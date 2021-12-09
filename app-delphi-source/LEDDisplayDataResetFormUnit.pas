unit LEDDisplayDataResetFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, TntForms, ExtCtrls, StdCtrls, sLabel, Buttons, TntButtons,
  sBitBtn, sSkinProvider, sSpeedButton, UnitKDCommon, UnitKDSerialPort,
  Menus, TntMenus, SpecialProcsUnit, SoundDialogs, TntXPMenu;

const
  LEDDISPLAY_RESET_BYTE_1_FROM_MICRO = $CB;
  LEDDISPLAY_RESET_BYTE_2_TO_MICRO = $56;
  LEDDISPLAY_RESET_BYTE_3_FROM_MICRO = $AE;
  LEDDISPLAY_RESET_BYTE_4_TO_MICRO = $94;

type
  TLEDDisplayDataResetForm = class(TTntForm)
    sSkinProvider1: TsSkinProvider;
    sBitBtn1: TsBitBtn;
    sLabel4: TsLabel;
    Image1: TImage;
    Image2: TImage;
    sLabel1: TsLabel;
    sLabel2: TsLabel;
    sLabel3: TsLabel;
    sLabel5: TsLabel;
    sLabel6: TsLabel;
    sLabel7: TsLabel;
    LEDDisplayDataResetReadyBtn: TsSpeedButton;
    KDSerialPort1: KDSerialPort;
    LEDDisplayDataResetReadyPopup: TTntPopupMenu;
    LEDDisplayDataResetReadyMenuItem1: TTntMenuItem;
    LEDDisplayDataResetReadyMenuItem2: TTntMenuItem;
    TntXPMenu1: TTntXPMenu;
    procedure LEDDisplayDataResetReadyBtnClick(Sender: TObject);
    procedure LEDDisplayDataResetReadyMenuItem1Click(Sender: TObject);
    procedure LEDDisplayDataResetReadyMenuItem2Click(Sender: TObject);
    procedure sBitBtn1Click(Sender: TObject);
    procedure TntFormShow(Sender: TObject);
    procedure TntFormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure TntFormDestroy(Sender: TObject);
  private
    { Private declarations }
    OperationCancelled: Boolean;
    ReturnBtnClicked: Boolean;
    procedure ResetLEDDisplayData(LEDDisplayNumber: Integer);
  public
    { Public declarations }
  end;

var
  LEDDisplayDataResetForm: TLEDDisplayDataResetForm;

implementation

uses ProgrammerFormUnit, MainUnit;

{$R *.dfm}

procedure TLEDDisplayDataResetForm.LEDDisplayDataResetReadyBtnClick(
  Sender: TObject);
begin
  if LEDDisplayDataResetReadyBtn.Down then
  begin
    //Show menu or run direct?
    if GlobalOptions.NumOfLEDDisplays = 1 then
      //Run direct
      LEDDisplayDataResetReadyMenuItem1.Click
    else
      //Show menu 
      SpecialProcs.PopupMenuAtControl(LEDDisplayDataResetReadyBtn, LEDDisplayDataResetReadyPopup);
  end
  else
  begin
    OperationCancelled := True;
    LEDDisplayDataResetReadyBtn.Enabled := False;
    Application.ProcessMessages;
  end;
end;

procedure TLEDDisplayDataResetForm.ResetLEDDisplayData(
  LEDDisplayNumber: Integer);
var
  ErrCode: Integer;
  rid: Integer;
  wr: TWaitResult;
  ShowInvalidDataMsg: Boolean;
  DataBytes: array of Byte;
  S: String;
