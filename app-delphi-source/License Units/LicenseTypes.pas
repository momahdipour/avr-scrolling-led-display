unit LicenseTypes;

interface

type
  TLicenseModel = (lmNone,
                   {$IFDEF NORMAL_MODEL}
                   lmModel1, lmModel1Alarm, lmModel1LFG, lmModel1AlarmLFG,
                   lmModel2, lmModel2Alarm, lmModel2LFG, lmModel2AlarmLFG,
                   lmModel3, lmModel3Alarm, lmModel3LFG, lmModel3AlarmLFG,
                   {$ENDIF}
                   {$IFDEF FULL_BRIGHT}
                   lmBRModel1, lmBRModel2, lmBRModel3
                   {$ENDIF}
                  );

implementation

end.
