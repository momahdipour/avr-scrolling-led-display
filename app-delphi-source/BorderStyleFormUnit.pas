unit BorderStyleFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, TntForms, sSkinProvider, Buttons, TntButtons, sSpeedButton,
  ExtCtrls, StdCtrls, sLabel, TntExtCtrls, sPanel, sEdit, sSpinEdit,
  sRadioButton, TntStdCtrls, sGroupBox, GlobalTypes;

type
  TBorderStyleForm = class(TTntForm)
    sSkinProvider1: TsSkinProvider;
    MainPanel: TsPanel;
    TopBorderLabel: TsLabel;
    BottomBorderLabel: TsLabel;
    LeftBorderLabel: TsLabel;
    RightBorderLabel: TsLabel;
    TopBorderSpeedBtn: TsSpeedButton;
    BottomBorderSpeedBtn: TsSpeedButton;
    LeftBorderSpeedBtn: TsSpeedButton;
    RightBorderSpeedBtn: TsSpeedButton;
    FullBorderSpeedBtn: TsSpeedButton;
    BorderStyleImage: TImage;
    OKBtn: TsSpeedButton;
    sLabel1: TsLabel;
    NoBorderSpeedBtn: TsSpeedButton;
    BorderOptionsGroup: TsGroupBox;
    sLabel2: TsLabel;
    BorderWidthSpin: TsSpinEdit;
    BordersFilledRadio: TsRadioButton;
    BordersClearedRadio: TsRadioButton;
    HighGUITimer: TTimer;
    Bevel2: TBevel;
    FullBorderBtn: TsSpeedButton;
    NoBorderBtn: TsSpeedButton;
    procedure TopBorderLabelClick(Sender: TObject);
    procedure TntFormShow(Sender: TObject);
    procedure FullBorderSpeedBtnClick(Sender: TObject);
    procedure TopBorderSpeedBtnClick(Sender: TObject);
    procedure TntFormDeactivate(Sender: TObject);
    procedure OKBtnClick(Sender: TObject);
    procedure TntFormClose(Sender: TObject; var Action: TCloseAction);
    procedure NoBorderSpeedBtnClick(Sender: TObject);
    procedure BorderWidthSpinChange(Sender: TObject);
    procedure BordersFilledRadioClick(Sender: TObject);
    procedure HighGUITimerTimer(Sender: TObject);
    procedure TntFormCreate(Sender: TObject);
    procedure FullBorderBtnClick(Sender: TObject);
    procedure NoBorderBtnClick(Sender: TObject);
  private
    { Private declarations }
    HighGUIItems: THighGUIItems;

    procedure Prepare;
    procedure UpdateButtonStates;
    procedure UpdateMainFormBorderLabels;
    procedure SetBorders(TopBorder, BottomBorder, LeftBorder,
      RightBorder: Boolean);
    procedure ResetBorders(TopBorder, BottomBorder, LeftBorder,
      RightBorder: Boolean);
      
    procedure HighGUIInitialize;
  public
    { Public declarations }
    TopBorder, BottomBorder, LeftBorder, RightBorder: Boolean;
    AreaBorderWidth: Integer;
    BordersFilled: Boolean;
  end;

var
  BorderStyleForm: TBorderStyleForm;

implementation

uses MainUnit;

{$R *.dfm}

procedure TBorderStyleForm.TopBorderLabelClick(Sender: TObject);
begin
  (Sender as TsLabel).Transparent := not (Sender as TsLabel).Transparent;
  UpdateButtonStates;
end;

procedure TBorderStyleForm.TntFormShow(Sender: TObject);
begin
  HighGUITimer.Enabled := True;

  MainPanel.SkinData.SkinSection := RuntimeGlobalOptions.PopupFormsMainPanelSkin;
  MainForm.EditBorderStyleSpeedBtn.Down := True;
  MainForm.EditBorderStyleSpeedBtn2.Down := True;
  Prepare;
end;

procedure TBorderStyleForm.Prepare;
begin
  BorderWidthSpin.Value := AreaBorderWidth;
  BordersFilledRadio.Checked := BordersFilled;
  BordersClearedRadio.Checked := not BordersFilled;

  ResetBorders(True, True, True, True);
  SetBorders(TopBorder, BottomBorder, LeftBorder, RightBorder);
end;

