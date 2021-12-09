unit AlarmProgressFormUnit;

{$INCLUDE Config.inc}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, TntForms, StdCtrls, sLabel, sGauge, Buttons, TntButtons,
  sSpeedButton, sBitBtn, sSkinProvider, GlobalTypes, SoundDialogs,
  UnitKDCommon, UnitKDSerialPort, ProgramConsts, ProcsUnit, License,
  License3;

const
  //------------------------------------------------------
  //LED Display usart command codes for working for alarms
  GET_ALARM_DATA_COMMAND = $D8;  //usart_cmd_GetAlarmData
  SET_ALARM_DATA_COMMAND = $33;  //usart_cmd_SetAlarmData
  //------------------------------------------------------

type
  TAlarmProgressForm = class(TTntForm)
    AlarmProgress: TsGauge;
    sLabel1: TsLabel;
    sSkinProvider1: TsSkinProvider;
    KDSerialPort1: KDSerialPort;
    CancelOperationBtn: TsSpeedButton;
    procedure CancelOperationBtnClick(Sender: TObject);
    procedure KDSerialPort1ReceiveData(Sender: TObject; DataPtr: Pointer;
      DataSize: Integer; var DisplayHandle: HWND);
    procedure TntFormDestroy(Sender: TObject);
    procedure TntFormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    OperationCancelled: Boolean;

    ReceivedData: TDataArray;

    procedure GenerateAlarmData(Alarm: TLDCAlarm; var DataBytes: TDataArray);
    { Private declarations }
  public
    { Public declarations }
    function SetAlarmData(AlarmMonth: Integer; const Alarms: TLDCAlarms;
      LEDDisplayNumber: Integer; DontReadLEDDisplayAlarms: Boolean): Boolean;
    function ReadAlarms(AlarmMonth: Integer; var Alarms: TLDCAlarms;
      LEDDisplayNumber: Integer): Boolean;
  end;

var
  AlarmProgressForm: TAlarmProgressForm;

implementation

uses MainUnit, AlarmSettingsFormUnit, ProgrammerFormUnit, StdConvs;

{$R *.dfm}

{ TAlarmProgressForm }

function TAlarmProgressForm.SetAlarmData(AlarmMonth: Integer;
  const Alarms: TLDCAlarms; LEDDisplayNumber: Integer;
  DontReadLEDDisplayAlarms: Boolean): Boolean;
var
  i, j: Integer;
  ErrCode: Integer;
  wr: TWaitResult;
  S: String;
  rid: Integer;
  TransmissionOK: Boolean;
  TryCount: Integer;
  Command: 0..255;

  AllOK: Boolean;
  AvailableAlarmCount: Integer;
  ProgressPerAlarm: Integer;
  ReadAlarmsFromLEDDisplay: TLDCAlarms;
  NextAlarm: Integer;
  DataBytes: TDataArray;
  CRC32: LongWord;
  OperationStage: Integer;
  AlarmIndexes: array of Integer;
  FoundAlarmIndex: Boolean;
begin
  MainForm.CheckAlSerialPortObjectsToBeClosed;

  //////////////
  TRY
  //////////////

{$ifndef _ALARM_TYPE_12_MONTHS}
  AlarmMonth := 1;  //AlarmMonth is always 1 when the alarmsystem is not 12-month
{$endif}

if not License._ALARM_ACTIVE_ then
begin
  Result := True;
  Exit;
