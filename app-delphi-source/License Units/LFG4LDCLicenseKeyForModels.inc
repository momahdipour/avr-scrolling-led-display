
{$INCLUDE 'F:\LED Display\Delphi\MAIN\LED Display Control Software\Project\ConfigModel.inc'}

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

//////////////////////////////////////////////////////////////////////////////////////////////
//  MODEL 1
{$if defined(_MODEL_1_)}
  {$if defined(_MODEL_WITH_ALARM_)}
    {$if defined(_MODEL_WITH_LFG_)}
      GLOBAL_ENCRYPTION_KEY = 'A0c3y@8X!0JpVH';
      REG_ENCODE_KEY = 'O0[t!4=3fy&Gbc9';

      HexDigits = ['0', '1', '2', '3', '4', '5', '6', '7', '8',
                   '9', 'A', 'B', 'C', 'D', 'E', 'F'];

      //Encryption keys
      ENCRYPTION_KEYS : array[0..15] of String[13] = (
        'wFggp40)%flXa',
        'gry5RDwss;pq]',
        'zBf!52d82UipQ',
        'aqSg5^hbf1vLp',
        '~12fgI7c9)fdr',
        'vNyklh7860bNt',
        '3rTtG3iVdDgD1',
        '=5Gfgxclkbd0+',
        '-4lWqa07xfCvZ',
        'dmkpc%675aTqA',
        '\]d6l:xXspqqW',
        'XdFgErt@bNse4',
        '1@3dSggKf(8ym',
        '4FgHrE45T8fZc',
        'vjfyIidW83W-0',
        'z+puJl83lpmvC'
      );
    {$else}
      GLOBAL_ENCRYPTION_KEY = '0*0*0*0*0*0*0*';
      REG_ENCODE_KEY = '0*0*0*0*0*0*0*0';

      HexDigits = ['0', '1', '2', '3', '4', '5', '6', '7', '8',
                   '9', 'A', 'B', 'C', 'D', 'E', 'F'];

      //Encryption keys
      ENCRYPTION_KEYS : array[0..15] of String[13] = (
        '0*0*0*0*0*0*0',
        '0*0*0*0*0*0*0',
        '0*0*0*0*0*0*0',
        '0*0*0*0*0*0*0',
        '0*0*0*0*0*0*0',
        '0*0*0*0*0*0*0',
        '0*0*0*0*0*0*0',
        '0*0*0*0*0*0*0',
        '0*0*0*0*0*0*0',
        '0*0*0*0*0*0*0',
        '0*0*0*0*0*0*0',
        '0*0*0*0*0*0*0',
        '0*0*0*0*0*0*0',
        '0*0*0*0*0*0*0',
        '0*0*0*0*0*0*0',
        '0*0*0*0*0*0*0'
      );
    {$ifend}
  {$else}
    {$if defined(_MODEL_WITH_LFG_)}
      GLOBAL_ENCRYPTION_KEY = '76jgS@3$sL"lB}';
      REG_ENCODE_KEY = '@df%Ghb+0)bb&*=';

      HexDigits = ['0', '1', '2', '3', '4', '5', '6', '7', '8',
                   '9', 'A', 'B', 'C', 'D', 'E', 'F'];

      //Encryption keys
      ENCRYPTION_KEYS : array[0..15] of String[13] = (
        'dk5%6jv@jdo&i',
        'cmvioqEFhk$33',
        '33jndop^ykbsp',
        '1@34+gg8f&kaE',
        'sWrk^l97v+kED',
        'xCdF3#rk+7^j%',
        '#fmBndDlo\gi/',
        'yTbCDkSl)kF34',
        '-_=2$hg^iOdSC',
        'sWeBnjH8%4k0w',
        'jGfl$l+)dk&k@',
        'CdsZBhVJck#1f',
        'nbTmgoPdjDEl{',
        '}fj\dk@jd^fgj',
        'bDcerwi%892vU',
        'W2%)9jf&h*vCE'
      );
    {$else}
      GLOBAL_ENCRYPTION_KEY = '0*0*0*0*0*0*0*';
      REG_ENCODE_KEY = '0*0*0*0*0*0*0*0';

      HexDigits = ['0', '1', '2', '3', '4', '5', '6', '7', '8',
                   '9', 'A', 'B', 'C', 'D', 'E', 'F'];

      //Encryption keys
      ENCRYPTION_KEYS : array[0..15] of String[13] = (
        '0*0*0*0*0*0*0',
        '0*0*0*0*0*0*0',
        '0*0*0*0*0*0*0',
        '0*0*0*0*0*0*0',
        '0*0*0*0*0*0*0',
        '0*0*0*0*0*0*0',
        '0*0*0*0*0*0*0',
        '0*0*0*0*0*0*0',
        '0*0*0*0*0*0*0',
        '0*0*0*0*0*0*0',
        '0*0*0*0*0*0*0',
        '0*0*0*0*0*0*0',
        '0*0*0*0*0*0*0',
        '0*0*0*0*0*0*0',
        '0*0*0*0*0*0*0',
        '0*0*0*0*0*0*0'
      );
    {$ifend}
  {$ifend}
{$ifend}
//////////////////////////////////////////////////////////////////////////////////////////////


