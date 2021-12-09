unit LEDAnimation;

{$INCLUDE Config.inc}

interface

uses
  GlobalTypes, GIFImage, Grids, AdvGrid, Graphics, Classes, Dialogs, Forms,
  TntSysUtils, SoundDialogs, ProgramConsts;

type
  TFrameData = record
    Bitmap: TBitmap;
    Delay: Integer;
  end;

  TFrameDataArray = array of TFrameData;

{$ifdef _ANIMATION_ACTIVE_}
  function LEDAnimationData(StageIndex: Integer; const Area: TArea; var Data: TDataArray): Boolean;
{$endif}

procedure ExtractFrameDataForAnimationContent(const Area: TArea;
  InvertFrames: Boolean; Frames: TFrameDataArray; var Data: TDataArray;
  var FrameCount, FrameColCount, BytesPerCol: Integer);

implementation

uses MainUnit, SysUtils;

function FitImageToArea(Bitmap: TBitmap;
  const Area: TArea; FitWidth: Boolean;
  var LeftDiff, RightDiff, TopDiff, BottomDiff :Integer): Boolean;

  //Returns True if the bitmap is changed
  //Returns False if no change has been applied to the bitmap

  function CountFilledCellsInRows(AGrid: TAdvStringGrid; RowNums: array of Integer): Integer;
  var
    Col, i: Integer;
  begin
    Result := 0;
    for i := Low(RowNums) to High(RowNums) do
    begin
      for Col := 0 to AGrid.ColCount - 1 do
        if AGrid.Colors[Col, RowNums[i]] = LCDFilledColor then
          Inc(Result);
    end;
  end;

  function CountFilledCellsInColumns(AGrid: TAdvStringGrid; ColNums: array of Integer): Integer;
  var
    Row, i: Integer;
  begin
    Result := 0;
    for i := Low(ColNums) to High(ColNums) do
    begin
      for Row := 0 to AGrid.RowCount - 1 do
        if AGrid.Colors[ColNums[i], Row] = LCDFilledColor then
          Inc(Result);
    end;
  end;

var
  LCDGrid: TAdvStringGrid;
  Row, Col: Integer;
  AreaHeight, AreaWidth: Integer;
  AddToTop, AddToLeft: Boolean;
  i: Integer;
  AddedCol: Integer;
  Count1, Count2: Integer;
