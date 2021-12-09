unit BiDiSoundDialogs;

interface

uses
  BiDiDialogs, Dialogs, Windows, Forms, Classes;

 { Standard Dialogs }

function MessageDlgBiDiSound(const Msg: string; DlgType: TMsgDlgType;
  Buttons: TMsgDlgButtons; HelpCtx: Longint; BiDiMode: TBiDiMode): Integer;
function MessageDlgPosBiDiSound(const Msg: string; DlgType: TMsgDlgType;
  Buttons: TMsgDlgButtons; HelpCtx: Longint; X, Y: Integer;
  BiDiMode: TBiDiMode): Integer;
function MessageDlgPosHelpBiDiSound(const Msg: string; DlgType: TMsgDlgType;
  Buttons: TMsgDlgButtons; HelpCtx: Longint; X, Y: Integer;
  const HelpFileName: string; BiDiMode: TBiDiMode): Integer;

procedure ShowMessageBiDiSound(const Msg: string; BiDiMode: TBiDiMode);
procedure ShowMessageFmtBiDiSound(const Msg: string; Params: array of const;
  BiDiMode: TBiDiMode);
procedure ShowMessagePosBiDiSound(const Msg: string; X, Y: Integer;
  BiDiMode: TBiDiMode);

  { =============  TOP MOST DIALOGS  ============= }

 { Standard Dialogs }

function MessageDlgBiDiSoundTop(const Msg: string; DlgType: TMsgDlgType;
  Buttons: TMsgDlgButtons; HelpCtx: Longint; BiDiMode: TBiDiMode): Integer;
function MessageDlgPosBiDiSoundTop(const Msg: string; DlgType: TMsgDlgType;
  Buttons: TMsgDlgButtons; HelpCtx: Longint; X, Y: Integer;
  BiDiMode: TBiDiMode): Integer;
function MessageDlgPosHelpBiDiSoundTop(const Msg: string; DlgType: TMsgDlgType;
  Buttons: TMsgDlgButtons; HelpCtx: Longint; X, Y: Integer;
  const HelpFileName: string; BiDiMode: TBiDiMode): Integer;

procedure ShowMessageBiDiSoundTop(const Msg: string; BiDiMode: TBiDiMode);
procedure ShowMessageFmtBiDiSoundTop(const Msg: string; Params: array of const;
  BiDiMode: TBiDiMode);
procedure ShowMessagePosBiDiSoundTop(const Msg: string; X, Y: Integer;
  BiDiMode: TBiDiMode);

const
  BiDiDialogSounds: array[TMsgDlgType] of Cardinal = (MB_ICONEXCLAMATION,
    MB_ICONHAND, MB_OK, MB_ICONQUESTION, MB_ICONASTERISK);

implementation

const
  BIDI_SHOW_MESSAGE_DLG_SOUND = MB_ICONASTERISK;

 { Standard Dialogs }

function MessageDlgBiDiSound(const Msg: string; DlgType: TMsgDlgType;
  Buttons: TMsgDlgButtons; HelpCtx: Longint; BiDiMode: TBiDiMode): Integer;
begin
  Windows.MessageBeep(BiDiDialogSounds[DlgType]);
  Result := MessageDlgBiDi(Msg, DlgType, Buttons, HelpCtx, BiDiMode);
end;

function MessageDlgPosBiDiSound(const Msg: string; DlgType: TMsgDlgType;
  Buttons: TMsgDlgButtons; HelpCtx: Longint; X, Y: Integer;
  BiDiMode: TBiDiMode): Integer;
begin
  Windows.MessageBeep(BiDiDialogSounds[DlgType]);
  Result := MessageDlgPosBiDi(Msg, DlgType, Buttons, HelpCtx, X, Y, BiDiMode);
end;

function MessageDlgPosHelpBiDiSound(const Msg: string; DlgType: TMsgDlgType;
  Buttons: TMsgDlgButtons; HelpCtx: Longint; X, Y: Integer;
  const HelpFileName: string; BiDiMode: TBiDiMode): Integer;
begin
  Windows.MessageBeep(BiDiDialogSounds[DlgType]);
  Result := MessageDlgPosHelpBiDi(Msg, DlgType, Buttons, HelpCtx, X, Y, HelpFileName, BiDiMode);
end;


procedure ShowMessageBiDiSound(const Msg: string; BiDiMode: TBiDiMode);
begin
  Windows.MessageBeep(BIDI_SHOW_MESSAGE_DLG_SOUND);
  ShowMessageBiDi(Msg, BiDiMode);
end;

procedure ShowMessageFmtBiDiSound(const Msg: string; Params: array of const;
  BiDiMode: TBiDiMode);
begin
  Windows.MessageBeep(BIDI_SHOW_MESSAGE_DLG_SOUND);
  ShowMessageFmtBiDi(Msg, Params, BiDiMode);
end;

procedure ShowMessagePosBiDiSound(const Msg: string; X, Y: Integer;
  BiDiMode: TBiDiMode);
begin
  Windows.MessageBeep(BIDI_SHOW_MESSAGE_DLG_SOUND);
  ShowMessagePosBiDi(Msg, X, Y, BiDiMode);
end;

{ =============  TOP MOST DIALOGS  ============= }

 { Standard Dialogs }

function MessageDlgBiDiSoundTop(const Msg: string; DlgType: TMsgDlgType;
  Buttons: TMsgDlgButtons; HelpCtx: Longint; BiDiMode: TBiDiMode): Integer;
begin
  Application.NormalizeAllTopMosts;
  Result := MessageDlgBiDiSound(Msg, DlgType, Buttons, HelpCtx, BiDiMode);
  Application.RestoreTopMosts;
end;

function MessageDlgPosBiDiSoundTop(const Msg: string; DlgType: TMsgDlgType;
  Buttons: TMsgDlgButtons; HelpCtx: Longint; X, Y: Integer;
  BiDiMode: TBiDiMode): Integer;
begin
  Application.NormalizeAllTopMosts;
  Result := MessageDlgPosBiDiSound(Msg, DlgType, Buttons, HelpCtx, X, Y, BiDiMode);
  Application.RestoreTopMosts;
end;

function MessageDlgPosHelpBiDiSoundTop(const Msg: string; DlgType: TMsgDlgType;
  Buttons: TMsgDlgButtons; HelpCtx: Longint; X, Y: Integer;
  const HelpFileName: string; BiDiMode: TBiDiMode): Integer;
begin
  Application.NormalizeAllTopMosts;
  Result := MessageDlgPosHelpBiDiSound(Msg, DlgType, Buttons, HelpCtx, X, Y, HelpFileName, BiDiMode);
  Application.RestoreTopMosts;
end;


procedure ShowMessageBiDiSoundTop(const Msg: string; BiDiMode: TBiDiMode);
begin
  Application.NormalizeAllTopMosts;
  ShowMessageBiDiSound(Msg, BiDiMode);
  Application.RestoreTopMosts;
end;

procedure ShowMessageFmtBiDiSoundTop(const Msg: string; Params: array of const;
  BiDiMode: TBiDiMode);
begin
  Application.NormalizeAllTopMosts;
  ShowMessageFmtBiDiSound(Msg, Params, BiDiMode);
  Application.RestoreTopMosts;
end;

procedure ShowMessagePosBiDiSoundTop(const Msg: string; X, Y: Integer;
  BiDiMode: TBiDiMode);
begin
  Application.NormalizeAllTopMosts;
  ShowMessagePosBiDiSound(Msg, X, Y, BiDiMode);
  Application.RestoreTopMosts;
end;

end.
