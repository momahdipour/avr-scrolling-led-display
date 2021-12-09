unit SWFPreviewFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, TntForms, StdCtrls, TntStdCtrls, sButton, MMSWF, GlobalTypes,
  ExtCtrls, sGroupBox, Buttons, TntButtons, sSpeedButton,
  sThumbnailImageViewer, ProcsUnit;

type
  TSWFPreviewForm = class(TTntForm)
    OKBtn: TsButton;
    AnimationPreviewGroup: TsGroupBox;
    AnimationPreviewImage: TImage;
    PlayAnimationBtn: TsSpeedButton;
    PauseAnimationBtn: TsSpeedButton;
    ScrollBox1: TScrollBox;
    AfterShowTimer: TTimer;
    procedure TntFormCreate(Sender: TObject);
    procedure TntFormDestroy(Sender: TObject);
    procedure TntFormResize(Sender: TObject);
    procedure OKBtnClick(Sender: TObject);
    procedure PauseAnimationBtnClick(Sender: TObject);
    procedure PlayAnimationBtnClick(Sender: TObject);
    procedure AfterShowTimerTimer(Sender: TObject);
    procedure TntFormShow(Sender: TObject);
  private
    { Private declarations }
    MMSWF: TMMSWF;
    sThumbnailImageViewer: TsThumbnailImageViewer;
    SWFInfo: TSWFInfo;
    FrameIndex: Integer;
    StopAnimation: Boolean;
    AnimationPreviewInProgress: Boolean;

    procedure WindowClose(var msg: TWMClose); message WM_CLOSE;
    procedure PlayAnimation;
  public
    { Public declarations }
    procedure LoadSWFFromStream(SWFData: TStream; SWFInfo: TSWFInfo;
      SWFSensitivity: Integer);
  end;

var
  SWFPreviewForm: TSWFPreviewForm;

implementation

{$R *.dfm}

{ TSWFPreviewForm }

procedure TSWFPreviewForm.LoadSWFFromStream(SWFData: TStream;
  SWFInfo: TSWFInfo; SWFSensitivity: Integer);
var
  i: Integer;
begin
  sThumbnailImageViewer.Clear;
  FrameIndex := 0;
  Self.SWFInfo := SWFInfo;
  MMSWF.LoadFromStream(SWFData);
  MMSWF.Width := SWFInfo.Width;
  MMSWF.Height := SWFInfo.Height;
  MMSWF.ExtractFrames;
  MMSWF.NormalizeFramesToSingleColor(clWhite, clBlue, SWFSensitivity);
  for i := 0 to MMSWF.FrameCount - 1 do
    if MMSWF.Frames[i] <> nil then
      sThumbnailImageViewer.AddThumbnail(MMSWF.Frames[i], IntToStr(i + 1));
end;

procedure TSWFPreviewForm.TntFormCreate(Sender: TObject);
begin
  AnimationPreviewInProgress := False;
  
  MMSWF := TMMSWF.Create(nil);

  sThumbnailImageViewer := TsThumbnailImageViewer.Create(Self);
  sThumbnailImageViewer.Visible := False;
  sThumbnailImageViewer.HorzScrollBar.Tracking := True;
  sThumbnailImageViewer.VertScrollBar.Tracking := True;
  sThumbnailImageViewer.Parent := Self;
  sThumbnailImageViewer.Width := ScrollBox1.Width;
  sThumbnailImageViewer.Height := ScrollBox1.Height;
  sThumbnailImageViewer.Left := ScrollBox1.Left;
  sThumbnailImageViewer.Top := ScrollBox1.Top;
  sThumbnailImageViewer.Anchors := [akLeft, akTop, akRight];
  sThumbnailImageViewer.ThumbnailHeight := sThumbnailImageViewer.Height - 25;
  sThumbnailImageViewer.ThumbnailWidth := sThumbnailImageViewer.ThumbnailHeight;
  sThumbnailImageViewer.Visible := True;
  ScrollBox1.Free;
end;

procedure TSWFPreviewForm.TntFormDestroy(Sender: TObject);
begin
  MMSWF.Free;
end;

procedure TSWFPreviewForm.TntFormResize(Sender: TObject);
begin
  OKBtn.Left := Trunc(Self.Width / 2 - OKBtn.Width / 2);
  AnimationPreviewGroup.Left := Trunc(Self.Width / 2 - AnimationPreviewGroup.Width / 2);
end;

procedure TSWFPreviewForm.OKBtnClick(Sender: TObject);
begin
  StopAnimation := True;
end;

procedure TSWFPreviewForm.PauseAnimationBtnClick(Sender: TObject);
begin
  StopAnimation := True;
end;

procedure TSWFPreviewForm.PlayAnimation;
var
  FrameDelay: Integer;
  DelayStartTick: Cardinal;
begin
  if AnimationPreviewInProgress then
  begin
    PlayAnimationBtn.Down := True;
    Exit;
  end;

  AnimationPreviewInProgress := True;
  
  StopAnimation := False;
  PlayAnimationBtn.Down := True;
  TRY

  if MMSWF.FrameCount = 0 then
    Exit;
  FrameDelay := Trunc(1000 / SWFInfo.FrameRate); 
  while not StopAnimation do
  begin
    AnimationPreviewImage.Picture.Bitmap.Assign(MMSWF.Frames[FrameIndex]);
    Application.ProcessMessages;

    DelayStartTick := GetTickCount;
    while not StopAnimation do
    begin
      Sleep(1);
      Application.ProcessMessages;
      if (GetTickCount - DelayStartTick) >= FrameDelay then
        Break;
    end;

    Inc(FrameIndex);
    if FrameIndex >= MMSWF.FrameCount then
      FrameIndex := 0;
  end;

  FINALLY

  PlayAnimationBtn.Down := False;
  AnimationPreviewInProgress := False;

  END;
end;

procedure TSWFPreviewForm.PlayAnimationBtnClick(Sender: TObject);
begin
  PlayAnimation;
end;

procedure TSWFPreviewForm.WindowClose(var msg: TWMClose);
begin
  StopAnimation := True;
  Self.Close;
end;

procedure TSWFPreviewForm.AfterShowTimerTimer(Sender: TObject);
begin
  AfterShowTimer.Enabled := False;
  PlayAnimationBtn.Click;
end;

procedure TSWFPreviewForm.TntFormShow(Sender: TObject);
begin
  AfterShowTimer.Enabled := True;
end;

end.
