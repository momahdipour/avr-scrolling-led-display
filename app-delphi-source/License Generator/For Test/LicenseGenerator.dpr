program LicenseGenerator;

uses
  Forms,
  MainUnit in 'MainUnit.pas' {MainForm},
  cls_id in 'Used Units\CPUid\cls_id.pas',
  magsubs1 in 'Used Units\WMI\magsubs1.pas',
  magwmi in 'Used Units\WMI\magwmi.pas',
  smartapi in 'Used Units\WMI\smartapi.pas',
  WbemScripting_TLB in 'Used Units\WMI\WbemScripting_TLB.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'LCD Designer License 2.0 Generator';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
