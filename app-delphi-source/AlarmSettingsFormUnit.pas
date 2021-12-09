unit AlarmSettingsFormUnit;

{$INCLUDE Config.inc}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, TntForms, StdCtrls, sLabel, TntStdCtrls, sGroupBox,
  sSkinProvider, sEdit, sSpinEdit, sCheckBox, Buttons, TntButtons, sBitBtn,
  GlobalTypes, ProgrammerFormUnit, SoundDialogs, Menus, TntMenus,
  SpecialProcsUnit, ProcsUnit, TntXPMenu, sTntDialogs, sComboBox,
  AlarmProgressFormUnit, TntSysUtils, TntDialogs, ExtCtrls, ProgramConsts,
  sRadioButton, License2, License3;

const
  ALARM_COUNT = MAX_LED_DISPLAY_ALARM_COUNT;

type
  TAlarmSettingsForm = class(TTntForm)
    sSkinProvider1: TsSkinProvider;
    ScrollBox1: TScrollBox;
    RefAlarmGroup: TsGroupBox;
    AlarmDateGroup: TsGroupBox;
    sLabel4: TsLabel;
    sLabel5: TsLabel;
    sLabel6: TsLabel;
    c1: TsCheckBox;
    y1: TsSpinEdit;
    d1: TsSpinEdit;
    AlarmTimeGroup: TsGroupBox;
    sLabel1: TsLabel;
    sLabel2: TsLabel;
    sLabel3: TsLabel;
    s1: TsSpinEdit;
    min1: TsSpinEdit;
    h1: TsSpinEdit;
    AlarmDurationGroup: TsGroupBox;
    sLabel7: TsLabel;
    t1: TsSpinEdit;
    SetAlarmsBtn: TsBitBtn;
    CancelBtn: TsBitBtn;
    SetAlarmDataPopup: TTntPopupMenu;
    SetAlarmsDataMenuItem1: TTntMenuItem;
    SetAlarmsDataMenuItem2: TTntMenuItem;
    TntXPMenu1: TTntXPMenu;
    sLabel57: TsLabel;
    NumOfAlarmsSpin: TsSpinEdit;
    QuickSetGroupBox: TsGroupBox;
    QuickSetForOneMonthGroup: TsGroupBox;
    ReadAlarmsFromFileGroup: TsGroupBox;
    sLabel58: TsLabel;
    SolarMonthLabel: TsLabel;
    FromDaySpin: TsSpinEdit;
    SolarMonthCombo: TsComboBox;
    SpeedSetAlarmsForMonthBtn: TsBitBtn;
    SelectAlarmFileBtn: TsBitBtn;
    OpenAlarmFileDialog: TTntOpenDialog;
    SaveAlarmDataToFileBtn: TsBitBtn;
    SaveAlarmDialog: TTntSaveDialog;
    sLabel9: TsLabel;
    ToDaySpin: TsSpinEdit;
    m1: TsComboBox;
    SetAllAlarmsTimeGroup: TsGroupBox;
    SpeedSetAlarmsTimeBtn: TsBitBtn;
    sLabel10: TsLabel;
    SpeedSecondSpin: TsSpinEdit;
    SpeedMinuteSpin: TsSpinEdit;
    sLabel11: TsLabel;
    sLabel12: TsLabel;
    SpeedHourSpin: TsSpinEdit;
    ClearAllAlarmsBtn: TsBitBtn;
    ClearAlarmDataPopup: TTntPopupMenu;
    ClearAlarmsDataMenuItem1: TTntMenuItem;
    ClearAlarmsDataMenuItem2: TTntMenuItem;
    ClockDotsLabel2: TsLabel;
    ClockDotsLabel1: TsLabel;
    HighGUITimer: TTimer;
    GetAlarmBtn: TsBitBtn;
    GetAlarmsPopup: TTntPopupMenu;
    GetAlarmMenuItem1: TTntMenuItem;
    GetAlarmMenuItem2: TTntMenuItem;
    t2: TsSpinEdit;
    sLabel15: TsLabel;
    t5: TsSpinEdit;
    t4: TsSpinEdit;
    t3: TsSpinEdit;
    sLabel17: TsLabel;
    sLabel18: TsLabel;
    sLabel19: TsLabel;
    r2: TsRadioButton;
    r3: TsRadioButton;
    sLabel14: TsLabel;
    SolarYearSpin: TsSpinEdit;
    r1: TsRadioButton;
    AlarmMonthCombo: TsComboBox;
    AlarmMonthLabel: TsLabel;
    AlarmMonthImage: TImage;
    SetAllAlarmsDurationGroup: TsGroupBox;
    sLabel22: TsLabel;
    SpeedSetAlarmsDurationBtn: TsBitBtn;
    SpeedDurationSpin: TsSpinEdit;
    sLabel8: TsLabel;
    sLabel13: TsLabel;
    sLabel16: TsLabel;
    procedure SetAlarmsBtnClick(Sender: TObject);
    procedure SetAlarmsDataMenuItem1Click(Sender: TObject);
    procedure SetAlarmsDataMenuItem2Click(Sender: TObject);
    procedure TntFormShow(Sender: TObject);
    procedure TntFormCreate(Sender: TObject);
    procedure SelectAlarmFileBtnClick(Sender: TObject);
    procedure TntFormDestroy(Sender: TObject);
    procedure NumOfAlarmsSpinChange(Sender: TObject);
    procedure SpeedSetAlarmsForMonthBtnClick(Sender: TObject);
    procedure SpeedSetAlarmsTimeBtnClick(Sender: TObject);
    procedure ClearAlarmsDataMenuItem2Click(Sender: TObject);
    procedure ClearAlarmsDataMenuItem1Click(Sender: TObject);
    procedure ClearAllAlarmsBtnClick(Sender: TObject);
    procedure SaveAlarmDataToFileBtnClick(Sender: TObject);
    procedure SaveAlarmDialogCanClose(Sender: TObject;
      var CanClose: Boolean);
    procedure CancelBtnClick(Sender: TObject);
    procedure HighGUITimerTimer(Sender: TObject);
    procedure TntFormClose(Sender: TObject; var Action: TCloseAction);
    procedure GetAlarmBtnClick(Sender: TObject);
    procedure GetAlarmMenuItem1Click(Sender: TObject);
    procedure GetAlarmMenuItem2Click(Sender: TObject);
    procedure AlarmMonthComboChange(Sender: TObject);
    procedure SpeedSetAlarmsDurationBtnClick(Sender: TObject);
  private
    { Private declarations }
    HighGUIItems: THighGUIItems;

    AlarmControls: array of TsGroupBox;
    Alarms: TLDCAlarms;

    FirstShow: Boolean;

    function CollectAlaramsInfo(ClearAlarms: Boolean): Boolean;

    procedure LoadAlarmDefaults(AlarmIndex: Integer);

    procedure HighGUIInitialize;

    procedure GetLEDDisplayAlarms(LEDDisplayNumber: Integer);

    procedure DurationSpinChange(Sender: TObject);
    procedure DurationSpinMinChange(Sender: TObject);
    procedure DurationSpinHChange(Sender: TObject);
    procedure DurationSpinMChange(Sender: TObject);
    procedure DurationSpinSChange(Sender: TObject);
    procedure DurationRadioClick(Sender: TObject);

    procedure SetDurationSpinsValue(T: TDateTime; Num: Integer);

    procedure SetAlarmDataToAlarmControls(const Alarm: TLDCAlarm;
      AlarmNumber: Integer; SetDate, SetTime, SetDuration: Boolean);

    procedure RefreshButtonsCaption;
    procedure PrepareFormLayout;
  public
    { Public declarations }
    procedure PrepareAlarmControls(NewCount: Integer);
    procedure ShowAlarms(AlarmCount: Integer);

    function ClearAlarm(const Alarm: TLDCAlarm;
      AlarmMonth: Integer): TLDCAlarm;
    
    function ValidAlarm(const Alarm: TLDCAlarm; ForceMonthCheck: Boolean = True): Boolean;

    function SaveAlarmDataToFile(const FName: WideString): Boolean;
    function LoadAlarmsFromFile(const FName: WideString): Boolean;
    procedure UpdateAlarmControls;
    function ClearLEDDisplayAlarms(LEDDisplayNumber: Integer): Boolean;
  end;

