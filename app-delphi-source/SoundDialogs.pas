unit SoundDialogs;

interface

uses
  Dialogs, sTntDialogs, Windows, Forms;

 { Standard Dialogs }

function MessageDlgSound(const Msg: string; DlgType: TMsgDlgType;
  Buttons: TMsgDlgButtons; HelpCtx: Longint): Integer;
function MessageDlgPosSound(const Msg: string; DlgType: TMsgDlgType;
  Buttons: TMsgDlgButtons; HelpCtx: Longint; X, Y: Integer): Integer;
function MessageDlgPosHelpSound(const Msg: string; DlgType: TMsgDlgType;
  Buttons: TMsgDlgButtons; HelpCtx: Longint; X, Y: Integer;
  const HelpFileName: string): Integer;

procedure ShowMessageSound(const Msg: string);
procedure ShowMessageFmtSound(const Msg: string; Params: array of const);
procedure ShowMessagePosSound(const Msg: string; X, Y: Integer);



 {TNT Unicode Dialogs }

{TNT-WARN MessageDlg}
function WideMessageDlgSound(const Msg: WideString; DlgType: TMsgDlgType;
  Buttons: TMsgDlgButtons; HelpCtx: Longint): Integer;
{TNT-WARN MessageDlgPos}
function WideMessageDlgPosSound(const Msg: WideString; DlgType: TMsgDlgType;
  Buttons: TMsgDlgButtons; HelpCtx: Longint; X, Y: Integer): Integer;
{TNT-WARN MessageDlgPosHelp}
function WideMessageDlgPosHelpSound(const Msg: WideString; DlgType: TMsgDlgType;
  Buttons: TMsgDlgButtons; HelpCtx: Longint; X, Y: Integer;
  const HelpFileName: WideString): Integer;

{TNT-WARN ShowMessage}
procedure WideShowMessageSound(const Msg: WideString);
{TNT-WARN ShowMessageFmt}
procedure WideShowMessageFmtSound(const Msg: WideString; Params: array of const);
{TNT-WARN ShowMessagePos}
procedure WideShowMessagePosSound(const Msg: WideString; X, Y: Integer);

  { =============  TOP MOST DIALOGS  ============= }

 { Standard Dialogs }

function MessageDlgSoundTop(const Msg: string; DlgType: TMsgDlgType;
  Buttons: TMsgDlgButtons; HelpCtx: Longint): Integer;
function MessageDlgPosSoundTop(const Msg: string; DlgType: TMsgDlgType;
  Buttons: TMsgDlgButtons; HelpCtx: Longint; X, Y: Integer): Integer;
function MessageDlgPosHelpSoundTop(const Msg: string; DlgType: TMsgDlgType;
  Buttons: TMsgDlgButtons; HelpCtx: Longint; X, Y: Integer;
  const HelpFileName: string): Integer;

procedure ShowMessageSoundTop(const Msg: string);
procedure ShowMessageFmtSoundTop(const Msg: string; Params: array of const);
procedure ShowMessagePosSoundTop(const Msg: string; X, Y: Integer);



 {TNT Unicode Dialogs }

{TNT-WARN MessageDlg}
function WideMessageDlgSoundTop(const Msg: WideString; DlgType: TMsgDlgType;
  Buttons: TMsgDlgButtons; HelpCtx: Longint): Integer;
{TNT-WARN MessageDlgPos}
function WideMessageDlgPosSoundTop(const Msg: WideString; DlgType: TMsgDlgType;
  Buttons: TMsgDlgButtons; HelpCtx: Longint; X, Y: Integer): Integer;
{TNT-WARN MessageDlgPosHelp}
function WideMessageDlgPosHelpSoundTop(const Msg: WideString; DlgType: TMsgDlgType;
  Buttons: TMsgDlgButtons; HelpCtx: Longint; X, Y: Integer;
  const HelpFileName: WideString): Integer;

{TNT-WARN ShowMessage}
procedure WideShowMessageSoundTop(const Msg: WideString);
{TNT-WARN ShowMessageFmt}
procedure WideShowMessageFmtSoundTop(const Msg: WideString; Params: array of const);
{TNT-WARN ShowMessagePos}
procedure WideShowMessagePosSoundTop(const Msg: WideString; X, Y: Integer);

