unit Model1;

interface

const
      MODEL_WORD = '1A35';
      _LED_DISPLAY_MAX_ROW_COUNT_ = 16;
      _LED_DISPLAY_MAX_COL_COUNT_ = 128;
      _INTERNAL_LFG_INLCUDED_ = False;
      _COLOR_DISPLAY_ = False;
      _ALARM_ACTIVE_ = False;
      
      GLOBAL_ENCRYPTION_KEY = 'Tr$sV!k+Oi4hNE';
      REG_ENCODE_KEY = 'nr$8jf6SjK89W22';

      HexDigits = ['0', '1', '2', '3', '4', '5', '6', '7', '8',
                   '9', 'A', 'B', 'C', 'D', 'E', 'F'];

      //Encryption keys
      ENCRYPTION_KEYS : array[0..15] of String[13] = (
        'kWekfl{fk%4k0',
        'sW2tCvmLGKdp4',
        'xNb32%fk^,Azl',
        '@1j$jfoP0{+-6',
        'o$jfFkD0(k!2=',
        'xZsBnh8%kN$od',
        '1@~sEr$tk+j&k',
        'CvgF^o(f9f4DY',
        'fD4of+0v2mXzl',
        ';jro}[4$kdy^D',
        'aZdk(iTrk~k]c',
        'Fgt78Sw\dw|$4',
        'xSd9fj88fGkCo',
        'f$3f+6kVnGSwQ',
        'Cxd$3k*9fVbl@',
        'cNgYgkDb{;UiZ'
      );

implementation

end.
