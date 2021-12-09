unit SelectNormalEffectFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, TntForms, StdCtrls, Buttons, TntButtons, sBitBtn, sSkinProvider,
  ExtCtrls, TntExtCtrls, sPanel, GIFImage, TntStdCtrls, sGroupBox,
  ComCtrls, sTrackBar, sLabel, GlobalTypes;

type
  TSelectNormalEffectForm = class(TTntForm)
    sSkinProvider1: TsSkinProvider;
    CancelBtn: TsBitBtn;
    VerticalPanel: TsPanel;
    sGroupBox1: TsGroupBox;
    Effect1Image: TImage;
    sGroupBox3: TsGroupBox;
    Effect2Image: TImage;
    sGroupBox4: TsGroupBox;
    Effect3Image: TImage;
    sGroupBox5: TsGroupBox;
    Effect4Image: TImage;
    sGroupBox6: TsGroupBox;
    Effect5Image: TImage;
    sGroupBox7: TsGroupBox;
    Effect6Image: TImage;
    sGroupBox8: TsGroupBox;
    Effect7Image: TImage;
    sGroupBox2: TsGroupBox;
    Effect9Image: TImage;
    sGroupBox9: TsGroupBox;
    Effect10Image: TImage;
    sGroupBox10: TsGroupBox;
    Effect11Image: TImage;
    sGroupBox11: TsGroupBox;
    Effect12Image: TImage;
    sGroupBox12: TsGroupBox;
    Effect13Image: TImage;
    sGroupBox13: TsGroupBox;
    Effect14Image: TImage;
    sGroupBox14: TsGroupBox;
    Effect15Image: TImage;
    sGroupBox15: TsGroupBox;
    Effect8Image: TImage;
    sGroupBox16: TsGroupBox;
    Effect16Image: TImage;
    SelectionPanel: TsPanel;
    FinalSelectionPanel: TsPanel;
    OKBtn: TsBitBtn;
    TextMovementGroupBox: TsGroupBox;
    sLabel14: TsLabel;
    sLabel16: TsLabel;
    NormalEffectsSpeedTrackbar: TsTrackBar;
    sLabel15: TsLabel;
    HighGUITimer: TTimer;
    procedure Effect1ImageMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Effect1ImageClick(Sender: TObject);
    procedure TntFormShow(Sender: TObject);
    procedure NormalEffectsSpeedTrackbarChange(Sender: TObject);
    procedure Effect1ImageDblClick(Sender: TObject);
    procedure HighGUITimerTimer(Sender: TObject);
    procedure TntFormCreate(Sender: TObject);
    procedure TntFormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    HighGUIItems: THighGUIItems;

    procedure LoadImages;
    procedure SetAnimationSpeed(AnimationSpeed: Integer);

    procedure HighGUIInitialize;
  public
    { Public declarations }
    SelectedEffect: Integer;
    AnimSpeed: Integer;

    procedure Prepare;
  end;

var
  SelectNormalEffectForm: TSelectNormalEffectForm;

implementation

uses MainUnit;

{$R *.dfm}

{ TSelectNormalEffectForm }

procedure TSelectNormalEffectForm.LoadImages;
var
  rs: TResourceStream;
  GIFImage: TGIFImage;
  i: Integer;
begin
  try
    //Load GIF Image from the resources
    GIFImage := TGIFImage.Create;
    for i := 1 to NORMAL_EFFECTS_COUNT do
    begin
      rs := TResourceStream.Create(HInstance, 'EFFECT_' + IntToStr(i) + '_GIF', 'GIF');
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

procedure TSelectNormalEffectForm.Effect1ImageMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  //SelectionPanel.Left := (Sender as TControl).Parent.Left - 10;
  //SelectionPanel.Top := (Sender as TControl).Parent.Top - 10;
end;

procedure TSelectNormalEffectForm.Effect1ImageClick(Sender: TObject);
begin
  SelectedEffect := (Sender as TControl).Tag;
  FinalSelectionPanel.Left := (Sender as TControl).Parent.Left - 10;
  FinalSelectionPanel.Top := (Sender as TControl).Parent.Top - 10;
  //ModalResult := mrOk;
end;

procedure TSelectNormalEffectForm.Prepare;
begin
  //Nothing to do
  //Selection of current effect is done in OnShow event
end;

procedure TSelectNormalEffectForm.TntFormShow(Sender: TObject);
var
  EffectToSelect: Integer;
  Image: TComponent;
begin
  HighGUITimer.Enabled := True;

  LoadImages;  //Load every time the form is being opened to restart GIF preview

  if (SelectedEffect = 0) or (SelectedEffect > 16) then
    EffectToSelect := 1
  else
    EffectToSelect := SelectedEffect;

  Image := Self.FindComponent('Effect' + IntToStr(EffectToSelect) + 'Image');
  if Assigned(Image) then
  begin
    //(Image as TImage).OnMouseMove(Image, [], 0, 0);
    (Image as TImage).OnClick(Image);
  end;

  NormalEffectsSpeedTrackbar.Position := 255 - AnimSpeed;
  if Assigned(NormalEffectsSpeedTrackbar.OnChange) then  //Prevent potential software bugs
    NormalEffectsSpeedTrackbar.OnChange(NormalEffectsSpeedTrackbar);  //Force update
end;

procedure TSelectNormalEffectForm.SetAnimationSpeed(
  AnimationSpeed: Integer);
var
  i: Integer;
begin
  for i := 1 to NORMAL_EFFECTS_COUNT do
  begin
    with Self.FindComponent('Effect' + IntToStr(i) + 'Image') as TImage do
    begin
      if Picture.Graphic is TGIFImage then
        (Picture.Graphic as TGIFImage).AnimationSpeed := AnimationSpeed;
    end;
  end;
end;

procedure TSelectNormalEffectForm.NormalEffectsSpeedTrackbarChange(
  Sender: TObject);
begin
  AnimSpeed := 255 - NormalEffectsSpeedTrackbar.Position;
  SetAnimationSpeed(MainForm.AnimSpeedToGIFAnimationSpeed(AnimSpeed));
end;

procedure TSelectNormalEffectForm.Effect1ImageDblClick(Sender: TObject);
begin
  OKBtn.Click;
end;

procedure TSelectNormalEffectForm.HighGUITimerTimer(Sender: TObject);
begin
  HighGUITimer.Enabled := False;
  if HighGUITimer.Tag = 0 then
    Exit;
  try
    MainForm.HighGUIUpdateState(Self, HighGUITimer, HighGUIItems);
  finally
    HighGUITimer.Enabled := HighGUITimer.Tag = 1;
  end;
end;

procedure TSelectNormalEffectForm.TntFormCreate(Sender: TObject);
begin
  HighGUIInitialize;
end;

procedure TSelectNormalEffectForm.TntFormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  HighGUITimer.Enabled := False;
end;

procedure TSelectNormalEffectForm.HighGUIInitialize;
begin
  SetLength(HighGUIItems, 1);

  HighGUIItems[0] := TextMovementGroupBox;
end;

end.
