unit Model3G;

interface

const
      MODEL_WORD = '78E1';
      _LED_DISPLAY_MAX_ROW_COUNT_ = 32;
      _LED_DISPLAY_MAX_COL_COUNT_ = 128;
      _INTERNAL_LFG_INLCUDED_ = True;
      _COLOR_DISPLAY_ = False;
      _ALARM_ACTIVE_ = False;

      GLOBAL_ENCRYPTION_KEY = 't0$k@xZp](tVeM';
      REG_ENCODE_KEY = 'j$4kd+k^kYu7D3e';

      HexDigits = ['0', '1', '2', '3', '4', '5', '6', '7', '8',
                   '9', 'A', 'B', 'C', 'D', 'E', 'F'];

      //Encryption keys
      ENCRYPTION_KEYS : array[0..15] of String[13] = (
        'd#ek+%4kfTYk&',
        'd#d+G6kgRpW23',
        'jr$5k+T5kFdl#',
        'dE3l;+%fkDE2s',
        'Del+%rlFRelSw',
        'fGri+^5l@#4vG',
        'fR43%lFrd+^la',
        'dE23+%fk90dCW',
        'cDflH]D>dkEmv',
        'dE<hlOj[|d#k6',
        'dVbzxre#4w24H',
        'fjTybV65^jDXn',
        'E2Fvk%gk+kCD,',
        'xDsr#4+lYgjVm',
        'fR,$k+H6kUiXs',
        'Xsl@3kP[f]Gjw'
      );

implementation

end.
