unit MMSWF;

interface

uses
  Windows, Graphics, Classes, TntClasses, SysUtils,
  fe_flashplayer, fe_flashwnd, fe_flashole, fe_hook, fe_layer, fe_stream,
  fe_swfinfo;

type
  TMMSWF = class(TComponent)
  private
    feFlashPlayer: TfeFlashPlayer;
    FWidth, FHeight: Integer;
    FFrames: array of TBitmap;
    FSWFHeader: TSWFHeader;

    SWFDataStream: TMemoryStream;

    function GetWidth: Integer;
    procedure SetWidth(AWidth: Integer);
    function GetHeight: Integer;
    procedure SetHeight(AHeight: Integer);
    function GetFrame(Index: Integer): TBitmap;
    function GetFrameCount: Integer;
    function GetFrameRate: Integer;
    function GetSWFHeader: TSWFHeader;

    procedure FreeupCurrentFrames;
    procedure NormalizeBitmapToSingleColor(Bitmap: TBitmap; TransparentColor: TColor;
      BackgroundColor, ForegroundColor: TColor; Threshold: Integer);
    
    procedure DrawTransparentBmp(Cnv: TCanvas; x,y: Integer; Bmp: TBitmap;
      clTransparent: TColor);
  protected
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure LoadFromStream(const Stream: TStream);
    procedure LoadFromFile(const FileName: WideString);

    procedure ExtractFrames;
    procedure NormalizeFramesToSingleColor(BackgroundColor,
      ForegroundColor: TColor; Threshold: Integer);

    property Width: Integer read GetWidth write SetWidth;
    property Height: Integer read GetHeight write SetHeight;

    property Frames[Index: Integer]: TBitmap read GetFrame; default;
    property FrameCount: Integer read GetFrameCount;
    property FrameRate: Integer read GetFrameRate;
    property SWFHeader: TSWFHeader read GetSWFHeader;
  published
  end;

implementation

{ TMMSWF }

constructor TMMSWF.Create(AOwner: TComponent);
begin
  inherited;
  FWidth := 400;
  FHeight := 400;

  SWFDataStream := TMemoryStream.Create;
  
  feFlashPlayer := TfeFlashPlayer.Create(Self);
  feFlashPlayer.Transparent  := True;
  feFlashPlayer.Width := FWidth;
  feFlashPlayer.Height := FHeight;
end;

destructor TMMSWF.Destroy;
begin
  FreeupCurrentFrames;
  SWFDataStream.Free;
  feFlashPlayer.Free;
  inherited;
end;

procedure TMMSWF.ExtractFrames;
var
  i: Integer;
  b: TBitmap;
begin
  FreeupCurrentFrames;

  //GetSwfFileHeader(SWFDataStream, FSWFHeader);  --> SWF Header is read upon load
  SetLength(FFrames, FSWFHeader.FrameCount);

  feFlashPlayer.Width := FWidth;
  feFlashPlayer.Height := FHeight;
  feFlashPlayer.LoadMovieFromStream(0, SWFDataStream);
  feFlashPlayer.StopPlay;

  for i := 0 to FSWFHeader.FrameCount - 1 do
  begin
    feFlashPlayer.GotoFrame(i);
    b := feFlashPlayer.GrabCurrentFrame;
    //if b <> nil then
      FFrames[i] := b;
  end;
end;

procedure TMMSWF.FreeupCurrentFrames;
var
  i: Integer;
begin
  for i := Low(FFrames) to High(FFrames) do
  begin
    try
      FFrames[i].Free;
    except
    end;
  end;

  SetLength(FFrames, 0);
end;

function TMMSWF.GetFrame(Index: Integer): TBitmap;
begin
  //Index starting from 0 
  if (Index < 0) or (Index > High(FFrames)) then
  begin
    //List index out of bounds
    raise Exception.Create('Index out of bounds');
    Exit;
  end;
  Result := FFrames[Index];
end;

function TMMSWF.GetFrameCount: Integer;
begin
  Result := FSWFHeader.FrameCount;
end;

function TMMSWF.GetFrameRate: Integer;
begin
  Result := FSWFHeader.FrameRate;
end;

function TMMSWF.GetHeight: Integer;
begin
  Result := FHeight;
end;

function TMMSWF.GetSWFHeader: TSWFHeader;
begin
  Result := FSWFHeader;
end;

function TMMSWF.GetWidth: Integer;
begin
  Result := FWidth;
end;

procedure TMMSWF.LoadFromFile(const FileName: WideString);
var
  FStream: TTntFileStream;
begin
  FStream := TTntFileStream.Create(FileName, fmOpenRead);
  try
    LoadFromStream(FStream);
  finally
    FStream.Free;
  end;
end;

procedure TMMSWF.LoadFromStream(const Stream: TStream);
begin
  SWFDataStream.LoadFromStream(Stream);
  GetSwfFileHeader(SWFDataStream, FSWFHeader);
end;

procedure TMMSWF.NormalizeBitmapToSingleColor(Bitmap: TBitmap; TransparentColor: TColor;
  BackgroundColor, ForegroundColor: TColor; Threshold: Integer);

  function IsColorInGoodRange(AColor: TColor; RRange, GRange, BRange: Integer): Boolean;
  var
    R, G, B: Byte;
    Color: Longint;
  begin
    Color := ColorToRGB(AColor);
    R := Color;
    G := Color shr 8;
    B := Color shr 16;

    Result := (R <= RRange) and (G <= GRange) and (B >= BRange);
    {
    Result := (R >= RMin) and (R <= RMax) and
              (G >= GMin) and (G <= GMax) and
              (B >= BMin) and (B <= BMax);
    }
  end;

