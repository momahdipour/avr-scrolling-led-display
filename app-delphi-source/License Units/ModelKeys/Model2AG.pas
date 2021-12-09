unit Model2AG;

interface

const
      MODEL_WORD = 'A89F';
      _LED_DISPLAY_MAX_ROW_COUNT_ = 24;
      _LED_DISPLAY_MAX_COL_COUNT_ = 128;
      _INTERNAL_LFG_INLCUDED_ = True;
      _COLOR_DISPLAY_ = False;
      _ALARM_ACTIVE_ = True;

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

implementation

end.
