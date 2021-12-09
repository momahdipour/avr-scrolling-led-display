//Alarms

#ifdef  _ALARM_ACTIVE_

eeprom unsigned char ALARM_CHEK_COUNTER = DEFAULT_ALARM_CHEK_COUNTER;  //max 254

#ifdef  _1_MONTH_ALARM_SYSTEM_
  #define   ALARM_SYSTEM_BYTES_PER_ALARM  0  //sizeof(TLDCAlarm)  -->  0 for 1-month alarm system, sizeof(TLDCAlarm) for 12-month alarm system
#endif
#ifdef  _12_MONTH_ALARM_SYSTEM_
  #define   ALARM_SYSTEM_BYTES_PER_ALARM  sizeof(TLDCAlarm)  //-->  0 for 1-month alarm system, sizeof(TLDCAlarm) for 12-month alarm system
#endif

#if MAX_ALARM_COUNT_PER_MONTH > 254
  #error ERROR: Maximum number of alarms that you can have for every month is 244 (=255 - 1). Please change the value of "MAX_ALARM_COUNT_PER_MONTH" to 254 or any value less than or equal to 254.
#endif

#if _ALARM_STORAGE_SELECT_ == _INTERNAL_EEPROM_
  eeprom unsigned char AlarmData[_ALARM_MONTH_COUNT_ * MAX_ALARM_COUNT_PER_MONTH * sizeof(TLDCAlarm)];  //The values of this array are automatically set to zero by the compiler in the MAIN.eep function
#endif

void WriteAlarmData(unsigned int mem_start_offset, unsigned char *data)
{
  unsigned int mem_offset;
  unsigned char i;
  
  mem_offset = mem_start_offset;
  
  #if     _ALARM_STORAGE_SELECT_ == _EXTERNAL_EEPROM_
    for(i = 0; i < sizeof(TLDCAlarm); i++)
    {
      mem_write(mem_offset, data[i]);
      mem_offset++;
    }
  #elif   _ALARM_STORAGE_SELECT_ == _INTERNAL_EEPROM_
    for(i = 0; i < sizeof(TLDCAlarm); i++)
    {
      AlarmData[mem_offset] = data[i];
      mem_offset++;
    }
  #endif
}

void ReadAlarmData(unsigned int mem_start_offset, unsigned char *data)
{
  #if     _ALARM_STORAGE_SELECT_ == _EXTERNAL_EEPROM_
    mem_read_block(mem_start_offset, sizeof(TLDCAlarm), data);
  #elif   _ALARM_STORAGE_SELECT_ == _INTERNAL_EEPROM_
    unsigned int mem_offset;
    unsigned char i;
  
    mem_offset = mem_start_offset;
    
    for(i = 0; i < sizeof(TLDCAlarm); i++)
    {
      data[i] = AlarmData[mem_offset];
      mem_offset++;
    }
  #endif
}

void WriteAlarm(unsigned char month, unsigned char AlarmIndex, unsigned char *AlarmData)
{
  unsigned int AlarmMemStartOffset;
  
  //DEBUG -----------------------
  //PORTC.2 = 1;
  //delay_ms(4000);
  //PORTC.2 = 0;
  //printf("AlarmMonth=%d, AlarmIndex=%d", month, AlarmIndex);
  //for(i = 0; i < sizeof(TLDCAlarm); i++)
  //  printf("<%X>", AlarmData[i]);
  //-----------------------------
  
  if(month > 0 && month <= 12 && AlarmIndex < MAX_ALARM_COUNT_PER_MONTH)
  {
    AlarmMemStartOffset = ALARM_DATA_MEM_START_OFFSET + (unsigned int) (month - 1) * MAX_ALARM_COUNT_PER_MONTH * ALARM_SYSTEM_BYTES_PER_ALARM + (unsigned int) AlarmIndex * sizeof(TLDCAlarm);
    WriteAlarmData(AlarmMemStartOffset, AlarmData);
  }
}