procedure TBorderStyleForm.UpdateButtonStates;
begin
  TopBorderSpeedBtn.Down := not TopBorderLabel.Transparent;
  BottomBorderSpeedBtn.Down := not BottomBorderLabel.Transparent;
  LeftBorderSpeedBtn.Down := not LeftBorderLabel.Transparent;
  RightBorderSpeedBtn.Down := not RightBorderLabel.Transparent;
  //FullBorderSpeedBtn.Down := TopBorderSpeedBtn.Down and BottomBorderSpeedBtn.Down and
  //                           LeftBorderSpeedBtn.Down and RightBorderSpeedBtn.Down;
  //NoBorderSpeedBtn.Down := not(TopBorderSpeedBtn.Down or BottomBorderSpeedBtn.Down or
  //                             LeftBorderSpeedBtn.Down or RightBorderSpeedBtn.Down);

  UpdateMainFormBorderLabels;
end;

procedure TBorderStyleForm.SetBorders(TopBorder, BottomBorder, LeftBorder,
  RightBorder: Boolean);
begin
  TopBorderLabel.Transparent := not TopBorder;
  BottomBorderLabel.Transparent := not BottomBorder;
  LeftBorderLabel.Transparent := not LeftBorder;
  RightBorderLabel.Transparent := not RightBorder;

  UpdateButtonStates;
end;

procedure TBorderStyleForm.ResetBorders(TopBorder, BottomBorder,
  LeftBorder, RightBorder: Boolean);
begin
  TopBorderLabel.Transparent := TopBorder;
  BottomBorderLabel.Transparent := BottomBorder;
  LeftBorderLabel.Transparent := LeftBorder;
  RightBorderLabel.Transparent := RightBorder;

  UpdateButtonStates;
end;

procedure TBorderStyleForm.FullBorderSpeedBtnClick(Sender: TObject);
begin
  SetBorders(True, True, True, True);
  //ResetBorders(not FullBorderSpeedBtn.Down, not FullBorderSpeedBtn.Down, not FullBorderSpeedBtn.Down, not FullBorderSpeedBtn.Down);
  ResetBorders(False, False, False, False);
  UpdateButtonStates;
end;

procedure TBorderStyleForm.TopBorderSpeedBtnClick(Sender: TObject);
begin
  SetBorders(TopBorderSpeedBtn.Down, BottomBorderSpeedBtn.Down, LeftBorderSpeedBtn.Down, RightBorderSpeedBtn.Down);
  ResetBorders(not TopBorderSpeedBtn.Down, not BottomBorderSpeedBtn.Down, not LeftBorderSpeedBtn.Down, not RightBorderSpeedBtn.Down);
end;

procedure TBorderStyleForm.TntFormDeactivate(Sender: TObject);
begin
  Close;
end;

procedure TBorderStyleForm.OKBtnClick(Sender: TObject);
begin
  Close;
end;

procedure TBorderStyleForm.TntFormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  MainForm.EditBorderStyleSpeedBtn.Down := False;
  MainForm.EditBorderStyleSpeedBtn2.Down := False;

  UpdateMainFormBorderLabels;

  HighGUITimer.Enabled := False;
end;

procedure TBorderStyleForm.UpdateMainFormBorderLabels;
begin
  MainForm.TopBorderLabel.Transparent := TopBorderLabel.Transparent;
  MainForm.BottomBorderLabel.Transparent := BottomBorderLabel.Transparent;
  MainForm.LeftBorderLabel.Transparent := LeftBorderLabel.Transparent;
  MainForm.RightBorderLabel.Transparent := RightBorderLabel.Transparent;

  MainForm.AreaBorderWidthSpin.Value := BorderWidthSpin.Value;
  MainForm.DisplayStages[MainForm.ActiveDisplayStage].Areas[MainForm.ActiveAreaIndex].BordersFilled := BordersFilledRadio.Checked;
end;

procedure TBorderStyleForm.NoBorderSpeedBtnClick(Sender: TObject);
begin
  ResetBorders(True, True, True, True);
  UpdateButtonStates;
end;

procedure TBorderStyleForm.BorderWidthSpinChange(Sender: TObject);
begin
  UpdateMainFormBorderLabels;
end;

procedure TBorderStyleForm.BordersFilledRadioClick(Sender: TObject);
begin
  UpdateMainFormBorderLabels;
end;

procedure TBorderStyleForm.HighGUIInitialize;
begin
  SetLength(HighGUIItems, 1);

  HighGUIItems[0] := BorderOptionsGroup;
end;

procedure TBorderStyleForm.HighGUITimerTimer(Sender: TObject);
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

procedure TBorderStyleForm.TntFormCreate(Sender: TObject);
begin
  HighGUIInitialize;
end;

procedure TBorderStyleForm.FullBorderBtnClick(Sender: TObject);
begin
  FullBorderSpeedBtn.Click;
end;

procedure TBorderStyleForm.NoBorderBtnClick(Sender: TObject);
begin
  NoBorderSpeedBtn.Click;
end;

end.
