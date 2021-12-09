
{$INCLUDE ConfigModel.inc}

(*
{$IF Defined(_MODEL_1_)}

  //16x128
  _LED_DISPLAY_MAX_ROW_COUNT_ = 16;
  _LED_DISPLAY_MAX_COL_COUNT_ = 128;
  {$DEFINE _ROW_LIMIT_16_}

{$ELSEIF Defined(_MODEL_2_)}

  //24x128
  _LED_DISPLAY_MAX_ROW_COUNT_ = 24;
  _LED_DISPLAY_MAX_COL_COUNT_ = 128;
  {$DEFINE _ROW_LIMIT_24_}

{$ELSEIF Defined(_MODEL_3_)}

  //32x128
  _LED_DISPLAY_MAX_ROW_COUNT_ = 32;
  _LED_DISPLAY_MAX_COL_COUNT_ = 128;
  {$DEFINE _ROW_LIMIT_32_}

{$IFEND}
*)

  _MAX_ALARM_COUNT_ = 31;



  {$if Defined(_ROW_LIMIT_16_)}
    {$if Defined(_ROW_LIMIT_24_) or Defined(_ROW_LIMIT_32_)}
      {$MESSAGE Error 'ERROR: Multiple row count limit has been defined.'}
    {$ifend}
  {$ifend}
  {$if Defined(_ROW_LIMIT_24_)}
    {$if defined(_ROW_LIMIT_16_) or defined(_ROW_LIMIT_32_)}
      {$MESSAGE Error 'ERROR: Multiple row count limit has been defined.'}
    {$ifend}
  {$ifend}
  {$if Defined(_ROW_LIMIT_32_)}
    {$if defined(_ROW_LIMIT_16_) or defined(_ROW_LIMIT_24_)}
      {$MESSAGE Error 'ERROR: Multiple row count limit has been defined.'}
    {$ifend}
  {$ifend}

