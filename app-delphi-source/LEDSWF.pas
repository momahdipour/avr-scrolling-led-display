unit LEDSWF;

interface

uses
  GlobalTypes, MMSWF, MMSWFHeaderReader, SoundDialogs, SysUtils, Dialogs, Classes, Graphics,
  ProgramConsts;

  function LEDSWFData(StageIndex: Integer; const Area: TArea; var Data: TDataArray): Boolean;

implementation

uses MainUnit, LEDAnimation;

procedure ExtractFrameData(const Area: TArea; SWFData: TStream;
  var Data: TDataArray; var FrameCount, FrameColCount, BytesPerCol: Integer;
  DelayMultiplier: Double);
var
  MMSWF: TMMSWF;
  MMSWFHeaderReader: TMMSWFHeaderReader;
  Frames: TFrameDataArray;
  i: Integer;
  AreaHeight, AreaWidth: Integer;
begin
  if SWFData.Size <= 0 then
    Exit;

  AreaHeight := Area.y2 - Area.y1 + 1;
  AreaWidth := Area.x2 - Area.x1 + 1;

  MMSWF := TMMSWF.Create(nil);
  MMSWFHeaderReader := TMMSWFHeaderReader.Create(nil);

  try
    MMSWF.LoadFromStream(SWFData);
    MMSWFHeaderReader.LoadFromStream(SWFData);
    MMSWF.Width := MMSWFHeaderReader.MMSWFHeader.Width;
    MMSWF.Height := MMSWFHeaderReader.MMSWFHeader.Height;
    MMSWF.ExtractFrames;
    MMSWF.NormalizeFramesToSingleColor(clWhite, clBlue, Area.SWFSensitivity);

    SetLength(Frames, 0);
    for i := 0 to MMSWF.FrameCount - 1 do
      if MMSWF.Frames[i] <> nil then
      begin
        SetLength(Frames, Length(Frames) + 1);
        Frames[High(Frames)].Bitmap := TBitmap.Create;
        Frames[High(Frames)].Bitmap.Assign(MMSWF.Frames[i]);
        //Frames[i].Delay := Trunc(Frames[i].Delay * DelayMultiplier);
        //if Frames[i].Delay = 0 then
        //  Frames[i].Delay := 5;  //Don't allow to be zero
        Frames[High(Frames)].Delay := 0;
        //Frames[High(Frames)].Bitmap.SaveToFile('C:\temp\' + IntToStr(i) + '.bmp');  //-> For Debug
      end;

    try
      LEDAnimation.ExtractFrameDataForAnimationContent(Area, Area.InvertSWF, Frames, Data, FrameCount, FrameColCount, BytesPerCol);
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
    MMSWF.Free;
    MMSWFHeaderReader.Free;
  end;
end;

function LEDSWFData(StageIndex: Integer; const Area: TArea; var Data: TDataArray): Boolean;
var
  FrameCount, FrameColCount, BytesPerCol: Integer;
  w: Word;
  i: Integer;
  FrameDelayMultiplier: Double;
begin
  Result := True;

  if Area.ContentType <> ctSWF then
    Exit;

  with Area do
  begin
    SetLength(Data, 12);

    Data[0] := MainForm.SpeedIndexToSpeedValue(SWFPlaySpeed);

    w := SWFTotalDisplayTime;
    if SWFTimingStyle = tsRepeatNTimes then
    begin
      Data[5] := SWFRepetitionTimes;  //RepetitionTimes
      Data[6] := 0;  //TotalDisplayTime
      Data[7] := 0;
    end
    else
    begin
      Data[5] := 0;  //RepetitionTimes
      Data[6] := Lo(w);  //TotalDisplayTime
      Data[7] := Hi(w);
    end;

    if InvertSWF then
      Data[8] := 1
    else
      Data[8] := 0;

    if PutSWFAtCenter then
    begin
      Data[9] := 1;  //CenterHorizontally
      Data[10] := 1;  //CenterVertically
    end
    else
    begin
      Data[9] := 0;  //CenterHorizontally
      Data[10] := 0;  //CenterVertically
    end;

    if UseSWFTimings then
      Data[11] := 1  //UseGIFTimings
    else
      Data[11] := 0;  //UseGIFTimings

    if Area.SWFData.Size <= 0 then
    begin
      Result := False;
      MainForm.HideLastWaitState;
      WideMessageDlgSoundTop(WideFormat(Dyn_Texts[135] {'You have not defined any SWF animation for the stage %s.'}, [IntToStr(StageIndex + 1 {StageIndex starts from 0 so add 1 to it})]), mtWarning, [mbOK], 0);
      Exit;
    end;


    if Data[0] = 0 then
      FrameDelayMultiplier := (Data[0] + 1) / NORMAL_SPEED_VALUE
    else
      FrameDelayMultiplier := Data[0] / NORMAL_SPEED_VALUE;

    ExtractFrameData(Area, Area.SWFData, Data, FrameCount, FrameColCount, BytesPerCol, FrameDelayMultiplier);

    Data[1] := BytesPerCol;  //BytesPerCol
    Data[2] := FrameColCount;  //FrameColCount
    w := FrameCount;  //FrameCount
    Data[3] := Lo(w);
    Data[4] := Hi(w);

    Data[9] := 1;
    Data[10] := 1;
  end;
end;

end.