const
  DialogSounds: array[TMsgDlgType] of Cardinal = (MB_ICONEXCLAMATION,
    MB_ICONHAND, MB_OK, MB_ICONQUESTION, MB_ICONASTERISK);

implementation

const
  SHOW_MESSAGE_DLG_SOUND = MB_ICONASTERISK;

 { Standard Dialogs }

function MessageDlgSound(const Msg: string; DlgType: TMsgDlgType;
  Buttons: TMsgDlgButtons; HelpCtx: Longint): Integer;
begin
  Windows.MessageBeep(DialogSounds[DlgType]);
  Result := MessageDlg(Msg, DlgType, Buttons, HelpCtx);
end;

function MessageDlgPosSound(const Msg: string; DlgType: TMsgDlgType;
  Buttons: TMsgDlgButtons; HelpCtx: Longint; X, Y: Integer): Integer;
begin
  Windows.MessageBeep(DialogSounds[DlgType]);
  Result := MessageDlgPos(Msg, DlgType, Buttons, HelpCtx, X, Y);
end;

function MessageDlgPosHelpSound(const Msg: string; DlgType: TMsgDlgType;
  Buttons: TMsgDlgButtons; HelpCtx: Longint; X, Y: Integer;
  const HelpFileName: string): Integer;
begin
  Windows.MessageBeep(DialogSounds[DlgType]);
  Result := MessageDlgPosHelp(Msg, DlgType, Buttons, HelpCtx, X, Y, HelpFileName);
end;


procedure ShowMessageSound(const Msg: string);
begin
  Windows.MessageBeep(SHOW_MESSAGE_DLG_SOUND);
  ShowMessage(Msg);
end;

procedure ShowMessageFmtSound(const Msg: string; Params: array of const);
begin
  Windows.MessageBeep(SHOW_MESSAGE_DLG_SOUND);
  ShowMessageFmt(Msg, Params);
end;

procedure ShowMessagePosSound(const Msg: string; X, Y: Integer);
begin
  Windows.MessageBeep(SHOW_MESSAGE_DLG_SOUND);
  ShowMessagePos(Msg, X, Y);
end;


 {TNT Unicode Dialogs }

function WideMessageDlgSound(const Msg: WideString; DlgType: TMsgDlgType;
  Buttons: TMsgDlgButtons; HelpCtx: Longint): Integer;
begin
  Windows.MessageBeep(DialogSounds[DlgType]);
  Result := WideMessageDlg(Msg, DlgType, Buttons, HelpCtx);
end;

function WideMessageDlgPosSound(const Msg: WideString; DlgType: TMsgDlgType;
  Buttons: TMsgDlgButtons; HelpCtx: Longint; X, Y: Integer): Integer;
begin
  Windows.MessageBeep(DialogSounds[DlgType]);
  Result := WideMessageDlgPos(Msg, DlgType, Buttons, HelpCtx, X, Y);
end;

function WideMessageDlgPosHelpSound(const Msg: WideString; DlgType: TMsgDlgType;
  Buttons: TMsgDlgButtons; HelpCtx: Longint; X, Y: Integer;
  const HelpFileName: WideString): Integer;
begin
  Windows.MessageBeep(DialogSounds[DlgType]);
  Result := WideMessageDlgPosHelp(Msg, DlgType, Buttons, HelpCtx, X, Y, HelpFileName);
end;


procedure WideShowMessageSound(const Msg: WideString);
begin
  Windows.MessageBeep(SHOW_MESSAGE_DLG_SOUND);
  WideShowMessage(Msg);
end;

procedure WideShowMessageFmtSound(const Msg: WideString; Params: array of const);
begin
  Windows.MessageBeep(SHOW_MESSAGE_DLG_SOUND);
  WideShowMessageFmt(Msg, Params);
end;

procedure WideShowMessagePosSound(const Msg: WideString; X, Y: Integer);
begin
  Windows.MessageBeep(SHOW_MESSAGE_DLG_SOUND);
  WideShowMessagePos(Msg, X, Y);
