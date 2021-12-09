program LEDDisplayControl;

{$R 'Resource Files\Effects (Normal) GIF\EffectsNormalGIF.res' 'Resource Files\Effects (Normal) GIF\EffectsNormalGIF.rc'}
{$R 'Resource Files\Page Effects GIF\PageEffectsGIF.res' 'Resource Files\Page Effects GIF\PageEffectsGIF.rc'}
{$R 'Resource Files\General\GeneralResources.res' 'Resource Files\General\GeneralResources.rc'}
{$R 'Resource Files\Farsi Translation\EnglishTranslation.res' 'Resource Files\Farsi Translation\EnglishTranslation.rc'}
{$R 'Resource Files\Preview Pictures\Farsi\FarsiPreviewPictures.res' 'Resource Files\Preview Pictures\Farsi\FarsiPreviewPictures.rc'}
{$R 'Resource Files\Preview Pictures\English\EnglishPreviewPictures.res' 'Resource Files\Preview Pictures\English\EnglishPreviewPictures.rc'}
{%File 'License Units\LicenseKeyForModels.inc'}

uses
  Forms,
  MainUnit in 'MainUnit.pas' {MainForm},
  ProgrammerFormUnit in 'ProgrammerFormUnit.pas' {ProgrammerForm},
  SpecialProcsUnit in 'SpecialProcsUnit.pas',
  GlobalTypes in 'GlobalTypes.pas',
  LEDTime in 'LEDTime.pas',
  LayoutFormUnit in 'LayoutFormUnit.pas' {LayoutForm},
  Layouts in 'Layouts.pas',
  LEDDate in 'LEDDate.pas',
  LEDScrollingText in 'LEDScrollingText.pas',
  LEDAnimation in 'LEDAnimation.pas',
  LEDPageEffect in 'LEDPageEffect.pas',
  LEDPicture in 'LEDPicture.pas',
  TextPicturePreviewFormUnit in 'TextPicturePreviewFormUnit.pas' {TextPicturePreviewForm},
  TextToLCDUnit in 'TextToLCDUnit.pas',
  Graphics32 in '..\Project Units\Graphics32\Graphics32.pas',
  Image32 in '..\Project Units\Graphics32\Image32.pas',
  Blend32 in '..\Project Units\Graphics32\Blend32.pas',
  CPUid in '..\Project Units\Graphics32\CPUid.pas',
  Transform32 in '..\Project Units\Graphics32\Transform32.pas',
  LowLevel32 in '..\Project Units\Graphics32\LowLevel32.pas',
  Filters32 in '..\Project Units\Graphics32\Filters32.pas',
  LCDProcsUnit in 'LCDProcsUnit.pas',
  ProcsUnit in 'ProcsUnit.pas',
  GIFImage in '..\Project Units\GIFImage\GIFImage.pas',
  ImportGraphicsFormUnit in 'ImportGraphicsFormUnit.pas' {ImportGraphicsForm: TTntForm},
  SoundDialogs in 'SoundDialogs.pas',
  LEDTemperature in 'LEDTemperature.pas',
  ChangeDisplaySettingsFormUnit in 'ChangeDisplaySettingsFormUnit.pas' {ChangeDisplaySettingsForm},
  ProgramConsts in 'ProgramConsts.pas',
  SelectNormalEffectFormUnit in 'SelectNormalEffectFormUnit.pas' {SelectNormalEffectForm},
  SelectPageEffectFormUnit in 'SelectPageEffectFormUnit.pas' {SelectPageEffectForm},
  AboutFormUnit in 'AboutFormUnit.pas' {AboutForm: TTntForm},
  sStagePanel in '..\Project Components\TsStagePanel (with TsLabel)\sStagePanel.pas',
  LEDEmpty in 'LEDEmpty.pas',
  ProgramOptionsFormUnit in 'ProgramOptionsFormUnit.pas' {ProgramOptionsForm},
  License in 'License Units\Main License Unit\License.pas',
  License2 in 'License Units\License Unit Copies\License2.pas',
  License3 in 'License Units\License Unit Copies\License3.pas',
  License4 in 'License Units\License Unit Copies\License4.pas',
  License5 in 'License Units\License Unit Copies\License5.pas',
  License6 in 'License Units\License Unit Copies\License6.pas',
  BiDiSoundDialogs in 'BiDiSoundDialogs.pas',
  BiDiDialogs in 'BiDiDialogs.pas',
  magwmi in '..\Project Units\WMI (MagWMI)\magwmi.pas',
  WbemScripting_TLB in '..\Project Units\WMI (MagWMI)\WbemScripting_TLB.pas',
  magsubs1 in '..\Project Units\WMI (MagWMI)\magsubs1.pas',
  smartapi in '..\Project Units\WMI (MagWMI)\smartapi.pas',
  cls_id in '..\Project Units\CPUid\cls_id.pas',
  SplashScreenFormUnit in 'SplashScreenFormUnit.pas' {SplashScreenForm},
  SysUtils,
  PreviewUnit in 'PreviewUnit.pas',
  AlarmSettingsFormUnit in 'AlarmSettingsFormUnit.pas' {AlarmSettingsForm},
  AlarmProgressFormUnit in 'AlarmProgressFormUnit.pas' {AlarmProgressForm},
  LayoutDesignerFormUnit in 'LayoutDesignerFormUnit.pas' {LayoutDesignerForm},
  Controls,
  Windows,
  BorderStyleFormUnit in 'BorderStyleFormUnit.pas' {BorderStyleForm},
  ScheduleStageFormUnit in 'ScheduleStageFormUnit.pas' {ScheduleStageForm},
  LEDDisplayDataResetFormUnit in 'LEDDisplayDataResetFormUnit.pas' {LEDDisplayDataResetForm},
  sCancelDialog in '..\Project Components\TsCancelDialog\sCancelDialog.pas',
  WaitFormUnit in 'WaitFormUnit.pas' {WaitForm},
  AnimationLineSummaryFormUnit in 'AnimationLineSummaryFormUnit.pas' {AnimationLineSummaryForm: TTntForm},
  FadedDraw in '..\Project Components\From LFG Components\TFadedDraw\FadedDraw.pas',
  ProgressFormUnit in 'ProgressFormUnit.pas' {ProgressForm},
  OTAImage in '..\Project Units\OTAImage\OTAImage.pas',
  RAR in '..\Project Units\RAR Component v.1.2\RARComponent12\RAR.pas',
  RAR_DLL in '..\Project Units\RAR Component v.1.2\RARComponent12\RAR_DLL.pas',
  DefaultPicturesFormUnit in 'DefaultPicturesFormUnit.pas' {DefaultPicturesForm},
  CapabilitiesFormUnit in 'CapabilitiesFormUnit.pas' {CapabilitiesForm},
  SWFFile in 'SWFFile.pas',
  LEDSWF in 'LEDSWF.pas',
  MMSWF in 'Project Units\MMSWF\MMSWF.pas',
  SetOffTimeFormUnit in 'SetOffTimeFormUnit.pas' {SetOffTimeForm: TTntForm},
  CreateSupportFileFormUnit in 'CreateSupportFileFormUnit.pas' {CreateSupportFileForm},
  HiddenAboutFormUnit in 'HiddenAboutFormUnit.pas' {HiddenAboutForm},
  LicenseTypes in 'License Units\LicenseTypes.pas',
  Model1AG in 'License Units\ModelKeys\Model1AG.pas',
  Model1A in 'License Units\ModelKeys\Model1A.pas',
  Model1G in 'License Units\ModelKeys\Model1G.pas',
  Model1 in 'License Units\ModelKeys\Model1.pas',
  Model2AG in 'License Units\ModelKeys\Model2AG.pas',
  Model2A in 'License Units\ModelKeys\Model2A.pas',
  Model2G in 'License Units\ModelKeys\Model2G.pas',
  Model2 in 'License Units\ModelKeys\Model2.pas',
  Model3AG in 'License Units\ModelKeys\Model3AG.pas',
  Model3A in 'License Units\ModelKeys\Model3A.pas',
  Model3G in 'License Units\ModelKeys\Model3G.pas',
  Model3 in 'License Units\ModelKeys\Model3.pas',
  MMSWFHeaderReader in 'Project Units\MMSWF\MMSWFHeaderReader.pas',
  SWFPreviewFormUnit in 'SWFPreviewFormUnit.pas' {SWFPreviewForm},
  sThumbnailImageViewer in '..\Project Components\TsThumbnailImageViewer\sThumbnailImageViewer.pas',
  BRModel1 in 'License Units\BRModelKeys\BRModel1.pas',
  BRModel2 in 'License Units\BRModelKeys\BRModel2.pas',
  BRModel3 in 'License Units\BRModelKeys\BRModel3.pas';

