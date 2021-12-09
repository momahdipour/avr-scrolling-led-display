unit CreateSupportFileFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, TntForms, StdCtrls, TntStdCtrls, sButton, ExtCtrls, sLabel,
  Buttons, TntButtons, sBitBtn,
  DCPcast128, DCPsha1, cls_id, magwmi, smartapi, magsubs1,
  MSI_Common, MSI_Storage,
  MSI_CPU, MiTeC_WinIOCTL, MSI_OS, MSI_Processes, MSI_SMBIOS,
  DateUtils, TntDialogs, ProcsUnit, SoundDialogs;

type
  TCreateSupportFileForm = class(TTntForm)
    Image1: TImage;
    sLabel5: TsLabel;
    CreateSupportFileBtn: TsBitBtn;
    OKBtn: TsButton;
    MiTeC_ProcessList1: TMiTeC_ProcessList;
    MiTeC_OperatingSystem1: TMiTeC_OperatingSystem;
    MiTeC_CPU1: TMiTeC_CPU;
    MiTeC_Storage1: TMiTeC_Storage;
    MiTeC_SMBIOS1: TMiTeC_SMBIOS;
    procedure CreateSupportFileBtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    function GetMiTecSerialStrings(var CPUID, BIOSInfo, MBInfo,
      HDSerial: String; var AllInfo: TStringList): Boolean;
    function CreateSupportFileInteractive: Boolean;
    function CreateSupportFile(FName: String): Boolean;
  end;

var
  CreateSupportFileForm: TCreateSupportFileForm;

implementation

uses MainUnit;

{$R *.dfm}

function GetSerialStringsForSupportFile(var CPUID, BIOSInfo, MBInfo, HDSerial: String): Boolean;
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

function TCreateSupportFileForm.CreateSupportFile(FName: String): Boolean;
var
  DataStrs: TStringList;
  i: Integer;
  Cipher: TDCP_cast128;
  bFile: File of Byte;
  Data: array of Byte;
  b: Byte;
  CRC32: LongWord;
  CPUID, BIOSInfo, MBInfo, HDSerial: String;
  MiTecInfo: TStringList;
begin
  Result := False;

  DataStrs := TStringList.Create;
  DataStrs.Clear;
  DataStrs.Sorted := False;

  //SetProcessAffinityMask(GetCurrentProcess, 1);  //If unable to set only the affinity of the main thread, set the affinity of the process

  GetSerialStringsForSupportFile(CPUID, BIOSInfo, MBInfo, HDSerial);
  DataStrs.Append('NEM Version: ' + SUPPORT_FILE_VERSION_STR);
  DataStrs.Append('CPUID From WMI: ' + CPUID);
  DataStrs.Append('BIOS Info From WMI: ' + BIOSInfo);
  DataStrs.Append('Motherboard Info From WMI: ' + MBInfo);
  DataStrs.Append('Hard Disk Serial From WMI: ' + HDSerial);

  MiTecInfo := TStringList.Create;
  MiTecInfo.Clear;
  MiTecInfo.Sorted := False;
  GetMiTecSerialStrings(CPUID, BIOSInfo, MBInfo, HDSerial, MiTecInfo);
  DataStrs.Append('CPUID From MiTec: ' + CPUID);
  DataStrs.Append('BIOS Info From MiTec: ' + BIOSInfo);
  DataStrs.Append('Motherboard Info From MiTec: ' + MBInfo);
  DataStrs.Append('Hard Disk Serial From MiTec: ' + HDSerial);
  for i := 0 to MiTecInfo.Count - 1 do
    DataStrs.Append(MiTecInfo.Strings[i]);
  MiTecInfo.Free;

  //Encrypt all strings
  Cipher := TDCP_cast128.Create(Self);
  Cipher.InitStr(SupportEnKey, TDCP_sha1);

  for i := 0 to DataStrs.Count - 1 do
    DataStrs.Strings[i] := Cipher.EncryptString(DataStrs.Strings[i]);
  Cipher.Burn;
  Cipher.Free;

  //Save result to file
  DataStrs.SaveToFile(FName);
  DataStrs.Free;

  //Add crc32 to file
  AssignFile(bFile, FName);
  Reset(bFile);
  SetLength(Data, FileSize(bFile));
  for i := 1 to FileSize(bFile) do
  begin
    Read(bFile, b);
    Data[i - 1] := b;
  end;
  CRC32 := MainForm.CalculateCRC32(Data);

  //Write CRC32
  b := CRC32 shr 24;  //high byte first
  Write(bFile, b);
  b := CRC32 shr 16;
  Write(bFile, b);
  b := CRC32 shr 8;
  Write(bFile, b);
  b := CRC32;
  Write(bFile, b);

  CloseFile(bFile);

  Result := True;