//////////////////////////////////////////////////////////////////////////////////////////////
//  MODEL 2
{$if defined(_MODEL_2_)}
  {$if defined(_MODEL_WITH_ALARM_)}
    {$if defined(_MODEL_WITH_LFG_)}
      GLOBAL_ENCRYPTION_KEY = 'WDl:$>2!rGjitp';
      REG_ENCODE_KEY = 'dh45#kvc0YjSxBS';

      HexDigits = ['0', '1', '2', '3', '4', '5', '6', '7', '8',
                   '9', 'A', 'B', 'C', 'D', 'E', 'F'];

      //Encryption keys
      ENCRYPTION_KEYS : array[0..15] of String[13] = (
        'opWErfGRb67Xg',
        'fRjCXm56H[pf@',
        'w!2vm,T6%l]o\',
        'cVgD7^7Hn4cXj',
        'zVn>g//f?k340',
        'cGj@woDSkgP0-',
        'cDfk@!lf+k5Bx',
        'x#rkg^lf0Ti8s',
        'xFgke@309gHlo',
        'cHnk%6flk9!2v',
        'vGhk$%ld!~l+0',
        'vGflNb67f$r%d',
        'cDfZaw53$k{c]',
        'd$5fdfoi^5f21',
        'cGhkSwkPlfO1f',
        'c]f|skl/f|\d#'
      );
    {$else}
      GLOBAL_ENCRYPTION_KEY = '0*0*0*0*0*0*0*';
      REG_ENCODE_KEY = '0*0*0*0*0*0*0*0';

      HexDigits = ['0', '1', '2', '3', '4', '5', '6', '7', '8',
                   '9', 'A', 'B', 'C', 'D', 'E', 'F'];

      //Encryption keys
      ENCRYPTION_KEYS : array[0..15] of String[13] = (
        '0*0*0*0*0*0*0',
        '0*0*0*0*0*0*0',
        '0*0*0*0*0*0*0',
        '0*0*0*0*0*0*0',
        '0*0*0*0*0*0*0',
        '0*0*0*0*0*0*0',
        '0*0*0*0*0*0*0',
        '0*0*0*0*0*0*0',
        '0*0*0*0*0*0*0',
        '0*0*0*0*0*0*0',
        '0*0*0*0*0*0*0',
        '0*0*0*0*0*0*0',
        '0*0*0*0*0*0*0',
        '0*0*0*0*0*0*0',
        '0*0*0*0*0*0*0',
        '0*0*0*0*0*0*0'
      );
    {$ifend}
  {$else}
    {$if defined(_MODEL_WITH_LFG_)}
      GLOBAL_ENCRYPTION_KEY = '3ER51!vXiFpn>(';
      REG_ENCODE_KEY = 'fh%4kn&l0]SmxzA';

      HexDigits = ['0', '1', '2', '3', '4', '5', '6', '7', '8',
                   '9', 'A', 'B', 'C', 'D', 'E', 'F'];

      //Encryption keys
      ENCRYPTION_KEYS : array[0..15] of String[13] = (
        'dk#2kk^5l+flk',
        'd#kdi$5kF+kGd',
        '\Fdl?l/f|p$5d',
        'xZsl#f4fl"k!o',
        's@k%4lCDl+o&0',
        'd#k^5oVCf&-d5',
        'De#2k%6g+d^k8',
        'cFl$3l8_lfDe#',
        's@1l_6lkDoXzs',
        'fl&tvmDEps932',
        'd|d[<sk%fQ1[c',
        'f$rjf^t9dl#|s',
        'cv|khmDu675jS',
        'vgHT6%k*lcdmR',
        'd#ek%FflmCll@',
        'D3k$l+dl^kCdl'
      );
    {$else}
      GLOBAL_ENCRYPTION_KEY = '0*0*0*0*0*0*0*';
      REG_ENCODE_KEY = '0*0*0*0*0*0*0*0';

      HexDigits = ['0', '1', '2', '3', '4', '5', '6', '7', '8',
                   '9', 'A', 'B', 'C', 'D', 'E', 'F'];

      //Encryption keys
      ENCRYPTION_KEYS : array[0..15] of String[13] = (
        '0*0*0*0*0*0*0',
        '0*0*0*0*0*0*0',
        '0*0*0*0*0*0*0',
        '0*0*0*0*0*0*0',
        '0*0*0*0*0*0*0',
        '0*0*0*0*0*0*0',
        '0*0*0*0*0*0*0',
        '0*0*0*0*0*0*0',
        '0*0*0*0*0*0*0',
        '0*0*0*0*0*0*0',
        '0*0*0*0*0*0*0',
        '0*0*0*0*0*0*0',
        '0*0*0*0*0*0*0',
        '0*0*0*0*0*0*0',
        '0*0*0*0*0*0*0',
        '0*0*0*0*0*0*0'
      );
    {$ifend}
  {$ifend}
{$ifend}
//////////////////////////////////////////////////////////////////////////////////////////////


