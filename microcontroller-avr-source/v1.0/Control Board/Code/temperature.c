//  Temperature Functions  //

eeprom int TemperatureOffset = 0;

#ifdef  _TEMPERATURE_ACTIVE_
/*
// FOR LM75 //
int temperature_read(char *s, unsigned char unit)  //unit: 0 = Centigrade, 1 = Fahrenheit
{
  int t, tc, tf;
  
  t = lm75_temperature_10(0);
  tc = t / 10;
  if(t % 10 >= 5)
  {
    if(tc < 0)
      tc--;
    else
      tc++;
  }
  
  //Apply temperature offset
  tc = tc + TemperatureOffset;
  
  if(unit == 1)
  {
    //Convert to fahrenheit
    tf = (float) tc * 9.0 / 5.0 + 32.0;  //automatically rounded to an integer
    t = tf;
  }
  else
  {
    t = tc;
  }
  
  sprintf(s, "%-i", t);
  return(t);
}
*/

//For LM35:
unsigned char round(float d)
{
  int r1;
  //float t;
  
  //Always round up to avoid change of temperature unsteadily
  r1 = floor(d);
  r1++;
  
  /*
  r1 = floor(d);
  t = d - r1;
  if(t >= 0.5)
    r1++;
  */
  return(r1);
}

/* LM35 output is connected to AD2. AD1 is connected to the GND. */
bit LM35_State = 0;
BOOL temperature_read(char *s, unsigned char unit, int *TemperatureValue)
{
  int t, tc, tf;
  unsigned int adc_val, dc_val;
  bit voltage_sign;
  float voltage;
  unsigned char temperature;
  
  if(!LM35_State)
  {
    adc_start(18);
    LM35_State = 1;
    return(FALSE);
  }
  
  LM35_State = 0;
  
  adc_val = read_adc();
  if( (adc_val & 0x0200) != 0)
  {
    dc_val = ~(adc_val - 1) & 0x03ff;
    voltage_sign = 1;
  }
  else
  {
    dc_val = adc_val;
    voltage_sign = 0;
  }
  voltage = (float) dc_val * 5.0e-3;
  temperature = round(voltage * 100.0);
  if(temperature >= 255)
    temperature = 0;
  
  //Check temperature unit
  if(voltage_sign == 1)
    tc = - (int) temperature;
  else
    tc = (int) temperature;
  
  //Apply temperature offset
  tc = tc + TemperatureOffset;
  
  if(unit == 1)
  {
    //Convert to fahrenheit
    tf = (float) tc * 9.0 / 5.0 + 32.0;  //automatically rounded to an integer
    t = tf;
  }
  else
  {
    t = tc;
  }
  
  sprintf(s, "%-i", t);
  *TemperatureValue = t;
  
  return(TRUE);
}
#endif

/* LM35 output is connected to AD0. AD1 is connected to the GND. */

/* FOR LM35 USING ADC
void temperature_read(char *s, unsigned char unit)  //unit: 0 = Centigrade, 1 = Fahrenheit
{
  // return temperatue in the form +/-45 //
  unsigned int adc_val, dc_val;
  float voltage;
  char voltage_sign;
  unsigned char temperature;
  int tc, f;
  
  static unsigned int LastTemperatureVoltage;
  static unsigned long TempLastSampleTickCount = 0xffffffff;
  
  if((TickCount - TempLastSampleTickCount) >= TEMPERATURE_SAMPLING_TICK_COUNT ||
     TickCount < TempLastSampleTickCount)
  {
    adc_val = read_adc(16);
    LastTemperatureVoltage = adc_val;
    TempLastSampleTickCount = TickCount;
  }
  else
  {
    adc_val = LastTemperatureVoltage;
  }
  
  if( (adc_val & 0x0200) != 0)
  {
    dc_val = ~(adc_val - 1) & 0x03ff;
    voltage_sign = 1;
  }
  else
  {
    dc_val = adc_val;
    voltage_sign = 0;
  }
  voltage = (float) dc_val * 5.0e-3;
  temperature = round(voltage * 100.0);
  if(temperature >= 255)
    temperature = 0;
  
  //Check temperature unit
  if(voltage_sign == 1)
    tc = - (int) temperature;
  else
    tc = (int) temperature;
  if(unit == 1)
  {
    //Convert to fahrenheit
    f = (float) tc * 9.0 / 5.0 + 32.0;  //automatically rounded to an integer
    if(f < 0)
    {
      voltage_sign = 1;
      temperature = (unsigned char) -f;
    }
    else
    {
      voltage_sign = 0;
      temperature = f;
    }
  }
  
  if(voltage_sign == 1)
  {
    s[0] = '-';
    sprintf(&s[1], "%u", temperature);  //There was an error in direct conversion of negative values to string
  }
  else
  {
    sprintf(s, "%u", temperature);  //There was an error in direct conversion of negative values to string
  }
}
*/
