unit License6;

{
  Main License generator unit
  Other License units are exact copies of this unit except that a number is
  appended to the name of the unit (e.g. License2.pas, License3.pas, ...).
}

interface

uses
  ProgramConsts, BiDiSoundDialogs, Classes, magwmi, magsubs1, LicenseTypes,
  {$IFDEF NORMAL_MODEL}
  Model1,   Model1A,  Model1AG, Model1G,
  Model2,   Model2A,  Model2AG, Model2G,
  Model3,   Model3A,  Model3AG, Model3G
  {$ENDIF}
  {$IFDEF FULL_BRIGHT}
  BRModel1, BRModel2, BRModel3
  {$ENDIF};

  function CheckLicenseStatus: Boolean;
  function CheckLicenseStatusFull: Boolean;
  function RegisterSoftware(const ActivationCode: String): Boolean;
  procedure GenerateCUID(var CUIDWord1, CUIDWord2, CUIDWord3, CUIDWord4, CUIDWord5, CUIDWord6, CUIDWord7: String);

  procedure SelectLicenseModel(LicenseModel: TLicenseModel);
  function DetermineRegisteredLicenseModel: TLicenseModel;

var
  _LED_DISPLAY_MAX_ROW_COUNT_: Integer = 0;
  _LED_DISPLAY_MAX_COL_COUNT_: Integer = 0;
  _INTERNAL_LFG_INLCUDED_: Boolean = False;
  _COLOR_DISPLAY_: Boolean = False;
  _ALARM_ACTIVE_: Boolean = False;

implementation

uses
  DCPcast128, DCPsha1, cls_id, SysUtils, Dialogs, Registry,
  Windows, MainUnit, StrUtils, ProcsUnit;

const
  LICENSE_REG_PATH = 'SOFTWARE\' + SOFTWARE_NAME + '\' + MAJOR_VERSION_NUMBER_STR_FOR_LICENSE +'.' + MINOR_VERSION_NUMBER_STR_FOR_LICENSE;

  {$INCLUDE 'F:\LED Display\Delphi\MAIN\LED Display Control Software\Project\License Units\LicenseKeyForModels.inc'}

var
  ActiveLicenseModel: TLicenseModel = lmNone;
  GLOBAL_ENCRYPTION_KEY: String;
  REG_ENCODE_KEY: String;
  HexDigits: set of Char;
  ENCRYPTION_KEYS : array[0..15] of String[13];
  MODEL_WORD: String = '47CC';


function HexToInt(HexDigit: Char): Integer;
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
    else
      Result := 0; 
  end;
end;

function RegEncode(const S: String): String;
var
  Cipher: TDCP_cast128;
begin
  Cipher := TDCP_cast128.Create(nil);
  Cipher.InitStr(REG_ENCODE_KEY, TDCP_sha1);
  Result := Cipher.EncryptString(ReverseString(S));
  Cipher.Burn;
  Cipher.Free;
  Result := ReverseString(Result);
end;

function RegDecode(const S: String): String;
var
  Cipher: TDCP_cast128;
begin
  Cipher := TDCP_cast128.Create(nil);
  Cipher.InitStr(REG_ENCODE_KEY, TDCP_sha1);
  Result := Cipher.DecryptString(ReverseString(S));
  Cipher.Burn;
  Cipher.Free;
  Result := ReverseString(Result);
end;

procedure HaltOnCUIDError(const AdditionalErrMsg: String);
begin
  MessageDlgBiDiSoundTop('Unable to create a valid CUID for this machine.'#13 + AdditionalErrMsg,
    mtError, [mbOK], 0, bdLeftToRight);
  Halt;
end;

{$IFDEF HD_SMART_SERIAL}
function GetHardDiskSerial: String;
var
  errInfo, model, serial: String;
  diskbytes: Int64;
  Success: Boolean;
begin
  Result := '';
  Success := False;
  try
    Success := MagWmiSmartDiskInfo(0, errinfo, model, serial, diskbytes);
  except
  end;
  if (not Success) or (Length(Trim(serial)) = 0) then
  begin
    try
      Success := MagWmiScsiDiskInfo (0, errinfo, model, serial, diskbytes);
    except
    end;
  end;
  if not Success then
    HaltOnCUIDError(errInfo);
  Result := serial;
end;
{$ENDIF}

