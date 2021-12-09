/* This file contains routines for handling buttons */

#ifdef  _DATE_TIME_ADJUST_BUTTONS_ACTIVE

//===================================================
//===================================================
//Clock specific definitions
#define KEY_UP      1
#define KEY_DOWN    2
#define KEY_SET     3
#define KEY_FONT    4

#define MODE_LED      PORTA.7
#define MODE_LED_PIN  PINA.7

#define MODE_EXIT_TIME_OUT  30  //in seconds
#define BUTTON_REPEAT_TICK_COUNT                      (10000 / OVERALL_SPEED_SETTING)  //Determines the time duration that a button must be held down to start the button repeatition
#define BUTTON_REPEAT_TICK_COUNT_BETWEEN_REPETITIONS  (2000 / OVERALL_SPEED_SETTING)  //Controls speed of button repetition when a button is held down
//===================================================
//===================================================

typedef struct
{
  BOOL SetMode;
  //BOOL FontMode;

  unsigned char SetItem;  //0 = Second, 1 = Minute, 2 = Hour, 3 = Year, 4 = Month, 5 = Day
  int SetValue;
  BOOL SetValueChanged;
  BOOL EditValueOn;

  //int DigitsFontIndex;

  BOOL AllButtonsReleased;
  
  BOOL RepeatButton;

  TTime ModeLastTime;
  unsigned long ButtonLastTickCount;
} TClockStatus;

TClockStatus ClockStatus;

void SetIndicator(BOOL Status)
{
  if(Status == ON)
  {
    MODE_LED = 1;
  }
  else
  {
    MODE_LED = 0;
  } 
  ClockStatus.EditValueOn = Status;
}

/* ***** ********* ***** ***** ******** *** ** *** ********* ********** ***** */
/* ***** IMPORTANT NOTES ABOUT CHANGING ANY OF THE FOLLOWING CHARACTERS ***** */
/* If you change size of any of the following characters stored in the internal EEPROM, you
   MUST update the value of MAX_INTERNAL_EEP_CHAR_DATA_SIZE in the LEDPutCharE() function. Otherwise
   the characters will not be displayed correctly.
*/
/* ***** ********* ***** ***** ******** *** ** *** ********* ********** ***** */

eeprom unsigned char ClockStatusChar[6][21] = {
{  //Hour char
20,
/* OLD - NOT MIRRORED
0x00, 0x18, 0x04, 0x24, 0x24, 0x04, 0x1C, 0x04, 0x0C, 0x14,
0x14, 0x00, 0x78, 0x04, 0x04, 0x1C, 0x04, 0x1C, 0x04, 0x18
*/
0x00, 0x18, 0x20, 0x24, 0x24, 0x20, 0x38, 0x20, 0x30, 0x28,
0x28, 0x00, 0x1E, 0x20, 0x20, 0x38, 0x20, 0x38, 0x20, 0x18
},

{  //Minute char
20,
/* OLD - NOT MIRRORED
0x00, 0x18, 0x28, 0x3C, 0x05, 0x04, 0x1D, 0x04, 0x4C, 0x14,
0x5D, 0x04, 0x1D, 0x04, 0x4C, 0x14, 0x5C, 0x00, 0x22, 0x1C
*/
0x00, 0x18, 0x14, 0x3C, 0xA0, 0x20, 0xB8, 0x20, 0x32, 0x28,
0xBA, 0x20, 0xB8, 0x20, 0x32, 0x28, 0x3A, 0x00, 0x44, 0x38
},

{  //Second char
20,
/* OLD - NOT MIRRORED
0x00, 0x00, 0x00, 0x00, 0x18, 0x28, 0x3C, 0x05, 0x04, 0x1D,
0x04, 0x44, 0x18, 0x00, 0xF8, 0x04, 0x44, 0x98, 0x40, 0x00
*/
0x00, 0x00, 0x00, 0x00, 0x18, 0x14, 0x3C, 0xA0, 0x20, 0xB8,
0x20, 0x22, 0x18, 0x00, 0x1F, 0x20, 0x22, 0x19, 0x02, 0x00
},

{  //Day char
16,
/* OLD - NOT MIRRORED
0x00, 0x01, 0x01, 0x02, 0xBC, 0x00, 0x00, 0x61, 0x91, 0x92,
0x7C, 0x00, 0x01, 0x01, 0x02, 0x7C, 0x00, 0x00, 0x00, 0x00
*/
0x00, 0x80, 0x80, 0x40, 0x3D, 0x00, 0x00, 0x86, 0x89, 0x49,
0x3E, 0x00, 0x80, 0x80, 0x40, 0x3E, 0x00, 0x00, 0x00, 0x00
},

{  //Month char
16,
/* OLD - NOT MIRRORED
0x00, 0x00, 0x00, 0x0C, 0x32, 0x12, 0x0C, 0x00, 0x7C, 0x02,
0x02, 0x02, 0x0E, 0x11, 0x11, 0x0E, 0x00, 0x00, 0x00, 0x00
*/
0x00, 0x00, 0x00, 0x30, 0x4C, 0x48, 0x30, 0x00, 0x3E, 0x40,
0x40, 0x40, 0x70, 0x88, 0x88, 0x70, 0x00, 0x00, 0x00, 0x00
},

{  //Year char
16,
/* OLD - NOT MIRRORED
0x00, 0x00, 0x0E, 0x01, 0x01, 0x01, 0x7E, 0x00, 0x7C, 0x02,     
0x02, 0x0C, 0x02, 0x0C, 0x02, 0x1C, 0x00, 0x00, 0x00, 0x00
*/
0x00, 0x00, 0x70, 0x80, 0x80, 0x80, 0x7E, 0x00, 0x3E, 0x40,
0x40, 0x30, 0x40, 0x30, 0x40, 0x38, 0x00, 0x00, 0x00, 0x00
}

};

