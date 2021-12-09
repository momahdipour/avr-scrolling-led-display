unit ProgrammerFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, TntForms, sSkinProvider, sGauge, StdCtrls, sLabel, UnitKDCommon,
  UnitKDSerialPort, ExtCtrls, GlobalTypes, sTntDialogs, SoundDialogs,
  ProgramConsts, ProcsUnit, Buttons, TntButtons, sSpeedButton, License;

type
  TOffTimeSettings = record
    OffTimeDefined: Boolean;
    OffTimeHourFrom, OffTimeHourTo: Byte;
    OffTimeMinuteFrom, OffTimeMinuteTo: Byte;
  end;
  
  TProgrammerForm = class(TTntForm)
    sSkinProvider1: TsSkinProvider;
    SendProgress: TsGauge;
    KDSerialPort1: KDSerialPort;
    sLabel1: TsLabel;
    StartTimer: TTimer;
    CancelBtn: TsSpeedButton;
    procedure TntFormShow(Sender: TObject);
    procedure StartTimerTimer(Sender: TObject);
    procedure CancelBtnClick(Sender: TObject);
    procedure KDSerialPort1ReceiveData(Sender: TObject; DataPtr: Pointer;
      DataSize: Integer; var DisplayHandle: HWND);
    procedure TntFormDestroy(Sender: TObject);
  private
    { Private declarations }
    OperationCancelled: Boolean;

    ReceivedData: TDataArray;

    function ParseLEDDisplayConfigurationData(
      ConfigurationData: TDataArray): TLEDDisplayConfiguration;
    function ParseLEDDisplayOffTimeSettingsData(
      OffTimeSettingsData: TDataArray): TOffTimeSettings;
  public
    { Public declarations }
    LEDDisplayNumber: Integer;  //Only used when the ShowModal method is used

    procedure SetupSerialCommunication(AKDSerialPort: KDSerialPort;
      LEDDisplayNumber: Integer);
    function SendData(Command: Byte; const Data: TDataArray; LEDDisplayNumber: Integer): Boolean;
    function SendDataFast(Command: Byte; const Data: TDataArray;
      LEDDisplayNumber: Integer): Boolean;
    function PortErrMsg(ErrCode: Integer): WideString;

    function GetConfiguration(var LEDDisplayConfigurtion: TLEDDisplayConfiguration;
      LEDDisplayNumber: Integer): Boolean;
    function GetOffTimeSettings(var OffTimeSettings: TOffTimeSettings;
      LEDDisplayNumber: Integer): Boolean;
  end;

var
  ProgrammerForm: TProgrammerForm;

implementation

uses MainUnit;

{$R *.dfm}

procedure TProgrammerForm.SetupSerialCommunication(AKDSerialPort: KDSerialPort;
  LEDDisplayNumber: Integer);
begin
  with AKDSerialPort.ManualSettings do
  begin
    //Select COM port
    Port := MainForm.GetCOMPort(LEDDisplayNumber);

    BaudRate := br38400;
    DataBits := db8Bits;
    StopBits := sb1Bits;
    HardwareFlow := hfNone;
    SoftwareFlow := sfNone;
    Parity := ptNone;
  end;
end;

procedure TProgrammerForm.TntFormShow(Sender: TObject);
begin
  SendProgress.Progress := SendProgress.MinValue; 
  StartTimer.Enabled := True;
end;

procedure TProgrammerForm.StartTimerTimer(Sender: TObject);
var
  Successful: Boolean;
//  ErrCode: Integer;
begin
  StartTimer.Enabled := False;

  try
    Successful := SendDataFast($11, MainForm.Data, LEDDisplayNumber);  //Set Data Command Code is $11
  except
    WideMessageDlgSoundTop(Dyn_Texts[28] {Error in port operation.}, mtError, [mbOK], 0);
    Successful := False;
  end;

  if Successful then
    MainForm.LastChangeDisplayTickCount := GetTickCount;

  Application.ProcessMessages;
  Hide;
  Application.ProcessMessages;

  if Successful then
  begin
    MainForm.PlaySound(siLEDDisplayDataChangeFinished);
    WideShowMessageSoundTop(Dyn_Texts[18] {'Operation completed.'});
    //WideMessageDlgSoundTop(Dyn_Texts[18] {'Operation completed.'}, mtInformation, [mbOK], 0);
  end;

  Application.ProcessMessages;
  Close;
  //SendProgress.Progress := SendProgress.MinValue;
end;

function TProgrammerForm.SendData(Command: Byte; const Data: TDataArray;
  LEDDisplayNumber: Integer): Boolean;
const
  BUFFER_OVERFLOW_AVOIDANCE_DATA_SIZE = 150;  //The number of bytes that the program will wait for a while to continue again (in bytes) - to avoid buffer overflow error in the target device and aloow it to process received data