{$IFDEF FULL_BRIGHT}
function GetSerialStrings(var CPUID, BIOSInfo, MBInfo, HDSerial: String): Boolean;
var
  MyCPU: TCPUID;
  rows, instances, I: integer ;
  WmiResults: T2DimStrArray ;
  Title: String;
  CPUIDAvailable, BIOSInfoAvailable, MBInfoAvailable, HDSerialAvailable: Boolean;
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
      CPUID := '';
      //MyCPU.Free;
      //Exit;  //CPUID is a required part
    end;
    MyCPU.Free;

    MBInfo := MagWmiGetBaseBoard;

    ////////////
    //Win32_BIOS
    rows := MagWmiGetInfo (GetCompName, 'root\CIMV2', '',
              '', 'Win32_BIOS',
              WmiResults, instances) ;
    if (instances <= 0) or (rows <= 0) then
      BIOSInfo := ''
    else
    begin
      for I := 1 to rows do
      begin
        Title := WmiResults [0, I] ;
        if LowerCase(Title) = LowerCase('BIOSVersion') then
          BIOSInfo := BIOSInfo + WmiResults [1, I]
        else if LowerCase(Title) = LowerCase('ReleaseDate') then
          BIOSInfo := BIOSInfo + WmiResults [1, I];
      end;
    end;

    HDSerial := GetHardDiskSerial;
    //HDSerial := MagWmiGetDiskSerial(0);

    //Validate serials
    CPUIDAvailable := Length(Trim(CPUID)) > 5;  //at least 5 digits
    BIOSInfoAvailable := (Length(Trim(BIOSInfo)) > 0) and (UpperCase(BIOSInfo) <> 'NULL');
    MBInfoAvailable := (Length(Trim(MBInfo)) > 0) and (UpperCase(MBInfo) <> 'NULL');
    HDSerialAvailable := (Length(Trim(HDSerial)) > 0) and (UpperCase(HDSerial) <> 'NULL');

    //CPUID is a required field
    //1 of other fields can be ommited
    if CPUIDAvailable then
    begin
      if (BIOSInfoAvailable and MBInfoAvailable) or
         (BIOSInfoAvailable and HDSerialAvailable) or
         (MBInfoAvailable and HDSerialAvailable) then
      begin
        if not BIOSInfoAvailable then
          BIOSInfo := 'NULL';
        if not HDSerialAvailable then
          HDSerial := 'NULL';
        if not MBInfoAvailable then
          MBInfo := 'NULL';
      end
      else
        HaltOnCUIDError(IfThen(HDSerialAvailable, 'H', '') + IfThen(BIOSInfoAvailable, 'B', '') +
          IfThen(MBInfoAvailable, 'M', ''));
    end
    else
      HaltOnCUIDError('CPUID not available');
    Result := True;
  finally
    WmiResults := nil ;  //garbage collection is automatic and frees the memory
  end ;
end;
{$ENDIF}

{$IFDEF NORMAL_MODEL}
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
{$ENDIF}

procedure GenerateCUID(var CUIDWord1, CUIDWord2, CUIDWord3, CUIDWord4,
  CUIDWord5, CUIDWord6, CUIDWord7: String);
var
  S, S2: String;
  i: Integer;
  Cipher: TDCP_cast128;
  CPUID, BIOSInfo, MBInfo, HDSerial: String;  //Serial strings
begin
  CPUID := '';
  HDSerial := '';
  if not GetSerialStrings(CPUID, BIOSInfo, MBInfo, HDSerial) then
  begin
    MessageDlgBiDiSoundTop('Unable to create a valid CUID for this machine.', mtError, [mbOK], 0, bdLeftToRight);
    Halt;
  end;
  if CPUID = '' then
    Halt;
  if HDSerial = '' then
    Exit;

  ///////////////////////
  S2 := CPUID + BIOSInfo;

  Cipher := TDCP_cast128.Create(nil);
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
  ///////////////////////

  S := '';
  for i := 1 to Length(S2) do
    S := S + IntToHex(Ord(S2[i]), 2);

  CUIDWord1 := Copy(S, 1, 4);
  CUIDWord2 := Copy(S, 5, 4);
  CUIDWord3 := Copy(S, 9, 4);
  CUIDWord4 := Copy(S, 13, 4);
  CUIDWord5 := Copy(S, 17, 4);
  CUIDWord6 := Copy(S, 21, 4);
  CUIDWord7 := MODEL_WORD;
end;

function ValidateCUID(const CUIDWord1, CUIDWord2, CUIDWord3, CUIDWord4, CUIDWord5, CUIDWord6: String): Boolean;
var
  CW1, CW2, CW3, CW4, CW5, CW6, CW7: String;
begin
  Result := (Length(CUIDWord1) = 4) and
            (Length(CUIDWord2) = 4) and
            (Length(CUIDWord3) = 4) and
            (Length(CUIDWord4) = 4) and
            (Length(CUIDWord5) = 4) and
            (Length(CUIDWord6) = 4);
  if not Result then
    Exit;
  GenerateCUID(CW1, CW2, CW3, CW4, CW5, CW6, CW7);
  Result := (CUIDWord1 = CW1) and
            (CUIDWord2 = CW2) and
            (CUIDWord3 = CW3) and
            (CUIDWord4 = CW4) and
            (CUIDWord5 = CW5) and
            (CUIDWord6 = CW6);
end;

