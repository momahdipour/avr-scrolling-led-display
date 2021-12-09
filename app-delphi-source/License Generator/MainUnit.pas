unit MainUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, Buttons, cls_id, DCPcast128, DCPsha1,
  Clipbrd, ExtCtrls, TntStdCtrls, m1, m1Alarm, m1LFG, m1LFGAlarm,
  m2, m2Alarm, m2LFG, m2LFGAlarm, m3, m3Alarm, m3LFG, m3LFGAlarm,
  BRm1, BRm2, BRm3,
  ColorModel, Jpeg, IniFiles, PreviewFormUnit;

const
  INI_FILENAME = 'settings.ini';
  HexDigits = ['0', '1', '2', '3', '4', '5', '6', '7', '8',
               '9', 'A', 'B', 'C', 'D', 'E', 'F'];

  MAX_TRY_COUNT = 3;

var
  GLOBAL_ENCRYPTION_KEY: String;
  //REG_ENCODE_KEY: String;  --> Only is used into the program at runtime

  //Encryption keys
  ENCRYPTION_KEYS : array[0..15] of String[13];

type
  TMainForm = class(TForm)
    MainPanel: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    GenerateCUIDBtn: TSpeedButton;
    CUIDWord4: TEdit;
    CUIDWord3: TEdit;
    CUIDWord2: TEdit;
    CUIDWord1: TEdit;
    GenerateACBtn: TSpeedButton;
    ACWord1: TEdit;
    ACWord2: TEdit;
    ACWord3: TEdit;
    ACWord4: TEdit;
    CopyACToClipboardBtn: TSpeedButton;
    PSWPanel: TPanel;
    PSWLabel: TLabel;
    PSWEdit: TEdit;
    CUIDWord6: TEdit;
    Label9: TLabel;
    CUIDWord5: TEdit;
    Label10: TLabel;
    ACWord6: TEdit;
    Label11: TLabel;
    ACWord5: TEdit;
    Label12: TLabel;
    ColorDisplayRadio: TTntCheckBox;
    AlarmCheck: TTntCheckBox;
    LFGCheck: TTntCheckBox;
    ModelSelectGroup: TTntGroupBox;
    Model1Radio: TTntRadioButton;
    Model2Radio: TTntRadioButton;
    Model3Radio: TTntRadioButton;
    Model1Label: TTntLabel;
    Model2Label: TTntLabel;
    Model3Label: TTntLabel;
    SpeedButton1: TSpeedButton;
    SaveDialog1: TSaveDialog;
    Label13: TLabel;
    EditInitialDir: TEdit;
    CUIDWord7: TEdit;
    Label14: TLabel;
    Label15: TLabel;
    ModelLabel: TLabel;
    BRModel1Radio: TTntRadioButton;
    BRModel2Radio: TTntRadioButton;
    BRModel3Radio: TTntRadioButton;
    procedure GenerateCUIDBtnClick(Sender: TObject);
    procedure GenerateACBtnClick(Sender: TObject);
    procedure CopyACToClipboardBtnClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure CUIDWord1KeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure CUIDWord1KeyPress(Sender: TObject; var Key: Char);
    procedure PSWEditKeyPress(Sender: TObject; var Key: Char);
    procedure ColorDisplayRadioClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure EditInitialDirChange(Sender: TObject);
    procedure CUIDWord7Change(Sender: TObject);
    procedure Model1RadioClick(Sender: TObject);
  private
    { Private declarations }
    TryCount: Integer;
    InitialDir: String;

    function HexToInt(HexDigit: Char): Integer;
    procedure GenerateCUID(var CUIDWord1, CUIDWord2, CUIDWord3, CUIDWord4, CUIDWord5, CUIDWord6: String);
    procedure GenerateActivationCode(const CUIDWord1, CUIDWord2, CUIDWord3, CUIDWord4, CUIDWord5, CUIDWord6: String;
      var ACWord1, ACWord2, ACWord3, ACWord4, ACWord5, ACWord6: String);

    function CheckPassword(const PSW: String): Boolean;

    procedure DetermineEncryptionParameters;

    procedure ReadSettings;
    procedure SaveSettings;
    function DetermineModelFromModelWord(ModelWord: String): String;

    procedure RefreshFormState;
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;
  
  ApplicationPath: String = '';

