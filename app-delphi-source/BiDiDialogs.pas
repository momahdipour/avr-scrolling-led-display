unit BiDiDialogs;

interface

uses
  Windows, Forms, Dialogs, Graphics, Types, StdCtrls, Classes, SysUtils,
  Consts, Controls, Math, ExtCtrls;

function CreateMessageDialogBiDi(const Msg: string; DlgType: TMsgDlgType;
  Buttons: TMsgDlgButtons; BiDiModeParam: TBiDiMode): TForm;

function MessageDlgBiDi(const Msg: string; DlgType: TMsgDlgType;
  Buttons: TMsgDlgButtons; HelpCtx: Longint; BiDiMode: TBiDiMode): Integer;
function MessageDlgPosBiDi(const Msg: string; DlgType: TMsgDlgType;
  Buttons: TMsgDlgButtons; HelpCtx: Longint; X, Y: Integer;
  BiDiMode: TBiDiMode): Integer;
function MessageDlgPosHelpBiDi(const Msg: string; DlgType: TMsgDlgType;
  Buttons: TMsgDlgButtons; HelpCtx: Longint; X, Y: Integer;
  const HelpFileName: string; BiDiMode: TBiDiMode): Integer;

procedure ShowMessageBiDi(const Msg: string; BiDiMode: TBiDiMode);
procedure ShowMessageFmtBiDi(const Msg: string; Params: array of const;
  BiDiMode: TBiDiMode);
procedure ShowMessagePosBiDi(const Msg: string; X, Y: Integer;
  BiDiMode: TBiDiMode);

var
  BiDiMessageCaptions: array[TMsgDlgType] of String;
  BiDiMessageDlgButtonCursor: TCursor = crDefault;

implementation

{ ========================================================================}
{ BiDiMode Dialogs                                                        }
{ ========================================================================}

{ Message dialog }

function GetAveCharSize(Canvas: TCanvas): TPoint;
var
  I: Integer;
  Buffer: array[0..51] of Char;
begin
  for I := 0 to 25 do Buffer[I] := Chr(I + Ord('A'));
  for I := 0 to 25 do Buffer[I + 26] := Chr(I + Ord('a'));
  GetTextExtentPoint(Canvas.Handle, Buffer, 52, TSize(Result));
  Result.X := Result.X div 52;
end;


type
  TMessageForm = class(TForm)
  private
    Message: TLabel;
    procedure HelpButtonClick(Sender: TObject);
  protected
    procedure CustomKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure WriteToClipBoard(Text: String);
    function GetFormText: String;
  public
    constructor CreateNew(AOwner: TComponent); reintroduce;
  end;

constructor TMessageForm.CreateNew(AOwner: TComponent);
var
  NonClientMetrics: TNonClientMetrics;
begin
  inherited CreateNew(AOwner);
  NonClientMetrics.cbSize := sizeof(NonClientMetrics);
  if SystemParametersInfo(SPI_GETNONCLIENTMETRICS, 0, @NonClientMetrics, 0) then
    Font.Handle := CreateFontIndirect(NonClientMetrics.lfMessageFont);
end;

procedure TMessageForm.HelpButtonClick(Sender: TObject);
begin
  Application.HelpContext(HelpContext);
end;

procedure TMessageForm.CustomKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if (Shift = [ssCtrl]) and (Key = Word('C')) then
  begin
    Beep;
    WriteToClipBoard(GetFormText);
  end;
end;

procedure TMessageForm.WriteToClipBoard(Text: String);
var
  Data: THandle;
  DataPtr: Pointer;
begin
  if OpenClipBoard(0) then
  begin
    try
      Data := GlobalAlloc(GMEM_MOVEABLE+GMEM_DDESHARE, Length(Text) + 1);
      try
        DataPtr := GlobalLock(Data);
        try
          Move(PChar(Text)^, DataPtr^, Length(Text) + 1);
          EmptyClipBoard;
          SetClipboardData(CF_TEXT, Data);
        finally
          GlobalUnlock(Data);
        end;
      except
        GlobalFree(Data);
        raise;
      end;
    finally
      CloseClipBoard;
    end;
  end
  else
    raise Exception.CreateRes(@SCannotOpenClipboard);
