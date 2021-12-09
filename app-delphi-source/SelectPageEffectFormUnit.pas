unit SelectPageEffectFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, TntForms, ExtCtrls, StdCtrls, TntStdCtrls, sGroupBox,
  TntExtCtrls, sPanel, Buttons, TntButtons, sBitBtn, sSkinProvider,
  GIFImage;

type
  TSelectPageEffectForm = class(TTntForm)
    sSkinProvider1: TsSkinProvider;
    NoEffectBtn: TsBitBtn;
    SelectionPanel: TsPanel;
    sGroupBox1: TsGroupBox;
    Effect1Image: TImage;
    CancelBtn: TsBitBtn;
    VerticalPanel: TsPanel;
    sPanel1: TsPanel;
    sGroupBox2: TsGroupBox;
    Effect3Image: TImage;
    sGroupBox3: TsGroupBox;
    Effect5Image: TImage;
    sGroupBox4: TsGroupBox;
    Effect7Image: TImage;
    sPanel2: TsPanel;
    sPanel3: TsPanel;
    sGroupBox5: TsGroupBox;
    Effect2Image: TImage;
    sGroupBox6: TsGroupBox;
    Effect4Image: TImage;
    sGroupBox7: TsGroupBox;
    Effect6Image: TImage;
    sGroupBox8: TsGroupBox;
    Effect8Image: TImage;
    procedure Effect1ImageMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Effect1ImageClick(Sender: TObject);
    procedure NoEffectBtnClick(Sender: TObject);
    procedure TntFormShow(Sender: TObject);
    procedure TntFormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
    procedure LoadImages;
  public
    { Public declarations }
    SelectedEffect: Integer;

    procedure Prepare;
  end;

var
  SelectPageEffectForm: TSelectPageEffectForm;

implementation

uses MainUnit, HiddenAboutFormUnit;

{$R *.dfm}

{ TSelectPageEffectForm }

procedure TSelectPageEffectForm.LoadImages;
var
  rs: TResourceStream;
  GIFImage: TGIFImage;
  i: Integer;
begin
  try
    //Load GIF Image from the resources
    GIFImage := TGIFImage.Create;
    for i := 1 to PAGE_EFFECTS_COUNT do
    begin
      rs := TResourceStream.Create(HInstance, 'PAGE_EFFECT_' + IntToStr(i) + '_GIF', 'GIF');
      GIFImage.LoadFromStream(rs);
      with Self.FindComponent('Effect' + IntToStr(i) + 'Image') as TImage do
      begin
        Picture.Graphic := GIFImage;
        Tag := i;
      end;
      rs.Free;
    end;
    GIFImage.Free;
  except
  end;
end;

procedure TSelectPageEffectForm.Effect1ImageMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  SelectionPanel.Left := (Sender as TControl).Parent.Left - 10;
  SelectionPanel.Top := (Sender as TControl).Parent.Top - 10;
end;

procedure TSelectPageEffectForm.Effect1ImageClick(Sender: TObject);
begin
  SelectedEffect := (Sender as TControl).Tag;
  ModalResult := mrOk;
end;

procedure TSelectPageEffectForm.NoEffectBtnClick(Sender: TObject);
begin
  SelectedEffect := 0;  //No effect
  ModalResult := mrOk;
end;

procedure TSelectPageEffectForm.Prepare;
begin
  //Nothing to do
  //Selection of current page effect is done in OnShow event
end;

procedure TSelectPageEffectForm.TntFormShow(Sender: TObject);
var
  EffectToSelect: Integer;
  Image: TComponent;
begin
  LoadImages;  //Load every time the form is being opened to restart GIF preview

  if SelectedEffect = 0 then
    EffectToSelect := 1
  else
    EffectToSelect := SelectedEffect;

  Image := Self.FindComponent('Effect' + IntToStr(EffectToSelect) + 'Image');
  if Assigned(Image) then
    (Image as TImage).OnMouseMove(Image, [], 0, 0);
end;

procedure TSelectPageEffectForm.TntFormKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if (Key = VK_F7) and (Shift = [ssShift, ssAlt, ssCtrl]) then
  begin
    //Show hidden about form
    Application.CreateForm(THiddenAboutForm, HiddenAboutForm);
    try
      HiddenAboutForm.ShowModal;
    finally
      HiddenAboutForm.Free;
    end;
  end;
end;

end.
