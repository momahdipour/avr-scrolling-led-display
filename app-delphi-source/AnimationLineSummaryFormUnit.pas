unit AnimationLineSummaryFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, TntForms, StdCtrls, Buttons, TntButtons, sBitBtn, sSkinProvider,
  sComboBox, sEdit, sSpinEdit, sCheckBox, sLabel, TntStdCtrls, sGroupBox,
  GlobalTypes, ExtCtrls, TntExtCtrls, sPanel;

type
  TAnimationLineSummaryForm = class(TTntForm)
    sSkinProvider1: TsSkinProvider;
    OKBtn: TsBitBtn;
    ScrollBox1: TScrollBox;
    RefStageGroup: TsGroupBox;
    RefAreaLabel: TsLabel;
    NoStagePanel: TsPanel;
    procedure TntFormDestroy(Sender: TObject);
    procedure TntFormShow(Sender: TObject);
    procedure TntFormResize(Sender: TObject);
    procedure TntFormHide(Sender: TObject);
  private
    { Private declarations }
    StageGroups: array of TsGroupBox;
    procedure FreeAllStageGroups;
    procedure Prepare;
  public
    { Public declarations }
  end;

var
  AnimationLineSummaryForm: TAnimationLineSummaryForm;

implementation

uses MainUnit;

{$R *.dfm}

{ TAnimationLineSurveyForm }

procedure TAnimationLineSummaryForm.FreeAllStageGroups;
var
  i: Integer;
begin
  for i := 0 to High(StageGroups) do
    StageGroups[i].Free;
  SetLength(StageGroups, 0);
end;

procedure TAnimationLineSummaryForm.Prepare;
var
  StageIndex, AreaIndex: Integer;
  gb: TsGroupBox;
  AreaLabel: TsLabel;
  AreaCount: Integer;
  NextGroupTop, NextLabelTop: Integer;
  i: Integer;
begin
  FreeAllStageGroups;  //This is necessary to free up unused resources, unless the program may encounter problems for long time execution

  SetLength(StageGroups, 0);
  NextGroupTop := RefStageGroup.Top;

  ScrollBox1.VertScrollBar.Visible := False;

  RefStageGroup.Visible := True;
  RefStageGroup.Visible := False;

  StageIndex := 0;
  for i := 0 to High(MainForm.DisplayStages) do
  if not MainForm.DisplayStages[i].TemporaryDisabled then
  begin
    SetLength(StageGroups, Length(StageGroups) + 1);
    gb := MainForm.NewGroupBoxFromRef(RefStageGroup, ScrollBox1, Self);
    gb.Visible := True;  //because the reference groupbox is not visible
    gb.Caption := RefStageGroup.Caption + ' ' + IntToStr(StageIndex + 1);
    gb.Top := NextGroupTop;
    StageGroups[StageIndex] := gb;
    AreaCount := 0;
    NextLabelTop := RefAreaLabel.Top;
    for AreaIndex := 1 to MAX_AREA_COUNT do
      if not MainForm.IsUnusedArea(MainForm.DisplayStages[i].Areas[AreaIndex]) then
        with MainForm.DisplayStages[i].Areas[AreaIndex] do
        begin
          Inc(AreaCount);
          AreaLabel := MainForm.NewLabelFromRef(RefAreaLabel, gb, Self);
          AreaLabel.Top := NextLabelTop;
          AreaLabel.Caption := MainForm.GetAreaContentDescription(MainForm.DisplayStages[i].Areas[AreaIndex]);
          NextLabelTop := NextLabelTop + RefAreaLabel.Height + 5;
        end;
    gb.Height := AreaCount * (RefAreaLabel.Height + 4) + 22 + 6;

    NextGroupTop := NextGroupTop + gb.Height + 3;

    Inc(StageIndex);
  end;

  ScrollBox1.VertScrollBar.Visible := True;

  NoStagePanel.Visible := Length(StageGroups) = 0;
end;

procedure TAnimationLineSummaryForm.TntFormDestroy(Sender: TObject);
begin
  FreeAllStageGroups;
end;

procedure TAnimationLineSummaryForm.TntFormShow(Sender: TObject);
begin
  Prepare;
end;

procedure TAnimationLineSummaryForm.TntFormResize(Sender: TObject);
begin
  OKBtn.Left := Trunc(Width / 2 - OKBtn.Width / 2);
end;

procedure TAnimationLineSummaryForm.TntFormHide(Sender: TObject);
begin
  ScrollBox1.VertScrollBar.Position := 0;
end;

end.