function ValidateActivationCode(const ACWord1, ACWord2, ACWord3, ACWord4, ACWord5, ACWord6: String): Boolean;

  function HexStrToStr(const HexStr: String): String;
  var
    i: Integer;
  begin
    Result := StringOfChar(' ', Trunc(Length(HexStr) / 2));
    for i := 1 to Length(Result) do
      Result[i] := Chr(HexToInt(HexStr[i * 2 - 1]) * 16 + HexToInt(HexStr[i * 2]));
  end;

var
  Cipher: TDCP_cast128;
  CUID, CUIDWord1, CUIDWord2, CUIDWord3, CUIDWord4, CUIDWord5, CUIDWord6, CUIDWord7: String;
  S, ActivationCode: String;
begin
  Result := False;

  if (Length(ACWord1) <> 4) or
     (Length(ACWord2) <> 4) or
     (Length(ACWord3) <> 4) or
     (Length(ACWord4) <> 4) or
     (Length(ACWord5) <> 4) or
     (Length(ACWord6) <> 4) then
    Exit;

  GenerateCUID(CUIDWord1, CUIDWord2, CUIDWord3, CUIDWord4, CUIDWord5, CUIDWord6, CUIDWord7);

  ActivationCode := HexStrToStr(ACWord1) +
                    HexStrToStr(ACWord2) +
                    HexStrToStr(ACWord3) +
                    HexStrToStr(ACWord4) +
                    HexStrToStr(ACWord5) +
                    HexStrToStr(ACWord6);

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
  Cipher := TDCP_cast128.Create(nil);

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

  Result := ActivationCode = S;
end;

function MultiplyTexts(const Text1, Text2: String): String;
var
  i: Integer;
  MinLen, MaxLen: Integer;
begin
  if Length(Text1) > Length(Text2) then
  begin
    MaxLen := Length(Text1);
    MinLen := Length(Text2);
  end
  else
  begin
    MaxLen := Length(Text2);
    MinLen := Length(Text1);
  end;
  Result := StringOfChar(' ', MaxLen);
  for i := 1 to MinLen do
    Result[i] := Chr(Ord(Text1[i]) * Ord(Text2[i]) + Ord(Text1[i]) * 6 - Ord(Text2[i]) * 4);
end;

function CheckLicenseStatus: Boolean;
var
  Reg: TRegistry;
begin
  //Check Admin again
  if not Procs.IsWindowsAdmin then
    Halt;
  ///////////////////

  Result := False;

  try

  Reg := TRegistry.Create(KEY_READ or KEY_QUERY_VALUE or KEY_ENUMERATE_SUB_KEYS);
  Reg.RootKey := HKEY_LOCAL_MACHINE;
  if Reg.KeyExists(LICENSE_REG_PATH) then
  begin
    if not Reg.OpenKeyReadOnly(LICENSE_REG_PATH) then
    begin
      MessageDlgBiDiSoundTop('Unable to access the registry. Maybe your user account is restricted. Contact your system administrator to resolve this problem.', mtError, [mbOK], 0, bdLeftToRight);
      Halt;
    end
    else
    begin
      if Reg.ValueExists('CUID') and
         Reg.ValueExists('AC') and
         Reg.ValueExists('{Security Code}') then
      begin
        //The CUID and ActivationCode variables are declared as global variables
        // in the MainUnit.pas.
        CUID := RegDecode(Reg.ReadString('CUID'));
        ActivationCode := RegDecode(Reg.ReadString('AC'));
        SecurityCode := RegDecode(Reg.ReadString('{Security Code}'));
        if (Length(CUID) = 24) and
           (Length(ActivationCode) = 24) then
        begin
          Result := (MultiplyTexts(CUID, ActivationCode) = SecurityCode); (*and {Even, the order of the parameters is important}
                    ValidateCUID(Copy(CUID, 1, 4), Copy(CUID, 5, 4),
                      Copy(CUID, 9, 4), Copy(CUID, 13, 4), Copy(CUID, 17, 4), Copy(CUID, 21, 4)) and
                    ValidateActivationCode(Copy(ActivationCode, 1, 4), Copy(ActivationCode, 5, 4),
                      Copy(ActivationCode, 9, 4), Copy(ActivationCode, 13, 4),
                      Copy(ActivationCode, 17, 4), Copy(ActivationCode, 21, 4));*)
        end;
      end;
      Reg.CloseKey;
    end;
  end;
  Reg.Free;

  except

    Result := False;

  end;
end;

function CheckLicenseStatusFull: Boolean;
var
  Reg: TRegistry;
