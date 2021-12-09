unit WaitFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, TntForms, sSkinProvider, ExtCtrls, StdCtrls, sLabel, ComCtrls,
  TntExtCtrls, sPanel;

type
  TWaitForm = class(TTntForm)
    sSkinProvider1: TsSkinProvider;
    MainPanel: TsPanel;
    MessageImage: TImage;
    MessageLabel: TsLabel;
    procedure TntFormShow(Sender: TObject);
    procedure TntFormCreate(Sender: TObject);
  private
    { Private declarations }
    procedure Prepare;
  public
    { Public declarations }
  end;

var
  WaitForm: TWaitForm;

implementation

uses MainUnit;

{$R *.dfm}

procedure TWaitForm.TntFormShow(Sender: TObject);
begin
  Left := Trunc((Screen.Width - Width) / 2);
  Top := Trunc((Screen.Height - Height) / 2);

  MainPanel.SkinData.SkinSection := RuntimeGlobalOptions.WaitFormMainPanelSkin;
end;

procedure TWaitForm.TntFormCreate(Sender: TObject);
begin
  Prepare;
end;

procedure TWaitForm.Prepare;
begin
  MainForm.LoadGIFFromResource('WAITFORM_PROGRESS_GIF', MessageImage.Picture);
end;

end.
