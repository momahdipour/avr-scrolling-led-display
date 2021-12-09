unit ProgramOptionsFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, TntForms, sSkinProvider, StdCtrls, sComboBox, sLabel, Buttons,
  TntButtons, sBitBtn, TntStdCtrls, sGroupBox, UnitKDCommon,
  UnitKDSerialPort, ComCtrls, sTrackBar, TntComCtrls, TntDelayedTrackBar,
  sDelayedTrackBar, sCheckBox, TntSysUtils, TntClasses, GlobalTypes,
  sSpeedButton, MPlayer, TntDialogs, ProcsUnit, ExtCtrls, SoundDialogs;

type
  TProgramOptionsForm = class(TTntForm)
    sSkinProvider1: TsSkinProvider;
    ConnectionGroup: TsGroupBox;
    OKBtn: TsBitBtn;
    CancelBtn: TsBitBtn;
    PortLabel1: TsLabel;
    PortCombo1: TsComboBox;
    AppearanceGroup: TsGroupBox;
    HueOffsetTrackBar: TsDelayedTrackBar;
    SkinTrackBar: TsDelayedTrackBar;
    sLabel2: TsLabel;
    sLabel3: TsLabel;
    sLabel4: TsLabel;
    PortLabel2: TsLabel;
    PortCombo2: TsComboBox;
    NumOfLEDDisplaysCombo: TsComboBox;
    OtherSettingsGroup: TsGroupBox;
    SelectPageEffectOnNewStageCheck: TsCheckBox;
    SelectPageLayoutOnNewStageCheck: TsCheckBox;
    DefaultAppearanceBtn: TsBitBtn;
    DontUseHighGUICheck: TsCheckBox;
    SoundsGroup: TsGroupBox;
    PlaySoundOnDataChangeFinishedCheck: TsCheckBox;
    SoundsCombo: TsComboBox;
    PlaySoundBtn: TsSpeedButton;
    MediaPlayer1: TMediaPlayer;
    OpenSoundDialog: TTntOpenDialog;
    AutomaticallyRefreshTimePreviewCheck: TsCheckBox;
    HighGUITimer: TTimer;
    procedure OKBtnClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure HueOffsetTrackBarDelayedChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure SkinTrackBarDelayedChange(Sender: TObject);
    procedure CancelBtnClick(Sender: TObject);
    procedure NumOfLEDDisplaysComboChange(Sender: TObject);
    procedure DefaultAppearanceBtnClick(Sender: TObject);
    procedure PlaySoundBtnClick(Sender: TObject);
    procedure SoundsComboChange(Sender: TObject);
    procedure TntFormClose(Sender: TObject; var Action: TCloseAction);
    procedure PlaySoundOnDataChangeFinishedCheckClick(Sender: TObject);
    procedure TntFormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure HighGUITimerTimer(Sender: TObject);
  private
    { Private declarations }
    HighGUIItems: THighGUIItems;

    OKClicked, CancelClicked, AllowToClose: Boolean;
    CurrentSoundOptions: TSoundOptions;

    LoadingConfig: Boolean;

    OldSoundComboItemIndex: Integer; 

    procedure BuildSoundList(const SoundFileToSelect: WideString);

    procedure HighGUIInitialize;
  public
    { Public declarations }
    procedure LoadConfig;
    procedure SaveConfig;
    procedure CancelConfig;
  end;

var
  ProgramOptionsForm: TProgramOptionsForm;

implementation

uses MainUnit;

{$R *.dfm}

procedure TProgramOptionsForm.SaveConfig;

  function GetPortNum(PortNumber: Integer): TPortNumber;
  begin
    case PortNumber of
      1: Result := pnCOM1;
      2: Result := pnCOM2;
      3: Result := pnCOM3;
      4: Result := pnCOM4;
      5: Result := pnCOM5;
      6: Result := pnCOM6;
      7: Result := pnCOM7;
      8: Result := pnCOM8;
      9: Result := pnCOM9;
      10: Result := pnCOM10;
      11: Result := pnCOM11;
      12: Result := pnCOM12;
      13: Result := pnCOM13;
      14: Result := pnCOM14;
      15: Result := pnCOM15;
      16: Result := pnCOM16;
      else
        Result := pnCOM1;
    end;
  end;

