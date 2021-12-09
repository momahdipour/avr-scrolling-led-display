unit Layouts;

interface

uses
  GlobalTypes, ProgramConsts, License;

  procedure SetLayout(var Areas: TAreasArray; LayoutIndex: Integer; DisplayHeight, DisplayWidth: Integer; var CustomLayout: Boolean);

  function GetMaxLayoutIndex(DisplayHeight, DisplayWidth: Integer): Integer;

implementation

type
  TLayoytSizeType = (lstRelative, lstAbsolute);
  TLayoutSize = record
    Size: Integer;
    SizeType: TLayoytSizeType;
  end;

  TLayout = record
    Width: TLayoutSize;
    Height: TLayoutSize;
  end;

//const
//  LAYOUT_COUNT = 2;
{  Layouts8: array[0..0] of TLayout = (
    ( Width: ( Size: 1; SizeType: lstRelative); Height: (Size: 0; SizeType: lstRelative) ),
    ( Width: ( Size: 2; SizeType: lstRelative); Height: (Size: 0; SizeType: lstRelative) ),
    ( Width: ( Size: 3; SizeType: lstRelative); Height: (Size: 0; SizeType: lstRelative) ),
    ( Width: ( Size: 0; SizeType: lstRelative); Height: (Size: 0; SizeType: lstRelative) ),
  );}
//  PredefinedLayouts: array[0..LAYOUT_COUNT - 1] of TAreasArray;

procedure SetArea(var Area: TArea; x1, x2, y1, y2: Integer;
  SizeChangingMode: TAreaSizeChanging);
begin
  Area.x1 := x1;
  Area.y1 := y1;
  Area.x2 := x2;
  Area.y2 := y2;
  Area.SizeChangingMode := SizeChangingMode;
end;

procedure SetLayout(var Areas: TAreasArray; LayoutIndex: Integer; DisplayHeight, DisplayWidth: Integer; var CustomLayout: Boolean);
  procedure SetDefaultLayout(var Areas: TAreasArray);
  begin
    SetArea(Areas[1], 0, DisplayWidth - 1, 0, DisplayHeight - 1, scNone);
    SetArea(Areas[2], 0, 0, 0, 0, scHorizontal);
    SetArea(Areas[3], 0, 0, 0, 0, scHorizontal);
    SetArea(Areas[4], 0, 0, 0, 0, scHorizontal);
  end;
