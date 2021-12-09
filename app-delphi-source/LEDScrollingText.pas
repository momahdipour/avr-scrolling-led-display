unit LEDScrollingText;

{$INCLUDE Config.inc}

interface

uses
  GlobalTypes, AdvGrid, Graphics, TextToLCDUnit, Classes, LCDProcsUnit,
  Dialogs, TntClasses;

{$ifdef _SCROLLING_TEXT_ACTIVE_}
  function LEDScrollingTextData(StageIndex: Integer; Area: TArea; var Data: TDataArray): Boolean;
{$endif}

  function ScrollingTextSpeedIndexToSpeedValue(SpeedIndex: Integer): Integer;
  function DefineTextScrollStep(const Area: TArea; SpeedIndex: Integer): Byte;  //This function is used in LEDPicture.pas

implementation

uses MainUnit, SysUtils;

procedure FitTextToArea(const Area: TArea; TextToLCDGrid: TAdvStringGrid);
var
  b: TBitmap;
begin
  b := TBitmap.Create;
  MainForm.LCDToBitmap(TextToLCDGrid, b, False);
  MainForm.FitImageToArea(b, Area, False);
  MainForm.BitmapToLCD(b, TextToLCDGrid, 0, False);
  b.Free;
end;

procedure GetTextData(const Area: TArea; TextToLCDGrid: TAdvStringGrid);
var
  Font: TFont;
  FontFolderList: TTntStringList;
  LCDFont: TLCDFont;
  TextBiDiMode: TBiDiMode;
  NoResult: Boolean;
begin
  //Prevent potential software bugs
  TextToLCDGrid.ColCount := 1;
  TextToLCDGrid.RowCount := 1;
  TextToLCDGrid.Colors[0, 0] := LCDClearedColor;

  Font := TFont.Create;
  FontFolderList := TTntStringList.Create;
  with Area do
  begin
    if ScrollingTextType = ttSimpleText then
    begin
      if TextLanguage = laEnglish then
        TextBiDiMode := bdLeftToRight
      else
        TextBiDiMode := bdRightToLeft;

      if ScrollingTextFontSettings.FontType = ftSystemFont then
      begin
        MainForm.SetFontSettings(Font, ScrollingTextFontSettings.SystemFontSettings);
        TextToLCD(ScrollingText, Font, TextToLCDGrid);
        FitTextToArea(Area, TextToLCDGrid);
        {if TextBiDiMode = bdRightToLeft then  //LCDGrid.BiDiMode = bdRightToLeft then
        begin
          TextToLCDGrid.SelectRows(0, TextToLCDGrid.RowCount);
          LCDProcs.FlipSelectionHorizontally(TextToLCDGrid);
        end;}
      end
      else
      begin
        FontFolderList.Clear;
        if (TextLanguage = laFarsi) or (TextLanguage = laMixed) then
        begin
          if MainForm.FindFont(ScrollingTextFontSettings.FarsiLCDFontName, laFarsi, LCDFont) then
            FontFolderList.Append(LCDFont.Path);
        end;
        if (TextLanguage = laEnglish) or (TextLanguage = laMixed) then
        begin
          if MainForm.FindFont(ScrollingTextFontSettings.EnglishLCDFontName, laEnglish, LCDFont) then
            FontFolderList.Append(LCDFont.Path);
        end;
        TextToLCDGrid.RowCount := 1;
        TextToLCDGrid.ColCount := 1;

        PerformTextToLCDFromCharacterLibrary(ScrollingText, TextBiDiMode, FontFolderList, TextToLCDGrid);
        FitTextToArea(Area, TextToLCDGrid);
      end;
    end
    else //if ScrollingTextType = ttAdvancedText then
    begin
      NoResult := True;
      if FileExists(ScrollingTextLFGFileName) then
      begin
        if MainForm.OpenLFGFile(ScrollingTextLFGFileName, TextToLCDGrid) then
          NoResult := False;
      end;
      if NoResult then
      begin
        TextToLCDGrid.ColCount := 1;
        TextToLCDGrid.RowCount := 1;
        TextToLCDGrid.Colors[0, 0] := LCDClearedColor;
      end
      else
        FitTextToArea(Area, TextToLCDGrid);
    end;
  end;
  FontFolderList.Free;
  Font.Free;