begin
  with GlobalOptions do
  begin
    //Connection settings
    NumOfLEDDisplays := StrToInt(NumOfLEDDisplaysCombo.Items[NumOfLEDDisplaysCombo.ItemIndex]);
    ComPort1 := GetPortNum(PortCombo1.ItemIndex + 1);
    ComPort2 := GetPortNum(PortCombo2.ItemIndex + 1);

    //Appearance settings
    HueOffset := HueOffsetTrackBar.Position;
    SkinNumber := SkinTrackBar.Position;
    DontUseHighGUI := DontUseHighGUICheck.Checked;

    //Other settings
    SelectPageEffectOnNewStage := SelectPageEffectOnNewStageCheck.Checked;
    SelectPageLayoutOnNewStage := SelectPageLayoutOnNewStageCheck.Checked;

    AutomaticallyRefreshTimePreview := AutomaticallyRefreshTimePreviewCheck.Checked;

    if PlaySoundOnDataChangeFinishedCheck.Checked then
      SoundOptions.LEDDisplayDataChangeFinishedSoundFileName := CurrentSoundOptions.LEDDisplayDataChangeFinishedSoundFileName
    else
      SoundOptions.LEDDisplayDataChangeFinishedSoundFileName := '';  //Means no sound
  end;
end;

procedure TProgramOptionsForm.OKBtnClick(Sender: TObject);
begin
  AllowToClose := True;
  if StrToInt(NumOfLEDDisplaysCombo.Items.Strings[NumOfLEDDisplaysCombo.ItemIndex]) > 1 then
  begin
    if PortCombo1.Enabled and PortCombo2.Enabled then
      if PortCombo1.ItemIndex = PortCombo2.ItemIndex then
      begin
        if WideMessageDlgSoundTop(Dyn_Texts[104] {'You have selected the same connection port for your LED Displays. Are you sure?'}, mtConfirmation, [mbYes, mbNo], 0) = mrNo then
        begin
          AllowToClose := False;
          Exit;
        end;
      end;
  end;

  OKClicked := True;
  SaveConfig;
end;

