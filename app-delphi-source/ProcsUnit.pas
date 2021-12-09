unit ProcsUnit;

{$WARN UNIT_PLATFORM OFF}

interface

uses
  Controls, DateUtils, Grids, ADODB, Classes, ShlOBJ, Windows, Forms,
  Graphics, ExtCtrls, StdCtrls, Printers, Tlhelp32, Registry, ShellAPI,
  FileCtrl, ActiveX, IniFiles, TntClasses, TntSysUtils;

type
//  FreePIDLProc  =  procedure (PIDL: PItemIDList); stdcall;  --> Not used anymore

  TDirection = (diHorizontal, diVertical);

  TDateTimeRec = record
    Year, Month, Day: Word;
    Hour, Minute, Second, Milliseconds: Word;
  end;

  TProcs = class(TObject)
    private
      BlinkForm: TForm;
      BlinkTimer: TTimer;
      procedure BlinkTimerOnTimer(Sender: TObject);
    protected
    public
      constructor Create; overload;
      destructor Destroy; reintroduce;
      function StrToInteger(const Str:String; var Value:Integer):Boolean;
      function CompareDates(const Date1,Date2:String):Integer;
      function MiladiIsLeap(miladiYear: Integer): Boolean;
      procedure ChristianToSolar(var Y, M, D: Word);
      procedure SolarToChristian(var Y, M, D: Word);
      function IntToStrMinLen(Value:Integer; MinLen: Integer): String;
      function TodaySolarDate: String;
      function TodaySolarDateTime: TDateTimeRec;
      procedure AutosizeStringGridColumns(AStringGrid: TStringGrid);
      procedure LoadTableToGrid(ATable: TADOTable; AStringGrid: TStringGrid);
      function FileCopy(const SourceFileName, DesFileName: String): Boolean;
      function WideFileCopy(const SourceFileName,
        DesFileName: WideString): Boolean;
      function FileMove(const SourecFileName,DesFileName:String):Boolean;
      function IsValidAccessDatabase(const DatabseFileName: String): Boolean;
      function IsValidSolarDate(const ADate: String): Boolean;
      function BooleanToInt(ABooleanValue: Boolean): Integer;
      function ChristianToSolarStr(ADate: TDateTime; DateFormat: Integer): String;
      function BrowseForFolder(const DialogCaption: String; var FolderName: String): Boolean;
      function BrowseForFolderW(const Caption: WideString; const Root: WideString;
        var Directory: WideString): Boolean;
      function IsInCSVList(const CSVList: String; Value: Integer): Boolean;
      function StrToDateSolar(const DateStr: String; DateSep: Char): TDateTime;
      function SubStrCount(const SubStr, Str: String): Integer;
      function IsValidInt(const S: String): Boolean;
      function ValidateCSVList(const CSVList: String): Boolean;
      function GetFullyQualifiedFilName(const FName:String):String;
      function HexToBinStr(HexStr: String): String;  //Don't declare constant parameter (reference by value)
      procedure ScaleBitmap(Source, Dest: TBitmap; ScaleFactor: Cardinal);

      procedure BlinkScreen(BlinkColor: TColor; BlinkCount: Integer);
      function KeyDown(KeyVirtCode:Integer):Boolean;
      procedure PrintBitmap(ABitmap: TBitmap; FitToPage: Boolean;
        const PrintTitle: String);

      procedure GetProcessList(ProcessList: TStringList);
      function ProcessExists(const ExeFileName: String): Boolean;
      function ProcessInstanceCount(const ExeFileName: String): Integer;

      function GetAssociation(const DocFileName: String): String;
      function ExecuteProgramNoWait(const ProgramFileName: String): Boolean;

      function ExtractFileNameWithoutExt(const FileName: String): String;
      function WideExtractFileNameWithoutExt(
        const FileName: WideString): WideString;

      function RegKeyExists(const Key: String; RootKey: HKEY = HKEY_CURRENT_USER): Boolean;
      function RegValueExists(const Key, Name: String; RootKey: HKEY = HKEY_CURRENT_USER): Boolean;
      function RegReadValue(const Key, Name: String; var Value: String;
        RootKey: HKEY = HKEY_CURRENT_USER): Boolean;

      function OpenUrlInDefaultBrowser(const Url: String): Boolean;

      function IsVKCodeALphaNumberic(VirtualKeyCode: Word): Boolean;

      function WideDirectoryExists(const Directory: WideString): Boolean;

      function Min(Values: array of Double): Double;
      function Max(Values: array of Double): Double;
      procedure RGBToHSL(R, G, B: Byte; var H, S, L: Byte);
      procedure HSLToRGB(H, S, L: Byte; var R, G, B: Byte);
      function TransparentColor(ForeColor, BackColor: TColor;
        ForeColorTransparencyPercent: Integer): TColor;

      function FileSize(const FileName: String): Int64;
      function WideFileSize(const FileName: WideString): Int64;

      procedure SetWindowPosition(Form: TCustomForm; Position: TPosition;
        ToMainFormMonitor: Boolean);

      procedure MoveFormIntoScreen(Form: TCustomForm);

      function IsReadOnlyFile(const FileName: String): Boolean;
      function WideIsReadOnlyFile(const FileName: WideString): Boolean;
      function IsSystemFile(const FileName: String): Boolean;

      function ApplyFileNameExtension(const FileName,
        Extension {Format: .xxxx (is not case sensitive)}: WideString;
        ForceExtension: Boolean = False): WideString;

      function RemoveLastDelimiter(const Delimiter: Char;
        const S: String): String;

      function ExtractFilterString(const Filter: String;
        FilterIndex: Integer): String;
      function GetFilterIndex(const Filter, Extension: String): Integer;

      {File version information functions}
      function GetFileVersion64(const AFileName: string; var VersionMS,
        VersionLS: Cardinal): Boolean;
      function GetFileVersionString(const AFileName: String): String;

      function IsWindowsAdmin: Boolean;

      function HexStrToByte(const HexStr: String): Byte;

      function MirrorBits(Value: LongWord; FromBit, ToBit: Integer): LongWord;

      function GetSpecialFolderPath(Folder: Integer): String;

      function GenerateTemporaryFileName(const Path,
        NamePrefix: String): String;
      function GenerateTemporaryFileNameW(const Path,
        NamePrefix: WideString): WideString;
      function GetTempFilesPath: String;
      function GetTempFilesPathW: WideString;

      function LoadAnimatedCursorFromResource(Instance: Cardinal;
        const ResName, ResType: String): HCURSOR;

      function SetFolderIcon(const FolderPath: String; const FolderInfoTip: String;
        const IconFileFullPath: String; IconIndex: Integer = 0;
        CopyFileIconToFolder: Boolean = True): Boolean;

      function IfThenW(AValue: Boolean; const ATrue: WideString;
        const AFalse: WideString): WideString;

      procedure SleepNoBlock(Milliseconds: Cardinal);

      procedure TrimBitmapUnusedBorders(b: TBitmap);

      function CompareMemoryStreams(MemStream1,
        MemStream2: TMemoryStream): Boolean;
      function CompareBinaryFiles(const File1, File2: String): Boolean;

      function TwipsToPixelsExact(Twips: Integer; Direction: TDirection): Integer;
      function TwipsToPixelsForSWF(Twips: Integer): Integer;

      function CompareTimes(Hour1, Minute1, Second1, Hour2, 
        Minute2, Second2: Integer): Integer;
    published
  end;


var
  Procs : TProcs;
//  FreePIDL : FreePIDLProc = nil;  --> Not used anymore

implementation

uses SysUtils, Variants, StrUtils, Math;

function TProcs.StrToInteger(const Str:String; var Value:Integer):Boolean;
var
  Temp,ErrCode:Integer;
begin
  Result:=False;
  try
    Val(Str,Temp,ErrCode);
    if ErrCode=0 then
    begin
      Result:=True;
      Value:=Temp;
    end;
  except
    Exit;
  end;
end;

function TProcs.CompareDates(const Date1, Date2: String): Integer;
var
  Year1,Month1,Day1:Integer;
  Year2,Month2,Day2:Integer;
  ErrCode:Integer;
begin
  //Date1: yyyy/mm/dd
  //Date2: yyyy/mm/dd
  //Result: 0=Equal, -1:Date1<Date2, 1:Date1>Date2
  Result:=0;

  val(Copy(Date1,1,4),Year1,ErrCode);
  if ErrCode<>0 then Exit;
  val(Copy(Date1,6,2),Month1,ErrCode);
  if ErrCode<>0 then Exit;
  val(Copy(Date1,9,2),Day1,ErrCode);
  if ErrCode<>0 then Exit;

  val(Copy(Date2,1,4),Year2,ErrCode);
  if ErrCode<>0 then Exit;
  val(Copy(Date2,6,2),Month2,ErrCode);
  if ErrCode<>0 then Exit;
  val(Copy(Date2,9,2),Day2,ErrCode);
  if ErrCode<>0 then Exit;

  if Year1<Year2 then Result:=-1
  else if Year1>Year2 then Result:=1
  else if Month1<Month2 then Result:=-1
  else if Month1>Month2 then Result:=1
  else if Day1<Day2 then Result:=-1
  else if Day1>Day2 then Result:=1
  else Result:=0;
end;

