unit ScheduleStageFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, TntForms, sSkinProvider, StdCtrls, Buttons, TntButtons, sBitBtn,
  sRadioButton, ExtCtrls, TntStdCtrls, sGroupBox, sLabel, sEdit, sSpinEdit,
  ProcsUnit, TntExtCtrls, sPanel, sCheckBox, sComboBox;

type
  TScheduleStageForm = class(TTntForm)
    sSkinProvider1: TsSkinProvider;
    MainPanel: TsPanel;
    Image1: TImage;
    NoTimeSpanCheck: TsRadioButton;
    DefineTimeSpanCheck: TsRadioButton;
    DefineNOTTimeSpanCheck: TsRadioButton;
    sPanel1: TsPanel;
    sLabel6: TsLabel;
    MinuteToSpin: TsSpinEdit;
    sLabel8: TsLabel;
    sLabel4: TsLabel;
    sLabel5: TsLabel;
    HourToSpin: TsSpinEdit;
    sLabel9: TsLabel;
    MinuteFromSpin: TsSpinEdit;
    sLabel2: TsLabel;
    sLabel3: TsLabel;
    sLabel7: TsLabel;
    HourFromSpin: TsSpinEdit;
    sLabel1: TsLabel;
    DisplayInSpecificDateCheck: TsCheckBox;
    sLabel10: TsLabel;
    DaySpin: TsSpinEdit;
    sLabel11: TsLabel;
    MonthCombo: TsComboBox;
    sLabel12: TsLabel;
    YearSpin: TsSpinEdit;
    procedure TntFormShow(Sender: TObject);
    procedure TntFormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure MinuteFromSpinChange(Sender: TObject);
    procedure NoTimeSpanCheckClick(Sender: TObject);
    procedure DefineTimeSpanCheckClick(Sender: TObject);
    procedure TntFormDeactivate(Sender: TObject);
    procedure TntFormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure TntFormCreate(Sender: TObject);
    procedure TntFormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    LoadingValues: Boolean;
    procedure Prepare;
    procedure RefreshFormState;
  public
    { Public declarations }
    HourFrom, MinuteFrom: Integer;
    HourTo, MinuteTo: Integer;
    OnlyDonNotShowDuringTimeSpan: Boolean;
    DisplayInSpecificDate: Boolean;
    Year, Month, Day: Integer;
  end;

var
  ScheduleStageForm: TScheduleStageForm;

implementation

uses MainUnit, Math;

{$R *.dfm}

procedure TScheduleStageForm.Prepare;
begin
  LoadingValues := True;

  if MainForm.TimeSpanDefined(HourFrom, MinuteFrom, HourTo, MinuteTo) then
  begin
    if OnlyDonNotShowDuringTimeSpan then
      DefineNOTTimeSpanCheck.Checked := True
    else
      DefineTimeSpanCheck.Checked := True;
  end
  else
    NoTimeSpanCheck.Checked := True;

  if DefineTimeSpanCheck.Checked or DefineNOTTimeSpanCheck.Checked then
  begin
    HourFromSpin.Value := HourFrom;
    MinuteFromSpin.Value := MinuteFrom;
    HourToSpin.Value := HourTo;
    MinuteToSpin.Value := MinuteTo;

    DisplayInSpecificDateCheck.Checked := DisplayInSpecificDate;
    YearSpin.Value := Year;
    try
      MonthCombo.ItemIndex := Month - 1;
    except
      MonthCombo.ItemIndex := 0;
    end;
    DaySpin.Value := Day;
  end
  else
  begin
    HourFromSpin.Value := 0;
    MinuteFromSpin.Value := 0;
    HourToSpin.Value := 0;
    MinuteToSpin.Value := 0;
    DisplayInSpecificDateCheck.Checked := False;
  end;
  RefreshFormState;

  //DisplayInSpecificDateCheckClick(DisplayInSpecificDateCheck);
  LoadingValues := False;
end;

procedure TScheduleStageForm.TntFormShow(Sender: TObject);
begin
  MainPanel.SkinData.SkinSection := RuntimeGlobalOptions.PopupFormsMainPanelSkin;
  MainForm.ScheduleStageBtn.Down := True;
  Prepare;
end;

procedure TScheduleStageForm.TntFormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  CanClose := True;
  {
  if OKClicked then
  begin
    if NoTimeSpanCheck.Checked then
    begin
      HourFrom := 0;
      MinuteFrom := 0;
      HourTo := 0;
      MinuteTo := 0;
    end
    else
    begin
      if ValidateTimeValues then
      begin
        HourFrom := HourFromSpin.Value;
        MinuteFrom := MinuteFromSpin.Value;
        HourTo := HourToSpin.Value;
        MinuteTo := MinuteToSpin.Value;
      end
      else
        CanClose := False;
    end;
  end;
  }
end;

