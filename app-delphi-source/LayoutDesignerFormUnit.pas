unit LayoutDesignerFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, TntForms, sSkinProvider, StdCtrls, Buttons, TntButtons, sBitBtn,
  TntStdCtrls, sGroupBox, ExtCtrls, TntExtCtrls, sPanel, atDiagram,
  GlobalTypes, sSpeedButton, ComCtrls, TntComCtrls, ToolWin, sToolBar,
  ImgList, SoundDialogs, sLabel;

const
  DIAGRAM_BORDER_OFFSET = 1;

type
  TLayoutDesignerForm = class(TTntForm)
    sSkinProvider1: TsSkinProvider;
    CancelBtn: TsBitBtn;
    OKBtn: TsBitBtn;
    DesignPanel: TsPanel;
    LayoutDiagram: TatDiagram;
    DiagramBlock1: TDiagramBlock;
    AddAreaBtn: TsSpeedButton;
    RemoveSelectedAreaBtn: TsSpeedButton;
    LayoutDesignerToolbar: TsToolBar;
    TntToolButton1: TTntToolButton;
    TntToolButton2: TTntToolButton;
    TntToolButton3: TTntToolButton;
    TntToolButton4: TTntToolButton;
    TntToolButton5: TTntToolButton;
    TntToolButton6: TTntToolButton;
    TntToolButton7: TTntToolButton;
    LayoutDesignToolbarImageList: TImageList;
    TntToolButton8: TTntToolButton;
    TntToolButton9: TTntToolButton;
    TntToolButton10: TTntToolButton;
    TntToolButton11: TTntToolButton;
    LayoutWarningImage: TImage;
    LayoutWarningLabel: TsLabel;
    SelectLayoutBtn: TsBitBtn;
    TntToolButton12: TTntToolButton;
    TntToolButton13: TTntToolButton;
    procedure TntFormShow(Sender: TObject);
    procedure TntToolButton1Click(Sender: TObject);
    procedure TntToolButton3Click(Sender: TObject);
    procedure TntToolButton5Click(Sender: TObject);
    procedure TntToolButton7Click(Sender: TObject);
    procedure TntToolButton2Click(Sender: TObject);
    procedure TntToolButton6Click(Sender: TObject);
    procedure RemoveSelectedAreaBtnClick(Sender: TObject);
    procedure AddAreaBtnClick(Sender: TObject);
    procedure OKBtnClick(Sender: TObject);
    procedure TntFormHide(Sender: TObject);
    procedure TntToolButton9Click(Sender: TObject);
    procedure LayoutDiagramModified(Sender: TObject);
    procedure TntFormCreate(Sender: TObject);
    procedure LayoutDiagramDControlMouseDown(Sender: TObject;
      ADControl: TDiagramControl; Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer);
    procedure LayoutDiagramMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure LayoutDiagramKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
    ResultLayout: TAreasArray;
    DiagramBlocksOriginalPos: array[1..MAX_AREA_COUNT] of TRect;
    OriginalBlockCount: Integer;
    OriginalAreas: TAreasArray;

    LoadingLayout: Boolean;

    OldBlocksRect: array[0..3] of TRect;
    CheckOldBlocksRect: Boolean;

    procedure SetDiagramBlockDefaults(db: TDiagramBlock);
    procedure SetDiagramBlockText(db: TCustomDiagramBlock);
    procedure AlignSelecteds(ADiagram: TatDiagram; ALeft, ATop,
      ARight, ABottom: Integer);
    procedure AlignSelectedsCenter(ADiagram: TatDiagram;
      Horizontally, Vertically: Boolean);

    procedure GetAreasFromDiagram(var Areas: TAreasArray);

    procedure SaveOriginalState;
    function LayoutChanged: Boolean;

    function AreasIntersect: Boolean;
    procedure DiagramBlockToArea(DBlock: TCustomDiagramBlock; var x1, y1, x2,
      y2: Integer);
    procedure ApplyAreaCorrection(const Areas: TAreasArray);

    procedure InitializeOldBlocksRect;
  public
    { Public declarations }
    procedure PrepareLayout(Areas: TAreasArray);
    procedure SetLayout(var Areas: TAreasArray);
  end;

