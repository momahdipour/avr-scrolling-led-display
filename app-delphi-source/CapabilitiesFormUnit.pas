unit CapabilitiesFormUnit;

{$INCLUDE Config.inc}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, TntForms, StdCtrls, TntStdCtrls, sButton, sSkinProvider, sLabel,
  sGroupBox, ProgramConsts, License, License2;

type
  TCapabilitiesForm = class(TTntForm)
    sSkinProvider1: TsSkinProvider;
    OKBtn: TsButton;
    sLabel1: TsLabel;
    sGroupBox1: TsGroupBox;
    sLabel7: TsLabel;
    sLabel8: TsLabel;
    sLabel9: TsLabel;
    sLabel10: TsLabel;
    sLabel11: TsLabel;
    sLabel12: TsLabel;
    sLabel13: TsLabel;
    sLabel15: TsLabel;
    sLabel14: TsLabel;
    sLabel2: TsLabel;
    sLabel6: TsLabel;
    sLabel3: TsLabel;
    sLabel4: TsLabel;
    sLabel5: TsLabel;
    MaxDimensionsLabel: TsLabel;
    sLabel16: TsLabel;
    sLabel17: TsLabel;
    ColorCountLabel: TsLabel;
    DateTimeLabel: TsLabel;
    TemperatureLabel: TsLabel;
    ScrollingTextLabel: TsLabel;
    PictureLabel: TsLabel;
    AnimationLabel: TsLabel;
    TextEffectsLabel: TsLabel;
    PageEffectsLabel: TsLabel;
    LayoutLabel: TsLabel;
    TimeSpanLabel: TsLabel;
    AlarmLabel: TsLabel;
    AlarmCountLabel: TsLabel;
    AlarmSystem12MonthTypeLabel: TsLabel;
    procedure TntFormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  CapabilitiesForm: TCapabilitiesForm;

implementation

uses MainUnit;

{$R *.dfm}

procedure TCapabilitiesForm.TntFormCreate(Sender: TObject);
begin
  MaxDimensionsLabel.Caption := WideFormat(Dyn_Texts[121] {'%s Rows x %s Columns'}, [IntToStr(License._LED_DISPLAY_MAX_ROW_COUNT_), IntToStr(License._LED_DISPLAY_MAX_COL_COUNT_)]);
  if License._COLOR_DISPLAY_ then
    ColorCountLabel.Caption := '3'  //Color displays have only 3 colors in this version
  else
    ColorCountLabel.Caption := '1';  //If not a color display, it is indeed 1 color display!

  {$if Defined(_TIME_ACTIVE_) and Defined(_DATE_ACTIVE_)}
  DateTimeLabel.Caption := Dyn_Texts[84];  //'Has'
  {$else}
  DateTimeLabel.Caption := Dyn_Texts[85];  //'Do not have'
  {$ifend}

  {$ifdef _TEXT_ANIMATIONS_ACTIVE_}
  TextEffectsLabel.Caption := Dyn_Texts[84];  //'Has'
  {$else}
  TextEffectsLabel.Caption := Dyn_Texts[85];  //'Do not have'
  {$endif}

  {$ifdef _PAGE_EFFECTS_ACTIVE_}
  PageEffectsLabel.Caption := Dyn_Texts[84];  //'Has'
  {$else}
  PageEffectsLabel.Caption := Dyn_Texts[85];  //'Do not have'
  {$endif}

  {$ifdef _STAGE_LAYOUT_ACTIVE_}
  LayoutLabel.Caption := Dyn_Texts[84];  //'Has'
  {$else}
  LayoutLabel.Caption := Dyn_Texts[85];  //'Do not have'
  {$endif}

  {$ifdef _SCROLLING_TEXT_ACTIVE_}
  ScrollingTextLabel.Caption := Dyn_Texts[84];  //'Has'
  PictureLabel.Caption := Dyn_Texts[84];  //'Has'
  {$else}
  ScrollingTextLabel.Caption := Dyn_Texts[85];  //'Do not have'
  PictureLabel.Caption := Dyn_Texts[85];  //'Do not have'
  {$endif}

  {$ifdef _ANIMATION_ACTIVE_}
  AnimationLabel.Caption := Dyn_Texts[84];  //'Has'
  {$else}
  AnimationLabel.Caption := Dyn_Texts[85];  //'Do not have'
  {$endif}

  {$ifdef _TEMPERATURE_ACTIVE_}
  TemperatureLabel.Caption := Dyn_Texts[84];  //'Has'
  {$else}
  TemperatureLabel.Caption := Dyn_Texts[85];  //'Do not have'
  {$endif}

  {$ifdef _TIME_SPAN_ACTIVE_}
  TimeSpanLabel.Caption := Dyn_Texts[84];  //'Has'
  {$else}
  TimeSpanLabel.Caption := Dyn_Texts[85];  //'Do not have'
  {$endif}

  if License2._ALARM_ACTIVE_ then
  begin
    AlarmLabel.Caption := Dyn_Texts[84];  //'Has'
    AlarmCountLabel.Caption := IntToStr(_MAX_ALARM_COUNT_);
    {$ifdef _ALARM_TYPE_12_MONTHS}
    AlarmSystem12MonthTypeLabel.Caption := Dyn_Texts[84];  //'Has'
    {$else}
    AlarmSystem12MonthTypeLabel.Caption := Dyn_Texts[85];  //'Do not have'
    {$endif}
  end
  else
  begin
    AlarmLabel.Caption := Dyn_Texts[85];  //'Do not have'
    AlarmCountLabel.Caption := '0';
    AlarmSystem12MonthTypeLabel.Caption := Dyn_Texts[85];  //'Do not have'
  end;
end;

end.