end;

function TMessageForm.GetFormText: String;
var
  DividerLine, ButtonCaptions: string;
  I: integer;
begin
  DividerLine := StringOfChar('-', 27) + sLineBreak;
  for I := 0 to ComponentCount - 1 do
    if Components[I] is TButton then
      ButtonCaptions := ButtonCaptions + TButton(Components[I]).Caption +
        StringOfChar(' ', 3);
  ButtonCaptions := StringReplace(ButtonCaptions,'&','', [rfReplaceAll]);
  Result := Format('%s%s%s%s%s%s%s%s%s%s', [DividerLine, Caption, sLineBreak,
    DividerLine, Message.Caption, sLineBreak, DividerLine, ButtonCaptions,
    sLineBreak, DividerLine]);
end;

var
  Captions: array[TMsgDlgType] of Pointer = (@SMsgDlgWarning, @SMsgDlgError,
    @SMsgDlgInformation, @SMsgDlgConfirm, nil);
  IconIDs: array[TMsgDlgType] of PChar = (IDI_EXCLAMATION, IDI_HAND,
    IDI_ASTERISK, IDI_QUESTION, nil);
  ButtonNames: array[TMsgDlgBtn] of string = (
    'Yes', 'No', 'OK', 'Cancel', 'Abort', 'Retry', 'Ignore', 'All', 'NoToAll',
    'YesToAll', 'Help');
  ButtonCaptions: array[TMsgDlgBtn] of Pointer = (
    @SMsgDlgYes, @SMsgDlgNo, @SMsgDlgOK, @SMsgDlgCancel, @SMsgDlgAbort,
    @SMsgDlgRetry, @SMsgDlgIgnore, @SMsgDlgAll, @SMsgDlgNoToAll, @SMsgDlgYesToAll,
    @SMsgDlgHelp);
  ModalResults: array[TMsgDlgBtn] of Integer = (
    mrYes, mrNo, mrOk, mrCancel, mrAbort, mrRetry, mrIgnore, mrAll, mrNoToAll,
    mrYesToAll, 0);
var
  ButtonWidths : array[TMsgDlgBtn] of integer;  // initialized to zero

function GetMessageCaptionBiDi(MsgType: TMsgDlgType): String;
begin
  try
    Result := BiDiMessageCaptions[MsgType];
  except
    raise EInvalidArgument.Create('Unexpected MsgType in GetMessageCaption in SoundDialogs.');
  end;

{  case MsgType of
    mtWarning:      Result := SMsgDlgWarning;
    mtError:        Result := SMsgDlgError;
    mtInformation:  Result := SMsgDlgInformation;
    mtConfirmation: Result := SMsgDlgConfirm;
    mtCustom:       Result := '';
    else
      raise ETntInternalError.Create('Unexpected MsgType in GetMessageCaption.');
  end;}
end;

function CreateMessageDialogBiDi(const Msg: string; DlgType: TMsgDlgType;
  Buttons: TMsgDlgButtons; BiDiModeParam: TBiDiMode): TForm;
const
  mcHorzMargin = 8;
  mcVertMargin = 8;
  mcHorzSpacing = 10;
  mcVertSpacing = 10;
  mcButtonWidth = 50;
  mcButtonHeight = 14;
  mcButtonSpacing = 4;
var
  DialogUnits: TPoint;
  HorzMargin, VertMargin, HorzSpacing, VertSpacing, ButtonWidth,
  ButtonHeight, ButtonSpacing, ButtonCount, ButtonGroupWidth,
  IconTextWidth, IconTextHeight, X, ALeft: Integer;
  B, DefaultButton, CancelButton: TMsgDlgBtn;
  IconID: PChar;
  IconImage: TImage;
  TextRect: TRect;
