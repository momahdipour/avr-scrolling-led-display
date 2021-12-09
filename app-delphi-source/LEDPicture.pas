unit LEDPicture;

{$INCLUDE Config.inc}

interface

uses
  GlobalTypes, Graphics, Classes, LCDProcsUnit, Dialogs, SoundDialogs, SysUtils;

  function LEDPictureData(StageIndex: Integer; const Area: TArea; var Data: TDataArray): Boolean;

implementation

uses MainUnit, LEDAnimation, LEDScrollingText;

procedure GenerateSLSTData(Bitmap: TBitmap; const Area: TArea;
  var Data: TDataArray);

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
  for Col := 0 to Bitmap.Width - 1 do
  begin
    Line:='';
    for Row := 0 to Bitmap.Height - 1 do
      if Bitmap.Canvas.Pixels[Col, Row] = LCDFilledColor then
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
      if Area.PictureTextDirection = 0 then  //Right (defined in GlobalTypes.pas)
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

procedure GenerateFramedAnimationData(Bitmap: TBitmap;
  var Data: TDataArray);

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
  for Col := 0 to Bitmap.Width - 1 do
  begin
    Line:='';
    for Row := 0 to Bitmap.Height - 1 do
      if Bitmap.Canvas.Pixels[Col, Row] = LCDFilledColor then
        Line := Line + OneChar
      else            
        Line := Line + ZeroChar;
    Line := MirrorBits(Line);

    OutputLineList.Append(Line);
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

procedure ExtractFrameData(const Area: TArea; var Data: TDataArray;
  var FrameColCount, BytesPerCol: Integer);
begin
  with Area do
  begin
    GenerateFramedAnimationData(PictureBitmap, Data);
    FrameColCount := PictureBitmap.Width;
    if PictureBitmap.Height <= 8 then
      BytesPerCol := 1
    else if PictureBitmap.Height <= 16 then
      BytesPerCol := 2
    else if PictureBitmap.Height <= 24 then
      BytesPerCol := 3
    else if PictureBitmap.Height <= 32 then
      BytesPerCol := 4;
  end;
end;

function LEDPictureData(StageIndex: Integer; const Area: TArea;
  var Data: TDataArray): Boolean;
var
  //FrameColCount, BytesPerCol: Integer;
  ColCount: Word;
  b: TBitmap;
  w: Word;