function TProcs.MiladiIsLeap(miladiYear: Integer): Boolean;
begin
  Result := ( ((miladiYear mod 100) <> 0) and ((miladiYear mod 4) = 0) ) or
            ( ((miladiYear mod 100) = 0) and ((miladiYear mod 400) = 0) );
end;

procedure TProcs.ChristianToSolar(var Y, M, D: Word);

const
  sumDayMiladiMonth: array[0..11] of Integer = (0,31,59,90,120,151,181,212,243,273,304,334);
  sumDayMiladiMonthLeap: array[0..11] of Integer = (0,31,60,91,121,152,182,213,244,274,305,335);
var
  //DateTimeTemp:TDateTime;
  shamsiDay, shamsiMonth, shamsiYear: Integer;
  dayCount, farvardinDayDiff, deyDayDiff: Integer;
begin
  farvardinDayDiff := 79;

  if MiladiIsLeap(Y) then
  begin
    dayCount := sumDayMiladiMonthLeap[M-1] + D;
  end
  else
  begin
    dayCount := sumDayMiladiMonth[M-1] + D;
  end;

  if MiladiIsLeap(Y - 1) then
  begin
    deyDayDiff := 11;
  end
  else
  begin
    deyDayDiff := 10;
  end;

  if dayCount > farvardinDayDiff then
  begin
    dayCount := dayCount - farvardinDayDiff;
    if dayCount <= 186 then
    begin
      case (dayCount mod 31) of
        0:
          begin
            shamsiMonth := Trunc(dayCount / 31);
            shamsiDay := 31;
          end;
        else
          begin
            shamsiMonth := Trunc(dayCount / 31) + 1;
            shamsiDay := dayCount mod 31;
          end;
      end;
      shamsiYear := Y - 621;
    end
    else
    begin
      dayCount := dayCount - 186;
      case (dayCount mod 30) of
        0:
          begin
              shamsiMonth := Trunc(dayCount / 30) + 6;
              shamsiDay := 30;
          end;
        else
          begin
              shamsiMonth := Trunc(dayCount / 30) + 7;
              shamsiDay := dayCount mod 30;
          end;
      end;
      shamsiYear := Y - 621;
    end;
  end
  else
  begin
    dayCount := dayCount + deyDayDiff;
    case (dayCount mod 30) of
      0:
        begin
          shamsiMonth := Trunc(dayCount / 30) + 9;
          shamsiDay := 30;
        end;
      else
        begin
          shamsiMonth := Trunc(dayCount / 30) + 10;
          shamsiDay := dayCount mod 30;
        end;
    end;
    shamsiYear := Y - 622;
  end;

  Y := shamsiYear;
  M := shamsiMonth;
  D := shamsiDay;

(*COULD NOT CONVERT 2009/03/18 CORRECTLY TO 1387/12/28

  //******************* Leap year
  if Y=2000 then
    if M>2 then
    begin
      DateTimeTemp:=EncodeDate(Y,M,D);
      DateTimeTemp:=IncDay(DateTimeTemp,1);
      DecodeDate(DateTimeTemp,Y,M,D);
    end;
  //*******************

  if (M<3) or ((M=3) and (D<21)) then
    Y:=Y-622
  else
    Y:=Y-621;

  case M of
    1:
      if D<21 then
      begin
        M:=10;  D:=D+10;
      end
      else
      begin
        M:=11;  D:=D-20;
      end;
    2:
      if D<20 then
      begin
        M:=11;  D:=D+11;
      end
      else
      begin
        M:=12;  D:=D-19;
      end;
    3:
      if D<21 then
      begin
        M:=12;  D:=D+9;
      end
      else
      begin
         M:=1;  D:=D-20;
      end;
    4:
      if D<21 then
      begin
        M:=1;  D:=D+11;
      end
      else
      begin
        M:=2;  D:=D-20;
      end;
    5,6:
      if D<22 then
      begin
        M:=M-3;  D:=D+10;
      end
      else
      begin
        M:=M-2;  D:=D-21;
      end;
    7,8,9:
      if D<23 then
      begin
        M:=M-3;  D:=D+9;
      end
      else
      begin
        M:=M-2;  D:=D-22;
      end;
    10:
      if D<23 then
      begin
        M:=7;  D:=D+8;
      end
      else
      begin
        M:=8;  D:=D-22;
      end;
    11,12:
      if D<22 then
      begin
        M:=M-3;  D:=D+9;
      end
      else
      begin
        M:=M-2;  D:=D-21;
      end;
  end;
  *)
end;

function TProcs.IntToStrMinLen(Value, MinLen: Integer): String;
begin
  Result := IntToStr(Value);
  if Value < 0 then
    Result := '-' + StringOfChar('0', MinLen-Length(Result) - 1) + Copy(Result, 2, Length(Result) - 1)
  else
    Result := StringOfChar('0', MinLen-Length(Result)) + Result;
end;

function TProcs.TodaySolarDate: String;
var
  Y,M,D: Word;
begin
  DecodeDate(Date,Y,M,D);
  ChristianToSolar(Y,M,D);
  Result:=Procs.IntToStrMinLen(Y,4)+'/'+Procs.IntToStrMinLen(M,2)+'/'+Procs.IntToStrMinLen(D,2);
end;

function TProcs.TodaySolarDateTime: TDateTimeRec;
var
  Y,M,D: Word;
  Hour, Min, Sec, MSec: Word;
begin
  DecodeDate(Date,Y,M,D);
  ChristianToSolar(Y,M,D);
  DecodeTime(Time, Hour, Min, Sec, MSec);
  Result.Year := Y;
  Result.Month := M;
  Result.Day := D;
  Result.Hour := Hour;
  Result.Minute := Min;
  Result.Second := Sec;
  Result.Milliseconds := MSec;
end;

procedure TProcs.AutosizeStringGridColumns(AStringGrid: TStringGrid);
var
  MinWidth, Row, Col: Integer;
begin
  for Col:=0 to AStringGrid.ColCount - 1 do
  begin
    MinWidth:=AStringGrid.Canvas.TextWidth(AStringGrid.Cells[Col,0]);
    for Row:=1 to AStringGrid.RowCount - 1 do
      if MinWidth<AStringGrid.Canvas.TextWidth(AStringGrid.Cells[Col,Row]) then
        MinWidth:=AStringGrid.Canvas.TextWidth(AStringGrid.Cells[Col,Row]);
    AStringGrid.ColWidths[Col]:=MinWidth + 8;
  end;
end;

procedure TProcs.LoadTableToGrid(ATable: TADOTable;
  AStringGrid: TStringGrid);
var
  Row, Col: Integer;
begin
  if ATable.RecordCount<=0 then
  begin
    AStringGrid.RowCount:=1;
    AStringGrid.RowCount:=2;
    AStringGrid.ColCount:=1;
    AStringGrid.FixedRows:=1;
    AStringGrid.Cells[0,0]:='';
    Exit;
  end;

  AStringGrid.RowCount:=ATable.RecordCount+1;
  AStringGrid.FixedRows:=1;

  AStringGrid.ColCount:=ATable.FieldCount;
  for Col:=0 to AStringGrid.ColCount - 1 do
    AStringGrid.Cells[Col,0]:=ATable.Fields[Col].FieldName;

  ATable.First;
  for Row:=1 to ATable.RecordCount do
  begin
    for Col:=0 to AStringGrid.ColCount - 1 do
      AStringGrid.Cells[Col,Row]:=VarToStr(ATable.Fields[Col].Value);
    ATable.Next;
  end;

  AStringGrid.Row:=1;
end;

function TProcs.FileCopy(const SourceFileName,
  DesFileName: String): Boolean;
var
  Source, Des: TFileStream;
begin
  Result:=False;
  Source:=TFileStream.Create(SourceFileName,fmOpenRead);
  Des:=TFileStream.Create(DesFileName,fmOpenWrite or fmCreate);
  try
    Des.CopyFrom(Source,Source.Size);
    Des.Free;
    Source.Free;
    Result:=True;
  except
    Source.Free;
    Des.Free;
  end;
end;

function TProcs.WideFileCopy(const SourceFileName,
  DesFileName: WideString): Boolean;
var
  Source, Des: TTntFileStream;
begin
  Result := False;
  Source := TTntFileStream.Create(SourceFileName, fmOpenRead);
  Des := TTntFileStream.Create(DesFileName, fmOpenWrite or fmCreate);
  try
    Des.CopyFrom(Source, Source.Size);
    Des.Free;
    Source.Free;
    Result:=True;
  except
    Source.Free;
    Des.Free;
  end;
end;

function TProcs.IsValidAccessDatabase(const DatabseFileName: String): Boolean;
var
  ADOConnection: TADOConnection;
begin
  ADOConnection := TADOConnection.Create(nil);
  ADOConnection.LoginPrompt := False;
  ADOConnection.ConnectionString := 'Provider=Microsoft.Jet.OLEDB.4.0;Data Source=' + DatabseFileName + ';Mode=ReadWrite|Share Deny None;Persist Security Info=False';
  try
    ADOConnection.Open;
    Result := True;
    ADOConnection.Close;
  except
    Result := False;
  end;
  ADOConnection.Free;
end;

function TProcs.IsValidSolarDate(const ADate: String): Boolean;
var
  i: Integer;
  DateStr: String;
  Year, Month, Day: String;