end;

function TCreateSupportFileForm.GetMiTecSerialStrings(var CPUID, BIOSInfo, MBInfo,
  HDSerial: String; var AllInfo: TStringList): Boolean;
var
  i: Integer;
  dt: TDateTime;
  DeviceTypeStr: String;
begin
  AllInfo.Clear;

  //Hard Disk Serial
  MiTeC_Storage1.RefreshData;
  AllInfo.Append('Storage Physical Count: ' + IntToStr(MiTeC_Storage1.PhysicalCount));
  for i := 0 to MiTeC_Storage1.PhysicalCount - 1 do
  begin
    AllInfo.Append('----------------------');
    AllInfo.Append('Storage ' + IntToStr(i));
    AllInfo.Append('----------------------');

    DeviceTypeStr := '';
    if MiTeC_Storage1.Physical[i].DeviceType in [FILE_DEVICE_CD_ROM] then
      DeviceTypeStr := DeviceTypeStr + 'FILE_DEVICE_CD_ROM';
    if MiTeC_Storage1.Physical[i].DeviceType in [FILE_DEVICE_DVD] then
      DeviceTypeStr := DeviceTypeStr + 'FILE_DEVICE_DVD';
    if MiTeC_Storage1.Physical[i].DeviceType in [FILE_DEVICE_TAPE] then
      DeviceTypeStr := DeviceTypeStr + 'FILE_DEVICE_TAPE';
    if MiTeC_Storage1.Physical[i].DeviceType in [FILE_DEVICE_UNKNOWN] then
      DeviceTypeStr := DeviceTypeStr + 'FILE_DEVICE_UNKNOWN';
    if MiTeC_Storage1.Physical[i].DeviceType in [FILE_DEVICE_DISK] then
      DeviceTypeStr := DeviceTypeStr + 'FILE_DEVICE_DISK';

    AllInfo.Append('  Device Type: ' + DeviceTypeStr);

    if MiTeC_Storage1.Physical[i].Removable then
      AllInfo.Append('  Removable: YES')
    else
      AllInfo.Append('  Removable: NO');

    AllInfo.Append('  Model: ' + MiTeC_Storage1.Physical[i].Model);
    AllInfo.Append('  Serial Number: ' + MiTeC_Storage1.Physical[i].SerialNumber);
  end;
  HDSerial := 'NULL';
  for i := 0 to MiTeC_Storage1.PhysicalCount - 1 do
    if MiTeC_Storage1.Physical[i].DeviceType = FILE_DEVICE_DISK then
    begin
      if not MiTeC_Storage1.Physical[i].Removable then
      begin
        HDSerial := MiTeC_Storage1.Physical[i].SerialNumber;
        Break;
      end;
    end;

  //CPU Serial
  MiTeC_CPU1.RefreshData;
  MiTeC_CPU1.CPUIndex := 0;
  CPUID := MiTeC_CPU1.SerialNumber;

  BIOSInfo := 'NULL';
  MBInfo := 'NULL';

  AllInfo.Append('CPU Count: ' + IntToStr(MiTeC_CPU1.CPUCount));
  AllInfo.Append('CPU Physical Count: ' + IntToStr(MiTeC_CPU1.CPUPhysicalCount));

  MiTeC_OperatingSystem1.RefreshData;
  with MiTeC_OperatingSystem1 do
    AllInfo.Append(OSName + ' ' + OSEdition + ' ' + IntToStr(MajorVersion) + '.' + IntToStr(MinorVersion) + '.' + IntToStr(BuildNumber) + ' <Version: ' + MiTeC_OperatingSystem1.Version + '> <CSD: ' + CSD + '> <Install Date: Year=' + IntToStr(YearOf(InstallDate)) + ' Month= ' + IntToStr(MonthOf(InstallDate)) + ' Day= ' + IntToStr(DayOf(InstallDate)) + '> <BuildLab: ' + BuildLab + '>');
  dt := Date;
  AllInfo.Append('Current Date: Year=' + IntToStr(YearOf(dt)) + ' Month=' + IntToStr(MonthOf(dt)) + ' Day=' + IntToStr(DayOf(dt)));
  dt := GetTime;
  AllInfo.Append('Current Time: Hour=' + IntToStr(HourOf(dt)) + ' Minute=' + IntToStr(MinuteOf(dt)) + ' Second=' + IntToStr(SecondOf(dt)));

  AllInfo.Append('Process List');
  AllInfo.Append('-------------');
  MiTeC_ProcessList1.RefreshData;
  for i := 0 to MiTeC_ProcessList1.ProcessCount - 1 do
  begin
    AllInfo.Append(IntToStr(i) + '. Name: ' + MiTeC_ProcessList1.Processes[i].Name + ' ImageName: ' + MiTeC_ProcessList1.Processes[i].ImageName + ' UserName: ' + MiTeC_ProcessList1.Processes[i].UserName);
  end;
  AllInfo.Append('Process List Done!');

  AllInfo.Append('SMBIOS Info');
  AllInfo.Append('------------------');
  MiTeC_SMBIOS1.RefreshData;
  with MiTeC_SMBIOS1 do
  begin
    AllInfo.Append('MainBoardModel:' + MainBoardModel + ',MainBoardManufacturer:' + MainBoardManufacturer + ',SystemModel:' + SystemModel + ',SystemManufacturer:' + SystemManufacturer + ',SystemVersion:' + SystemVersion + ',SystemSerial:' + SystemSerial);
    AllInfo.Append('BIOSVendor:' + BIOSVendor + ',BIOSVersion:' + BIOSVersion);
  end;
