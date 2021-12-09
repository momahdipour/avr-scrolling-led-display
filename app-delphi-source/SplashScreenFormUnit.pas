unit SplashScreenFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, TntForms, jpeg, ExtCtrls, sSkinProvider, StdCtrls, sLabel,
  sBevel, GIFImage, Buttons, PngSpeedButton;

const
  IMAGE_DELAY = 200;  //in milliseconds
  PICTURE_COUNT = 9;

  LOADING_MESSAGE = 'Loading';

type
  TSplashScreenForm = class(TTntForm)
    sSkinProvider1: TsSkinProvider;
    BackImage: TImage;
    Pic1: TImage;
    Pic2: TImage;
    sBevel1: TsBevel;
    Pic3: TImage;
    Pic5: TImage;
    sBevel2: TsBevel;
    Pic9: TImage;
    Pic6: TImage;
    Pic7: TImage;
    Pic8: TImage;
    TextGIFImage: TImage;
    LoadingLabel: TsLabel;
    Image3: TImage;
    Pic4: TPngSpeedButton;
    procedure TntFormCreate(Sender: TObject);
    procedure TntFormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
    Done: Boolean;

    Images: array[1..PICTURE_COUNT] of TControl;
    ImageIndex: Integer;
    LastTickCount: Cardinal;
    LastTickCount2: Cardinal;

    procedure UpdateImages;
  end;

var
  SplashScreenForm: TSplashScreenForm;

implementation

{$R *.dfm}

procedure TSplashScreenForm.TntFormCreate(Sender: TObject);
var
  i: Integer;
  GIFImage: TGIFImage;
  rs: TResourceStream;
begin
  Done := False;

  {$IFDEF NORMAL_MODEL}
  BackImage.Picture.Bitmap.LoadFromResourceName(HInstance, 'SPLASH_BACK_NORMAL');
  {$ENDIF}
  {$IFDEF FULL_BRIGHT}
  BackImage.Picture.Bitmap.LoadFromResourceName(HInstance, 'SPLASH_BACK_SUNLIGHT');
  {$ENDIF}

  LastTickCount := 0;
  LastTickCount2 := 0;

  for i := 1 to PICTURE_COUNT do
    Images[i] := Self.FindComponent('Pic' + IntToStr(i)) as TControl;
  ImageIndex := 0;

  {$IFDEF NORMAL_MODEL}
  rs := TResourceStream.Create(HInstance, 'SPLASH_GIF', 'GIF');
  {$ENDIF}
  {$IFDEF FULL_BRIGHT}
  rs := TResourceStream.Create(HInstance, 'SPLASH_GIF_SUNLIGHT', 'GIF');
  {$ENDIF}
  GIFImage := TGIFImage.Create;
  GIFImage.ThreadPriority := tpTimeCritical;
  GIFImage.LoadFromStream(rs);
  TextGIFImage.Picture.Graphic := GIFImage;
  //(TextGIFImage.Picture.Graphic as TGIFImage).DrawOptions := (TextGIFImage.Picture.Graphic as TGIFImage).DrawOptions + [goLoopContinously];
  GIFImage.Free;
  rs.Free;
end;

procedure TSplashScreenForm.UpdateImages;
var
  TimeElapsed: Cardinal;
begin
  if (GetTickCount - LastTickCount2) >= 600 then
  begin
    LoadingLabel.Tag := LoadingLabel.Tag + 1;
    if LoadingLabel.Tag > 3 then
      LoadingLabel.Tag := 0;
    LoadingLabel.Caption := LOADING_MESSAGE + StringOfChar('.', LoadingLabel.Tag);
    LastTickCount2 := GetTickCount;
  end;

  Application.ProcessMessages;
  TimeElapsed := GetTickCount - LastTickCount;
  if TimeElapsed < IMAGE_DELAY then
    Exit;

  LastTickCount := GetTickCount;
  Inc(ImageIndex);
  if ImageIndex <= High(Images) then
    Images[ImageIndex].Visible := True;
  Update;
  Done := ImageIndex >= High(Images);
end;

procedure TSplashScreenForm.TntFormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  CanClose := False;
end;

end.