begin
  Result := TMessageForm.CreateNew(Application);
  with Result do
  begin
    BiDiMode := BiDiModeParam;
    BorderStyle := bsDialog;
    Canvas.Font := Font;
    KeyPreview := True;
    OnKeyDown := TMessageForm(Result).CustomKeyDown;
    DialogUnits := GetAveCharSize(Canvas);
    HorzMargin := MulDiv(mcHorzMargin, DialogUnits.X, 4);
    VertMargin := MulDiv(mcVertMargin, DialogUnits.Y, 8);
    HorzSpacing := MulDiv(mcHorzSpacing, DialogUnits.X, 4);
    VertSpacing := MulDiv(mcVertSpacing, DialogUnits.Y, 8);
    ButtonWidth := MulDiv(mcButtonWidth, DialogUnits.X, 4);
    for B := Low(TMsgDlgBtn) to High(TMsgDlgBtn) do
    begin
      if B in Buttons then
      begin
        if ButtonWidths[B] = 0 then
        begin
          TextRect := Rect(0,0,0,0);
          Windows.DrawText( canvas.handle,
            PChar(LoadResString(ButtonCaptions[B])), -1,
            TextRect, DT_CALCRECT or DT_LEFT or DT_SINGLELINE or
            IfThen(SysLocale.MiddleEast and (BiDiModeParam <> bdLeftToRight), DT_RTLREADING, 0));
          with TextRect do ButtonWidths[B] := Right - Left + 8;
        end;
        if ButtonWidths[B] > ButtonWidth then
          ButtonWidth := ButtonWidths[B];
      end;
    end;
    ButtonHeight := MulDiv(mcButtonHeight, DialogUnits.Y, 8);
    ButtonSpacing := MulDiv(mcButtonSpacing, DialogUnits.X, 4);
    SetRect(TextRect, 0, 0, Screen.Width div 2, 0);
    DrawText(Canvas.Handle, PChar(Msg), Length(Msg)+1, TextRect,
      DT_EXPANDTABS or DT_CALCRECT or DT_WORDBREAK or
      IfThen(SysLocale.MiddleEast and (BiDiModeParam <> bdLeftToRight), DT_RTLREADING, 0));
    IconID := IconIDs[DlgType];
    IconTextWidth := TextRect.Right;
    IconTextHeight := TextRect.Bottom;
    if IconID <> nil then
    begin
      Inc(IconTextWidth, 32 + HorzSpacing);
      if IconTextHeight < 32 then IconTextHeight := 32;
    end;
    ButtonCount := 0;
    for B := Low(TMsgDlgBtn) to High(TMsgDlgBtn) do
      if B in Buttons then Inc(ButtonCount);
    ButtonGroupWidth := 0;
    if ButtonCount <> 0 then
      ButtonGroupWidth := ButtonWidth * ButtonCount +
        ButtonSpacing * (ButtonCount - 1);
    ClientWidth := Max(IconTextWidth, ButtonGroupWidth) + HorzMargin * 2;
    ClientHeight := IconTextHeight + ButtonHeight + VertSpacing +
      VertMargin * 2;
    Left := (Screen.Width div 2) - (Width div 2);
    Top := (Screen.Height div 2) - (Height div 2);
//    if DlgType <> mtCustom then
      Caption := GetMessageCaptionBiDi(DlgType); //LoadResString(Captions[DlgType]) else
