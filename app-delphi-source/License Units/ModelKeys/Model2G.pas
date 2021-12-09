unit Model2G;

interface

const
      MODEL_WORD = 'F4A0';
      _LED_DISPLAY_MAX_ROW_COUNT_ = 24;
      _LED_DISPLAY_MAX_COL_COUNT_ = 128;
      _INTERNAL_LFG_INLCUDED_ = True;
      _COLOR_DISPLAY_ = False;
      _ALARM_ACTIVE_ = False;

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

implementation

end.
