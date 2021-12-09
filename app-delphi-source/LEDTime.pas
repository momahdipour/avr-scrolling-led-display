unit LEDTime;

{$INCLUDE Config.inc}

interface

uses
  GlobalTypes;

{$IFDEF _TIME_ACTIVE_}
  function LEDTimeData(StageIndex: Integer; const Area: TArea; var Data: TDataArray): Boolean;
{$ENDIF}

implementation

{$IFDEF _TIME_ACTIVE_}
function LEDTimeData(StageIndex: Integer; const Area: TArea;
  var Data: TDataArray): Boolean;
var
  w: Word;
begin
  Result := True;

  if Area.ContentType <> ctTime then
    Exit;

  with Area do
  begin
    SetLength(Data, 8);

    if TimeLanguage = laFarsi then
      Data[0] := 0
    else
      Data[0] := 1;

    Data[1] := ClockFormat;
    Data[2] := ClockType;

    w := ClockTotalDisplayTime;
    Data[3] := Lo(w);
    Data[4] := Hi(w);

    if PutClockAtCenter then
    begin
      Data[5] := 1;
      Data[6] := 1;
    end
    else
    begin
      Data[5] := 0;
      Data[6] := 0;
    end;

    if ClockDotsBlink then
      Data[7] := 1
    else
      Data[7] := 0;
  end;
end;
{$endif}
end.
