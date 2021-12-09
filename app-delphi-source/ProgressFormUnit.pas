unit ProgressFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, TntForms, UnitKDCommon, UnitKDSerialPort, sSkinProvider,
  Buttons, TntButtons, sSpeedButton, StdCtrls, sLabel, sGauge;

type
  TProgressForm = class(TTntForm)
    Progress: TsGauge;
    sLabel1: TsLabel;
    CancelBtn: TsSpeedButton;
    sSkinProvider1: TsSkinProvider;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ProgressForm: TProgressForm;

implementation

{$R *.dfm}

end.
