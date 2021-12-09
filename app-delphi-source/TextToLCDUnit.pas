unit TextToLCDUnit;

interface

uses
  Graphics, AdvGrid, Image32, Graphics32, SysUtils, Grids, TntClasses,
  Classes, Windows, Dialogs, Forms;

procedure InitializeTyperModules;

procedure TextToLCD(const LCDText: WideString; LCDFont: TFont;
  LCD: TAdvStringGrid; OnlyGetSize: Boolean = False {Not used in this version});

function PerformTextToLCDFromCharacterLibrary(const Text: WideString; TextDirection: TBiDiMode;
  FontFolders: TTntStrings; ResultGrid: TAdvStringGrid): Boolean;

implementation

uses MainUnit, LCDProcsUnit;

//==============================================================================
// From System Fonts
//==============================================================================
procedure LCDTrim(LCD: TAdvStringGrid; DrawingCanvas: TCanvas; DrawingText: String); overload;

  function IsEmpty(L, T, R, B: Integer; ClearedColor: TColor): Boolean;
  var
    Col, Row: Integer;
  begin
    Result := False;
    for Col := L to R do
      for Row := T to B do
        if LCD.Colors[Col, Row] <> ClearedColor then  //*** It is not necessary to compare ColorsTo values
          Exit;
    Result := True;
  end;

var
  L, R, T, B: Integer;
  Row, Col: Integer;
begin
  //Top
  T := 0;
  while IsEmpty(0, T, LCD.ColCount - 1, T, clWhite) do
    Inc(T);
  //Bottom
  B := LCD.RowCount - 1;
  while IsEmpty(0, B, LCD.ColCount - 1, B, clWhite) do
    Dec(B);
  //Left
  L := 0;
  while IsEmpty(L, 0, L, LCD.RowCount - 1, clWhite) do
    Inc(L);
  if (Length(DrawingText) - Length(TrimLeft(DrawingText))) > 0 then
    L := L - DrawingCanvas.TextWidth(StringOfChar(' ', Length(DrawingText) - Length(TrimLeft(DrawingText))));
  //Right
  R := LCD.ColCount - 1;
  while IsEmpty(R, 0, R, LCD.RowCount - 1, clWhite) do
    Dec(R);
  if (Length(DrawingText) - Length(TrimRight(DrawingText))) > 0 then
    R := R + DrawingCanvas.TextWidth(StringOfChar(' ', Length(DrawingText) - Length(TrimRight(DrawingText))));

  if T > 0 then
  begin
    for Row := T to B do
      for Col := L to R do
      begin
        LCD.Colors[Col, Row - T] := LCD.Colors[Col, Row];
        LCD.ColorsTo[Col, Row - T] := LCD.ColorsTo[Col, Row];
      end;
  end;
  LCD.RowCount := B - T + 1;
  if L > 0 then
  begin
    for Col := L to R do
      for Row := 0 to LCD.RowCount - 1 do
      begin
        LCD.Colors[Col - L, Row] := LCD.Colors[Col, Row];
        LCD.ColorsTo[Col - L, Row] := LCD.ColorsTo[Col, Row];
      end;
  end;
  LCD.ColCount := R - L + 1;
end;

procedure LCDTrim(LCD: TAdvStringGrid; Birmap: TBitmap32;
  DrawingText: String); overload;

  function IsEmpty(L, T, R, B: Integer; ClearedColor: TColor): Boolean;
  var
    Col, Row: Integer;
  begin
    Result := False;
    if (L < 0) or (T < 0) then
      Exit;
    for Col := L to R do
      for Row := T to B do
        if LCD.Colors[Col, Row] <> ClearedColor then  //*** It is not necessary to compare the ColorsTo values
          Exit;
    Result := True;
  end;

var
  L, R, T, B: Integer;
  Row, Col: Integer;