begin
  Result := True;

  if Area.ContentType <> ctPicture then
    Exit;

  if not Area.PictureAvailable or
     not Assigned(Area.PictureBitmap) or
     (Area.PictureBitmap.Width = 0) or
     (Area.PictureBitmap.Height = 0) then
  begin
    Result := False;
    MainForm.HideLastWaitState;
    WideMessageDlgSoundTop(WideFormat(Dyn_Texts[133] {'No picture is defined for the stage %s.'}, [IntToStr(StageIndex + 1 {StageIndex starts from 0 so add 1 to it})]), mtWarning, [mbOK], 0);
    Exit;
  end;

  b := TBitmap.Create;
  b.Assign(Area.PictureBitmap);
  MainForm.NormalizeBitmapForeground(b);  //Normalize bitmap foreground color to allow converting pictures not having LCDFilledColor as the foreground color

  //Implement it as ScrollingText (both fixed picture and scrolling picture)
  with Area do
  begin
    SetLength(Data, 12);

    if Area.ScrollingPicture then
      Data[0] := 0  //Scrolling Text
    else
      Data[0] := 1;  //No Scrolling Text

    Data[1] := PictureTextDirection;

    //Data[2] := PictureTextScrollType;
    if Area.PictureEntranceAnimID = 1 then
      Data[2] := 0
    else
      Data[2] := 1;

    Data[3] := MainForm.SpeedIndexToSpeedValue(PictureTextScrollSpeed);
    //Data[4] and Data[5] = ColCount
    //Data[6] = BytesPerCol  //There is no need to set this field (BytesPerCol)

    if InvertPicture then
      Data[7] := 1
    else
      Data[7] := 0;

    w := PictureTotalDisplayTime;
    if PictureTimingStyle = tsRepeatNTimes then
    begin
      Data[8] := PictureRepetitionTimes;  //RepetitionTimes
      Data[9] := 0;  //TotalDisplayTime
      Data[10] := 0;
    end
    else
    begin
      Data[8] := 0;  //RepetitionTimes
      Data[9] := Lo(w);  //TotalDisplayTime
      Data[10] := Hi(w);
    end;

    MainForm.FitImageToArea(b, Area, False);
    if (PictureEntranceAnimID = 0) and ScrollingPicture then
      MainForm.PutLCDBitmapAtCenter(b, Area.x2 - Area.x1 + 1);
    if InvertPicture then
    begin
      //if not ScrollingPicture then
        MainForm.PutLCDBitmapAtCenter(b, Area.x2 - Area.x1 + 1);
      LCDProcs.InvertBitmap(b, LCDFilledColor, LCDClearedColor);
    end;
    GenerateSLSTData(b, Area, Data);

    //Text column count
    ColCount := b.Width;
    Data[4] := Lo(ColCount);
    Data[5] := Hi(ColCount);

    //Bytes per column
    //There is no need to set this field (BytesPerCol)
    if b.Height <= 8 then
      Data[6] := 1
    else if b.Height <= 16 then
      Data[6] := 2
    else if b.Height <= 24 then
      Data[6] := 3
    else if b.Height <= 32 then
      Data[6] := 4;

    //Set ScrollStep
    Data[11] := DefineTextScrollStep(Area, PictureTextScrollSpeed);
    //Correct Scroll Speed value for scrolling text (because picture is implemented as scrolling text)
    Data[3] := ScrollingTextSpeedIndexToSpeedValue(PictureTextScrollSpeed);
  end;
  b.Free;


    {
    with Area do
    begin
      SetLength(Data, 10);
      Data[0] := 1;  //Yes - Fixed Text

      Data[1] := PictureTextDirection;  //NOT APPLICABLE

      //Data[2] := PictureTextScrollType;
      if Area.PictureEntranceAnimID = 1 then
        Data[2] := 0
      else
        Data[2] := 1;

      Data[3] := MainForm.SpeedIndexToSpeedValue(PictureTextScrollSpeed);  //NOT APPLICABLE
      //Data[4] and Data[5] = ColCount
      //Data[6] = BytesPerCol  //There is no need to set this field (BytesPerCol)
      if InvertPicture then
        Data[7] := 1
      else
        Data[7] := 0;

//      if PictureTimingStyle = tsRepeatNTimes then
//      begin
//        Data[8] := PictureRepetitionTimes;  //RepetitionTimes
//        Data[9] := 0;  //TotalDisplayTime
//      end
//      else
//      begin
        Data[8] := 0;  //RepetitionTimes
        Data[9] := PictureTotalDisplayTime;  //TotalDisplayTime
//      end;

      MainForm.FitImageToArea(b, Area, False);
      MainForm.NormalizeBitmapForeground(b);  //Normalize bitmap foreground color to allow converting pictures not having LCDFilledColor as the foreground color
      GenerateSLSTData(b, Area, Data);

      //Text column count
      ColCount := b.Width;
      Data[4] := Lo(ColCount);
      Data[5] := Hi(ColCount);

      //Bytes per column
      //There is no need to set this field (BytesPerCol)
      if b.Height <= 8 then
        Data[6] := 1
      else if b.Height <= 16 then
        Data[6] := 2
      else if b.Height <= 24 then
        Data[6] := 3
      else if b.Height <= 32 then
        Data[6] := 4;
      }



{Implementation using FramedAnimation:
      SetLength(Data, 10);

      Data[0] := 255;  //Maximum speed (we have only one frame)

      if PictureTimingStyle = tsRepeatNTimes then
      begin
        Data[5] := PictureRepetitionTimes;  //RepetitionTimes
        Data[6] := 0;  //TotalDisplayTime
      end
      else
      begin
        Data[5] := 0;  //RepetitionTimes
        Data[6] := PictureTotalDisplayTime;  //TotalDisplayTime
      end;

      if InvertPicture then
        Data[7] := 1
      else
        Data[7] := 0;

      ExtractFrameData(Area, Data, FrameColCount, BytesPerCol);

      Data[1] := BytesPerCol;  //BytesPerCol
      Data[2] := FrameColCount;  //FrameColCount
      Data[3] := 1;  //FrameCount: We have only one frame
      Data[4] := 0;

      Data[8] := 1;  //CenterHorizontally
      Data[9] := 1;  //CenterVertically


     b.Free;
  end;
  }
end;

end.