void ReadAlarm(unsigned char Month, unsigned char AlarmIndex, unsigned char *Alarm)  //Alarm in a pointer to the beginning of a TLDCAlarm structure
{
  unsigned char i;
  unsigned int AlarmMemStartOffset;
  
  if(Month > 0 && Month <= 12 && AlarmIndex < MAX_ALARM_COUNT_PER_MONTH)
  {
    AlarmMemStartOffset = ALARM_DATA_MEM_START_OFFSET + (unsigned int) (Month - 1) * MAX_ALARM_COUNT_PER_MONTH * ALARM_SYSTEM_BYTES_PER_ALARM + (unsigned int) AlarmIndex * sizeof(TLDCAlarm);
    //printf("Mem Offset = %u", AlarmMemStartOffset);
    ReadAlarmData(AlarmMemStartOffset, Alarm);
  }
  else
  {
    //printf("Invalid Alarm No. %d", AlarmIndex);
    //Invalid month number - no alarm: fill with 0
    for(i = 0; i < sizeof(TLDCAlarm); i++)
      Alarm[i] = 0;
  }
}

unsigned char CountActiveAlarms(unsigned char AlarmMonth)
{
  TLDCAlarm a;
  unsigned char i;
  unsigned char ActiveAlarmCount = 0;
  
  //DEBUG ---------------------------
  //PORTC.2 = 1;
  //delay_ms(6000);
  //PORTC.2 = 0;
  //---------------------------------
  for(i = 0; i < MAX_ALARM_COUNT_PER_MONTH; i++)
  {
    //printf("<Alarm No. %d,", i);
    ReadAlarm(AlarmMonth, i, (unsigned char *) &a);
    //printf(", Month=%d, Duration=%d>\n", a.Month, a.Duration);
    if(a.Duration > 0)
      ActiveAlarmCount++;
  }
  //printf("\n\nAll Done");
  
  return(ActiveAlarmCount);
}

unsigned char ActiveAlarmIndex = 0xff;


//Define ActivateAlarm as a macro to decrease code size (because it is only one sbi instruction
//It can be changed to function in future versions without any changes in the code.
#define ActivateAlarm()      PORTC.2 = 1;
/*
void ActivateAlarm()
{
  PORTC.2 = 1;
}
*/

//Define DeactivateAlarm as a macro to decrease code size (because it is only one sbi instruction
//It can be changed to function in future versions without any changes in the code.
#define DeactivateAlarm()   PORTC.2 = 0;
/*
void DeactivateAlarm()
{
  PORTC.2 = 0;
}
*/

/*
THIS FUNCTION ACTUALLY DO EXACTLY THE SAME JOB THAT THE AlarmIsActive FUNCTION DOES, BUT EVEN A LITTLE INACCURATE! SO IT IS NO LONGER NEEDED.
BOOL AlarmExpired(unsigned char month, unsigned char AlarmIndex)
{
  //AlarmNo strting from 0
  TLDCAlarm Alarm;
  TTime t;
  long int elapsed;
  
  ReadAlarm(month, AlarmIndex, (unsigned char *) &Alarm);
  
  t.h = Alarm.Hour;
  t.m = Alarm.Minute;
  t.s = Alarm.Second;
  
  elapsed = time_elapsed(t, TRUE);
  if(elapsed < 0)
    return(TRUE);
  else
  {
    if(elapsed >= Alarm.Duration)  //use >= not > because when Alarm.Duration seconds is elapsed, the alarm is expired
      return(TRUE);
  }
  
  return(FALSE);
}
*/

