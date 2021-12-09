unit SetOffTimeFormUnit;

{$INCLUDE Config.inc}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, TntForms, ExtCtrls, StdCtrls, sLabel, Buttons, TntButtons,
  sBitBtn, sSkinProvider, sSpeedButton, UnitKDCommon, UnitKDSerialPort,
  Menus, TntMenus, SpecialProcsUnit, SoundDialogs, TntXPMenu, sEdit,
  sSpinEdit, sRadioButton, GlobalTypes, License3, pROGRAMcONSTS, ProcsUnit,
  TntExtCtrls, sPanel, License;

type
  TSetOffTimeForm = class(TTntForm)
    sSkinProvider1: TsSkinProvider;
    sBitBtn1: TsBitBtn;
    Image2: TImage;
    sLabel1: TsLabel;
    KDSerialPort1: KDSerialPort;
    SetOffTimePopup: TTntPopupMenu;
    SetOffTimeMenuItem1: TTntMenuItem;
    SetOffTimeMenuItem2: TTntMenuItem;
    SettingsPanel: TsPanel;
    FromLabel: TsLabel;
    HourFromLabel: TsLabel;
    MinuteFromLabel: TsLabel;
    HourToLabel: TsLabel;
    ToLabel: TsLabel;
    MinuteToLabel: TsLabel;
    ColonToLabel: TsLabel;
    ColonFromLabel: TsLabel;
    NoTimeSpanCheck: TsRadioButton;
    DefineTimeSpanRadio: TsRadioButton;
    HourFromSpin: TsSpinEdit;
    MinuteFromSpin: TsSpinEdit;
    HourToSpin: TsSpinEdit;
    MinuteToSpin: TsSpinEdit;
    TntXPMenu1: TTntXPMenu;
    SetOffTimeBtn: TsSpeedButton;
    GetOffTimeBtn: TsSpeedButton;
    GetOffTimePopup: TTntPopupMenu;
    GetOffTimeMenuItem1: TTntMenuItem;
    GetOffTimeMenuItem2: TTntMenuItem;
    procedure SetOffTimeBtnClick(Sender: TObject);
    procedure SetOffTimeMenuItem1Click(Sender: TObject);
    procedure SetOffTimeMenuItem2Click(Sender: TObject);
    procedure TntFormDestroy(Sender: TObject);
    procedure GetOffTimeBtnClick(Sender: TObject);
    procedure GetOffTimeMenuItem1Click(Sender: TObject);
    procedure GetOffTimeMenuItem2Click(Sender: TObject);
    procedure NoTimeSpanCheckClick(Sender: TObject);
    procedure TntFormShow(Sender: TObject);
  private
    { Private declarations }
    procedure SetLEDDisplayOffTime(LEDDisplayNumber: Integer);
    procedure GetLEDDisplayOffTime(LEDDisplayNumber: Integer);

    procedure RefreshFormState;
    function ValidateTimes: Boolean;
  public
    { Public declarations }
  end;

var
  SetOffTimeForm: TSetOffTimeForm;

implementation

uses ProgrammerFormUnit, MainUnit, ProgressFormUnit;

{$R *.dfm}

procedure TSetOffTimeForm.SetOffTimeBtnClick(
  Sender: TObject);
begin
  if not ValidateTimes then
    Exit;
  //Show menu or run direct?
  if GlobalOptions.NumOfLEDDisplays = 1 then
    //Run direct
    SetOffTimeMenuItem1.Click
  else
    //Show menu
    SpecialProcs.PopupMenuAtControl(SetOffTimeBtn, SetOffTimePopup);
end;

procedure TSetOffTimeForm.SetOffTimeMenuItem1Click(
  Sender: TObject);
begin
  SetLEDDisplayOffTime(1);
end;

procedure TSetOffTimeForm.SetOffTimeMenuItem2Click(
  Sender: TObject);
begin
  SetLEDDisplayOffTime(2);