var
  B1: TBitmap;
  B2: TBitmap;
  X, Y: Integer;
begin
  B1 := TBitmap.Create;
  B1.Assign(Bitmap);
  B2 := TBitmap.Create;
  B2.Width := B1.Width;
  B2.Height := B1.Height;
  DrawTransparentBmp(B2.Canvas, 0, 0, B1, TransparentColor);
  for X := 0 to B2.Width - 1 do
    for Y := 0 to B2.Height - 1 do
    begin
      if IsColorInGoodRange(B2.Canvas.Pixels[X, Y], 20, 20, Threshold) then
        B2.Canvas.Pixels[X, Y] := ForegroundColor
      else
        B2.Canvas.Pixels[X, Y] := BackgroundColor;
      {
      if B2.Canvas.Pixels[X, Y] = clWhite then
        B2.Canvas.Pixels[X, Y] := BackgroundColor
      else
        B2.Canvas.Pixels[X, Y] := ForegroundColor;
      }
    end;
  Bitmap.Assign(B2);
  B2.Free;
  B1.Free;
end;

procedure doit(b1: TBitmap; Bf: TBitmap);
begin
  bf.Assign(b1);
end;

procedure TMMSWF.NormalizeFramesToSingleColor(BackgroundColor,
  ForegroundColor: TColor; Threshold: Integer);
var
  FrameIndex: Integer;
  TransparentColor: TColor;
begin
  if Length(FFrames) <= 0 then
    Exit;

    //Left-Bottom pixel color is the transparent color
  TransparentColor := clBlack;//Always black  -- Don't use FFrames[0].Canvas.Pixels[0, FFrames[0].Height - 1];
  for FrameIndex := Low(FFrames) to High(FFrames) do
  begin
    NormalizeBitmapToSingleColor(FFrames[FrameIndex], TransparentColor, BackgroundColor, ForegroundColor, Threshold);
  end;
end;

procedure TMMSWF.SetHeight(AHeight: Integer);
begin
  FHeight := AHeight;
end;

procedure TMMSWF.SetWidth(AWidth: Integer);
begin
  FWidth := AWidth;
end;

procedure TMMSWF.DrawTransparentBmp(Cnv: TCanvas; x,y: Integer; Bmp: TBitmap;
  clTransparent: TColor);
var
  bmpXOR, bmpAND, bmpINVAND, bmpTarget: TBitmap;
  oldcol: Longint;
begin
  //This procedure is originally from delphi3000.com:
  //  http://www.delphi3000.com/articles/article_485.asp?SK=
  try
    bmpAND := TBitmap.Create;
    bmpAND.Width := Bmp.Width;
    bmpAND.Height := Bmp.Height;
    bmpAND.Monochrome := True;
    oldcol := SetBkColor(Bmp.Canvas.Handle, ColorToRGB(clTransparent));
    BitBlt(bmpAND.Canvas.Handle, 0,0,Bmp.Width,Bmp.Height, Bmp.Canvas.Handle,
           0,0, SRCCOPY);
    SetBkColor(Bmp.Canvas.Handle, oldcol);

    bmpINVAND := TBitmap.Create;
    bmpINVAND.Width := Bmp.Width;
    bmpINVAND.Height := Bmp.Height;
    bmpINVAND.Monochrome := True;
    BitBlt(bmpINVAND.Canvas.Handle, 0,0,Bmp.Width,Bmp.Height,
           bmpAND.Canvas.Handle, 0,0, NOTSRCCOPY);

    bmpXOR := TBitmap.Create;
    bmpXOR.Width := Bmp.Width;
    bmpXOR.Height := Bmp.Height;
    BitBlt(bmpXOR.Canvas.Handle, 0,0,Bmp.Width,Bmp.Height, Bmp.Canvas.Handle,
           0,0, SRCCOPY);
    BitBlt(bmpXOR.Canvas.Handle, 0,0,Bmp.Width,Bmp.Height,
           bmpINVAND.Canvas.Handle, 0,0, SRCAND);

    bmpTarget := TBitmap.Create;
    bmpTarget.Width := Bmp.Width;
    bmpTarget.Height := Bmp.Height;
    BitBlt(bmpTarget.Canvas.Handle, 0,0,Bmp.Width,Bmp.Height, Cnv.Handle, x,y,
           SRCCOPY);
    BitBlt(bmpTarget.Canvas.Handle, 0,0,Bmp.Width,Bmp.Height,
           bmpAND.Canvas.Handle, 0,0, SRCAND);
    BitBlt(bmpTarget.Canvas.Handle, 0,0,Bmp.Width,Bmp.Height,
           bmpXOR.Canvas.Handle, 0,0, SRCINVERT);
    BitBlt(Cnv.Handle, x,y,Bmp.Width,Bmp.Height, bmpTarget.Canvas.Handle, 0,0,
           SRCCOPY);
  finally
    bmpXOR.Free;
    bmpAND.Free;
    bmpINVAND.Free;
    bmpTarget.Free;
  end;
end;

end.