eeprom unsigned char Year13[9] = {
8,
/* OLD - NOT MIRRORED
0x00, 0x7E, 0x00, 0x7E, 0x10, 0x60, 0x10, 0x60
*/
0x00, 0xFC, 0x00, 0xFC, 0x10, 0x0C, 0x10, 0x0C
};

eeprom unsigned char Year14[9] = {
8,
/* OLD - NOT MIRRORED
0x00, 0x7E, 0x00, 0x7E, 0x10, 0x30, 0x50, 0x50
*/
0x00, 0xFC, 0x00, 0xFC, 0x10, 0x18, 0x14, 0x14
};

BOOL KeyPressed()
{
  unsigned char Buttons[4];
  unsigned char i, j;
  
  #ifdef _CHIP_ATMEGA128_
  if(!ClockStatus.AllButtonsReleased)
  {
    if(!BUTTON_SET)
      return FALSE;
    if(ClockStatus.RepeatButton)
    {
      if((TickCount - ClockStatus.ButtonLastTickCount) < BUTTON_REPEAT_TICK_COUNT_BETWEEN_REPETITIONS)
        return FALSE;
    }
    else if((TickCount - ClockStatus.ButtonLastTickCount) < BUTTON_REPEAT_TICK_COUNT)
      return FALSE;
    else
      ClockStatus.RepeatButton = TRUE;
  }
  else
    ClockStatus.RepeatButton = FALSE;
  #endif
  
  //Read buttons status  
  #ifdef _CHIP_ATMEGA32_
    delay_ms(10);
  #endif
  
  //delay_ms(5);
  Buttons[2] = !BUTTON_SET;
  
  #ifdef _CHIP_ATMEGA32_
    delay_ms(50);
  #endif
  
  //delay_ms(5);
  Buttons[0] = !BUTTON_UP;
  //delay_ms(5);
  Buttons[1] = !BUTTON_DOWN;
  //delay_ms(5);
  Buttons[3] = !BUTTON_OTHER;
  //delay_ms(5);
  
  #ifdef _CHIP_ATMEGA128_
  //Prevent multiple keys to be pressed simultaneously
  for(i = 0; i < 4; i++)
    if(Buttons[i])
      for(j = 0; j < 4; j++)
        if((i != j) && Buttons[j])
          return(FALSE);
  #endif
  
  return Buttons[0] || Buttons[1] || Buttons[2] || Buttons[3];
}

unsigned char ReadKey()
{
  ClockStatus.AllButtonsReleased = FALSE;
  ClockStatus.ButtonLastTickCount = TickCount;
  
  if(!BUTTON_UP)
    return KEY_UP;
  else if(!BUTTON_DOWN)
    return KEY_DOWN;
  else if(!BUTTON_SET)
    return KEY_SET;
  else if(!BUTTON_OTHER)
    return KEY_FONT;
  else
    return 0;
}