//////////////////////////////////////////////////////////////////////////////////////////////
//  MODEL 3
{$if defined(_MODEL_3_)}
  {$if defined(_MODEL_WITH_ALARM_)}
    {$if defined(_MODEL_WITH_LFG_)}
      GLOBAL_ENCRYPTION_KEY = '7YfC+L:w#B7jCr';
      REG_ENCODE_KEY = 'd]sk$di@skp;pTc';

      HexDigits = ['0', '1', '2', '3', '4', '5', '6', '7', '8',
                   '9', 'A', 'B', 'C', 'D', 'E', 'F'];

      //Encryption keys
      ENCRYPTION_KEYS : array[0..15] of String[13] = (
        'sl$3kFdkpTk,A',
        'dWek#kf)dl6vD',
        'd#kd+f%kfYUlc',
        'x#dkLofp$5kxs',
        'd#ek%^okfe985',
        'd#dkGT5lBm021',
        's1#RfoPfi%icZ',
        's@1+6G^lDfLx^',
        'd#dlCxd+^l%kR',
        'Tg&kCdvfR6UJa',
        'dCfrGhjp^0eDl',
        'l)l&kF2sCfk$j',
        'dRk%kEWs;#4lf',
        'f$fk%ok+5^o@S',
        'dE3f+%4kFEDw@',
        'fFgl+%rkUFewQ'
      );
    {$else}
      GLOBAL_ENCRYPTION_KEY = '0*0*0*0*0*0*0*';
      REG_ENCODE_KEY = '0*0*0*0*0*0*0*0';

      HexDigits = ['0', '1', '2', '3', '4', '5', '6', '7', '8',
                   '9', 'A', 'B', 'C', 'D', 'E', 'F'];

      //Encryption keys
      ENCRYPTION_KEYS : array[0..15] of String[13] = (
        '0*0*0*0*0*0*0',
        '0*0*0*0*0*0*0',
        '0*0*0*0*0*0*0',
        '0*0*0*0*0*0*0',
        '0*0*0*0*0*0*0',
        '0*0*0*0*0*0*0',
        '0*0*0*0*0*0*0',
        '0*0*0*0*0*0*0',
        '0*0*0*0*0*0*0',
        '0*0*0*0*0*0*0',
        '0*0*0*0*0*0*0',
        '0*0*0*0*0*0*0',
        '0*0*0*0*0*0*0',
        '0*0*0*0*0*0*0',
        '0*0*0*0*0*0*0',
        '0*0*0*0*0*0*0'
      );
    {$ifend}
  {$else}
    {$if defined(_MODEL_WITH_LFG_)}
      GLOBAL_ENCRYPTION_KEY = 't0$k@xZp](tVeM';
      REG_ENCODE_KEY = 'j$4kd+k^kYu7D3e';

      HexDigits = ['0', '1', '2', '3', '4', '5', '6', '7', '8',
                   '9', 'A', 'B', 'C', 'D', 'E', 'F'];

      //Encryption keys
      ENCRYPTION_KEYS : array[0..15] of String[13] = (
        'd#ek+%4kfTYk&',
        'd#d+G6kgRpW23',
        'jr$5k+T5kFdl#',
        'dE3l;+%fkDE2s',
        'Del+%rlFRelSw',
        'fGri+^5l@#4vG',
        'fR43%lFrd+^la',
        'dE23+%fk90dCW',
        'cDflH]D>dkEmv',
        'dE<hlOj[|d#k6',
        'dVbzxre#4w24H',
        'fjTybV65^jDXn',
        'E2Fvk%gk+kCD,',
        'xDsr#4+lYgjVm',
        'fR,$k+H6kUiXs',
        'Xsl@3kP[f]Gjw'
      );
    {$else}
      GLOBAL_ENCRYPTION_KEY = '0*0*0*0*0*0*0*';
      REG_ENCODE_KEY = '0*0*0*0*0*0*0*0';

      HexDigits = ['0', '1', '2', '3', '4', '5', '6', '7', '8',
                   '9', 'A', 'B', 'C', 'D', 'E', 'F'];

      //Encryption keys
      ENCRYPTION_KEYS : array[0..15] of String[13] = (
        '0*0*0*0*0*0*0',
        '0*0*0*0*0*0*0',
        '0*0*0*0*0*0*0',
        '0*0*0*0*0*0*0',
        '0*0*0*0*0*0*0',
        '0*0*0*0*0*0*0',
        '0*0*0*0*0*0*0',
        '0*0*0*0*0*0*0',
        '0*0*0*0*0*0*0',
        '0*0*0*0*0*0*0',
        '0*0*0*0*0*0*0',
        '0*0*0*0*0*0*0',
        '0*0*0*0*0*0*0',
        '0*0*0*0*0*0*0',
        '0*0*0*0*0*0*0',
        '0*0*0*0*0*0*0'
      );
    {$ifend}
  {$ifend}
{$ifend}
//////////////////////////////////////////////////////////////////////////////////////////////

{$ifend}
