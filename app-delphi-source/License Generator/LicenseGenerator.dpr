program LicenseGenerator;

uses
  Forms,
  MainUnit in 'MainUnit.pas' {MainForm},
  cls_id in 'Used Units\CPUid\cls_id.pas',
  magsubs1 in 'Used Units\WMI\magsubs1.pas',
  magwmi in 'Used Units\WMI\magwmi.pas',
  smartapi in 'Used Units\WMI\smartapi.pas',
  WbemScripting_TLB in 'Used Units\WMI\WbemScripting_TLB.pas',
  Windows,
  m1 in 'Model Units\Model 1\m1.pas',
  m1Alarm in 'Model Units\Model 1\m1Alarm.pas',
  m1LFG in 'Model Units\Model 1\m1LFG.pas',
  m1LFGAlarm in 'Model Units\Model 1\m1LFGAlarm.pas',
  m2 in 'Model Units\Model 2\m2.pas',
  m2Alarm in 'Model Units\Model 2\m2Alarm.pas',
  m2LFG in 'Model Units\Model 2\m2LFG.pas',
  m2LFGAlarm in 'Model Units\Model 2\m2LFGAlarm.pas',
  m3 in 'Model Units\Model 3\m3.pas',
  m3Alarm in 'Model Units\Model 3\m3Alarm.pas',
  m3LFG in 'Model Units\Model 3\m3LFG.pas',
  m3LFGAlarm in 'Model Units\Model 3\m3LFGAlarm.pas',
  ColorModel in 'Model Units\Color Display\ColorModel.pas',
  PreviewFormUnit in 'PreviewFormUnit.pas' {PreviewForm},
  BRm1 in 'Model Units\BRModels\BRm1.pas',
  BRm2 in 'Model Units\BRModels\BRm2.pas',
  BRm3 in 'Model Units\BRModels\BRm3.pas';

{$R *.res}

begin
  //Only set the affinity of the main thread, if possible
  if SetThreadAffinityMask(GetCurrentThread, 1) = 0 then  //0 means error
    SetProcessAffinityMask(GetCurrentProcess, 1);  //If unable to set only the affinity of the main thread, set the affinity of the process

  Application.Initialize;
  Application.Title := 'LED Display Control Software 1.0 Activation Code Generator';
  Application.CreateForm(TMainForm, MainForm);
  //Application.CreateForm(TPreviewForm, PreviewForm);
  Application.Run;
end.