end;

  Result := False;

  AvailableAlarmCount := 0;
  for i := 0 to High(Alarms) do
    if AlarmSettingsForm.ValidAlarm(Alarms[i]) and (Alarms[i].Duration > 0) then
      Inc(AvailableAlarmCount);

  (*--> No need to check this because it is check in the AlarmSettingsForm
  if AvailableAlarmCount = 0 then
  begin
    WideShowMessageSoundTop(Dyn_Texts[???] {'No alarm is defined.'});
    Exit;
  end;
  *)

  Command := SET_ALARM_DATA_COMMAND;  //usart_cmd_SetAlarmData

  if not DontReadLEDDisplayAlarms then
  begin
    if not AlarmProgressForm.ReadAlarms(AlarmMonth, ReadAlarmsFromLEDDisplay, LEDDisplayNumber) then
      Exit;
  end;

  (*if AvailableAlarmCount > GlobalOptions.LEDDisplaySettings.AlarmCount then
  begin
    if WideMessageDlgSoundTop(Dyn_Texts[???] {'Number of alarms you have defined exceeds number of alarms that your LED Display supports. Are you sure you want to continue?'}, mtConfirmation, [mbYes, mbNo], 0) = mrNo then
    begin
      SetLength(ReadAlarmsFromLEDDisplay, 0);
      Exit;
    end;
  end;*)

  OperationStage := 0;

  //Prepare alarm array to send
  if DontReadLEDDisplayAlarms then
  begin
    SetLength(ReadAlarmsFromLEDDisplay, Length(Alarms));
    SetLength(AlarmIndexes, 0);  //Settings AlarmIndexes to have no elements makes it to not be used later - also any value less than 0 is ignored automatically in this program
    SetLength(AlarmIndexes, Length(Alarms));
    for i := 0 to High(Alarms) do
      ReadAlarmsFromLEDDisplay[i] := Alarms[i];
  end
  else
  begin
    //Save alarm indexes returned by the LED Display to be used later
    SetLength(AlarmIndexes, Length(ReadAlarmsFromLEDDisplay));
    for i := 0 to High(ReadAlarmsFromLEDDisplay) do
      AlarmIndexes[i] := ReadAlarmsFromLEDDisplay[i].AlarmIndexOnTheLEDDisplay;

    NextAlarm := 0;
		i := 0;
		while (NextAlarm <= High(ReadAlarmsFromLEDDisplay)) and (i <= High(Alarms)) do
		begin
  		if AlarmSettingsForm.ValidAlarm(Alarms[i]) and (Alarms[i].Duration > 0) then
	  	begin
		  	ReadAlarmsFromLEDDisplay[NextAlarm] := Alarms[i];
			  Inc(NextAlarm);
  		end;
	  	Inc(i);
		end;
		if NextAlarm <= High(ReadAlarmsFromLEDDisplay) then  //Clear other alarms
		begin
  		for j := NextAlarm to High(ReadAlarmsFromLEDDisplay) do
	  		ReadAlarmsFromLEDDisplay[j] := AlarmSettingsForm.ClearAlarm(ReadAlarmsFromLEDDisplay[j], AlarmMonth);
    end
  	else if i <= High(Alarms) then
	 	begin
		  for j := i to High(Alarms) do
	  	begin
		  	if AlarmSettingsForm.ValidAlarm(Alarms[j]) and (Alarms[j].Duration > 0) then
			  begin
          SetLength(ReadAlarmsFromLEDDisplay, Length(ReadAlarmsFromLEDDisplay) + 1);
			    ReadAlarmsFromLEDDisplay[High(ReadAlarmsFromLEDDisplay)] := Alarms[j];
			  end;
		  end;
    end;
  end;
  //Now prepare alarm indexes (alarm indexes must use indexes received from the LED Display and other numbers starting from 0)
  for i := 0 to High(ReadAlarmsFromLEDDisplay) do
  begin
    FoundAlarmIndex := False;
    for j := 0 to High(AlarmIndexes) do
      if AlarmIndexes[j] = i then
      begin
        FoundAlarmIndex := True;
        Break;
      end;
    if not FoundAlarmIndex then
    begin
      SetLength(AlarmIndexes, Length(AlarmIndexes) + 1);
      AlarmIndexes[High(AlarmIndexes)] := i;
    end;
  end;
  //Alarm array prepared for sending
  /////////////////////////////

  AlarmProgress.MinValue := 0;
  AlarmProgress.MaxValue := Length(ReadAlarmsFromLEDDisplay);
  AlarmProgress.Progress := 0;
  AlarmProgressForm.Show;

  ///////////////////////////////
  OperationCancelled := False;  //Put OperationCancelled intialization here to allow user to cancel the operation when we are waiting for the LED Display to be ready
  ///////////////////////////////

  //while not MainForm.CommunicationWithLEDDisplayAllowed(False) do
  //  Procs.SleepNoBlock(5);
  Procs.SleepNoBlock(USART_TIMEOUT_2);

  try

  SetPriorityClass(GetCurrentProcess, HIGH_PRIORITY_CLASS);

  SetLength(DataBytes, 0);

  //Open port

  ProgrammerForm.SetupSerialCommunication(KDSerialPort1, LEDDisplayNumber);

  ErrCode := KDSerialPort1.Open(0);
  if ErrCode <> 0 then
  begin
    WideMessageDlgSound(ProgrammerForm.PortErrMsg(ErrCode), mtError, [mbOK], 0);
    Close;
    Exit;
  end;

  ///////////////////////////////
  MainForm.OnDataExchangeStarted;
  ///////////////////////////////

  TryCount := 0;
  TransmissionOK := True;
  repeat
    if not TransmissionOK then
      Procs.SleepNoBlock(1000);
    SetLength(DataBytes, 3);
    DataBytes[0] := $ED;
    DataBytes[1] := $CB;
    DataBytes[2] := Command;
    KDSerialPort1.AddResponse(0, 5, '', False);
    KDSerialPort1.SendData(Pointer(DataBytes), Length(DataBytes));
    KDSerialPort1.WaitResponse(S, rid, USART_TIMEOUT_1, wr);
    TransmissionOK := (wr = wrMaxSizeReached) and (S[1] = #$ED) and (S[2] = #$CB) and (S[3] = Chr(Command));
    Inc(TryCount);
    ///////////////////////////////
    if OperationCancelled then
    begin
      MainForm.OnDataExchangeFinished;
      KDSerialPort1.Close;
      Exit;
    end;
    ///////////////////////////////
  until (TransmissionOK) or (TryCount = MAX_USART_TRY_COUNT);

  /////////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////
  //CHECK FIRMWARE VERSION
  if TransmissionOK then
  begin
    //Check Firmware version number
    if ( (S[4] = FirmwareVersion_Major) and (S[5] = FirmwareVersion_Minor) ) or
       ( (S[4] = '0') and (S[5] = '0') ) then  //0.0 means that it is the portable memory connected to the computer
    begin
      TryCount := 0;
      TransmissionOK := True;  //Prevent potential software bugs
      repeat
        if not TransmissionOK then
          Procs.SleepNoBlock(1000);
        SetLength(DataBytes, 2);
        DataBytes[0] := Byte(S[4]);
        DataBytes[1] := Byte(S[5]);
        KDSerialPort1.AddResponse(0, 1, '', False);
        KDSerialPort1.SendData(Pointer(DataBytes), Length(DataBytes));
        KDSerialPort1.WaitResponse(S, rid, USART_TIMEOUT_1, wr);
        TransmissionOK := (wr = wrMaxSizeReached) and (S[1] = Chr(Command));
        Inc(TryCount);
        ///////////////////////////////
        if OperationCancelled then
        begin
          MainForm.OnDataExchangeFinished;
          KDSerialPort1.Close;
          Exit;
        end;
        ///////////////////////////////
      until (TransmissionOK) or (TryCount = MAX_USART_TRY_COUNT);
    end
    else
    begin
      //Invalid or unsupported firmware version
      KDSerialPort1.Close;
      MainForm.OnDataExchangeFinished;
      WideMessageDlgSoundTop(Dyn_Texts[81] {'The firmware version of the target device does not match.'}, mtError, [mbOK], 0);
      Exit;
    end;

    if not TransmissionOK then
    begin
      KDSerialPort1.Close;
      MainForm.OnDataExchangeFinished;
      WideMessageDlgSound(Dyn_Texts[82] {'The LED Display did not respond correctly. Please try again.'}, mtError, [mbOK], 0);
      Exit;
    end;
  end;
  //CHECKING THE FIRMWARE VERSION DONE
  /////////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////

  if not TransmissionOK then
  begin
    KDSerialPort1.Close;
    MainForm.OnDataExchangeFinished;
    WideMessageDlgSound(Dyn_Texts[17] {'No LED display detected.'}, mtError, [mbOK], 0);
    Exit;
  end;

  //==================================================================================================================
  //============  HANDSHAKING WITH LED DISPLAY DONE HERE - NOW FROM THIS POINT, DO OUR WORK ABOUT ALARMS  ============
  //==================================================================================================================

  SetLength(DataBytes, 1);
  DataBytes[0] := Length(ReadAlarmsFromLEDDisplay);  //Set all alarms of the LED Display
  KDSerialPort1.SendData(Pointer(DataBytes), Length(DataBytes));  //Send number of alarms to send

  NextAlarm := 0;

  OperationStage := 1;

  repeat

    ///////////////////////////////
    if OperationCancelled then
    begin
      KDSerialPort1.Close;
      MainForm.OnDataExchangeFinished;
      Exit;
    end;
    ///////////////////////////////

    SetLength(DataBytes, 2);  //2 bytes for AlarmIndex and AlarmMonth

    //Set AlarmIndex
    //Check to prevent potential software bugs even if it is no need to check AlarmIndexes bounds because it is fully filled with necessary alarm index values and there is no need to use the value of NextAlarm
    if NextAlarm <= High(AlarmIndexes) then  //First use alarm indexes that are returned by the LED Display
    begin
      if AlarmIndexes[NextAlarm] >= 0 then  //but only if it is a valid AlarmIndex
        DataBytes[0] := AlarmIndexes[NextAlarm]
      else
        DataBytes[0] := NextAlarm;
    end
    else  //If number of alarms to set is greater than number of alarms that LED Display has sent, use next subsequent alarm index
      DataBytes[0] := NextAlarm;
    //Set AlarmMonth
    DataBytes[1] := AlarmMonth;//ReadAlarmsFromLEDDisplay[NextAlarm].Month;  //  --> If uc has a 1-month alarm system, passing any number as the month number is automatically stored as it was set in the first month, so no problem will occur  //1;  //AlarmMonth is always 1 in the LDC program

    GenerateAlarmData(ReadAlarmsFromLEDDisplay[NextAlarm], DataBytes);  //Append alarm data to the end of the DataBytes

    //Add CRC32 to the end of DataBytes
    CRC32 := MainForm.CalculateCRC32(DataBytes);
    SetLength(DataBytes, Length(DataBytes) + 4);
    DataBytes[High(DataBytes) - 3] := CRC32;  //lowest bytes
    DataBytes[High(DataBytes) - 2] := CRC32 shr 8;
    DataBytes[High(DataBytes) - 1] := CRC32 shr 16;
    DataBytes[High(DataBytes) - 0] := CRC32 shr 24;  //highest byte

    KDSerialPort1.AddResponse(0, 1, '', False);
    KDSerialPort1.SendData(Pointer(DataBytes), Length(DataBytes));
    KDSerialPort1.WaitResponse(S, rid, 4000, wr);

    if wr = wrMaxSizeReached then
    begin
      if Length(S) = 1 then
      begin
        if S[1] = WRITE_SUCCESSFUL then
          Inc(NextAlarm);
      end
      else
      begin
        KDSerialPort1.Close;
        MainForm.OnDataExchangeFinished;
        ShowMessageSoundTop(Dyn_Texts[88] {'Invalid data received from the LED Display. Please try again later.'});
        Break;
      end;
    end
    else
    begin
      KDSerialPort1.Close;
      MainForm.OnDataExchangeFinished;
      WideShowMessageSoundTop(Dyn_Texts[105] {'No response from the LED Display connected to the port. Please try again later.'});
      Break;
    end;

    AlarmProgress.Progress := NextAlarm;

  until NextAlarm = Length(ReadAlarmsFromLEDDisplay);

  Procs.SleepNoBlock(100);  //Allow the user to see that the progressbar is filled completely 100%

  if NextAlarm = Length(ReadAlarmsFromLEDDisplay) then
  begin
    MainForm.LastChangeDisplayTickCount := GetTickCount;
    KDSerialPort1.Close;
    MainForm.OnDataExchangeFinished;
    AlarmProgressForm.Hide;  //Hide the form before displaying 'Operation Completed.' message
    WideMessageDlgSoundTop(Dyn_Texts[18] {'Operation completed.'}, mtInformation, [mbOK], 0);
    Result := True;
    OperationCancelled := False;  //When program reaches here, nothing is available to cancel! So, prevent any incorrect messages to be shown to the user.
  end
  else
  begin
    KDSerialPort1.Close;
    MainForm.OnDataExchangeFinished;
    WideMessageDlgSoundTop(Dyn_Texts[58] {'Alarms could not be set correctly.'}, mtInformation, [mbOK], 0);
  end;

  finally

  ///////////////////////////////
  MainForm.OnDataExchangeFinished;
  ///////////////////////////////

  SetLength(ReadAlarmsFromLEDDisplay, 0);
  SetLength(AlarmIndexes, 0);
  SetLength(DataBytes, 0);

  try
    if KDSerialPort1.IsOpened then
      KDSerialPort1.Close;
  except
  end;

  if OperationCancelled then
  begin
    if OperationStage = 1 then
    begin
      //WideMessageDlgSoundTop(Dyn_Texts[57] {'Alarm settings cancelled. Alarms could not be set correctly.'}, mtInformation, [mbOK], 0)
      WideShowMessageSoundTop(Dyn_Texts[57] {'Alarm settings cancelled. Alarms could not be set correctly.'});
    end
    else
    begin
      WideShowMessageSoundTop(Dyn_Texts[103] {'Operation cancelled.'});
    end;
  end;

  AlarmProgressForm.Hide;

  SetPriorityClass(GetCurrentProcess, NORMAL_PRIORITY_CLASS);

  end;

  //////////////
  EXCEPT

    WideMessageDlgSoundTop(Dyn_Texts[120] {'Error in operation. Please try again. If problem persists, restart the application.'}, mtError, [mbOK], 0);
    Result := False;

  END;
  //////////////
end;

procedure TAlarmProgressForm.GenerateAlarmData(Alarm: TLDCAlarm;
  var DataBytes: TDataArray);
var
  i: Integer;
  w: Word;
  Offset: Integer;
begin
  //This function appends alarm data to the end of DataBytes
  Offset := Length(DataBytes);
  SetLength(DataBytes, Length(DataBytes) + BYTES_PER_ALARM);

	with Alarm do
	begin
    if Duration > 0 then
    begin
  		w := Duration;
	  	DataBytes[Offset + 0] := Lo(w);  //Duration low byte
		  DataBytes[Offset + 1] := Hi(w);  //Duration high byte

			if EveryDay then
			begin
				DataBytes[Offset + 2] := 1;  //EveryDay
				DataBytes[Offset + 3] := 0;  //Day
				DataBytes[Offset + 4] := Month;  //Month  --> Month always must be set correctly 
				DataBytes[Offset + 5] := 0;  //Year low byte
				DataBytes[Offset + 6] := 0;  //Year high byte
			end
			else
			begin
				DataBytes[Offset + 2] := 0;  //EveryDay
				DataBytes[Offset + 3] := Day;  //Day
				DataBytes[Offset + 4] := Month;  //Month
				w := Year;
				DataBytes[Offset + 5] := Lo(w);  //Year low byte
				DataBytes[Offset + 6] := Hi(w);  //Year high byte
			end;

			DataBytes[Offset + 7] := Hour;  //Hour
			DataBytes[Offset + 8] := Minute;  //Minute
			DataBytes[Offset + 9] := Second;  //Second
    end
    else
    begin
      //If the alarm is disabled, it is better to set all bytes to zero not only the value of Duration, but it is better to set the Month field correctly
      for i := 0 to BYTES_PER_ALARM - 1 do
        DataBytes[Offset + i] := 0;
      DataBytes[Offset +4] := Alarm.Month;  //It is better to always set the Month field correctly
    end;
	end;

  //----------------------------------------
  //----------------------------------------
  //Reserved bytes - set to 0 for compatibility
  DataBytes[Offset + 10] := 0;  //Reserved byte - set to 0 for compatibility
  DataBytes[Offset + 11] := 0;  //Reserved byte - set to 0 for compatibility
  //----------------------------------------
  //----------------------------------------
end;

procedure TAlarmProgressForm.CancelOperationBtnClick(Sender: TObject);
begin
  OperationCancelled := True;
end;

function TAlarmProgressForm.ReadAlarms(AlarmMonth: Integer;
  var Alarms: TLDCAlarms; LEDDisplayNumber: Integer): Boolean;
const
  //MAX_TOTAL_TRY_COUNT = 3;

  ALARM_READ_TIMEOUT = 4000;  //in milliseconds  --  4000 milliseconds to ensure that we will catch the data sent from the LED Display even when it is busy

  ALARM_DATA_OFFSET = 1;
var
  DataBytes: array of Byte;
  i: Integer;
  ErrCode: Integer;
  wr: TWaitResult;
  S: String;
  rid: Integer;
  TransmissionOK: Boolean;
  TryCount: Integer;
  //TotalTryCount: Integer;

  //=================================
  StartTickCount: Cardinal;
  Command: 0..255;  //!!! New type for test only!
  UIntTemp: Word;
  CRC32: LongWord;
  AlarmCount: Byte;
  OperationStage: Integer;
  //=================================
  CalculatedCRC32: LongWord;
begin
  MainForm.CheckAlSerialPortObjectsToBeClosed;
  
  //////////////
  TRY
  //////////////

{$ifndef _ALARM_TYPE_12_MONTHS}
  AlarmMonth := 1;  //AlarmMonth is always 1 when the alarmsystem is not 12-month
{$endif}

if not License3._ALARM_ACTIVE_ then
begin
  Result := True;
  Exit;
end;

  //IMPORTANT NOTES:
  //  1. The LED Display only sends alarms that are set into the LED Display not the alarms that are disabled, so
  //     the number of alarms received may not be the number of alarms that can be set on the LED Display. But when
  //     no alarm is set on the LED Display, at leat one alarm is sent by the LED Display to ensure communication
  //     with the LED Display and also ensure that the LED Display has no alarms set.

  Result := False;

  SetLength(Alarms, 0);

  if not MainForm.CommunicationWithLEDDisplayAllowed(True) then
    Exit;

  Command := GET_ALARM_DATA_COMMAND;

  OperationStage := 0;

  AlarmProgress.Progress := 0;
  AlarmProgressForm.Show;

  try

  SetPriorityClass(GetCurrentProcess, HIGH_PRIORITY_CLASS);

  //TotalTryCount := MAX_TOTAL_TRY_COUNT;

  SetLength(DataBytes, 0);

  //Open port

  ProgrammerForm.SetupSerialCommunication(KDSerialPort1, LEDDisplayNumber);

  ErrCode := KDSerialPort1.Open(0);
  if ErrCode <> 0 then
  begin
    WideMessageDlgSound(ProgrammerForm.PortErrMsg(ErrCode), mtError, [mbOK], 0);
    Close;
    Exit;
  end;

  ///////////////////////////////
  MainForm.OnDataExchangeStarted;
  ///////////////////////////////

  ///////////////////////////////
  OperationCancelled := False;
  ///////////////////////////////

  TryCount := 0;
  TransmissionOK := True;
  //repeat  -->  Only try 1 time
    if not TransmissionOK then
      Procs.SleepNoBlock(1000);
    SetLength(DataBytes, 3);
    DataBytes[0] := $ED;
    DataBytes[1] := $CB;
    DataBytes[2] := Command;
    KDSerialPort1.AddResponse(0, 5, '', False);
    KDSerialPort1.SendData(Pointer(DataBytes), Length(DataBytes));
    KDSerialPort1.WaitResponse(S, rid, USART_TIMEOUT_1, wr);
    TransmissionOK := (wr = wrMaxSizeReached) and (S[1] = #$ED) and (S[2] = #$CB) and (S[3] = Chr(Command));
    Inc(TryCount);
    ///////////////////////////////
    if OperationCancelled then
    begin
      MainForm.OnDataExchangeFinished;
      KDSerialPort1.Close;
      Exit;
    end;
    ///////////////////////////////
  //until (TransmissionOK) or (TryCount = MAX_USART_TRY_COUNT);

  /////////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////
  //CHECK FIRMWARE VERSION
  if TransmissionOK then
  begin
    //Check Firmware version number
    if ( (S[4] = FirmwareVersion_Major) and (S[5] = FirmwareVersion_Minor) ) or
       ( (S[4] = '0') and (S[5] = '0') ) then  //0.0 means that it is the portable memory connected to the computer
    begin
      TryCount := 0;
      TransmissionOK := True;  //Prevent potential software bugs
      //repeat  -->  Only try 1 time
        if not TransmissionOK then
          Procs.SleepNoBlock(1000);
        SetLength(DataBytes, 2);
        DataBytes[0] := Byte(S[4]);
        DataBytes[1] := Byte(S[5]);
        KDSerialPort1.AddResponse(0, 1, '', False);
        KDSerialPort1.SendData(Pointer(DataBytes), Length(DataBytes));
        KDSerialPort1.WaitResponse(S, rid, USART_TIMEOUT_1, wr);
        TransmissionOK := (wr = wrMaxSizeReached) and (S[1] = Chr(Command));
        Inc(TryCount);
        ///////////////////////////////
        if OperationCancelled then
        begin
          MainForm.OnDataExchangeFinished;
          KDSerialPort1.Close;
          Exit;
        end;
        ///////////////////////////////
      //until (TransmissionOK) or (TryCount = MAX_USART_TRY_COUNT);
    end
    else
    begin
      //Invalid or unsupported firmware version
      SetLength(DataBytes, 0);
      KDSerialPort1.Close;
      MainForm.OnDataExchangeFinished;
      WideMessageDlgSoundTop(Dyn_Texts[81] {'The firmware version of the target device does not match.'}, mtError, [mbOK], 0);
      Exit;
    end;

    if not TransmissionOK then
    begin
      SetLength(DataBytes, 0);
      KDSerialPort1.Close;
      MainForm.OnDataExchangeFinished;
      WideMessageDlgSound(Dyn_Texts[82] {'The LED Display did not respond correctly. Please try again.'}, mtError, [mbOK], 0);
      Exit;
    end;
  end;
  //CHECKING THE FIRMWARE VERSION DONE
  /////////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////

  if not TransmissionOK then
  begin
    SetLength(DataBytes, 0);
    KDSerialPort1.Close;
    MainForm.OnDataExchangeFinished;
    WideMessageDlgSound(Dyn_Texts[17] {'No LED display detected.'}, mtError, [mbOK], 0);
    Exit;
  end;

  //==================================================================================================================
  //============  HANDSHAKING WITH LED DISPLAY DONE HERE - NOW FROM THIS POINT, DO OUR WORK ABOUT ALARMS  ============
  //==================================================================================================================

  SetLength(DataBytes, 1);  //1 byte AlarmIndex, 1 byte AlarmMonth

  DataBytes[0] := AlarmMonth;

  SetLength(ReceivedData, 0);
  KDSerialPort1.MonitorReceiveData := True;

  KDSerialPort1.SendData(Pointer(DataBytes), Length(DataBytes));

  Procs.SleepNoBlock(100);  //Wait to get number of alarms to receive

  if Length(ReceivedData) > 1 then
  begin
    KDSerialPort1.Close;
    MainForm.OnDataExchangeFinished;
    WideShowMessageSoundTop(Dyn_Texts[88] {'Invalid data received from the LED Display. Please try again later.'});
    Exit;
  end
  else if Length(ReceivedData) = 0 then
  begin
    KDSerialPort1.Close;
    MainForm.OnDataExchangeFinished;
    WideShowMessageSoundTop(Dyn_Texts[105] {'No response from the LED Display connected to the port. Please try again later.'});
    Exit;
  end;

  AlarmCount := ReceivedData[0];

  SetLength(ReceivedData, 0);

  AlarmProgress.MinValue := 0;
  AlarmProgress.MaxValue := AlarmCount;

  OperationStage := 0;  //OperatinStage is always 0 in this function because no critical operation is going to be done in this procedure (we want to only read some data (i.e. alarm settings) from the LED Display)

  i := 0;
  while i < AlarmCount do
  begin

    ///////////////////////////////
    if OperationCancelled then
    begin
      KDSerialPort1.Close;
      MainForm.OnDataExchangeFinished;
      Exit;
    end;
    ///////////////////////////////

    AlarmProgress.Progress := i;

    StartTickCount := GetTickCount;

    while (Length(ReceivedData) < (BYTES_PER_ALARM + 1 + 4)) and  //1 byte for AlarmIndex, 4 bytes for crc32
          ((GetTickCount - StartTickCount) < ALARM_READ_TIMEOUT) do
    begin
      Application.ProcessMessages;
      Sleep(1);  //--> If sleep greater than 1 millisecond, use Procs.SleepNoBlock instead
    end;
    KDSerialPort1.MonitorReceiveData := False;

    if Length(ReceivedData) > 0 then
    begin
      if Length(ReceivedData) <> (BYTES_PER_ALARM + 1 + 4) then
      begin
        KDSerialPort1.Close;
        MainForm.OnDataExchangeFinished;
        WideShowMessageSoundTop(Dyn_Texts[88] {'Invalid data received from the LED Display. Please try again later.'});
        SetLength(Alarms, 0);
        Exit;
      end;

      //Check CRC32 - last four bytes are for CRC32
      CRC32 := ReceivedData[High(ReceivedData)];
      CRC32 := (CRC32 shl 8) or ReceivedData[High(ReceivedData) - 1];
      CRC32 := (CRC32 shl 8) or ReceivedData[High(ReceivedData) - 2];
      CRC32 := (CRC32 shl 8) or ReceivedData[High(ReceivedData) - 3];
      SetLength(ReceivedData, Length(ReceivedData) - 4);
      CalculatedCRC32 := MainForm.CalculateCRC32(ReceivedData);
      if CalculatedCRC32 = CRC32 then
      //if MainForm.CalculateCRC32(ReceivedData) = CRC32 then  --> Causes incorrect comparison in some cases!!!!
      begin
        Inc(i);
        DataBytes[0] := Byte(WRITE_SUCCESSFUL);
        SetLength(Alarms, Length(Alarms) + 1);
        with Alarms[High(Alarms)] do
        begin
          //First byte of the ReceivedData is the AlarmIndex as stored on the LED Display
          AlarmIndexOnTheLEDDisplay := ReceivedData[0];

          //Other bytes are for AlarmData
          UIntTemp := ReceivedData[ALARM_DATA_OFFSET + 1];  //Duration high byte
          UIntTemp := (UIntTemp shl 8) or ReceivedData[ALARM_DATA_OFFSET + 0];
          Duration := UIntTemp;

          if ReceivedData[ALARM_DATA_OFFSET + 2] = 1 then  //EveryDay
            EveryDay := True
          else
            EveryDay := False;

          Day := ReceivedData[ALARM_DATA_OFFSET + 3];  //Day
          Month := ReceivedData[ALARM_DATA_OFFSET + 4];  //Month

          UIntTemp := ReceivedData[ALARM_DATA_OFFSET + 6];  //Year high byte
          UIntTemp := (UIntTemp shl 8) or ReceivedData[ALARM_DATA_OFFSET + 5];  //Year low byte
          Year := UIntTemp;

          Hour := ReceivedData[ALARM_DATA_OFFSET + 7];  //Hour
          Minute := ReceivedData[ALARM_DATA_OFFSET + 8];  //Minute
          Second := ReceivedData[ALARM_DATA_OFFSET + 9];  //Second
        end;
      end
      else
      begin
        DataBytes[0] := Byte(WRITE_FAIL);
      end;

      SetLength(ReceivedData, 0);
      KDSerialPort1.MonitorReceiveData := True;
      KDSerialPort1.SendData(Pointer(DataBytes), Length(DataBytes));
    end
    else
    begin
      KDSerialPort1.Close;
      MainForm.OnDataExchangeFinished;
      WideShowMessageSoundTop(Dyn_Texts[105] {'No response from the LED Display connected to the port. Please try again later.'});
      Exit;
    end;
  end;

  MainForm.OnDataExchangeFinished;

  AlarmProgress.Progress := AlarmProgress.MaxValue;
  Procs.SleepNoBlock(100);  //Allow the user to see that the progressbar is filled completely 100%

  OperationCancelled := False;  //When program reaches here, nothing is available to cancel! So, prevent any incorrect messages to be shown to the user.

  Result := True;

  finally

  ///////////////////////////////
  MainForm.OnDataExchangeFinished;  //Prevent potential software bugs
  ///////////////////////////////

  AlarmProgressForm.Hide;

  SetLength(DataBytes, 0);  //Prevent potential software bugs

  try
    if KDSerialPort1.IsOpened then  //Prevent potential software bugs
      KDSerialPort1.Close;
  except
  end;

  KDSerialPort1.MonitorReceiveData := False;

  if OperationCancelled then
  begin
    if OperationStage = 0 then
    begin
      WideShowMessageSoundTop(Dyn_Texts[103] {'Operation cancelled.'});
    end;
  end;

  SetPriorityClass(GetCurrentProcess, NORMAL_PRIORITY_CLASS);

  end;

  //////////////
  EXCEPT

    WideMessageDlgSoundTop(Dyn_Texts[120] {'Error in operation. Please try again. If problem persists, restart the application.'}, mtError, [mbOK], 0);
    Result := False;

  END;
  //////////////
end;

procedure TAlarmProgressForm.KDSerialPort1ReceiveData(Sender: TObject;
  DataPtr: Pointer; DataSize: Integer; var DisplayHandle: HWND);
type
  TReceivedDataByteArray = array[0..32767] of Byte;
var
  DataArray: ^TReceivedDataByteArray;
  Offset, i: Integer;
begin
  Offset := Length(ReceivedData);
  SetLength(ReceivedData, Length(ReceivedData) + DataSize);
  DataArray := DataPtr;
  for i := 0 to DataSize - 1 do
    ReceivedData[Offset + i] := DataArray[i];
end;

procedure TAlarmProgressForm.TntFormDestroy(Sender: TObject);
begin
  SetLength(ReceivedData, 0);
  
  try
    if KDSerialPort1.IsOpened then
      KDSerialPort1.Close;
  except
  end;
end;

procedure TAlarmProgressForm.TntFormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (ssAlt in Shift) and (Key = VK_F4) then  //Prevent the user to close the window using Alt+F4
    Key := 0;
end;

end.