BOOL AlarmIsActive(unsigned char month, unsigned char AlarmIndex)
{
  //AlarmNo strting from 0
  TLDCAlarm Alarm;
  unsigned int y;
  unsigned char m, d;
  long int elapsed;
  TTime t;
  
  ReadAlarm(month, AlarmIndex, (unsigned char *) &Alarm);
  
  t.h = Alarm.Hour;
  t.m = Alarm.Minute;
  t.s = Alarm.Second;
  
  if(Alarm.Duration > 0)
  {
    if(Alarm.EveryDay == 1)
    {
      elapsed = time_elapsed(t, TRUE);
      if(elapsed == -1)
        return(FALSE);
      else if(elapsed < Alarm.Duration)  //use < not <= because when Alarm.Duration seconds is elapsed, the alarm is expired
        return(TRUE);
    }
    else
    {
      get_date(&y, &m, &d, 1);
      if(y == Alarm.Year && m == Alarm.Month && d == Alarm.Day)
      {
        elapsed = time_elapsed(t, TRUE);
        if(elapsed < 0)
          return(FALSE);
        else if(elapsed < Alarm.Duration)  //use < not <= because when Alarm.Duration seconds is elapsed, the alarm is expired
          return(TRUE);
      }
    }
  }
  
  return(FALSE);
}

void DisableAlarmIfCanBeDisabled(unsigned char month, unsigned char AlarmIndex)
{
  TLDCAlarm Alarm;
  unsigned char i;
  unsigned char *AlarmData;
  
  ReadAlarm(month, AlarmIndex, (unsigned char *) &Alarm);
  if(Alarm.EveryDay != 1 && (Alarm.AlarmFlags & 0x01) == 1)  //must not be an alarm that is activated everyday - AlarmFlag Bit 0: if 1 disable the alarm after deactivation
  {
    AlarmData = (unsigned char *) Alarm;
    //Set all
    for(i = 0; i < sizeof(TLDCAlarm); i++)
      AlarmData[i] = 0;
    Alarm.Month = month;  //It is better to always set month to correct value -- Alarm and AlarmData both point to the same memory area
    WriteAlarm(month, AlarmIndex, AlarmData);  //Now write back alarm settings to the EEPROM memory with new settings (disables)
  }
}

void CheckAlarms()
{
  static unsigned char NextAlarm = 0;
  unsigned char month;
  unsigned int temp;  //temp must be of type unsigned int because it is passed as the year parameter to the function get_dat.
  
  get_date(&temp, &month, (unsigned char *) &temp, 1);  //1 in the last parameter means solar date (shamsi)
  
  if(ActiveAlarmIndex < MAX_ALARM_COUNT_PER_MONTH)
  {
    //An alarm is active - check if to deactivate it.
    if(!AlarmIsActive(month, ActiveAlarmIndex))
    {
      DeactivateAlarm();
      DisableAlarmIfCanBeDisabled(month, ActiveAlarmIndex);
      ActiveAlarmIndex = 0xff;
      //RemoveAlarmIfRemovable(ActiveAlarmIndex);  --> DO NOT REMOVE BECAUSE THE USER MAY CHANGE DATE AND TIME OF THE LED DISPLAY TO AN OLDER TIME AND DATE  //--> If the alarm has a due date, remove it from the list of alarms (i.e. set Duration to 0)
    }
  }
  else
  {
    if(AlarmIsActive(month, NextAlarm))
    {
      ActivateAlarm();
      ActiveAlarmIndex = NextAlarm;
    }
    else
    {
      NextAlarm++;
      if(NextAlarm >= MAX_ALARM_COUNT_PER_MONTH)
        NextAlarm = 0;
    }
  }
}

void InitAlarms()
{
  unsigned char NextA;
  unsigned char month;
  unsigned int temp;
  
  if(ALARM_CHEK_COUNTER == 0 || ALARM_CHEK_COUNTER > 254)
    ALARM_CHEK_COUNTER = DEFAULT_ALARM_CHEK_COUNTER;
  
  ActiveAlarmIndex = 0xff;
  get_date(&temp, &month, (unsigned char *) &temp, 1);
  for(NextA = 0; NextA < MAX_ALARM_COUNT_PER_MONTH; NextA++)
  {
    if(AlarmIsActive(month, NextA))
    {
      ActiveAlarmIndex = NextA;
      ActivateAlarm();
      return;  //an active alarm found, return to not to deactivate it
    }
  }
  
  //If no active alarm found, deactivate alarm if active
  DeactivateAlarm();
}

#endif