unit BRModel3;

interface

const
      MODEL_WORD = 'BF2A';
      _LED_DISPLAY_MAX_ROW_COUNT_ = 32;
      _LED_DISPLAY_MAX_COL_COUNT_ = 128;
      _INTERNAL_LFG_INLCUDED_ = True;
      _COLOR_DISPLAY_ = False;
      _ALARM_ACTIVE_ = True;

      GLOBAL_ENCRYPTION_KEY = 'b7%55uiq\z_34h';
      REG_ENCODE_KEY = 'nmVk,S45]kS/kfR';

      HexDigits = ['0', '1', '2', '3', '4', '5', '6', '7', '8',
                   '9', 'A', 'B', 'C', 'D', 'E', 'F'];

      //Encryption keys
      ENCRYPTION_KEYS : array[0..15] of String[13] = (
        'h%47Fdol#p2!l',
        'xn0$lkdjkjgDl',
        's@2jDF87TTxS1',
        'q!2lF+fjkk-$k',
        'ednh564Fkfhn0',
        'bdg@3y6kE893j',
        'd#kjkk+Gl=3kf',
        'hf$ghHlfiE38D',
        'Cvng$j82@S21!',
        'mLdo09Ddj4=3d',
        'sd3l+FRkeg$56',
        'dk#kfu+%llDGl',
        'dj$jfkDndmE@3',
        'dF3mfl23Fllo0',
        'gd#4hFld+%78d',
        'DgbHgr78Fl!2l'
      );

implementation

end.