begin
  //Top
  T := 0;
  while IsEmpty(0, T, LCD.ColCount - 1, T, clWhite) do
    Inc(T);
  //Bottom
  B := LCD.RowCount - 1;
  while IsEmpty(0, B, LCD.ColCount - 1, B, clWhite) do
    Dec(B);
  //Left
  L := 0;
  while IsEmpty(L, 0, L, LCD.RowCount - 1, clWhite) do
    Inc(L);
  if (Length(DrawingText) - Length(TrimLeft(DrawingText))) > 0 then
    L := L - Birmap.TextWidth(StringOfChar(' ', Length(DrawingText) - Length(TrimLeft(DrawingText))));
  //Right
  R := LCD.ColCount - 1;
  while IsEmpty(R, 0, R, LCD.RowCount - 1, clWhite) do
    Dec(R);
  if (Length(DrawingText) - Length(TrimRight(DrawingText))) > 0 then
    R := R + Birmap.TextWidth(StringOfChar(' ', Length(DrawingText) - Length(TrimRight(DrawingText))));

  if R >= LCD.ColCount then
    R := LCD.ColCount - 1;
  if B >= LCD.RowCount then
    B := LCD.RowCount - 1;

  if T > 0 then
  begin
    for Row := T to B do
      for Col := L to R do
      begin
        LCD.Colors[Col, Row - T] := LCD.Colors[Col, Row];
        //LCD.ColorsTo[Col, Row - T] := LCD.ColorsTo[Col, Row];
      end;
  end;
  LCD.RowCount := B - T + 1;
  if L > 0 then
  begin
    for Col := L to R do
      for Row := 0 to LCD.RowCount - 1 do
      begin
        LCD.Colors[Col - L, Row] := LCD.Colors[Col, Row];
        //LCD.ColorsTo[Col - L, Row] := LCD.ColorsTo[Col, Row];
        //LCD.Colors[Col, Row] := LCDClearedColor;
      end;
  end;
  LCD.ColCount := R - L + 1;
end;

