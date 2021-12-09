/* Date-Time Routines */

void get_exact_time(TTime *time)
{
  unsigned char h, m, s;
  
  rtc_get_time(&h, &m, &s);
  time->h = h;
  time->m = m;
  time->s = s;
}

void get_time(TTime *time)
{
/*
//  -- FOR TEST --
  time->h = 19;
  time->m = 41;
  time->s = 34;
  return;
*/
  
  time->h = ClkHour;
  time->m = ClkMinute;
  time->s = ClkSecond;
}

#ifdef  _DATE_TIME_ADJUST_BUTTONS_ACTIVE
void set_time(TTime time)
{
  rtc_set_time(time.h, time.m, time.s);

  ClkHour = time.h;
  ClkMinute = time.m;
  ClkSecond = time.s;
}
#endif

/*
BOOL time_passed(TTime time)
{
  TTime current;
  
  get_time(&current);
  
  //Hour
  if(current.h > time.h)
    return(FALSE);
  if(current.h < time.h)
    return(TRUE);
  
  //Minute
  if(current.m > time.m)
    return(FALSE);
  if(current.m < time.m)
    return(TRUE);
  
  //Second
  if(current.s > time.s)
    return(FALSE);
  if(current.s <= time.s)
    return(TRUE);
  
  return(FALSE);  //Is Not Necessary
}
*/

unsigned long int time_elapsed(TTime time, BOOL ExactTime)
{
  TTime current;
  unsigned long int ct, t;
  unsigned int temp;
  
  if(ExactTime)
    get_exact_time(&current);
  else
    get_time(&current);
  
  //temp is used to have sum calculations in 4-byte scale and reduce the code size
//  t = (unsigned long) time.h * 3600L + (unsigned long) time.m * 60L + (unsigned long) time.s;
  temp = (unsigned int) time.m * 60U + (unsigned int) time.s;
  t = (unsigned long) time.h * 3600L + (unsigned long) temp;
//  ct = (unsigned long) current.h * 3600L + (unsigned long) current.m * 60L + (unsigned long) current.s;
  temp = (unsigned int) current.m * 60U + (unsigned int) current.s;
  ct = (unsigned long) current.h * 3600L + (unsigned long) temp;
  
  if(ct < t)  //Midnignt passed
  {
    return(ct + (86400L /*Total number of seconds in a day*/ - t));
  }
  else
  {
    return(ct - t);
  }
  
  /*
  sum = ((unsigned long) current.h - (unsigned long) time.h) * (unsigned long) 60 * (unsigned long) 60;
  if(current.h == time.h)
  {
    if(current.m != time.m)
      sum = sum + ( (unsigned long) (current.m - time.m - 1) ) * (unsigned long) 60;
  }
  else
  {
    sum = sum + (unsigned long) current.m * (unsigned long) 60 + ( (unsigned long) (60 - time.m) ) * (unsigned long) 60;
  }
  
  if(current.h == time.h && current.m == time.m)
  {
    sum = sum + (unsigned long) (current.s - time.s);
  }
  else
  {
    sum = sum + (unsigned long) current.s + ((unsigned long) 60 - time.s);
  }
  
  return(sum);
  */
}

void get_date(unsigned int *year, unsigned char *month, unsigned char *day, unsigned char shamsi)
{
  //shamsi: 1 = Yes, 0 = No (Gregorian)
  unsigned char y, m, d;
  
/*
  -- FOR TEST --
  *year = 1385;
  *month = 12;
  *day = 23;
  return;
*/
  
  rtc_get_date(&d, &m, &y);
  if(shamsi == 0)
  {
    *year = y + 2000;
    *month = m;
    *day = d;
  }
  else
  {
    MiladiToShamsi(y + 2000, m, d, year, month, day);
  }
}

#ifdef  _DATE_TIME_ADJUST_BUTTONS_ACTIVE
void set_date(unsigned int year, unsigned char month, unsigned char day, unsigned char shamsi)
{
  //shamsi: 1 = Yes, 0 = No
  unsigned int y;
  unsigned char m, d;
  
  if(shamsi == 0)
  {
    y = year - 2000;
    m = month;
    d = day;
  }
  else
  {
    ShamsiToMiladi(year, month, day, &y, &m, &d);
    y = y - 2000;
  }
  
  rtc_set_date(d, m, y);
}
#endif