begin
  Result := False;

  LeftDiff := 0;
  RightDiff := 0;
  TopDiff := 0;
  BottomDiff := 0;

  LCDGrid := TAdvStringGrid.Create(nil);
  LCDGrid.Visible := False;
  LCDGrid.Parent := MainForm;

  LCDGrid.ColCount := Bitmap.Width;
  LCDGrid.RowCount := Bitmap.Height;

  for Row := 0 to LCDGrid.RowCount - 1 do
    for Col := 0 to LCDGrid.ColCount - 1 do
      LCDGrid.Colors[Col, Row] := Bitmap.Canvas.Pixels[Col, Row];

  AreaHeight := Area.y2 - Area.y1 + 1;
  AreaWidth := Area.x2 - Area.x1 + 1;

  //Fit height
  if LCDGrid.RowCount > AreaHeight then
  begin
    //Crop the image
    //Crop from bottom or top?
    if LCDGrid.RowCount > 3 then
    begin
      Count1 := CountFilledCellsInRows(LCDGrid, [0, 1, 2]);
      Count2 := CountFilledCellsInRows(LCDGrid, [LCDGrid.RowCount - 1, LCDGrid.RowCount - 2, LCDGrid.RowCount - 3]);
    end
    else if LCDGrid.RowCount > 2 then
    begin
      Count1 := CountFilledCellsInRows(LCDGrid, [0, 1]);
      Count2 := CountFilledCellsInRows(LCDGrid, [LCDGrid.RowCount - 1, LCDGrid.RowCount - 2]);
    end
    else
    begin
      Count1 := CountFilledCellsInRows(LCDGrid, [0]);
      Count2 := CountFilledCellsInRows(LCDGrid, [LCDGrid.RowCount - 1]);
    end;
    if Count1 < Count2 then
    begin
      //Crop from top
      TopDiff := -(LCDGrid.RowCount - AreaHeight);
      LCDGrid.RemoveRows(0, LCDGrid.RowCount - AreaHeight);
    end
    else
    begin
      //Crop from bottom
      BottomDiff := -(LCDGrid.RowCount - AreaHeight);
      LCDGrid.RemoveRows(LCDGrid.RowCount - (LCDGrid.RowCount - AreaHeight), LCDGrid.RowCount - AreaHeight);
    end;
  end
  else if LCDGrid.RowCount < AreaHeight then
  begin
    //Add new rows and colorize them
    AddToTop := True;
    for i := 1 to AreaHeight - LCDGrid.RowCount do
    begin
      if AddToTop then
      begin
        LCDGrid.InsertRows(0, 1);
        Inc(TopDiff);
        LCDGrid.RowColor[0] := LCDClearedColor;
      end
      else
      begin
        LCDGrid.InsertRows(LCDGrid.RowCount, 1);
        Inc(BottomDiff);
        LCDGrid.RowColor[LCDGrid.RowCount - 1] := LCDClearedColor;
      end;
      AddToTop := not AddToTop;
    end;
  end;

  //Fit width
  if FitWidth then
  begin
    if LCDGrid.ColCount > AreaWidth then
    begin
      //Crop the image
      //Crop from right or left?
      if LCDGrid.ColCount > 2 then
      begin
        Count1 := CountFilledCellsInColumns(LCDGrid, [0, 1]);
        Count2 := CountFilledCellsInColumns(LCDGrid, [LCDGrid.ColCount - 1, LCDGrid.ColCount - 2]);
      end
      else
      begin
        Count1 := CountFilledCellsInColumns(LCDGrid, [0]);
        Count2 := CountFilledCellsInColumns(LCDGrid, [LCDGrid.ColCount - 1]);
      end;
      if Count1 < Count2 then
      begin
        //Crop from left
        LeftDiff := -(LCDGrid.ColCount - AreaWidth);
        LCDGrid.RemoveCols(0, LCDGrid.ColCount - AreaWidth);
      end
      else
      begin
        //Crop from right
        RightDiff := -(LCDGrid.ColCount - AreaWidth);
        LCDGrid.RemoveCols(LCDGrid.ColCount - 1, LCDGrid.ColCount - AreaWidth);
      end;
    end
    else
    begin
      //Add new columns and colorize them
    AddToLeft := True;
    for i := 1 to AreaWidth - LCDGrid.ColCount do
    begin
      if AddToLeft then
      begin
        LCDGrid.InsertCols(0, 1);
        Inc(LeftDiff);
        AddedCol := 0;
      end
      else
      begin
        LCDGrid.InsertCols(LCDGrid.ColCount - 1, 1);
        Inc(RightDiff);
        AddedCol := LCDGrid.ColCount;
      end;
      //Colorize the new column
      for Row := 0 to LCDGrid.RowCount - 1 do
        LCDGrid.Colors[AddedCol, Row] := LCDClearedColor;
      AddToLeft := not AddToLeft;
    end;
    end;
  end;

  //Update image if necessary
  Result := (LCDGrid.ColCount <> Bitmap.Width) or
            (LCDGrid.RowCount <> Bitmap.Height);
  MainForm.LCDToBitmap(LCDGrid, Bitmap, False);

  LCDGrid.Free;
end;

procedure GenerateFramedAnimationData(Grid: TAdvStringGrid;
  var Data: TDataArray; InvertFrames: Boolean);

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
  for Col := 0 to Grid.ColCount - 1 do
  begin
    Line:='';
    for Row := 0 to Grid.RowCount - 1 do
      if Grid.Colors[Col, Row] = LCDFilledColor then
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
        if InvertFrames then
          Data[High(Data)] := not(B)
        else
          Data[High(Data)] := B;
      end;
    end;

  OutputLineList.Free;
end;

procedure ExtractFrameDataForAnimationContent(const Area: TArea;
  InvertFrames: Boolean; Frames: TFrameDataArray; var Data: TDataArray;
  var FrameCount, FrameColCount, BytesPerCol: Integer);