implementation

uses StrUtils, magwmi, magsubs1;

{$R *.dfm}

function GetSerialStrings(var CPUID, BIOSInfo, MBInfo, HDSerial: String): Boolean;
var
    MyCPU: TCPUID;
    rows, instances, I: integer ;
    WmiResults: T2DimStrArray ;
    Title: String;
begin
  Result := False;

  try

    MyCPU := TCPUID.Create;
    if MyCPU.IDAvailable then
    begin
      CPUID := IntToHex(MyCPU.ID1, 8) + IntToHex(MyCPU.ID2, 8) +
               IntToHex(MyCPU.ID3, 8) + IntToHex(MyCPU.ID4, 8);
    end
    else
    begin
      MyCPU.Free;
      Exit;
    end;
    MyCPU.Free;

    MBInfo := MagWmiGetBaseBoard;

    ////////////
    //Win32_BIOS
    rows := MagWmiGetInfo (GetCompName, 'root\CIMV2', '',
              '', 'Win32_BIOS',
              WmiResults, instances) ;
    if (instances <= 0) or (rows <= 0) then
      Exit;

    BIOSInfo := '';
    for I := 1 to rows do
    begin
      Title := WmiResults [0, I] ;
      if LowerCase(Title) = LowerCase('BIOSVersion') then
        BIOSInfo := BIOSInfo + WmiResults [1, I]
      else if LowerCase(Title) = LowerCase('ReleaseDate') then
        BIOSInfo := BIOSInfo + WmiResults [1, I];
    end;
    if BIOSInfo = '' then
      Exit;

    HDSerial := '';
    HDSerial := MagWmiGetDiskSerial(0);
    if HDSerial = '' then
      Exit;

    Result := True;
  finally
    WmiResults := nil ;  //garbage collection is automatic and frees the memory
  end ;
end;

procedure TMainForm.GenerateCUID(var CUIDWord1, CUIDWord2, CUIDWord3, CUIDWord4,
  CUIDWord5, CUIDWord6: String);
var
  S, S2: String;
  i: Integer;
  Cipher: TDCP_cast128;
  CPUID, BIOSInfo, MBInfo, HDSerial: String;  //Serial strings
begin
    if not GetSerialStrings(CPUID, BIOSInfo, MBInfo, HDSerial) then
    begin
      Application.MessageBox('Error occured.', 'Critical Error');
      Exit;
    end;
    S2 := CPUID + BIOSInfo;

    Cipher := TDCP_cast128.Create(Self);
    Cipher.InitStr(HDSerial, TDCP_sha1);
    S2 := Cipher.EncryptString(S2);
    Cipher.Burn;
    Cipher.InitStr(MBInfo, TDCP_sha1);
    S2 := Cipher.EncryptString(S2);
    Cipher.Burn;

    Cipher.InitStr(GLOBAL_ENCRYPTION_KEY, TDCP_sha1);
    S2 := Cipher.EncryptString(S2);
    Cipher.Burn;

    if Length(S2) > 9 then  //9 chars will be encrypted to max. 12 chars, to be coded to 24/4=6 4-digit hex fields
    begin
      Cipher.InitStr(Copy(S2, 10, Length(S2) - 9), TDCP_sha1);
      S2 := Copy(S2, 1, 9);
      S2 := Cipher.EncryptString(S2);
      Cipher.Burn;
    end;

    Cipher.Free;

    S := '';
    for i := 1 to Length(S2) do
      S := S + IntToHex(Ord(S2[i]), 2);

    CUIDWord1 := Copy(S, 1, 4);
    CUIDWord2 := Copy(S, 5, 4);
    CUIDWord3 := Copy(S, 9, 4);
    CUIDWord4 := Copy(S, 13, 4);
    CUIDWord5 := Copy(S, 17, 4);
    CUIDWord6 := Copy(S, 21, 4);
