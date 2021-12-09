unit ChangeDisplaySettingsFormUnit;

{$INCLUDE Config.inc}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, TntForms, sSkinProvider, StdCtrls, Buttons, TntButtons, sBitBtn,
  TntStdCtrls, sGroupBox, sLabel, sComboBox, StrUtils, ExtCtrls,
  sRadioButton, sEdit, GlobalTypes, ProcsUnit, SoundDialogs, ProgramConsts,
  sCheckBox, Menus, TntMenus, SpecialProcsUnit, TntXPMenu,
  LEDDisplayDataResetFormUnit, sSpinEdit, ProgrammerFormUnit, TntClasses,
  License;

type
  TChangeDisplaySettingsForm = class(TTntForm)
    sSkinProvider1: TsSkinProvider;
    OKBtn: TsBitBtn;
    CancelBtn: TsBitBtn;
    SizeSettingsGroup: TsGroupBox;
    MemorySettingsGroup: TsGroupBox;
    sLabel1: TsLabel;
    sLabel2: TsLabel;
    ColCountCombo: TsComboBox;
    RowCountCombo: TsComboBox;
    MemoryCombo: TsComboBox;
    sLabel3: TsLabel;
    Image1: TImage;
    sLabel4: TsLabel;
    ColorSettingsGroup: TsGroupBox;
    ColorLabel1: TsLabel;
    ColorLabel2: TsLabel;
    ColorCombo1: TsComboBox;
    SingleColorRadio: TsRadioButton;
    DoubleColorRadio: TsRadioButton;
    ColorCombo2: TsComboBox;
    ColorNameEdit1: TsEdit;
    ColorNameEdit2: TsEdit;
    CustomColumnCountEdit: TsEdit;
    CustomRowCountEdit: TsEdit;
    ColorLabel3: TsLabel;
    ColorLabel3FormatLabel: TsLabel;
    sLabel5: TsLabel;
    CapabilitiesGroup: TsGroupBox;
    CanShowDateTimeCheck: TsCheckBox;
    CanShowTemperatureCheck: TsCheckBox;
    LEDDisplayToolsBtn: TsBitBtn;
    LEDDisplayToolsPopup: TTntPopupMenu;
    N1: TTntMenuItem;
    TntXPMenu1: TTntXPMenu;
    CanShowScrollingTextCheck: TsCheckBox;
    CanShowPictureCheck: TsCheckBox;
    CanShowAnimationCheck: TsCheckBox;
    CanSetAlarmsCheck: TsCheckBox;
    CanShowTextEffectsCheck: TsCheckBox;
    CanShowPageEffectsCheck: TsCheckBox;
    CanChangePageLayoutCheck: TsCheckBox;
    CanSetTimeSpanCheck: TsCheckBox;
    HighGUITimer: TTimer;
    AlarmCountLabel: TsLabel;
    AlarmCountSpin: TsSpinEdit;
    AlarmSystem12MonthCheck: TsCheckBox;
    GetConfigurationBtn: TsBitBtn;
    GetConfigurationWithSubMenuMenuItem: TTntMenuItem;
    GetConfigurationMenuItem1: TTntMenuItem;
    GetConfigurationMenuItem2: TTntMenuItem;
    LEDDisplayGetConfigurationBtnPopup: TTntPopupMenu;
    LEDDisplayGetConfigurationBtnMenuItem1: TTntMenuItem;
    LEDDisplayGetConfigurationBtnMenuItem2: TTntMenuItem;
    GetConfigurationMenuItem: TTntMenuItem;
    procedure OKBtnClick(Sender: TObject);
    procedure SingleColorRadioClick(Sender: TObject);
    procedure ColorCombo1Change(Sender: TObject);
    procedure ColorCombo2Change(Sender: TObject);
    procedure ColCountComboChange(Sender: TObject);
    procedure RowCountComboChange(Sender: TObject);
    procedure TntFormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure TntFormShow(Sender: TObject);
    procedure ColorNameEdit1Change(Sender: TObject);
    procedure ColorNameEdit2Change(Sender: TObject);
    procedure LEDDisplayToolsBtnClick(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure HighGUITimerTimer(Sender: TObject);
    procedure TntFormCreate(Sender: TObject);
    procedure TntFormClose(Sender: TObject; var Action: TCloseAction);
    procedure CanSetAlarmsCheckClick(Sender: TObject);
    procedure GetConfigurationBtnClick(Sender: TObject);
    procedure GetConfigurationMenuItem1Click(Sender: TObject);
    procedure GetConfigurationMenuItem2Click(Sender: TObject);
    procedure LEDDisplayGetConfigurationBtnMenuItem1Click(Sender: TObject);
    procedure LEDDisplayGetConfigurationBtnMenuItem2Click(Sender: TObject);
    procedure LEDDisplayToolsPopupPopup(Sender: TObject);
    procedure GetConfigurationMenuItemClick(Sender: TObject);
  private
    { Private declarations }
    HighGUIItems: THighGUIItems;

    OKClicked: Boolean;
    procedure UpdateColorLabel3Caption;

    procedure HighGUIInitialize;

    procedure ApplyLEDDisplayConfiguration(
      const LEDDisplayConfiguration: TLEDDisplayConfiguration);
    procedure GetLEDDisplayConfiguration(LEDDisplayNumber: Integer);

    function FindBestChoiceForCombo(Items: TTntStrings; Value: Integer): Integer;
  public
    { Public declarations }
    Settings: TLEDDisplaySettings;
    procedure Prepare;
  end;

var
  ChangeDisplaySettingsForm: TChangeDisplaySettingsForm;

implementation

uses MainUnit;

{$R *.dfm}

procedure TChangeDisplaySettingsForm.Prepare;

  procedure SetColorCombo(ColorCombo: TsComboBox; ColorNameEdit: TsEdit; const ColorName: WideString);
  begin
    if (ColorCombo.Items.IndexOf(ColorName) >= 0) and (ColorCombo.Items.IndexOf(ColorName) < (ColorCombo.Items.Count - 1)) then
    begin
      ColorCombo.ItemIndex := ColorCombo.Items.IndexOf(ColorName);
      ColorNameEdit.Text := '';
    end
    else
    begin
      ColorCombo.ItemIndex := ColorCombo.Items.Count - 1;
      ColorNameEdit.Text := ColorName;
    end;
    ColorNameEdit.Enabled := ColorCombo.ItemIndex = ColorCombo.Items.Count - 1;
  end;

var
  i: Integer;
begin
  if ColCountCombo.Items.IndexOf(IntToStr(Settings.Width)) >= 0 then
    ColCountCombo.ItemIndex := ColCountCombo.Items.IndexOf(IntToStr(Settings.Width))
  else
    ColCountCombo.ItemIndex := FindBestChoiceForCombo(ColCountCombo.Items, Settings.Width);//ColCountCombo.Items.IndexOf('64');
  {
  if ColCountCombo.Items.IndexOf(IntToStr(ColCount)) >= 0 then
  begin
    ColCountCombo.ItemIndex := ColCountCombo.Items.IndexOf(IntToStr(ColCount));
    CustomColumnCountEdit.Hide;
  end
  else
  begin
    ColCountCombo.ItemIndex := ColCountCombo.Items.Count - 1;
    if ColCount < MINIMUM_COL_COUNT then
      ColCount := MINIMUM_COL_COUNT;
    CustomColumnCountEdit.Text := IntToStr(ColCount);
    CustomColumnCountEdit.Show;
  end;
  }

  if RowCountCombo.Items.IndexOf(IntToStr(Settings.Height)) >= 0 then
    RowCountCombo.ItemIndex := RowCountCombo.Items.IndexOf(IntToStr(Settings.Height))
  else
    RowCountCombo.ItemIndex := FindBestChoiceForCombo(RowCountCombo.Items, Settings.Height);//RowCountCombo.Items.IndexOf('16');
  {
  if RowCountCombo.Items.IndexOf(IntToStr(Settings.Height)) >= 0 then
  begin
    RowCountCombo.ItemIndex := RowCountCombo.Items.IndexOf(IntToStr(Settings.Height));
    CustomRowCountEdit.Hide;
  end
  else
  begin
    RowCountCombo.ItemIndex := RowCountCombo.Items.Count - 1;
    if Settings.Height < MINIMUM_ROW_COUNT then
      Settings.Height := MINIMUM_ROW_COUNT;
    CustomRowCountEdit.Text := IntToStr(Settings.Height);
    CustomRowCountEdit.Show;
  end;
  }

  if MemoryCombo.Items.IndexOf(IntToStr(Settings.Memory) + ' KB') >= 0 then
    MemoryCombo.ItemIndex := MemoryCombo.Items.IndexOf(IntToStr(Settings.Memory) + ' KB')
  else
  begin
    //Find closest match greater than to the value
    MemoryCombo.ItemIndex := -1;
    for i := 0 to MemoryCombo.Items.Count - 1 do
      if StrToInt(LeftStr(MemoryCombo.Items.Strings[i], Length(MemoryCombo.Items.Strings[i]) - Length(' KB'))) >= Settings.Memory then
      begin
        MemoryCombo.ItemIndex := i;
        Break;
      end;
    if not(MemoryCombo.ItemIndex >= 0) then
      MemoryCombo.ItemIndex := MemoryCombo.Items.Count - 1;  //Otherwise select maximum available memory
  end;

  CanShowDateTimeCheck.Checked := Settings.CanShowDateTime;
  CanShowTemperatureCheck.Checked := Settings.CanShowTemperature;
  CanShowScrollingTextCheck.Checked := Settings.CanShowScrollingText;
  CanShowPictureCheck.Checked := Settings.CanShowPicture;
  CanShowAnimationCheck.Checked := Settings.CanShowAnimation;
  CanShowTextEffectsCheck.Checked := Settings.CanShowTextEffects;
  CanShowPageEffectsCheck.Checked := Settings.CanShowPageEffects;
  CanChangePageLayoutCheck.Checked := Settings.CanChangePageLayout;
  //Alarm settings
  CanSetAlarmsCheck.Checked := Settings.CanSetAlarms;
  if Assigned(CanSetAlarmsCheck.OnClick) then
    CanSetAlarmsCheck.OnClick(CanSetAlarmsCheck);
  if Settings.CanSetAlarms then
  begin
    AlarmCountSpin.Value := Settings.AlarmCount;
    AlarmSystem12MonthCheck.Checked := (Settings.AlarmSystem = as12MonthAlarmSystem);
  end
  else
  begin
    AlarmCountSpin.Value := DEFAULT_LED_DISPLAY_ALARM_COUNT;
    AlarmSystem12MonthCheck.Checked := (DEFAULT_LED_DISPLAY_ALARM_SYSTEM = as12MonthAlarmSystem);
  end;
  //TimeSpan
  CanSetTimeSpanCheck.Checked := Settings.CanSetTimeSpan;

  DoubleColorRadio.Checked := Settings.ColorCount > 1;
  SingleColorRadio.Checked := not DoubleColorRadio.Checked;
  SingleColorRadio.OnClick(SingleColorRadio);

  if DoubleColorRadio.Checked then
  begin
    if Length(Trim(Settings.Color1)) = 0 then
      Settings.Color1 := ColorCombo1.Items.Strings[0];
    if Length(Trim(Settings.Color2)) = 0 then
      Settings.Color2 := ColorCombo2.Items.Strings[1];
    SetColorCombo(ColorCombo1, ColorNameEdit1, Settings.Color1);
    SetColorCombo(ColorCombo2, ColorNameEdit2, Settings.Color2);
  end
  else
  begin
    ColorNameEdit1.Text := '';
    ColorNameEdit2.Text := '';
    ColorCombo1.ItemIndex := 0;
    ColorCombo2.ItemIndex := 1;
  end;
  UpdateColorLabel3Caption;
end;

procedure TChangeDisplaySettingsForm.OKBtnClick(Sender: TObject);
begin
  OKClicked := True;
end;

procedure TChangeDisplaySettingsForm.SingleColorRadioClick(
  Sender: TObject);
begin
  ColorLabel1.Enabled := DoubleColorRadio.Checked;
  ColorLabel2.Enabled := DoubleColorRadio.Checked;
  ColorCombo1.Enabled := DoubleColorRadio.Checked;
  ColorCombo2.Enabled := DoubleColorRadio.Checked;
  ColorNameEdit1.Enabled := DoubleColorRadio.Checked and (ColorCombo1.ItemIndex = ColorCombo1.Items.Count - 1);
  ColorNameEdit2.Enabled := DoubleColorRadio.Checked and (ColorCombo2.ItemIndex = ColorCombo2.Items.Count - 1);
end;

procedure TChangeDisplaySettingsForm.ColorCombo1Change(Sender: TObject);
begin
  ColorNameEdit1.Enabled := ColorCombo1.ItemIndex = ColorCombo1.Items.Count - 1;
  if ColorNameEdit1.Enabled then
  begin
    MainForm.ChangeKeyboardLanguage(laFarsi);
    try
      ColorNameEdit1.SetFocus;
    except
    end;
  end;

  UpdateColorLabel3Caption;
end;

procedure TChangeDisplaySettingsForm.ColorCombo2Change(Sender: TObject);
begin
  ColorNameEdit2.Enabled := ColorCombo2.ItemIndex = ColorCombo2.Items.Count - 1;
  if ColorNameEdit2.Enabled then
  begin
    MainForm.ChangeKeyboardLanguage(laFarsi);
    try
      ColorNameEdit2.SetFocus;
    except
    end;
  end;

  UpdateColorLabel3Caption;
end;

procedure TChangeDisplaySettingsForm.ColCountComboChange(Sender: TObject);
begin
  {
  CustomColumnCountEdit.Visible := ColCountCombo.ItemIndex = (ColCountCombo.Items.Count - 1);
  if CustomColumnCountEdit.Visible then
  begin
    CustomColumnCountEdit.Text := IntToStr(ColCount);
    CustomColumnCountEdit.SetFocus;
  end;
  }
end;

procedure TChangeDisplaySettingsForm.RowCountComboChange(Sender: TObject);
begin
  {
  CustomRowCountEdit.Visible := RowCountCombo.ItemIndex = (RowCountCombo.Items.Count - 1);
  if CustomRowCountEdit.Visible then
  begin
    CustomRowCountEdit.Text := IntToStr(Settings.Height);
    CustomRowCountEdit.SetFocus;
  end;
  }
end;

procedure TChangeDisplaySettingsForm.TntFormCloseQuery(Sender: TObject;
  var CanClose: Boolean);

  function GetColorCombo(AColorCombo: TsComboBox; AColorNameEdit: TsEdit): WideString;
  begin
    if AColorCombo.ItemIndex = AColorCombo.Items.Count - 1 then
    begin
      if Length(Trim(AColorNameEdit.Text)) > 0 then
        Result := Trim(AColorNameEdit.Text)
      else
        Result := '';
    end
    else
      Result := AColorCombo.Items.Strings[AColorCombo.ItemIndex];
  end;

var
  NewColCount, NewRowCount: Integer;
begin
  try

  CanClose := True;
  if OKClicked then
  begin
    NewColCount := StrToInt(ColCountCombo.Items.Strings[ColCountCombo.ItemIndex]);
    if (NewColCount < MINIMUM_COL_COUNT) or (NewColCount > MAXIMUM_COL_COUNT) then
      CanClose := False;
    if not CanClose then
    begin
      if CustomColumnCountEdit.Enabled and CustomColumnCountEdit.Visible then  //Prevent potential software bugs
        CustomColumnCountEdit.SetFocus;
      WideMessageDlgSoundTop(Dyn_Texts[78] {'Please enter a valid value for the number of columns.'}, mtError, [mbOK], 0);
      Exit;
    end;
    (*
    if ColCountCombo.ItemIndex = (ColCountCombo.Items.Count - 1) then
    begin
      if Procs.IsValidInt(CustomColumnCountEdit.Text) then
      begin
        NewColCount := StrToInt(CustomColumnCountEdit.Text);
      end
      else
        CanClose := False;
    end
    else
      NewColCount := StrToInt(ColCountCombo.Items.Strings[ColCountCombo.ItemIndex]);
    if not CanClose then
    begin
      CustomColumnCountEdit.SetFocus;
      WideMessageDlgSoundTop(Dyn_Texts[78] {'Please enter a valid value for the number of columns.'}, mtError, [mbOK], 0);
      Exit;
    end;
    *)

    NewRowCount := StrToInt(RowCountCombo.Items.Strings[RowCountCombo.ItemIndex]);
    if (NewRowCount < MINIMUM_ROW_COUNT) or (NewRowCount > MAXIMUM_ROW_COUNT) then
      CanClose := False;
    if not CanClose then
    begin
      if CustomRowCountEdit.Enabled and CustomRowCountEdit.Visible then  //Prevent potential software bugs
        CustomRowCountEdit.SetFocus;
      WideMessageDlgSoundTop(Dyn_Texts[79] {'Please enter a valid value for the number of rows.'}, mtError, [mbOK], 0);
      Exit;
    end;
    (*
    if RowCountCombo.ItemIndex = (RowCountCombo.Items.Count - 1) then
    begin
      if Procs.IsValidInt(CustomRowCountEdit.Text) then
      begin
        NewRowCount := StrToInt(CustomRowCountEdit.Text);
      end
      else
        CanClose := False;
    end
    else
      NewRowCount := StrToInt(RowCountCombo.Items.Strings[RowCountCombo.ItemIndex]);
    if (NewRowCount < MINIMUM_ROW_COUNT) or (NewRowCount > MAXIMUM_ROW_COUNT) then
      CanClose := False;
    if not CanClose then
    begin
      if CustomRowCountEdit.Enabled and CustomRowCountEdit.Visible then  //Prevent potential software bugs
        CustomRowCountEdit.SetFocus;
      WideMessageDlgSoundTop(Dyn_Texts[79] {'Please enter a valid value for the number of rows.'}, mtError, [mbOK], 0);
      Exit;
    end;
    *)

    Settings.Width := NewColCount;
    Settings.Height := NewRowCount;
    Settings.Memory := StrToInt(LeftStr(MemoryCombo.Items.Strings[MemoryCombo.ItemIndex], Length(MemoryCombo.Items.Strings[MemoryCombo.ItemIndex]) - 3));

    Settings.CanShowDateTime := CanShowDateTimeCheck.Checked;
    Settings.CanShowTemperature := CanShowTemperatureCheck.Checked;
    Settings.CanShowScrollingText := CanShowScrollingTextCheck.Checked;
    Settings.CanShowPicture := CanShowPictureCheck.Checked;
    Settings.CanShowAnimation := CanShowAnimationCheck.Checked;
    Settings.CanShowTextEffects := CanShowTextEffectsCheck.Checked;
    Settings.CanShowPageEffects := CanShowPageEffectsCheck.Checked;
    Settings.CanChangePageLayout := CanChangePageLayoutCheck.Checked;
    Settings.CanSetAlarms := CanSetAlarmsCheck.Checked;
    if CanSetAlarmsCheck.Checked then
    begin
      Settings.AlarmCount := AlarmCountSpin.Value;
      if AlarmSystem12MonthCheck.Checked then
        Settings.AlarmSystem := as12MonthAlarmSystem
      else
        Settings.AlarmSystem := as1MonthAlarmSystem;
    end
    else
    begin
      Settings.AlarmCount := DEFAULT_LED_DISPLAY_ALARM_COUNT;
      Settings.AlarmSystem := DEFAULT_LED_DISPLAY_ALARM_SYSTEM;
    end;
    Settings.CanSetTimeSpan := CanSetTimeSpanCheck.Checked;

    if GetColorCombo(ColorCombo1, ColorNameEdit1) <> '' then
      Settings.Color1 := GetColorCombo(ColorCombo1, ColorNameEdit1);
    if GetColorCombo(ColorCombo2, ColorNameEdit2) <> '' then
      Settings.Color2 := GetColorCombo(ColorCombo2, ColorNameEdit2);

    if SingleColorRadio.Checked then
      Settings.ColorCount := 1
    else
      Settings.ColorCount := 2;

  end;

  finally

  OKClicked := False;

  end;
end;

procedure TChangeDisplaySettingsForm.TntFormShow(Sender: TObject);
begin
  HighGUITimer.Enabled := True;

  OKClicked := False;
end;

procedure TChangeDisplaySettingsForm.UpdateColorLabel3Caption;
var
  Color1Name, Color2Name: WideString;
begin
  if ColorNameEdit1.Enabled then
    Color1Name := ColorNameEdit1.Text
  else
    Color1Name := ColorCombo1.Text;

  if ColorNameEdit2.Enabled then
    Color2Name := ColorNameEdit2.Text
  else
    Color2Name := ColorCombo2.Text;

  ColorLabel3.Caption := WideFormat(ColorLabel3FormatLabel.Caption, [Color1Name, Color2Name]);
end;

procedure TChangeDisplaySettingsForm.ColorNameEdit1Change(Sender: TObject);
begin
  UpdateColorLabel3Caption;
end;

procedure TChangeDisplaySettingsForm.ColorNameEdit2Change(Sender: TObject);
begin
  UpdateColorLabel3Caption;
end;

procedure TChangeDisplaySettingsForm.LEDDisplayToolsBtnClick(
  Sender: TObject);
begin
  //TntXPMenu1.Active := not TntXPMenu1.Active;
  //TntXPMenu1.Active := not TntXPMenu1.Active;

  SpecialProcs.PopupMenuAtControl(LEDDisplayToolsBtn, LEDDisplayToolsPopup);
end;

procedure TChangeDisplaySettingsForm.N1Click(Sender: TObject);
begin
  LEDDisplayDataResetForm.ShowModal;
end;

procedure TChangeDisplaySettingsForm.HighGUITimerTimer(Sender: TObject);
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

procedure TChangeDisplaySettingsForm.TntFormCreate(Sender: TObject);
var
  i: Integer;
begin
  AlarmCountSpin.MaxValue := MAX_LED_DISPLAY_ALARM_COUNT;
  
  //Build RowCountCombo items
  RowCountCombo.Items.Clear;
  for i := Low(LED_DISPLAY_SELECTABLE_ROW_COUNTS) to High(LED_DISPLAY_SELECTABLE_ROW_COUNTS) do
    if LED_DISPLAY_SELECTABLE_ROW_COUNTS[i] <= License._LED_DISPLAY_MAX_ROW_COUNT_ then
      RowCountCombo.Items.Append(IntToStr(LED_DISPLAY_SELECTABLE_ROW_COUNTS[i]));
    //else
    //  Break;
  if RowCountCombo.Items.Count > 0 then
    RowCountCombo.ItemIndex := 0;

  //Build ColCountCombo items
  ColCountCombo.Items.Clear;
  for i := Low(LED_DISPLAY_SELECTABLE_COL_COUNTS) to High(LED_DISPLAY_SELECTABLE_COL_COUNTS) do
    if LED_DISPLAY_SELECTABLE_COL_COUNTS[i] <= _LED_DISPLAY_MAX_COL_COUNT_ then
      ColCountCombo.Items.Append(IntToStr(LED_DISPLAY_SELECTABLE_COL_COUNTS[i]));
    //else
    //  Break;
  if ColCountCombo.Items.Count > 0 then
    ColCountCombo.ItemIndex := 0;

  //Build MemoryCombo items
  MemoryCombo.Items.Clear;
  for i := Low(LED_DISPLAY_SELECTABLE_MEMORIES) to High(LED_DISPLAY_SELECTABLE_MEMORIES) do
    MemoryCombo.Items.Append(IntToStr(LED_DISPLAY_SELECTABLE_MEMORIES[i]) + ' KB');
  if MemoryCombo.Items.Count > 0 then
    MemoryCombo.ItemIndex := 0;

  HighGUIInitialize;
end;

procedure TChangeDisplaySettingsForm.TntFormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  HighGUITimer.Enabled := False;
end;

procedure TChangeDisplaySettingsForm.HighGUIInitialize;
begin
  SetLength(HighGUIItems, 4);

  HighGUIItems[0] := SizeSettingsGroup;
  HighGUIItems[1] := MemorySettingsGroup;
  HighGUIItems[2] := CapabilitiesGroup;
  HighGUIItems[3] := ColorSettingsGroup;
end;

procedure TChangeDisplaySettingsForm.CanSetAlarmsCheckClick(
  Sender: TObject);
begin
  AlarmCountLabel.Enabled := CanSetAlarmsCheck.Checked;
  AlarmCountSpin.Enabled := CanSetAlarmsCheck.Checked;
  AlarmSystem12MonthCheck.Enabled := CanSetAlarmsCheck.Checked;
end;

procedure TChangeDisplaySettingsForm.GetConfigurationBtnClick(
  Sender: TObject);
begin
  //Show menu or run direct?
  if GlobalOptions.NumOfLEDDisplays = 1 then
    //Run direct
    GetConfigurationMenuItem1.Click
  else
    //Show menu
    SpecialProcs.PopupMenuAtControl(GetConfigurationBtn, LEDDisplayGetConfigurationBtnPopup);
end;

procedure TChangeDisplaySettingsForm.GetConfigurationMenuItem1Click(
  Sender: TObject);
begin
  GetLEDDisplayConfiguration(1);
end;

procedure TChangeDisplaySettingsForm.GetConfigurationMenuItem2Click(
  Sender: TObject);
begin
  GetLEDDisplayConfiguration(2);
end;

procedure TChangeDisplaySettingsForm.GetLEDDisplayConfiguration(
  LEDDisplayNumber: Integer);
var
  LEDDisplayConfiguration: TLEDDisplayConfiguration;
begin
  if ProgrammerForm.GetConfiguration(LEDDisplayConfiguration, LEDDisplayNumber) then
  begin
    ApplyLEDDisplayConfiguration(LEDDisplayConfiguration);
  end;
end;

function TChangeDisplaySettingsForm.FindBestChoiceForCombo(Items: TTntStrings; Value: Integer): Integer;
var
  i: Integer;
begin
  for i := 0 to Items.Count - 1 do
    if StrToInt(Items.Strings[i]) >= Value then
    begin
      Result := i;
      Exit;
    end;
  //If no choise found, the greatest available value is the best choice
  Result := Items.Count - 1;
end;

procedure TChangeDisplaySettingsForm.ApplyLEDDisplayConfiguration(
  const LEDDisplayConfiguration: TLEDDisplayConfiguration);
var
  MemorySize: Integer;
  i: Integer;
begin
  with LEDDisplayConfiguration do
  begin
    //Memory is always valid both for LED Display and the portable memory
    //Memory
    MemorySize := EEPROMICCount * EEPROMICSize;  //in bytes
    MemoryCombo.ItemIndex := MemoryCombo.Items.Count - 1;  //Set the maximum selectable memory size as default
    for i := 0 to MemoryCombo.Items.Count - 1 do
      if (StrToInt(LeftStr(MemoryCombo.Items.Strings[i], Length(MemoryCombo.Items.Strings[i]) - Length(' KB'))) * 1024) >= MemorySize then
      begin
        MemoryCombo.ItemIndex := i;
        Break;
      end;

    ///////////////////////////////////////
    //If this is a portable memory, other settings is not valid at all, so return while displaying a message
    if PortableMemory then
    begin
      WideShowMessageSoundTop(Dyn_Texts[130] {'This is LED Display portable memory connected to the port and only its memory size is received. To view the LED Display settings, please connect the LED Display itself to the port.'});
      Exit;
    end;
    ///////////////////////////////////////

    //Row Count
    if RowCountCombo.IndexOf(IntToStr(MaxRowCount)) >= 0 then
      RowCountCombo.ItemIndex := RowCountCombo.IndexOf(IntToStr(MaxRowCount))
    else
      RowCountCombo.ItemIndex := FindBestChoiceForCombo(RowCountCombo.Items, MaxRowCount);
    //Custom row count is not available in this version
    if Assigned(RowCountCombo.OnChange) then
      RowCountCombo.OnChange(RowCountCombo);
    (*
    //Row Count
    if RowCountCombo.IndexOf(IntToStr(MaxRowCount)) >= 0 then
      RowCountCombo.ItemIndex := RowCountCombo.IndexOf(IntToStr(MaxRowCount))
    else
    begin
      if (MaxRowCount >= MINIMUM_ROW_COUNT) and (MaxRowCount <= MAXIMUM_ROW_COUNT) then
      begin
        RowCountCombo.ItemIndex := RowCountCombo.Items.Count - 1;
        CustomRowCountEdit.Text := IntToStr(MaxRowCount);
      end;
    end;
    if Assigned(RowCountCombo.OnChange) then
      RowCountCombo.OnChange(RowCountCombo);
    *)

    //Column Count
    if ColCountCombo.IndexOf(IntToStr(MaxColCount)) >= 0 then
      ColCountCombo.ItemIndex := ColCountCombo.IndexOf(IntToStr(MaxColCount))
    else
      ColCountCombo.ItemIndex := FindBestChoiceForCombo(ColCountCombo.Items, MaxColCount);
    //Custom column count is not available in this version
    if Assigned(ColCountCombo.OnChange) then
      ColCountCombo.OnChange(ColCountCombo);

    //---------------------------------------------------------
    CanShowDateTimeCheck.Checked := TimeActive;
    CanShowTemperatureCheck.Checked := TemperatureActive;
    CanShowScrollingTextCheck.Checked := ScrollingTextActive;
    CanShowPictureCheck.Checked := ScrollingTextActive;
    CanShowAnimationCheck.Checked := AnimationActive;
    CanShowTextEffectsCheck.Checked := TextAnimationsActive;
    CanShowPageEffectsCheck.Checked := PageEffectsActive;
    CanChangePageLayoutCheck.Checked := StageLayoutActive;
    CanSetTimeSpanCheck.Checked := TimeSpanActive;
    CanSetAlarmsCheck.Checked := AlarmActive;
    if Assigned(CanSetAlarmsCheck.OnClick) then
      CanSetAlarmsCheck.OnClick(CanSetAlarmsCheck);
    if AlarmActive then
    begin
      AlarmCountSpin.Value := MaxAlarmCountPerMonth;
      AlarmSystem12MonthCheck.Checked := AlarmSystem = as12MonthAlarmSystem;
    end;

    //---------------------------------------------------------
    if _COLOR_DISPLAY_METHOD_1_ or _COLOR_DISPLAY_METHOD_2_ then  //Only set Checked property in this way, not direct assignment of comparison of values
      DoubleColorRadio.Checked := True
    else
      SingleColorRadio.Checked := True;
    if Assigned(SingleColorRadio.OnClick) then
      SingleColorRadio.OnClick(SingleColorRadio);
  end;
end;

procedure TChangeDisplaySettingsForm.LEDDisplayGetConfigurationBtnMenuItem1Click(
  Sender: TObject);
begin
  GetConfigurationMenuItem1.Click;
end;

procedure TChangeDisplaySettingsForm.LEDDisplayGetConfigurationBtnMenuItem2Click(
  Sender: TObject);
begin
  GetConfigurationMenuItem2.Click;
end;

procedure TChangeDisplaySettingsForm.LEDDisplayToolsPopupPopup(
  Sender: TObject);
begin
  GetConfigurationMenuItem.Visible := GlobalOptions.NumOfLEDDisplays = 1;
  GetConfigurationWithSubMenuMenuItem.Visible := GlobalOptions.NumOfLEDDisplays > 1;
end;

procedure TChangeDisplaySettingsForm.GetConfigurationMenuItemClick(
  Sender: TObject);
begin
  if GlobalOptions.NumOfLEDDisplays = 1 then
    GetConfigurationMenuItem1.Click;
end;

end.