end;

function TCreateSupportFileForm.CreateSupportFileInteractive: Boolean;
var
  SaveDialog: TTntSaveDialog;
  FileName: String;
begin
  Result := False;
  SaveDialog := TTntSaveDialog.Create(nil);
  TRY

  try
    SaveDialog.Options := SaveDialog.Options + [ofPathMustExist, ofNoReadOnlyReturn, ofCreatePrompt, ofOverwritePrompt];
    SaveDialog.Filter := 'Support Files (*.nem)|*.nem';
    if SaveDialog.Execute then
    begin
      FileName := SaveDialog.FileName;
      FileName := Procs.ApplyFileNameExtension(FileName, '.nem', True);
      Result := CreateSupportFile(FileName);
      if Result then
        MessageDlgSoundTop(WideFormat(Dyn_Texts[140], [#13 + FileName]) , mtInformation, [mbOK], 0);
    end;
  finally
    SaveDialog.Free;
  end;

  EXCEPT

   WideMessageDlgSoundTop(Dyn_Texts[139] {'Error occurred during the operation. Please try again.'}, mtError, [mbOK], 0);

  END;
end;

procedure TCreateSupportFileForm.CreateSupportFileBtnClick(
  Sender: TObject);
begin
  CreateSupportFileInteractive;
end;

end.