begin
  if (License._LED_DISPLAY_MAX_ROW_COUNT_ > 0) and
     (DisplayHeight > License._LED_DISPLAY_MAX_ROW_COUNT_) then
    Halt;

  CustomLayout := False;  //By default, set it to False
    
  if DisplayHeight in [4, 5, 6, 7, 8, 9, 10, 11, 12, 13] then
  begin
    case LayoutIndex of
      1:
        begin
          SetArea(Areas[1], 0, DisplayWidth - 1, 0, DisplayHeight - 1, scNone);
          SetArea(Areas[2], 0, 0, 0, 0, scHorizontal);
          SetArea(Areas[3], 0, 0, 0, 0, scHorizontal);
          SetArea(Areas[4], 0, 0, 0, 0, scHorizontal);
        end;
      2:
        begin
          SetArea(Areas[1], 0, 3 * Trunc(DisplayWidth / 4) - 1, 0, DisplayHeight - 1, scHorizontal);
          SetArea(Areas[2], Areas[1].x2 + 1, DisplayWidth - 1, 0, DisplayHeight - 1, scHorizontal);
          SetArea(Areas[3], 0, 0, 0, 0, scHorizontal);
          SetArea(Areas[4], 0, 0, 0, 0, scHorizontal);
        end;
      3:
        begin
          SetArea(Areas[1], 0, Trunc(DisplayWidth / 3) - 1, 0, DisplayHeight - 1, scHorizontal);
          SetArea(Areas[2], Areas[1].x2 + 1, 2 * Trunc(DisplayWidth / 3) - 1, 0, DisplayHeight - 1, scHorizontal);
          SetArea(Areas[3], Areas[2].x2 + 1, DisplayWidth - 1, 0, DisplayHeight - 1, scHorizontal);
          SetArea(Areas[4], 0, 0, 0, 0, scHorizontal);
        end;
      4:
        begin
          SetArea(Areas[1], 0, Trunc(DisplayWidth / 4) - 1, 0, DisplayHeight - 1, scHorizontal);
          SetArea(Areas[2], Areas[1].x2 + 1, 2 * Trunc(DisplayWidth / 4) - 1, 0, DisplayHeight - 1, scHorizontal);
          SetArea(Areas[3], Areas[2].x2 + 1, 3 * Trunc(DisplayWidth / 4) - 1, 0, DisplayHeight - 1, scHorizontal);
          SetArea(Areas[4], Areas[3].x2 + 1, DisplayWidth - 1, 0, DisplayHeight - 1, scHorizontal);
        end;
      5:
        begin
          SetArea(Areas[1], 0, DisplayWidth - 1, 0, Trunc(DisplayHeight / 2) - 1, scVertical);
          SetArea(Areas[2], 0, DisplayWidth - 1, Areas[1].y2 + 1, DisplayHeight - 1, scVertical);
          SetArea(Areas[3], 0, 0, 0, 0, scVertical);
          SetArea(Areas[4], 0, 0, 0, 0, scHorizontal);
        end;
      else
        SetDefaultLayout(Areas);
    end;
  end
  else if DisplayHeight in [14, 15, 16, 17, 18, 19, 20, 21, 22, 23] then
  begin
    case LayoutIndex of
      1:
        begin
          SetArea(Areas[1], 0, DisplayWidth - 1, 0, DisplayHeight - 1, scNone);
          SetArea(Areas[2], 0, 0, 0, 0, scHorizontal);
          SetArea(Areas[3], 0, 0, 0, 0, scHorizontal);
          SetArea(Areas[4], 0, 0, 0, 0, scHorizontal);
        end;
      2:
        begin
          SetArea(Areas[1], 0, DisplayWidth - 1, 0, Trunc(DisplayHeight / 2) - 1, scVertical);
          SetArea(Areas[2], 0, DisplayWidth - 1, Areas[1].y2 + 1, DisplayHeight - 1, scVertical);
          SetArea(Areas[3], 0, 0, 0, 0, scVertical);
          SetArea(Areas[4], 0, 0, 0, 0, scHorizontal);
        end;
      3:
        begin
          SetArea(Areas[1], 0, DisplayWidth - 1, 0, Trunc(DisplayHeight / 4) - 1, scVertical);
          SetArea(Areas[2], 0, DisplayWidth - 1, Areas[1].y2 + 1, 3 * Trunc(DisplayHeight / 4) - 1, scVertical);
          SetArea(Areas[3], 0, DisplayWidth - 1, Areas[2].y2 + 1, DisplayHeight - 1, scVertical);
          SetArea(Areas[4], 0, 0, 0, 0, scHorizontal);
        end;
      4:
        begin
          SetArea(Areas[1], 0, Trunc(DisplayWidth / 2) - 1, 0, DisplayHeight - 1, scHorizontal);
          SetArea(Areas[2], Areas[1].x2 + 1, DisplayWidth - 1, 0, DisplayHeight - 1, scHorizontal);
          SetArea(Areas[3], 0, 0, 0, 0, scHorizontal);
          SetArea(Areas[4], 0, 0, 0, 0, scHorizontal);
        end;
      5:
        begin
          SetArea(Areas[1], 0, Trunc(DisplayWidth / 3) - 1, 0, DisplayHeight - 1, scHorizontal);
          SetArea(Areas[2], Areas[1].x2 + 1, 2 * Trunc(DisplayWidth / 3) - 1, 0, DisplayHeight - 1, scHorizontal);
          SetArea(Areas[3], Areas[2].x2 + 1, DisplayWidth - 1, 0, DisplayHeight - 1, scHorizontal);
          SetArea(Areas[4], 0, 0, 0, 0, scHorizontal);
        end;
      6:
        begin
          {
          SetArea(Areas[1], 0, Trunc(DisplayWidth / 4) - 1, 0, DisplayHeight - 1, scHorizontal);
          SetArea(Areas[2], Areas[1].x2 + 1, 2 * Trunc(DisplayWidth / 4) - 1, 0, DisplayHeight - 1, scHorizontal);
          SetArea(Areas[3], Areas[2].x2 + 1, 3 * Trunc(DisplayWidth / 4) - 1, 0, DisplayHeight - 1, scHorizontal);
          SetArea(Areas[4], Areas[3].x2 + 1, DisplayWidth - 1, 0, DisplayHeight - 1, scHorizontal);
          }
          CustomLayout := True;
          SetArea(Areas[1], 0, 3 * Trunc(DisplayWidth / 4) - 1, 0, Trunc(DisplayHeight / 2) - 1, scNone);
          SetArea(Areas[2], Areas[1].x2 + 1, DisplayWidth - 1, 0, Trunc(DisplayHeight / 2) - 1, scNone);
          SetArea(Areas[3], Areas[1].x1, Areas[1].x2, Areas[1].y2 + 1, DisplayHeight - 1, scNone);
          SetArea(Areas[4], Areas[2].x1, Areas[2].x2, Areas[1].y2 + 1, DisplayHeight - 1, scNone);
        end;
      7:
        begin
          SetArea(Areas[1], 0, DisplayWidth - 1, 0, Trunc(DisplayHeight / 2) - 1, scVertical);
          SetArea(Areas[2], 0, Trunc(DisplayWidth / 2) - 1, Areas[1].y2 + 1, DisplayHeight - 1, scHorizontal);
          SetArea(Areas[3], Areas[2].x2 + 1, DisplayWidth - 1, Areas[1].y2 + 1, DisplayHeight - 1, scHorizontal);
          SetArea(Areas[4], 0, 0, 0, 0, scHorizontal);
        end;
      8:
        begin
          SetArea(Areas[1], 0, DisplayWidth - 1, 0, Trunc(DisplayHeight / 2) - 1, scVertical);
          SetArea(Areas[2], 0, Trunc(DisplayWidth / 3) - 1, Areas[1].y2 + 1, DisplayHeight - 1, scHorizontal);
          SetArea(Areas[3], Areas[2].x2 + 1, 2 * Trunc(DisplayWidth / 3) - 1, Areas[1].y2 + 1, DisplayHeight - 1, scHorizontal);
          SetArea(Areas[4], Areas[3].x2 + 1, DisplayWidth - 1, Areas[1].y2 + 1, DisplayHeight - 1, scHorizontal);
        end;
      9:
        begin
          SetArea(Areas[1], 0, Trunc(DisplayWidth / 2) - 1, 0, DisplayHeight - 1, scHorizontal);
          SetArea(Areas[2], Areas[1].x2 + 1, DisplayWidth - 1, 0, Trunc(DisplayHeight / 2) - 1, scVertical);
          SetArea(Areas[3], Areas[1].x2 + 1, DisplayWidth - 1, Areas[2].y2 + 1, DisplayHeight - 1, scVertical);
          SetArea(Areas[4], 0, 0, 0, 0, scHorizontal);
        end;
      10:
        begin
          SetArea(Areas[1], 0, Trunc(DisplayWidth / 2) - 1, 0, Trunc(DisplayHeight / 2) - 1, scHorizontal);
          SetArea(Areas[2], Areas[1].x2 + 1, DisplayWidth - 1, 0, Trunc(DisplayHeight / 2) - 1, scHorizontal);
          SetArea(Areas[3], 0, DisplayWidth - 1, Areas[1].y2 + 1, DisplayHeight - 1, scVertical);
          SetArea(Areas[4], 0, 0, 0, 0, scHorizontal);
        end;
      11:
        begin
          SetArea(Areas[1], 0, Trunc(DisplayWidth / 3) - 1, 0, Trunc(DisplayHeight / 2) - 1, scHorizontal);
          SetArea(Areas[2], Areas[1].x2 + 1, 2 * Trunc(DisplayWidth / 3) - 1, 0, Areas[1].y2, scHorizontal);
          SetArea(Areas[3], Areas[2].x2 + 1, DisplayWidth - 1, 0, Areas[1].y2, scHorizontal);
          SetArea(Areas[4], 0, DisplayWidth - 1, Areas[1].y2 + 1, DisplayHeight - 1, scVertical);
        end;
      12:
        begin
          SetArea(Areas[1], 0, Trunc(DisplayWidth / 2) - 1, 0, Trunc(DisplayHeight / 2) - 1, scVertical);
          SetArea(Areas[2], 0, Trunc(DisplayWidth / 2) - 1, Areas[1].y2 + 1, DisplayHeight - 1, scVertical);
          SetArea(Areas[3], Areas[2].x2 + 1, DisplayWidth - 1, 0, DisplayHeight - 1, scHorizontal);
          SetArea(Areas[4], 0, 0, 0, 0, scHorizontal);
        end;
      else
        SetDefaultLayout(Areas);
    end;
  end
  else if DisplayHeight in [24, 25, 26, 27, 28] then
  begin
    case LayoutIndex of
      1:
        begin
          SetArea(Areas[1], 0, DisplayWidth - 1, 0, DisplayHeight - 1, scNone);
          SetArea(Areas[2], 0, 0, 0, 0, scHorizontal);
          SetArea(Areas[3], 0, 0, 0, 0, scHorizontal);
          SetArea(Areas[4], 0, 0, 0, 0, scHorizontal);
        end;
      2:
        begin
          SetArea(Areas[1], 0, DisplayWidth - 1, 0, Trunc(DisplayHeight / 2) - 1, scVertical);
          SetArea(Areas[2], 0, DisplayWidth - 1, Areas[1].y2 + 1, DisplayHeight - 1, scVertical);
          SetArea(Areas[3], 0, 0, 0, 0, scVertical);
          SetArea(Areas[4], 0, 0, 0, 0, scHorizontal);
        end;
      3:
        begin
          SetArea(Areas[1], 0, DisplayWidth - 1, 0, Trunc(DisplayHeight / 3) - 1, scVertical);
          SetArea(Areas[2], 0, DisplayWidth - 1, Areas[1].y2 + 1, 2 * Trunc(DisplayHeight / 3) - 1, scVertical);
          SetArea(Areas[3], 0, DisplayWidth - 1, Areas[2].y2 + 1, DisplayHeight - 1, scVertical);
          SetArea(Areas[4], 0, 0, 0, 0, scHorizontal);
        end;
      4:
        begin
          SetArea(Areas[1], 0, Trunc(DisplayWidth / 2) - 1, 0, DisplayHeight - 1, scHorizontal);
          SetArea(Areas[2], Areas[1].x2 + 1, DisplayWidth - 1, 0, DisplayHeight - 1, scHorizontal);
          SetArea(Areas[3], 0, 0, 0, 0, scHorizontal);
          SetArea(Areas[4], 0, 0, 0, 0, scHorizontal);
        end;
      5:
        begin
          SetArea(Areas[1], 0, Trunc(DisplayWidth / 3) - 1, 0, DisplayHeight - 1, scHorizontal);
          SetArea(Areas[2], Areas[1].x2 + 1, 2 * Trunc(DisplayWidth / 3), 0, DisplayHeight - 1, scHorizontal);
          SetArea(Areas[3], Areas[2].x2 + 1, DisplayWidth - 1, 0, DisplayHeight - 1, scHorizontal);
          SetArea(Areas[4], 0, 0, 0, 0, scHorizontal);
        end;
      6:
        begin
          {
          SetArea(Areas[1], 0, Trunc(DisplayWidth / 4) - 1, 0, DisplayHeight - 1, scHorizontal);
          SetArea(Areas[2], Areas[1].x2 + 1, 2 * Trunc(DisplayWidth / 4) - 1, 0, DisplayHeight - 1, scHorizontal);
          SetArea(Areas[3], Areas[2].x2 + 1, 3 * Trunc(DisplayWidth / 4) - 1, 0, DisplayHeight - 1, scHorizontal);
          SetArea(Areas[4], Areas[3].x2 + 1, DisplayWidth - 1, 0, DisplayHeight - 1, scHorizontal);
          }
          CustomLayout := True;
          SetArea(Areas[1], 0, 3 * Trunc(DisplayWidth / 4) - 1, 0, Trunc(DisplayHeight / 2) - 1, scNone);
          SetArea(Areas[2], Areas[1].x2 + 1, DisplayWidth - 1, 0, Trunc(DisplayHeight / 2) - 1, scNone);
          SetArea(Areas[3], Areas[1].x1, Areas[1].x2, Areas[1].y2 + 1, DisplayHeight - 1, scNone);
          SetArea(Areas[4], Areas[2].x1, Areas[2].x2, Areas[1].y2 + 1, DisplayHeight - 1, scNone);
        end;
      7:
        begin
          SetArea(Areas[1], 0, DisplayWidth - 1, 0, Trunc(DisplayHeight / 2) - 1, scVertical);
          SetArea(Areas[2], 0, Trunc(DisplayWidth / 2) - 1, Areas[1].y2 + 1, DisplayHeight - 1, scHorizontal);
          SetArea(Areas[3], Areas[2].x2 + 1, DisplayWidth - 1, Areas[1].y2 + 1, DisplayHeight - 1, scHorizontal);
          SetArea(Areas[4], 0, 0, 0, 0, scHorizontal);
        end;
      8:
        begin
          SetArea(Areas[1], 0, DisplayWidth - 1, 0, Trunc(DisplayHeight / 2) - 1, scVertical);
          SetArea(Areas[2], 0, Trunc(DisplayWidth / 3) - 1, Areas[1].y2 + 1, DisplayHeight - 1, scHorizontal);
          SetArea(Areas[3], Areas[2].x2 + 1, 2 * Trunc(DisplayWidth / 3) - 1, Areas[1].y2 + 1, DisplayHeight - 1, scHorizontal);
          SetArea(Areas[4], Areas[3].x2 + 1, DisplayWidth - 1, Areas[1].y2 + 1, DisplayHeight - 1, scHorizontal);
        end;
      9:
        begin
          SetArea(Areas[1], 0, Trunc(DisplayWidth / 2) - 1, 0, DisplayHeight - 1, scHorizontal);
          SetArea(Areas[2], Areas[1].x2 + 1, DisplayWidth - 1, 0, Trunc(DisplayHeight / 2) - 1, scVertical);
          SetArea(Areas[3], Areas[1].x2 + 1, DisplayWidth - 1, Areas[2].y2 + 1, DisplayHeight - 1, scVertical);
          SetArea(Areas[4], 0, 0, 0, 0, scHorizontal);
        end;
      10:
        begin
          SetArea(Areas[1], 0, Trunc(DisplayWidth / 2) - 1, 0, Trunc(DisplayHeight / 2) - 1, scHorizontal);
          SetArea(Areas[2], Areas[1].x2 + 1, DisplayWidth - 1, 0, Trunc(DisplayHeight / 2) - 1, scHorizontal);
          SetArea(Areas[3], 0, DisplayWidth - 1, Areas[1].y2 + 1, DisplayHeight - 1, scVertical);
          SetArea(Areas[4], 0, 0, 0, 0, scHorizontal);
        end;
      11:
        begin
          SetArea(Areas[1], 0, Trunc(DisplayWidth / 3) - 1, 0, Trunc(DisplayHeight / 2) - 1, scHorizontal);
          SetArea(Areas[2], Areas[1].x2 + 1, 2 * Trunc(DisplayWidth / 3) - 1, 0, Areas[1].y2, scHorizontal);
          SetArea(Areas[3], Areas[2].x2 + 1, DisplayWidth - 1, 0, Areas[1].y2, scHorizontal);
          SetArea(Areas[4], 0, DisplayWidth - 1, Areas[1].y2 + 1, DisplayHeight - 1, scVertical);
        end;
      12:
        begin
          SetArea(Areas[1], 0, Trunc(DisplayWidth / 2) - 1, 0, Trunc(DisplayHeight / 2) - 1, scVertical);
          SetArea(Areas[2], 0, Trunc(DisplayWidth / 2) - 1, Areas[1].y2 + 1, DisplayHeight - 1, scVertical);
          SetArea(Areas[3], Areas[2].x2 + 1, DisplayWidth - 1, 0, DisplayHeight - 1, scHorizontal);
          SetArea(Areas[4], 0, 0, 0, 0, scHorizontal);
        end;
      else
        SetDefaultLayout(Areas);
    end;
  end
  else if DisplayHeight in [29, 30, 31, 32] then
  begin
    case LayoutIndex of
      1:
        begin
          SetArea(Areas[1], 0, DisplayWidth - 1, 0, DisplayHeight - 1, scNone);
          SetArea(Areas[2], 0, 0, 0, 0, scHorizontal);
          SetArea(Areas[3], 0, 0, 0, 0, scHorizontal);
          SetArea(Areas[4], 0, 0, 0, 0, scHorizontal);
        end;
      2:
        begin
          SetArea(Areas[1], 0, DisplayWidth - 1, 0, Trunc(DisplayHeight / 2) - 1, scVertical);
          SetArea(Areas[2], 0, DisplayWidth - 1, Areas[1].y2 + 1, DisplayHeight - 1, scVertical);
          SetArea(Areas[3], 0, 0, 0, 0, scVertical);
          SetArea(Areas[4], 0, 0, 0, 0, scHorizontal);
        end;
      3:
        begin
          {
          SetArea(Areas[1], 0, DisplayWidth - 1, 0, Trunc(DisplayHeight / 4) - 1, scVertical);
          SetArea(Areas[2], 0, DisplayWidth - 1, Areas[1].y2 + 1, 3 * Trunc(DisplayHeight / 4) - 1, scVertical);
          SetArea(Areas[3], 0, DisplayWidth - 1, Areas[2].y2 + 1, DisplayHeight - 1, scVertical);
          SetArea(Areas[4], 0, 0, 0, 0, scHorizontal);
          }
          SetArea(Areas[1], 0, DisplayWidth - 1, 0, Trunc(DisplayHeight / 3) - 1, scVertical);
          SetArea(Areas[2], 0, DisplayWidth - 1, Areas[1].y2 + 1, 2 * Trunc(DisplayHeight / 3) - 1, scVertical);
          SetArea(Areas[3], 0, DisplayWidth - 1, Areas[2].y2 + 1, DisplayHeight - 1, scVertical);
          SetArea(Areas[4], 0, 0, 0, 0, scHorizontal);
        end;
      4:
        begin
          SetArea(Areas[1], 0, DisplayWidth - 1, 0, Trunc(DisplayHeight / 4) - 1, scVertical);
          SetArea(Areas[2], 0, DisplayWidth - 1, Areas[1].y2 + 1, 2 * Trunc(DisplayHeight / 4) - 1, scVertical);
          SetArea(Areas[3], 0, DisplayWidth - 1, Areas[2].y2 + 1, 3 * Trunc(DisplayHeight / 4) - 1, scVertical);
          SetArea(Areas[4], 0, DisplayWidth - 1, Areas[3].y2 + 1, DisplayHeight - 1, scVertical);
        end;
      5:
        begin
          SetArea(Areas[1], 0, Trunc(DisplayWidth / 2) - 1, 0, DisplayHeight - 1, scHorizontal);
          SetArea(Areas[2], Areas[1].x2 + 1, DisplayWidth - 1, 0, DisplayHeight - 1, scHorizontal);
          SetArea(Areas[3], 0, 0, 0, 0, scHorizontal);
          SetArea(Areas[4], 0, 0, 0, 0, scHorizontal);
        end;
      6:
        begin
          {
          SetArea(Areas[1], 0, Trunc(DisplayWidth / 3) - 1, 0, DisplayHeight - 1, scHorizontal);
          SetArea(Areas[2], Areas[1].x2 + 1, 2 * Trunc(DisplayWidth / 3) - 1, 0, DisplayHeight - 1, scHorizontal);
          SetArea(Areas[3], Areas[2].x2 + 1, DisplayWidth - 1, 0, DisplayHeight - 1, scHorizontal);
          SetArea(Areas[4], 0, 0, 0, 0, scHorizontal);
          }
          CustomLayout := True;
          SetArea(Areas[1], 0, 3 * Trunc(DisplayWidth / 4) - 1, 0, Trunc(DisplayHeight / 2) - 1, scNone);
          SetArea(Areas[2], Areas[1].x2 + 1, DisplayWidth - 1, 0, Trunc(DisplayHeight / 2) - 1, scNone);
          SetArea(Areas[3], Areas[1].x1, Areas[1].x2, Areas[1].y2 + 1, DisplayHeight - 1, scNone);
          SetArea(Areas[4], Areas[2].x1, Areas[2].x2, Areas[1].y2 + 1, DisplayHeight - 1, scNone);
        end;
      7:
        begin
          SetArea(Areas[1], 0, DisplayWidth - 1, 0, Trunc(DisplayHeight / 2) - 1, scVertical);
          SetArea(Areas[2], 0, Trunc(DisplayWidth / 2) - 1, Areas[1].y2 + 1, DisplayHeight -1, scHorizontal);
          SetArea(Areas[3], Areas[2].x2 + 1, DisplayWidth - 1, Areas[1].y2 + 1, DisplayHeight - 1, scHorizontal);
          SetArea(Areas[4], 0, 0, 0, 0, scHorizontal);
        end;
      8:
        begin
          SetArea(Areas[1], 0, DisplayWidth - 1, 0, Trunc(DisplayHeight / 2) - 1, scVertical);
          SetArea(Areas[2], 0, Trunc(DisplayWidth / 3) - 1, Areas[1].y2 + 1, DisplayHeight - 1, scHorizontal);
          SetArea(Areas[3], Areas[2].x2 + 1, 2 * Trunc(DisplayWidth / 3) - 1, Areas[1].y2 + 1, DisplayHeight - 1, scHorizontal);
          SetArea(Areas[4], Areas[3].x2 + 1, DisplayWidth - 1, Areas[1].y2 + 1, DisplayHeight - 1, scHorizontal);
        end;
      9:
        begin
          SetArea(Areas[1], 0, Trunc(DisplayWidth / 2) - 1, 0, DisplayHeight - 1, scHorizontal);
          SetArea(Areas[2], Areas[1].x2 + 1, DisplayWidth - 1, 0, Trunc(DisplayHeight / 2) - 1, scVertical);
          SetArea(Areas[3], Areas[1].x2 + 1, DisplayWidth - 1, Areas[2].y2 + 1, DisplayHeight - 1, scVertical);
          SetArea(Areas[4], 0, 0, 0, 0, scHorizontal);
        end;
      10:
        begin
          SetArea(Areas[1], 0, Trunc(DisplayWidth / 2) - 1, 0, Trunc(DisplayHeight / 2) - 1, scHorizontal);
          SetArea(Areas[2], Areas[1].x2 + 1, DisplayWidth - 1, 0, Trunc(DisplayHeight / 2) - 1, scHorizontal);
          SetArea(Areas[3], 0, DisplayWidth - 1, Areas[1].y2 + 1, DisplayHeight - 1, scVertical);
          SetArea(Areas[4], 0, 0, 0, 0, scHorizontal);
        end;
      11:
        begin
          SetArea(Areas[1], 0, Trunc(DisplayWidth / 3) - 1, 0, Trunc(DisplayHeight / 2) - 1, scHorizontal);
          SetArea(Areas[2], Areas[1].x2 + 1, 2 * Trunc(DisplayWidth / 3) - 1, 0, Areas[1].y2, scHorizontal);
          SetArea(Areas[3], Areas[2].x2 + 1, DisplayWidth - 1, 0, Areas[1].y2, scHorizontal);
          SetArea(Areas[4], 0, DisplayWidth - 1, Areas[1].y2 + 1, DisplayHeight - 1, scVertical);
        end;
      12:
        begin
          SetArea(Areas[1], 0, Trunc(DisplayWidth / 2) - 1, 0, Trunc(DisplayHeight / 2) - 1, scVertical);
          SetArea(Areas[2], 0, Trunc(DisplayWidth / 2) - 1, Areas[1].y2 + 1, DisplayHeight - 1, scVertical);
          SetArea(Areas[3], Areas[2].x2 + 1, DisplayWidth - 1, 0, DisplayHeight - 1, scHorizontal);
          SetArea(Areas[4], 0, 0, 0, 0, scHorizontal);
        end;
      else
        SetDefaultLayout(Areas);
    end;
  end
  else
  begin
    SetDefaultLayout(Areas);
  end;
end;

function GetMaxLayoutIndex(DisplayHeight, DisplayWidth: Integer): Integer;
begin
  //DisplayWidth parameter is not used in this version but is completely supported
  case DisplayHeight of
    4, 5, 6, 7, 8, 9, 10, 11, 12, 13:  Result := 5;
    14, 15, 16, 17, 18, 19, 20, 21, 22, 23: Result := 12;
    24, 25, 26, 27, 28: Result := 12;
    29, 30, 31, 32: Result := 12;
    else
      Result := 1;
  end;
end;

end.
