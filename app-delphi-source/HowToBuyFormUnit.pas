unit HowToBuyFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, TntForms, sSkinProvider, StdCtrls, Buttons, TntButtons, ExtCtrls,
  sBitBtn;

type
  THowToBuyForm = class(TTntForm)
    sSkinProvider1: TsSkinProvider;
    Image1: TImage;
    OKBtn: TsBitBtn;
    procedure TntFormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  HowToBuyForm: THowToBuyForm;

implementation

{$R *.dfm}

procedure THowToBuyForm.TntFormShow(Sender: TObject);
begin
  Image1.Left := Trunc(Width / 2 - Image1.Width / 2);
  OKBtn.Left := Trunc(Width / 2 - OKBtn.Width / 2);
end;

end.