var
  AlarmSettingsForm: TAlarmSettingsForm;

implementation

uses DateUtils, MainUnit, Math, StrUtils;

{$R *.dfm}

function TAlarmSettingsForm.CollectAlaramsInfo(ClearAlarms: Boolean): Boolean;

  function CheckAlarmInfo(AlarmNo: Integer; c: TsCheckBox;
    d, y, s, min, h, t: TsSpinEdit; m: TsComboBox): Boolean;
  var
    dt1, dt2: TDateTime;
    InvalidAlarm: Boolean;
  begin
    Result := True;
    if t.Value > 0 then
    begin
      Result := False;
      InvalidAlarm := False;

      //dt1 := EncodeTime(h.Value, min.Value, s.Value, 0);
      //if (h.Value = 23) and (min.Value = 59) and (s.Value >= 58) then
      //  InvalidAlarm := True;

      //dt2 := EncodeTime(23, 59, 58, 0);
      //InvalidAlarm := InvalidAlarm or (SecondsBetween(dt1, dt2) < t.Value);

      if InvalidAlarm then
      begin
        WideShowMessageSound(WideFormat(Dyn_Texts[51] {'The alarm settings is invalid for alarm number %s.'}, [IntToStr(AlarmNo + 1)]));
        Exit;
      end;

      SetLength(Alarms, Length(Alarms) + 1);
      with Alarms[High(Alarms)] do
      begin
        EveryDay := c.Checked;

        Day := d.Value;
        Month := m.ItemIndex + 1;
        Year := y.Value;

        Hour := h.Value;
        Minute := min.Value;
        Second := s.Value;

        Duration := t.Value;
      end;
      Result := True;
    end;
  end;

var
  i, k: Integer;
begin
  Result := False;

  SetLength(Alarms, 0);

  if ClearAlarms then
  begin
    for i := 0 to High(AlarmControls) do
    begin
      SetLength(Alarms, Length(Alarms) + 1);
      if GlobalOptions.LEDDisplaySettings.AlarmSystem = as12MonthAlarmSystem then
        Alarms[i] := ClearAlarm(Alarms[i], AlarmMonthCombo.ItemIndex + 1)
      else
        Alarms[i] := ClearAlarm(Alarms[i], 1);
    end;
    Result := True;
    Exit;
  end;

  //Only get duration from the seconds spin edits.
  for i := 0 to NumOfAlarmsSpin.Value - 1 do
  begin
    if not CheckAlarmInfo(i, FindComponent('EveryDayCheck' + IntToStr(i)) as TsCheckBox, FindComponent('DaySpin' + IntToStr(i)) as TsSpinEdit,
      FindComponent('YearSpin' + IntToStr(i)) as TsSpinEdit,
      FindComponent('SecondSpin' + IntToStr(i)) as TsSpinEdit, FindComponent('MinuteSpin' + IntToStr(i)) as TsSpinEdit,
      FindComponent('HourSpin' + IntToStr(i)) as TsSpinEdit, FindComponent('DurationSpin' + IntToStr(i)) as TsSpinEdit,
      FindComponent('MonthCombo' + IntToStr(i)) as TsComboBox) then
    begin
      SetLength(Alarms, 0);
      Exit;
    end;
  end;

  if Length(Alarms) = 0 then
  begin
    WideMessageDlgSound(Dyn_Texts[52] {'No alarm is defined. Please define some valid alarms.'}, mtInformation, [mbOK], 0);
    Exit;
  end;

  for i := NumOfAlarmsSpin.Value to High(AlarmControls) do
  begin
    SetLength(Alarms, Length(Alarms) + 1);
    if GlobalOptions.LEDDisplaySettings.AlarmSystem = as12MonthAlarmSystem then
      Alarms[i] := ClearAlarm(Alarms[i], AlarmMonthCombo.ItemIndex + 1)
    else
      Alarms[i] := ClearAlarm(Alarms[i], 1);
  end;

  Result := True;
end;

procedure TAlarmSettingsForm.SetAlarmsBtnClick(Sender: TObject);
begin
  //Show menu or run direct
  if GlobalOptions.NumOfLEDDisplays = 1 then
  begin
    //Run direct
    SetAlarmsDataMenuItem1.Click;
  end
  else
    //Show menu
    SpecialProcs.PopupMenuAtControl(SetAlarmsBtn, SetAlarmDataPopup);
end;

procedure TAlarmSettingsForm.SetAlarmsDataMenuItem1Click(Sender: TObject);
var
  AlarmMonth: Integer;
begin
  //Determine correct alarm month
  if GlobalOptions.LEDDisplaySettings.AlarmSystem = as12MonthAlarmSystem then
    AlarmMonth := AlarmMonthCombo.ItemIndex + 1
  else
    AlarmMonth := 1;
  if CollectAlaramsInfo(False) then
    AlarmProgressForm.SetAlarmData(AlarmMonth, Alarms, 1, False);
  SetLength(Alarms, 0);
end;

procedure TAlarmSettingsForm.SetAlarmsDataMenuItem2Click(Sender: TObject);
var
  AlarmMonth: Integer;
begin
  //Determine correct alarm month
  if GlobalOptions.LEDDisplaySettings.AlarmSystem = as12MonthAlarmSystem then
    AlarmMonth := AlarmMonthCombo.ItemIndex + 1
  else
    AlarmMonth := 1;

  if CollectAlaramsInfo(False) then
    AlarmProgressForm.SetAlarmData(AlarmMonth, Alarms, 2, False);
  SetLength(Alarms, 0);
end;