var
  LeftDiff, RightDiff, TopDiff, BottomDiff :Integer;

  procedure BitmapToGrid(Bitmap: TBitmap; Grid: TAdvStringGrid);
  var
    Col, Row: Integer;
  begin
    Grid.ColCount := Bitmap.Width;
    Grid.RowCount := Bitmap.Height;

    for Row := 0 to Grid.RowCount - 1 do
      for Col := 0 to Grid.ColCount - 1 do
        if Bitmap.Canvas.Pixels[Col, Row] = GIFClearedColor then
          Grid.Colors[Col, Row] := LCDClearedColor
        else
          Grid.Colors[Col, Row] := LCDFilledColor;
  end;


  procedure PrepareGrid(Bitmap: TBitmap; Grid: TAdvStringGrid);
  var
    i, j: Integer;
  begin
    BitmapToGrid(Bitmap, Grid);

    //Only apply negative values to width
    //Don't increase the size of the grid horizontally

    {for i := 1 to LeftDiff do
    begin
      Grid.InsertCols(0, 1);
      for j := 0 to Grid.RowCount - 1 do
        Grid.Colors[0, j] := LCDClearedColor;
    end;
    for i := 1 to RightDiff do
    begin
      Grid.InsertCols(Grid.ColCount, 1);
      for j := 0 to Grid.RowCount - 1 do
        Grid.Colors[Grid.ColCount - 1, j] := LCDClearedColor;
    end;}

    if LeftDiff < 0 then
      Grid.RemoveCols(0, - LeftDiff);
    if RightDiff < 0 then
      Grid.RemoveCols(Grid.ColCount - 1, - RightDiff);

    for i := 1 to TopDiff do
    begin
      Grid.InsertRows(0, 1);
      for j := 0 to Grid.ColCount - 1 do
        Grid.Colors[j, 0] := LCDClearedColor;
    end;
    for i := 1 to BottomDiff do
    begin
      Grid.InsertRows(Grid.RowCount, 1);
      for j := 0 to Grid.ColCount - 1 do
        Grid.Colors[j, Grid.RowCount - 1] := LCDClearedColor;
    end;

    if TopDiff < 0 then
      Grid.RemoveRows(0, - TopDiff);
    if BottomDiff < 0 then
      Grid.RemoveRows(Grid.RowCount + BottomDiff, - BottomDiff);
  end;

var
  b: TBitmap;
  Grid: TAdvStringGrid;
  i: Integer;
  w: Word;
begin
  if Length(Frames) = 0 then
    Exit;

  b := TBitmap.Create;
  b.Assign(Frames[0].Bitmap);
  MainForm.NormalizeBitmapForeground(b);
  FitImageToArea(b, Area, True, LeftDiff, RightDiff, TopDiff, BottomDiff);

  Grid := TAdvStringGrid.Create(nil);

  Grid.Visible := False;
  Grid.Parent := MainForm;
  Grid.SendToBack;
  Grid.Visible := True;
  Application.ProcessMessages;

  //Grid.BringToFront;
  //Grid.DefaultRowHeight := 5;
  //Grid.DefaultColWidth := 5;
  //Grid.FixedRows := 0;
  //Grid.FixedCols := 0;
  //Grid.ShowSelection := False;
  //Grid.Height := 200;
  //Grid.Width := 300;


  for i := Low(Frames) to High(Frames) do
  begin
    b.Assign(Frames[i].Bitmap);
    MainForm.NormalizeBitmapForeground(b);

    PrepareGrid(b, Grid);
    Grid.Refresh;

    //if Area.PutAnimationAtCenter then  --> Don't put at center here because it increases data size - this is done in microcontroller program
    //  MainForm.PutLDCAtCenter(Grid, Area.x2 - Area.x1 + 1);

    //if Area.InvertAnimation then  --> Don't invert here - this is done in the function GenerateFramedAnimationData
    //  MainForm.InvertLCD(Grid, False);

    //Grid.Col := 32;
    //ShowMessage('Frame ' + IntToStr(i + 1));

    //Add frame header
    SetLength(Data, Length(Data) + 2);
    w := Frames[i].Delay;
    Data[High(Data) - 1] := Lo(w);
    Data[High(Data)] := Hi(w);
    GenerateFramedAnimationData(Grid, Data, InvertFrames);
  end;

  FrameCount := Length(Frames);
  FrameColCount := Grid.ColCount;
  if Grid.RowCount <= 8 then
    BytesPerCol := 1
  else if Grid.RowCount <= 16 then
    BytesPerCol := 2
  else if Grid.RowCount <= 24 then
    BytesPerCol := 3
  else if Grid.RowCount <= 32 then
    BytesPerCol := 4;

  Grid.Free;
  b.Free;
end;

procedure ExtractFrameData(const Area: TArea; const GIFFileName: WideString;
  var Data: TDataArray; var FrameCount, FrameColCount, BytesPerCol: Integer;
  DelayMultiplier: Double);
var
  GIFImage: TGIFImage;
  Frames: TFrameDataArray;
  i: Integer;