begin
  if not MainForm.CommunicationWithLEDDisplayAllowed(True) then
    Exit;

  MainForm.CheckAlSerialPortObjectsToBeClosed;

  SetLength(DataBytes, 0);

  ProgrammerForm.SetupSerialCommunication(KDSerialPort1, LEDDisplayNumber);
  OperationCancelled := False;
  ShowInvalidDataMsg := False;

  try

  SetPriorityClass(GetCurrentProcess, HIGH_PRIORITY_CLASS);

  //Open port
  ErrCode := KDSerialPort1.Open(0);
  if ErrCode <> 0 then
  begin
    WideMessageDlgSound(ProgrammerForm.PortErrMsg(ErrCode), mtError, [mbOK], 0);
    Close;
    Exit;
  end;

  KDSerialPort1.AddResponse(0, 1, '', False);
  repeat
    KDSerialPort1.WaitResponse(S, rid, 1000, wr);
    if Length(S) >= 1 then
    begin
      if S[1] <> Chr(LEDDISPLAY_RESET_BYTE_1_FROM_MICRO) then  //Maybe first byte come from the bootloader
      begin
        S := '';
        wr := wrTimeOut;
      end;
    end;
    Application.ProcessMessages;
  until OperationCancelled or (wr = wrMaxSizeReached);

  if OperationCancelled then
    Exit;

  ShowInvalidDataMsg := True;

  //wr = wrMaxSizeReached
  if (Length(S) > 1) or (Length(S) = 0) then  //Prevent potential software bugs
    Exit;
  if S[1] <> Chr(LEDDISPLAY_RESET_BYTE_1_FROM_MICRO) then
    Exit;

  SetLength(DataBytes, 1);
  DataBytes[0] := LEDDISPLAY_RESET_BYTE_2_TO_MICRO;
  KDSerialPort1.SendData(Pointer(DataBytes), Length(DataBytes));

  ShowInvalidDataMsg := False;

  repeat
    KDSerialPort1.WaitResponse(S, rid, 1000, wr);
    Application.ProcessMessages;
  until OperationCancelled or (wr = wrMaxSizeReached);

  if OperationCancelled then
    Exit;

  ShowInvalidDataMsg := True;

  //wr = wrMaxSizeReached
  if (Length(S) > 1) or (Length(S) = 0) then  //Prevent potential software bugs
    Exit;
  if S[1] <> Chr(LEDDISPLAY_RESET_BYTE_3_FROM_MICRO) then
    Exit;

  DataBytes[0] := LEDDISPLAY_RESET_BYTE_4_TO_MICRO;
  KDSerialPort1.SendData(Pointer(DataBytes), Length(DataBytes));

  ShowInvalidDataMsg := False;
  KDSerialPort1.Close;

  WideShowMessageSoundTop(Dyn_Texts[87] {'Connection with the LED Display established and the operation completed successfully.'});

  Close;

  finally

  SetLength(DataBytes, 0);
  if KDSerialPort1.IsOpened then
    KDSerialPort1.Close;
  if ShowInvalidDataMsg then
    //WideMessageDlgSoundTop(Dyn_Texts[88] {'Invalid data received from the LED Display. Please try again later.'}, mtError, [mbOK], 0);
    WideShowMessageSoundTop(Dyn_Texts[88] {'Invalid data received from the LED Display. Please try again later.'});
  LEDDisplayDataResetReadyBtn.Enabled := True;
  LEDDisplayDataResetReadyBtn.Down := False;

  end;
end;

procedure TLEDDisplayDataResetForm.LEDDisplayDataResetReadyMenuItem1Click(
  Sender: TObject);
begin
  ResetLEDDisplayData(1);
end;

procedure TLEDDisplayDataResetForm.LEDDisplayDataResetReadyMenuItem2Click(
  Sender: TObject);
begin
  ResetLEDDisplayData(2);
end;

procedure TLEDDisplayDataResetForm.sBitBtn1Click(Sender: TObject);
begin
  ReturnBtnClicked := True;
  OperationCancelled := True;
end;

procedure TLEDDisplayDataResetForm.TntFormShow(Sender: TObject);
begin
  ReturnBtnClicked := False;
end;

procedure TLEDDisplayDataResetForm.TntFormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  CanClose := ReturnBtnClicked or not LEDDisplayDataResetReadyBtn.Down;
end;

procedure TLEDDisplayDataResetForm.TntFormDestroy(Sender: TObject);
begin
  try
    if KDSerialPort1.IsOpened then
      KDSerialPort1.Close;
  except
  end;
end;

end.