procedure TAlarmSettingsForm.TntFormShow(Sender: TObject);
begin
  if FirstShow then
  begin
    FirstShow := False;

    //PrepareAlarmControls;
    //NumOfAlarmsSpin.MaxValue := ALARM_COUNT;
    //NumOfAlarmsSpin.OnChange(NumOfAlarmsSpin);
  end;

  if NumOfAlarmsSpin.Value > GlobalOptions.LEDDisplaySettings.AlarmCount then
  begin
    NumOfAlarmsSpin.Value := GlobalOptions.LEDDisplaySettings.AlarmCount;
  end;
  NumOfAlarmsSpin.MaxValue := GlobalOptions.LEDDisplaySettings.AlarmCount;
  if Assigned(NumOfAlarmsSpin.OnChange) then
    NumOfAlarmsSpin.OnChange(NumOfAlarmsSpin);

  HighGUITimer.Enabled := True;

  PrepareFormLayout;

  //Refresh popup menus to draw correctly
  TntXPMenu1.Active := not TntXPMenu1.Active;
  TntXPMenu1.Active := not TntXPMenu1.Active;

  CancelBtn.SetFocus;
end;

procedure TAlarmSettingsForm.TntFormCreate(Sender: TObject);
var
  y, m, d: Word;
  dt: TDateTime;
  i: Integer;
begin
  //Set constraints' MinWidth to MaxWidth to prevent potential software bugs
  Constraints.MinWidth := Constraints.MaxWidth;

  //Correct appearance
  //SetAlarmsBtn.Caption := SetAlarmsBtn.Caption + #13;  --No need to do this here, because it is done in the PrepareFormLayout procedure
  CancelBtn.Caption := CancelBtn.Caption + #13;  //--> But, this is necessary here! This new line make the caption of the button two lines to have better appearance on the button.

  dt := Now;
  DecodeDate(dt, y, m, d);
  Procs.ChristianToSolar(y, m, d);
  SolarYearSpin.Value := y;
  SolarMonthCombo.ItemIndex := m - 1;
  AlarmMonthCombo.OnChange := nil;
  AlarmMonthCombo.ItemIndex := m - 1;
  AlarmMonthCombo.OnChange := AlarmMonthComboChange;

  {$ifndef _ALARM_TYPE_12_MONTHS}
  AlarmMonthImage.Enabled := False;
  AlarmMonthLabel.Enabled := False;
  AlarmMonthCombo.Enabled := False;
  {$endif}

  HighGUIInitialize;

  FirstShow := True;

  SetLength(AlarmControls, 0);

  if License3._ALARM_ACTIVE_ then// {$IFDEF _ALARM_ACTIVE_}
  begin
    PrepareAlarmControls(31);//ALARM_COUNT);//DEFAULT_LED_DISPLAY_ALARM_COUNT);
  end//{$ELSE}
  else
  begin
    PrepareAlarmControls(1);
  end;//{$ENDIF}
  //NumOfAlarmsSpin.MaxValue := ALARM_COUNT;
  //NumOfAlarmsSpin.OnChange(NumOfAlarmsSpin);
end;

procedure TAlarmSettingsForm.SelectAlarmFileBtnClick(Sender: TObject);
begin
  if OpenAlarmFileDialog.Execute then
    LoadAlarmsFromFile(OpenAlarmFileDialog.FileName);
end;

procedure TAlarmSettingsForm.PrepareAlarmControls(NewCount: Integer);
var
  i: Integer;
  gb: TsGroupBox;
  OldHighGUITimerEnabled: Boolean;
  StartAlarm: Integer;
begin
  if NewCount <= Length(AlarmControls) then
    Exit;

  OldHighGUITimerEnabled := HighGUITimer.Enabled;  //Prevent potential software bugs

  StartAlarm := Length(AlarmControls);
  SetLength(AlarmControls, NewCount);

  for i := StartAlarm to High(AlarmControls) do
  begin
    AlarmControls[i] := MainForm.NewGroupBoxFromRef(RefAlarmGroup, ScrollBox1, Self);
    AlarmControls[i].Caption := IntToStr(i + 1);
    if i > 0 then
      AlarmControls[i].Top := AlarmControls[i - 1].Top + AlarmControls[i - 1].Height + 3;

    SetLength(HighGUIItems, Length(HighGUIItems) + 3);

    gb := MainForm.NewGroupBoxFromRef(AlarmDateGroup, AlarmControls[i], Self);
    MainForm.NewLabelFromRef(sLabel4, gb, Self);
    MainForm.NewLabelFromRef(sLabel5, gb, Self);
    MainForm.NewLabelFromRef(sLabel6, gb, Self);
    //Tab order: EveryDayCheck, YearSpin, MonthCombo, DaySpin (Tab order depends on the creation order - so don't change the creation order of these controls)
    MainForm.NewCheckFromRef(c1, gb, Self, 'EveryDayCheck' + IntToStr(i));
    MainForm.NewSpinFromRef(y1, gb, Self, 'YearSpin' + IntToStr(i));
    MainForm.NewComboFromRef(m1, gb, Self, 'MonthCombo' + IntToStr(i));
    MainForm.NewSpinFromRef(d1, gb, Self, 'DaySpin' + IntToStr(i));
    HighGUIItems[High(HighGUIItems) - 2] := gb;

    gb := MainForm.NewGroupBoxFromRef(AlarmTimeGroup, AlarmControls[i], Self);
    MainForm.NewLabelFromRef(sLabel3, gb, Self);
    MainForm.NewLabelFromRef(sLabel2, gb, Self);
    MainForm.NewLabelFromRef(sLabel1, gb, Self);
    MainForm.NewLabelFromRef(ClockDotsLabel1, gb, Self);
    MainForm.NewLabelFromRef(ClockDotsLabel2, gb, Self);
    //Tab order: HourSpin, MinuteSpin, SecondSpin (Tab order depends on the creation order - so don't change the creation order of these controls)
    MainForm.NewSpinFromRef(h1, gb, Self, 'HourSpin' + IntToStr(i));
    MainForm.NewSpinFromRef(min1, gb, Self, 'MinuteSpin' + IntToStr(i));
    MainForm.NewSpinFromRef(s1, gb, Self, 'SecondSpin' + IntToStr(i));
    HighGUIItems[High(HighGUIItems) - 1] := gb;

    gb := MainForm.NewGroupBoxFromRef(AlarmDurationGroup, AlarmControls[i], Self);
    MainForm.NewLabelFromRef(sLabel7, gb, Self);
    MainForm.NewLabelFromRef(sLabel15, gb, Self);
    MainForm.NewLabelFromRef(sLabel17, gb, Self);
    MainForm.NewLabelFromRef(sLabel18, gb, Self);                                                                  
    MainForm.NewLabelFromRef(sLabel19, gb, Self);
    MainForm.NewRadioBoxFromRef(r1, gb, Self, 'DurationRadioMinutes' + IntToStr(i)).OnClick := DurationRadioClick;
    MainForm.NewRadioBoxFromRef(r2, gb, Self, 'DurationRadioSeconds' + IntToStr(i)).OnClick := DurationRadioClick;
    MainForm.NewRadioBoxFromRef(r3, gb, Self, 'DurationRadioTime' + IntToStr(i)).OnClick := DurationRadioClick;
    MainForm.NewSpinFromRef(t1, gb, Self, 'DurationSpin' + IntToStr(i)).OnChange := DurationSpinChange;
    MainForm.NewSpinFromRef(t2, gb, Self, 'DurationSpinMin' + IntToStr(i)).OnChange := DurationSpinMinChange;
    //Tab order: DurationSpinS, DurationSpinM, DurationSpinH (Tab order depends on the creation order - so don't change the creation order of these controls)
    MainForm.NewSpinFromRef(t5, gb, Self, 'DurationSpinS' + IntToStr(i)).OnChange := DurationSpinSChange;
    MainForm.NewSpinFromRef(t4, gb, Self, 'DurationSpinM' + IntToStr(i)).OnChange := DurationSpinMChange;
    MainForm.NewSpinFromRef(t3, gb, Self, 'DurationSpinH' + IntToStr(i)).OnChange := DurationSpinHChange;
    HighGUIItems[High(HighGUIItems) - 0] := gb;

    LoadAlarmDefaults(i);
  end;

  HighGUITimer.Enabled := OldHighGUITimerEnabled;  //Restore previous value
