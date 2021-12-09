unit BRModel2;

interface

const
      MODEL_WORD = 'D34F';
      _LED_DISPLAY_MAX_ROW_COUNT_ = 24;
      _LED_DISPLAY_MAX_COL_COUNT_ = 128;
      _INTERNAL_LFG_INLCUDED_ = True;
      _COLOR_DISPLAY_ = False;
      _ALARM_ACTIVE_ = True;

      GLOBAL_ENCRYPTION_KEY = '8gHi32An90@VBD';
      REG_ENCODE_KEY = 'l[23Sw90FT3}1@g';

      HexDigits = ['0', '1', '2', '3', '4', '5', '6', '7', '8',
                   '9', 'A', 'B', 'C', 'D', 'E', 'F'];

      //Encryption keys
      ENCRYPTION_KEYS : array[0..15] of String[13] = (
        'fgt672jDk(2@m',
        'xcv@13+-d=Gtu',
        'IoeSw45cD981x',
        'zLap23Fv*09gh',
        '2Rr45eP+zSk78',
        'v$j73#jg12XDo',
        's@1k+rlk=%jVF',
        'xDf45GmLo32ct',
        '1@fdloG;l87#d',
        'sdh#4ms10hhyt',
        'CH74OS$37PFS!',
        'DLP+RI9MASHsD',
        'Dfj@3jk2GTl89',
        'dm@309ftjDmck',
        'dj#kk43@m38ol',
        'db#4ijmHyp0A1'
      );

implementation

end.
