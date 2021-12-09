unit AboutFormUnit;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls, ShellAPI, TntStdCtrls, ProcsUnit,
  TntForms, sSkinProvider, ProgramConsts, sLabel, sButton, TntButtons,
  sBitBtn, CapabilitiesFormUnit, Dialogs, CreateSupportFileFormUnit,
  SoundDialogs, BiDiSoundDialogs;

type
  TAboutForm = class(TTntForm)
    Panel1: TPanel;
    ProgramIcon: TImage;
    RegistrationInfoGroup: TGroupBox;
    LicenseStatusLabel: TsLabel;
    InfoMemo: TTntMemo;
    Bevel2: TBevel;
    Label6: TLabel;
    SoftwareVersionLabel: TsLabel;
    SoftwareNameImage: TImage;
    sSkinProvider1: TsSkinProvider;
    FarsiInfoMemo: TTntMemo;
    SoftwareNameLabel: TsLabel;
    OKBtn: TsButton;
    ShowCapabilitiesBtn: TsBitBtn;
    Panel2: TPanel;
    Label7: TLabel;
    MailLabel: TLabel;
    Label4: TsLabel;
    Label3: TLabel;
    Label5: TLabel;
    Bevel1: TBevel;
    sLabel1: TsLabel;
    sLabel4: TsLabel;
    Label8: TLabel;
    Bevel3: TBevel;
    Label1: TsLabel;
    sLabel3: TsLabel;
    HowToBuyBtn: TsBitBtn;
    CompanyImage: TImage;
    sLabel2: TsLabel;
    sLabel5: TsLabel;
    sLabel36: TsLabel;
    sLabel6: TsLabel;
    CreateSupportFileBtn: TsBitBtn;
    procedure Label1Click(Sender: TObject);
    procedure Label4MouseEnter(Sender: TObject);
    procedure Label4MouseLeave(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure TntFormCreate(Sender: TObject);
    procedure InfoMemoKeyPress(Sender: TObject; var Key: Char);
    procedure sSkinProvider1SkinItem(Item: TComponent;
      var CanBeAdded: Boolean; var SkinSection: String);
    procedure sLabel1Click(Sender: TObject);
    procedure sLabel2Click(Sender: TObject);
    procedure Label4Click(Sender: TObject);
    procedure HowToBuyBtnClick(Sender: TObject);
    procedure sLabel3Click(Sender: TObject);
    procedure sLabel4Click(Sender: TObject);
    procedure ShowCapabilitiesBtnClick(Sender: TObject);
    procedure CreateSupportFileBtnClick(Sender: TObject);
    procedure TntFormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
    procedure LoadCustomCompanyImage;
  public
    { Public declarations }
  end;

var
  AboutForm: TAboutForm;

implementation

uses
  MainUnit, StrUtils, HowToBuyFormUnit;

{$R *.dfm}

procedure TAboutForm.Label1Click(Sender: TObject);
begin
  Procs.OpenUrlInDefaultBrowser(SOFTWARE_HOME_PAGE_OLD);
end;

procedure TAboutForm.Label4MouseEnter(Sender: TObject);
begin
  (Sender as TsLabel).Caption := 'mailto: mo.mahdipour@gmail.com';
end;

procedure TAboutForm.Label4MouseLeave(Sender: TObject);
begin
  (Sender as TsLabel).Caption := 'Direct Contact';
end;

procedure TAboutForm.FormShow(Sender: TObject);
begin
  InfoMemo.SelLength := 0;
  OKBtn.SetFocus;

  //License
  LicenseStatusLabel.Caption := 'Registered';
  LicenseStatusLabel.Font.Color := clWindowText;
  LicenseStatusLabel.Font.Style := [];
end;

procedure TAboutForm.TntFormCreate(Sender: TObject);
var
  ExeVersion: String;
begin
  SoftwareNameLabel.Caption := SOFTWARE_NAME;
  SoftwareVersionLabel.Caption := MAJOR_VERSION_NUMBER_STR + '.' + MINOR_VERSION_NUMBER_STR;
  InfoMemo.Lines[0] := SoftwareNameLabel.Caption;
  InfoMemo.Lines[1] := SoftwareVersionLabel.Caption;
  {$IFDEF NORMAL_MODEL}
  SoftwareNameImage.Picture.Bitmap.LoadFromResourceName(HInstance, 'SOFTWARE_NAME_NORMAL');
  FarsiInfoMemo.Visible := True;
  {$ENDIF}
  {$IFDEF FULL_BRIGHT}
  SoftwareNameImage.Picture.Bitmap.LoadFromResourceName(HInstance, 'SOFTWARE_NAME_SUNLIGHT');
  FarsiInfoMemo.Visible := False;
  {$ENDIF}
  ExeVersion := Procs.GetFileVersionString(Application.ExeName);
  if ExeVersion <> EmptyStr then
    InfoMemo.Lines[1] := InfoMemo.Lines[1] + ' (Internal File Version: ' + ExeVersion + ')';
  //ProgramIcon.Picture.Graphic.Assign(Application.Icon);
  LoadCustomCompanyImage;
end;

procedure TAboutForm.InfoMemoKeyPress(Sender: TObject; var Key: Char);
begin
  if (Ord(Key) = VK_RETURN) or
     (Ord(Key) = VK_ESCAPE) then
    OKBtn.Click;
end;

procedure TAboutForm.sSkinProvider1SkinItem(Item: TComponent;
  var CanBeAdded: Boolean; var SkinSection: String);
begin
  CanBeAdded := (Item <> InfoMemo) and
                (Item <> Label5) and
                (Item <> Label6) and
                (Item <> Bevel1) and
                (Item <> Bevel2) and
                (Item <> FarsiInfoMemo) and
                (Item <> SoftwareNameLabel);
end;

procedure TAboutForm.sLabel1Click(Sender: TObject);
begin
  Procs.OpenUrlInDefaultBrowser('mailto:info@lcddesigner.com');
end;

procedure TAboutForm.sLabel2Click(Sender: TObject);
begin
  Procs.OpenUrlInDefaultBrowser('mailto:noorsun.electronic@yahoo.com');
end;

procedure TAboutForm.Label4Click(Sender: TObject);
begin
  Procs.OpenUrlInDefaultBrowser('mailto: mo.mahdipour@gmail.com');
end;

procedure TAboutForm.HowToBuyBtnClick(Sender: TObject);
begin
  HowToBuyForm := THowToBuyForm.Create(nil);
  try
    HowToBuyForm.ShowModal;
  finally
    HowToBuyForm.Free;
  end;
end;

procedure TAboutForm.sLabel3Click(Sender: TObject);
begin
  Procs.OpenUrlInDefaultBrowser(SOFTWARE_HOME_PAGE_NEW);
end;

procedure TAboutForm.sLabel4Click(Sender: TObject);
begin
  Procs.OpenUrlInDefaultBrowser('mailto:info@noorsun-em.com');
end;

procedure TAboutForm.ShowCapabilitiesBtnClick(Sender: TObject);
begin
  CapabilitiesForm.ShowModal;
end;

procedure TAboutForm.LoadCustomCompanyImage;
var
  Image: TBitmap;
begin
  //Load company Image
  if FileExists(ApplicationPath + COMPANY_IMAGE_FILENAME) then
  begin
    Image := TBitmap.Create;
    try
      try
        Image.LoadFromFile(ApplicationPath + COMPANY_IMAGE_FILENAME);
        CompanyImage.Picture.Bitmap.Assign(Image);
      except
      end;
    except
      Image.Free;
    end;
  end;
end;

procedure TAboutForm.CreateSupportFileBtnClick(Sender: TObject);
begin
  Application.CreateForm(TCreateSupportFileForm, CreateSupportFileForm);
  try
    CreateSupportFileForm.ShowModal;
  finally
    CreateSupportFileForm.Free;
  end;
end;

procedure TAboutForm.TntFormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_F6) and (Shift = [ssAlt, ssShift, ssCtrl]) then
    MessageDlgBiDiSoundTop('This is a product of Modern Noorsun Electronics.' +
        #13 +
        #13 + 'To buy this software call to 09127425583 (Mortaza Ghaffari)' +
        #13 + '   OR email to noorsun.electronic@yahoo.com.' +
        #13 +
        #13 + 'Programmer: Mohammad Mahdipour (mo.mahdipour@gmail.com)',
        mtInformation, [mbOK], 0, bdLeftToRight);
end;

end.