procedure TProgramOptionsForm.LoadConfig;
begin
  LoadingConfig := True;

  //Connection settings
  //***Don't write this statement inside a with-end block
  try
    NumOfLEDDisplaysCombo.ItemIndex := NumOfLEDDisplaysCombo.Items.IndexOf(IntToStr(GlobalOptions.NumOfLEDDisplays))
  except
    NumOfLEDDisplaysCombo.ItemIndex := 0;
  end;

  try
    PortCombo1.ItemIndex := Integer(GlobalOptions.ComPort1);  //Don't write this statement inside a with-end block
    PortCombo2.ItemIndex := Integer(GlobalOptions.ComPort2);  //Don't write this statement inside a with-end block
  except
    PortCombo1.ItemIndex := 0;
    PortCombo2.ItemIndex := PortCombo1.ItemIndex + 1;
  end;

  if (GlobalOptions.NumOfLEDDisplays = 1) and (PortCombo1.ItemIndex = PortCombo2.ItemIndex) then
  begin
    try
      PortCombo2.ItemIndex := PortCombo1.ItemIndex + 1;
    except
      PortCombo2.ItemIndex  := 0;
    end;
  end;

  NumOfLEDDisplaysCombo.OnChange(NumOfLEDDisplaysCombo);

  with GlobalOptions do
  begin
    //Appearance settings
    HueOffsetTrackBar.Position := HueOffset;
    HueOffsetTrackBar.CancelPendingDelay;
    SkinTrackBar.Position := SkinNumber;
    SkinTrackBar.CancelPendingDelay;
    DontUseHighGUICheck.Checked := DontUseHighGUI;

    //Other settings
    SelectPageEffectOnNewStageCheck.Checked := SelectPageEffectOnNewStage;
    SelectPageLayoutOnNewStageCheck.Checked := SelectPageLayoutOnNewStage;

    AutomaticallyRefreshTimePreviewCheck.Checked := AutomaticallyRefreshTimePreview;

    CurrentSoundOptions := SoundOptions;
    BuildSoundList(SoundOptions.LEDDisplayDataChangeFinishedSoundFileName);
    PlaySoundOnDataChangeFinishedCheck.Checked := Length(SoundOptions.LEDDisplayDataChangeFinishedSoundFileName) > 0;
    if WideExtractFilePath(SoundOptions.LEDDisplayDataChangeFinishedSoundFileName) = (ApplicationPath + SOUNDS_FOLDER_NAME + '\') then
      SoundsCombo.ItemIndex := SoundsCombo.Items.IndexOf(Procs.WideExtractFileNameWithoutExt(SoundOptions.LEDDisplayDataChangeFinishedSoundFileName))
    else
    begin
      if WideFileExists(SoundOptions.LEDDisplayDataChangeFinishedSoundFileName) then
      begin
        SoundsCombo.OnChange := nil;  //We don't want to show open dialog
        SoundsCombo.ItemIndex := SoundsCombo.Items.Count - 1;
        SoundsCombo.OnChange := SoundsComboChange;
      end
      else
      begin
        if SoundsCombo.Items.Count > 1 then  //don't include the first item
          SoundsCombo.ItemIndex := 0;
      end;
    end;
    if Assigned(PlaySoundOnDataChangeFinishedCheck.OnClick) then
      PlaySoundOnDataChangeFinishedCheck.OnClick(PlaySoundOnDataChangeFinishedCheck);  //Force to update
  end;

  LoadingConfig := False;
end;

procedure TProgramOptionsForm.FormShow(Sender: TObject);
begin
  HighGUITimer.Enabled := True;

  OKClicked := False;
  CancelClicked := False;
  AllowToClose := True;
  
  LoadConfig;
  NumOfLEDDisplaysCombo.SetFocus;
end;

procedure TProgramOptionsForm.HueOffsetTrackBarDelayedChange(
  Sender: TObject);
begin
  MainForm.sSkinManager1.HueOffset := HueOffsetTrackBar.Position;
  Self.BringToFront;
end;

procedure TProgramOptionsForm.FormCreate(Sender: TObject);
begin
  HighGUIInitialize;

  SkinTrackBar.Max := SKIN_COUNT;

  OldSoundComboItemIndex := SoundsCombo.ItemIndex;
end;

procedure TProgramOptionsForm.SkinTrackBarDelayedChange(Sender: TObject);
begin
  //Application.Minimize;

  MainForm.SetSkin(SkinTrackBar.Position);
  Self.BringToFront;
  
  //Application.Restore;
  //Application.BringToFront;
  //Application.ProcessMessages;
end;

procedure TProgramOptionsForm.CancelConfig;
begin
  with GlobalOptions do
  begin
    if MainForm.sSkinManager1.HueOffset <> HueOffset then
      MainForm.sSkinManager1.HueOffset := HueOffset;
    if MainForm.GetSkinNumber <> SkinNumber then
      MainForm.SetSkin(SkinNumber);
  end;
end;

procedure TProgramOptionsForm.CancelBtnClick(Sender: TObject);
begin
  CancelClicked := True;
  CancelConfig;
end;

procedure TProgramOptionsForm.NumOfLEDDisplaysComboChange(Sender: TObject);
begin
  PortCombo2.Enabled := StrToInt(NumOfLEDDisplaysCombo.Items.Strings[NumOfLEDDisplaysCombo.ItemIndex]) > 1;
  PortLabel2.Enabled := PortCombo2.Enabled;
end;

procedure TProgramOptionsForm.DefaultAppearanceBtnClick(Sender: TObject);
begin
  //Connection settings
  NumOfLEDDisplaysCombo.ItemIndex := NumOfLEDDisplaysCombo.Items.IndexOf('1');
  NumOfLEDDisplaysCombo.OnChange(NumOfLEDDisplaysCombo);
  PortCombo1.ItemIndex := 0;
  PortCombo2.ItemIndex := 1;

  //Load and apply default appearance settings
  HueOffsetTrackBar.Position := RuntimeGlobalOptions.AppearanceDefaultHueOffset;
  HueOffsetTrackBar.CancelPendingDelay;
  SkinTrackBar.Position := RuntimeGlobalOptions.AppearanceDefaultSkinNumber;
  SkinTrackBar.CancelPendingDelay;
  
  if MainForm.sSkinManager1.HueOffset <> RuntimeGlobalOptions.AppearanceDefaultHueOffset then
    MainForm.sSkinManager1.HueOffset := RuntimeGlobalOptions.AppearanceDefaultHueOffset;
  if MainForm.GetSkinNumber <> RuntimeGlobalOptions.AppearanceDefaultSkinNumber then
    MainForm.SetSkin(RuntimeGlobalOptions.AppearanceDefaultSkinNumber);

  //Other settings
  SelectPageEffectOnNewStageCheck.Checked := True;
  SelectPageLayoutOnNewStageCheck.Checked := False;

  AutomaticallyRefreshTimePreviewCheck.Checked := True;
end;

procedure TProgramOptionsForm.BuildSoundList(
  const SoundFileToSelect: WideString);

  function IsSoundFileExt(const FileExt: WideString): Boolean;
  begin
    Result := (WideLowerCase(FileExt) = '.wav') or (WideLowerCase(FileExt) = '.mp3');
  end;
var
  i: Integer;
  FSR: TSearchRecW;
  SoundsList: TTntStringList;
begin
  //Get list of all sound files (*.wav, *.mp3) in the SOUNDS_FOLDER_NAME folder
  SoundsList := TTntStringList.Create;
  if WideFindFirst(ApplicationPath + SOUNDS_FOLDER_NAME + '\*.*', faAnyFile, FSR) = 0 then
  begin
    repeat
      if ((FSR.Attr and faSysFile)=0) and
         ((FSR.Attr and faSymLink)=0) and
         ((FSR.Attr and faVolumeID)=0) then
      begin
        if ((FSR.Attr and faDirectory) = 0) and
           (FSR.Name[1] <> '.') then
        begin
          if WideFileExists(ApplicationPath + SOUNDS_FOLDER_NAME + '\' + FSR.Name) and
             IsSoundFileExt(WideExtractFileExt(FSR.Name)) then
            SoundsList.Append(ApplicationPath + SOUNDS_FOLDER_NAME + '\' + FSR.Name);
        end;
      end;
    until WideFindNext(FSR) <> 0;
  end;
  WideFindClose(FSR);

  SoundsList.Sorted := True;
  
  SoundsCombo.Items.Clear;
  for i := 0 to SoundsList.Count - 1 do
    SoundsCombo.Items.Append(Procs.WideExtractFileNameWithoutExt(SoundsList.Strings[i]));
  SoundsCombo.Items.Append(Dyn_Texts[89] + #10 {'Other files...' + #10});  //Add #10 to not to allow the user to create a file with the same name as this item!!!

  if SoundsList.IndexOf(SoundFileToSelect) >= 0 then
    SoundsCombo.ItemIndex := SoundsList.IndexOf(SoundFileToSelect)
  else
    SoundsCombo.ItemIndex := 0;

  SoundsList.Free;
end;

procedure TProgramOptionsForm.PlaySoundBtnClick(Sender: TObject);
begin
  MediaPlayer1.FileName := CurrentSoundOptions.LEDDisplayDataChangeFinishedSoundFileName;
  try
    MediaPlayer1.Open;
    MediaPlayer1.Play;
  except
  end;
end;

procedure TProgramOptionsForm.SoundsComboChange(Sender: TObject);
begin
  try
    MediaPlayer1.Stop;
  except
  end;

  if SoundsCombo.ItemIndex = (SoundsCombo.Items.Count - 1) then
  begin
    //Other files selected
    if OpenSoundDialog.Execute then
      CurrentSoundOptions.LEDDisplayDataChangeFinishedSoundFileName := OpenSoundDialog.FileName
    else
    begin
      if WideExtractFilePath(CurrentSoundOptions.LEDDisplayDataChangeFinishedSoundFileName) = (ApplicationPath + SOUNDS_FOLDER_NAME + '\') then
        SoundsCombo.ItemIndex := SoundsCombo.Items.IndexOf(Procs.WideExtractFileNameWithoutExt(CurrentSoundOptions.LEDDisplayDataChangeFinishedSoundFileName))
      else
      begin
        if (OldSoundComboItemIndex >= 0) and (OldSoundComboItemIndex < (SoundsCombo.Items.Count - 1 {must not include the last item because it is for external sound files})) then  //Prevent potential software bugs
          SoundsCombo.ItemIndex := OldSoundComboItemIndex
        else
          SoundsCombo.ItemIndex := 0;
        if Assigned(SoundsCombo.OnChange) then
          SoundsCombo.OnChange(SoundsCombo);
      end;
    end;
  end
  else
  begin
    if WideFileExists(ApplicationPath + SOUNDS_FOLDER_NAME + '\*.wav') then
      CurrentSoundOptions.LEDDisplayDataChangeFinishedSoundFileName := ApplicationPath + SOUNDS_FOLDER_NAME + '\' + SoundsCombo.Items.Strings[SoundsCombo.ItemIndex] + '.wav'
    else
      CurrentSoundOptions.LEDDisplayDataChangeFinishedSoundFileName := ApplicationPath + SOUNDS_FOLDER_NAME + '\' + SoundsCombo.Items.Strings[SoundsCombo.ItemIndex] + '.mp3';
  end;

  OldSoundComboItemIndex := SoundsCombo.ItemIndex;
end;

procedure TProgramOptionsForm.TntFormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  HighGUITimer.Enabled := False;

  try
    MediaPlayer1.Stop;
  except
  end;

  try
    MediaPlayer1.Close;  //Close the opened file to allow access to it by other parts of the program later
  except
  end;
end;

procedure TProgramOptionsForm.PlaySoundOnDataChangeFinishedCheckClick(
  Sender: TObject);
begin
  SoundsCombo.Enabled := PlaySoundOnDataChangeFinishedCheck.Checked;
  PlaySoundBtn.Enabled := PlaySoundOnDataChangeFinishedCheck.Checked;
  if Assigned(SoundsCombo.OnChange) and not LoadingConfig then
    SoundsCombo.OnChange(SoundsCombo);
end;

procedure TProgramOptionsForm.TntFormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  if not AllowToClose then
  begin
    AllowToClose := True;
    CanClose := False;
    Exit;
  end;
  if not OKClicked then
  begin
    if not CancelClicked then
      CancelBtn.Click;
  end;
end;

procedure TProgramOptionsForm.HighGUITimerTimer(Sender: TObject);
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

procedure TProgramOptionsForm.HighGUIInitialize;
begin
  SetLength(HighGUIItems, 4);

  HighGUIItems[0] := ConnectionGroup;
  HighGUIItems[1] := AppearanceGroup;
  HighGUIItems[2] := SoundsGroup;
  HighGUIItems[3] := OtherSettingsGroup;
end;

end.