begin
  if Length(ADate)=0 then
  begin
    Result:=True;
    Exit;
  end;
  Result:=False;
  DateStr:=ADate;
  //***************************************
  if Pos('/',DateStr)<2 then Exit;
  Year:=Copy(DateStr,1,Pos('/',DateStr)-1);
  Delete(DateStr,1,Length(Year)+1);
  if not StrToInteger(Year,i) then Exit;
  if (i>9999) or (i<1) then Exit;
  //***************************************
  if Pos('/',DateStr)<2 then Exit;
  Month:=Copy(DateStr,1,Pos('/',DateStr)-1);
  Delete(DateStr,1,Length(Month)+1);
  if not StrToInteger(Month,i) then Exit;
  if (i>12) or (i<1) then Exit;
  //***************************************
  if Pos('/',DateStr)<>0 then Exit;
  Day:=DateStr;
  if not StrToInteger(Day,i) then Exit;
  if (i>31) or (i<1) then Exit;
  //***************************************
  Result:=True;
end;

function TProcs.BooleanToInt(ABooleanValue: Boolean): Integer;
begin
  //BooleanToInt:
  //Returns: 1 for True
  //         0 for False
  if ABooleanValue then
    Result := 1
  else
    Result := 0;
end;

function TProcs.ChristianToSolarStr(ADate: TDateTime;
  DateFormat: Integer): String;
var
  Y, M, D: Word;
begin
  //DateFormat is not used in this version - Default with 0
  DecodeDate(ADate, Y, M, D);
  ChristianToSolar(Y, M, D);
  Result:=Procs.IntToStrMinLen(Y,4)+'/'+Procs.IntToStrMinLen(M,2)+'/'+Procs.IntToStrMinLen(D,2);
end;

function TProcs.BrowseForFolder(const DialogCaption: String; var FolderName: String): Boolean;
{var
  BrowseInfo: TBrowseInfo;
  ItemIDList: PItemIDList;
  ItemSelected : PItemIDList;
  NameBuffer: array[0..MAX_PATH] of Char;
  WindowList: Pointer;}
begin
  Result := SelectDirectory(DialogCaption, '', FolderName);

{  itemIDList := nil;
  FillChar(BrowseInfo, SizeOf(BrowseInfo), 0);
  BrowseInfo.hwndOwner := Application.Handle;
  BrowseInfo.pidlRoot := ItemIDList;
  BrowseInfo.pszDisplayName := NameBuffer;
  BrowseInfo.lpszTitle := PChar(DialogCaption);
  BrowseInfo.ulFlags := BIF_RETURNONLYFSDIRS;
  WindowList := DisableTaskWindows(0);
  try
    ItemSelected := SHBrowseForFolder(BrowseInfo);
    Result := ItemSelected <> nil;
  finally
    EnableTaskWindows(WindowList);
  end;

  if Result then
   begin
    SHGetPathFromIDList(ItemSelected, NameBuffer);
    FolderName := NameBuffer;
   end;
  FreePIDL(BrowseInfo.pidlRoot);}
end;

function SelectDirCB_W(Wnd: HWND; uMsg: UINT; lParam, lpData: LPARAM): Integer stdcall;
begin
  if (uMsg = BFFM_INITIALIZED) and (lpData <> 0) then
    SendMessageW(Wnd, BFFM_SETSELECTIONW, Integer(True), lpdata);
  result := 0;
end;

function TProcs.BrowseForFolderW(const Caption: WideString; const Root: WideString;
  var Directory: WideString): Boolean;
// Here is the code from the TntFileCtrl unit:
const
  BIF_NEWDIALOGSTYLE = $0040;
  BIF_USENEWUI = (BIF_NEWDIALOGSTYLE or BIF_EDITBOX);
var
  WindowList: Pointer;
  BrowseInfo: TBrowseInfoW;
  Buffer: PWideChar;
  OldErrorMode: Cardinal;
  RootItemIDList, ItemIDList: PItemIDList;
  ShellMalloc: IMalloc;
  IDesktopFolder: IShellFolder;
  Eaten, Flags: LongWord;
  AnsiDirectory: AnsiString;
{ Here is my own code:
var
  BrowseInfo: TBrowseInfoW;
  ItemIDList: PItemIDList;
  ItemSelected : PItemIDList;
  NameBuffer: array[0..MAX_PATH] of WideChar;
  WindowList: Pointer;
}
begin
// Here is the code from the TntFileCtrl unit:
  if (not {Win32PlatformIsUnicode} (Win32Platform = VER_PLATFORM_WIN32_NT)) then begin
    AnsiDirectory := Directory;
    Result := SelectDirectory{TNT-ALLOW SelectDirectory}(Caption, Root, AnsiDirectory);
    Directory := AnsiDirectory;
  end else begin
    Result := False;
    if not WideDirectoryExists(Directory) then
      Directory := '';
    FillChar(BrowseInfo, SizeOf(BrowseInfo), 0);
    if (ShGetMalloc(ShellMalloc) = S_OK) and (ShellMalloc <> nil) then
    begin
      Buffer := ShellMalloc.Alloc(MAX_PATH * SizeOf(WideChar));
      try
        RootItemIDList := nil;
        if Root <> '' then
        begin
          SHGetDesktopFolder(IDesktopFolder);
          IDesktopFolder.ParseDisplayName(Application.Handle, nil,
            POleStr(Root), Eaten, RootItemIDList, Flags);
        end;
        with BrowseInfo do
        begin
          hwndOwner := Application.Handle;
          pidlRoot := RootItemIDList;
          pszDisplayName := Buffer;
          lpszTitle := PWideChar(Caption);
          ulFlags := BIF_RETURNONLYFSDIRS;
          if Win32MajorVersion >= 5 then
            ulFlags := ulFlags; //or BIF_USENEWUI;  --> This new flag adds a 'Make New Folder' to the dialog and also makes the dialog resizeable.
          if Directory <> '' then
          begin
            lpfn := SelectDirCB_W;
            lParam := Integer(PWideChar(Directory));
          end;
        end;
        WindowList := DisableTaskWindows(0);
        OldErrorMode := SetErrorMode(SEM_FAILCRITICALERRORS);
        try
          ItemIDList := SHBrowseForFolderW(BrowseInfo);
        finally
          SetErrorMode(OldErrorMode);
          EnableTaskWindows(WindowList);
        end;
        Result :=  ItemIDList <> nil;
        if Result then
        begin
          ShGetPathFromIDListW(ItemIDList, Buffer);
          ShellMalloc.Free(ItemIDList);
          Directory := Buffer;
        end;
      finally
        ShellMalloc.Free(Buffer);
      end;
    end;
  end;
{ Here is my own code:
  itemIDList := nil;
  FillChar(BrowseInfo, SizeOf(BrowseInfo), 0);
  BrowseInfo.hwndOwner := Application.Handle;
  BrowseInfo.pidlRoot := ItemIDList;
  BrowseInfo.pszDisplayName := NameBuffer;
  BrowseInfo.lpszTitle := PWideChar(DialogCaption);
  BrowseInfo.ulFlags := BIF_RETURNONLYFSDIRS;
  WindowList := DisableTaskWindows(0);
  try
    ItemSelected := SHBrowseForFolderW(BrowseInfo);
    Result := ItemSelected <> nil;
  finally
    EnableTaskWindows(WindowList);
  end;

  if Result then
   begin
    SHGetPathFromIDListW(ItemSelected, NameBuffer);
    FolderName := NameBuffer;
   end;
  FreePIDL(BrowseInfo.pidlRoot);
}
end;

//var
//  ShellHandle: THandle = 0;  --> Not used anymore

procedure TProcs.BlinkScreen(BlinkColor: TColor; BlinkCount: Integer);
begin
  BlinkForm.Color := BlinkColor;
  BlinkTimer.Tag := (BlinkCount - 1) * 2 + 1;
  BlinkForm.Show;
  BlinkTimer.Enabled := True;
end;

constructor TProcs.Create;
begin
  inherited;

  BlinkForm := TForm.Create(Application);
  BlinkForm.Hide;
  BlinkForm.BorderStyle := bsNone;
  BlinkForm.FormStyle := fsStayOnTop;
  BlinkForm.WindowState := wsMaximized;

  BlinkTimer := TTimer.Create(nil);
  BlinkTimer.Enabled := False;
  BlinkTimer.Interval := 200;
  BlinkTimer.OnTimer := BlinkTimerOnTimer;
end;

destructor TProcs.Destroy;
begin
  if BlinkForm <> nil then
  begin
    BlinkForm.Hide;
    BlinkForm.Free;
  end;

  if BlinkTimer <> nil then
    BlinkTimer.Free;

  inherited Destroy;
end;

procedure TProcs.BlinkTimerOnTimer(Sender: TObject);
begin
  BlinkForm.Visible := not BlinkForm.Visible;
  BlinkTimer.Tag := BlinkTimer.Tag - 1;
  if BlinkTimer.Tag = 0 then
  begin
    BlinkTimer.Enabled := False;
    BlinkForm.Hide;
    Exit;
  end;
end;

function TProcs.IsInCSVList(const CSVList: String;
  Value: Integer): Boolean;
var
  OldPos, NextPos: Integer;
