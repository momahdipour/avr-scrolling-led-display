unit LEDDate;

{$INCLUDE Config.inc}

interface

uses
  GlobalTypes;

{$ifdef _DATE_ACTIVE_}
  function LEDDateData(StageIndex: Integer; const Area: TArea; var Data: TDataArray): Boolean;
{$endif}

implementation

{$ifdef _DATE_ACTIVE_}
function LEDDateData(StageIndex: Integer; const Area: TArea;
  var Data: TDataArray): Boolean;
var
  w: Word;
begin
  Result := True;

  if Area.ContentType <> ctDate then
    Exit;

  with Area do
  begin
    SetLength(Data, 7);

    if DateLanguage = laFarsi then
      Data[0] := 0
    else
      Data[0] := 1;

    Data[1] := DateFormat;
    Data[2] := DateType;

    w := DateTotalDisplayTime;
    Data[3] := Lo(w);
    Data[4] := Hi(w);

    if PutDateAtCenter then
    begin
      Data[5] := 1;
      Data[6] := 1;
    end
    else
    begin
      Data[5] := 0;
      Data[6] := 0;
    end;
  end;
end;
{$endif}

end.