var
  DataBytes: array of Byte;
  i: Integer;
  ErrCode: Integer;
  wr: TWaitResult;
  S: String;
  rid: Integer;
  TransmissionOK: Boolean;
  TryCount: Integer;
  BufferOverflowSizeCounter: Integer;
begin
  Result := False;

  //////////////
  TRY
  //////////////

  try

  SetPriorityClass(GetCurrentProcess, HIGH_PRIORITY_CLASS);

  SendProgress.Progress := 0;
  SendProgress.MinValue := 0;
  SendProgress.MaxValue := Length(Data);
  SetLength(DataBytes, 0);

  //Open port

  SetupSerialCommunication(KDSerialPort1, LEDDisplayNumber);

  ErrCode := KDSerialPort1.Open(0);
  if ErrCode <> 0 then
  begin
    WideMessageDlgSoundTop(PortErrMsg(ErrCode), mtError, [mbOK], 0);
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
      until (TransmissionOK) or (TryCount = MAX_USART_TRY_COUNT);
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

  SetLength(DataBytes, 1);
  i := 0;
  BufferOverflowSizeCounter := 0;
  KDSerialPort1.AddResponse(0, 1, '', False);
  while {TransmissionOK and }(i < Length(Data)) do
  begin
    //Prevent buffer overflow error in the target device
    if BufferOverflowSizeCounter >= BUFFER_OVERFLOW_AVOIDANCE_DATA_SIZE then
    begin
      Procs.SleepNoBlock(150);  //Allow the target device to process received data and continue again
      BufferOverflowSizeCounter := 0;
    end;

    DataBytes[0] := Data[i];
    Procs.SleepNoBlock(DATA_WRITE_DELAY);
    KDSerialPort1.SendData(Pointer(DataBytes), Length(DataBytes));
    Inc(BufferOverflowSizeCounter);

    //KDSerialPort1.WaitResponse(S, rid, 6000, wr);
    //if wr <> wrMaxSizeReached then
    //  Break;

    {
    KDSerialPort1.WaitResponse(S, rid, 1000, wr);
    TransmissionOK := wr = wrMaxSizeReached;
    if TransmissionOK and (Length(S) > 1) then
      TransmissionOK := Byte(S[1]) = DataBytes[0];
    }

    Inc(i);
    SendProgress.Progress := i;
    Application.ProcessMessages;
  end;

//  if not TransmissionOK then
//    WideShowMessage('Transmition error.' + Chr(13) + 'Num of bytes sent = ' + IntToStr(i));

  SetLength(DataBytes, 0);
  KDSerialPort1.Close;
  //WideShowMessage('Operation completed successfully.');

  Result := True;

  finally

  ///////////////////////////////
  MainForm.OnDataExchangeFinished;
  ///////////////////////////////

  SetLength(DataBytes, 0);  //Prevent potential software bugs

  SetPriorityClass(GetCurrentProcess, NORMAL_PRIORITY_CLASS);

  if KDSerialPort1.IsOpened then  //Prevent potential software bugs
    KDSerialPort1.Close;

  end;

  //////////////
  EXCEPT

    WideMessageDlgSoundTop(Dyn_Texts[120] {'Error in operation. Please try again. If problem persists, restart the application.'}, mtError, [mbOK], 0);
    Result := False;

  END;
  //////////////
end;

function TProgrammerForm.SendDataFast(Command: Byte; const Data: TDataArray;
  LEDDisplayNumber: Integer): Boolean;
const
  BUFFER_OVERFLOW_AVOIDANCE_DATA_SIZE = 150;  //The number of bytes that the program will wait for a while to continue again (in bytes) - to avoid buffer overflow error in the target device and aloow it to process received data
var
  DataBytes: array of Byte;
  i: Integer;
  ErrCode: Integer;
  wr: TWaitResult;
  S: String;
  rid: Integer;
  TransmissionOK: Boolean;
  TryCount: Integer;
  //BufferOverflowSizeCounter: Integer;  -->  NOT NEED IN SendDataFast
  //=================================
  PageSize: Integer;
  BufferIndex, DataSentCount: Integer;
  CRC32: LongWord;
  j: Integer;
  OperationStage: Integer;
  //=================================