end;

procedure TAlarmSettingsForm.TntFormDestroy(Sender: TObject);
var
  i: Integer;
begin
  for i := 0 to High(AlarmControls) do
    if Assigned(AlarmControls[i]) then
      AlarmControls[i].Free;
end;

procedure TAlarmSettingsForm.ShowAlarms(AlarmCount: Integer);
var
  i: Integer;
  Combo1: TsComboBox;
begin
  for i := 1 to AlarmCount do
  begin
    Combo1 := FindComponent('MonthCombo' + IntToStr(i - 1)) as TsComboBox;
    Combo1.Enabled := GlobalOptions.LEDDisplaySettings.AlarmSystem = as1MonthAlarmSystem;
    if GlobalOptions.LEDDisplaySettings.AlarmSystem = as12MonthAlarmSystem then
      Combo1.ItemIndex := AlarmMonthCombo.ItemIndex;

    AlarmControls[i -1].Show;
  end;
  for i := AlarmCount to High(AlarmControls) do
    if AlarmControls[i].Visible then
      AlarmControls[i].Hide;
end;

procedure TAlarmSettingsForm.LoadAlarmDefaults(AlarmIndex: Integer);
var
  y, m, d: Word;
  dt: TDateTime;
  Alarm: TLDCAlarm;
begin
  dt := Now;
  DecodeDate(dt, y, m, d);
  Procs.ChristianToSolar(y, m, d);

  //FirstShow := False;  --> Why this is here???!!!

  //Prepare alarm data
  with Alarm do
  begin
    EveryDay := False;
    Year := y;
    if GlobalOptions.LEDDisplaySettings.AlarmSystem = as12MonthAlarmSystem then
      Month := AlarmMonthCombo.ItemIndex + 1
    else
      Month := m;
    Day := d;
  end;
  //Set alarm data to alarm controls
  SetAlarmDataToAlarmControls(Alarm, AlarmIndex, True, False, False);
end;

procedure TAlarmSettingsForm.NumOfAlarmsSpinChange(Sender: TObject);
begin
  PrepareAlarmControls(NumOfAlarmsSpin.Value);

  if (NumOfAlarmsSpin.Value <= Length(AlarmControls)) and
     (NumOfAlarmsSpin.Value > 0) then
    ShowAlarms(NumOfAlarmsSpin.Value);
end;

procedure TAlarmSettingsForm.SpeedSetAlarmsForMonthBtnClick(
  Sender: TObject);
var
  Alarm: TLDCAlarm;
  i: Integer;
begin
  if ToDaySpin.Value < FromDaySpin.Value then
  begin
    i := FromDaySpin.Value;
    FromDaySpin.Value := ToDaySpin.Value;
    ToDaySpin.Value := i;
  end;


  Alarm.Year := SolarYearSpin.Value;  //Year value is the same for all alarms in this procedure
  for i := 1 to (ToDaySpin.Value - FromDaySpin.Value + 1) do
  begin
    with Alarm do
    begin
      //Year := SolarYearSpin.Value;  --> This is set outside the for loop
      Day := FromDaySpin.Value + i - 1;
      if GlobalOptions.LEDDisplaySettings.AlarmSystem = as12MonthAlarmSystem then
        Month := AlarmMonthCombo.ItemIndex + 1
      else
        Month := SolarMonthCombo.ItemIndex + 1;
    end;
    SetAlarmDataToAlarmControls(Alarm, i - 1, True, False, False);
  end;

  if (ToDaySpin.Value - FromDaySpin.Value + 1) <= NumOfAlarmsSpin.MaxValue then
    NumOfAlarmsSpin.Value := ToDaySpin.Value - FromDaySpin.Value + 1
  else
    NumOfAlarmsSpin.Value := NumOfAlarmsSpin.MaxValue;
  
  ShowAlarms(NumOfAlarmsSpin.Value);
end;

procedure TAlarmSettingsForm.SpeedSetAlarmsTimeBtnClick(Sender: TObject);
var
  i: Integer;
  Alarm: TLDCAlarm;
begin
  for i := 0 to High(AlarmControls) do
  begin
    //Prepare alarm data
    with Alarm do
    begin
      Second := SpeedSecondSpin.Value;
      Minute := SpeedMinuteSpin.Value;
      Hour := SpeedHourSpin.Value;
    end;
    //Set alarm data to alarm controls
    SetAlarmDataToAlarmControls(Alarm, i, False, True, False);
  end;
end;

procedure TAlarmSettingsForm.ClearAlarmsDataMenuItem1Click(
  Sender: TObject);
begin
  ClearLEDDisplayAlarms(1);
  {
  CollectAlaramsInfo(True);
  AlarmProgressForm.SetAlarmData(Alarms, 1);
  SetLength(Alarms, 0);
  }
end;

procedure TAlarmSettingsForm.ClearAlarmsDataMenuItem2Click(
  Sender: TObject);
begin
  ClearLEDDisplayAlarms(2);
  {
  CollectAlaramsInfo(True);
  AlarmProgressForm.SetAlarmData(Alarms, 2);
  SetLength(Alarms, 0);
  }
end;

procedure TAlarmSettingsForm.ClearAllAlarmsBtnClick(Sender: TObject);
begin
  //Show menu or run direct
  if GlobalOptions.NumOfLEDDisplays = 1 then
  begin
    //Run direct
    ClearAlarmsDataMenuItem1.Click;
  end
  else
    //Show menu
    SpecialProcs.PopupMenuAtControl(ClearAllAlarmsBtn, ClearAlarmDataPopup);
end;

function TAlarmSettingsForm.LoadAlarmsFromFile(
  const FName: WideString): Boolean;