begin
  //Check Admin again
  if not Procs.IsWindowsAdmin then
    Halt;
  ///////////////////

  Result := False;

  try

  Reg := TRegistry.Create(KEY_READ or KEY_QUERY_VALUE or KEY_ENUMERATE_SUB_KEYS);
  Reg.RootKey := HKEY_LOCAL_MACHINE;
  if Reg.KeyExists(LICENSE_REG_PATH) then
  begin
    if not Reg.OpenKeyReadOnly(LICENSE_REG_PATH) then
    begin
      MessageDlgBiDiSoundTop('Unable to access the registry. Maybe your user account is restricted. Contact your system administrator to resolve this problem.', mtError, [mbOK], 0, bdLeftToRight);
      Halt;
    end
    else
    begin
      if Reg.ValueExists('CUID') and
         Reg.ValueExists('AC') and
         Reg.ValueExists('{Security Code}') then
      begin
        //The CUID and ActivationCode variables are declared as global variables
        // in the MainUnit.pas.
        CUID := RegDecode(Reg.ReadString('CUID'));
        ActivationCode := RegDecode(Reg.ReadString('AC'));
        SecurityCode := RegDecode(Reg.ReadString('{Security Code}'));
        if (Length(CUID) = 24) and
           (Length(ActivationCode) = 24) then
        begin
          Result := (MultiplyTexts(CUID, ActivationCode) = SecurityCode) and {Even, the order of the parameters is important}
                    ValidateCUID(Copy(CUID, 1, 4), Copy(CUID, 5, 4),
                      Copy(CUID, 9, 4), Copy(CUID, 13, 4), Copy(CUID, 17, 4), Copy(CUID, 21, 4)) and
                    ValidateActivationCode(Copy(ActivationCode, 1, 4), Copy(ActivationCode, 5, 4),
                      Copy(ActivationCode, 9, 4), Copy(ActivationCode, 13, 4),
                      Copy(ActivationCode, 17, 4), Copy(ActivationCode, 21, 4));
        end;
      end;
      Reg.CloseKey;
    end;
  end;
  Reg.Free;

  except

    Result := False;

  end;
end;

function RegisterSoftware(const ActivationCode: String): Boolean;
var
  Reg: TRegistry;
  CUIDWord1, CUIDWord2, CUIDWord3, CUIDWord4, CUIDWord5, CUIDWord6, CUIDWord7: String;
begin
  Result := False;

  try

  if not ValidateActivationCode(Copy(ActivationCode, 1, 4), Copy(ActivationCode, 5, 4),
             Copy(ActivationCode, 9, 4), Copy(ActivationCode, 13, 4),
             Copy(ActivationCode, 17, 4), Copy(ActivationCode, 21, 4)) then
    Exit;

  //A valid license information. Save them in the registry.
  Reg := TRegistry.Create;
  Reg.RootKey := HKEY_LOCAL_MACHINE;

  try
    if Reg.OpenKey(LICENSE_REG_PATH, True) then
    begin
      GenerateCUID(CUIDWord1, CUIDWord2, CUIDWord3, CUIDWord4, CUIDWord5, CUIDWord6, CUIDWord7);
      Reg.WriteString('CUID', RegEncode(CUIDWord1 + CUIDWord2 + CUIDWord3 + CUIDWord4 + CUIDWord5 + CUIDWord6));
      Reg.WriteString('AC', RegEncode(ActivationCode));
      Reg.WriteString('{Security Code}', RegEncode(MultiplyTexts(CUIDWord1 + CUIDWord2 + CUIDWord3 + CUIDWord4 + CUIDWord5 + CUIDWord6,
                      ActivationCode)));  {Even, the order of the parameters is important}
      Reg.CloseKey;
    end;
    Reg.Free;
    Result := True;
  except
    Result := False;
  end;

  except
    Result := False;
  end;
end;

procedure SelectLicenseModel(LicenseModel: TLicenseModel);
var
  i: Integer;
  k: Integer;