end;

procedure TMainForm.GenerateCUIDBtnClick(Sender: TObject);
var
  Word1, Word2, Word3, Word4, Word5, Word6: String;
begin
  DetermineEncryptionParameters;
  
  GenerateCUID(Word1, Word2, Word3, Word4, Word5, Word6);
  CUIDWord1.Text := Word1;
  CUIDWord2.Text := Word2;
  CUIDWord3.Text := Word3;
  CUIDWord4.Text := Word4;
  CUIDWord5.Text := Word5;
  CUIDWord6.Text := Word6;
end;

procedure TMainForm.GenerateACBtnClick(Sender: TObject);
var
  Word1, Word2, Word3, Word4, Word5, Word6: String;
begin
  DetermineEncryptionParameters;
  
  if (Length(CUIDWord1.Text) <> 4) or
     (Length(CUIDWord2.Text) <> 4) or
     (Length(CUIDWord3.Text) <> 4) or
     (Length(CUIDWord4.Text) <> 4) or
     (Length(CUIDWord5.Text) <> 4) or
     (Length(CUIDWord6.Text) <> 4) then
    Exit;

  GenerateActivationCode(UpperCase(CUIDWord1.Text), UpperCase(CUIDWord2.Text),
                         UpperCase(CUIDWord3.Text), UpperCase(CUIDWord4.Text),
                         UpperCase(CUIDWord5.Text), UpperCase(CUIDWord6.Text),
                         Word1, Word2, Word3, Word4, Word5, Word6);

  ACWord1.Text := Word1;
  ACWord2.Text := Word2;
  ACWord3.Text := Word3;
  ACWord4.Text := Word4;
  ACWord5.Text := Word5;
  ACWord6.Text := Word6;
end;

{$WARNINGS OFF}
function TMainForm.HexToInt(HexDigit: Char): Integer;
begin
  case HexDigit of
    '0': Result := 0;
    '1': Result := 1;
    '2': Result := 2;
    '3': Result := 3;
    '4': Result := 4;
    '5': Result := 5;
    '6': Result := 6;
    '7': Result := 7;
    '8': Result := 8;
    '9': Result := 9;
    'A': Result := 10;
    'B': Result := 11;
    'C': Result := 12;
    'D': Result := 13;
    'E': Result := 14;
    'F': Result := 15;
  end;
end;
{$WARNINGS ON}

procedure TMainForm.GenerateActivationCode(const CUIDWord1, CUIDWord2,
  CUIDWord3, CUIDWord4, CUIDWord5, CUIDWord6: String; var ACWord1, ACWord2,
  ACWord3, ACWord4, ACWord5, ACWord6: String);

  function HexStrToStr(const HexStr: String): String;
  var
    i: Integer;
  begin
    Result := StringOfChar(' ', Trunc(Length(HexStr) / 2));
    for i := 1 to Length(Result) do
      Result[i] := Chr(HexToInt(HexStr[i * 2 - 1]) * 16 + HexToInt(HexStr[i * 2]));
  end;
var
  CUID, ActivationCode, S: String;
  Cipher: TDCP_cast128;
  i: Integer;