begin
  Result := False;

  MainForm.CheckAlSerialPortObjectsToBeClosed;

  //////////////
  TRY
  //////////////

  OperationStage := 0;

  try

  SetPriorityClass(GetCurrentProcess, HIGH_PRIORITY_CLASS);

  SendProgress.Progress := 0;
  SendProgress.MinValue := 0;
  SendProgress.MaxValue := Length(Data);
  SetLength(DataBytes, 0);

  //Open port

  SetupSerialCommunication(KDSerialPort1, LEDDisplayNumber);

  ErrCode := KDSerialPort1.Open(0);
  if ErrCode <> 0 then
  begin
    WideMessageDlgSound(PortErrMsg(ErrCode), mtError, [mbOK], 0);
    Close;
    Exit;
  end;

  ///////////////////////////////
  MainForm.OnDataExchangeStarted;
  ///////////////////////////////

  ///////////////////////////////
  OperationCancelled := False;
  ///////////////////////////////

  /////////////////////////////////////////////////////////////////////////////
  if GlobalOptions.LEDDisplaySettings.Height > License._LED_DISPLAY_MAX_ROW_COUNT_ then
    Halt;
  /////////////////////////////////////////////////////////////////////////////

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
      SetLength(DataBytes, 0);
      KDSerialPort1.Close;
      MainForm.OnDataExchangeFinished;
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
          SetLength(DataBytes, 0);
          KDSerialPort1.Close;
          MainForm.OnDataExchangeFinished;
          Exit;
        end;
        ///////////////////////////////
      until (TransmissionOK) or (TryCount = MAX_USART_TRY_COUNT);
    end
    else
    begin
      //Invalid or unsupported firmware version
      SetLength(DataBytes, 0);
      KDSerialPort1.Close;
      MainForm.OnDataExchangeFinished;
      OperationCancelled := False;  //Don't display two error messages to the user, one for this andone for operation cancelled
      WideMessageDlgSoundTop(Dyn_Texts[81] {'The firmware version of the target device does not match.'}, mtError, [mbOK], 0);
      Exit;
    end;

    if not TransmissionOK then
    begin
      SetLength(DataBytes, 0);
      KDSerialPort1.Close;
      MainForm.OnDataExchangeFinished;
      OperationCancelled := False;  //Don't display two error messages to the user, one for this and one for operation cancelled
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
    OperationCancelled := False;  //Don't display two error messages to the user, one for this and one for operation cancelled
    WideMessageDlgSound(Dyn_Texts[17] {'No LED display detected.'}, mtError, [mbOK], 0);
    Exit;
  end;

  //============================================================================
  //============================================================================
  //Get page size
  KDSerialPort1.AddResponse(0, 5, '', False);
  KDSerialPort1.WaitResponse(S, rid, 4000, wr);

  TransmissionOK := True;
  for i := 1 to Length(S) do
    TransmissionOK := TransmissionOK and (S[i] = S[1]);

  if (wr <> wrMaxSizeReached) or not TransmissionOK then
  begin
    SetLength(DataBytes, 0);
    KDSerialPort1.Close;
    MainForm.OnDataExchangeFinished;
    OperationCancelled := False;  //Don't display two error messages to the user, one for this and one for operation cancelled
    WideMessageDlgSound(Dyn_Texts[82] {'The LED Display did not respond correctly. Please try again.'}, mtError, [mbOK], 0);
    Exit;
  end;

  PageSize := Integer(S[1]);

  i := 0;
  //BufferOverflowSizeCounter := 0;  -->  NOT NEEDED IN SendDataFast
  OperationStage := 1;
  while (i < Length(Data)) do
  begin
    ///////////////////////////////
    if OperationCancelled then
    begin
      SetLength(DataBytes, 0);
      KDSerialPort1.Close;
      MainForm.OnDataExchangeFinished;
      Exit;
    end;
    ///////////////////////////////
    SetLength(DataBytes, 1);
    DataBytes[0] := PageSize;
    KDSerialPort1.SendData(Pointer(DataBytes), Length(DataBytes));
    //Procs.SleepNoBlock(500);  --> No need to this at all

    //Prepare buffer to send 
    SetLength(DataBytes, PageSize);
    BufferIndex := 0;
    DataSentCount := 0;
    while (i < Length(Data)) and (BufferIndex < Length(DataBytes)) do
    begin
      DataBytes[BufferIndex] := Data[i];
      Inc(DataSentCount);
      Inc(i);
      Inc(BufferIndex);
    end;
    if BufferIndex < Length(DataBytes) then
    begin
      while BufferIndex < Length(DataBytes) do
      begin
        DataBytes[BufferIndex] := 0;
        Inc(BufferIndex);
      end;
    end;

    CRC32 := MainForm.CalculateCRC32(DataBytes);

    SetLength(DataBytes, Length(DataBytes) + 4);  //4 bytes for crc32

    for j := High(DataBytes) downto 4 do
      DataBytes[j] := DataBytes[j - 4];
    //Add CRC32
    DataBytes[0] := Byte(CRC32);  //low byte first
    DataBytes[1] := Byte(CRC32 shr 8);
    DataBytes[2] := Byte(CRC32 shr 16);
    DataBytes[3] := Byte(CRC32 shr 24);

    KDSerialPort1.AddResponse(0, 1, '', False);
    KDSerialPort1.SendData(Pointer(DataBytes), Length(DataBytes));
    KDSerialPort1.WaitResponse(S, rid, 6000, wr);

    if (wr = wrTimeOut) or (Length(S) = 0) then
    begin
      SetLength(DataBytes, 0);
      KDSerialPort1.Close;
      MainForm.OnDataExchangeFinished;
      OperationCancelled := False;  //Don't display two error messages to the user, one for this and one for operation cancelled
      WideMessageDlgSound(Dyn_Texts[82] {'The LED Display did not respond correctly. Please try again.'}, mtError, [mbOK], 0);
      Exit;
    end;
    if S[1] <> WRITE_SUCCESSFUL then  //Write failure?
      i  := i - DataSentCount;
    SendProgress.Progress := i;
    Application.ProcessMessages;
  end;
  Procs.SleepNoBlock(200);  //Allow the user to see that the progressbar is filled completely!
  //============================================================================
  //============================================================================

  (*
  SetLength(DataBytes, 1);
  i := 0;
  BufferOverflowSizeCounter := 0;
  KDSerialPort1.AddResponse(0, 1, '', False);
  while {TransmissionOK and }(i < Length(Data)) do
  begin
    //Prevent buffer overflow error in the target device
    if BufferOverflowSizeCounter >= BUFFER_OVERFLOW_AVOIDANCE_DATA_SIZE then
    begin
      Procs.SleepNoBlock(150);  //Allow the target device to process received data and continue again
      BufferOverflowSizeCounter := 0;
    end;

    DataBytes[0] := Data[i];
    Procs.SleepNoBlock(DATA_WRITE_DELAY);
    KDSerialPort1.SendData(Pointer(DataBytes), Length(DataBytes));
    Inc(BufferOverflowSizeCounter);

    //KDSerialPort1.WaitResponse(S, rid, 6000, wr);
    //if wr <> wrMaxSizeReached then
    //  Break;

    {
    KDSerialPort1.WaitResponse(S, rid, 1000, wr);
    TransmissionOK := wr = wrMaxSizeReached;
    if TransmissionOK and (Length(S) > 1) then
      TransmissionOK := Byte(S[1]) = DataBytes[0];
    }

    Inc(i);
    SendProgress.Progress := i;
    Application.ProcessMessages;
  end;
  *)