var
  LayoutDesignerForm: TLayoutDesignerForm;

implementation

uses MainUnit, Math;

{$R *.dfm}

procedure TLayoutDesignerForm.AlignSelecteds(ADiagram: TatDiagram; ALeft,
  ATop, ARight, ABottom: Integer);
var
  i: Integer;
begin
  if ADiagram.SelectedCount > 0 then
  begin
    for i := 0 to ADiagram.SelectedCount - 1 do
    begin
      if ALeft >= 0 then
        (ADiagram.Selecteds[i] as TDiagramBlock).Left := ALeft;
      if ATop >= 0 then
        (ADiagram.Selecteds[i] as TDiagramBlock).Top := ATop;
      if ARight >= 0 then
        (ADiagram.Selecteds[i] as TDiagramBlock).Left := (ADiagram.Selecteds[i] as TDiagramBlock).Left + (ARight - (ADiagram.Selecteds[i] as TDiagramBlock).Right);
      if ABottom >= 0 then
        (ADiagram.Selecteds[i] as TDiagramBlock).Top := (ADiagram.Selecteds[i] as TDiagramBlock).Top + (ABottom - (ADiagram.Selecteds[i] as TDiagramBlock).Bottom);
    end;
  end;
end;

procedure TLayoutDesignerForm.PrepareLayout(Areas: TAreasArray);
var
  i: Integer;
  db: TDiagramBlock;
  WM, HM: Double;
  //AreaCount: Integer;
begin
  LoadingLayout := True;

  CheckOldBlocksRect := False;

  for i := 1 to MAX_AREA_COUNT do
    OriginalAreas[i] := Areas[i];

  LayoutDiagram.Clear;

  with LayoutDiagram.SnapGrid do
  begin
    Active := True;
    Visible := True;
    LayoutDiagram.Width := Trunc((390 - DIAGRAM_BORDER_OFFSET) / (GlobalOptions.LEDDisplaySettings.Width - 1)) * GlobalOptions.LEDDisplaySettings.Width;
    LayoutDiagram.Height := Trunc((290 - DIAGRAM_BORDER_OFFSET) / (GlobalOptions.LEDDisplaySettings.Height - 1)) * GlobalOptions.LEDDisplaySettings.Height;
    LayoutDiagram.Left := Trunc(DesignPanel.Width / 2 - LayoutDiagram.Width / 2);  //Put at center horizontally
    SizeX := (LayoutDiagram.Width - DIAGRAM_BORDER_OFFSET) / (GlobalOptions.LEDDisplaySettings.Width - 1);
    SizeY := (LayoutDiagram.Height - DIAGRAM_BORDER_OFFSET) / (GlobalOptions.LEDDisplaySettings.Height - 1);
  end;

  WM := LayoutDiagram.Width / (GlobalOptions.LEDDisplaySettings.Width - 1);
  HM := LayoutDiagram.Height / (GlobalOptions.LEDDisplaySettings.Height - 1);

  //AreaCount := 0;
  SetRoundMode(rmNearest);
  for i := 1 to MAX_AREA_COUNT do
    if not MainForm.IsUnusedArea(Areas[i]) then
    begin
      //Inc(AreaCount);
      db := TDiagramBlock.Create(LayoutDiagram);
      SetDiagramBlockDefaults(db);
      db.Left := Round(WM * Areas[i].x1);
      db.Width := Round(WM * Areas[i].x2) - db.Left + 1;
      if db.Right > LayoutDiagram.Width then
        db.Width := db.Width - (db.Right - LayoutDiagram.Width);
      db.Top := Round(HM * Areas[i].y1);
      db.Height := Round(HM * Areas[i].y2 - db.Top + 1);
      if db.Bottom > LayoutDiagram.Height then
        db.Height := db.Height - (db.Bottom - LayoutDiagram.Height);
      db.Diagram := LayoutDiagram;
      //db.Strings.Add(IntToStr(AreaCount));
      //db.TextCells[0].Alignment := taCenter;
      //db.TextCells[1].VertAlign := vaCenter;
    end;
  //db.Height := db.Height - DIAGRAM_BORDER_OFFSET;

  if LayoutDiagram.BlockCount = 0 then
    AddAreaBtn.Click;

  LoadingLayout := False;