begin
  CUID := HexStrToStr(CUIDWord1) +
          HexStrToStr(CUIDWord2) +
          HexStrToStr(CUIDWord3) +
          HexStrToStr(CUIDWord4) +
          HexStrToStr(CUIDWord5) +
          HexStrToStr(CUIDWord6);

  if not(CUIDWord6[4] in Hexdigits) or
     not(CUIDWord4[4] in Hexdigits) or
     not(CUIDWord2[4] in Hexdigits) then
  begin
    MessageDlg('Invalid CUID.', mtError, [mbOK], 0);
    Exit;
  end;

  S := CUID;
  Cipher := TDCP_cast128.Create(Self);

  Cipher.InitStr(ENCRYPTION_KEYS[HexToInt(CUIDWord6[4])], TDCP_sha1);
  S := Cipher.EncryptString(S);
  Cipher.Burn;

  Cipher.InitStr(ENCRYPTION_KEYS[HexToInt(CUIDWord4[4])], TDCP_sha1);
  S := Cipher.EncryptString(S);
  Cipher.Burn;

  Cipher.InitStr(ENCRYPTION_KEYS[HexToInt(CUIDWord2[4])], TDCP_sha1);
  S := Cipher.EncryptString(S);
  Cipher.Burn;

  Cipher.InitStr(Copy(S, 10, Length(S) - 9), TDCP_sha1);
  S := Copy(S, 1, 9);
  S := Cipher.EncryptString(S);
  Cipher.Burn;

  Cipher.Free;

  ActivationCode := '';
  for i := 1 to Length(S) do
    ActivationCode := ActivationCode + IntToHex(Ord(S[i]), 2);

  ACWord1 := Copy(ActivationCode, 1, 4);
  ACWord2 := Copy(ActivationCode, 5, 4);
  ACWord3 := Copy(ActivationCode, 9, 4);
  ACWord4 := Copy(ActivationCode, 13, 4);
  ACWord5 := Copy(ActivationCode, 17, 4);
  ACWord6 := Copy(ActivationCode, 21, 4);
end;

procedure TMainForm.CopyACToClipboardBtnClick(Sender: TObject);
begin
  Clipboard.AsText := ACWord1.Text + '-' +
                      ACWord2.Text + '-' +
                      ACWord3.Text + '-' +
                      ACWord4.Text + '-' +
                      ACWord5.Text + '-' +
                      ACWord6.Text;
end;

procedure TMainForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  {if (ssCtrl in Shift) and (ssShift in Shift) and
     (Key = VK_F1) then
    GenerateCUIDBtn.Visible := not GenerateCUIDBtn.Visible;}
end;

procedure TMainForm.CUIDWord1KeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Sender as TEdit).SelStart = 4 then
    SendMessage(Handle, WM_NEXTDLGCTL, 0, 0);
end;

procedure TMainForm.CUIDWord1KeyPress(Sender: TObject; var Key: Char);
begin
  if (Ord(Key) >= 97) and
     (Ord(Key) <= 122) then
    Key := Chr(Ord(Key) - 32);
end;

procedure TMainForm.PSWEditKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    Key := #0;
    Application.Terminate;
  end
  else if Key = Chr(VK_ESCAPE) then
  begin
    Key := #0;
    if (TryCount < MAX_TRY_COUNT) and CheckPassword(PSWEdit.Text) then
    begin
      Self.Visible := False;
      PSWEdit.Text := '6876 87v87b68 87678';
      PSWEdit.Text := '';
      PSWLabel.Free;
      PSWEdit.Free;
      PSWPanel.Hide;
      MainPanel.Show;
      Self.Visible := True;
    end
    else if TryCount < MAX_TRY_COUNT then
      Inc(TryCount);
  end;
end;

function TMainForm.CheckPassword(const PSW: String): Boolean;
var
  tmp: String;
begin
  //Password: NOORSUN8810750
  Result := False;
  if (Length(PSW) <> 14) or
     (UpperCase(PSW) <> PSW) then
    Exit;
  tmp := LowerCase(ReverseString(PSW));
  if Copy(tmp, 1, 3) <> '057' then
    Exit;
  if Copy(tmp, 3, 3) <> '701' then
    Exit;
  if Copy(tmp, 5, 2) <> '18' then
    Exit;
  if Copy(tmp, 7, 3) <> '8nu' then
    Exit;
  if Copy(tmp, 9, 3) <> 'usr' then
    Exit;
  if tmp[12] <> 'o' then
    Exit;
  if tmp[13] <> 'o' then
    Exit;
  Result := tmp[Length(tmp)] = 'n';
end;

