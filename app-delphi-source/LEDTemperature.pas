unit LEDTemperature;

{$INCLUDE Config.inc}

interface

uses
  GlobalTypes;

{$ifdef _TEMPERATURE_ACTIVE_}
  function LEDTemperatureData(StageIndex: Integer; const Area: TArea; var Data: TDataArray): Boolean;
{$endif}

implementation

{$ifdef _TEMPERATURE_ACTIVE_}
function LEDTemperatureData(StageIndex: Integer; const Area: TArea;
  var Data: TDataArray): Boolean;
var
  w: Word;
begin
  Result := True;

  if Area.ContentType <> ctTemperature then
    Exit;

  with Area do
  begin
    SetLength(Data, 6);

    if TemperatureLanguage = laFarsi then
      Data[0] := 0
    else
      Data[0] := 1;

    Data[1] := TemperatureUnit;

    w := TemperatureTotalDisplayTime;
    Data[2] := Lo(w);
    Data[3] := Hi(w);

    if PutTemperatureAtCenter then
    begin
      Data[4] := 1;
      Data[5] := 1;
    end
    else
    begin
      Data[4] := 0;
      Data[5] := 0;
    end;
  end;
end;
{$endif}

end.