end;

procedure TLayoutDesignerForm.TntFormShow(Sender: TObject);
begin
  LayoutDiagram.Width := LayoutDiagram.Width + DIAGRAM_BORDER_OFFSET;
  LayoutDiagram.Height := LayoutDiagram.Height + DIAGRAM_BORDER_OFFSET;
  //AddAreaBtn.Enabled := LayoutDiagram.BlockCount < MAX_AREA_COUNT;
  //RemoveSelectedAreaBtn.Enabled := LayoutDiagram.BlockCount > 1;
  SaveOriginalState;
  DesignPanel.SetFocus;

  InitializeOldBlocksRect;
  
  CheckOldBlocksRect := True;
end;

procedure TLayoutDesignerForm.TntToolButton1Click(Sender: TObject);
begin
  AlignSelecteds(LayoutDiagram, 0, -1, -1, -1);
end;

procedure TLayoutDesignerForm.TntToolButton3Click(Sender: TObject);
begin
  AlignSelecteds(LayoutDiagram, -1, -1, LayoutDiagram.Width - DIAGRAM_BORDER_OFFSET, -1);
end;

procedure TLayoutDesignerForm.TntToolButton5Click(Sender: TObject);
begin
  AlignSelecteds(LayoutDiagram, -1, 0, -1, -1);
end;

procedure TLayoutDesignerForm.TntToolButton7Click(Sender: TObject);
begin
  AlignSelecteds(LayoutDiagram, -1, -1, -1, LayoutDiagram.Height - DIAGRAM_BORDER_OFFSET);
end;

procedure TLayoutDesignerForm.TntToolButton2Click(Sender: TObject);
begin
  AlignSelectedsCenter(LayoutDiagram, True, False);
end;

procedure TLayoutDesignerForm.AlignSelectedsCenter(ADiagram: TatDiagram;
  Horizontally, Vertically: Boolean);
var
  i: Integer;
begin
  if ADiagram.SelectedCount > 0 then
  begin
    for i := 0 to ADiagram.SelectedCount - 1 do
    begin
      if Horizontally then
        (ADiagram.Selecteds[i] as TDiagramBlock).Left := Trunc((ADiagram.Width - DIAGRAM_BORDER_OFFSET) / 2 - (ADiagram.Selecteds[i] as TDiagramBlock).Width / 2);
      if Vertically then
        (ADiagram.Selecteds[i] as TDiagramBlock).Top := Trunc((ADiagram.Height - DIAGRAM_BORDER_OFFSET) / 2 - (ADiagram.Selecteds[i] as TDiagramBlock).Height / 2);
    end;
  end;
end;

procedure TLayoutDesignerForm.TntToolButton6Click(Sender: TObject);
begin
  AlignSelectedsCenter(LayoutDiagram, False, True);
end;

procedure TLayoutDesignerForm.RemoveSelectedAreaBtnClick(Sender: TObject);
begin
  if LayoutDiagram.SelectedCount = 0 then
    WideMessageDlgSound(Dyn_Texts[59] {'Please select a layout to remove it.'}, mtInformation, [mbOK], 0)
  else if LayoutDiagram.BlockCount = 1 then
    WideMessageDlgSound(Dyn_Texts[60] {'At least one display area must exist on the screen.'}, mtInformation, [mbOK], 0);

  try
    if LayoutDiagram.BlockCount = 1 then
      Exit;

    if (LayoutDiagram.BlockCount - LayoutDiagram.SelectedCount) <= 0 then
      LayoutDiagram.Selecteds[0].Selected := False;

    LayoutDiagram.DeleteSelecteds;
  finally
    //AddAreaBtn.Enabled := LayoutDiagram.BlockCount < MAX_AREA_COUNT;
    //RemoveSelectedAreaBtn.Enabled := LayoutDiagram.BlockCount > 1;
  end;
end;

