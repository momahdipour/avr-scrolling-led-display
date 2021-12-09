unit HiddenAboutFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, TntForms, sSkinProvider, Buttons, TntButtons, sBitBtn, StdCtrls,
  TntStdCtrls, sButton, ExtCtrls, sLabel, ProcsUnit, ProgramConsts;

type
  THiddenAboutForm = class(TTntForm)
    Panel1: TPanel;
    ProgramIcon: TImage;
    Label1: TsLabel;
    Bevel1: TBevel;
    Label5: TLabel;
    Label3: TLabel;
    MailLabel: TLabel;
    Bevel2: TBevel;
    Label6: TLabel;
    Label4: TsLabel;
    Label7: TLabel;
    Label10: TsLabel;
    Image1: TImage;
    Label2: TsLabel;
    sLabel1: TsLabel;
    Bevel3: TBevel;
    Label8: TLabel;
    sLabel2: TsLabel;
    Image2: TImage;
    sLabel3: TsLabel;
    sLabel4: TsLabel;
    RegistrationInfoGroup: TGroupBox;
    LicenseStatusLabel: TsLabel;
    InfoMemo: TTntMemo;
    FarsiInfoMemo: TTntMemo;
    OKBtn: TsButton;
    HowToBuyBtn: TsBitBtn;
    ShowCapabilitiesBtn: TsBitBtn;
    sSkinProvider1: TsSkinProvider;
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
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  HiddenAboutForm: THiddenAboutForm;

implementation

uses
  MainUnit, StrUtils, HowToBuyFormUnit, CapabilitiesFormUnit;

{$R *.dfm}

procedure THiddenAboutForm.Label1Click(Sender: TObject);
begin
  Procs.OpenUrlInDefaultBrowser(SOFTWARE_HOME_PAGE_OLD);
end;

procedure THiddenAboutForm.Label4MouseEnter(Sender: TObject);
begin
  (Sender as TsLabel).Caption := 'mailto: mo.mahdipour@gmail.com';
end;

procedure THiddenAboutForm.Label4MouseLeave(Sender: TObject);
begin
  (Sender as TsLabel).Caption := 'Direct Contact';
end;

procedure THiddenAboutForm.FormShow(Sender: TObject);
begin
  InfoMemo.SelLength := 0;
  OKBtn.SetFocus;

  //License
  LicenseStatusLabel.Caption := 'Registered';
  LicenseStatusLabel.Font.Color := clWindowText;
  LicenseStatusLabel.Font.Style := [];
end;

procedure THiddenAboutForm.TntFormCreate(Sender: TObject);
var
  ExeVersion: String;
begin
  ExeVersion := Procs.GetFileVersionString(Application.ExeName);
  if ExeVersion <> EmptyStr then
    InfoMemo.Lines[1] := InfoMemo.Lines[1] + ' (' + ExeVersion + ')';
  //ProgramIcon.Picture.Graphic.Assign(Application.Icon);
end;

procedure THiddenAboutForm.InfoMemoKeyPress(Sender: TObject; var Key: Char);
begin
  if (Ord(Key) = VK_RETURN) or
     (Ord(Key) = VK_ESCAPE) then
    OKBtn.Click;
end;

procedure THiddenAboutForm.sSkinProvider1SkinItem(Item: TComponent;
  var CanBeAdded: Boolean; var SkinSection: String);
begin
  CanBeAdded := (Item <> InfoMemo) and
                (Item <> Label5) and
                (Item <> Label6) and
                (Item <> Bevel1) and
                (Item <> Bevel2) and
                (Item <> FarsiInfoMemo) and
                (Item <> Label2);
end;

procedure THiddenAboutForm.sLabel1Click(Sender: TObject);
begin
  Procs.OpenUrlInDefaultBrowser('mailto:info@lcddesigner.com');
end;

procedure THiddenAboutForm.sLabel2Click(Sender: TObject);
begin
  Procs.OpenUrlInDefaultBrowser('mailto:noorsun.electronic@yahoo.com');
end;

procedure THiddenAboutForm.Label4Click(Sender: TObject);
begin
  Procs.OpenUrlInDefaultBrowser('mailto: mo.mahdipour@gmail.com');
end;

procedure THiddenAboutForm.HowToBuyBtnClick(Sender: TObject);
begin
  HowToBuyForm := THowToBuyForm.Create(nil);
  try
    HowToBuyForm.ShowModal;
  finally
    HowToBuyForm.Free;
  end;
end;

procedure THiddenAboutForm.sLabel3Click(Sender: TObject);
begin
  Procs.OpenUrlInDefaultBrowser(SOFTWARE_HOME_PAGE_NEW);
end;

procedure THiddenAboutForm.sLabel4Click(Sender: TObject);
begin
  Procs.OpenUrlInDefaultBrowser('mailto:info@noorsun-em.com');
end;

procedure THiddenAboutForm.ShowCapabilitiesBtnClick(Sender: TObject);
begin
  CapabilitiesForm.ShowModal;
end;

end.
