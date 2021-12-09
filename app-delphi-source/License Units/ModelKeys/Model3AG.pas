unit Model3AG;

interface

const
      MODEL_WORD = '26CB';
      _LED_DISPLAY_MAX_ROW_COUNT_ = 32;
      _LED_DISPLAY_MAX_COL_COUNT_ = 128;
      _INTERNAL_LFG_INLCUDED_ = True;
      _COLOR_DISPLAY_ = False;
      _ALARM_ACTIVE_ = True;

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

implementation

end.