procedure TLayoutDesignerForm.SetDiagramBlockDefaults(db: TDiagramBlock);
begin
  db.Restrictions := [crNoRotation];

  db.MinWidth := 10;
  db.MinHeight := 10;

  db.Cursor := crHandPoint;

  //Gradient
  db.Gradient.Direction := grInOut;
  db.Gradient.Visible := True;
  db.Gradient.StartColor := clWhite;
  db.Gradient.EndColor := clBlue;

  //Text
  db.Alignment := taCenter;
  db.VertAlign := vaCenter;
  db.Font.Color := clRed;
  SetDiagramBlockText(db);
end;

procedure TLayoutDesignerForm.AddAreaBtnClick(Sender: TObject);
var
  db: TDiagramBlock;
begin
  if LayoutDiagram.BlockCount >= MAX_AREA_COUNT then
    WideMessageDlgSound(WideFormat(Dyn_Texts[61] {'You can have maximum of %s separate display areas on the screen.'}, [IntToStr(MAX_AREA_COUNT)]), mtInformation, [mbOK], 0);

  if LayoutDiagram.BlockCount < MAX_AREA_COUNT then
  begin
    db := TDiagramBlock.Create(LayoutDiagram);
    SetDiagramBlockDefaults(db);
    db.Diagram := LayoutDiagram;
  end;
  //AddAreaBtn.Enabled := LayoutDiagram.BlockCount < MAX_AREA_COUNT;
  //RemoveSelectedAreaBtn.Enabled := LayoutDiagram.BlockCount > 1;
end;

procedure TLayoutDesignerForm.DiagramBlockToArea(DBlock: TCustomDiagramBlock; var x1, y1, x2, y2: Integer);
var
  WM, HM: Double;
begin
  WM := (GlobalOptions.LEDDisplaySettings.Width - 1) / (LayoutDiagram.Width - DIAGRAM_BORDER_OFFSET);
  HM := (GlobalOptions.LEDDisplaySettings.Height - 1) / (LayoutDiagram.Height - DIAGRAM_BORDER_OFFSET);

  SetRoundMode(rmNearest);

  x1 := Round(DBlock.Left * WM);
  x2 := Round(DBlock.Right * WM);
  if x2 > (GlobalOptions.LEDDisplaySettings.Width - 1) then
    x2 := GlobalOptions.LEDDisplaySettings.Width - 1;
  y1 := Round(DBlock.Top * HM);
  y2 := Round(DBlock.Bottom * HM);
  if y2 > (GlobalOptions.LEDDisplaySettings.Height - 1) then
    y2 := GlobalOptions.LEDDisplaySettings.Height - 1;
end;

procedure TLayoutDesignerForm.GetAreasFromDiagram(var Areas: TAreasArray);
var
  i: Integer;
  x1, y1, x2, y2: Integer;
begin
  if not LayoutChanged then
  begin
    for i := 1 to MAX_AREA_COUNT do
    begin
      Areas[i].x1 := OriginalAreas[i].x1;
      Areas[i].x2 := OriginalAreas[i].x2;
      Areas[i].y1 := OriginalAreas[i].y1;
      Areas[i].y2 := OriginalAreas[i].y2;
    end;
    Exit;
  end;

  //ShowMessage('layout changed');

  for i := 1 to Length(Areas) do
    MainForm.SetAreaUnused(Areas[i]);

  for i := 0 to LayoutDiagram.BlockCount - 1 do
  begin
    DiagramBlockToArea(LayoutDiagram.Blocks[i], x1, y1, x2, y2);
    Areas[i + 1].x1 := x1;
    Areas[i + 1].x2 := x2;
    Areas[i + 1].y1 := y1;
    Areas[i + 1].y2 := y2;
  end;
end;

procedure TLayoutDesignerForm.OKBtnClick(Sender: TObject);
var
  Areas: TAreasArray;
begin
  GetAreasFromDiagram(Areas);
  ApplyAreaCorrection(Areas);

  if AreasIntersect then
  begin
    //if WideMessageDlgSound(Dyn_Texts[62] {'Areas intersect. This my cause display problems. Continue anyway?'}, mtWarning, [mbYes, mbNo], 0) = mrNo then
    //  Exit;
    WideMessageDlgSound(Dyn_Texts[123] {'Areas intersect. This my cause display problems. Please change layout and size of the display areas and then press OK.'}, mtWarning, [mbOK], 0);
    Exit;
  end;
  GetAreasFromDiagram(ResultLayout);
  ModalResult := mrOk;