begin
  if not WideFileExists(GIFFileName) then
    Exit;

  GIFImage := TGIFImage.Create;

  try
    MainForm.WideLoadGIFImageFromFile(GIFFileName, GIFImage);
    //GIFImage.LoadFromFile(GIFFileName);

    SetLength(Frames, GIFImage.Images.Count);
    for i := 0 to GIFImage.Images.Count - 1 do
    begin
      Frames[i].Bitmap := TBitmap.Create;
      Frames[i].Bitmap.Assign(GIFImage.Images[i].Bitmap);
      Frames[i].Delay :=  GIFImage.Images[i].GraphicControlExtension.Delay * 10;  //in milliseconds
      Frames[i].Delay := Trunc(Frames[i].Delay * DelayMultiplier);
      if Frames[i].Delay = 0 then
        Frames[i].Delay := 5;  //Don't allow to be zero
    end;

    try
      ExtractFrameDataForAnimationContent(Area, Area.InvertAnimation, Frames, Data, FrameCount, FrameColCount, BytesPerCol);
    finally
        //Free up memory
      for i := 0 to High(Frames) do
        try
          Frames[i].Bitmap.Free;
        except
        end;
      SetLength(Frames, 0);
  end;
  finally
    GIFImage.Free;
  end;
end;

{$ifdef _ANIMATION_ACTIVE_}
function LEDAnimationData(StageIndex: Integer; const Area: TArea;
  var Data: TDataArray): Boolean;
var
  FrameCount, FrameColCount, BytesPerCol: Integer;
  w: Word;
  AnimationFileIndex: Integer;
  i: Integer;
  FrameDelayMultiplier: Double;
begin
  Result := True;

  with Area do
  begin
    SetLength(Data, 12);

    Data[0] := MainForm.SpeedIndexToSpeedValue(AnimationPlaySpeed);

    w := AnimationTotalDisplayTime;
    if AnimationTimingStyle = tsRepeatNTimes then
    begin
      Data[5] := AnimationRepetitionTimes;  //RepetitionTimes
      Data[6] := 0;  //TotalDisplayTime
      Data[7] := 0;
    end
    else
    begin
      Data[5] := 0;  //RepetitionTimes
      Data[6] := Lo(w);  //TotalDisplayTime
      Data[7] := Hi(w);
    end;

    if InvertAnimation then
      Data[8] := 1
    else
      Data[8] := 0;

    if PutAnimationAtCenter then
    begin
      Data[9] := 1;  //CenterHorizontally
      Data[10] := 1;  //CenterVertically
    end
    else
    begin
      Data[9] := 0;  //CenterHorizontally
      Data[10] := 0;  //CenterVertically
    end;

    if UseGIFTimings then
      Data[11] := 1  //UseGIFTimings
    else
      Data[11] := 0;  //UseGIFTimings

    AnimationFileIndex := -1;
    for i := 0 to High(MainForm.LCDGIFAnimations) do
    begin
      if MainForm.LCDGIFAnimations[i].Description = AnimationName then
      begin
        AnimationFileIndex := i;
        Break;
      end;
    end;

    if AnimationFileIndex < 0 then
    begin
      Result := False;
      MainForm.HideLastWaitState;
      WideMessageDlgSoundTop(WideFormat(Dyn_Texts[131] {'You have not defined any animation for the stage %s.'}, [IntToStr(StageIndex + 1 {StageIndex starts from 0 so add 1 to it})]), mtWarning, [mbOK], 0);
      Exit;
    end;
    if not WideFileExists(MainForm.LCDGIFAnimations[AnimationFileIndex].FileName) then
    begin
      Result := False;
      MainForm.HideLastWaitState;
      WideMessageDlgSoundTop(WideFormat(Dyn_Texts[132] {'The animation file %s does not exist.'}, [#13 + MainForm.LCDGIFAnimations[AnimationFileIndex].FileName + #13]), mtWarning, [mbOK], 0);
      Exit;
    end;

    if AnimationFileIndex > High(MainForm.LCDGIFAnimations) then
      Exit;

    FrameDelayMultiplier := MainForm.CalculateFrameDelayMultiplier(AnimationPlaySpeed);

    if AnimationFileIndex >= 0 then
      ExtractFrameData(Area, MainForm.LCDGIFAnimations[AnimationFileIndex].FileName, Data, FrameCount, FrameColCount, BytesPerCol, FrameDelayMultiplier);

    Data[1] := BytesPerCol;  //BytesPerCol
    Data[2] := FrameColCount;  //FrameColCount
    w := FrameCount;  //FrameCount
    Data[3] := Lo(w);
    Data[4] := Hi(w);

    Data[9] := 1;
    Data[10] := 1;
  end;
end;
{$endif}

end.
