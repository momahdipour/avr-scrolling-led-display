unit Model2A;

interface

const
      MODEL_WORD = 'CE46';
      _LED_DISPLAY_MAX_ROW_COUNT_ = 24;
      _LED_DISPLAY_MAX_COL_COUNT_ = 128;
      _INTERNAL_LFG_INLCUDED_ = False;
      _COLOR_DISPLAY_ = False;
      _ALARM_ACTIVE_ = True;

      GLOBAL_ENCRYPTION_KEY = '9~FXewN[f&xcEV';
      REG_ENCODE_KEY = 'fk8$jsl@k0F+skW';

      HexDigits = ['0', '1', '2', '3', '4', '5', '6', '7', '8',
                   '9', 'A', 'B', 'C', 'D', 'E', 'F'];

      //Encryption keys
      ENCRYPTION_KEYS : array[0..15] of String[13] = (
        'j%dnFRe4nCxdO',
        'dEfkS#39^kcgs',
        'sW2k+8^kdElob',
        'xDf+5l$;^5@kT',
        'CRt0Y6k@pfDDv',
        'cJkiEj$30!2k)',
        'dSwi&gkr942vs',
        'd#24cf^%kHvBd',
        's@dk$59gGhaq9',
        'dE4+98fDkYkv^',
        's@f+5$k^7kRtv',
        'cDe23Y76hKlsW',
        'aW2f(d+&kB%dl',
        'f$fk%6,Vdsl*&',
        'dE3l%6l0d+k=s',
        's#eh$kmkx!2lP'
      );

implementation

end.