end;

procedure GenerateSLSTData(TextGrid: TAdvStringGrid; const Area: TArea;
  var Data: TDataArray);

//  **  If this procedure is changed, also must update the same procedure in the LEDPicture unit.  **

  function MirrorBits(const Line: String): String;
  var
    L, R: Integer;
    CharTemp: Char;
  begin
    Result := Line;
    L := 1;
    R := Length(Result);
    while L < R do
    begin
      CharTemp := Result[L];
      Result[L] := Result[R];
      Result[R] := CharTemp;
      Inc(L);
      Dec(R);
    end;
  end;

const
  OneChar = '1';
  ZeroChar = '0';
var
  Line: String;
  Col, Row, i, j: Integer;
  B: Byte;
  OutputLineList: TStringList;
begin
  OutputLineList := TStringList.Create;
  OutputLineList.Clear;
  for Col := 0 to TextGrid.ColCount - 1 do
  begin
    Line:='';
    for Row := 0 to TextGrid.RowCount - 1 do
      if TextGrid.Colors[Col, Row] = LCDFilledColor then
        Line := Line + OneChar
      else
        Line := Line + ZeroChar;
    Line := MirrorBits(Line);

    //When generating data, only TextDirection is used (not BiDiMode),
    // however, when converting text to LCD using LCD Fonts, BiDiMode is used.
    {if Area.ScrollingTextFontSettings.FontType = ftLCDFont then
    begin
      if Area.TextBiDiMode = bdRightToLeft then
        OutputLineList.Insert(0, Line)  //Inverse order
      else
        OutputLineList.Append(Line);
    end
    else
    begin}
      if Area.TextDirection = 0 then  //Right (defined in GlobalTypes.pas)
        OutputLineList.Insert(0, Line)  //Inverse order
      else  //Left
        OutputLineList.Append(Line);
    //end;
  end;

  //Generate Data Bytes
    for i := 0 to OutputLineList.Count - 1 do
    begin
      Line := MainForm.ConvertBinToHex(OutputLineList.Strings[i]);
      if (Length(Line) mod 2) <> 0 then
        Insert('0', Line, 1);
      j := 1;
      while j <= Length(Line) do
      begin
        if Line[j] in ['0'..'9'] then
          B := (Ord(Line[j]) - Ord('0')) * 16
        else
          B := (Ord(Line[j]) - Ord('A') + 10) * 16;
        Inc(j);
        if Line[j] in ['0'..'9'] then
          B := B + Ord(Line[j]) - Ord('0')
        else
          B := B + Ord(Line[j]) - Ord('A') + 10;
        Inc(j, 1);
        SetLength(Data, Length(Data) + 1);
        Data[High(Data)] := B;
      end;
    end;

  OutputLineList.Free;
end;

function ScrollingTextSpeedIndexToSpeedValue(SpeedIndex: Integer): Integer;
begin
  //For scrolling text, speed value must have values only
  //Very slow speed has been removed 
  case SpeedIndex of
    0:  //Slow
      Result := 192;
    1:  //Medium
      Result := 128;
    2:  //Fast
      Result := 96;
    3:  //Very Fast
      Result := 64;
  end;
end;

function DefineTextScrollStep(const Area: TArea; SpeedIndex: Integer): Byte;
  //If this function is changed, also update the SpeedIndexToSpeedValue function.
  function SelectScrollStep(VeryFast, Fast, Medium, Slow: Integer): Byte;
  begin
    case SpeedIndex of
      0:  //Slow
        Result := Slow;
      1:  //Medium
        Result := Medium;
      2:  //Fast
        Result := Fast;
      3:  //Very Fast
        Result := VeryFast;
    end;
    {
    //Very Fast (0-51), Fast (52-103), Medium (104-155), Slow (156-207), Very Slow (208-255)
    if ScrollSpeed <= 51 then  //Very Fast
      Result := VeryFast
    else if ScrollSpeed <= 103 then  //Fast
      Result := Fast
    else if ScrollSpeed <= 155 then  //Medium
      Result := Medium
    else if ScrollSpeed <= 207 then  //Slow
      Result := Slow
    else //if ScrollSpeed <= 255 then  //Very Slow
      Result := VerySlow;
    }
  end;