end;

procedure TSetOffTimeForm.TntFormDestroy(Sender: TObject);
begin
  try
    if KDSerialPort1.IsOpened then
      KDSerialPort1.Close;
  except
  end;
end;

procedure TSetOffTimeForm.SetLEDDisplayOffTime(LEDDisplayNumber: Integer);
var
  ControlData: TDataArray;
  OffTimeActive: Boolean;
  HourFrom, HourTo, MinuteFrom, MinuteTo: Byte;
  LEDDisplayConfiguration: TLEDDisplayConfiguration;
  i: Integer;
  OperationOK: Boolean;
begin
  OffTimeActive := DefineTimeSpanRadio.Checked;
  if OffTimeActive then
  begin
    HourFrom := HourFromSpin.Value;
    HourTo := HourToSpin.Value;
    MinuteFrom := MinuteFromSpin.Value;
    MinuteTo := MinuteToSpin.Value;
  end
  else
  begin
    HourFrom := 0;
    HourTo := 0;
    MinuteFrom := 0;
    MinuteTo := 0;
  end;

  //************************************
  if not License3.CheckLicenseStatusFull then
    Halt;
  //************************************

  //----------------------------------------------------
  //Check if it is portable memory connected to the port
  if not ProgrammerForm.GetConfiguration(LEDDisplayConfiguration, LEDDisplayNumber) then
    Exit;
  if LEDDisplayConfiguration.PortableMemory then  //If it is portable memory, don't do anything - just show message and return.
  begin
    WideShowMessageSoundTop(Dyn_Texts[117] {'This is LED Display portable memory connected to the port. You must connect the LED Display itself to the computer to complete this operation.'});
    Exit;
  end;
  //----------------------------------------------------

  //Now continue for setting off time
  if not MainForm.CommunicationWithLEDDisplayAllowed(True) then
    Exit;

  SetLength(ControlData, 5);

  Screen.Cursor := crHourGlass;

    /////////////////////////////////////////////////////////////////////////////
  if GlobalOptions.LEDDisplaySettings.Height > License._LED_DISPLAY_MAX_ROW_COUNT_ then
    Halt;
  /////////////////////////////////////////////////////////////////////////////

  Self.Enabled := False;
  ProgressForm.Progress.MinValue := 0;
  ProgressForm.Progress.MaxValue := 2;  //2 steps (2 steps for setting off time twice)
  ProgressForm.Progress.Progress := 0;
  ProgressForm.Caption := Dyn_Texts[138];  //'Setting LED Display Off Time'
  ProgressForm.Show;

  Application.ProcessMessages;

  try
    //generate data
    if OffTimeActive then
      ControlData[0] := $FF
    else
      ControlData[0] := $00;

    ControlData[1] := HourFrom;
    ControlData[2] := HourTo;
    ControlData[3] := MinuteFrom;
    ControlData[4] := MinuteTo;
    for i := 1 to NUMBER_OF_TIMES_TO_SET_OFF_TIME do
    begin
     OperationOK := ProgrammerForm.SendData($F4, ControlData, LEDDisplayNumber);  //Set Off Time Command Code = $F4

      if not OperationOK then
        Exit;

      ProgressForm.Progress.Progress := ProgressForm.Progress.Progress + 1;
      Application.ProcessMessages;

      Procs.SleepNoBlock(USART_TIMEOUT_2);
    end;
  finally
    Application.ProcessMessages;
    if ProgressForm.Progress.Progress = ProgressForm.Progress.MaxValue then  //If the progressbar is completely filled, wait some milliseconds for the user to see the filled progressbar
      Procs.SleepNoBlock(300);  //Allow the user to see that the progressbar is completely filled 100% (only when the progressbar is completely filled)

    Screen.Cursor := crDefault;
    SetLength(ControlData, 0);

    ProgressForm.Hide;
    Self.Enabled := True;

    Application.ProcessMessages;

    if OperationOK then
    begin
      MainForm.LastChangeDisplayTickCount := GetTickCount;
      WideShowMessageSoundTop(Dyn_Texts[18] {'Operation completed successfully.'});
      MainForm.BringToFront;  //Corrects GUI bugs
      Self.BringToFront;  //Corrects GUI bugs
    end;
  end;