void AddToSetValue(int Value)
{
  int SetValue;
  
  SetValue = ClockStatus.SetValue;
  
  SetValue += Value;
  switch(ClockStatus.SetItem)
  {
    case 0:  //Hour
      if(SetValue < 0)
        SetValue = 23;
      else if(SetValue > 23)
        SetValue = 0;
      break;
    case 1:  //Minute
    case 2:  //Second
      if(SetValue < 0)
        SetValue = 59;
      else if(SetValue > 59)
        SetValue = 0;
      break;
    case 3:  //Day
      if(SetValue < 1)
        SetValue = 31;
      else if(SetValue > 31)
        SetValue = 1;
      break;
    case 4:  //Month
      if(SetValue < 1)
        SetValue = 12;
      else if(SetValue > 12)
        SetValue = 1;
      break;
    case 5:  //Year
      if(SetValue < 1380)
        SetValue = 1499;
      else if(SetValue > 1499)
        SetValue = 1380;
      break;
  }
  
  ClockStatus.SetValue = SetValue;
}

void AdjustDateTime(unsigned char Key)
{
  switch(Key)
  {
    case KEY_UP:
      AddToSetValue(+1);
      break;
    case KEY_DOWN:
      AddToSetValue(-1);
      break;
    default:;
  }
  ClockStatus.SetValueChanged = TRUE;
}

void SetEditItem(unsigned char SetItem, int Value)
{
  TTime t;
  unsigned int year;
  unsigned char month, day;
  
  get_exact_time(&t);
  get_date(&year, &month, &day, 1);  //Get shamsi date
  
  switch(SetItem)
  {
    case 0:  //Hour
      t.h = Value;
      set_time(t);
      break;
    case 1:  //Minute
      t.m = Value;
      set_time(t);
      break;
    case 2:  //Second
      t.s = Value;
      set_time(t);
      break;
    case 3:  //Day
      day = Value;
      set_date(year, month, day, 1);  //Year is shamsi
      break;
    case 4:  //Month
      month = Value;
      set_date(year, month, day, 1);  //Year is shamsi
      break;
    case 5:  //Year
      year = Value;
      set_date(year, month, day, 1);  //Year is shamsi
      break;
  }
}

int GetEditItem(unsigned char SetItem)
{
  TTime t;
  unsigned int year;
  unsigned char month, day;
  
  get_exact_time(&t);
  get_date(&year, &month, &day, 1);  //Get shamsi date
  
  switch(SetItem)
  {
    case 0:  //Hour
      return(t.h);
      break;  //Not Required Here (because of return statement)
    case 1:  //Minute
      return(t.m);
      break;  //Not Required Here (because of return statement)
    case 2:  //Second
      return(t.s);
      break;  //Not Required Here (because of return statement)
    case 3:  //Day
      return(day);
      break;  //Not Required Here (because of return statement)
    case 4:  //Month
      return(month);
      break;  //Not Required Here (because of return statement)
    case 5:  //Year
      return(year);
      break;  //Not Required Here (because of return statement)
  }
  return(0);
}

BOOL ButtonsReleased()
{
  return (BUTTON_UP == 1) && (BUTTON_DOWN == 1) && (BUTTON_SET == 1) && (BUTTON_OTHER == 1);
}

void LEDDateTimeSetMode()
{
  unsigned char x = 0, y;
  unsigned char value;
  char s[3];
  unsigned char i;
  int SetValue;
  
  SetValue = ClockStatus.SetValue;
  //y = (ROW_COUNT - 8) / 2;
  y = 0;
  
  if(ClockStatus.SetItem == 5)  //Year
  {
    if(SetValue < 1400)
    {
      LEDPutCharE(x, y, ROW_COUNT - 1, Year13, 0, 8, COL_COUNT);
      x += Year13[0];
    }
    else
    {
      LEDPutCharE(x, y, ROW_COUNT - 1, Year14, 0, 8, COL_COUNT);
      x += Year14[0];
    }
    value = SetValue % 100;
  }
  else
  {
    value = SetValue;
  }
  
  sprintf(s, "%02d", value);
  
  for(i = 0; i < strlen(s); i++)
  {
    LEDPutCharNEW(x, y, ROW_COUNT - 1, 0, 8, FALSE, s[i], COL_COUNT);
    //LEDPutChar(x, y, ROW_COUNT - 1, LEDDigitsFa8[s[i] - 48], 0, 8);
    //x += LEDDigitsFa8[s[i] - 48][0];
    x += GetCharWidth(0 /*0=Farsi*/, 8, FALSE, s[i]);
  }
  
  /*
  if(ClockStatus.SetMode < 3)  //Hour, Minute, Second
    LEDPutCharf(x, 0, ClockStatusChar[ClockStatus.SetItem], 20, 8);
  else
    LEDPutCharf(x, 0, ClockStatusChar[ClockStatus.SetItem], 16, 8);
  */
  LEDPutCharE(x, y, ROW_COUNT - 1, ClockStatusChar[ClockStatus.SetItem], 0, 8, COL_COUNT);
}

