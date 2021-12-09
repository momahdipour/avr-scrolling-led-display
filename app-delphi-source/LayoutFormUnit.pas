unit LayoutFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, TntForms, sSkinProvider, StdCtrls, Buttons, TntButtons, sBitBtn,
  ExtCtrls, TntExtCtrls, sPanel, sSpeedButton, TntStdCtrls, sGroupBox,
  Layouts, GlobalTypes, LayoutDesignerFormUnit;

type
  TLayoutForm = class(TTntForm)
    sSkinProvider1: TsSkinProvider;
    CancelBtn: TsBitBtn;
    LayoutGroup: TsGroupBox;
    LayoutBtn1: TsSpeedButton;
    LayoutBtn2: TsSpeedButton;
    LayoutBtn3: TsSpeedButton;
    LayoutBtn4: TsSpeedButton;
    VerticalPanel: TsPanel;
    sGroupBox1: TsGroupBox;
    sSpeedButton1: TsSpeedButton;
    sSpeedButton2: TsSpeedButton;
    sSpeedButton3: TsSpeedButton;
    sSpeedButton4: TsSpeedButton;
    SelectionPanel: TsPanel;
    CreateCustomLayoutBtn: TsBitBtn;
    SameAsPrviousStageLayoutBtn: TsBitBtn;
    sPanel1: TsPanel;
    procedure TntFormShow(Sender: TObject);
    procedure LayoutGroupMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure LayoutGroupClick(Sender: TObject);
    procedure TntFormCreate(Sender: TObject);
    procedure TntFormResize(Sender: TObject);
  private
    { Private declarations }
    LayoutContainers: array of TsGroupBox;
  public
    { Public declarations }
    SelectedLayoutIndex: Integer;
    procedure Prepare;
    function NumberOfLayouts: Integer;
  end;

var
  LayoutForm: TLayoutForm;

implementation

uses MainUnit, Math;

{$R *.dfm}

procedure TLayoutForm.Prepare;
const
  COLUMN_1_LEFT = 12;
  COLUMN_2_LEFT = 247;
  COLUMN_3_LEFT = 482;
  ROW_1_TOP = 10;
  ROWS_DIF = 15;
  CONTAINER_HEIGHT = 105;
var
  LayoutBtns: array[1..4] of TsSpeedButton;
  i, j: Integer;
  Areas: TAreasArray;
  CustomLayout: Boolean;
begin
  for i := 0 to High(LayoutContainers) do
    LayoutContainers[i].Free;  //This will automatically free all owned children

  SetLength(LayoutContainers, GetMaxLayoutIndex(GlobalOptions.LEDDisplaySettings.Height, GlobalOptions.LEDDisplaySettings.Width));

  if Length(LayoutContainers) = 0 then
    Exit;

  SetRoundMode(rmUp);

  Self.Height := Round(Length(LayoutContainers) / 3) * (CONTAINER_HEIGHT + ROWS_DIF) + ROW_1_TOP + CancelBtn.Height + 10 + 50;

  for i := 1 to GetMaxLayoutIndex(GlobalOptions.LEDDisplaySettings.Height, GlobalOptions.LEDDisplaySettings.Width) do
  begin
    LayoutContainers[i - 1] := TsGroupBox.Create(Self);
    with LayoutContainers[i - 1] do
    begin
      Parent := Self;
      Width := 203;
      Height := CONTAINER_HEIGHT;
      Cursor := crHandPoint;
      Tag := i;
      OnMouseMove := LayoutGroupMouseMove;
      OnClick := LayoutGroupClick;

      if (i mod 3) = 0 then
        Left := COLUMN_3_LEFT
      else if (i mod 3) = 1 then
        Left := COLUMN_1_LEFT
      else if (i mod 3) = 2 then
        Left := COLUMN_2_LEFT;

      Top := ROW_1_TOP + (((i - 1) div 3) * (ROWS_DIF + LayoutContainers[i - 1].Height));
    end;

    for j := 1 to 4 do
    begin
      LayoutBtns[j] := TsSpeedButton.Create(LayoutContainers[i - 1]);
      LayoutBtns[j].Parent := LayoutContainers[i - 1];
      LayoutBtns[j].Tag := i;  //to correctly select a layout in OnCLick event
      LayoutBtns[j].SkinData.SkinSection := RuntimeGlobalOptions.LayoutButtonSkin;//'PROGRESSH';
      LayoutBtns[j].GroupIndex := j;
      LayoutBtns[j].AllowAllUp := False;
      LayoutBtns[j].Down := True;
      LayoutBtns[j].Cursor := crHandPoint;
      LayoutBtns[j].OnMouseMove := LayoutGroupMouseMove;
      LayoutBtns[j].OnClick := LayoutGroupClick;
    end;

    SetLayout(Areas, i, GlobalOptions.LEDDisplaySettings.Height, GlobalOptions.LEDDisplaySettings.Width, CustomLayout);
    //** Don't care about the value of CustomLayout here **//  
    MainForm.SetupLayout(Areas, LayoutBtns[1], LayoutBtns[2], LayoutBtns[3], LayoutBtns[4], LayoutContainers[i - 1]);
  end;
