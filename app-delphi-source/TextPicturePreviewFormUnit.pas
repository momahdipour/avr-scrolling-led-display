unit TextPicturePreviewFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, sSkinProvider, TntForms, StdCtrls, Buttons,
  TntButtons, sBitBtn, TntStdCtrls, sGroupBox, ComCtrls, TntComCtrls,
  sStatusBar, sSpeedButton, sCheckBox, sTrackBar, sLabel, TntExtCtrls,
  sPanel, Grids, BaseGrid, AdvGrid, MMAdvancedGrid;

type
  TTextPicturePreviewForm = class(TTntForm)
    sSkinProvider1: TsSkinProvider;
    PreviewImage: TImage;
    StatusBar: TsStatusBar;
    ZoomPanel: TsPanel;
    sLabel1: TsLabel;
    ZoomTrackBar: TsTrackBar;
    LCDGridLinesCheck: TsCheckBox;
    GridPanel: TsPanel;
    TextPreviewGrid: TMMAdvancedGrid;
    CloseBtn: TsSpeedButton;
    procedure CloseBtnClick(Sender: TObject);
    procedure TntFormClose(Sender: TObject; var Action: TCloseAction);
    procedure TntFormResize(Sender: TObject);
    procedure TntFormCreate(Sender: TObject);
    procedure TntFormShow(Sender: TObject);
    procedure ZoomTrackBarChange(Sender: TObject);
    procedure LCDGridLinesCheckClick(Sender: TObject);
    procedure TntFormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure PutLCDAtCenter(LCDGrid:TAdvStringGrid;Container:TControl);
    procedure PositionLCD;
    procedure UpdateInfo;
  end;

var
  TextPicturePreviewForm: TTextPicturePreviewForm;

implementation

uses MainUnit;

{$R *.dfm}

procedure TTextPicturePreviewForm.CloseBtnClick(Sender: TObject);
begin
  Close;
end;

procedure TTextPicturePreviewForm.TntFormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  MainForm.ShowTextPreviewBtn.Down := False;
end;

procedure TTextPicturePreviewForm.TntFormResize(Sender: TObject);
begin
//  CloseBtn.Left := Trunc(ZoomPanel.Width / 2 - CloseBtn.Width / 2);
  PositionLCD;
end;

procedure TTextPicturePreviewForm.TntFormCreate(Sender: TObject);
begin
  Left := 0;
  Top := 0;
  Width := Screen.DesktopWidth;
end;

procedure TTextPicturePreviewForm.TntFormShow(Sender: TObject);
begin
  MainForm.ShowTextPreviewBtn.Down := True;
  UpdateInfo;
end;

procedure TTextPicturePreviewForm.PositionLCD;
begin
  TextPreviewGrid.ScrollBars := ssNone;
  TextPreviewGrid.DefaultRowHeight := ZoomTrackBar.Position;
  TextPreviewGrid.DefaultColWidth := ZoomTrackBar.Position;
  TextPreviewGrid.RowHeights[TextPreviewGrid.RowCount - 1] := 0;

  PutLCDAtCenter(TextPreviewGrid, GridPanel);
end;

procedure TTextPicturePreviewForm.PutLCDAtCenter(LCDGrid: TAdvStringGrid;
  Container: TControl);
var
  ShowScrollBars:Boolean;
begin
  LCDGrid.Width:=(LCDGrid.ColCount)*LCDGrid.DefaultColWidth;
  LCDGrid.Height:=(LCDGrid.RowCount-1)*LCDGrid.DefaultRowHeight;
  ShowScrollBars:=False;
  if LCDGrid.Width>Container.Width then
  begin
    LCDGrid.Width:=Container.Width;
    ShowScrollBars:=True;
  end;
  if LCDGrid.Height>Container.Height then
  begin
    LCDGrid.Height:=Container.Height;
    ShowScrollBars:=True;
  end;
  if ShowScrollBars then
    LCDGrid.ScrollBars:=ssBoth;
  //Put at center
  LCDGrid.Left:=Trunc(Container.Width/2-LCDGrid.Width/2);
  LCDGrid.Top:=Trunc(Container.Height/2-LCDGrid.Height/2);
  LCDGrid.Col:=0;
  LCDGrid.Row:=0;  
end;

procedure TTextPicturePreviewForm.ZoomTrackBarChange(Sender: TObject);
begin
  PositionLCD;
end;

procedure TTextPicturePreviewForm.LCDGridLinesCheckClick(Sender: TObject);
begin
  if (Sender as TsCheckBox).Checked then
    //TextPreviewGrid.Options := TextPreviewGrid.Options+[goVertLine,goHorzLine]
    TextPreviewGrid.GridLineColor := LCDGridLineColor
  else
    //TextPreviewGrid.Options := TextPreviewGrid.Options-[goVertLine,goHorzLine];
    TextPreviewGrid.GridLineColor := TextPreviewGrid.Color;
end;

procedure TTextPicturePreviewForm.UpdateInfo;
begin
  StatusBar.Panels[0].Text := IntToStr(TextPreviewGrid.RowCount - 1) + 'x' + IntToStr(TextPreviewGrid.ColCount);
end;

procedure TTextPicturePreviewForm.TntFormActivate(Sender: TObject);
begin
  UpdateInfo;
end;

end.