end;

procedure TLayoutDesignerForm.SetLayout(var Areas: TAreasArray);
var
  i: Integer;
begin
  for i := 1 to Length(Areas) do
  begin
    Areas[i].x1 := ResultLayout[i].x1;
    Areas[i].x2 := ResultLayout[i].x2;
    Areas[i].y1 := ResultLayout[i].y1;
    Areas[i].y2 := ResultLayout[i].y2;
    Areas[i].SizeChangingMode := scNone;
  end;
end;

procedure TLayoutDesignerForm.TntFormHide(Sender: TObject);
begin
  LayoutDiagram.Width := LayoutDiagram.Width - DIAGRAM_BORDER_OFFSET;
  LayoutDiagram.Height := LayoutDiagram.Height - DIAGRAM_BORDER_OFFSET;
end;

procedure TLayoutDesignerForm.SaveOriginalState;
var
  i: Integer;
begin
  OriginalBlockCount := LayoutDiagram.BlockCount;
  for i := 0 to LayoutDiagram.BlockCount - 1 do
    DiagramBlocksOriginalPos[i + 1] := LayoutDiagram.Blocks[i].BoundsRect;
  for i := LayoutDiagram.BlockCount + 1 to MAX_AREA_COUNT do
    DiagramBlocksOriginalPos[i] := Rect(0, 0, 0, 0);
end;

function TLayoutDesignerForm.LayoutChanged: Boolean;
var
  i: Integer;
begin
  Result := True;

  if OriginalBlockCount <> LayoutDiagram.BlockCount then
    Exit;
  for i := 0 to LayoutDiagram.BlockCount - 1 do
    if (LayoutDiagram.Blocks[i].Left <> DiagramBlocksOriginalPos[i + 1].Left) or
       (LayoutDiagram.Blocks[i].Right <> DiagramBlocksOriginalPos[i + 1].Right) or
       (LayoutDiagram.Blocks[i].Top <> DiagramBlocksOriginalPos[i + 1].Top) or
       (LayoutDiagram.Blocks[i].Bottom <> DiagramBlocksOriginalPos[i + 1].Bottom) then
    begin
      Exit;
    end;

  Result := False;
end;

procedure TLayoutDesignerForm.TntToolButton9Click(Sender: TObject);
begin
  LayoutDiagram.Width := LayoutDiagram.Width - DIAGRAM_BORDER_OFFSET;
  LayoutDiagram.Height := LayoutDiagram.Height - DIAGRAM_BORDER_OFFSET;

  PrepareLayout(OriginalAreas);

  LayoutDiagram.Width := LayoutDiagram.Width + DIAGRAM_BORDER_OFFSET;
  LayoutDiagram.Height := LayoutDiagram.Height + DIAGRAM_BORDER_OFFSET;
end;

procedure TLayoutDesignerForm.LayoutDiagramModified(Sender: TObject);
  function RectsEqual(R1, R2: TRect): Boolean;
  begin
    Result := (R1.Left = R2.Left) and (R1.Right = R2.Right) and
              (R1.Top = R2.Top) and (R1.Bottom = R2.Bottom);
  end;

var
  i, j: Integer;
  SelectedIndex: Integer;
  RestoreBoundsRect: Boolean;
