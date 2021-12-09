//Alarm management routines
/*

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

BOOL WriteAlarm(unsigned char month, unsigned char AlarmIndex, unsigned char *AlarmData)
{
  //If alarm data is valid and there is enough memory to store the alarm, stores the alarm in the memory and returns TRUE,
  //  otherwise returns FALSE.
  //Valid alarm is an alarm that its month is in valid range and its Duration is greater than 0 (in fact it is an active alarm).
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
*/
