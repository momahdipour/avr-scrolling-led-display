unit PreviewFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Buttons;

type
  TPreviewForm = class(TForm)
    BitBtn1: TBitBtn;
    Panel1: TPanel;
    Image1: TImage;
  private
    { Private declarations }
  public
    { Public declarations }
    procedure LoadBitmap(Bitmap: TBitmap);
  end;

var
  PreviewForm: TPreviewForm;

implementation

{$R *.dfm}

{ TPreviewForm }

procedure TPreviewForm.LoadBitmap(Bitmap: TBitmap);
begin
  Image1.Picture.Bitmap.Assign(Bitmap);
end;

end.