end;

procedure TLayoutForm.TntFormShow(Sender: TObject);
var
  //Areas: TAreasArray;  -->  For Test
  LayoutToSelect: Integer;
begin
  //Prevent potential software bugs by setting the value of the SkinSection property
  LayoutBtn1.SkinData.SkinSection := RuntimeGlobalOptions.LayoutButtonSkin;
  LayoutBtn2.SkinData.SkinSection := RuntimeGlobalOptions.LayoutButtonSkin;
  LayoutBtn3.SkinData.SkinSection := RuntimeGlobalOptions.LayoutButtonSkin;
  LayoutBtn4.SkinData.SkinSection := RuntimeGlobalOptions.LayoutButtonSkin;

  //CreateCustomLayoutBtn.SetFocus;
  
  if SelectedLayoutIndex = 0 then
    LayoutToSelect := 1
  else
    LayoutToSelect := SelectedLayoutIndex;

  LayoutContainers[LayoutToSelect - 1].OnMouseMove(LayoutContainers[LayoutToSelect - 1], [], 0, 0);
//  SetLayout(Areas, 2, GlobalOptions.LEDDisplaySettings.Height, GlobalOptions.LEDDisplaySettings.Width);
//  MainForm.SetupLayout(Areas, LayoutBtn1, LayoutBtn2, LayoutBtn3, LayoutBtn4, LayoutGroup);

  Top := Trunc(Screen.Height / 2 - Height / 2);
end;

procedure TLayoutForm.LayoutGroupMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  if Sender is TsGroupBox then
  begin
    SelectionPanel.Left := (Sender as TsGroupBox).Left - 5;
    SelectionPanel.Top := (Sender as TsGroupBox).Top - 5;
  end
  else if Sender is TsSpeedButton then
  begin
    SelectionPanel.Left := (Sender as TsSpeedButton).Parent.Left - 5;
    SelectionPanel.Top := (Sender as TsSpeedButton).Parent.Top - 5;
  end;
end;

procedure TLayoutForm.LayoutGroupClick(Sender: TObject);
begin
  SelectedLayoutIndex := (Sender as TComponent).Tag;
  ModalResult := mrOk;
end;

procedure TLayoutForm.TntFormCreate(Sender: TObject);
begin
  CreateCustomLayoutBtn.ModalResult := mrLayoutDesigner;
  SameAsPrviousStageLayoutBtn.ModalResult := mrLayoutSameAsPreviousStage;
end;

function TLayoutForm.NumberOfLayouts: Integer;
begin
  Result := Length(LayoutContainers);
end;

procedure TLayoutForm.TntFormResize(Sender: TObject);
begin
  CancelBtn.Left := Trunc(Width / 2 - CancelBtn.Width / 2);
end;

end.