//      Caption := Application.Title;
    if (Caption = EmptyStr) and (DlgType = mtCustom) then
      Caption := Application.Title;
    IconImage := nil;
    if IconID <> nil then
    begin
      IconImage := TImage.Create(Result);
      with IconImage do
      begin
        Name := 'Image';
        Parent := Result;
        Picture.Icon.Handle := LoadIcon(0, IconID);
        SetBounds(HorzMargin, VertMargin, 32, 32);
      end;
    end;
    TMessageForm(Result).Message := TLabel.Create(Result);
    with TMessageForm(Result).Message do
    begin
      Name := 'Message';
      Parent := Result;
      WordWrap := True;
      Caption := Msg;
      BoundsRect := TextRect;
      ParentBiDiMode := True;
      ALeft := IconTextWidth - TextRect.Right + HorzMargin;
      if SysLocale.MiddleEast and (BiDiModeParam = bdRightToLeft) then
      begin
        ALeft := Result.ClientWidth - ALeft - Width;
        if Assigned(IconImage) then
          IconImage.Left := Result.ClientWidth - IconImage.Left - IconImage.Width;
      end;
      SetBounds(ALeft, VertMargin,
        TextRect.Right, TextRect.Bottom);
    end;
    if mbOk in Buttons then DefaultButton := mbOk else
      if mbYes in Buttons then DefaultButton := mbYes else
        DefaultButton := mbRetry;
    if mbCancel in Buttons then CancelButton := mbCancel else
      if mbNo in Buttons then CancelButton := mbNo else
        CancelButton := mbOk;
    X := (ClientWidth - ButtonGroupWidth) div 2;
    for B := Low(TMsgDlgBtn) to High(TMsgDlgBtn) do
      if B in Buttons then
        with TButton.Create(Result) do
        begin
          Name := ButtonNames[B];
          Parent := Result;
          ParentBiDiMode := False;
          BiDiMode := Result.BiDiMode;
          Caption := LoadResString(ButtonCaptions[B]);
          Cursor := BiDiMessageDlgButtonCursor;
          ModalResult := ModalResults[B];
          if B = DefaultButton then Default := True;
          if B = CancelButton then Cancel := True;
          SetBounds(X, IconTextHeight + VertMargin + VertSpacing,
            ButtonWidth, ButtonHeight);
          Inc(X, ButtonWidth + ButtonSpacing);
          if B = mbHelp then
            OnClick := TMessageForm(Result).HelpButtonClick;
        end;
  end;
end;

function MessageDlgBiDi(const Msg: string; DlgType: TMsgDlgType;
  Buttons: TMsgDlgButtons; HelpCtx: Longint; BiDiMode: TBiDiMode): Integer;
begin
  Result := MessageDlgPosHelpBiDi(Msg, DlgType, Buttons, HelpCtx, -1, -1, '',
              BiDiMode);
end;

function MessageDlgPosBiDi(const Msg: string; DlgType: TMsgDlgType;
  Buttons: TMsgDlgButtons; HelpCtx: Longint; X, Y: Integer;
  BiDiMode: TBiDiMode): Integer;
begin
  Result := MessageDlgPosHelpBiDi(Msg, DlgType, Buttons, HelpCtx, X, Y, '',
              BiDiMode);
end;

function MessageDlgPosHelpBiDi(const Msg: string; DlgType: TMsgDlgType;
  Buttons: TMsgDlgButtons; HelpCtx: Longint; X, Y: Integer;
  const HelpFileName: string; BiDiMode: TBiDiMode): Integer;
begin
  with CreateMessageDialogBiDi(Msg, DlgType, Buttons, BiDiMode) do
    try
      HelpContext := HelpCtx;
      HelpFile := HelpFileName;
      if X >= 0 then Left := X;
      if Y >= 0 then Top := Y;
      if (Y < 0) and (X < 0) then Position := poScreenCenter;
      Result := ShowModal;
    finally
      Free;
    end;
end;

procedure ShowMessageBiDi(const Msg: string; BiDiMode: TBiDiMode);
begin
  ShowMessagePosBiDi(Msg, -1, -1, BiDiMode);
end;

procedure ShowMessageFmtBiDi(const Msg: string; Params: array of const;
  BiDiMode: TBiDiMode);
begin
  ShowMessageBiDi(Format(Msg, Params), BiDiMode);
end;

procedure ShowMessagePosBiDi(const Msg: string; X, Y: Integer; BiDiMode: TBiDiMode);
begin
  MessageDlgPosBiDi(Msg, mtCustom, [mbOK], 0, X, Y, BiDiMode);
end;

initialization
  //Message dialog window captions
  BiDiMessageCaptions[mtWarning] := LoadResString(Captions[mtWarning]);
  BiDiMessageCaptions[mtError] := LoadResString(Captions[mtError]);
  BiDiMessageCaptions[mtInformation] := LoadResString(Captions[mtInformation]);
  BiDiMessageCaptions[mtConfirmation] := LoadResString(Captions[mtConfirmation]);
  BiDiMessageCaptions[mtCustom] := EmptyStr;  //To be set to title of the application if empty string

  BiDiMessageDlgButtonCursor := crDefault;  //Also default value is set directly where this global variable is defined

finalization

end.