//  if not TransmissionOK then
//    WideShowMessage('Transmition error.' + Chr(13) + 'Num of bytes sent = ' + IntToStr(i));

  SetLength(DataBytes, 0);
  KDSerialPort1.Close;
  //WideShowMessage('Operation completed successfully.');

  Result := True;
  OperationCancelled := False;  //When program reaches here, nothing is available to cancel! So, prevent any incorrect messages to be shown to the user.

  finally

  ///////////////////////////////
  MainForm.OnDataExchangeFinished;
  ///////////////////////////////

  SetLength(DataBytes, 0);  //Prevent potential software bugs

  if OperationCancelled then
  begin
    if OperationStage = 1 then
    begin
      //WideMessageDlgSoundTop(Dyn_Texts[102] {'Operation cancelled by the user. The LED Display data may be incorrect.'}, mtInformation, [mbOK], 0);
      WideShowMessageSoundTop(Dyn_Texts[102] {'Operation cancelled by the user. The LED Display data may be incorrect.'});
    end
    else
    begin
      WideShowMessageSoundTop(Dyn_Texts[103] {'Operation cancelled.'});
    end;
  end;

  SetPriorityClass(GetCurrentProcess, NORMAL_PRIORITY_CLASS);

  try
    if KDSerialPort1.IsOpened then  //Prevent potential software bugs
      KDSerialPort1.Close;
  except
  end;

  end;

  //////////////
  EXCEPT

    WideMessageDlgSoundTop(Dyn_Texts[120] {'Error in operation. Please try again. If problem persists, restart the application.'}, mtError, [mbOK], 0);
    Result := False;

    if KDSerialPort1.IsOpened then
      KDSerialPort1.Close;
    
  END;
  //////////////
end;

