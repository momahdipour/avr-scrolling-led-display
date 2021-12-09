unit Model1G;

interface

const
      MODEL_WORD = '23A1';
      _LED_DISPLAY_MAX_ROW_COUNT_ = 16;
      _LED_DISPLAY_MAX_COL_COUNT_ = 128;
      _INTERNAL_LFG_INLCUDED_ = True;
      _COLOR_DISPLAY_ = False;
      _ALARM_ACTIVE_ = False;

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

implementation

end.
