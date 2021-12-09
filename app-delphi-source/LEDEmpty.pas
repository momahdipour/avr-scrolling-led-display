unit LEDEmpty;

{$INCLUDE Config.inc}

interface

uses
  GlobalTypes;

  function LEDEmptyData(StageIndex: Integer; const Area: TArea; var Data: TDataArray): Boolean;

implementation

function LEDemptyData(StageIndex: Integer; const Area: TArea;
  var Data: TDataArray): Boolean;
var
  w: Word;
begin
  Result := True;

  if Area.ContentType <> ctEmpty then
    Exit;

  with Area do
  begin
    SetLength(Data, 3);

    if EmptyAreaFilled then
      Data[0] := 1
    else
      Data[0] := 0;

    w := EmptyAreaTotalDisplayTime;
    Data[1] := Lo(w);
    Data[2] := Hi(w);
  end;
end;

end.
