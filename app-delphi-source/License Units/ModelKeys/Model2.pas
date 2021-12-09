unit Model2;

interface

const
      MODEL_WORD = 'C5D4';
      _LED_DISPLAY_MAX_ROW_COUNT_ = 24;
      _LED_DISPLAY_MAX_COL_COUNT_ = 128;
      _INTERNAL_LFG_INLCUDED_ = False;
      _COLOR_DISPLAY_ = False;
      _ALARM_ACTIVE_ = False;

      GLOBAL_ENCRYPTION_KEY = '9%f2K[XnIl8$BN';
      REG_ENCODE_KEY = 'jk%ksd#0.sdk@kA';

      HexDigits = ['0', '1', '2', '3', '4', '5', '6', '7', '8',
                   '9', 'A', 'B', 'C', 'D', 'E', 'F'];

      //Encryption keys
      ENCRYPTION_KEYS : array[0..15] of String[13] = (
        'k%kd_l&gkEwp#',
        'k%fkDE3o&yosw',
        'c}jlg\k<f,25Q',
        'k9%jd3hjTu?Cx',
        's@sg$0f)k*kER',
        'vGn#j+9fH5k@i',
        'g%i^k8+lk*ldE',
        's@sjVcFdm&k+0',
        'd#dj%fkvC8(l1',
        'x#k+6Fi*ldVdg',
        'c#j$tj^*kd+k*',
        'dFewo5Bh78d0!',
        'cF4h3%kswF5^k',
        'd#djY^ljWp]23',
        'dh$3kVc%d7SDl',
        'c#dj$32jUhF9+'
      );

implementation

end.