procedure TMainForm.ColorDisplayRadioClick(Sender: TObject);
begin
  RefreshFormState;
end;

procedure TMainForm.DetermineEncryptionParameters;
type
  TKeysArrayType = array[0..15] of String[13];

var
  KeysArrayPtr: ^TKeysArrayType;
  i: Integer;
begin
  if ColorDisplayRadio.Checked then
  begin
    GLOBAL_ENCRYPTION_KEY := ColorModel.GLOBAL_ENCRYPTION_KEY;
    KeysArrayPtr := @ColorModel.ENCRYPTION_KEYS;
  end
  else
  begin
    //////////////////////////////////////////////////////////////
    //  MODEL 1
    if Model1Radio.Checked then
    begin
      if AlarmCheck.Checked and not LFGCheck.Checked then
      begin
        GLOBAL_ENCRYPTION_KEY := m1Alarm.GLOBAL_ENCRYPTION_KEY;
        KeysArrayPtr := @m1Alarm.ENCRYPTION_KEYS;
      end
      else if AlarmCheck.Checked and LFGCheck.Checked then
      begin
        GLOBAL_ENCRYPTION_KEY := m1LFGAlarm.GLOBAL_ENCRYPTION_KEY;
        KeysArrayPtr := @m1LFGAlarm.ENCRYPTION_KEYS;
      end
      else if not AlarmCheck.Checked and LFGCheck.Checked then
      begin
        GLOBAL_ENCRYPTION_KEY := m1LFG.GLOBAL_ENCRYPTION_KEY;
        KeysArrayPtr := @m1LFG.ENCRYPTION_KEYS;
      end
      else if not AlarmCheck.Checked and not LFGCheck.Checked then
      begin
        GLOBAL_ENCRYPTION_KEY := m1.GLOBAL_ENCRYPTION_KEY;
        KeysArrayPtr := @m1.ENCRYPTION_KEYS;
      end;
    end
    //////////////////////////////////////////////////////////////

    //////////////////////////////////////////////////////////////
    //  MODEL 2
    else if Model2Radio.Checked then
    begin
      if AlarmCheck.Checked and not LFGCheck.Checked then
      begin
        GLOBAL_ENCRYPTION_KEY := m2Alarm.GLOBAL_ENCRYPTION_KEY;
        KeysArrayPtr := @m2Alarm.ENCRYPTION_KEYS;
      end
      else if AlarmCheck.Checked and LFGCheck.Checked then
      begin
        GLOBAL_ENCRYPTION_KEY := m2LFGAlarm.GLOBAL_ENCRYPTION_KEY;
        KeysArrayPtr := @m2LFGAlarm.ENCRYPTION_KEYS;
      end
      else if not AlarmCheck.Checked and LFGCheck.Checked then
      begin
        GLOBAL_ENCRYPTION_KEY := m2LFG.GLOBAL_ENCRYPTION_KEY;
        KeysArrayPtr := @m2LFG.ENCRYPTION_KEYS;
      end
      else if not AlarmCheck.Checked and not LFGCheck.Checked then
      begin
        GLOBAL_ENCRYPTION_KEY := m2.GLOBAL_ENCRYPTION_KEY;
        KeysArrayPtr := @m2.ENCRYPTION_KEYS;
      end;
    end
    //////////////////////////////////////////////////////////////

    //////////////////////////////////////////////////////////////
    //  MODEL 3
    else if Model3Radio.Checked then
    begin
      if AlarmCheck.Checked and not LFGCheck.Checked then
      begin
        GLOBAL_ENCRYPTION_KEY := m3Alarm.GLOBAL_ENCRYPTION_KEY;
        KeysArrayPtr := @m3Alarm.ENCRYPTION_KEYS;
      end
      else if AlarmCheck.Checked and LFGCheck.Checked then
      begin
        GLOBAL_ENCRYPTION_KEY := m3LFGAlarm.GLOBAL_ENCRYPTION_KEY;
        KeysArrayPtr := @m3LFGAlarm.ENCRYPTION_KEYS;
      end
      else if not AlarmCheck.Checked and LFGCheck.Checked then
      begin
        GLOBAL_ENCRYPTION_KEY := m3LFG.GLOBAL_ENCRYPTION_KEY;
        KeysArrayPtr := @m3LFG.ENCRYPTION_KEYS;
      end
      else if not AlarmCheck.Checked and not LFGCheck.Checked then
      begin
        GLOBAL_ENCRYPTION_KEY := m3.GLOBAL_ENCRYPTION_KEY;
        KeysArrayPtr := @m3.ENCRYPTION_KEYS;
      end;
    end
    //////////////////////////////////////////////////////////////

    //////////////////////////////////////////////////////////////
    //  MODEL 1 Full Bright
    else if BRModel1Radio.Checked then
    begin
      GLOBAL_ENCRYPTION_KEY := BRm1.GLOBAL_ENCRYPTION_KEY;
      KeysArrayPtr := @BRm1.ENCRYPTION_KEYS;
    end
    //////////////////////////////////////////////////////////////

    //////////////////////////////////////////////////////////////
    //  MODEL 2 Full Bright
    else if BRModel2Radio.Checked then
    begin
      GLOBAL_ENCRYPTION_KEY := BRm2.GLOBAL_ENCRYPTION_KEY;
      KeysArrayPtr := @BRm2.ENCRYPTION_KEYS;
    end
    //////////////////////////////////////////////////////////////

    //////////////////////////////////////////////////////////////
    //  MODEL 3 Full Bright
    else if BRModel3Radio.Checked then
    begin
      GLOBAL_ENCRYPTION_KEY := BRm3.GLOBAL_ENCRYPTION_KEY;
      KeysArrayPtr := @BRm3.ENCRYPTION_KEYS;
    end
    //////////////////////////////////////////////////////////////
    else
    begin
      MessageDlg('Critical Error: No encryption key found.', mtError, [mbOK], 0);
      Halt;
    end;
  end;

  for i := 0 to 15 do
    ENCRYPTION_KEYS[i] := KeysArrayPtr[i];
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  TryCount := 0;
  InitialDir := '';

  ApplicationPath := ExtractFilePath(Application.ExeName);

  ReadSettings;

  EditInitialDir.Text := InitialDir;