{$R *.res}

{$define SPLASH_ON}

const
  ANI_HOURSE = 100;
var
  Cur: HCursor;
  CursorLoaded: Boolean;
begin
  //Only set the affinity of the main thread, if possible
  if SetThreadAffinityMask(GetCurrentThread, 1) = 0 then  //0 means error
    SetProcessAffinityMask(GetCurrentProcess, 1);  //If unable to set only the affinity of the main thread, set the affinity of the process

  ApplicationState := [asLoading];

  Application.Initialize;
  Application.Title := 'LED Display Control Software 1.5';
  CursorLoaded := False;
  Cur := HCURSOR(nil);
  try
    Cur := Procs.LoadAnimatedCursorFromResource(HInstance, 'HOURSE_CUR', 'ANICURSOR');
    CursorLoaded := True;
  except
  end;
  if CursorLoaded and (Cur <> HCURSOR(nil)) then
    Screen.Cursors[ANI_HOURSE] := Cur
  else
    Screen.Cursors[ANI_HOURSE] := Screen.Cursors[crDefault];

  Screen.Cursor := ANI_HOURSE;

  {$ifdef  SPLASH_ON}
  //Show Splash Screen
  SplashScreenForm := nil;
  if Procs.ProcessInstanceCount(APPLICATION_EXE_FILE_NAME) <= 1 then
  begin
    SplashScreenForm := TSplashScreenForm.Create(nil);
    //Application.CreateForm(TSplashScreenForm, SplashScreenForm);
    SplashScreenForm.Show;
    SplashScreenForm.Update;
    Application.ProcessMessages;
  end;
  {$endif}

  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TAlarmSettingsForm, AlarmSettingsForm);
  Application.CreateForm(TAlarmProgressForm, AlarmProgressForm);
  Application.CreateForm(TLayoutDesignerForm, LayoutDesignerForm);
  Application.CreateForm(TBorderStyleForm, BorderStyleForm);
  Application.CreateForm(TScheduleStageForm, ScheduleStageForm);
  Application.CreateForm(TLEDDisplayDataResetForm, LEDDisplayDataResetForm);
  Application.CreateForm(TWaitForm, WaitForm);
  Application.CreateForm(TAnimationLineSummaryForm, AnimationLineSummaryForm);
  Application.CreateForm(TProgressForm, ProgressForm);
  Application.CreateForm(TDefaultPicturesForm, DefaultPicturesForm);
  Application.CreateForm(TCapabilitiesForm, CapabilitiesForm);
  //Application.CreateForm(TSWFPreviewForm, SWFPreviewForm);
  //Application.CreateForm(THiddenAboutForm, HiddenAboutForm);
  //Application.CreateForm(TCreateSupportFileForm, CreateSupportFileForm);
  //Application.CreateForm(TSetOffTimeForm, SetOffTimeForm);
  {$ifdef  SPLASH_ON}
  if Assigned(SplashScreenForm) then
    SplashScreenForm.UpdateImages;
  {$endif}
  Application.CreateForm(TProgrammerForm, ProgrammerForm);
  {$ifdef  SPLASH_ON}
  if Assigned(SplashScreenForm) then
    SplashScreenForm.UpdateImages;
  {$endif}
  Application.CreateForm(TLayoutForm, LayoutForm);
  {$ifdef  SPLASH_ON}
  if Assigned(SplashScreenForm) then
    SplashScreenForm.UpdateImages;
  {$endif}
  Application.CreateForm(TTextPicturePreviewForm, TextPicturePreviewForm);
  {$ifdef  SPLASH_ON}
  if Assigned(SplashScreenForm) then
    SplashScreenForm.UpdateImages;
  {$endif}
  Application.CreateForm(TImportGraphicsForm, ImportGraphicsForm);
  {$ifdef  SPLASH_ON}
  if Assigned(SplashScreenForm) then
    SplashScreenForm.UpdateImages;
  {$endif}
  Application.CreateForm(TChangeDisplaySettingsForm, ChangeDisplaySettingsForm);
  {$ifdef  SPLASH_ON}
  if Assigned(SplashScreenForm) then
    SplashScreenForm.UpdateImages;
  {$endif}
  Application.CreateForm(TSelectNormalEffectForm, SelectNormalEffectForm);
  {$ifdef  SPLASH_ON}
  if Assigned(SplashScreenForm) then
    SplashScreenForm.UpdateImages;
  {$endif}
  Application.CreateForm(TSelectPageEffectForm, SelectPageEffectForm);
  {$ifdef  SPLASH_ON}
  if Assigned(SplashScreenForm) then
    SplashScreenForm.UpdateImages;
  {$endif}
//  Application.CreateForm(TAboutForm, AboutForm);
  {$ifdef  SPLASH_ON}
  if Assigned(SplashScreenForm) then
    SplashScreenForm.UpdateImages;
  {$endif}
  Application.CreateForm(TProgramOptionsForm, ProgramOptionsForm);
  {$ifdef  SPLASH_ON}
  if Assigned(SplashScreenForm) then
    SplashScreenForm.UpdateImages;
  {$endif}
  //Application.CreateForm(THowToBuyForm, HowToBuyForm);

  {$ifdef  SPLASH_ON}
  //Hide Splash Screen
  if Assigned(SplashScreenForm) then
  begin
    while not SplashScreenForm.Done do
      SplashScreenForm.UpdateImages;

    SplashScreenForm.Update;
    Procs.SleepNoBlock(100);

    { -- For Test
    while(True) do
    begin
      Application.ProcessMessages;
      Procs.SleepNoBlock(10);
    end;
    //}
    
    SplashScreenForm.Hide;
    SplashScreenForm.Free;
  end;
  {$endif}

  Screen.Cursor := crDefault;
  Application.Run;
end.