procedure TScheduleStageForm.MinuteFromSpinChange(Sender: TObject);
begin
  if LoadingValues then Exit;

  NoTimeSpanCheck.Checked := (HourFromSpin.Value = HourToSpin.Value) and
                             (MinuteFromSpin.Value = MinuteToSpin.Value);
  if not NoTimeSpanCheck.Checked then
  begin
    if not DefineNOTTimeSpanCheck.Checked then
      DefineTimeSpanCheck.Checked := True;
  end;

  if DefineTimeSpanCheck.Checked or DefineNOTTimeSpanCheck.Checked then
  begin
    with MainForm do
    begin
      //Time Setting
      DisplayStages[ActiveDisplayStage].HourFrom := IfThen(HourFromSpin.Value <= HourFromSpin.MaxValue, HourFromSpin.Value, HourFromSpin.MaxValue);
      DisplayStages[ActiveDisplayStage].MinuteFrom := IfThen(MinuteFromSpin.Value <= MinuteFromSpin.MaxValue, MinuteFromSpin.Value, MinuteFromSpin.MaxValue);
      DisplayStages[ActiveDisplayStage].HourTo := IfThen(HourToSpin.Value <= HourToSpin.MaxValue, HourToSpin.Value, HourToSpin.MaxValue);
      DisplayStages[ActiveDisplayStage].MinuteTo := IfThen(MinuteToSpin.Value <= MinuteToSpin.MaxValue, MinuteToSpin.Value, MinuteToSpin.MaxValue);
      DisplayStages[ActiveDisplayStage].OnlyDoNotShowDuringTimeSpan := DefineNOTTimeSpanCheck.Checked;
      //Date Setting
      DisplayStages[ActiveDisplayStage].DisplayInSpecificDate := DisplayInSpecificDateCheck.Checked;
      DisplayStages[ActiveDisplayStage].Year := YearSpin.Value;
      DisplayStages[ActiveDisplayStage].Month := MonthCombo.ItemIndex + 1;
      DisplayStages[ActiveDisplayStage].Day := DaySpin.Value;
    end;
    MainForm.RefreshStagePanels;
  end;
  RefreshFormState;
end;

procedure TScheduleStageForm.NoTimeSpanCheckClick(Sender: TObject);
begin
  if LoadingValues then Exit;

  with MainForm do
  begin
    DisplayStages[ActiveDisplayStage].HourFrom := 0;
    DisplayStages[ActiveDisplayStage].MinuteFrom := 0;
    DisplayStages[ActiveDisplayStage].HourTo := 0;
    DisplayStages[ActiveDisplayStage].MinuteTo := 0;
    DisplayStages[ActiveDisplayStage].OnlyDoNotShowDuringTimeSpan := False;

    DisplayStages[ActiveDisplayStage].DisplayInSpecificDate := False;
  end;
  MainForm.RefreshStagePanels;
  RefreshFormState;
end;

procedure TScheduleStageForm.DefineTimeSpanCheckClick(Sender: TObject);
begin
  if LoadingValues then Exit;

  with MainForm do
  begin
    DisplayStages[ActiveDisplayStage].HourFrom := IfThen(HourFromSpin.Value <= HourFromSpin.MaxValue, HourFromSpin.Value, HourFromSpin.MaxValue);
    DisplayStages[ActiveDisplayStage].MinuteFrom := IfThen(MinuteFromSpin.Value <= MinuteFromSpin.MaxValue, MinuteFromSpin.Value, MinuteFromSpin.MaxValue);
    DisplayStages[ActiveDisplayStage].HourTo := IfThen(HourToSpin.Value <= HourToSpin.MaxValue, HourToSpin.Value, HourToSpin.MaxValue);
    DisplayStages[ActiveDisplayStage].MinuteTo := IfThen(MinuteToSpin.Value <= MinuteToSpin.MaxValue, MinuteToSpin.Value, MinuteToSpin.MaxValue);
    DisplayStages[ActiveDisplayStage].OnlyDoNotShowDuringTimeSpan := DefineNOTTimeSpanCheck.Checked;

    DisplayStages[ActiveDisplayStage].DisplayInSpecificDate := DisplayInSpecificDateCheck.Checked;
    DisplayStages[ActiveDisplayStage].Year := YearSpin.Value;
    DisplayStages[ActiveDisplayStage].Month := MonthCombo.ItemIndex + 1;
    DisplayStages[ActiveDisplayStage].Day := DaySpin.Value;
  end;
  MainForm.RefreshStagePanels;
  RefreshFormState;
end;

procedure TScheduleStageForm.TntFormDeactivate(Sender: TObject);
begin
  Close;
end;

procedure TScheduleStageForm.TntFormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_ESCAPE) or (Key = VK_RETURN) then
  begin
    Key := 0;
    Close;
  end;
end;

procedure TScheduleStageForm.TntFormCreate(Sender: TObject);
begin
  LoadingValues := False;
end;

procedure TScheduleStageForm.TntFormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  MainForm.ScheduleStageBtn.Down := False;
end;

procedure TScheduleStageForm.RefreshFormState;
begin
  DisplayInSpecificDateCheck.Enabled := not NoTimeSpanCheck.Checked;
  YearSpin.Enabled := DisplayInSpecificDateCheck.Checked and DisplayInSpecificDateCheck.Enabled;
  MonthCombo.Enabled := YearSpin.Enabled;
  DaySpin.Enabled := YearSpin.Enabled;
end;

end.