end;

procedure TMainForm.SpeedButton1Click(Sender: TObject);
var
  FormPic: TBitmap;
  FileName: String;
  Jpg: TJpegImage;
begin
  keybd_event(VK_SNAPSHOT, 1, 0, 0);
  Application.ProcessMessages;
  Sleep(100);
  FormPic := TBitmap.Create;
  FormPic.LoadFromClipboardFormat(CF_BITMAP, Clipboard.GetAsHandle(CF_BITMAP), 0);

  Application.CreateForm(TPreviewForm, PreviewForm);
  PreviewForm.LoadBitmap(FormPic);
  PreviewForm.ShowModal;
  PreviewForm.Free;

  Jpg := TJPEGImage.Create;
  Jpg.Assign(FormPic);
  if DirectoryExists(InitialDir) then
    SaveDialog1.InitialDir := InitialDir
  else
    SaveDialog1.InitialDir := '';
  if SaveDialog1.Execute then
  begin
    FileName := SaveDialog1.FileName;
    if ExtractFileExt(FileName) <> '.jpg' then
      FileName := FileName + '.jpg';
    Jpg.SaveToFile(FileName);
  end;
  FormPic.Free;
  Jpg.Free;
end;

procedure TMainForm.ReadSettings;
var
  ini: TIniFile;
begin
  try

  if FileExists(ApplicationPath + INI_FILENAME) then
  begin
    ini := TIniFile.Create(ApplicationPath + INI_FILENAME);
    InitialDir := ini.ReadString('Settings', 'InitialDir', InitialDir);
    ini.Free;
  end;

  except
    DeleteFile(ApplicationPath + INI_FILENAME);
  end;