begin
  ActiveLicenseModel := LicenseModel;

  _LED_DISPLAY_MAX_ROW_COUNT_ := 0;
  _LED_DISPLAY_MAX_COL_COUNT_ := 0;
  _INTERNAL_LFG_INLCUDED_ := False;
  _COLOR_DISPLAY_ := False;
  _ALARM_ACTIVE_ := False;
  GLOBAL_ENCRYPTION_KEY := 'hjjdiuyux78777jhdjhd7';  //dummy value
  REG_ENCODE_KEY := '33ghjdkj8skslk##445!';  //dummy value
  HexDigits := [];
  for i := 0 to 15 do
    HexDigits := HexDigits + ['x'];
  MODEL_WORD := '93BB';

  for i := 0 to 15 do
  begin
    for k := 0 to 12 do
      ENCRYPTION_KEYS[i] := 'lj83kd3@1@1~!';  //dummy value
  end;

  case ActiveLicenseModel of
    lmNone:
      begin
        //nothing to do
      end;

    {$IFDEF NORMAL_MODEL}
    lmModel1:
      begin
        MODEL_WORD := Model1.MODEL_WORD;
        GLOBAL_ENCRYPTION_KEY := Model1.GLOBAL_ENCRYPTION_KEY;
        REG_ENCODE_KEY := Model1.REG_ENCODE_KEY;
        HexDigits := Model1.HexDigits;
        for i := 0 to 15 do
          for k := 0 to 12 do
            ENCRYPTION_KEYS[i] := Model1.ENCRYPTION_KEYS[i];
        _LED_DISPLAY_MAX_ROW_COUNT_ := Model1._LED_DISPLAY_MAX_ROW_COUNT_;
        _LED_DISPLAY_MAX_COL_COUNT_ := Model1._LED_DISPLAY_MAX_COL_COUNT_;
        _INTERNAL_LFG_INLCUDED_ := Model1._INTERNAL_LFG_INLCUDED_;
        _COLOR_DISPLAY_ := Model1._COLOR_DISPLAY_;
        _ALARM_ACTIVE_ := Model1._ALARM_ACTIVE_;
      end;
    lmModel1Alarm:
      begin
        MODEL_WORD := Model1A.MODEL_WORD;
        GLOBAL_ENCRYPTION_KEY := Model1A.GLOBAL_ENCRYPTION_KEY;
        REG_ENCODE_KEY := Model1A.REG_ENCODE_KEY;
        HexDigits := Model1A.HexDigits;
        for i := 0 to 15 do
          for k := 0 to 12 do
            ENCRYPTION_KEYS[i] := Model1A.ENCRYPTION_KEYS[i];
        _LED_DISPLAY_MAX_ROW_COUNT_ := Model1A._LED_DISPLAY_MAX_ROW_COUNT_;
        _LED_DISPLAY_MAX_COL_COUNT_ := Model1A._LED_DISPLAY_MAX_COL_COUNT_;
        _INTERNAL_LFG_INLCUDED_ := Model1A._INTERNAL_LFG_INLCUDED_;
        _COLOR_DISPLAY_ := Model1A._COLOR_DISPLAY_;
        _ALARM_ACTIVE_ := Model1A._ALARM_ACTIVE_;
      end;
    lmModel1LFG:
      begin
        MODEL_WORD := Model1G.MODEL_WORD;
        GLOBAL_ENCRYPTION_KEY := Model1G.GLOBAL_ENCRYPTION_KEY;
        REG_ENCODE_KEY := Model1G.REG_ENCODE_KEY;
        HexDigits := Model1G.HexDigits;
        for i := 0 to 15 do
          for k := 0 to 12 do
            ENCRYPTION_KEYS[i] := Model1G.ENCRYPTION_KEYS[i];
        _LED_DISPLAY_MAX_ROW_COUNT_ := Model1G._LED_DISPLAY_MAX_ROW_COUNT_;
        _LED_DISPLAY_MAX_COL_COUNT_ := Model1G._LED_DISPLAY_MAX_COL_COUNT_;
        _INTERNAL_LFG_INLCUDED_ := Model1G._INTERNAL_LFG_INLCUDED_;
        _COLOR_DISPLAY_ := Model1G._COLOR_DISPLAY_;
        _ALARM_ACTIVE_ := Model1G._ALARM_ACTIVE_;
      end;
    lmModel1AlarmLFG:
      begin
        MODEL_WORD := Model1AG.MODEL_WORD;
        GLOBAL_ENCRYPTION_KEY := Model1AG.GLOBAL_ENCRYPTION_KEY;
        REG_ENCODE_KEY := Model1AG.REG_ENCODE_KEY;
        HexDigits := Model1AG.HexDigits;
        for i := 0 to 15 do
          for k := 0 to 12 do
            ENCRYPTION_KEYS[i] := Model1AG.ENCRYPTION_KEYS[i];
        _LED_DISPLAY_MAX_ROW_COUNT_ := Model1AG._LED_DISPLAY_MAX_ROW_COUNT_;
        _LED_DISPLAY_MAX_COL_COUNT_ := Model1AG._LED_DISPLAY_MAX_COL_COUNT_;
        _INTERNAL_LFG_INLCUDED_ := Model1AG._INTERNAL_LFG_INLCUDED_;
        _COLOR_DISPLAY_ := Model1AG._COLOR_DISPLAY_;
        _ALARM_ACTIVE_ := Model1AG._ALARM_ACTIVE_;
      end;
    lmModel2:
      begin
        MODEL_WORD := Model2.MODEL_WORD;
        GLOBAL_ENCRYPTION_KEY := Model2.GLOBAL_ENCRYPTION_KEY;
        REG_ENCODE_KEY := Model2.REG_ENCODE_KEY;
        HexDigits := Model2.HexDigits;
        for i := 0 to 15 do
          for k := 0 to 12 do
            ENCRYPTION_KEYS[i] := Model2.ENCRYPTION_KEYS[i];
        _LED_DISPLAY_MAX_ROW_COUNT_ := Model2._LED_DISPLAY_MAX_ROW_COUNT_;
        _LED_DISPLAY_MAX_COL_COUNT_ := Model2._LED_DISPLAY_MAX_COL_COUNT_;
        _INTERNAL_LFG_INLCUDED_ := Model2._INTERNAL_LFG_INLCUDED_;
        _COLOR_DISPLAY_ := Model2._COLOR_DISPLAY_;
        _ALARM_ACTIVE_ := Model2._ALARM_ACTIVE_;
      end;
    lmModel2Alarm:
      begin
        MODEL_WORD := Model2A.MODEL_WORD;
        GLOBAL_ENCRYPTION_KEY := Model2A.GLOBAL_ENCRYPTION_KEY;
        REG_ENCODE_KEY := Model2A.REG_ENCODE_KEY;
        HexDigits := Model2A.HexDigits;
        for i := 0 to 15 do
          for k := 0 to 12 do
            ENCRYPTION_KEYS[i] := Model2A.ENCRYPTION_KEYS[i];
        _LED_DISPLAY_MAX_ROW_COUNT_ := Model2A._LED_DISPLAY_MAX_ROW_COUNT_;
        _LED_DISPLAY_MAX_COL_COUNT_ := Model2A._LED_DISPLAY_MAX_COL_COUNT_;
        _INTERNAL_LFG_INLCUDED_ := Model2A._INTERNAL_LFG_INLCUDED_;
        _COLOR_DISPLAY_ := Model2A._COLOR_DISPLAY_;
        _ALARM_ACTIVE_ := Model2A._ALARM_ACTIVE_;
      end;
    lmModel2LFG:
      begin
        MODEL_WORD := Model2G.MODEL_WORD;
        GLOBAL_ENCRYPTION_KEY := Model2G.GLOBAL_ENCRYPTION_KEY;
        REG_ENCODE_KEY := Model2G.REG_ENCODE_KEY;
        HexDigits := Model2G.HexDigits;
        for i := 0 to 15 do
          for k := 0 to 12 do
            ENCRYPTION_KEYS[i] := Model2G.ENCRYPTION_KEYS[i];
        _LED_DISPLAY_MAX_ROW_COUNT_ := Model2G._LED_DISPLAY_MAX_ROW_COUNT_;
        _LED_DISPLAY_MAX_COL_COUNT_ := Model2G._LED_DISPLAY_MAX_COL_COUNT_;
        _INTERNAL_LFG_INLCUDED_ := Model2G._INTERNAL_LFG_INLCUDED_;
        _COLOR_DISPLAY_ := Model2G._COLOR_DISPLAY_;
        _ALARM_ACTIVE_ := Model2G._ALARM_ACTIVE_;
      end;
    lmModel2AlarmLFG:
      begin
        MODEL_WORD := Model2AG.MODEL_WORD;
        GLOBAL_ENCRYPTION_KEY := Model2AG.GLOBAL_ENCRYPTION_KEY;
        REG_ENCODE_KEY := Model2AG.REG_ENCODE_KEY;
        HexDigits := Model2AG.HexDigits;
        for i := 0 to 15 do
          for k := 0 to 12 do
            ENCRYPTION_KEYS[i] := Model2AG.ENCRYPTION_KEYS[i];
        _LED_DISPLAY_MAX_ROW_COUNT_ := Model2AG._LED_DISPLAY_MAX_ROW_COUNT_;
        _LED_DISPLAY_MAX_COL_COUNT_ := Model2AG._LED_DISPLAY_MAX_COL_COUNT_;
        _INTERNAL_LFG_INLCUDED_ := Model2AG._INTERNAL_LFG_INLCUDED_;
        _COLOR_DISPLAY_ := Model2AG._COLOR_DISPLAY_;
        _ALARM_ACTIVE_ := Model2AG._ALARM_ACTIVE_;
      end;
    lmModel3:
      begin
        MODEL_WORD := Model3.MODEL_WORD;
        GLOBAL_ENCRYPTION_KEY := Model3.GLOBAL_ENCRYPTION_KEY;
        REG_ENCODE_KEY := Model3.REG_ENCODE_KEY;
        HexDigits := Model3.HexDigits;
        for i := 0 to 15 do
          for k := 0 to 12 do
            ENCRYPTION_KEYS[i] := Model3.ENCRYPTION_KEYS[i];
        _LED_DISPLAY_MAX_ROW_COUNT_ := Model3._LED_DISPLAY_MAX_ROW_COUNT_;
        _LED_DISPLAY_MAX_COL_COUNT_ := Model3._LED_DISPLAY_MAX_COL_COUNT_;
        _INTERNAL_LFG_INLCUDED_ := Model3._INTERNAL_LFG_INLCUDED_;
        _COLOR_DISPLAY_ := Model3._COLOR_DISPLAY_;
        _ALARM_ACTIVE_ := Model3._ALARM_ACTIVE_;
      end;
    lmModel3Alarm:
      begin
        MODEL_WORD := Model3A.MODEL_WORD;
        GLOBAL_ENCRYPTION_KEY := Model3A.GLOBAL_ENCRYPTION_KEY;
        REG_ENCODE_KEY := Model3A.REG_ENCODE_KEY;
        HexDigits := Model3A.HexDigits;
        for i := 0 to 15 do
          for k := 0 to 12 do
            ENCRYPTION_KEYS[i] := Model3A.ENCRYPTION_KEYS[i];
        _LED_DISPLAY_MAX_ROW_COUNT_ := Model3A._LED_DISPLAY_MAX_ROW_COUNT_;
        _LED_DISPLAY_MAX_COL_COUNT_ := Model3A._LED_DISPLAY_MAX_COL_COUNT_;
        _INTERNAL_LFG_INLCUDED_ := Model3A._INTERNAL_LFG_INLCUDED_;
        _COLOR_DISPLAY_ := Model3A._COLOR_DISPLAY_;
        _ALARM_ACTIVE_ := Model3A._ALARM_ACTIVE_;
      end;
    lmModel3LFG:
      begin
        MODEL_WORD := Model3G.MODEL_WORD;
        GLOBAL_ENCRYPTION_KEY := Model3G.GLOBAL_ENCRYPTION_KEY;
        REG_ENCODE_KEY := Model3G.REG_ENCODE_KEY;
        HexDigits := Model3G.HexDigits;
        for i := 0 to 15 do
          for k := 0 to 12 do
            ENCRYPTION_KEYS[i] := Model3G.ENCRYPTION_KEYS[i];
        _LED_DISPLAY_MAX_ROW_COUNT_ := Model3G._LED_DISPLAY_MAX_ROW_COUNT_;
        _LED_DISPLAY_MAX_COL_COUNT_ := Model3G._LED_DISPLAY_MAX_COL_COUNT_;
        _INTERNAL_LFG_INLCUDED_ := Model3G._INTERNAL_LFG_INLCUDED_;
        _COLOR_DISPLAY_ := Model3G._COLOR_DISPLAY_;
        _ALARM_ACTIVE_ := Model3G._ALARM_ACTIVE_;
      end;
    lmModel3AlarmLFG:
      begin
        MODEL_WORD := Model3AG.MODEL_WORD;
        GLOBAL_ENCRYPTION_KEY := Model3AG.GLOBAL_ENCRYPTION_KEY;
        REG_ENCODE_KEY := Model3AG.REG_ENCODE_KEY;
        HexDigits := Model3AG.HexDigits;
        for i := 0 to 15 do
          for k := 0 to 12 do
            ENCRYPTION_KEYS[i] := Model3AG.ENCRYPTION_KEYS[i];
        _LED_DISPLAY_MAX_ROW_COUNT_ := Model3AG._LED_DISPLAY_MAX_ROW_COUNT_;
        _LED_DISPLAY_MAX_COL_COUNT_ := Model3AG._LED_DISPLAY_MAX_COL_COUNT_;
        _INTERNAL_LFG_INLCUDED_ := Model3AG._INTERNAL_LFG_INLCUDED_;
        _COLOR_DISPLAY_ := Model3AG._COLOR_DISPLAY_;
        _ALARM_ACTIVE_ := Model3AG._ALARM_ACTIVE_;
      end;
    {$ENDIF}

    {$IFDEF FULL_BRIGHT}
    lmBRModel1:
      begin
        MODEL_WORD := BRModel1.MODEL_WORD;
        GLOBAL_ENCRYPTION_KEY := BRModel1.GLOBAL_ENCRYPTION_KEY;
        REG_ENCODE_KEY := BRModel1.REG_ENCODE_KEY;
        HexDigits := BRModel1.HexDigits;
        for i := 0 to 15 do
          for k := 0 to 12 do
            ENCRYPTION_KEYS[i] := BRModel1.ENCRYPTION_KEYS[i];
        _LED_DISPLAY_MAX_ROW_COUNT_ := BRModel1._LED_DISPLAY_MAX_ROW_COUNT_;
        _LED_DISPLAY_MAX_COL_COUNT_ := BRModel1._LED_DISPLAY_MAX_COL_COUNT_;
        _INTERNAL_LFG_INLCUDED_ := BRModel1._INTERNAL_LFG_INLCUDED_;
        _COLOR_DISPLAY_ := BRModel1._COLOR_DISPLAY_;
        _ALARM_ACTIVE_ := BRModel1._ALARM_ACTIVE_;
      end;
    lmBRModel2:
      begin
        MODEL_WORD := BRModel2.MODEL_WORD;
        GLOBAL_ENCRYPTION_KEY := BRModel2.GLOBAL_ENCRYPTION_KEY;
        REG_ENCODE_KEY := BRModel2.REG_ENCODE_KEY;
        HexDigits := BRModel2.HexDigits;
        for i := 0 to 15 do
          for k := 0 to 12 do
            ENCRYPTION_KEYS[i] := BRModel2.ENCRYPTION_KEYS[i];
        _LED_DISPLAY_MAX_ROW_COUNT_ := BRModel2._LED_DISPLAY_MAX_ROW_COUNT_;
        _LED_DISPLAY_MAX_COL_COUNT_ := BRModel2._LED_DISPLAY_MAX_COL_COUNT_;
        _INTERNAL_LFG_INLCUDED_ := BRModel2._INTERNAL_LFG_INLCUDED_;
        _COLOR_DISPLAY_ := BRModel2._COLOR_DISPLAY_;
        _ALARM_ACTIVE_ := BRModel2._ALARM_ACTIVE_;
      end;
    lmBRModel3:
      begin
        MODEL_WORD := BRModel3.MODEL_WORD;
        GLOBAL_ENCRYPTION_KEY := BRModel3.GLOBAL_ENCRYPTION_KEY;
        REG_ENCODE_KEY := BRModel3.REG_ENCODE_KEY;
        HexDigits := BRModel3.HexDigits;
        for i := 0 to 15 do
          for k := 0 to 12 do
            ENCRYPTION_KEYS[i] := BRModel3.ENCRYPTION_KEYS[i];
        _LED_DISPLAY_MAX_ROW_COUNT_ := BRModel3._LED_DISPLAY_MAX_ROW_COUNT_;
        _LED_DISPLAY_MAX_COL_COUNT_ := BRModel3._LED_DISPLAY_MAX_COL_COUNT_;
        _INTERNAL_LFG_INLCUDED_ := BRModel3._INTERNAL_LFG_INLCUDED_;
        _COLOR_DISPLAY_ := BRModel3._COLOR_DISPLAY_;
        _ALARM_ACTIVE_ := BRModel3._ALARM_ACTIVE_;
      end;
    {$ENDIF}
  end;
  CheckLicenseStatusFull;
