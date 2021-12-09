(*
//Select Model or choose full model (with color)
//{$DEFINE    _FULL_MODEL_FOR_US_}  //If defined, this will override other model settings

//{$DEFINE    _MODEL_1_}  //16x128
//{$DEFINE    _MODEL_2_}  //24x128
{$DEFINE    _MODEL_3_}  //32x128

//Include LED Font Generator Limited Edition with the model or not?
{$DEFINE      _MODEL_WITH_LFG_}

//Model has alarm capabilities or not
{$DEFINE    _MODEL_WITH_ALARM_}

//Currently all models are single color displays only
//{$DEFINE    _MODEL_WITH_COLOR_}




//---------------------------------------------------------------------------
//---------------------------------------------------------------------------
{$ifdef _FULL_MODEL_FOR_US_}
  {$DEFINE _MODEL_3_}
  {$DEFINE _MODEL_WITH_LFG_}
  {$DEFINE _MODEL_WITH_ALARM_}
  {$DEFINE _MODEL_WITH_COLOR_}
{$endif}
*)
