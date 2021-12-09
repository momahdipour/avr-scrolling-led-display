unit Model1A;

interface

const
      MODEL_WORD = '2B5F';
      _LED_DISPLAY_MAX_ROW_COUNT_ = 16;
      _LED_DISPLAY_MAX_COL_COUNT_ = 128;
      _INTERNAL_LFG_INLCUDED_ = False;
      _COLOR_DISPLAY_ = False;
      _ALARM_ACTIVE_ = True;

      GLOBAL_ENCRYPTION_KEY = 'IR398cv1aS345N';
      REG_ENCODE_KEY = 'uRbH73k0lo^=Q-b';

      HexDigits = ['0', '1', '2', '3', '4', '5', '6', '7', '8',
                   '9', 'A', 'B', 'C', 'D', 'E', 'F'];

      //Encryption keys
      ENCRYPTION_KEYS : array[0..15] of String[13] = (
        'wF3rp30)dfcXa',
        'gry5cDDssd4q]',
        'zB34525hjnipQ',
        'aqSaqlopx1vLp',
        '~12fgI7r5gnm8',
        'vNyklhdf34bNt',
        '3rTdsw35gbgD1',
        '=5Gs1xhlkyu8+',
        '-4cnko0d4rc1Z',
        'nni%j59wSxZp[',
        ']\jf|fkm!2koR',
        'ioYubFvk0*0#j',
        '2sD#4jgn+-0bv',
        'w@kdxLOpajhT%',
        '~ffXtgJdix(h0',
        'h5%jg^jc*j@#Q'
      );

implementation

end.
