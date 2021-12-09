unit SpecialProcsUnit;

interface

uses
  Controls, Forms, Graphics, Types, Classes, Menus, ComCtrls, Windows, TntForms,
  TntStdCtrls, Consts;

type
  TGrowDirection = (gdToLeft, gdToRight, gdToTop, gdToBottom);

  TSpecialProcs = class(TObject)
  private
    GrowShrinkControls: array of TControl;

    function GetAveCharSize(Canvas: TCanvas): TPoint;
  protected
  public
      constructor Create; overload;
      destructor Destroy; reintroduce;

      function WideInputQueryWithFont(const ACaption, APrompt: WideString;
         AFont: TFont; var Value: WideString;
         const OKBtnCaption, CancelBtnCaption: WideString): Boolean;

      procedure FlipControls(const Controls: array of TControl);
      procedure FlipChildren(ParentControl: TWinControl; AllLevels: Boolean);
      procedure FlipChildrenExcept(ParentControl: TWinControl;
        const ExcludeTheseClasses: array of TComponentClass;
        AllLevels: Boolean);

      procedure PopupMenuAtControl(Control: TControl; PopupMenu: TPopupMenu);
      procedure PopupMenuAtControlBiDi(Control: TControl; PopupMenu: TPopupMenu;
        OverrideBiDiMode: TBiDiMode);

      function ReadToolbarSettings(AToolbar: TToolBar; const Key: String;
        const Value: String): Boolean;
      function WriteToolbarSettings(AToolbar: TToolBar; const Key: String;
        const Value: String): Boolean;

    procedure GrowShrink(Control: TControl; GrowDirection: TGrowDirection; LastSize: Integer; Step, Delay: Integer);
  published
  end;

var
  SpecialProcs: TSpecialProcs;

implementation

uses SysUtils, Math;

{ TSpecialProcs }

procedure TSpecialProcs.GrowShrink(Control: TControl;
  GrowDirection: TGrowDirection; LastSize: Integer; Step, Delay: Integer);
var
  StartSize: Integer;
  i: Integer;
  ArrayIndex: Integer;
begin
  case GrowDirection of
    gdToLeft, gdToRight:
      StartSize := Control.Width;
    gdToTop, gdToBottom:
      StartSize := Control.Height;
  end;

  if StartSize = LastSize then
    Exit;

  for i := 0 to High(GrowShrinkControls) do
    if GrowShrinkControls[i] = Control then
      Exit;

  SetLength(GrowShrinkControls, Length(GrowShrinkControls) + 1);
  ArrayIndex := High(GrowShrinkControls);
  GrowShrinkControls[ArrayIndex] := Control;

  if StartSize > LastSize then
    Step := - Abs(Step)
  else
    Step := Abs(Step);

  while StartSize * Sign(Step) < LastSize * Sign(Step) do
  begin
    StartSize := StartSize + Step;
    case GrowDirection of
      gdToLeft:
        begin
          Control.Width := StartSize;
          Control.Left := Control.Left - Step;
        end;
      gdToRight:
        begin
          Control.Width := StartSize;
        end;
    end;
    Sleep(Delay);
    Application.ProcessMessages;
  end;

  GrowShrinkControls[ArrayIndex] := nil;
  for i := 0 to High(GrowShrinkControls) do
    if Assigned(GrowShrinkControls[i]) then
      Exit;
  SetLength(GrowShrinkControls, 0);
end;

function TSpecialProcs.GetAveCharSize(Canvas: TCanvas): TPoint;
var
  I: Integer;
  Buffer: array[0..51] of WideChar;
begin
  for I := 0 to 25 do Buffer[I] := WideChar(I + Ord('A'));
  for I := 0 to 25 do Buffer[I + 26] := WideChar(I + Ord('a'));
  GetTextExtentPointW(Canvas.Handle, Buffer, 52, TSize(Result));
  Result.X := Result.X div 52;
end;

function TSpecialProcs.WideInputQueryWithFont(const ACaption,
  APrompt: WideString; AFont: TFont; var Value: WideString;
  const OKBtnCaption, CancelBtnCaption: WideString): Boolean;
var
  Form: TTntForm{TNT-ALLOW TTntForm};
  Prompt: TTntLabel;
  Edit: TTntEdit;
  DialogUnits: TPoint;
  ButtonTop, ButtonWidth, ButtonHeight: Integer;
