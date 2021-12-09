
{$INCLUDE 'F:\LED Display\Delphi\MAIN\LED Display Control Software\Project\ConfigModel.inc'}

(*
{$if defined(_MODEL_WITH_COLOR_)}
  {$ifndef _MODEL_1_}
    {$MESSAGE Error 'ERROR: Color display is only for 16-row display.'}
  {$endif}
  {$ifndef _MODEL_WITH_LFG_}
    {$MESSAGE Error 'ERROR: LED Font Generator must be included with color display.'}
  {$endif}
  {$ifdef _MODEL_WITH_ALARM_}
    {$MESSAGE Error 'ERROR: Alarm must not be enabled on the color display.'}
  {$endif}
      GLOBAL_ENCRYPTION_KEY = 'E2tyNcNb7^p[Za';
      REG_ENCODE_KEY = 'flp^5-0kFdlo32F';

      HexDigits = ['0', '1', '2', '3', '4', '5', '6', '7', '8',
                   '9', 'A', 'B', 'C', 'D', 'E', 'F'];

      //Encryption keys
      ENCRYPTION_KEYS : array[0..15] of String[13] = (
        'Fr4-%kf}doE3x',
        'vFrl$3d+Gtk6k',
        'vFrk78*lofDps',
        'cDel3@+f;l9Cd',
        'cD2kd)6lfnmsN',
        'v,lTopfDkPrjS',
        'DfkE45GTRpvD;',
        'dEl$ld9^mg+&k',
        'Fk^kd0Yo6;2dW',
        'dQk@1i+6lFpoc',
        'cFNmFdl4D>k#@',
        'cDfkP=trio&oE',
        'Sw@EkkGvl78GF',
        'f$k560GY6kCdo',
        'cDek32+pl^oFd',
        'cfRj6ogYYi+@d'
      );
{$else}

{$ifend}

*)