end;

procedure TMainForm.SaveSettings;
var
  ini: TIniFile;
begin
  try
    ini := TIniFile.Create(ApplicationPath + INI_FILENAME);
    ini.WriteString('Settings', 'InitialDir', InitialDir);
    ini.Free;
  except
    on E: Exception do
    begin
      ShowMessage('Unable to save program settings:' + #13 + E.Message);
    end;
  end;
end;

procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  SaveSettings;
end;

procedure TMainForm.EditInitialDirChange(Sender: TObject);
begin
  InitialDir := EditInitialDir.Text;
end;

function TMainForm.DetermineModelFromModelWord(ModelWord: String): String;
begin
  Result := '{Undefined}';
  if ModelWord = m1.MODEL_WORD then
    Result := 'Model1'
  else if ModelWord = m1Alarm.MODEL_WORD then
    Result := 'Model1+Alarm'
  else if ModelWord = m1LFG.MODEL_WORD then
    Result := 'Model1+LFG'
  else if ModelWord = m1LFGAlarm.MODEL_WORD then
    Result := 'Model1+Alarm+LFG'
  else if ModelWord = m2.MODEL_WORD then
    Result := 'Model2'
  else if ModelWord = m2Alarm.MODEL_WORD then
    Result := 'Model2+Alarm'
  else if ModelWord = m2LFG.MODEL_WORD then
    Result := 'Model2+LFG'
  else if ModelWord = m2LFGAlarm.MODEL_WORD then
    Result := 'Model2+Alarm+LFG'
  else if ModelWord = m3.MODEL_WORD then
    Result := 'Model3'
  else if ModelWord = m3Alarm.MODEL_WORD then
    Result := 'Model3+Alarm'
  else if ModelWord = m3LFG.MODEL_WORD then
    Result := 'Model3+LFG'
  else if ModelWord = m3LFGAlarm.MODEL_WORD then
    Result := 'Model3+Alarm+LFG'
  else if ModelWord = BRm1.MODEL_WORD then
    Result := 'SunLight Model1'
  else if ModelWord = BRm2.MODEL_WORD then
    Result := 'SunLight Model2'
  else if ModelWord = BRm3.MODEL_WORD then
    Result := 'SunLight Model3';
end;

procedure TMainForm.CUIDWord7Change(Sender: TObject);
begin
  ModelLabel.Caption := DetermineModelFromModelWord(CUIDWord7.Text);
end;

procedure TMainForm.Model1RadioClick(Sender: TObject);
begin
  RefreshFormState;
end;

procedure TMainForm.RefreshFormState;
begin
  if ColorDisplayRadio.Checked then
  begin
    Model1Radio.Checked := True;
    AlarmCheck.Checked := False;
    LFGCheck.Checked := True;
  end;

  ModelSelectGroup.Enabled := not ColorDisplayRadio.Checked;

  Model1Radio.Enabled := not ColorDisplayRadio.Checked;
  Model2Radio.Enabled := not ColorDisplayRadio.Checked;
  Model3Radio.Enabled := not ColorDisplayRadio.Checked;

  BRModel1Radio.Enabled := not ColorDisplayRadio.Checked;
  BRModel2Radio.Enabled := not ColorDisplayRadio.Checked;
  BRModel3Radio.Enabled := not ColorDisplayRadio.Checked;

  Model1Label.Enabled := not ColorDisplayRadio.Checked;
  Model2Label.Enabled := not ColorDisplayRadio.Checked;
  Model3Label.Enabled := not ColorDisplayRadio.Checked;

  if ColorDisplayRadio.Checked then
  begin
    AlarmCheck.Enabled := False;
    LFGCheck.Enabled := False;
  end
  else
  begin
    AlarmCheck.Enabled := Model1Radio.Checked or
        Model2Radio.Checked or Model3Radio.Checked;
    LFGCheck.Enabled := Model1Radio.Checked or
        Model2Radio.Checked or Model3Radio.Checked;
  end;
end;

end.
