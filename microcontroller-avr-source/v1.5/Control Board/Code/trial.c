//Trial check

#ifndef _DEBUG_
eeprom unsigned int TrialLimit = 0;  //Maximum numbr of times allowed to change data
eeprom unsigned int TrialCount = 0;  //Number of times data has been changed
#endif

BOOL CheckTrial()
{
  //if trial limit is active, check it, otherwise return False to have no limit for trial
  #ifdef  _TRIAL_LIMIT_ACTIVE_
  if(TrialLimit > 0)
  {
    if((TrialCount > TrialLimit) || (TrialLimit == 0xffff))  //Trial limit is not allowed to be set as 0xffff because TrialCount will be greater than TrialLimit
    {
      ResetMemoryData(TRUE);  //IMPORTANT ATTENTION: If we call it with FALSE value by mistake, data stack overflow will occur due to recursive calls.
      return(TRUE);
      //MicroReset();  //Reset
    }
  }
  #endif
  return(FALSE);
}

BOOL TrialTimedOut()
{
  #ifdef  _TRIAL_LIMIT_ACTIVE_
  if(TrialLimit == 0)
    return(FALSE);
  else if(TrialCount > TrialLimit)
    return(TRUE);
  else
    return(FALSE);
  #else
    //If trial limit is not active, simply return FALSE to have no limitation.
    return(FALSE);
  #endif
}

/*
eeprom unsigned int TrialLimit = 0;  //In days
eeprom unsigned int TrialDaysElapsed = 0;
eeprom BOOL TrialApplied = FALSE;

bit TrialEnabled = 0;
unsigned int TrialCounter = 0;
unsigned int TrialMinuteCounter = 0;
unsigned int TickCountsPerMinute = 0;

void ResetTrial()
{
  stop_refresh();
  
  if(TrialLimit > 0)
  {
    TrialEnabled = 1;
  }
  else
  {
    TrialEnabled = 0;
  }
  
  TrialCounter = 0;
  TrialMinuteCounter = 0;
  //TrialDaysElapsed = 0;
  TrialApplied = FALSE;
  
  start_refresh();
}

void CheckTrial()
{
  if((TrialDaysElapsed >= TrialLimit) && !TrialApplied)
  {
    ResetMemoryData(TRUE);
    TrialApplied = TRUE;
    MicroReset();  //Reset
  }
}
*/