begin
  if CheckOldBlocksRect then
  begin
    if LayoutDiagram.SelectedCount > 0 then
    begin
      RestoreBoundsRect := False;
      SelectedIndex := 0;
      for i := 0 to LayoutDiagram.BlockCount - 1 do
      begin
        for SelectedIndex := 0 to LayoutDiagram.SelectedCount - 1 do
        begin
          if LayoutDiagram.Blocks[i] <> LayoutDiagram.Selecteds[SelectedIndex] then
            if not RectsEqual(LayoutDiagram.Blocks[i].BoundsRect, OldBlocksRect[i]) then
            begin
              RestoreBoundsRect := True;
              Break;
            end;
        end;
        if RestoreBoundsRect then
          Break;
      end;

      if RestoreBoundsRect then
      begin
        for i := 0 to LayoutDiagram.BlockCount - 1 do
          for SelectedIndex := 0 to LayoutDiagram.SelectedCount - 1 do
            if LayoutDiagram.Blocks[i] <> LayoutDiagram.Selecteds[SelectedIndex] then
            begin
              if not RectsEqual(Rect(0, 0, 0, 0), OldBlocksRect[i]) then
                LayoutDiagram.Blocks[i].BoundsRect := OldBlocksRect[i];
            end;
      end;
    end;
  end;

  for i := 0 to LayoutDiagram.BlockCount - 1 do
  begin
    if (LayoutDiagram.Blocks[i] as TDiagramBlock).Width < 20 then
      (LayoutDiagram.Blocks[i] as TDiagramBlock).Width := 20;

    if (LayoutDiagram.Blocks[i] as TDiagramBlock).Height < 20 then
      (LayoutDiagram.Blocks[i] as TDiagramBlock).Height := 20;

    if (LayoutDiagram.Blocks[i] as TDiagramBlock).Left > (LayoutDiagram.Width - 5) then
      (LayoutDiagram.Blocks[i] as TDiagramBlock).Left := LayoutDiagram.Width - (LayoutDiagram.Blocks[i] as TDiagramBlock).Width;

    if (LayoutDiagram.Blocks[i] as TDiagramBlock).Top > (LayoutDiagram.Height - 5) then
      (LayoutDiagram.Blocks[i] as TDiagramBlock).Top := LayoutDiagram.Height - (LayoutDiagram.Blocks[i] as TDiagramBlock).Height;

    SetDiagramBlockText(LayoutDiagram.Blocks[i]);
  end;

  LayoutWarningImage.Visible := AreasIntersect;
  LayoutWarningLabel.Visible := AreasIntersect;

  if CheckOldBlocksRect then
    InitializeOldBlocksRect;
end;

procedure TLayoutDesignerForm.TntFormCreate(Sender: TObject);
begin
  LoadingLayout := False;

  CheckOldBlocksRect := False;

  LayoutDesignerToolbar.Width := LayoutDesignerToolbar.Width + DIAGRAM_BORDER_OFFSET;
  SelectLayoutBtn.ModalResult := mrSelectLayout;
end;

function TLayoutDesignerForm.AreasIntersect: Boolean;
  function Intersect(x1_1, x1_2, x2_1, x2_2: Integer): Boolean;
  begin
    Result := False;
    if (x1_2 < x2_1) or (x1_1 > x2_2) then
      Exit;
    Result := True;
    if (x1_1 >= x2_1) and (x1_1 <= x2_2) then
      Exit;
    if (x1_1 <= x2_1) and (x1_2 >= x2_1) then
      Exit;
    if (x1_2 >= x2_2) and (x1_1 <= x2_2) then
      Exit;
    Result := False;
  end;

var
  i, j: Integer;
  //dbi, dbj: TDiagramBlock;
  Areas: TAreasArray;
begin
  Result := True;
  GetAreasFromDiagram(Areas);
  for i := 1 to MAX_AREA_COUNT do
  if not MainForm.IsUnusedArea(Areas[i]) then
  begin
    for j := 1 to MAX_AREA_COUNT do
    if not MainForm.IsUnusedArea(Areas[j]) then
    begin
      if j <> i then
      begin
        if Intersect(Areas[i].x1, Areas[i].x2, Areas[j].x1, Areas[j].x2) then
        begin
          if Intersect(Areas[i].y1, Areas[i].y2, Areas[j].y1, Areas[j].y2) then
            Exit;
        end;
      end;
    end;
  end;
  {
  for i := 0 to LayoutDiagram.BlockCount - 1 do
  begin
    dbi := LayoutDiagram.Blocks[i] as TDiagramBlock;
    for j := 0 to LayoutDiagram.BlockCount - 1 do
    begin
      dbj := LayoutDiagram.Blocks[j] as TDiagramBlock;
      if j <> i then
      begin
        if Intersect(dbi.Left, dbi.Right, dbj.Left, dbj.Right) then
        begin
          if Intersect(dbi.Top, dbi.Bottom, dbj.Top, dbj.Bottom) then
            Exit;
        end;
      end;
    end;
  end;
  }
  Result := False;