begin
  Result := False;
  Form := TTntForm{TNT-ALLOW TTntForm}.Create(Application);
  with Form do begin
    try
      Font.Assign(AFont);
      Canvas.Font := Font;
      DialogUnits := GetAveCharSize(Canvas);
      BorderStyle := bsDialog;
      Caption := ACaption;
      ClientWidth := MulDiv(180, DialogUnits.X, 4);
      Position := poScreenCenter;
      Prompt := TTntLabel.Create(Form);
      with Prompt do
      begin
        Parent := Form;
        Caption := APrompt;
        Left := MulDiv(8, DialogUnits.X, 4);
        Top := MulDiv(8, DialogUnits.Y, 8);
        Constraints.MaxWidth := MulDiv(164, DialogUnits.X, 4);
        WordWrap := True;
      end;
      Edit := TTntEdit.Create(Form);
      with Edit do
      begin
        Parent := Form;
        Left := Prompt.Left;
        Top := Prompt.Top + Prompt.Height + 5;
        Width := MulDiv(164, DialogUnits.X, 4);
        MaxLength := 255;
        Text := Value;
        SelectAll;
      end;
      ButtonTop := Edit.Top + Edit.Height + 15;
      ButtonWidth := MulDiv(50, DialogUnits.X, 4);
      ButtonHeight := MulDiv(14, DialogUnits.Y, 8);
      with TTntButton.Create(Form) do
      begin
        Parent := Form;
        if Length(OKBtnCaption) = 0 then
          Caption := SMsgDlgOK
        else
          Caption := OKBtnCaption;
        ModalResult := mrOk;
        Default := True;
        SetBounds(MulDiv(38, DialogUnits.X, 4), ButtonTop, ButtonWidth,
          ButtonHeight);
      end;
      with TTntButton.Create(Form) do
      begin
        Parent := Form;
        if Length(CancelBtnCaption) = 0 then
          Caption := SMsgDlgCancel
        else
          Caption := CancelBtnCaption;
        ModalResult := mrCancel;
        Cancel := True;
        SetBounds(MulDiv(92, DialogUnits.X, 4), Edit.Top + Edit.Height + 15, ButtonWidth,
          ButtonHeight);
        Form.ClientHeight := Top + Height + 13;
      end;
      if ShowModal = mrOk then
      begin
        Value := Edit.Text;
        Result := True;
      end;
    finally
      Form.Free;
    end;
  end;
end;

procedure TSpecialProcs.FlipControls(const Controls: array of TControl);

  procedure DoFlipControl(Control: TControl);
  var
    TheWidth: Integer;
    RealignAssociated: Boolean;
  begin
//    RealignAssociated := False;
    TheWidth := Control.Parent.ClientWidth;
//    if (Control.Owner = Control.Parent.Owner) then
//    begin
      RealignAssociated := True;
      Control.Left := TheWidth - Control.Width - Control.Left;
//    end;
    { Allow controls that have associations to realign themselves }
    if RealignAssociated then
      TControl(Control).Perform(CM_ALLCHILDRENFLIPPED, 0, 0);
  end;

  procedure FlipControl(Control: TControl);
  var
    CorrectAlign: Boolean;
  begin
    CorrectAlign := Control.Align in [alLeft, alRight];
    try
      //Correct anchor settings
      if (akLeft in Control.Anchors) and not (akRight in Control.Anchors) then
          Control.Anchors := Control.Anchors - [akLeft] + [akRight]
        else if (akRight in Control.Anchors) and not (akLeft in Control.Anchors) then
          Control.Anchors := Control.Anchors - [akRight] + [akLeft];

      DoFlipControl(Control);
    finally
      if CorrectAlign then
      begin
        if Control.Align = alLeft then
          Control.Align := alRight
        else
          Control.Align := alLeft;
      end;
    end;

  end;

var
  Loop: Integer;
begin
  try
    for Loop := 0 to High(Controls) do
    begin
      Controls[Loop].Parent.DisableAlign;
      FlipControl(Controls[Loop]);
    end;
  finally
    for Loop := 0 to High(Controls) do
      if Controls[Loop].Parent.AlignDisabled then
        Controls[Loop].Parent.EnableAlign;
  end;
end;

procedure TSpecialProcs.FlipChildren(ParentControl: TWinControl;
  AllLevels: Boolean);

procedure DoFlipChildren;
var
  Loop: Integer;
  TheWidth: Integer;
  FlippedList: TList;
begin
  FlippedList := TList.Create;
  try
    TheWidth := ParentControl.ClientWidth;
    for Loop := 0 to ParentControl.ControlCount - 1 do
      with ParentControl.Controls[Loop] do