unsigned char CheckDateTimeButtons()
{
  unsigned char Key;
  
  
  if(BUTTON_SET)  //if the set button is not pressed return with 0
    return(0);
  
  //ClearScreen(FALSE);  --> May cause not to capture key press
  
  FILTER_OFF = 0xFF;

  ClockStatus.AllButtonsReleased = TRUE;
  ClockStatus.RepeatButton = FALSE;
  
  while(1)
  {
    if(KeyPressed())
    {
    
  
      Key = ReadKey();
      if(Key == KEY_SET)
      {
        if(ClockStatus.SetMode)
        {
          switch(ClockStatus.SetItem)
          {
            case 0:  //Hour
              if(ClockStatus.SetValueChanged)
                SetEditItem(ClockStatus.SetItem, ClockStatus.SetValue);
              ClockStatus.SetItem++;
              ClockStatus.SetValue = GetEditItem(ClockStatus.SetItem);
              break;
            case 1:  //Minute
              if(ClockStatus.SetValueChanged)
                SetEditItem(ClockStatus.SetItem, ClockStatus.SetValue);
              ClockStatus.SetItem++;
              ClockStatus.SetValue = GetEditItem(ClockStatus.SetItem);
              break;
            case 2:  //Second
              if(ClockStatus.SetValueChanged)
                SetEditItem(ClockStatus.SetItem, ClockStatus.SetValue);
              ClockStatus.SetItem++;
              ClockStatus.SetValue = GetEditItem(ClockStatus.SetItem);
              break;
            case 3:  //Day
              if(ClockStatus.SetValueChanged)
                SetEditItem(ClockStatus.SetItem, ClockStatus.SetValue);
              ClockStatus.SetItem++;
              ClockStatus.SetValue = GetEditItem(ClockStatus.SetItem);
              break;
            case 4:  //Month
              if(ClockStatus.SetValueChanged)
                SetEditItem(ClockStatus.SetItem, ClockStatus.SetValue);
              ClockStatus.SetItem++;
              ClockStatus.SetValue = GetEditItem(ClockStatus.SetItem);
              break;
            case 5:  //Year
              ClockStatus.SetMode = FALSE;
              SetIndicator(OFF);
              if(ClockStatus.SetValueChanged)
                SetEditItem(ClockStatus.SetItem, ClockStatus.SetValue);
              break;              
          }
          ClearScreen(TRUE);
        }
        else  //if(!ClockStatus.SetMode)
        {
          ClearScreen(TRUE);
          ClockStatus.SetMode = TRUE;
          SetIndicator(ON);
          ClockStatus.SetItem = 0;  //Hour
          ClockStatus.SetValue = GetEditItem(ClockStatus.SetItem);
        }
        ClockStatus.SetValueChanged = FALSE;
      }  //if(Key == KEY_SET)
      else if(Key == KEY_UP)
      {
        if(ClockStatus.SetMode)
          AdjustDateTime(Key);
      }  //if(Key == KEY_SET)
      else if(Key == KEY_DOWN)
      {
        if(ClockStatus.SetMode)
          AdjustDateTime(Key);
      }
      get_time(&ClockStatus.ModeLastTime);
      
      
    }
    
    
    if(ClockStatus.SetMode)
      LEDDateTimeSetMode();
    
    if(time_elapsed(ClockStatus.ModeLastTime, FALSE) >= MODE_EXIT_TIME_OUT)
    {
      ClockStatus.SetMode = FALSE;
    }
    
    ClockStatus.AllButtonsReleased = ClockStatus.AllButtonsReleased || ButtonsReleased();
    
    if(!ClockStatus.SetMode)
      break;
  }
  
  SetIndicator(OFF);
  ClearScreen(TRUE);
  
  FILTER_OFF = 0x00;
  
  delay_ms(250);  //Wait for the user to release the SER button
  return(1);
}

#endif