var
  AreaWidth: Integer;
begin
  AreaWidth := Area.x2 - Area.x1 + 1;
  //if AreaWidth <= 32 then
    Result := SelectScrollStep(4, 3, 2, 1);
end;

//******************************************************
//***************** I M P O R T A N T ******************
{  IF THIS FILE IS CHANGED, ALSO UPDATE LEDPitcure.pas  }
//******************************************************
//******************************************************
{$ifdef _SCROLLING_TEXT_ACTIVE_}
function LEDScrollingTextData(StageIndex: Integer; Area: TArea;
  var Data: TDataArray): Boolean;
var
  TextToLCDGrid: TAdvStringGrid;
  ColCount: Word;
  w: Word;
begin
  Result := True;

  if Area.ContentType <> ctScrollingText then
    Exit;

  if Area.ScrollingText = '' then
    Area.ScrollingText := ' ';  //Add one space if no text available to prevnt potential software bugs

  with Area do
  begin
    SetLength(Data, 12);

    if FixedText then
      Data[0] := 1  //Yes
    else
      Data[0] := 0;  //No

    Data[1] := TextDirection;
    
    //Data[2] := TextScrollType;
    if Area.TextEntranceAnimID = 1 then
      Data[2] := 0
    else
      Data[2] := 1;

    Data[3] := MainForm.SpeedIndexToSpeedValue(TextScrollSpeed);
    //Data[4] and Data[5] = ColCount
    //Data[6] = BytesPerCol  //There is no need to set this field (BytesPerCol)

    if InvertScrollingText then  //InvertScrollingText is implemented directly by inverting cells - Settings of this value is used in animations
      Data[7] := 1
    else
      Data[7] := 0;

    w := TextTotalDisplayTime;
    if TextTimingStyle = tsRepeatNTimes then
    begin
      Data[8] := TextRepetitionTimes;  //RepetitionTimes
      Data[9] := 0;  //TotalDisplayTime
      Data[10] := 0;
    end
    else
    begin
      Data[8] := 0;  //RepetitionTimes
      Data[9] := Lo(w);  //TotalDisplayTime
      Data[10] := Hi(w);
    end;

    //Convert text to LCD
    TextToLCDGrid := TAdvStringGrid.Create(nil);
    //TextToLCDGrid.DefaultRowHeight := 3;
    //TextToLCDGrid.DefaultColWidth := 3;
    TextToLCDGrid.Visible := False;
    TextToLCDGrid.Parent := MainForm;
    GetTextData(Area, TextToLCDGrid);

    if (TextEntranceAnimID = 0) and not FixedText then
      MainForm.PutLCDAtCenter(TextToLCDGrid, Area.x2 - Area.x1 + 1);
    if InvertScrollingText then
    begin
      if FixedText then
        MainForm.PutLCDAtCenter(TextToLCDGrid, Area.x2 - Area.x1 + 1);
      LCDProcs.InvertLCD(TextToLCDGrid, LCDFilledColor, LCDClearedColor);
    end;

    GenerateSLSTData(TextToLCDGrid, Area, Data);

    //Text column count
    ColCount := TextToLCDGrid.ColCount;
    Data[4] := Lo(ColCount);
    Data[5] := Hi(ColCount);

    //Bytes per column
    //There is no need to set this field (BytesPerCol)
    if TextToLCDGrid.RowCount <= 8 then
      Data[6] := 1
    else if TextToLCDGrid.RowCount <= 16 then
      Data[6] := 2
    else if TextToLCDGrid.RowCount <= 24 then
      Data[6] := 3
    else if TextToLCDGrid.RowCount <= 32 then
      Data[6] := 4;

    //Set ScrollStep
    Data[11] := DefineTextScrollStep(Area, TextScrollSpeed);
    //Correct Scroll Speed value for scrolling text
    Data[3] := ScrollingTextSpeedIndexToSpeedValue(TextScrollSpeed);

//    TextToLCDGrid.Free;
  end;
end;
{$endif}

end.