begin
  //This function does not check to validate numbers.
  Result := False;
  if Length(CSVList) = 0 then Exit;
  OldPos := 1;
  repeat
    NextPos := PosEx(',', CSVList, OldPos);
    if NextPos = 0 then
      NextPos := Length(CSVList) + 1;
    Result := StrToInt(Copy(CSVList, OldPos, NextPos - OldPos)) = Value;
    OldPos := NextPos + 1;
  until (OldPos > Length(CSVList)) or Result;
end;

{$WARNINGS OFF}
function TProcs.StrToDateSolar(const DateStr: String; DateSep: Char): TDateTime;
resourcestring
  RaiseMsg = '''%s'' is not a valid solar date.';
var
  TempStr: String;
  ConvError: Boolean;
  StartPos, EndPos: Integer;
  Y, M, D: Word;
begin
  ConvError := SubStrCount('/', DateStr) <> 2;
  ConvError := ConvError or (DateStr[1] = DateSep) or (DateStr[Length(DateStr)] = DateSep);
  ConvError := ConvError or ( (DateSep <> ' ') and (Pos(' ', DateStr) > 0) );
  if ConvError then
    raise EConvertError.CreateFmt(RaiseMsg, [DateStr]);

 //Get year
  StartPos := 1;
  EndPos := PosEx(DateSep, DateStr, StartPos);
  TempStr := Copy(DateStr, StartPos, EndPos - StartPos);
  if (Length(TempStr) <= 4) and IsValidInt(TempStr) then
  begin
    Y := StrToInt(TempStr);
    if Length(TempStr) < 3 then
      Y := Y + 1300;
  end
  else
    raise EConvertError.CreateFmt(RaiseMsg, [DateStr]);
  //Get month
  StartPos := EndPos + 1;
  EndPos := PosEx(DateSep, DateStr, StartPos);
  TempStr := Copy(DateStr, StartPos, EndPos - StartPos);
  if (Length(TempStr) <= 2) and IsValidInt(TempStr) then
    M := StrToInt(TempStr)
  else
    raise EConvertError.CreateFmt(RaiseMsg, [DateStr]);
  //Get day
  TempStr := Copy(DateStr, EndPos + 1, Length(DateStr) - EndPos);
  if (Length(TempStr) <= 2) and IsValidInt(TempStr) then
    D := StrToInt(TempStr)
  else
    raise EConvertError.CreateFmt(RaiseMsg, [DateStr]);
  //Check number values to be valid
  if (Y < 0) or (M < 1) or (M > 12) or (D < 1) or (D > 31) then
    raise EConvertError.CreateFmt(RaiseMsg, [DateStr]);

  SolarToChristian(Y, M, D);
  Result := EncodeDate(Y, M, D);
end;
{$WARNINGS ON}

function TProcs.SubStrCount(const SubStr, Str: String): Integer;
var
  OldPos, NextPos: Integer;
begin
  Result := 0;
  if (Length(Str) = 0) or (Length(Substr) = 0) then
    Exit;
  OldPos := 1;
  repeat
    NextPos := PosEx(SubStr, Str, OldPos);
    if NextPos > 0 then
      Inc(Result);
    OldPos := NextPos + Length(SubStr);
  until (NextPos = 0) or (OldPos > Length(Str));
end;

{$HINTS OFF}
function TProcs.IsValidInt(const S: String): Boolean;
var
  Temp, ErrCode: Integer;
begin
  val(S, Temp, ErrCode);
  Result := ErrCode = 0;
end;
{$HINTS ON}

procedure TProcs.SolarToChristian(var Y, M, D: Word);
const
  miladiMonthConst: array[0..11] of Integer = (30,31,30,31,31,30,31,30,31,31,28,31);  //day count of Miladi month from April to January for a none year
var
  iYear, iMonth, iDay: Integer;
  marchDayDiff, remainDay: Integer;
  dayCount, miladiYear, i: Integer;
  miladiMonth: array[0..11] of Integer;
begin
  for i := 0 to 11 do
    miladiMonth[i] := miladiMonthConst[i];

  miladiYear := Y + 621;

  //Detemining the Farvardin the First

  if MiladiIsLeap(miladiYear) then
  begin
    //this is a Miladi leap year so Shamsi is leap too so the 1st of Farvardin is March 20 (3/20)
    marchDayDiff := 12;
  end
  else
  begin
    //this is not a Miladi leap year so Shamsi is not leap too so the 1st of Farvardin is March 21 (3/21)
    marchDayDiff := 11;
  end;

  // If next year is leap we will add one day to Feb.
  if MiladiIsLeap(miladiYear+1) then
  begin
    miladiMonth[10] := miladiMonth[10] + 1; //Adding one day to Feb
  end;

  //Calculate the day count for input shamsi date from 1st Farvadin

  if (M >= 1) and (M <= 6) then
    dayCount := ((M-1) * 31) + D
  else
    dayCount := (6 * 31) + ((M - 7) * 30) + D;

  //Finding the correspond miladi month and day

  if dayCount <= marchDayDiff then  //So we are in 20(for leap year) or 21for none leap year) to 31 march
  begin
    iDay := dayCount + (31 - marchDayDiff);
    iMonth := 3;
    iYear := miladiYear;
  end
  else
  begin
    remainDay := dayCount - marchDayDiff;

    i := 0; //starting from April

    while remainDay > miladiMonth[i] do
    begin
      remainDay := remainDay - miladiMonth[i];
      Inc(i);
    end;
    iDay := remainDay;

    if i > 8 then  // We are in the next Miladi Year
    begin
      iMonth := i - 8;
      iYear :=  miladiYear + 1;
    end
    else
    begin
      iMonth := i + 4;
      iYear := miladiYear;
    end;
  end;


  Y := iYear;
  M := iMonth;
  D := iDay;

(*MAY HAVE BUGS LIKE OLD ChristianToSolar PROCEDURE
  //******************* Leap year
  if Y = 1378 then
  begin
    if (M = 12) and (D = 10) then
    begin
      Y := 2000; M := 2; D := 29;
      Exit;
    end;
    if (M = 12) and (D > 10) then
      D := D - 1;
  end
  else if Y = 1379 then
  begin
    D := D - 1;
    if D = 0 then
    begin
      M := M - 1;
      if (M > 0) and (M < 7) then D := 31;
      if M > 6 then D := 30;
      if M = 0 then
      begin
        D := 29; M := 12; Y := Y - 1;
      end;
    end;
  end;
  //*******************
  if (M < 10) or ((M = 10) and (D < 11)) then
    Y := Y + 621
  else
    Y := Y + 622;
  case M of
    1:
      if D < 12 then
      begin
        M := 3; D := D + 20;
      end
      else
      begin
        M := 4; D := D - 11;
      end;
    2:
      if D < 11 then
      begin
        M := 4; D := D + 20;
      end
      else
      begin
        M := 5; D := D - 10;
      end;
    3:
      if D < 11 then
      begin
        M := 5; D := D + 21;
      end
      else
      begin
        M := 6; D := D - 10;
      end;
    4:
      if D < 10 then
      begin
        M := 6; D := D + 21;
      end
      else
      begin
        M := 7; D := D - 9;
      end;
    5, 6, 8:
      if D < 10 then
      begin
        M := M + 2; D := D + 22;
      end
      else
      begin
        M := M + 3; D := D - 9;
      end;
    7:
      if D < 9 then
      begin
        M := 9; D := D + 22;
      end
      else
      begin
        M := 10; D := D - 8;
      end;
    9:
      if D < 10 then
      begin
        M := 11; D := D + 21;
      end
      else
      begin
        M := 12; D := D - 9;
      end;
    10:
      if D < 11 then
      begin
        M := 12; D := D + 21;
      end
      else
      begin
        M := 1; D := D - 10;
      end;
    11:
      if D < 12 then
      begin
        M := 1; D := D + 20;
      end
      else
      begin
        M := 2; D := D - 11;
      end;
    12:
      if D < 10 then
      begin
        M := 2; D := D + 19;
      end
      else
      begin
        M := 3; D := D - 9;
      end;
  end;
  *)
end;

function TProcs.ValidateCSVList(const CSVList: String): Boolean;
var
  i: Integer;
  Comma: Boolean;
begin
  Result := False;
  Comma := True;
  for i := 1 to Length(CSVList) do
  begin
    if CSVList[i] in ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'] then
      Comma := False
    else if CSVList[i] = ',' then
    begin
      if Comma then
        Exit
      else
        Comma := True;
    end
    else
      Exit;
  end;
  Result := not Comma;
end;

function TProcs.FileMove(const SourecFileName,
  DesFileName: String): Boolean;
begin
  if not FileCopy(SourecFileName,DesFileName) then
    Result:=False
  else
  begin
    if not DeleteFile(SourecFileName) then
    begin
      Result:=False;
      DeleteFile(DesFileName);
    end
    else
      Result:=True;
  end;
end;

function TProcs.GetFullyQualifiedFilName(const FName: String): String;
var
  FullName:array of Char;
  FNamePos:PChar;
  ResLength: Cardinal;
begin
  try
    Result:=FName;
    SetLength(FullName,2000);
    ResLength:=GetFullPathName(PChar(FName),Length(FullName),Pointer(FullName),FNamePos);
    if (ResLength > 0) and (ResLength < Cardinal(Length(FullName))) then
      Result:=String(Copy(FullName,0,ResLength));
  finally
    SetLength(FullName,0);
  end;
end;

function TProcs.KeyDown(KeyVirtCode: Integer): Boolean;
begin
  //Note: The virtual key code fot the ALT key is VK_MENU
  Result:=(GetKeyState(KeyVirtCode) and $80)=$80;
end;

function TProcs.HexToBinStr(HexStr: String): String;
  function HexCharToBinStr(HexChar: Char): String;
  begin
    case HexChar of
      '0': Result := '0000';
      '1': Result := '0001';
      '2': Result := '0010';
      '3': Result := '0011';
      '4': Result := '0100';
      '5': Result := '0101';
      '6': Result := '0110';
      '7': Result := '0111';
      '8': Result := '1000';
      '9': Result := '1001';
      'A': Result := '1010';
      'B': Result := '1011';
      'C': Result := '1100';
      'D': Result := '1101';
      'E': Result := '1110';
      'F': Result := '1111';
    end;
  end;
var
  i: Integer;
begin
  HexStr := UpperCase(HexStr);
  Result := '';
  for i:=1 to Length(HexStr) do
    Result := Result + HexCharToBinStr(HexStr[i]);
end;

procedure TProcs.ScaleBitmap(Source, Dest: TBitmap; ScaleFactor: Cardinal);
begin
  Dest.Width := Trunc(Cardinal(Source.Width) * ScaleFactor / 100);
  Dest.Height := Trunc(Cardinal(Source.Height) * ScaleFactor / 100);

  Dest.Canvas.CopyRect(Rect(0, 0, Dest.Width, Dest.Height), Source.Canvas, Rect(0, 0, Source.Width, Source.Height));
end;

procedure TProcs.PrintBitmap(ABitmap: TBitmap; FitToPage: Boolean;
  const PrintTitle: String);

  function SafeScale(Source, Dest: TBitmap; ScaleFactor: Cardinal): Boolean;
  begin
    Result := True;
    try
      ScaleBitmap(Source, Dest, ScaleFactor);
    except
      Result := False;
    end;
  end;

var
  b: TBitmap;
  ScaleFactor: Cardinal;
begin
  b := TBitmap.Create;

  try

  Printer.Title := PrintTitle;
  Application.NormalizeAllTopMosts;
  if FitToPage then
  begin
    if Printer.PageWidth < Printer.PageHeight then
      ScaleFactor := Trunc(Printer.PageWidth / ABitmap.Width * 100)
    else
      ScaleFactor := Trunc(Printer.PageHeight / ABitmap.Height * 100);
    while not SafeScale(ABitmap, b, ScaleFactor) do
      ScaleFactor := Trunc(ScaleFactor / 2);
    Printer.BeginDoc;
    Printer.Canvas.Draw(0, 0, b);
  end
  else
  begin
    Printer.BeginDoc;
    Printer.Canvas.Draw(0, 0, ABitmap);
  end;

  finally

  b.Free;
  Application.RestoreTopMosts;
  Printer.EndDoc;

  end;
end;

procedure TProcs.GetProcessList(ProcessList: TStringList);
var
  ContinueLoop:BOOL;
  FSnapshotHandle:THandle;
  FProcessEntry32:TProcessEntry32;
begin
  ProcessList.Clear;
  FSnapshotHandle:=CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS,0);
  FProcessEntry32.dwSize:=SizeOf(FProcessEntry32);
  ContinueLoop:=Process32First(FSnapshotHandle,FProcessEntry32);
  while Integer(ContinueLoop)<>0 do
  begin
    ProcessList.Append(FProcessEntry32.szExeFile);
    ContinueLoop:=Process32Next(FSnapshotHandle,FProcessEntry32);
  end;
  CloseHandle(FSnapshotHandle);
end;

function TProcs.ProcessExists(const ExeFileName: String): Boolean;
begin
  //ExeFileName = FileName.exe
  Result := ProcessInstanceCount(ExeFileName) > 0;
end;

function TProcs.ProcessInstanceCount(const ExeFileName: String): Integer;
var
  ProcList: TStringList;
  i: Integer;
begin
  //ExeFileName = FileName.exe
  Result := 0;
  ProcList := TStringList.Create;
  try
    GetProcessList(ProcList);
    for i := 0 to ProcList.Count - 1 do
      if ( LowerCase(ExtractFileName(ProcList.Strings[i])) = LowerCase(ExeFileName) ) or
         ( LowerCase(ProcList.Strings[i]) = LowerCase(ExeFileName) ) then
        Inc(Result);
    ProcList.Free;
  except
    ProcList.Free;
  end;
end;

function TProcs.GetAssociation(const DocFileName: String): String;
var
  FileClass: String;
  Reg: TRegistry;
begin
  Result := '';
  Reg := TRegistry.Create(KEY_EXECUTE);
  try
    Reg.RootKey := HKEY_CLASSES_ROOT;
    FileClass := '';
    if Reg.OpenKeyReadOnly(ExtractFileExt(DocFileName)) then
    begin
      FileClass := Reg.ReadString('');
      Reg.CloseKey;
    end;
    if FileClass <> '' then
    begin
      if Reg.OpenKeyReadOnly(FileClass + '\shell\open\command') then
      begin
        Result := Reg.ReadString('');
        Reg.CloseKey;
      end;
    end;
  except
    Result := '';
    Reg.Free;
  end;
end;

function TProcs.ExecuteProgramNoWait(
  const ProgramFileName: String): Boolean;
var
  StartupInfo:TStartupInfo;
  ProcessInformation:TProcessInformation;
begin
  StartupInfo.cb:=SizeOf(TStartupInfo);
  StartupInfo.lpReserved:=nil;
  StartupInfo.lpDesktop:=nil;
  StartupInfo.lpTitle:=nil;
  StartupInfo.dwFlags:=0;
  if CreateProcess(PChar(ProgramFileName), nil, nil, nil, False, NORMAL_PRIORITY_CLASS, nil, nil, StartupInfo, ProcessInformation) = False then
    Result := False
  else
    Result := True;
end;

function TProcs.ExtractFileNameWithoutExt(const FileName: String): String;
begin
  Result := LeftStr(ExtractFileName(FileName),
      Length(ExtractFileName(FileName)) - Length(ExtractFileExt(FileName)));
end;

function TProcs.WideExtractFileNameWithoutExt(const FileName: WideString): WideString;
begin
  Result := Copy(WideExtractFileName(FileName), 1, Length(WideExtractFileName(FileName)) - Length(WideExtractFileExt(FileName)));
end;

function TProcs.RegKeyExists(const Key: String; RootKey: HKEY): Boolean;
var
  Reg: TRegistry;
begin
  Result := False;
  Reg := TRegistry.Create(KEY_READ or KEY_QUERY_VALUE or KEY_ENUMERATE_SUB_KEYS);  //No need to have specific access permission and also no need to have the specified key open
  try
    Reg.RootKey := RootKey;
    Result := Reg.KeyExists(Key);
    Reg.Free;
  except
    Reg.Free;
  end;
end;

function TProcs.RegValueExists(const Key, Name: String;
  RootKey: HKEY): Boolean;
var
  Reg: TRegistry;
begin
  Result := False;
  Reg := TRegistry.Create(KEY_READ or KEY_QUERY_VALUE or KEY_ENUMERATE_SUB_KEYS);
  try
    Reg.RootKey := RootKey;
    if Reg.OpenKeyReadOnly(Key) then
      Result := Reg.ValueExists(Name);
    Reg.Free;
  except
    Reg.Free;
  end;
end;

function TProcs.OpenUrlInDefaultBrowser(const Url: String): Boolean;
begin
  //Returns True if successful, otherwise False
  Result := ShellExecute(0, 'open', PChar(Url), nil, nil, SW_SHOW) > 32;
end;

function TProcs.IsVKCodeALphaNumberic(VirtualKeyCode: Word): Boolean;
const
  VK_0 = $30;
  VK_9 = $39;
  VK_A = $41;
  VK_Z = $5A;
begin
  Result := ( (VirtualKeyCode >= VK_0) and (VirtualKeyCode <= VK_9) ) or
            ( (VirtualKeyCode >= VK_NUMPAD0) and (VirtualKeyCode <= VK_NUMPAD9) ) or
            ( (VirtualKeyCode >= VK_A) and (VirtualKeyCode <= VK_Z) );
end;

function TProcs.WideDirectoryExists(const Directory: WideString): Boolean;
var
  Code: Integer;
begin
  Code := GetFileAttributesW(PWideChar(Directory));
  Result := (Code <> -1) and (FILE_ATTRIBUTE_DIRECTORY and Code <> 0);
end;

function TProcs.Min(Values: array of Double): Double;
var
  i: Integer;
begin
  if Length(Values) = 0 then
    raise Exception.Create('No values in TProcs.Min function.');
  Result := Values[0];
  for i := 1 to High(Values) do
    if Values[i] < Result then
      Result := Values[i];
end;

function TProcs.Max(Values: array of Double): Double;
var
  i: Integer;
begin
  if Length(Values) = 0 then
    raise Exception.Create('No values in TProcs.Max function.');
  Result := Values[0];
  for i := 1 to High(Values) do
    if Values[i] > Result then
      Result := Values[i];
end;

procedure TProcs.RGBToHSL(R, G, B: Byte; var H, S, L: Byte);
var
  var_R, var_G, var_B: Double;
  var_Min, var_Max, del_Max: Double;
  del_R, del_G, del_B: Double;
  HD, SD, LD: Double;
begin
  var_R := ( R / 255 );                     //Where RGB values = 0 ÷ 255
  var_G := ( G / 255 );
  var_B := ( B / 255 );

  var_Min := Min([var_R, var_G, var_B]);    //Min. value of RGB
  var_Max := Max([var_R, var_G, var_B]);    //Max. value of RGB
  del_Max := var_Max - var_Min;             //Delta RGB value

  LD := ( var_Max + var_Min ) / 2;

  HD := 0;  {prevent compiler warning}
  if del_Max = 0 then                     //This is a gray, no chroma...
  begin
    HD := 0;                                //HSL results = 0 ÷ 1
    SD := 0;
  end
  else                                    //Chromatic data...
  begin
    if  LD < 0.5  then
      SD := del_Max / ( var_Max + var_Min )
    else
      SD := del_Max / ( 2 - var_Max - var_Min );

   del_R := ( ( ( var_Max - var_R ) / 6 ) + ( del_Max / 2 ) ) / del_Max;
   del_G := ( ( ( var_Max - var_G ) / 6 ) + ( del_Max / 2 ) ) / del_Max;
   del_B := ( ( ( var_Max - var_B ) / 6 ) + ( del_Max / 2 ) ) / del_Max;

   if var_R = var_Max then
     HD := del_B - del_G
   else if var_G = var_Max then
     HD := ( 1 / 3 ) + del_R - del_B
   else if var_B = var_Max then
     HD := ( 2 / 3 ) + del_G - del_R;

   if HD < 0 then HD := HD + 1.0;
   if HD > 1 then HD := HD - 1.0;
  end;
  //HD, SD, LD in range (0..1)
  //H, S, L in range 0..255
  H := Trunc(HD * 255);
  S := Trunc(SD * 255);
  L := Trunc(LD * 255);
end;

procedure TProcs.HSLToRGB(H, S, L: Byte; var R, G, B: Byte);
  function Hue_2_RGB( v1, v2, vH: Double): Double;             //Function Hue_2_RGB
  begin
    if vH < 0 then vH := vH + 1.0;
    if vH > 1 then vH := vH - 1.0;
    if ( 6 * vH ) < 1 then
    begin
      Result := v1 + ( v2 - v1 ) * 6 * vH;
      Exit;
    end;
    if ( 2 * vH ) < 1 then
    begin
      Result :=  ( v2 );
      Exit;
    end;
    if ( 3 * vH ) < 2 then
    begin
      Result := ( v1 + ( v2 - v1 ) * ( ( 2 / 3 ) - vH ) * 6 );
      Exit;
    end;
    Result := v1;
  end;

var
  HD, SD, LD: Double;
  var_1, var_2: Double;
begin
  //H, S, L in range 0..255
  //GD, SD, LD in range 0..1
  HD := H / 255;
  SD := S / 255;
  LD := L / 255;

  if SD = 0 then                       //HSL values = 0 ÷ 1
  begin
    R := Trunc(LD * 255);                      //RGB results = 0 ÷ 255
    G := Trunc(LD * 255);
    B := Trunc(LD * 255);
  end
  else
  begin
    if LD < 0.5 then
      var_2 := LD * ( 1 + SD )
    else
      var_2 := ( LD + SD ) - ( SD * LD );

    var_1 := 2 * LD - var_2;

    R := Trunc( 255 * Hue_2_RGB( var_1, var_2, HD + ( 1 / 3 ) ) );
    G := Trunc( 255 * Hue_2_RGB( var_1, var_2, HD ) );
    B := Trunc( 255 * Hue_2_RGB( var_1, var_2, HD - ( 1 / 3 ) ) );
  end;
end;

function TProcs.TransparentColor(ForeColor, BackColor: TColor;
  ForeColorTransparencyPercent: Integer): TColor;
var
  InvertTransparency: Integer;
  ForeColorRGB, BackColorRGB: Integer;
  dstPixel, srcPixel: TRGBTriple;
begin
  ForeColorRGB := ColorToRGB(ForeColor);
  BackColorRGB := ColorToRGB(BackColor);

  dstPixel.rgbtRed := ForeColorRGB;
  dstPixel.rgbtGreen := ForeColorRGB shr 8;
  dstPixel.rgbtBlue := ForeColorRGB shr 16;

  srcPixel.rgbtRed := BackColorRGB;
  srcPixel.rgbtGreen := BackColorRGB shr 8;
  srcPixel.rgbtBlue := BackColorRGB shr 16;

  InvertTransparency := 100 - ForeColorTransparencyPercent;
  dstPixel.rgbtRed := ((InvertTransparency * dstPixel.rgbtRed) +
                       (ForeColorTransparencyPercent * srcPixel.rgbtRed)) div 100;
  dstPixel.rgbtGreen := ((InvertTransparency * dstPixel.rgbtGreen) +
                         (ForeColorTransparencyPercent * srcPixel.rgbtGreen)) div 100;
  dstPixel.rgbtBlue := ((InvertTransparency * dstPixel.rgbtBlue) +
                        (ForeColorTransparencyPercent * srcPixel.rgbtBlue)) div 100;

  Result := RGB(dstPixel.rgbtRed, dstPixel.rgbtGreen, dstPixel.rgbtBlue);
end;

function TProcs.FileSize(const FileName: String): Int64;
var
  fs: TFileStream;
begin
  Result := 0;
  if not FileExists(FileName) then
    Exit;
  try
    fs := TFileStream.Create(FileName, fmOpenRead, fmShareDenyNone);
    Result := fs.Size;
    fs.Free;
  except
    ;
  end;
end;

function TProcs.WideFileSize(const FileName: WideString): Int64;
var
  fs: TTntFileStream;
begin
  Result := 0;
  if not WideFileExists(FileName) then
    Exit;
  try
    fs := TTntFileStream.Create(FileName, fmOpenRead);
    Result := fs.Size;
    fs.Free;
  except
    ;
  end;
end;

function TProcs.RegReadValue(const Key, Name: String; var Value: String;
  RootKey: HKEY): Boolean;
var
  Reg: TRegistry;
begin
  Result := False;
  Reg := TRegistry.Create(KEY_READ or KEY_QUERY_VALUE or KEY_ENUMERATE_SUB_KEYS);
  try
    Reg.RootKey := RootKey;
    if Reg.OpenKeyReadOnly(Key) then
    begin
      if Reg.ValueExists(Name) then
        Value := Reg.ReadString(Name)
      else
        Result := True;
      Reg.CloseKey;
    end
    else
      Result := True;
    Result := not Result;
    Reg.Free;
  except
    Reg.Free;
  end;
end;

procedure TProcs.SetWindowPosition(Form: TCustomForm; Position: TPosition;
  ToMainFormMonitor: Boolean);
var
  X, Y: Integer;
begin
  //This procedure does not change the monitor of the form
  case Position of
    poMainFormCenter:
      begin
        X := (Application.MainForm.ClientWidth - Form.Width) div 2;
        Y := (Application.MainForm.ClientHeight - Form.Height) div 2;
      end;
    poScreenCenter:
      begin
        X := (Screen.Width - Form.Width) div 2;
        Y := (Screen.Height - Form.Height) div 2;
      end;
    poDesktopCenter:
      begin
        X := (Screen.DesktopWidth - Form.Width) div 2;
        Y := (Screen.DesktopHeight - Form.Height) div 2;
      end;
    else
      Exit;
  end;

  if X < 0 then X := 0;
  if Y < 0 then Y := 0;
  if not( (Position = poMainFormCenter) and (Form = Application.MainForm) ) then
    Form.SetBounds(X, Y, Form.Width, Form.Height);
  if ToMainFormMonitor and Assigned(Application.MainForm) then
    Form.MakeFullyVisible(Application.MainForm.Monitor);
end;

procedure TProcs.MoveFormIntoScreen(Form: TCustomForm);
begin
  if Form.Left < 0 then
    Form.Left := 0;
  if (Form.Left + Form.Width) > Screen.Width then
    Form.Left := Screen.Width - Form.Width;
  if Form.Top < 0 then
    Form.Top := 0;
  if (Form.Top + Form.Height) > Screen.Height then
    Form.Top := Screen.Height - Form.Height;
end;

function TProcs.IsReadOnlyFile(const FileName: String): Boolean;
var
  FAttrs: Cardinal;
begin
  Result := FileExists(FileName);
  if Result then
  begin
    FAttrs := Windows.GetFileAttributes(PAnsiChar(FileName));
    (*FAttrs = $FFFFFFFF {function failed}*)
    Result := (FAttrs and FILE_ATTRIBUTE_READONLY) <> 0;
  end;
end;

function TProcs.WideIsReadOnlyFile(const FileName: WideString): Boolean;
var
  FAttrs: Cardinal;
begin
  Result := WideFileExists(FileName);
  if Result then
  begin
    FAttrs := Windows.GetFileAttributesW(PWideChar(FileName));
    (*FAttrs = $FFFFFFFF {function failed}*)
    Result := (FAttrs and FILE_ATTRIBUTE_READONLY) <> 0;
  end;
end;

function TProcs.IsSystemFile(const FileName: String): Boolean;
var
  FAttrs: Cardinal;
begin
  Result := FileExists(FileName);
  if Result then
  begin
    FAttrs := Windows.GetFileAttributes(PAnsiChar(FileName));
    (*FAttrs = $FFFFFFFF {function failed}*)
    Result := (FAttrs and FILE_ATTRIBUTE_SYSTEM) <> 0;
  end;
end;

function TProcs.ApplyFileNameExtension(const FileName,
  Extension {Format: .xxxx}: WideString;
  ForceExtension: Boolean = False): WideString;
begin
{
  Notes:
        1. Extension format: .xxxx (is not case sensitive)
        2. If the Extension parameter includes wildcards, no extendion is
           appended to the FileName.
        3. If the file has an extension, no extension is appended to the
           FileName unless ForceExtension is True.
}

  Result := FileName;
  if (Pos('*', Extension) < 1) and (Pos('?', Extension) < 1) then
  begin
    if (WideLowerCase(ExtractFileExt(FileName)) <> WideLowerCase(Extension)) then
      if ForceExtension or
         (Length(ExtractFileExt(FileName)) < 2) then
      Result := Result + Extension;
  end;
  //The extension includes wildcards. Don't append it to the filename.
end;

function TProcs.RemoveLastDelimiter(const Delimiter: Char;
  const S: String): String;
begin
  if S[Length(S)] = Delimiter then
    Result := Copy(S, 1, Length(S) - 1)
  else
    Result := S;
end;

function TProcs.ExtractFilterString(const Filter: String;
  FilterIndex: Integer): String;
var
  CurrentFilterIndex: Integer;
  NextPos, FilterLen: Integer;
begin
  Result := '';
  CurrentFilterIndex := 1;
  NextPos := Pos('|', Filter);
  while (NextPos >= 1) and (NextPos <> Length(Filter)) and
        (CurrentFilterIndex <> FilterIndex) do
  begin
    NextPos := PosEx('|', Filter, NextPos + 1);
    if NextPos < 1 then
      Break;
    NextPos := posEx('|', Filter, NextPos + 1);
    Inc(CurrentFilterIndex);
  end;
  if NextPos >= 1 then
  begin
    FilterLen := PosEx('|', Filter, NextPos + 1);
    if FilterLen >= 1 then
      FilterLen := FilterLen - NextPos - 1
    else
      FilterLen := Length(Filter) - NextPos;
    Result := MidStr(Filter, NextPos + 1, FilterLen);
  end;
end;

function TProcs.GetFilterIndex(const Filter, Extension: String): Integer;
var
  FilterAtIndex: String;
begin
{
  Notes:
        1. Filter format is the same as the Filter property for dialogs.
        2. Extension format: .xxxx
}
  Result := 1;
  repeat
    FilterAtIndex := Procs.ExtractFilterString(Filter, Result);
    if ExtractFileExt(FilterAtIndex) = Extension then
      Break;
    Inc(Result);
  until Length(FilterAtIndex) = 0;
  if Length(FilterAtIndex) = 0 then
    Result := 1;
end;

function TProcs.GetFileVersion64(const AFileName: string;
  var VersionMS, VersionLS: Cardinal): Boolean;
var
  FileName: string;
  InfoSize, Wnd: DWORD;
  VerBuf: Pointer;
  FI: PVSFixedFileInfo;
  VerSize: DWORD;
begin
  Result := False;
  // GetFileVersionInfo modifies the filename parameter data while parsing.
  // Copy the string const into a local variable to create a writeable copy.
  FileName := AFileName;
  UniqueString(FileName);
  InfoSize := GetFileVersionInfoSize(PChar(FileName), Wnd);
  if InfoSize <> 0 then
  begin
    GetMem(VerBuf, InfoSize);
    try
      if GetFileVersionInfo(PChar(FileName), Wnd, InfoSize, VerBuf) then
        if VerQueryValue(VerBuf, '\', Pointer(FI), VerSize) then
        begin
          VersionMS := FI.dwFileVersionMS;
          VersionLS := FI.dwFileVersionLS;
          Result := True;
        end;
    finally
      FreeMem(VerBuf);
    end;
  end;
end;

function TProcs.GetFileVersionString(const AFileName: String): String;
var
  MS, LS: Cardinal;
begin
{
  Returns empty string if the function fails.
}
  if GetFileVersion64(AFileName, Ms, LS) then
    Result := IntToStr(MS shr 16) + '.' + IntToStr(MS and $0000FFFF) + '.' +
              IntToStr(LS shr 16) + '.' + IntToStr(LS and $0000FFFF)
  else
    Result := EmptyStr;
end;

function TProcs.IsWindowsAdmin: Boolean;
const
  SECURITY_NT_AUTHORITY: TSIDIdentifierAuthority = (Value: (0, 0, 0, 0, 0, 5)) ;
  SECURITY_BUILTIN_DOMAIN_RID = $00000020;
  DOMAIN_ALIAS_RID_ADMINS = $00000220;
var
  hAccessToken: THandle;
  ptgGroups: PTokenGroups;
  dwInfoBufferSize: DWORD;
  psidAdministrators: PSID;
  g: Integer;
  bSuccess: BOOL;
begin
  Result := False;

  bSuccess := OpenThreadToken(GetCurrentThread, TOKEN_QUERY, True, hAccessToken) ;
  if not bSuccess then
  begin
    if GetLastError = ERROR_NO_TOKEN then
      bSuccess := OpenProcessToken(GetCurrentProcess, TOKEN_QUERY, hAccessToken) ;
  end;


  if bSuccess then
  begin
    GetMem(ptgGroups, 1024) ;

    bSuccess := GetTokenInformation(hAccessToken, TokenGroups, ptgGroups, 1024, dwInfoBufferSize) ;

    CloseHandle(hAccessToken) ;

    if bSuccess then
    begin
      AllocateAndInitializeSid(SECURITY_NT_AUTHORITY, 2, SECURITY_BUILTIN_DOMAIN_RID, DOMAIN_ALIAS_RID_ADMINS, 0, 0, 0, 0, 0, 0, psidAdministrators) ;

      for g := 0 to ptgGroups.GroupCount - 1 do
        if EqualSid(psidAdministrators, ptgGroups.Groups[g].Sid) then
        begin
          Result := True;
          Break;
        end;

      FreeSid(psidAdministrators) ;
    end;

    FreeMem(ptgGroups) ;
  end;
end;

function TProcs.HexStrToByte(const HexStr: String): Byte;

  function HexCharToDec(C: Char): Byte;
  begin
    case C of
      '0'..'9': Result := Ord(C) - Ord('0');
      'A'..'F': Result := Ord(C) - Ord('A') + 10;
      'a'..'f': Result := Ord(C) - Ord('a') + 10;
      else
        Result := 0;
    end;
  end;

begin
  Result := HexCharToDec(HexStr[1]) * 16 + HexCharToDec(HexStr[2]);
end;

function TProcs.MirrorBits(Value: LongWord; FromBit,
  ToBit: Integer): LongWord;
var
  b1, b2: LongWord;
  Count, i: Integer;
begin
  b1 := $FFFFFFFF shl FromBit;
  b2 := $FFFFFFFF shr (32 - ToBit);
  Result := Value and not(b1 and b2);
  SetRoundMode(rmUp);
  Count := Round((ToBit - FromBit + 1) / 2);  //Round up
  for i := 0 to Count - 1 do
  begin
    b1 := (Value shr (FromBit + i)) and $00000001;
    b2 := (Value shr (ToBit - i)) and $00000001;

    Result := Result or (b2 shl (FromBit + i));
    Result := Result or (b1 shl (ToBit - i));
  end;
end;

function TProcs.GetSpecialFolderPath(Folder: Integer): String;
var
  PIDL: PItemIDList;
  Path: LPSTR;
  AMalloc: IMalloc;
begin
  Path := StrAlloc(MAX_PATH);
  SHGetSpecialFolderLocation(Application.Handle, Folder, PIDL);
  if SHGetPathFromIDList(PIDL, Path) then
    Result := Path;
  SHGetMalloc(AMalloc);
  AMalloc.Free(PIDL);
  StrDispose(Path);
end;

function TProcs.GenerateTemporaryFileName(const Path,
  NamePrefix: String): String;
//Notes: 1. Creates the file in the specified location
//       2. Returns full path and file name
var
  FName: array[0..MAX_PATH - 1] of Char;
begin
  FName := '';
  GetTempFileName(PChar(Path), PChar(NamePrefix), 0, @FName);
  Result := FName;
end;

function TProcs.GenerateTemporaryFileNameW(const Path,
  NamePrefix: WideString): WideString;
//Notes: 1. Creates the file in the specified location
//       2. Returns full path and file name
var
  FName: array[0..MAX_PATH - 1] of WideChar;
begin
  FName[0] := #0;
  GetTempFileNameW(PWideChar(Path), PWideChar(NamePrefix), 0, @FName);
  Result := FName;
end;

function TProcs.GetTempFilesPath: String;
var
  Path: array[0..MAX_PATH - 1] of Char;
  res: Cardinal;
begin
  res := GetTempPath(MAX_PATH, @Path);
  if (res = 0) or (res > MAX_PATH) then
    Result := GetCurrentDir
  else
    Result := Path;
end;

function TProcs.GetTempFilesPathW: WideString;
var
  Path: array[0..MAX_PATH - 1] of WideChar;
  res: Cardinal;
begin
  res := GetTempPathW(MAX_PATH, @Path);
  if (res = 0) or (res > MAX_PATH) then
    Result := GetCurrentDir
  else
    Result := Path;
end;

function TProcs.LoadAnimatedCursorFromResource(Instance: Cardinal;
  const ResName, ResType: String): HCURSOR;
var
  rs: TResourceStream;
  TmpFName: String;
begin
  Result := HCURSOR(nil);
  rs := nil;
  try
    rs := TResourceStream.Create(Instance, ResName, PChar(ResType));
  except
    if Assigned(rs) then
      rs.Free;
    Exit;
  end;
  TmpFName := GenerateTemporaryFileName(GetTempFilesPath, '');
  try
    rs.SaveToFile(TmpFName);
  except
    rs.Free;
    Exit;
  end;
  rs.Free;
  try
    Result := LoadCursorFromFile(PChar(TmpFName));
  except
  end;
  DeleteFile(TmpFName);
end;

function TProcs.SetFolderIcon(const FolderPath, FolderInfoTip,
  IconFileFullPath: String; IconIndex: Integer;
  CopyFileIconToFolder: Boolean): Boolean;
  (*
  Description:
  INPUT PARAMETERS:
    FolderPath: Full path of the folder you want to change its icon
    FoldeInfoTip: InfoTip of the folder you want to change its icon
    IconFileFullPath: Full path and filename of the icon file
    IconIndex: If the file IconFileFullPath is a .dll or .exe file (not a .ico file), you should define the icon index of it. Otherwise set it to 0 for single .ico files.
    CopyFileIconToFolder: If True, the icon file specified by IconFileFullPath is copied to the destination folder and the icon file of that folders refers to the new copied file, so it will be independent of the path of the source icon file.
  RESULT:
    Returns True if successful, otherwise returns False.
  *)
var
  IniFile: TIniFile;
  IconFileName: String;
  ParentFolder: String;
begin
  Result := False;
  try
    if CopyFileIconToFolder then
    begin
      if not FileExists(IconFileFullPath) then
        Exit;
      if FileExists(FolderPath + '\' + ExtractFileName(IconFileFullPath)) then
        SetFileAttributes(PChar(FolderPath + '\' + ExtractFileName(IconFileFullPath)), FILE_ATTRIBUTE_NORMAL);  //Change file attributes to normal to be able to overwrite it
      if not CopyFile(PChar(IconFileFullPath), PChar(FolderPath + '\' + ExtractFileName(IconFileFullPath)), False) then
        Exit;
      SetFileAttributes(PChar(FolderPath + '\' + ExtractFileName(IconFileFullPath)), FILE_ATTRIBUTE_HIDDEN or FILE_ATTRIBUTE_SYSTEM);
      IconFileName := ExtractFileName(IconFileFullPath);
    end
    else
    begin
      IconFileName := IconFileFullPath;
    end;

    IniFile := TIniFile.Create(FolderPath + '\Desktop.ini');

    IniFile.WriteString('.ShellClassInfo', 'IconFile', IconFileName);
    IniFile.WriteString('.ShellClassInfo', 'IconIndex', IntToStr(IconIndex));
    IniFile.WriteString('.ShellClassInfo', 'InfoTip', FolderInfoTip);
    IniFile.UpdateFile;  //For Windows 98/95

    IniFile.Free;

    if not SetFileAttributes(PChar(FolderPath + '\Desktop.ini'), FILE_ATTRIBUTE_HIDDEN or FILE_ATTRIBUTE_SYSTEM) then
      Exit;

    //Next we need to set the system attribute for the folder and its parent
    if not SetFileAttributes(PChar(FolderPath), FILE_ATTRIBUTE_SYSTEM) then
      Exit;
    if Length(FolderPath) > 3 then //If not at the root of a disk...
    begin
      ParentFolder := ExtractFilePath(FolderPath + '.txt');
      if not SetFileAttributes(PChar(ParentFolder), FILE_ATTRIBUTE_SYSTEM) then
        Exit;
    end;
    Result := True;
  except
  end;
end;

function TProcs.IfThenW(AValue: Boolean; const ATrue,
  AFalse: WideString): WideString;
begin
  if AValue then
    Result := ATrue
  else
    Result := AFalse;
end;

procedure TProcs.SleepNoBlock(Milliseconds: Cardinal);
var
  OldTickCount: Cardinal;
begin
  //Delays for Milliseconds milliseconds, but unlike the Sleep function, the thread is not blocked and Application.ProcessMessages is called until the required timeout reaches
  OldTickCount := GetTickCount;
  while (GetTickCount - OldTickCount) < Milliseconds do
  begin
    Application.ProcessMessages;
    Sleep(1);
  end;
end;

procedure TProcs.TrimBitmapUnusedBorders(b: TBitmap);
  function IsEmptyRow(Row: Integer): Boolean;
  var
    x: Integer;
  begin
    Result := False;
    for x := 0 to b.Width - 1 do
      if b.Canvas.Pixels[x, Row] <> clWhite then
        Exit;
    Result := True;
  end;

var
  Row, RowNew, Col: Integer;
  TopTrim, BottomTrim: Integer;
  NewBitmap: TBitmap;
begin
  TopTrim := 0;
  BottomTrim := 0;
  for Row := 0 to b.Height - 2 do
    if IsEmptyRow(Row) then
      Inc(TopTrim)
    else
      Break;
  for Row := b.Height - 1 downto 1 do
    if IsEmptyRow(Row) then
      Inc(BottomTrim)
    else
      Break;
  if (TopTrim + BottomTrim) < b.Height then
  begin
    NewBitmap := TBitmap.Create;
    NewBitmap.Width := b.Width;
    NewBitmap.Height := b.Height - TopTrim - BottomTrim;
    RowNew := 0;
    for Row := TopTrim to b.Height - BottomTrim - 1 do
    begin
      for Col := 0 to b.Width - 1 do
        NewBitmap.Canvas.Pixels[Col, RowNew] := b.Canvas.Pixels[Col, Row];
      Inc(RowNew);
    end;
    b.Assign(NewBitmap);
    NewBitmap.Free;
  end;
end;

function TProcs.CompareMemoryStreams(MemStream1,
  MemStream2: TMemoryStream): Boolean;
begin
  //Returns True if memory streams are equal, otherwise returns False
  Result := False;
  if MemStream1 = nil then
    Result := MemStream2 = nil
  else if MemStream2 = nil then
    Result := MemStream1 = nil;

  if Assigned(MemStream1) and Assigned(MemStream2) then
    if MemStream1.Size = MemStream2.Size then
      Result := CompareMem(MemStream1.Memory, MemStream2.Memory, MemStream1.Size);
end;

function TProcs.CompareBinaryFiles(const File1, File2: String): Boolean;
var
  m1, m2: TMemoryStream;
begin
  Result := False;
  m1 := TMemoryStream.Create;
  try
    m1.LoadFromFile(File1);
    m2 := TMemoryStream.Create;
    try
      m2.LoadFromFile(File2);
      Result := CompareMemoryStreams(m1, m2);
    finally
      m2.Free;
    end;
  finally
    m1.Free;
  end;
end;

function TProcs.TwipsToPixelsExact(Twips: Integer;
  Direction: TDirection): Integer;
const
  TwipsPerInch = 1440;
var
  dc: HDC;
  PixelsPerInch: Integer;
begin
  dc := GetDC(0);
  if Direction = diHorizontal then
    PixelsPerInch := GetDeviceCaps(dc, LOGPIXELSX)
  else
    PixelsPerInch := GetDeviceCaps(dc, LOGPIXELSY);

  ReleaseDC(0, dc);
  Result := Trunc((Twips / TwipsPerInch) * PixelsPerInch);
end;

function TProcs.TwipsToPixelsForSWF(Twips: Integer): Integer;
const
  TwipsPerPixelForSWF = 20;
begin
  //No matter for direction (width or height)
  Result := Trunc(Twips / TwipsPerPixelForSWF);
end;


function TProcs.CompareTimes(Hour1, Minute1, Second1, Hour2, Minute2,
  Second2: Integer): Integer;

  function IsBefore(H, M, S, BaseH, BaseM, BaseS: Integer): Boolean;
  begin
    Result := True;
    if H < BaseH then
      Exit;
    if H > BaseH then
    begin
      Result := False;
      Exit;
    end;
    //So H = BaseH
    if M < BaseM then
      Exit;
    if M > BaseM then
    begin
      Result := False;
      Exit;
    end;
    //so M = BaseM
    if S < BaseH then
      Exit;
    if S > BaseH then
    begin
      Result := False;
      Exit;
    end;
    //So S = BaseH
    //So the two times are equal
    Result := False;
    Exit;
  end;

begin
  if IsBefore(Hour1, Minute1, Second1, Hour2, Minute2, Second2) then
    Result := -1  //Time1 < Time2
  else if IsBefore(Hour2, Minute2, Second2, Hour1, Minute1, Second1) then
    Result := +1  //Time1 > Time2
  else
    Result := 0;  //Equal
end;

initialization
  Procs:=TProcs.Create;
  //ShellHandle := Windows.LoadLibrary('shell32.dll');  --> Not used anymore
  //if ShellHandle <> 0 then
  //  FreePIDL := GetProcAddress(ShellHandle, PChar(155));  --> Not used anymore

finalization
  Procs.Free;
  //if Shellhandle <> 0 then  --> Not used anymore
  //  FreeLibrary(ShellHandle);

end.
