unit MMSWFHeaderReader;

interface

uses
  Windows, Classes, TntClasses, SysUtils;

type
  TMMSWFHeader = record
    IsCompressed: Boolean;
    ErrorSignature: Boolean;
    Version: Integer;
    Width: Cardinal;
    Height: Cardinal;
    FrameRate: Integer;
    FrameCount: Cardinal;
  end;

  TMMSWFHeaderReader = class(TComponent)
  private
    SWFData: TMemoryStream;

    procedure ParseSWFHeader();
    procedure ReadSignature;
    procedure ReadFileLength;
    procedure ReadFrameSize;
    procedure ReadFrameRate;
    procedure ReadFrameCount;

    function GetNextByte: Byte;
  protected
  public
    MMSWFHeader: TMMSWFHeader;

    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure LoadFromFile(const FileName: WideString);
    procedure LoadFromStream(Stream: TStream);
  published
  end;

implementation

{ TMMSWFHeaderReader }

constructor TMMSWFHeaderReader.Create(AOwner: TComponent);
begin
  inherited;
  SWFData := TMemoryStream.Create;
  SWFData.Clear;
end;

destructor TMMSWFHeaderReader.Destroy;
begin
  SWFData.Free;
  inherited;
end;

function TMMSWFHeaderReader.GetNextByte: Byte;
var
  Buf: array[1..1] of Byte;
begin
  if SWFData.Read(Buf, 1) = 0 then
    raise Exception.Create('SWF Header Reader: Reached end of file');
  Result := Buf[1];
  //MemoryStream position is automatically increased by the number of bytes read from it
end;

procedure TMMSWFHeaderReader.LoadFromFile(const FileName: WideString);
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

procedure TMMSWFHeaderReader.LoadFromStream(Stream: TStream);
begin
  SWFData.LoadFromStream(Stream);
  SWFData.Position := 0;
  ParseSWFHeader;
end;

procedure TMMSWFHeaderReader.ParseSWFHeader;
begin
  ReadSignature;
  MMSWFHeader.Version := GetNextByte;
  ReadFileLength;
  ReadFrameSize;
  ReadFrameRate;
  ReadFrameCount;
end;

procedure TMMSWFHeaderReader.ReadFileLength;
begin
  //Read Size
  GetNextByte;
  GetNextByte;
  GetNextByte;
  GetNextByte;
end;

procedure TMMSWFHeaderReader.ReadFrameCount;
var
  i: Integer;
begin
  for i := 0 to 1 do
  begin
    MMSWFHeader.FrameCount := MMSWFHeader.FrameCount + (Cardinal(GetNextByte) shl (8 * i)); 
  end;
end;

procedure TMMSWFHeaderReader.ReadFrameRate;
var
  fps_decimal, fps_int: Byte;
begin
  fps_decimal := GetNextByte;
  fps_int := GetNextByte;
  MMSWFHeader.FrameRate := fps_int + Trunc(fps_decimal / 100);
end;

procedure TMMSWFHeaderReader.ReadFrameSize;
var
  cByte: Cardinal;
  NbBits: Cardinal;
  CurrentBit: Integer;
  CurrentValue: Cardinal;
  NumField: Integer;
  BitCount: Integer;
begin
  cByte := GetNextByte;
  NbBits := cByte shr 3;

  cByte := cByte and 7;
  cByte := cByte shl 5;

  CurrentBit := 2;

  // Must get all 4 values in the RECT
  for NumField := 0 to 3 do
  begin
    CurrentValue := 0;
    BitCount := 0;
    while BitCount < NbBits do
    begin
      if (cByte and 128) = 128 then
        CurrentValue := CurrentValue + (Cardinal(1) shl (NbBits - BitCount - 1));

      cByte := cByte shl 1;
      cByte := cByte and 255;
      Dec(CurrentBit);
      Inc(BitCount);
      // We will be needing a new byte if we run out of bits
      if CurrentBit < 0 then
      begin
        cByte := GetNextByte;
        CurrentBit := 7;
      end;
    end;

    // TWIPS to PIXELS
    CurrentValue := Trunc(CurrentValue / 20);
    case NumField of
      0: MMSWFHeader.Width := CurrentValue;
      1: MMSWFHeader.Width := CurrentValue - MMSWFHeader.Width;
      2: MMSWFHeader.Height := CurrentValue;
      3: MMSWFHeader.Height := CurrentValue - MMSWFHeader.Height;
    end;
  end;
end;

procedure TMMSWFHeaderReader.ReadSignature;
var
  ReadingByte: Byte;
begin
  ReadingByte := GetNextByte;
  if Char(ReadingByte) = 'C' then
    MMSWFHeader.IsCompressed := True;  //Not supported
  if (Char(ReadingByte) <> 'F') and (Char(ReadingByte) <> 'C') then
    MMSWFHeader.ErrorSignature := True;

  if Char(GetNextByte) <> 'W' then MMSWFHeader.ErrorSignature := True;
  if Char(GetNextByte) <> 'S' then MMSWFHeader.ErrorSignature := True;
end;

end.
