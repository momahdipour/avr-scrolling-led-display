//Alarms

#define   ALARM_COUNT   7
#define   TIME_RANGE    10  //Seconds

eeprom unsigned char AtiveAlarmIndex = 0xff;

typedef struct
{
  unsigned char EveryDay;
  unsigned char Day;
  unsigned char Month;
  unsigned int Year;
  unsigned char Hour;
  unsigned char Minute;
  unsigned char Second;
  unsigned int Duration;
  unsigned char RESERVED;
} TLDCAlarm;

void ActivateAlarm()
{
  PORTC.2 = 1;
}

void DeactivateAlarm()
{
  PORTC.2 = 0;
}

BOOL TriggerAlarm(unsigned char h, unsigned char m, unsigned char s, unsigned int Duration)
{
  TTime t;

  t.h = h;
  t.m = m;
  t.s = s;
  
  if(time_elapsed(t, TRUE) <= Duration)
    return(TRUE);
  else
    return(FALSE);
}

BOOL CheckAlarm(unsigned char AlarmIndex)
{
  //AlarmNo strting from 0
  TLDCAlarm Alarm;
  unsigned int y;
  unsigned char m, d;
  
  mem_read_block(0 + AlarmIndex * sizeof(TLDCAlarm), sizeof(TLDCAlarm), (unsigned char *) &Alarm);
  
  if(Alarm.Duration > 0)
  {
    if(Alarm.EveryDay == 1)
    {
      if(TriggerAlarm(Alarm.Hour, Alarm.Minute, Alarm.Second, Alarm.Duration))
        return(TRUE);
      else
        return(FALSE);
    }
    else
    {
      get_date(&y, &m, &d, 1);
      if(y == Alarm.Year && m == Alarm.Month && d == Alarm.Day)
        return(TRUE);
      else
        return(FALSE);
    }
  }
  else
  {
    return(FALSE);
  }
}

BOOL AlarmExpired(unsigned char AlarmIndex)
{
  //AlarmNo strting from 0
  TLDCAlarm Alarm;
  TTime t;
  
  mem_read_block(0 + AlarmIndex * sizeof(TLDCAlarm), sizeof(TLDCAlarm), (unsigned char *) &Alarm);
  
  t.h = Alarm.Hour;
  t.m = Alarm.Minute;
  t.s = Alarm.Second;
  
  if(time_elapsed(t, TRUE) >= Alarm.Duration)
  {
    return(TRUE);
  }
  else
  {
    return(FALSE);
  }
}

void CheckAlarms()
{
  static unsigned char NextAlarm = 0;
  
  if(AtiveAlarmIndex < ALARM_COUNT)
  {
    //An alarm is active - check if to deactivate it.
    if(AlarmExpired(AtiveAlarmIndex))
    {
      DeactivateAlarm();
      AtiveAlarmIndex = 0xff;
    }
  }
  else
  {
    if(CheckAlarm(NextAlarm))
    {
      ActivateAlarm();
      AtiveAlarmIndex = NextAlarm;
    }
    else
    {
      NextAlarm++;
      if(NextAlarm >= ALARM_COUNT)
        NextAlarm = 0;
    }
  }
}