var
  F: File of TLDCAlarm;
  F1, F2: File of Byte;
  NonUnicodeTempFName: String;
  TempFName: String;
  i: Integer;
  S: String;
  FileSignature: String;
  b: Byte;
  TooManyAlarms: Boolean;
begin
  Result := False;

  try

  NonUnicodeTempFName := Procs.GenerateTemporaryFileName(Procs.GetTempFilesPath, TEMPORARY_FILES_PREFIX);
  TempFName := Procs.GenerateTemporaryFileName(Procs.GetTempFilesPath, TEMPORARY_FILES_PREFIX);

  if not Procs.WideFileCopy(FName, NonUnicodeTempFName) then
  begin
    WideMessageDlgSound(WideFormat(Dyn_Texts[53] {'Error while reading alarm settings from file %s.'}, [#13 + FName]), mtError, [mbOK], 0);
    Exit;
  end;

  AssignFile(F1, NonUnicodeTempFName);
  Reset(F1);
  AssignFile(F2, TempFName);
  Rewrite(F2);
  S := LDC_ALARM_FILE_SIGNATURE;
  FileSignature := '';

  i := 0;
  while not eof(F1) and (i < Length(S)) do
  begin
    Read(F1, b);
    FileSignature := FileSignature + Chr(b);
    Inc(i);
  end;
  while not eof(F1) do
  begin
    Read(F1, b);
    Write(F2, b);
  end;
  CloseFile(F1);
  CloseFile(F2);

  //Check file signature to be valid 
  if FileSignature <> LDC_ALARM_FILE_SIGNATURE then
  begin
    WideMessageDlgSoundTop(WideFormat(Dyn_Texts[80] {'The file%sis either corrupted or for newer versions of LED Display Control and cannot be opened in this version.'}, [#13 + FName + #13]), mtInformation, [mbOK], 0);
    Exit;
  end;

  //Now TempFName contains alarm file data without file signature
  AssignFile(F, TempFName);
  {$I-}
  Reset(F);
  {$I+}
  if IOResult <> 0 then
  begin
    WideMessageDlgSound(WideFormat(Dyn_Texts[53] {'Error while reading alarm settings from file %s.'}, [#13 + FName]), mtError, [mbOK], 0);
    Exit;
  end;

  TooManyAlarms := False;
  SetLength(Alarms, 0);
  for i := 1 to FileSize(F) do
  begin
    if Length(Alarms) >= GlobalOptions.LEDDisplaySettings.AlarmCount then
    begin
      TooManyAlarms := True;
    end
    else
    begin
      SetLength(Alarms, Length(Alarms) + 1);
      {$I-}
      Read(F, Alarms[High(Alarms)]);
      {$I+}
      if IOResult <> 0 then
      begin
        WideMessageDlgSound(WideFormat(Dyn_Texts[53] {'Error while reading alarm settings from file %s.'}, [#13 + FName]), mtError, [mbOK], 0);
        Exit;
      end;
    end;
  end;
  {$I-}
  CloseFile(F);
  {$I+}

  UpdateAlarmControls;

  SetLength(Alarms, 0);

  if TooManyAlarms then
  begin
    WideShowMessageSoundTop(Dyn_Texts[129] {'The number of alarms in the file is greater than the number of alarms you have set for the LED Display settings form. Extra alarms have not been loaded from the file.'});
  end;

  Result := True;

  finally

  WideDeleteFile(NonUnicodeTempFName);
  WideDeleteFile(TempFName);

  end;
end;

function TAlarmSettingsForm.SaveAlarmDataToFile(
  const FName: WideString): Boolean;
var
  F: File of TLDCAlarm;
  F1, F2: File of Byte;
  NonUnicodeTempFName: String;
  TempFName: String;
  i: Integer;
  S: String;
  b: Byte;
begin
  Result := False;

  try

  NonUnicodeTempFName := Procs.GenerateTemporaryFileName(Procs.GetTempFilesPath, TEMPORARY_FILES_PREFIX);
  TempFName := Procs.GenerateTemporaryFileName(Procs.GetTempFilesPath, TEMPORARY_FILES_PREFIX);

  if CollectAlaramsInfo(False) then
  begin
    AssignFile(F, TempFName);
    {$I-}
    Rewrite(F);
    {$I+}
    if IOResult <> 0 then
    begin
      WideMessageDlgSound(WideFormat(Dyn_Texts[54] {'Unable to save alarm settings to the file %s'}, [#13 + FName]), mtError, [mbOK], 0);
      Exit;
    end;

    for i := 0 to High(Alarms) do
    begin
      {$I-}
      Write(F, Alarms[i]);
      {$I+}
      if IOResult <> 0 then
      begin
        {$I-}
        CloseFile(F);
        {$I+}
        WideMessageDlgSound(WideFormat(Dyn_Texts[56] {'Occurred an error while saving alarm settings to the file %s.'}, [#13 + FName]), mtError, [mbOK], 0);
        Exit;
      end;
    end;
    {$I-}
    CloseFile(F);
    {$I+}

    //Insert File Signature
    AssignFile(F1, TempFName);
    Reset(F1);
    AssignFile(F2, NonUnicodeTempFName);
    Rewrite(F2);
    S := LDC_ALARM_FILE_SIGNATURE;
    for i := 1 to Length(S) do
      Write(F2, Byte(S[i]));
    while not eof(F1) do
    begin
      Read(F1, b);
      Write(F2, b);
    end;
    CloseFile(F1);
    CloseFile(F2);

    if not Procs.WideFileCopy(NonUnicodeTempFName, FName) then
    begin
      WideMessageDlgSound(WideFormat(Dyn_Texts[56] {'Occurred an error while saving alarm settings to the file %s.'}, [#13 + FName]), mtError, [mbOK], 0);
      Exit;
    end;

    Result  := True;
  end;

  finally

  SetLength(Alarms, 0);

  WideDeleteFile(NonUnicodeTempFName);
  WideDeleteFile(TempFName);

  end;
end;

function TAlarmSettingsForm.ValidAlarm(const Alarm: TLDCAlarm;
  ForceMonthCheck: Boolean = True): Boolean;
//Returns True if invalid data found
//This function also corrects invalid data in the alarm
var
  Original: TLDCAlarm;
  CorrectedAlarm: TLDCAlarm;
begin
  Original := Alarm;
  CorrectedAlarm := Alarm;

  with CorrectedAlarm do
  begin
    if Day < 1 then Day := 1;
    if Day > 31 then Day := 31;

    if Month < 1 then Month := 1;
    if Month > 12 then Month := 12;
    if ForceMonthCheck then
    begin
      if GlobalOptions.LEDDisplaySettings.AlarmSystem = as12MonthAlarmSystem then
        Month := AlarmMonthCombo.ItemIndex + 1;
    end;

    if Year < 1300 then Year := 1300;
    if Year > 1500 then Year := 1500;

    if Hour < 0 then Hour := 0;
    if Hour > 23 then Hour := 23;

    if Minute < 0 then Minute := 0;
    if Minute > 59 then Minute := 59;

    if Second < 0 then Second := 0;
    if Second > 59 then Second := 59;
  end;

  Result := (CorrectedAlarm.Day     <> Original.Day) or
            (CorrectedAlarm.Month   <> Original.Month) or
            (CorrectedAlarm.Year    <> Original.Year) or
            (CorrectedAlarm.Hour    <> Original.Hour) or
            (CorrectedAlarm.Minute  <> Original.Minute) or
            (CorrectedAlarm.Second  <> Original.Second);
  Result := not Result;
end;

procedure TAlarmSettingsForm.UpdateAlarmControls;
var
  i: Integer;
  NextAlarm: Integer;
begin
  if Length(Alarms) > Length(AlarmControls) then
    SetLength(Alarms, Length(AlarmControls));

  if GlobalOptions.LEDDisplaySettings.AlarmSystem = as12MonthAlarmSystem then
  begin
    //Month of the first valid alarm is the selected alarm month
    for i := 0 to High(Alarms) do
      if ValidAlarm(Alarms[i], False) then
      begin
        AlarmMonthCombo.ItemIndex := Alarms[i].Month - 1;
        Break;
      end;
  end;

  NextAlarm := 0;
  for i := 0 to High(Alarms) do
  begin
    if ValidAlarm(Alarms[i]) then
    begin
      SetAlarmDataToAlarmControls(Alarms[i], NextAlarm, True, True, True);
      Inc(NextAlarm);
    end;
  end;

  for i := NextAlarm to High(AlarmControls) do
  begin
    (FindComponent('DurationSpinMin' + IntToStr(i)) as TsSpinEdit).Value := 0;
    (FindComponent('DurationRadioMinutes' + IntToStr(i)) as TsRadioButton).Checked := True;
    (FindComponent('DurationSpin' + IntToStr(i)) as TsSpinEdit).Value := 0;
  end;

  NumOfAlarmsSpin.Value := NextAlarm;
  ShowAlarms(NumOfAlarmsSpin.Value);
end;

procedure TAlarmSettingsForm.SaveAlarmDataToFileBtnClick(Sender: TObject);
var
  FName: WideString;
  RetrySave, SaveError: Boolean;
begin
  SaveAlarmDialog.FileName := NEW_ALARM_SETTINGS_FILE_NAME;

  RetrySave := True;
  while RetrySave do
  begin
    if SaveAlarmDialog.Execute then
    begin
      FName := Procs.ApplyFileNameExtension(SaveAlarmDialog.FileName,
                 ExtractFileExt(Procs.ExtractFilterString(SaveAlarmDialog.Filter, SaveAlarmDialog.FilterIndex)),
                 True);  //Force file extension
      if MainForm.InformForReadOnlySelectedFile(FName) then
        Continue;

      SaveError := False;
      if WideFileExists(FName) then
        SaveError := not WideDeleteFile(FName);
      if SaveError then
        if not(WideMessageDlgSoundTop(WideFormat(Dyn_Texts[13] {'Unable to create the file %s in the specified location.'}, [#13 + FName + #13]), mtError, [mbCancel, mbRetry], 0) = mrRetry) then
          Exit;
      if SaveError then
        Continue;
      with TFileStream.Create(FName, fmCreate) do
        Free;

      if not SaveAlarmDataToFile(FName) then
        WideDeleteFile(FName);

      RetrySave := False;
    end
    else
      RetrySave := False;
  end;
end;

procedure TAlarmSettingsForm.SaveAlarmDialogCanClose(Sender: TObject;
  var CanClose: Boolean);
begin
  CanClose := MainForm.PromptForFileReplace(SaveAlarmDialog.FileName,
                WideExtractFileExt(Procs.ExtractFilterString(SaveAlarmDialog.Filter,
                SaveAlarmDialog.FilterIndex)),
                True);  //Force file extension
end;

procedure TAlarmSettingsForm.CancelBtnClick(Sender: TObject);
begin
  Close;
end;

procedure TAlarmSettingsForm.HighGUITimerTimer(Sender: TObject);
begin
  HighGUITimer.Enabled := False;
  if HighGUITimer.Tag = 0 then
    Exit;
  try
    MainForm.HighGUIUpdateState(Self, HighGUITimer, HighGUIItems);
  finally
    HighGUITimer.Enabled := HighGUITimer.Tag = 1;
  end;
end;

procedure TAlarmSettingsForm.TntFormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  HighGUITimer.Enabled := False;
end;

procedure TAlarmSettingsForm.HighGUIInitialize;
begin
  SetLength(HighGUIItems, 4);

  HighGUIItems[0] := QuickSetForOneMonthGroup;
  HighGUIItems[1] := SetAllAlarmsTimeGroup;
  HighGUIItems[2] := SetAllAlarmsDurationGroup;
  HighGUIItems[3] := ReadAlarmsFromFileGroup;
end;

procedure TAlarmSettingsForm.GetAlarmBtnClick(Sender: TObject);
begin
  //Show menu or run direct
  if GlobalOptions.NumOfLEDDisplays = 1 then
  begin
    //Run direct
    GetAlarmMenuItem1.Click;
  end
  else
    //Show menu
    SpecialProcs.PopupMenuAtControl(GetAlarmBtn, GetAlarmsPopup);
end;

procedure TAlarmSettingsForm.GetLEDDisplayAlarms(
  LEDDisplayNumber: Integer);
var
  ReadAlarms: TLDCAlarms;
  i: Integer;
  NextAlarm: Integer;
  SpinMin, SpinSeconds: TsSpinEdit;
  OldEventHandlerMin, OldEventHandlerSeconds: TNotifyEvent;
  AlarmMonth: Integer;
  TooManyAlarms: Boolean;
begin
  SetLength(ReadAlarms, 0);

  try

  AlarmSettingsForm.Enabled := False;

  if GlobalOptions.LEDDisplaySettings.AlarmSystem = as12MonthAlarmSystem then
    AlarmMonth := AlarmMonthCombo.ItemIndex + 1
  else
    AlarmMonth := 1;

  if AlarmProgressForm.ReadAlarms(AlarmMonth, ReadAlarms, LEDDisplayNumber) then  //AlarmMonth is alaways 1 in this program
  begin
    TooManyAlarms := False;
    NextAlarm := 0;
    for i := 0 to High(ReadAlarms) do
    begin
      if ValidAlarm(ReadAlarms[i]) then
      begin
        if NextAlarm >= GlobalOptions.LEDDisplaySettings.AlarmCount then
        begin
          TooManyAlarms := True;
        end
        else
        begin
          SetAlarmDataToAlarmControls(ReadAlarms[i], NextAlarm, True, True, True);
          Inc(NextAlarm);
        end;
      end;
    end;

    if NextAlarm = 0 then
    begin
      NumOfAlarmsSpin.Value := 1;
      LoadAlarmDefaults(0);
      {
      SetLength(ReadAlarms, 1);
      ReadAlarms[0] := ClearAlarm(ReadAlarms[0], AlarmMonth);
      SetAlarmDataToAlarmControls(ReadAlarms[0], 0, True, True, True);
      SetLength(ReadAlarms, 0);
      }
      if GlobalOptions.LEDDisplaySettings.AlarmSystem = as12MonthAlarmSystem then
        WideShowMessageSoundTop(WideFormat(Dyn_Texts[108] {'No alarm is set for the month %s on the LED Display.'}, [AlarmMonthCombo.Items.Strings[AlarmMonth - 1]]))
      else
        WideShowMessageSoundTop(Dyn_Texts[106] {'No alarm is set for the LED Display connected to the port.'});
      Exit;
    end
    else if TooManyAlarms then
    begin
      WideShowMessageSoundTop(Dyn_Texts[128] {'Number of alarms of the LED Display is greater thanthe number of alarms you have set in the LED Display settings form. Not all alarms have been shown. Please correct the LED Display settings.'});
    end;

    NumOfAlarmsSpin.Value := NextAlarm;
    if Assigned(NumOfAlarmsSpin.OnChange) then
      NumOfAlarmsSpin.OnChange(NumOfAlarmsSpin);
  end;

  finally

  AlarmSettingsForm.Enabled := True;
  MainForm.BringToFront;
  AlarmSettingsForm.BringToFront;
  
  SetLength(ReadAlarms, 0);

  end;
end;

procedure TAlarmSettingsForm.GetAlarmMenuItem1Click(Sender: TObject);
begin
  GetLEDDisplayAlarms(1);
end;

procedure TAlarmSettingsForm.GetAlarmMenuItem2Click(Sender: TObject);
begin
  GetLEDDisplayAlarms(2);
end;

function TAlarmSettingsForm.ClearAlarm(const Alarm: TLDCAlarm;
  AlarmMonth: Integer): TLDCAlarm;
var
  i: Integer;
begin
  Result := Alarm;
  with Result do
  begin
    Duration := 0;
    EveryDay := False;
    Year := 0;
    Month := AlarmMonth;
    Day := 0;
    Hour := 0;
    Minute := 0;
    Second := 0;
    //-----------------------------------------
    //-----------------------------------------
    //Reserved bytes - set to 0 for compatibility
    for i := 1 to ALARM_RESERVED_BYTES_COUNT do
      ReservedBytes[i] := 0;
    //-----------------------------------------
    //-----------------------------------------
  end;
end;

function TAlarmSettingsForm.ClearLEDDisplayAlarms(
  LEDDisplayNumber: Integer): Boolean;
var
  ReadAlarms: TLDCAlarms;
  i: Integer;
  AlarmMonth: Integer;
begin
  Result := False;

  try

  AlarmSettingsForm.Enabled := False;

  if GlobalOptions.LEDDisplaySettings.AlarmSystem = as12MonthAlarmSystem then
    AlarmMonth := AlarmMonthCombo.ItemIndex + 1
  else
    AlarmMonth := 1;

  SetLength(ReadAlarms, 1);
  ReadAlarms[0] := ClearAlarm(ReadAlarms[0], AlarmMonth);

  Result := AlarmProgressForm.SetAlarmData(AlarmMonth, ReadAlarms, LEDDisplayNumber, False);

  finally

  SetLength(ReadAlarms, 0);

  AlarmSettingsForm.Enabled := True;
  MainForm.BringToFront;
  AlarmSettingsForm.BringToFront;

  end;
end;

procedure TAlarmSettingsForm.DurationSpinChange(Sender: TObject);
var
  S, Nums: String;
  i: Integer;
  OldEventHandler: TNotifyEvent;
  Spin: TsSpinEdit;
begin
  S := (Sender as TsSpinEdit).Name;
  Nums := '';
  i := Length(S);
  while S[i] in ['0'..'9'] do
  begin
    Nums := Nums + S[i];
    Dec(i);
  end;
  Delete(S, Length(S) - Length(Nums) + 1, Length(Nums));
  (FindComponent('DurationRadioSeconds' + Nums) as TsRadioButton).Checked := True;
  Spin := FindComponent(S + 'Min' + Nums) as TsSpinEdit;
  OldEventHandler := Spin.OnChange;
  Spin.OnChange := nil;
  Spin.Value := (Sender as TsSpinEdit).Value div 60;
  Spin.OnChange := OldEventHandler;
end;

procedure TAlarmSettingsForm.DurationSpinMinChange(Sender: TObject);
var
  S, Nums: String;
  i: Integer;
  OldEventHandler: TNotifyEvent;
  Spin: TsSpinEdit;
begin
  S := (Sender as TsSpinEdit).Name;
  Nums := '';
  i := Length(S);
  while S[i] in ['0'..'9'] do
  begin
    Nums := Nums + S[i];
    Dec(i);
  end;
  Delete(S, Length(S) - Length(Nums) + 1, Length(Nums));
  (FindComponent('DurationRadioMinutes' + Nums) as TsRadioButton).Checked := True;
  Spin := FindComponent(LeftStr(S, Length(S) - Length('Min')) + Nums) as TsSpinEdit;
  OldEventHandler := Spin.OnChange;
  Spin.OnChange := nil;
  Spin.Value := (Sender as TsSpinEdit).Value * 60;
  Spin.OnChange := OldEventHandler;
end;

procedure TAlarmSettingsForm.DurationRadioClick(Sender: TObject);
var
  S, Nums: String;
  Spin1, Spin2: TsSpinEdit;
  i: Integer;
begin
  S := (Sender as TsRadioButton).Name;
  Nums := '';
  i := Length(S);
  while S[i] in ['0'..'9'] do
  begin
    Nums := Nums + S[i];
    Dec(i);
  end;
  Delete(S, Length(S) - Length(Nums) + 1, Length(Nums));

  Spin1 := FindComponent('DurationSpinMin' + Nums) as TsSpinEdit;
  Spin2 := FindComponent('DurationSpin' + Nums) as TsSpinEdit;

  if S = 'DurationRadioMinutes' then
  begin
    Spin1.Enabled := True;
    Spin2.Enabled := False;
    try  //Prevent potential software bugs
      Spin1.SetFocus;
    except
    end;
  end
  else if S = 'DurationRadioSeconds' then
  begin
    Spin2.Enabled := True;
    Spin1.Enabled := False;
    try  //Prevent potential software bugs
      Spin2.SetFocus;
    except
    end;
  end
  else// if S = 'DurationRadioTime' then
  begin
    //NOT IMPLEMENTED YET
  end;
end;

procedure TAlarmSettingsForm.DurationSpinHChange(Sender: TObject);
begin
  //NOT IMPLEMENTED YET
end;

procedure TAlarmSettingsForm.DurationSpinMChange(Sender: TObject);
begin
  //NOT IMPLEMENTED YET
end;

procedure TAlarmSettingsForm.DurationSpinSChange(Sender: TObject);
begin
  //NOT IMPLEMENTED YET
end;

procedure TAlarmSettingsForm.SetDurationSpinsValue(T: TDateTime; Num: Integer);
begin
  //NOT IMPLEMENTED YET
end;

procedure TAlarmSettingsForm.SetAlarmDataToAlarmControls(
  const Alarm: TLDCAlarm; AlarmNumber: Integer;
  SetDate, SetTime, SetDuration: Boolean);
var
  SpinMin, SpinSeconds: TsSpinEdit;
  RadioMin, RadioSeconds: TsRadioButton;
  OldEventHandlerMin, OldEventHandlerSeconds: TNotifyEvent;
  OldRadioEventHandlerMin, OldRadioEventHandlerSeconds: TNotifyEvent;
begin
  with Alarm do
  begin
    if SetDate then
    begin
      (FindComponent('EveryDayCheck' + IntToStr(AlarmNumber)) as TsCheckBox).Checked := EveryDay;
      (FindComponent('DaySpin' + IntToStr(AlarmNumber)) as TsSpinEdit).Value := Day;
      (FindComponent('MonthCombo' + IntToStr(AlarmNumber)) as TsComboBox).ItemIndex := Month - 1;
      (FindComponent('YearSpin' + IntToStr(AlarmNumber)) as TsSpinEdit).Value := Year;
    end;

    if SetTime then
    begin
      (FindComponent('SecondSpin' + IntToStr(AlarmNumber)) as TsSpinEdit).Value := Second;
      (FindComponent('MinuteSpin' + IntToStr(AlarmNumber)) as TsSpinEdit).Value := Minute;
      (FindComponent('HourSpin' + IntToStr(AlarmNumber)) as TsSpinEdit).Value := Hour;
    end;

    if SetDuration then
    begin
      //Find components
      SpinMin := FindComponent('DurationSpinMin' + IntToStr(AlarmNumber)) as TsSpinEdit;
      SpinSeconds := FindComponent('DurationSpin' + IntToStr(AlarmNumber)) as TsSpinEdit;
      RadioMin := FindComponent('DurationRadioMinutes' + IntToStr(AlarmNumber)) as TsRadioButton;
      RadioSeconds := FindComponent('DurationRadioSeconds' + IntToStr(AlarmNumber)) as TsRadioButton;
      //Disable event handlers
      OldEventHandlerMin := SpinMin.OnChange;
      OldEventHandlerSeconds := SpinSeconds.OnChange;
      OldRadioEventHandlerMin := RadioMin.OnClick;
      OldRadioEventHandlerSeconds := RadioSeconds.OnClick;
      SpinMin.OnChange := nil;
      SpinSeconds.OnChange := nil;
      RadioMin.OnClick := nil;  //Disable these two event handlers too to prevent potential software bugs (when the Checked property of these RadioButtons is set and their OnClick event occurs when the new value is not the same as the old value of the Checked property)
      RadioSeconds.OnClick := nil;
      //Set values
      SpinMin.Value := Duration div 60;
      SpinSeconds.Value := Duration;
      //Set RadioButtons
      if Duration = ((Duration div 60) * 60) then  //It is in minutes
      begin
        SpinMin.Enabled := True;
        SpinSeconds.Enabled := False;
        RadioMin.Checked := True;
      end
      else
      begin
        SpinMin.Enabled := False;
        SpinSeconds.Enabled := True;
        RadioSeconds.Checked := True;
      end;
      //Restore event handlers
      SpinMin.OnChange := OldEventHandlerMin;
      SpinSeconds.OnChange := OldEventHandlerSeconds;
      RadioMin.OnClick := OldRadioEventHandlerMin;
      RadioSeconds.OnClick := OldRadioEventHandlerSeconds;
    end;
  end;
end;

procedure TAlarmSettingsForm.PrepareFormLayout;
const
  SCROLLBOX_BOTTOM_FROM_FORM_BOTTOM = 116;
begin
  if GlobalOptions.LEDDisplaySettings.AlarmSystem = as1MonthAlarmSystem then
  begin
    SolarMonthLabel.Enabled := True;
    SolarMonthCombo.Enabled := True;
    AlarmMonthImage.Visible := False;
    AlarmMonthLabel.Visible := False;
    AlarmMonthCombo.Visible := False;
    ScrollBox1.Top := 200;
    ScrollBox1.Height := (AlarmSettingsForm.Height - SCROLLBOX_BOTTOM_FROM_FORM_BOTTOM) - ScrollBox1.Top;
    //Buttons
    GetAlarmBtn.Caption := Dyn_Texts[109];  //'Get LED Display Alarm Setting'  --> I have added some spaces between words in the Persian translation to force the caption to break into two lines
    SetAlarmsBtn.Caption := Dyn_Texts[111] + #13;  //'Set LED Display Alarms'  --> The character #13 is needed to make caption of the button two lines for better display on the button
    ClearAllAlarmsBtn.Caption := Dyn_Texts[113];  //'Clear LED Display All Alarms'
  end
  else //if GlobalOptions.LEDDisplaySettings.AlarmSystem = as12MonthAlarmSystem then
  begin
    SolarMonthLabel.Enabled := False;
    SolarMonthCombo.Enabled := False;
    AlarmMonthImage.Visible := True;
    AlarmMonthLabel.Visible := True;
    AlarmMonthCombo.Visible := True;
    ScrollBox1.Top := 224;
    ScrollBox1.Height := (AlarmSettingsForm.Height - SCROLLBOX_BOTTOM_FROM_FORM_BOTTOM) - ScrollBox1.Top;
    //Buttons
    RefreshButtonsCaption;
  end;
end;

procedure TAlarmSettingsForm.AlarmMonthComboChange(Sender: TObject);
begin
  {$ifdef _ALARM_TYPE_12_MONTHS}
  RefreshButtonsCaption;
  ShowAlarms(NumOfAlarmsSpin.Value);
  SolarMonthCombo.ItemIndex := AlarmMonthCombo.ItemIndex;
  {$endif}
end;

procedure TAlarmSettingsForm.SpeedSetAlarmsDurationBtnClick(
  Sender: TObject);
var
  i: Integer;
  Alarm: TLDCAlarm;
begin
  for i := 0 to High(AlarmControls) do
  begin
    //Prepare alarm data
    with Alarm do
    begin
      Duration := SpeedDurationSpin.Value;
    end;
    //Set alarm data to alarm controls
    SetAlarmDataToAlarmControls(Alarm, i, False, False, True);
  end;
end;

procedure TAlarmSettingsForm.RefreshButtonsCaption;
begin
  if GlobalOptions.LEDDisplaySettings.AlarmSystem = as1MonthAlarmSystem then
    Exit;

  GetAlarmBtn.Caption := WideFormat(Dyn_Texts[110] {'Get LED Display Alarm Setting For the Month %s'}, [AlarmMonthCombo.Text]);
  SetAlarmsBtn.Caption := WideFormat(Dyn_Texts[112] {'Set LED Display Alarms For the Month %s'}, [AlarmMonthCombo.Text]);
  ClearAllAlarmsBtn.Caption := WideFormat(Dyn_Texts[114] {'Clear LED Display All Alarms For the Month %s'}, [AlarmMonthCombo.Text]);
end;

end.