//        if (Owner = ParentControl.Owner) then
        begin
          FlippedList.Add(ParentControl.Controls[Loop]);
          Left := TheWidth - Width - Left;
        end;
    { Allow controls that have associations to realign themselves }
    for Loop := 0 to FlippedList.Count - 1 do
      TControl(FlippedList[Loop]).Perform(CM_ALLCHILDRENFLIPPED, 0, 0);
  finally
    FlippedList.Free;
  end;
end;

var
  Loop: Integer;
  AlignList: TList;
begin
  if ParentControl.ControlCount = 0 then Exit;
  AlignList := TList.Create;
  ParentControl.DisableAlign;
  try
    { Collect all the Right and Left alignments }
    for Loop := 0 to ParentControl.ControlCount - 1 do
      with ParentControl.Controls[Loop] do
      begin
        if Align in [alLeft, alRight] then
          AlignList.Add(ParentControl.Controls[Loop]);
        //Correct anchor settings
        if (akLeft in Anchors) and not (akRight in Anchors) then
          Anchors := Anchors - [akLeft] + [akRight]
        else if (akRight in Anchors) and not (akLeft in Anchors) then
          Anchors := Anchors - [akRight] + [akLeft];
      end;
    { Flip 'em }
    DoFlipChildren;
  finally
    { Reverse the Right and Left alignments }
    while AlignList.Count > 0 do
    begin
      with TControl(AlignList.Items[AlignList.Count - 1]) do
        if Align = alLeft then
          Align := alRight
        else
          Align := alLeft;
      AlignList.Delete(AlignList.Count - 1);
    end;
    AlignList.Free;
    ParentControl.EnableAlign;
  end;
  if AllLevels then
    for Loop := 0 to ParentControl.ControlCount - 1 do
      if ParentControl.Controls[Loop] is TWinControl then
        FlipChildren(TWinControl(ParentControl.Controls[Loop]), True);
end;

procedure TSpecialProcs.FlipChildrenExcept(ParentControl: TWinControl;
  const ExcludeTheseClasses: array of TComponentClass; AllLevels: Boolean);

  function ExcludeControl(Control: TControl): Boolean;
  var
    i: Integer;
  begin
    Result := False;
    for i := 0 to High(ExcludeTheseClasses) do
      if Control is ExcludeTheseClasses[i] then
      begin
        Result := True;
        Exit;
      end;
  end;

var
  i: Integer;
  FlipList: array of TControl;
begin
  FlipChildren(ParentControl, False);

  //Exclude controls
  SetLength(FlipList, 0);
  for i := 0 to ParentControl.ControlCount - 1 do
    if ExcludeControl(ParentControl.Controls[i]) then
    begin
      SetLength(FlipList, Length(FlipList) + 1);
      FlipList[High(FlipList)] := ParentControl.Controls[i];
    end;
  FlipControls(FlipList);
  SetLength(FlipList, 0);

  if AllLevels then
    for i := 0 to ParentControl.ControlCount - 1 do
      if ParentControl.Controls[i] is TWinControl then
        FlipChildrenExcept(TWinControl(ParentControl.Controls[i]), ExcludeTheseClasses, True);
end;

procedure TSpecialProcs.PopupMenuAtControlBiDi(Control: TControl;
  PopupMenu: TPopupMenu; OverrideBiDiMode: TBiDiMode);
var
  P:TPoint;
begin
  if (OverrideBiDiMode = bdRightToLeft) and SysLocale.MiddleEast then
    P := Control.Parent.ClientToScreen(Point((Control.Left + Control.Width), Control.Top + Control.Height))
  else
    P := Control.Parent.ClientToScreen(Point(Control.Left, Control.Top + Control.Height));
  PopupMenu.Popup(P.X, P.Y);
end;

procedure TSpecialProcs.PopupMenuAtControl(Control: TControl;
  PopupMenu: TPopupMenu);
var
  P:TPoint;
begin
  if (PopupMenu.BiDiMode = bdRightToLeft) and SysLocale.MiddleEast then
    P := Control.Parent.ClientToScreen(Point((Control.Left + Control.Width), Control.Top + Control.Height))
  else
    P := Control.Parent.ClientToScreen(Point(Control.Left, Control.Top + Control.Height));
  PopupMenu.Popup(P.X, P.Y);
end;

constructor TSpecialProcs.Create;
begin
  inherited;

end;

destructor TSpecialProcs.Destroy;
begin

  inherited;
end;

function TSpecialProcs.ReadToolbarSettings(AToolbar: TToolBar; const Key,
  Value: String): Boolean;
begin

end;

function TSpecialProcs.WriteToolbarSettings(AToolbar: TToolBar; const Key,
  Value: String): Boolean;
begin

end;

initialization
  SpecialProcs := TSpecialProcs.Create;

finalization
  SpecialProcs.Free;
end.