end;

function DetermineRegisteredLicenseModel: TLicenseModel;
var
  OldActiveModel: TLicenseModel;
begin
  OldActiveModel := ActiveLicenseModel;
  Result := lmNone;

  TRY

  {$IFDEF NORMAL_MODEL}
  SelectLicenseModel(lmModel1);
  if CheckLicenseStatusFull then
  begin
    Result := lmModel1;
    Exit;
  end;

  SelectLicenseModel(lmModel1Alarm);
  if CheckLicenseStatusFull then
  begin
    Result := lmModel1Alarm;
    Exit;
  end;

  SelectLicenseModel(lmModel1LFG);
  if CheckLicenseStatusFull then
  begin
    Result := lmModel1LFG;
    Exit;
  end;

  SelectLicenseModel(lmModel1AlarmLFG);
  if CheckLicenseStatusFull then
  begin
    Result := lmModel1AlarmLFG;
    Exit;
  end;

  SelectLicenseModel(lmModel2);
  if CheckLicenseStatusFull then
  begin
    Result := lmModel2;
    Exit;
  end;

  SelectLicenseModel(lmModel2Alarm);
  if CheckLicenseStatusFull then
  begin
    Result := lmModel2Alarm;
    Exit;
  end;

  SelectLicenseModel(lmModel2LFG);
  if CheckLicenseStatusFull then
  begin
    Result := lmModel2LFG;
    Exit;
  end;

  SelectLicenseModel(lmModel2AlarmLFG);
  if CheckLicenseStatusFull then
  begin
    Result := lmModel2AlarmLFG;
    Exit;
  end;

  SelectLicenseModel(lmModel3);
  if CheckLicenseStatusFull then
  begin
    Result := lmModel3;
    Exit;
  end;

  SelectLicenseModel(lmModel3Alarm);
  if CheckLicenseStatusFull then
  begin
    Result := lmModel3Alarm;
    Exit;
  end;

  SelectLicenseModel(lmModel3LFG);
  if CheckLicenseStatusFull then
  begin
    Result := lmModel3LFG;
    Exit;
  end;

  SelectLicenseModel(lmModel3AlarmLFG);
  if CheckLicenseStatusFull then
  begin
    Result := lmModel3AlarmLFG;
    Exit;
  end;

  {$ENDIF}

  {$IFDEF FULL_BRIGHT}
  SelectLicenseModel(lmBRModel1);
  if CheckLicenseStatusFull then
  begin
    Result := lmBRModel1;
    Exit;
  end;

  SelectLicenseModel(lmBRModel2);
  if CheckLicenseStatusFull then
  begin
    Result := lmBRModel2;
    Exit;
  end;

  SelectLicenseModel(lmBRModel3);
  if CheckLicenseStatusFull then
  begin
    Result := lmBRModel3;
    Exit;
  end;
  {$ENDIF}

  FINALLY

    SelectLicenseModel(OldActiveModel);

  END;
end;

end.