end;

procedure TLayoutDesignerForm.LayoutDiagramDControlMouseDown(
  Sender: TObject; ADControl: TDiagramControl; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  ADControl.Cursor := crSizeAll;
  LayoutDiagram.Cursor := crSizeAll;
end;

procedure TLayoutDesignerForm.LayoutDiagramMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  i: Integer;
begin
  LayoutDiagram.Cursor := crDefault;
  for i := 0 to LayoutDiagram.BlockCount - 1 do
    LayoutDiagram.Blocks[i].Cursor := crHandPoint;
  Screen.Cursor := crDefault;
end;

procedure TLayoutDesignerForm.LayoutDiagramKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if Shift = [ssShift] then
  begin
    case Key of
      VK_LEFT:
        begin
          //Decrease width
          with LayoutDiagram.Selecteds[0] as TDiagramBlock do
            if Width > 1 then
              Width := Width - 1;
        end;
      VK_RIGHT:
        begin
          //Increase width
          with LayoutDiagram.Selecteds[0] as TDiagramBlock do
            if Width > 1 then
              Width := Width + 1;
        end;
      VK_UP:
        begin
          //Decrease height
          with LayoutDiagram.Selecteds[0] as TDiagramBlock do
            if Height > 1 then
              Height := Height - 1;
        end;
      VK_DOWN:
        begin
          //Increase height
          with LayoutDiagram.Selecteds[0] as TDiagramBlock do
            if Height > 1 then
              Height := Height + 1;
        end;
    end;
  end;
end;

procedure TLayoutDesignerForm.SetDiagramBlockText(db: TCustomDiagramBlock);
var
  x1, y1, x2, y2: Integer;
begin
  DiagramBlockToArea(db, x1, y1, x2, y2);
  if db.Strings.Count = 0 then
    db.Strings.Append('');

  db.Strings[0] :=  IntToStr(y2 - y1 + 1) + 'x' + IntToStr(x2 - x1 + 1);
end;

procedure TLayoutDesignerForm.ApplyAreaCorrection(
  const Areas: TAreasArray);
var
  i: Integer;
  db: TCustomDiagramBlock;
  WM, HM: Double;
begin
  LoadingLayout := True;

  WM := LayoutDiagram.Width / (GlobalOptions.LEDDisplaySettings.Width - 1);
  HM := LayoutDiagram.Height / (GlobalOptions.LEDDisplaySettings.Height - 1);

  //AreaCount := 0;
  SetRoundMode(rmNearest);
  for i := 1 to LayoutDiagram.BlockCount do
  begin
    db := LayoutDiagram.Blocks[i - 1];
    db.Left := Round(WM * Areas[i].x1);
    db.Width := Round(WM * Areas[i].x2) - db.Left + 1;
    if db.Right > LayoutDiagram.Width then
      db.Width := db.Width - (db.Right - LayoutDiagram.Width);
    db.Top := Round(HM * Areas[i].y1);
    db.Height := Round(HM * Areas[i].y2 - db.Top + 1);
    if db.Bottom > LayoutDiagram.Height then
      db.Height := db.Height - (db.Bottom - LayoutDiagram.Height);
    //db.Diagram := LayoutDiagram;
  end;
  //db.Height := db.Height - DIAGRAM_BORDER_OFFSET;

  if LayoutDiagram.BlockCount = 0 then
    AddAreaBtn.Click;

  LoadingLayout := False;
end;

procedure TLayoutDesignerForm.InitializeOldBlocksRect;
var
  i: Integer;
begin
  for i := 0 to LayoutDiagram.BlockCount - 1 do
    OldBlocksRect[i] := LayoutDiagram.Blocks[i].BoundsRect;
  for i := LayoutDiagram.BlockCount to High(OldBlocksRect) do
    OldBlocksRect[i] := Rect(0, 0, 0, 0);
end;

end.