function TProgrammerForm.PortErrMsg(ErrCode: Integer): WideString;
begin
  Result := '';
  if ErrCode = 0 then
    Exit;
  case ErrCode of
    KSPERROR_CONNECTION_CLOSED:         Result := Dyn_Texts[19];  //'The port is automatically closed.';
    KSPERROR_SETUP_FAILED:              Result := Dyn_Texts[20];  //'Could not setup the serial port device.';
    KSPERROR_FLUSH_FAILED:              Result := Dyn_Texts[21];  //'Could not flush the serial port buffer.';
    KSPERROR_INVALID_PORT_NUMBER:       Result := Dyn_Texts[22];  //'Invalid serial port number specified or the port is in use by another application.';
    KSPERROR_ABRUPTLY_CLOSED:           Result := Dyn_Texts[23];  //'Serial port device was abruptly closed.';
    KSPERROR_COMM_LINE_ERROR:           Result := Dyn_Texts[24];  //'A Communication error (frame, overrun or parity error) occurred.';
    KSPERROR_SEND_FAILED:               Result := Dyn_Texts[25];  //'Unable to send data completely to the serial port device.';
    KSPERROR_RECEIVE_FAILED:            Result := Dyn_Texts[26];  //'Unable to read data from the serial port device.';
    KSPERROR_PORT_NOT_OPENED:           Result := Dyn_Texts[27];  //'Could not open the serial port.';
    KSPERROR_PORT_ALREADY_OPENED:       Result := Dyn_Texts[28];  //'Error in port operation.';
    KSPERROR_CANNOT_CHANGE_BUFFER_SIZE: Result := Dyn_Texts[29];  //'Error in port operation. Buffer size cannot be changed.';
    KSPERROR_WAIT_NO_RESP:              Result := Dyn_Texts[30];  //'No response for the port is set or enabled.';
    KSPERROR_WAIT_IN_PROGRESS:          Result := Dyn_Texts[31];  //'A wait for response operation is already in progress.';
    KSPERROR_WAIT_ABORTED:              Result := Dyn_Texts[32];  //'Wait for response operation aborted.';
    else
      Result := Dyn_Texts[28];  //'Error in port operation.';
  end;
end;

procedure TProgrammerForm.CancelBtnClick(Sender: TObject);
begin
  OperationCancelled := True;
end;

function TProgrammerForm.GetConfiguration(var LEDDisplayConfigurtion: TLEDDisplayConfiguration;
  LEDDisplayNumber: Integer): Boolean;
const
  CONFIGURATION_DATA_SIZE = 31;  //This value must be equal to the same value in the uc program
  MAX_CRC32_ERR_TRY_COUNT = 10;
var
  DataBytes: array of Byte;
  i: Integer;
  ErrCode: Integer;
  wr: TWaitResult;
  S: String;
  rid: Integer;
  TransmissionOK: Boolean;
  TryCount: Integer;
  //BufferOverflowSizeCounter: Integer;  -->  NOT NEED IN SendDataFast
  //=================================
  PageSize: Integer;
  BufferIndex, DataSentCount: Integer;
  CRC32: LongWord;
  j: Integer;
  StartTickCount: Cardinal;
  Command: Byte;
  //=================================
  CalculatedCRC32: LongWord;
