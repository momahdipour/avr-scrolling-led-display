unit DefaultPicturesFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, TntForms, sSkinProvider, StdCtrls, sLabel, ExtCtrls,
  TntStdCtrls, sGroupBox, sCheckBox, Buttons, TntButtons, sBitBtn, sListBox,
  TntSysUtils, SoundDialogs, ProcsUnit;

type
  TDefaultPicturesForm = class(TTntForm)
    sSkinProvider1: TsSkinProvider;
    PictureListGroupBox: TsGroupBox;
    PicturePreviewGroupBox: TsGroupBox;
    PicturePreviewImage: TImage;
    sLabel28: TsLabel;
    PictureWidthLabel: TsLabel;
    sLabel29: TsLabel;
    PictureHeightLabel: TsLabel;
    ScaleGroupBox: TsGroupBox;
    Image1: TImage;
    ScalePictureToAreaHeightCheck: TsCheckBox;
    sLabel1: TsLabel;
    DefaultPicturesList: TsListBox;
    OKBtn: TsBitBtn;
    CancelBtn: TsBitBtn;
    procedure OKBtnClick(Sender: TObject);
    procedure TntFormCreate(Sender: TObject);
    procedure DefaultPicturesListClick(Sender: TObject);
    procedure TntFormShow(Sender: TObject);
    procedure TntFormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure DefaultPicturesListDblClick(Sender: TObject);
    procedure ScalePictureToAreaHeightCheckClick(Sender: TObject);
    procedure CancelBtnClick(Sender: TObject);
  private
    { Private declarations }
    CancelBtnClicked: Boolean;
  public
    { Public declarations }
    SelectedPictureIndex: Integer;
    ActiveAreaWidth, ActiveAreaHeight: Integer;
  end;

var
  DefaultPicturesForm: TDefaultPicturesForm;

implementation

uses MainUnit;

{$R *.dfm}

procedure TDefaultPicturesForm.OKBtnClick(Sender: TObject);
begin
  SelectedPictureIndex := DefaultPicturesList.ItemIndex;
end;

procedure TDefaultPicturesForm.TntFormCreate(Sender: TObject);
var
  i: Integer;
begin
  DefaultPicturesList.Items.Clear;
  for i := 0 to High(MainForm.DefaultPictures) do
    DefaultPicturesList.Items.Insert(i, MainForm.DefaultPictures[i].Description);
end;

procedure TDefaultPicturesForm.DefaultPicturesListClick(Sender: TObject);

  procedure RestoreOldItemIndex;
  begin
    if (DefaultPicturesList.Tag <> DefaultPicturesList.ItemIndex) and
       (DefaultPicturesList.Tag < DefaultPicturesList.Items.Count) then
    begin
      DefaultPicturesList.ItemIndex := DefaultPicturesList.Tag;  //Restore old ItemIndex
      DefaultPicturesList.OnClick(DefaultPicturesList);
    end;
  end;

var
  FName: WideString;
begin
  if (DefaultPicturesList.Items.Count > 0) and
     (DefaultPicturesList.ItemIndex >= 0) then
  begin
    FName := MainForm.DefaultPictures[DefaultPicturesList.ItemIndex].FileName;
    if not WideFileExists(FName) then
    begin
      WideMessageDlgSound(Dyn_Texts[72] {'File of the selected picture cannot be found.'}, mtError, [mbOK], 0);
      RestoreOldItemIndex;
      Exit;
    end;

    try
      MainForm.WideLoadBitmapImageFormFile(FName, PicturePreviewImage.Picture.Bitmap);
      //PicturePreviewImage.Picture.Bitmap.LoadFromFile(FName);
    except
      WideMessageDlgSound(Dyn_Texts[73] {'Invalid picture file.'}, mtError, [mbOK], 0);
      PicturePreviewImage.Hide;
      RestoreOldItemIndex;
      Exit;
    end;

    PicturePreviewImage.Show;  //It may be hidden

    PicturePreviewImage.Stretch := True;

    PictureWidthLabel.Caption := IntToStr(PicturePreviewImage.Picture.Bitmap.Width);
    PictureHeightLabel.Caption := IntToStr(PicturePreviewImage.Picture.Bitmap.Height);
    //Only height of the area is checked in this version
    ScaleGroupBox.Visible := ActiveAreaHeight < PicturePreviewImage.Picture.Bitmap.Height;
    if Assigned(ScalePictureToAreaHeightCheck.OnClick) then  //Prevent potential software bugs
      ScalePictureToAreaHeightCheck.OnClick(ScalePictureToAreaHeightCheck);

    //DisplayStages[ActiveDisplayStage].Areas[ActiveAreaIndex].PictureAvailable := True;

    //DefaultPicturesCombo.Tag := DefaultPicturesCombo.ItemIndex;  //Store ItemIndex

    //DesignChangeFlag := True;

    //UpdatePicturePicturePreview;
  end;
end;

procedure TDefaultPicturesForm.TntFormShow(Sender: TObject);
begin
  CancelBtnClicked := False;
  OKBtn.Enabled := DefaultPicturesList.Items.Count > 0;
end;

procedure TDefaultPicturesForm.TntFormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  CanClose := CancelBtnClicked or
              (DefaultPicturesList.ItemIndex >= 0);
end;

procedure TDefaultPicturesForm.DefaultPicturesListDblClick(
  Sender: TObject);
begin
  if OKBtn.Enabled then
    OKBtn.Click;
end;

procedure TDefaultPicturesForm.ScalePictureToAreaHeightCheckClick(
  Sender: TObject);
begin
  if ScalePictureToAreaHeightCheck.Checked then
  begin
    Procs.TrimBitmapUnusedBorders(PicturePreviewImage.Picture.Bitmap);
    MainForm.ScaleBitmapToAreaHeight(PicturePreviewImage.Picture.Bitmap, ActiveAreaHeight);

    PictureWidthLabel.Caption := IntToStr(PicturePreviewImage.Picture.Bitmap.Width);
    PictureHeightLabel.Caption := IntToStr(PicturePreviewImage.Picture.Bitmap.Height);
  end
  else
  begin
    if Assigned(DefaultPicturesList.OnClick) then  //Prevent potential software bugs
    begin
      ScalePictureToAreaHeightCheck.OnClick := nil;
      DefaultPicturesList.OnClick(DefaultPicturesList);
      ScalePictureToAreaHeightCheck.OnClick := ScalePictureToAreaHeightCheckClick;
    end;
  end;
end;

procedure TDefaultPicturesForm.CancelBtnClick(Sender: TObject);
begin
  CancelBtnClicked := True;
end;

end.