end;

  { =============  TOP MOST DIALOGS  ============= }

 { Standard Dialogs }

function MessageDlgSoundTop(const Msg: string; DlgType: TMsgDlgType;
  Buttons: TMsgDlgButtons; HelpCtx: Longint): Integer;
begin
  Application.NormalizeAllTopMosts;
  Result := MessageDlgSound(Msg, DlgType, Buttons, HelpCtx);
  Application.RestoreTopMosts;
end;

function MessageDlgPosSoundTop(const Msg: string; DlgType: TMsgDlgType;
  Buttons: TMsgDlgButtons; HelpCtx: Longint; X, Y: Integer): Integer;
begin
  Application.NormalizeAllTopMosts;
  Result := MessageDlgPosSound(Msg, DlgType, Buttons, HelpCtx, X, Y);
  Application.RestoreTopMosts;
end;

function MessageDlgPosHelpSoundTop(const Msg: string; DlgType: TMsgDlgType;
  Buttons: TMsgDlgButtons; HelpCtx: Longint; X, Y: Integer;
  const HelpFileName: string): Integer;
begin
  Application.NormalizeAllTopMosts;
  Result := MessageDlgPosHelpSound(Msg, DlgType, Buttons, HelpCtx, X, Y, HelpFileName);
  Application.RestoreTopMosts;
end;


procedure ShowMessageSoundTop(const Msg: string);
begin
  Application.NormalizeAllTopMosts;
  ShowMessageSound(Msg);
  Application.RestoreTopMosts;
end;

procedure ShowMessageFmtSoundTop(const Msg: string; Params: array of const);
begin
  Application.NormalizeAllTopMosts;
  ShowMessageFmtSound(Msg, Params);
  Application.RestoreTopMosts;
end;

procedure ShowMessagePosSoundTop(const Msg: string; X, Y: Integer);
begin
  Application.NormalizeAllTopMosts;
  ShowMessagePosSound(Msg, X, Y);
  Application.RestoreTopMosts;
end;


 {TNT Unicode Dialogs }

function WideMessageDlgSoundTop(const Msg: WideString; DlgType: TMsgDlgType;
  Buttons: TMsgDlgButtons; HelpCtx: Longint): Integer;
begin
  Application.NormalizeAllTopMosts;
  Result := WideMessageDlgSound(Msg, DlgType, Buttons, HelpCtx);
  Application.RestoreTopMosts;
end;

function WideMessageDlgPosSoundTop(const Msg: WideString; DlgType: TMsgDlgType;
  Buttons: TMsgDlgButtons; HelpCtx: Longint; X, Y: Integer): Integer;
begin
  Application.NormalizeAllTopMosts;
  Result := WideMessageDlgPosSound(Msg, DlgType, Buttons, HelpCtx, X, Y);
  Application.RestoreTopMosts;
end;

function WideMessageDlgPosHelpSoundTop(const Msg: WideString; DlgType: TMsgDlgType;
  Buttons: TMsgDlgButtons; HelpCtx: Longint; X, Y: Integer;
  const HelpFileName: WideString): Integer;
begin
  Application.NormalizeAllTopMosts;
  Result := WideMessageDlgPosHelpSound(Msg, DlgType, Buttons, HelpCtx, X, Y, HelpFileName);
  Application.RestoreTopMosts;
end;


procedure WideShowMessageSoundTop(const Msg: WideString);
begin
  Application.NormalizeAllTopMosts;
  WideShowMessageSound(Msg);
  Application.RestoreTopMosts;
end;

procedure WideShowMessageFmtSoundTop(const Msg: WideString; Params: array of const);
begin
  Application.NormalizeAllTopMosts;
  WideShowMessageFmtSound(Msg, Params);
  Application.RestoreTopMosts;
end;

procedure WideShowMessagePosSoundTop(const Msg: WideString; X, Y: Integer);
begin
  Application.NormalizeAllTopMosts;
  WideShowMessagePosSound(Msg, X, Y);
  Application.RestoreTopMosts;
end;

end.