begin
  Result := False;

  MainForm.CheckAlSerialPortObjectsToBeClosed;

  Command := $B2;  //usart_cmd_GetConfiguration

  //////////////
  TRY
  //////////////

  try

  SetPriorityClass(GetCurrentProcess, HIGH_PRIORITY_CLASS);

  //SendProgress.Progress := 0;
  //SendProgress.MinValue := 0;
  //SendProgress.MaxValue := Length(Data);
  SetLength(DataBytes, 0);

  //Open port

  SetupSerialCommunication(KDSerialPort1, LEDDisplayNumber);

  ErrCode := KDSerialPort1.Open(0);
  if ErrCode <> 0 then
  begin
    WideMessageDlgSound(PortErrMsg(ErrCode), mtError, [mbOK], 0);
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
  //repeat
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
      SetLength(DataBytes, 0);
      KDSerialPort1.Close;
      MainForm.OnDataExchangeFinished;
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
      //repeat
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
          SetLength(DataBytes, 0);
          KDSerialPort1.Close;
          MainForm.OnDataExchangeFinished;
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
  //=========  HANDSHAKING WITH LED DISPLAY DONE HERE - NOW FROM THIS POINT, DO OUR WORK ABOUT CONFIGURATION  ========
  //==================================================================================================================

  TransmissionOK := False;
  TryCount := 0;
  while not TransmissionOK and (TryCount < MAX_CRC32_ERR_TRY_COUNT) do
  begin
    Inc(TryCount);

    SetLength(DataBytes, 1);
    DataBytes[0] := $FF;
    SetLength(ReceivedData, 0);
    KDSerialPort1.MonitorReceiveData := True;
    KDSerialPort1.SendData(Pointer(DataBytes), Length(DataBytes));

    StartTickCount := GetTickCount;
    while ((GetTickCount - StartTickCount) < 1500) and (Length(ReceivedData) < (CONFIGURATION_DATA_SIZE + 4)) do  //4 bytes for CRC32
    begin
      Sleep(1);
      Application.ProcessMessages;
    end;

    KDSerialPort1.MonitorReceiveData := False;

    if Length(ReceivedData) > 0 then
    begin
      if Length(ReceivedData) <> (CONFIGURATION_DATA_SIZE + 4) then
      begin
        KDSerialPort1.Close;
        MainForm.OnDataExchangeFinished;
        WideShowMessageSoundTop(Dyn_Texts[88] {'Invalid data received from the LED Display. Please try again later.'});
        Exit;
      end;

      //Check CRC32 - last four bytes are for CRC32
      CRC32 := ReceivedData[High(ReceivedData)];
      CRC32 := (CRC32 shl 8) or ReceivedData[High(ReceivedData) - 1];
      CRC32 := (CRC32 shl 8) or ReceivedData[High(ReceivedData) - 2];
      CRC32 := (CRC32 shl 8) or ReceivedData[High(ReceivedData) - 3];
      SetLength(ReceivedData, Length(ReceivedData) - 4);
      SetLength(DataBytes, 1);  //Prevent potential software bugs
      CalculatedCRC32 := MainForm.CalculateCRC32(ReceivedData);
      //ShowMessage(IntToHex(CRC32, 8) + ',' + IntToHex(CalculatedCRC32, 8));  --> DEBUG
      if CalculatedCRC32 = CRC32 then
      //if MainForm.CalculateCRC32(ReceivedData) = CRC32 then  --> This way causes comparison error and cannot compare two values correctly in some cases
      begin
        DataBytes[0] := Byte(WRITE_SUCCESSFUL);
        TransmissionOK := True;
      end
      else
        DataBytes[0] := Byte(WRITE_FAIL);
      KDSerialPort1.SendData(Pointer(DataBytes), Length(DataBytes));
      if TransmissionOK then
        LEDDisplayConfigurtion := ParseLEDDisplayConfigurationData(ReceivedData);
    end
    else
    begin
      KDSerialPort1.Close;
      MainForm.OnDataExchangeFinished;
      WideShowMessageSoundTop(Dyn_Texts[105] {'No response from the LED Display connected to the port. Please try again later.'});
      Exit;
    end;
  end;

  SetLength(DataBytes, 0);
  try
    KDSerialPort1.Close;
  except
  end;

  if TransmissionOK then
    Result := True
  else
  begin
    MainForm.OnDataExchangeFinished;
    WideMessageDlgSound(Dyn_Texts[82] {'The LED Display did not respond correctly. Please try again.'}, mtError, [mbOK], 0);
    Exit;
  end;

  finally

  ///////////////////////////////
  MainForm.OnDataExchangeFinished;
  ///////////////////////////////

  SetLength(DataBytes, 0);  //Prevent potential software bugs

  try
    if KDSerialPort1.IsOpened then  //Prevent potential software bugs
      KDSerialPort1.Close;
  except
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

