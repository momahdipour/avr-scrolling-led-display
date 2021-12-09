unit Model3;

interface

const
      MODEL_WORD = '0AA3';
      _LED_DISPLAY_MAX_ROW_COUNT_ = 32;
      _LED_DISPLAY_MAX_COL_COUNT_ = 128;
      _INTERNAL_LFG_INLCUDED_ = False;
      _COLOR_DISPLAY_ = False;
      _ALARM_ACTIVE_ = False;

      GLOBAL_ENCRYPTION_KEY = 'ly%qxpTb5]rxoZ';
      REG_ENCODE_KEY = 'is#4kd%5ogO+k[d';

      HexDigits = ['0', '1', '2', '3', '4', '5', '6', '7', '8',
                   '9', 'A', 'B', 'C', 'D', 'E', 'F'];

      //Encryption keys
      ENCRYPTION_KEYS : array[0..15] of String[13] = (
        ']4Fl32+k%kCvH',
        'd@sh95GkCx;Aq',
        'd@wj+^lVflSx1',
        'f#kjLodpS[al0',
        'cDej38GgkRsp0',
        'dBnKl.w]>fk#2',
        'v>nS2pEp]+\?<',
        'dF4l+@90RcdS2',
        'fEj3+2kjHkcn^',
        'fR4lGVxl+^09D',
        'dSw2;"f]Trbxz',
        'nAzRlBr02f45%',
        '#f%$;odspjQaz',
        'cVg7%lkfPOmVC',
        'dEh3G+l&glDck',
        'Deh#2+gkE$5kV'
      );

implementation

end.