end;

procedure TSetOffTimeForm.GetOffTimeBtnClick(Sender: TObject);
begin
  //Show menu or run direct?
  if GlobalOptions.NumOfLEDDisplays = 1 then
    //Run direct
    GetOffTimeMenuItem1.Click
  else
    //Show menu
    SpecialProcs.PopupMenuAtControl(GetOffTimeBtn, GetOffTimePopup);
end;

procedure TSetOffTimeForm.GetLEDDisplayOffTime(LEDDisplayNumber: Integer);
var
  OffTimeSettings: TOffTimeSettings;
begin
  if ProgrammerForm.GetOffTimeSettings(OffTimeSettings, LEDDisplayNumber) then
  begin
    DefineTimeSpanRadio.Checked := OffTimeSettings.OffTimeDefined;
    NoTimeSpanCheck.Checked := not OffTimeSettings.OffTimeDefined;
    if Assigned(NoTimeSpanCheck.OnClick) then
      NoTimeSpanCheck.OnClick(NoTimeSpanCheck);

    HourFromSpin.Value := OffTimeSettings.OffTimeHourFrom;
    MinuteFromSpin.Value := OffTimeSettings.OffTimeMinuteFrom;
    HourToSpin.Value := OffTimeSettings.OffTimeHourTo;
    MinuteToSpin.Value := OffTimeSettings.OffTimeMinuteTo;

    RefreshFormState;
  end;
end;

procedure TSetOffTimeForm.GetOffTimeMenuItem1Click(Sender: TObject);
begin
  GetLEDDisplayOffTime(1);
end;

procedure TSetOffTimeForm.GetOffTimeMenuItem2Click(Sender: TObject);
begin
  GetLEDDisplayOffTime(2);
end;

procedure TSetOffTimeForm.RefreshFormState;
begin
  HourFromSpin.Enabled := DefineTimeSpanRadio.Checked;
  MinuteFromSpin.Enabled := HourFromSpin.Enabled;
  HourToSpin.Enabled := HourFromSpin.Enabled;
  MinuteToSpin.Enabled := HourFromSpin.Enabled;
  
  FromLabel.Enabled := HourFromSpin.Enabled;
  MinuteFromLabel.Enabled := HourFromSpin.Enabled;
  HourFromLabel.Enabled := HourFromSpin.Enabled;
  ColonFromLabel.Enabled := HourFromSpin.Enabled;

  ToLabel.Enabled := HourFromSpin.Enabled;
  MinuteToLabel.Enabled := HourFromSpin.Enabled;
  HourToLabel.Enabled := HourFromSpin.Enabled;
  ColonToLabel.Enabled := HourFromSpin.Enabled;
end;

procedure TSetOffTimeForm.NoTimeSpanCheckClick(Sender: TObject);
begin
  RefreshFormState;
end;

procedure TSetOffTimeForm.TntFormShow(Sender: TObject);
begin
  RefreshFormState;
end;

function TSetOffTimeForm.ValidateTimes: Boolean;
begin
  Result := True;
  Exit;
  (*
  if DefineTimeSpanRadio.Checked then
  begin
    if Procs.CompareTimes(HourFromSpin.Value, MinuteFromSpin.Value, 0,
      HourToSpin.Value, MinuteToSpin.Value, 0) >= 0 then
    begin
      MessageDlgSoundTop(Dyn_Texts[141] {'The input time span is invalid. Start time must be before than the end time.'}, mtError, [mbOK], 0);
      Result := False;
    end;
  end;
  *)
end;

end.