procedure TProgrammerForm.KDSerialPort1ReceiveData(Sender: TObject;
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

function TProgrammerForm.ParseLEDDisplayConfigurationData(
  ConfigurationData: TDataArray): TLEDDisplayConfiguration;
type
  TTemperatureVarRec = record
    case u: Integer of
      0: (TemperatureWord: Word;);
      1: (TemperatureInt: Smallint;);
  end;

var
  b: Byte;
  TempVar: TTemperatureVarRec;
begin
  with Result do
  begin
    FirmwareVersionMajorNumberChar := Chr(ConfigurationData[0]);
    FirmwareVersionMinorNumberChar := Chr(ConfigurationData[1]);

    EEPROMICCount := ConfigurationData[2];
    EEPROMICSize := ConfigurationData[4];  //high byte
    EEPROMICSize := (EEPROMICSize shl 8) or ConfigurationData[3];  //low byte

    ClearOldMemoryData := ConfigurationData[5] = $FF;  //$FF means active, $00 means inactive (= Don't clear)

    MaxRowCount := ConfigurationData[6];
    MaxColCount := ConfigurationData[7];
    RowCount := ConfigurationData[8];
    ColCount := ConfigurationData[9];

    RefreshRateOCR0_VALUE := ConfigurationData[10];

    ColumnsNOTInRefresh := ConfigurationData[11] = $FF;  //$FF means NOT is active
    RowsNOTInRefresh := ConfigurationData[12] = $FF;  //$FF means NOT is active

    TrialLimit := ConfigurationData[14];  //high byte
    TrialLimit := (TrialLimit shl 8) or ConfigurationData[13];  //low byte

    TrialTimesLeft := ConfigurationData[16];  //high byte
    TrialTimesLeft := (TrialTimesLeft shl 8) or ConfigurationData[15];  //low byte

    //Get individual bytes and convert them to signed integer
    TempVar.TemperatureWord := ConfigurationData[18];  //high byte
    TempVar.TemperatureWord := (TempVar.TemperatureWord shl 8) or ConfigurationData[17];  //low byte
    TemperatureOffset := TempVar.TemperatureInt;

    OVERALL_SPEED_SETTING := ConfigurationData[19];

    MaxAlarmCountPerMonth := ConfigurationData[20];
    if ConfigurationData[21] = 0 then
      AlarmSystem := as1MonthAlarmSystem
    else if ConfigurationData[21] = 1 then
      AlarmSystem := as12MonthAlarmSystem
    else  //Prevent potential software bugs
      AlarmSystem := as1MonthAlarmSystem;

    SCROLL_STEP_ADJUST := ConfigurationData[22];

    LED_DISPLAY_MAX_ROW_COUNT := ConfigurationData[23];
    LED_DISPLAY_MAX_COL_COUNT := ConfigurationData[24];

    DEFAULT_ALARM_CHEK_COUNTER := ConfigurationData[25];

    MAX_EEPROM_IC_PAGE_SIZE := ConfigurationData[26];

    EEPROM_WRITE_DELAY := ConfigurationData[27];

    MAX_CONTENT_SETTINGS_SIZE := ConfigurationData[28];

    b := ConfigurationData[29];  //Flags
    //Process flags
    TimeActive            := (b and ($01 shl 0)) <> $00;
    DateActive            := (b and ($01 shl 1)) <> $00;
    ScrollingTextActive   := (b and ($01 shl 2)) <> $00;
    AnimationActive       := (b and ($01 shl 3)) <> $00;
    TemperatureActive     := (b and ($01 shl 4)) <> $00;
    TextAnimationsActive  := (b and ($01 shl 5)) <> $00;
    PageEffectsActive     := (b and ($01 shl 6)) <> $00;
    StageLayoutActive     := (b and ($01 shl 7)) <> $00;
    //Done

    b := ConfigurationData[30];  //Flags
    //Process flags
    TimeSpanActive             := (b and ($01 shl 0)) <> $00;
    AlarmActive                := (b and ($01 shl 1)) <> $00;
    _COLOR_DISPLAY_METHOD_1_   := (b and ($01 shl 2)) <> $00;
    _COLOR_DISPLAY_METHOD_2_   := (b and ($01 shl 3)) <> $00;
    _ROWS_24_                  := (b and ($01 shl 4)) <> $00;
    _ROWS_32_                  := (b and ($01 shl 5)) <> $00;
    TrialLimitActive           := (b and ($01 shl 6)) <> $00;
    PortableMemory             := (b and ($01 shl 7)) <> $00;
    //Done
  end;
end;

procedure TProgrammerForm.TntFormDestroy(Sender: TObject);
begin
  try
    if KDSerialPort1.IsOpened then
      KDSerialPort1.Close;
  except
  end;
end;

function TProgrammerForm.GetOffTimeSettings(
  var OffTimeSettings: TOffTimeSettings;
  LEDDisplayNumber: Integer): Boolean;
const
  OFF_TIME_SETTINGS_DATA_SIZE = 5;  //This value must be equal to the same value in the uc program
  MAX_CRC32_ERR_TRY_COUNT = 10;
var
  DataBytes: array of Byte;
  i: Integer;
  ErrCode: Integer;
  wr: TWaitResult;
  S: String;
  rid: Integer;
  TransmissionOK: Boolean;
  TryCount: Integer;
  //BufferOverflowSizeCounter: Integer;  -->  NOT NEED IN SendDataFast
  //=================================
  PageSize: Integer;
  BufferIndex, DataSentCount: Integer;
  CRC32: LongWord;
  j: Integer;
  StartTickCount: Cardinal;
  Command: Byte;
  //=================================
  CalculatedCRC32: LongWord;
begin
  Result := False;

  MainForm.CheckAlSerialPortObjectsToBeClosed;

  Command := $F8;  //usart_cmd_Get_Off_Time

  //////////////
  TRY
  //////////////

  try

  SetPriorityClass(GetCurrentProcess, HIGH_PRIORITY_CLASS);

  //SendProgress.Progress := 0;
  //SendProgress.MinValue := 0;
  //SendProgress.MaxValue := Length(Data);
  SetLength(DataBytes, 0);

  //Open port

  SetupSerialCommunication(KDSerialPort1, LEDDisplayNumber);

  ErrCode := KDSerialPort1.Open(0);
  if ErrCode <> 0 then
  begin
    WideMessageDlgSound(PortErrMsg(ErrCode), mtError, [mbOK], 0);
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
  //repeat
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
      SetLength(DataBytes, 0);
      KDSerialPort1.Close;
      MainForm.OnDataExchangeFinished;
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
      //repeat
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
          SetLength(DataBytes, 0);
          KDSerialPort1.Close;
          MainForm.OnDataExchangeFinished;
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
  //=========  HANDSHAKING WITH LED DISPLAY DONE HERE - NOW FROM THIS POINT, DO OUR WORK ABOUT CONFIGURATION  ========
  //==================================================================================================================

  TransmissionOK := False;
  TryCount := 0;
  while not TransmissionOK and (TryCount < MAX_CRC32_ERR_TRY_COUNT) do
  begin
    Inc(TryCount);

    SetLength(DataBytes, 1);
    DataBytes[0] := $FF;
    SetLength(ReceivedData, 0);
    KDSerialPort1.MonitorReceiveData := True;
    KDSerialPort1.SendData(Pointer(DataBytes), Length(DataBytes));

    StartTickCount := GetTickCount;
    while ((GetTickCount - StartTickCount) < 1500) and (Length(ReceivedData) < (OFF_TIME_SETTINGS_DATA_SIZE + 4)) do  //4 bytes for CRC32
    begin
      Sleep(1);
      Application.ProcessMessages;
    end;

    KDSerialPort1.MonitorReceiveData := False;

    if Length(ReceivedData) > 0 then
    begin
      if Length(ReceivedData) <> (OFF_TIME_SETTINGS_DATA_SIZE + 4) then
      begin
        KDSerialPort1.Close;
        MainForm.OnDataExchangeFinished;
        WideShowMessageSoundTop(Dyn_Texts[88] {'Invalid data received from the LED Display. Please try again later.'});
        Exit;
      end;

      //Check CRC32 - last four bytes are for CRC32
      CRC32 := ReceivedData[High(ReceivedData)];
      CRC32 := (CRC32 shl 8) or ReceivedData[High(ReceivedData) - 1];
      CRC32 := (CRC32 shl 8) or ReceivedData[High(ReceivedData) - 2];
      CRC32 := (CRC32 shl 8) or ReceivedData[High(ReceivedData) - 3];
      SetLength(ReceivedData, Length(ReceivedData) - 4);
      SetLength(DataBytes, 1);  //Prevent potential software bugs
      CalculatedCRC32 := MainForm.CalculateCRC32(ReceivedData);
      //ShowMessage(IntToHex(CRC32, 8) + ',' + IntToHex(CalculatedCRC32, 8));  --> DEBUG
      if CalculatedCRC32 = CRC32 then
      //if MainForm.CalculateCRC32(ReceivedData) = CRC32 then  --> This way causes comparison error and cannot compare two values correctly in some cases
      begin
        DataBytes[0] := Byte(WRITE_SUCCESSFUL);
        TransmissionOK := True;
      end
      else
        DataBytes[0] := Byte(WRITE_FAIL);
      KDSerialPort1.SendData(Pointer(DataBytes), Length(DataBytes));
      if TransmissionOK then
        OffTimeSettings := ParseLEDDisplayOffTimeSettingsData(ReceivedData);
    end
    else
    begin
      KDSerialPort1.Close;
      MainForm.OnDataExchangeFinished;
      WideShowMessageSoundTop(Dyn_Texts[105] {'No response from the LED Display connected to the port. Please try again later.'});
      Exit;
    end;
  end;

  SetLength(DataBytes, 0);
  try
    KDSerialPort1.Close;
  except
  end;

  if TransmissionOK then
    Result := True
  else
  begin
    MainForm.OnDataExchangeFinished;
    WideMessageDlgSound(Dyn_Texts[82] {'The LED Display did not respond correctly. Please try again.'}, mtError, [mbOK], 0);
    Exit;
  end;

  finally

  ///////////////////////////////
  MainForm.OnDataExchangeFinished;
  ///////////////////////////////

  SetLength(DataBytes, 0);  //Prevent potential software bugs

  try
    if KDSerialPort1.IsOpened then  //Prevent potential software bugs
      KDSerialPort1.Close;
  except
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

function TProgrammerForm.ParseLEDDisplayOffTimeSettingsData(
  OffTimeSettingsData: TDataArray): TOffTimeSettings;
begin
  Result.OffTimeDefined := OffTimeSettingsData[0] = $FF;
  Result.OffTimeHourFrom := OffTimeSettingsData[1];
  Result.OffTimeHourTo := OffTimeSettingsData[2];
  Result.OffTimeMinuteFrom := OffTimeSettingsData[3];
  Result.OffTimeMinuteTo := OffTimeSettingsData[4];
end;

end.
