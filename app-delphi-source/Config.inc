
{$INCLUDE ConfigModel.inc}

(*
{$ifndef _FULL_MODEL_FOR_US_}
  {$if Defined(_MODEL_1_)}
    {$if defined(_MODEL_2_) or defined(_MODEL_3_)}
      {$MESSAGE Error 'ERROR: Select only one model for the LED Display.'}
    {$ifend}
  {$ifend}
  {$if Defined(_MODEL_2_)}
    {$if defined(_MODEL_1_) or defined(_MODEL_3_)}
      {$MESSAGE Error 'ERROR: Select only one model for the LED Display.'}
    {$ifend}
  {$ifend}
  {$if Defined(_MODEL_3_)}
    {$if defined(_MODEL_2_) or defined(_MODEL_1_)}
      {$MESSAGE Error 'ERROR: Select only one model for the LED Display.'}
    {$ifend}
  {$ifend}
{$endif}

{$if not defined(_MODEL_1_) and not defined(_MODEL_2_) and not defined(_MODEL_3_)}
  {$MESSAGE Error 'ERROR: Please select a MODEL'}
{$ifend}

//Color settings
{$IFDEF _MODEL_WITH_COLOR_}
  {$DEFINE    _COLOR_DISPLAY_}
{$ENDIF}
*)

//Capabilities
{$DEFINE    _TIME_ACTIVE_}
{$DEFINE    _DATE_ACTIVE_}
{$DEFINE    _TEXT_ANIMATIONS_ACTIVE_}
{$DEFINE    _PAGE_EFFECTS_ACTIVE_}
{$DEFINE    _STAGE_LAYOUT_ACTIVE_}
{$DEFINE    _SCROLLING_TEXT_ACTIVE_}
{$DEFINE    _SWF_ACTIVE_}
{$DEFINE    _ANIMATION_ACTIVE_}
{$DEFINE    _TEMPERATURE_ACTIVE_}
{$DEFINE    _TIME_SPAN_ACTIVE_}
//{$DEFINE    _DATE_TIME_ADJUST_BUTTONS_ACTIVE}  --> Not for delphi program!
{$DEFINE    _TRIAL_LIMIT_ACTIVE_}  //This is only used in the Configurator
{$DEFINE    _AREA_BORDERS_ACTIVE_}  //Must be always active

{$IFDEF _MODEL_WITH_LFG_}
  {$DEFINE    _INTERNAL_LFG_INLCUDED_}
{$ENDIF}


//Alarm settings
//{$IFDEF _MODEL_WITH_ALARM_}
  //{$DEFINE    _ALARM_TYPE_ONLY_1_MONTH}
  //{$DEFINE    _ALARM_TYPE_12_MONTHS}
  {$DEFINE    _ALARM_TYPE_ALL_TYPES_}
//{$ENDIF}

{$IFDEF _ALARM_TYPE_ALL_TYPES_}
  {$IF Defined(_ALARM_TYPE_ONLY_1_MONTH) or Defined(_ALARM_TYPE_12_MONTHS)}
    {$MESSAGE Error 'ERROR: Only _ALARM_TYPE_ALL_TYPES_ or one kind of any other alarm systems can be activated at the same time.'}
  {$IFEND}
{$ENDIF}
{$IF Defined(_ALARM_TYPE_ONLY_1_MONTH) and Defined(_ALARM_TYPE_12_MONTHS)}
  {$MESSAGE Error 'ERROR: Only one type of the alarm system can be active at the same time: either "_ALARM_TYPE_ONLY_1_MONTH" or "_ALARM_TYPE_12_MONTHS".'}
{$IFEND}

{$IF Defined(_ALARM_TYPE_ONLY_1_MONTH) or Defined(_ALARM_TYPE_12_MONTHS) or Defined(_ALARM_TYPE_ALL_TYPES_)}
  {$DEFINE    _ALARM_ACTIVE_}
{$IFEND}

{$IFDEF _ALARM_TYPE_ALL_TYPES_}
  {$DEFINE  _ALARM_TYPE_ONLY_1_MONTH}
  {$DEFINE  _ALARM_TYPE_12_MONTHS}
{$ENDIF}


