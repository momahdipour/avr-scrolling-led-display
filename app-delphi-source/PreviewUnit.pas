unit PreviewUnit;

interface

uses
  Windows, GlobalTypes, Graphics, Dialogs, ProcsUnit, StrUtils, Classes,
  ProgramConsts;

  procedure TimePreview(const Area: TArea; b: TBitmap);
  procedure DatePreview(const Area: TArea; b: TBitmap);
  procedure TemperaturePreview(const Area: TArea; b: TBitmap);
  procedure EmptyPreview(const Area: TArea; b: TBitmap);

implementation

uses SysUtils, DateUtils, MainUnit;

procedure GenerateBitmapPreview(const Str: String; Language: TLanguage; var Bitmap: TBitmap);
  function CharToResName(C: Char): String;
  begin
    if C in ['0'..'9'] then
      Result := 'DIGIT_' + C
    else
    begin
      case C of
        '/':  Result := 'SLASH';
        '-':  Result := 'DASH';
        ':':  Result := 'COLON';
        ' ':  Result := 'SPACE';
        'C':  Result := 'CENTIGRADE';
        'F':  Result := 'FAHRENHEIT';
        else
          Result := '';
      end;
    end;
  end;

  procedure GetBitmap(C: Char; var b: TBitmap);
  var
    ResName: String;
  begin
    b.Width := 0;  //Clear the bitmap, otherwise the result will overlap with bitmap of old characters
    b.Height := 0;

    case Language of
      laFarsi:    ResName := 'F_' + CharToResName(C);
      laEnglish:  ResName := 'E_' + CharToResName(C);
    end;

    try
      b.LoadFromResourceName(HInstance, ResName);
    except
    end;
  end;

var
  i: Integer;
  b: TBitmap;
  x: Integer;
begin
  Bitmap.Width := 0;  //Clear Bitmap
  Bitmap.Height := 0;

  b := TBitmap.Create;
  try

  x := 1;

  for i := 1 to Length(Str) do
  begin
    GetBitmap(Str[i], b);
    Bitmap.Width := Bitmap.Width + b.Width;
    if b.Height > Bitmap.Height then
      Bitmap.Height := b.Height;
    Bitmap.Canvas.Draw(x, 1, b);
    x := Bitmap.Width + 1;
  end;

  finally

  b.Free;  //If not freed, will make number of GDI Objects to get very large and consequently will causde application error

  end;
end;

var
  TimePreviewOldTime: TDateTime;

procedure TimePreview(const Area: TArea; b: TBitmap);
var
  TimeStr: String;
  dt: TDateTime;
  h, m, s, ms: Word;
  ColonChar: Char;
begin
  dt := GetTime;

  if not(Area.ClockDotsBlink and GlobalOptions.AutomaticallyRefreshTimePreview) then
    ColonChar := ':'
  else
  begin
    if SecondOf(dt) = SecondOf(TimePreviewOldTime) then
    begin
      if MilliSecondsBetween(TimePreviewOldTime, dt) < 500 then
        ColonChar := ':'
      else
        ColonChar := ' ';
    end
    else
    begin
      ColonChar := ':';
      TimePreviewOldTime := dt;
    end;
  end;

  with Area do
  begin
    DecodeTime(dt, h, m, s, ms);

    if ClockType = 1 then
    begin
      if h > 12 then
        h := h - 12
      else if h = 0 then
        h := 12;
    end;

    if ClockFormat = 0 then  //hh:mm:ss
      TimeStr := Format('%.2d:%.2d%s%.2d', [h, m, ColonChar, s])
    else
      TimeStr := Format('%.2d%s%.2d', [h, ColonChar, m]);

    //ShowMessage(TimeStr);
    GenerateBitmapPreview(TimeStr, TimeLanguage, b);
  end;
end;

var
  DatePreviewOldTime: TDateTime;
  DatePreviewItemToShow: Integer = 1;  //0 = show day and month, 1 = show year

procedure DatePreview(const Area: TArea; b: TBitmap);
  function GetTwoDigitYear(Y: Integer): Integer;
  begin
    if Y >= 10 then
      Result := StrToInt(RightStr(IntToStr(Y), 2))
    else
      Result := Y;
  end;

var
  DateStr: String;
  dt: TDateTime;
  y, m, d: Word;
begin
  with Area do
  begin
    dt := Today;
    DecodeDate(dt, y, m, d);

    if DateType = 0 then  //Solar date
      Procs.ChristianToSolar(y, m, d);

    dt := Time;

    case DateFormat of
      0:  DateStr := Format('%.4d/%.2d/%.2d', [y, m, d]);  //0 = 1387/01/01
      1:  DateStr := Format('%.2d/%.2d/%.2d', [GetTwoDigitYear(y), m, d]);  //1 = 87/01/01
      2:  DateStr := Format('%.4d-%.2d-%.2d', [y, m, d]);  //2 = 1387-01-01
      3:  DateStr := Format('%.2d-%.2d-%.2d', [GetTwoDigitYear(y), m, d]);  //3 = 87-01-01
      4, 5:
        begin
          if DatePreviewItemToShow = 0 then  //Show day and month
          begin
            if DateFormat = 4 then  //'/'
              DateStr := Format('%.2d/%.2d', [m, d])
            else //if DateFormat = 4 then  //'-'
              DateStr := Format('%.2d-%.2d', [m, d]);

            if MilliSecondsBetween(dt, DatePreviewOldTime) >= 1600 then
            begin
              DatePreviewOldTime := dt;
              DatePreviewItemToShow := 1;  //Show year
            end;
          end
          else //if DatePreviewItemToShow = 1 then  //Show year
          begin
            if DateFormat = 4 then  //'/'
              DateStr := Format('%.4d', [y])
            else //if DateFormat = 4 then  //'-'
              DateStr := Format('%.4d', [y]);

            if MilliSecondsBetween(dt, DatePreviewOldTime) >= 1600 then
            begin
              DatePreviewOldTime := dt;
              DatePreviewItemToShow := 0;  //Show day and month
            end;
          end;
        end;
    end;

    //ShowMessage(DateStr);
    GenerateBitmapPreview(DateStr, DateLanguage, b);
  end;
end;

procedure TemperaturePreview(const Area: TArea; b: TBitmap);
var
  TempStr: String;
begin
  TempStr := '-00';

  with Area do
  begin
    case TemperatureUnit of
      0:  TempStr := TempStr + 'C';  //Centigrade
      1:  TempStr := TempStr + 'F';  //Fahrenheit
    end;

    GenerateBitmapPreview(TempStr, TemperatureLanguage, b);
  end;
end;

procedure EmptyPreview(const Area: TArea; b: TBitmap);
begin
  b.Width := 0;
  b.Height := 0;
  b.Width := 615 * 2;
  b.Height := 71 * 2;
  if Area.EmptyAreaFilled then
  begin
    b.Canvas.Brush.Color := clBlue;
    b.Canvas.Brush.Style := bsSolid;
    b.Canvas.FillRect(Rect(1, 1, b.Width, b.Height));
    b.Canvas.Pixels[0, b.Height - 1] := clWhite;
  end
  else
  begin
    b.Canvas.Brush.Color := clWhite;
    b.Canvas.Brush.Style := bsSolid;
    b.Canvas.FillRect(Rect(1, 1, b.Width, b.Height));
  end;
end;

initialization


finalization


end.
