unit Model3A;

interface

const
      MODEL_WORD = 'C453';
      _LED_DISPLAY_MAX_ROW_COUNT_ = 32;
      _LED_DISPLAY_MAX_COL_COUNT_ = 128;
      _INTERNAL_LFG_INLCUDED_ = False;
      _COLOR_DISPLAY_ = False;
      _ALARM_ACTIVE_ = True;

      GLOBAL_ENCRYPTION_KEY = '5^Yf*cD2@Ublqo';
      REG_ENCODE_KEY = 'Oprj%4ikdUIHkCe';

      HexDigits = ['0', '1', '2', '3', '4', '5', '6', '7', '8',
                   '9', 'A', 'B', 'C', 'D', 'E', 'F'];

      //Encryption keys
      ENCRYPTION_KEYS : array[0..15] of String[13] = (
        's#ej+4k%6l&Fl',
        'dl#4kgk05dl8W',
        'i5#ej5jSxPyo6',
        'dE3k+6[}/"fl.',
        's@w+4%kYTmCdx',
        'dE34HJi(0f6kF',
        'dE34+^tl0k(kC',
        's@d+$3k^5kvGf',
        'e#456Gd8Xo)01',
        'd@3+&6o9DsZas',
        'dE34+t^5kBGcd',
        'd#e4+l^5kDevC',
        'x@3+^5kT9&kXs',
        'd@3+%l^lgFv>n',
        'fMbn$j+k6Do9)',
        'd@3+d$rkf^kXs'
      );

implementation

end.