procedure TakeTextApart(const LCDText: WideString; Parts: TTntStrings);
const
  SpecialChars = [
                WideChar('/'), WideChar('\'), WideChar(','), WideChar('.'), WideChar('-'),
                WideChar(')'), WideChar('('), WideChar('*'), WideChar('&'), WideChar('^'),
                WideChar('%'), WideChar('$'), WideChar('#'), WideChar('@'), WideChar('!'),
                WideChar('~'), WideChar('`'), WideChar(''''), WideChar('"'), WideChar(']'),
                WideChar('['), WideChar('}'), WideChar('{'), WideChar(' '), WideChar('+'),
                WideChar('=')
                ];

  function IsEnglishChar(wc: WideChar): Boolean;
  begin
    Result := wc in [WideChar('a')..WideChar('z'), WideChar('A')..WideChar('Z')];
  end;

  function NextAlphaCharIsEnglish(const Text: WideString; StartPos: Integer): Boolean;
  var
    i: Integer;
    wc: WideChar;
  begin
    Result := False;
    if StartPos > Length(Text) then
      Exit;
    for i := StartPos to Length(Text) do
    begin
      wc := Text[i];
      if wc in SpecialChars then
        Continue;
      if IsEnglishChar(wc) then
        Result := True;

      Break;
    end;
  end;

var
  i: Integer;
  wc: WideChar;
  NewPart: WideString;
begin
  Parts.Clear;
  i := 1;
  while i <= Length(LCDText) do
  begin
    wc := LCDText[i];
    NewPart := wc;
    Inc(i);
    if wc = ' ' then
    begin
      while i <= Length(LCDText) do
      begin
        wc := LCDText[i];
        if wc <> ' ' then
          Break;
        NewPart := NewPart + wc;
        Inc(i);
      end;
    end
    else if IsEnglishChar(wc) then
    begin
      //English text
      while i <= Length(LCDText) do
      begin
        wc := LCDText[i];
        //First check special characters, then english char
        if wc in SpecialChars then
        begin
          if not NextAlphaCharIsEnglish(LCDText, i + 1) then
            Break;
        end
        else if not IsEnglishChar(wc) then
          Break;
        NewPart := NewPart + wc;
        Inc(i);
      end;
    end
    else
    begin
      //Farsi text
      while i <= Length(LCDText) do
      begin
        wc := LCDText[i];
        if IsEnglishChar(wc) or (wc = ' ') then
          Break;
        NewPart := NewPart + wc;
        Inc(i);
      end;
    end;
    Parts.Append(NewPart);
  end;
end;

procedure TextToLCD(const LCDText: WideString; LCDFont: TFont;
  LCD: TAdvStringGrid; OnlyGetSize: Boolean = False {Not used in this version});
var
  Image:TImage32;
  Row,Col:Integer;
  FontColor: TColor;

  TextParts: TTntStringList;
  i: Integer;
  WS: WideString;
  ColCount, RowCount: Integer;
begin
  TextParts := TTntStringList.Create;
  TextParts.Clear;

  try
    TakeTextApart(LCDText, TextParts);

    ColCount := 0;
    RowCount := 0;

    for i := 0 to TextParts.Count - 1 do
    begin
      WS := TextParts[i];

      Image := TImage32.Create(nil);
      Image.SetupBitmap(True, Color32(clWhite {LCDOptions.LCDClearedColor}));

      Image.Bitmap.Font.Assign(LCDFont);

      FontColor := clBlue;
      Image.Bitmap.Font.Color := FontColor;

      Image.Bitmap.Width := Image.Bitmap.TextWidth(TextParts[i]);
      Image.Bitmap.Height := Image.Bitmap.TextHeight(TextParts[i]);
      Image.Bitmap.TextOut(0, 0, TextParts[i]);

      if ColCount = 0 then
        LCD.ColCount := ColCount + Image.Bitmap.Width
      else
      begin
        LCD.InsertCols(0, Image.Bitmap.Width);
      end;
      if RowCount < Image.Bitmap.Height then
        RowCount := Image.Bitmap.Height;
      if RowCount > 0 then
        LCD.RowCount := RowCount;

      for Col := 0 to Image.Bitmap.Width - 1 do
        for Row := 0 to Image.Bitmap.Height - 1 do
        begin
          if WinColor(Image.Bitmap.PixelS[Col, Row]) = FontColor then
            //SetCellColor(LCD, Col, Row, True)
            LCD.Colors[Col, Row] := LCDFilledColor
          else
            //SetCellColor(LCD, Col, Row, False);
            LCD.Colors[Col, Row] := LCDClearedColor;
          Application.ProcessMessages;
        end;
      if Image.Bitmap.Height < RowCount then
        for Col := 0 to Image.Bitmap.Width - 1 do
          for Row := Image.Bitmap.Height to RowCount - 1 do
            LCD.Colors[Col, Row] := LCDClearedColor;

      //LCDTrim(LCD, Image.Bitmap, TextParts[i]);

      ColCount := LCD.ColCount;
      RowCount := LCD.RowCount;

      Image.Free;
    end;

    if (ColCount > 0) and (RowCount > 0) then
      LCD.Tag := 1
    else
      LCD.Tag := 0;

    //Prepare to trim the LCD
    Image := TImage32.Create(nil);
    Image.SetupBitmap(True, Color32(clWhite {LCDOptions.LCDClearedColor}));
    Image.Bitmap.Font.Assign(LCDFont);
    FontColor := clBlue;
    Image.Bitmap.Font.Color := FontColor;
    Image.Bitmap.Width := Image.Bitmap.TextWidth(LCDText);
    Image.Bitmap.Height := Image.Bitmap.TextHeight(LCDText);
    Image.Bitmap.TextOut(0, 0, LCDText);

    LCDTrim(LCD, Image.Bitmap, LCDText);

    Image.Free;

    TextParts.Free;
  except
    TextParts.Free;
    Image.Free;
  end;
end;


//==============================================================================
// From Character Library
//==============================================================================

function MapCharToFile(CharCode: WideChar;
  var CanBeMappedByUser: Boolean): ShortString; external 'CharMap.dll';

const
  TYPERS_FOLDER_NAME = 'Typers';
  FILE_VERSION = '2.0.0.0';

  AnsiDelimiters : String = ' ';  //Used in the ConvertTextToLCD procedure

type
  TIsCompatible = function (const Version: ShortString; var CompatibilityMsg: ShortString): Boolean;
  TGetVersion = function : ShortString;
  TTypeChar = function (PrevChar, MainChar, NextChar: WideChar;
    var ProperChar: WideChar; var RightToLef: Boolean): Boolean;

var
  TyperModules: array of HMODULE;
  ///////////////////////////////////////////////////////////
  IsCompatible: TIsCompatible;
  GetVersion: TGetVersion;
  TypeChar: TTypeChar;
  ///////////////////////////////////////////////////////////

procedure InitializeTyperModules;

  procedure GetFullList(const Path:String; FileList: TStringList);
  var
    List:TStringList;
    FSR:TSearchRec;
    i:Integer;
  begin
    List:=TStringList.Create;
    List.Clear;
    if FindFirst(Path+'\*.*', faAnyFile, FSR)=0 then
    begin
      repeat
        if ((FSR.Attr and faSysFile)=0) and
           ((FSR.Attr and faSymLink)=0) and
           ((FSR.Attr and faVolumeID)=0) then
        begin
          if (FSR.Attr and faDirectory)=0 then
          begin
            if LowerCase(ExtractFileExt(FSR.Name))='.dll' then
              List.Append(Path+'\'+FSR.Name);
          end
          else if FSR.Name[1]<>'.' then
            List.Append(Path+'\'+FSR.Name);
        end;
      until FindNext(FSR)<>0;
    end;
    SysUtils.FindClose(FSR);
    for i:=0 to List.Count-1 do
    begin
      if DirectoryExists(List.Strings[i]) then
        GetFullList(List.Strings[i], FileList)
      else
        FileList.Append(List.Strings[i]);
    end;
  end;

var
  ModuleList: TStringList;
  Handle: THandle;
  i: Integer;
begin
  ModuleList := TStringList.Create;
  ModuleList.Clear;
  GetFullList(ApplicationPath + TYPERS_FOLDER_NAME, ModuleList);

  SetLength(TyperModules, 0);
  for i:=0 to ModuleList.Count - 1 do
  begin
    Handle := LoadLibrary(PChar(ModuleList.Strings[i]));
    if Handle <> 0 then
    begin
      try
        @IsCompatible := Windows.GetProcAddress(Handle, 'IsCompatible');
        @GetVersion := Windows.GetProcAddress(Handle, 'GetVersion');
        @TypeChar := Windows.GetProcAddress(Handle, 'TypeChar');
        if (@IsCompatible <> nil) and
           (@GetVersion <> nil) and
           (@TypeChar <> nil) then
        begin
          SetLength(TyperModules, Length(TyperModules) + 1);
          TyperModules[Length(TyperModules) - 1] := Handle;
        end;
      except
        FreeLibrary(Handle);
      end;
    end;
  end;
  ModuleList.Free;
end;

function MapCharacterToFilename(Character: WideChar;
  CharMapGrid:TAdvStringGrid; ReturnOnlyUserMappedName: Boolean): String;

  function IsMultiByteChar(CharCode: WideChar): Boolean;
  var
    S: String;
  begin
    S := WideChar(CharCode);
    Result := Integer(S[1]) <> Integer(CharCode);
  end;

var
  Row:Integer;
  SearchUserMapTable: Boolean;
  FName: ShortString;
begin
  FName := MapCharToFile(Character, SearchUserMapTable);
  Result := FName;
  if (Length(FName) > 0) and SearchUserMapTable then
  begin
    for Row:=1 to CharMapGrid.RowCount - 2 do
      if CharMapGrid.Cells[0, Row]=Character then
      begin
        Result:=CharMapGrid.Cells[1,Row]+'.chr';
        Exit;
      end;
  end;

  if ReturnOnlyUserMappedName then  //Do not return the MapCharToFile function result?
  begin
    if IsMultiByteChar(Character) then
      Result := ''  //Don't serach the user-mapped chars because the character is a multibyte character while the user-mapped chars do not support multibyte characters in this version
    else
      Result := Character + '.chr';
  end
  else
  begin
    if Length(FName) > 0 then
      Result := FName + '.chr'
    else
      Result:=Character + '.chr';
  end;
end;

function TypeCharacter(PrevChar, MainChar,
  NextChar: WideChar; var RightToLeft: Boolean): WideChar;
var
  i: Integer;
  S: ShortString;
  Handle: THandle;
begin
  for i:=0 to Length(TyperModules) - 1 do
  begin
    Handle := TyperModules[i];
    try
      @IsCompatible := Windows.GetProcAddress(Handle, 'IsCompatible');
      @GetVersion := Windows.GetProcAddress(Handle, 'GetVersion');
      @TypeChar := Windows.GetProcAddress(Handle, 'TypeChar');
      if (@IsCompatible <> nil) and
         (@GetVersion <> nil) and
         (@TypeChar <> nil) then
      begin
        if IsCompatible(FILE_VERSION, S) then
        begin
          if TypeChar(PrevChar, MainChar, NextChar, Result, RightToLeft) then
            Exit;
        end;
      end;
      except
      end;
  end;
  Result := MainChar;
end;

function GetFullCharacterFileList(const RootFolder: String;
  FullList: TStringList): Boolean;
  procedure GetFullList(const Path: String);
  var
    List: TStringList;
    FSR: TSearchRec;
    i: Integer;
  begin
    List := TStringList.Create;
    List.Clear;
    if FindFirst(Path + '\*.*', faAnyFile, FSR) = 0 then
    begin
      repeat
        if ((FSR.Attr and faSysFile) = 0) and
           ((FSR.Attr and faSymLink) = 0) and
           ((FSR.Attr and faVolumeID) = 0) then
        begin
          if (FSR.Attr and faDirectory) = 0 then
          begin
            if LowerCase(ExtractFileExt(FSR.Name)) = '.chr' then
              List.Append(Path + '\' + FSR.Name);
          end
          else if FSR.Name[1] <> '.' then
            List.Append(Path + '\' + FSR.Name);
        end;
      until FindNext(FSR) <> 0;
    end;
    SysUtils.FindClose(FSR);
    for i := 0 to List.Count-1 do
    begin
      if DirectoryExists(List.Strings[i]) then
        GetFullList(List.Strings[i])
      else
        FullList.Append(List.Strings[i]);
    end;
  end;
begin
  Result := False;
  if not DirectoryExists(RootFolder) then
    Exit;
  FullList.Clear;
  GetFullList(RootFolder);
  Result := True;
end;

{$HINTS OFF}
function ConvertTextToLCD(const Text: WideString; TextDirection: TBiDiMode;
  AGrid: TStringGrid; ErrorLogList: TTntStrings; FontFolders: TTntStrings): Boolean;

  function FindFullCharacterFName(FullFileList: TStringList;
    const CharFName: String): String;
  var
    i: Integer;
  begin
    //First search for exact name matching (case sensitive)
    for i := 0 to FullFileList.Count - 1 do
      if ExtractFileName(FullFileList.Strings[i]) = CharFName then
      begin
        Result := FullFileList.Strings[i];
        Exit;
      end;
    //Search is not case sensitive
    for i := 0 to FullFileList.Count - 1 do
      if LowerCase(ExtractFileName(FullFileList.Strings[i])) = LowerCase(CharFName) then
      begin
        Result := FullFileList.Strings[i];
        Exit;
      end;
    //Filename not in list
    Result := '';
  end;

var
  FullList, List: TStringList;
  CharMapGrid: TAdvStringGrid;
  i, Row, Col: Integer;
  FName: String;
  NextCol: Integer;
  ColCount: Integer;
  TempGrid: TAdvStringGrid;
  PrevChar, NextChar: WideChar;
  ProperChar: WideChar;
  RightToLeftChar: Boolean;
  RightToLeftStartCol: Integer;
  LeftToRightStartCol: Integer;
  MainNextCol: Integer;
begin
  Result := True;

  FullList := TStringList.Create;
  List := TStringList.Create;

try

  FullList.Clear;
  for i := 0 to FontFolders.Count - 1 do
  begin
    GetFullCharacterFileList(FontFolders.Strings[i], List);
    FullList.AddStrings(List);
  end;
  if FullList.Count = 0 then
  begin
    Result := False;
    Exit;
  end;

  CharMapGrid := TAdvStringGrid.Create(nil);
  CharMapGrid.RowCount := 2;
  CharMapGrid.ColCount := 2;
  //CharMapGrid.LoadFromCSV(ApplicationPath + USER_MAPPED_CHARS_FILE_NAME);
  LCDProcs.ReadUserMappedChars(CharMapGrid);

  TempGrid := TAdvStringGrid.Create(nil);
  NextCol := 0;
  AGrid.ColCount := 1;
  AGrid.RowCount := 1;
  ColCount := 0;
  RightToLeftStartCol := -1;
  LeftToRightStartCol := -1;
  for i := 1 to Length(Text) do
  begin
    //**************************
    Application.ProcessMessages;  //Process messages for displaying any progress indicator in the program
    //**************************

    if i = 1 then
      PrevChar := #$0000
    else
      PrevChar := Text[i - 1];
    if i = Length(Text) then
      NextChar := #$0000
    else
      NextChar := Text[i + 1];

    ProperChar := TypeCharacter(PrevChar, Text[i], NextChar, RightToLeftChar);
    //WideShowMessageSoundTop(MapCharacterToFilename(ProperChar, CharMapGrid));
    FName := FindFullCharacterFName(FullList, MapCharacterToFilename(ProperChar, CharMapGrid, False));
    if not FileExists(FName) then
      FName := FindFullCharacterFName(FullList, MapCharacterToFilename(ProperChar, CharMapGrid, True));
    if Pos(ProperChar, AnsiDelimiters) > 0 then
      RightToLeftChar := TextDirection = bdRightToLeft;

    if FileExists(FName) then
    begin
      TempGrid.RowCount := 2;
      TempGrid.ColCount := 1;
      TempGrid.LoadFromCSV(FName);

      if (TempGrid.RowCount - 1) > AGrid.RowCount then
        AGrid.RowCount := TempGrid.RowCount - 1;
      ColCount := ColCount + TempGrid.ColCount;
      if ColCount > 0 then
        AGrid.ColCount := ColCount;

      MainNextCol := NextCol;
      if TextDirection = bdLeftToRight then
      begin
        if RightToLeftChar and (RightToLeftStartCol >= 0) then
        begin
          LCDProcs.ShiftLCDValuesRight(AGrid, RightToLeftStartcol, TempGrid.ColCount);
          NextCol := RightToLeftStartCol;
        end;
      end
      else if TextDirection = bdRightToLeft then
      begin
        if RightToLeftChar then
        begin
          LCDProcs.ShiftLCDValuesRight(AGrid, 0, TempGrid.ColCount);
          NextCol := 0;
        end
        else if LeftToRightStartCol >= 0 then
        begin
          LCDProcs.ShiftLCDValuesRight(AGrid, LeftToRightStartCol, TempGrid.ColCount);
          NextCol := LeftToRightStartCol;
        end
        else if not RightToLeftChar and (LeftToRightStartCol < 0) then
        begin
          LCDProcs.ShiftLCDValuesRight(AGrid, 0, TempGrid.ColCount);
          NextCol := 0;
          LeftToRightStartCol := 0;
        end;
      end;

      for Col := 0 to TempGrid.ColCount - 1 do
        for Row := 0 to TempGrid.RowCount - 2 do
          AGrid.Cells[Col + NextCol, Row] := TempGrid.Cells[Col, Row];

      NextCol := MainNextCol;
      if TextDirection = bdLeftToRight then
      begin
        if RightToLeftChar then
        begin
          if RightToLeftStartCol < 0 then
            RightToLeftStartCol := NextCol;
        end
        else
          RightToLeftStartCol := -1;
      end
      else if TextDirection = bdRightToLeft then
      begin
        if RightToLeftChar then
          LeftToRightStartCol := -1
        else if LeftToRightStartCol < 0 then
          LeftToRightStartCol := NextCol
        else
          LeftToRightStartCol := LeftToRightStartCol + TempGrid.ColCount;
      end;

      NextCol := NextCol + TempGrid.ColCount;
    end
    else
      ErrorLogList.Append(WideFormat('The characer file of the character ''%s'' was not found in the selected categories.', [ProperChar]));  //'The characer file of the character ''' + ProperChar + ''' was not found in the selected categories.';
      //ErrorLogList.Append(WideFormat(Dyn_Texts[9], [ProperChar]));  //'The characer file of the character ''' + ProperChar + ''' was not found in the selected categories.';
  end;

  Result := not(ColCount = 0);
  AGrid.RowCount := AGrid.RowCount + 1;

  FullList.Free;
  List.Free;

except
  Result := False;
  FullList.Free;
  List.Free;
  
  //*******************
  raise;  //Re-raise the exception
  //*******************
end;

end;
{$HINTS ON}

function PerformTextToLCDFromCharacterLibrary(const Text: WideString; TextDirection: TBiDiMode;
  FontFolders: TTntStrings; ResultGrid: TAdvStringGrid): Boolean;
var
  Row, Col: Integer;
  RGrid: TStringGrid;  //Result Grid
  RGrid1: TAdvStringGrid;  //Result Grid
  ErrorLog: TTntStringList;
begin
  Result := False;

  ResultGrid.RowCount := 0;
  ResultGrid.ColCount := 0;
  ResultGrid.Tag := 0;

  RGrid := TStringGrid.Create(nil);
  RGrid1 := TAdvStringGrid.Create(nil);
  RGrid.Visible := False;
  RGrid1.Visible := False;

  ErrorLog := TTntStringList.Create;
  ErrorLog.Clear;

  try
    if not ConvertTextToLCD(Text, TextDirection, RGrid, ErrorLog, FontFolders) then
    begin
      //if ErrorLog.Count > 0 then
      //  ErrorLogForm.Show;
      Exit;
    end;
    //if (ErrorLogForm.ErrorLogListBox.Items.Count > 0) and ErrorLogCheck.Checked then
    //  ErrorLogForm.Show;


    RGrid.RowCount := RGrid.RowCount - 1;

    RGrid1.RowCount := RGrid.RowCount + 1;
    RGrid1.ColCount := RGrid.ColCount;
    for Row := 0 to RGrid.RowCount - 1 do
      for Col := 0 to RGrid.ColCount - 1 do
        RGrid1.Cells[Col, Row] := RGrid.Cells[Col, Row];


    //RGrid1.Visible := False;  --> Visible is already set to False
    RGrid1.Parent := MainForm;
    MainForm.ColorizeLCDGrid(RGrid1, LCDFilledColor, LCDClearedColor);

    //Return result
    ResultGrid.RowCount := RGrid1.RowCount - 1 {Because of TAdvStringGrid};
    ResultGrid.ColCount := RGrid1.ColCount;
    ResultGrid.Tag := 1;
    for Row := 0 to ResultGrid.RowCount - 1 do
      for Col := 0 to ResultGrid.ColCount - 1 do
        ResultGrid.Colors[Col, Row] := RGrid1.Colors[Col, Row];
    //InsertCharAtCursor(RGrid1, LCDGrid, LCDGrid.Row, LCDGrid.Col);
  finally
    RGrid.Free;
    RGrid1.Free;
    ErrorLog.Free;
  end;

  Result := True;
end;

initialization

finalization
  SetLength(TyperModules, 0);
end.
