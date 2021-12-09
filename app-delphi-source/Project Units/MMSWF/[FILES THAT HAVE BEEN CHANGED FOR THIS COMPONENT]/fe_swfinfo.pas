unit fe_swfinfo;

interface

uses
  SysUtils, Classes, fe_compress;

type
  TBitWidth = 1..32;

  TSWFRect = packed record
    Xmin: integer;  // in twips
    Xmax: integer;  // in twips
    Ymin: integer;  // in twips
    Ymax: integer;  // in twips
  end;

  TSWFHeader = packed record
    Signature: array [0..2] of char;
    Version: byte;
    FileLength: cardinal;
    FrameSize: TSWFRect;
    FrameRate: byte;
    FrameRateRemainder: byte;
    FrameCount: cardinal;
  end;

  function GetSwfFileHeader(const FileName: String; var Header: TSWFHeader): boolean; overload;
  function GetSwfFileHeader(const Stream: TStream; var Header: TSWFHeader): boolean; overload;

implementation

function ReadNBits(const Buffer; Position: longint; Count: TBitWidth): longint;
var
  I, B: longint;
begin
  Result:= 0;
  B:= 1 shl (Count-1);
  for I:= Position to Position+Count-1 do
  begin
    if (PByteArray(@Buffer)^[I div 8] and (128 shr (I mod 8)) ) <> 0 then
      Result:= Result or B;
    B:= B shr 1;
  end;
end;

function GetSwfFileHeader(const Stream: TStream; var Header: TSWFHeader): boolean;
const
  BuffSize = 25;
var
  Buffer: PByteArray;
  NBitsField: byte;
  Poz: longword;
  MemStream: TMemoryStream;
  ZStream: TDecompressionStream;
begin
  try
    Stream.Position:= 0;
    if Stream.Size > 22 then
    begin
      GetMem(Buffer, BuffSize);
      try
        Stream.Read(Header, 8);
        if(Header.Signature = 'CWS') and (Header.Version >= 6) then
        begin
          Result:= TRUE;
          MemStream:= TMemoryStream.Create;
          try
            MemStream.CopyFrom(Stream, Stream.Size-8);
            MemStream.Position:= 0;
            ZStream:= TDecompressionStream.Create(MemStream);
            try
              ZStream.Read(Buffer^, BuffSize);
            finally
              ZStream.Free;
            end;
          finally
            MemStream.Free;
          end;
        end
          else begin
            Stream.Read(Buffer^, BuffSize);
            Result:= Header.Signature = 'FWS';
          end;

          if Result then
            with Header do
            begin
              Poz:= 0;
              NBitsField:= TBitWidth(ReadNBits(Buffer^, Poz, 5)); Inc(Poz, 5);
              FrameSize.Xmin:= Integer(ReadNBits(Buffer^, Poz, NBitsField)); Inc(Poz,
NBitsField);
              FrameSize.Xmax:= Integer(ReadNBits(Buffer^, Poz, NBitsField)); Inc(Poz,
NBitsField);
              FrameSize.Ymin:= Integer(ReadNBits(Buffer^, Poz, NBitsField)); Inc(Poz,
NBitsField);
              FrameSize.Ymax:= Integer(ReadNBits(Buffer^, Poz, NBitsField)); Inc(Poz,
NBitsField);
              NBitsField:= Poz mod 8;
              Poz:= Poz div 8;
              if (NBitsField > 0) then Inc(Poz);
              FrameRateRemainder:= Buffer^[Poz]; // 8.[8]
              FrameRate:= Buffer^[Poz+1];
              FrameCount:= Buffer^[Poz+2] or (Buffer^[Poz+3] shl 8);
            end;

       finally
         FreeMem(Buffer);
       end;
    end;
  finally
  end;
end;

function GetSwfFileHeader(const FileName: string; var Header: TSWFHeader): boolean;
var
  FileStream: TFileStream;
begin
  Result:= FALSE;
  if not FileExists(FileName) then Exit;
  FileStream:= TFileStream.Create(FileName, fmOpenRead);
  try
    Result := GetSwfFileHeader(FileStream, Header);
  finally
    FileStream.Free;
  end;
end;

end.