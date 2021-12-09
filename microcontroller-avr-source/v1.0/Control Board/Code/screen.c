//===================================================
//===================================================

//eeprom unsigned int DATA_VALIDATION_ERR_COUNT = 0;  --> Removed for privacy policy

eeprom unsigned char MICRO_RESET_AFTER_EACH_SHOW = 0xFF;  //0x00 = No (Don't Reset), Any other value = Yes (Reset)

unsigned char ROW_COUNT = 0;
unsigned char COL_COUNT = 0;

//===================================================
//===================================================

#define SCREEN_FILTER_ARRAY_BOUND   MAX_ROW_COUNT_FOR_ARRAY
#define SCREEN_ARRAY_BOUND          (MAX_ROW_COUNT_FOR_ARRAY / 8)

unsigned char Screen[SCREEN_ARRAY_BOUND][MAX_COL_COUNT_FOR_ARRAY + 1];  //plus 1 to avoid boundary errors
unsigned char AnimScreen[SCREEN_ARRAY_BOUND][MAX_COL_COUNT_FOR_ARRAY + 1];  //plus 1 to avoid boundary errors
#ifdef  _COLOR_DISPLAY_
unsigned char RedFilter[SCREEN_FILTER_ARRAY_BOUND][(MAX_COL_COUNT_FOR_ARRAY - 1) / 8];
unsigned char GreenFilter[SCREEN_FILTER_ARRAY_BOUND][(MAX_COL_COUNT_FOR_ARRAY - 1) / 8];
#endif

TTime StageTime;
TTime AreaTimes[4];

unsigned char StageCount, CurrentStageIndex;

TDisplayStage CurrentStage;
//unsigned char CurrentStageElapsedTime;  //in seconds
TStageSettings StageSettings;

unsigned long LoadFromScreen(unsigned char ScreenCol)
{
  unsigned long b;
  
  #ifdef  _ROWS_32_
  b = Screen[3][ScreenCol];
  b = (b << 8) | Screen[2][ScreenCol];
  b = (b << 8) | Screen[1][ScreenCol];
  b = (b << 8) | Screen[0][ScreenCol];
  #else
    #ifdef  _ROWS_24_
    b = Screen[2][ScreenCol];
    b = (b << 8) | Screen[1][ScreenCol];
    b = (b << 8) | Screen[0][ScreenCol];
    #else
    b = Screen[1][ScreenCol];
    b = (b << 8) | Screen[0][ScreenCol];
    #endif
  #endif
  
  return(b);
}

unsigned long LoadFromAnimScreen(unsigned char ScreenCol)
{
  unsigned long b;
  
  #ifdef  _ROWS_32_
  b = AnimScreen[3][ScreenCol];
  b = (b << 8) | AnimScreen[2][ScreenCol];
  b = (b << 8) | AnimScreen[1][ScreenCol];
  b = (b << 8) | AnimScreen[0][ScreenCol];
  #else
    #ifdef  _ROWS_24_
    b = AnimScreen[2][ScreenCol];
    b = (b << 8) | AnimScreen[1][ScreenCol];
    b = (b << 8) | AnimScreen[0][ScreenCol];
    #else
    b = AnimScreen[1][ScreenCol];
    b = (b << 8) | AnimScreen[0][ScreenCol];
    #endif
  #endif
  
  return(b);
}

void StoreToScreen(unsigned long data, unsigned char ScreenCol)
{
  Screen[0][ScreenCol] = data;
  Screen[1][ScreenCol] = data >> 8;
  #ifdef  _ROWS_24_
  Screen[2][ScreenCol] = data >> 16;
  #endif
  #ifdef  _ROWS_32_
  Screen[3][ScreenCol] = data >> 24;
  #endif
}

void StoreToAnimScreen(unsigned long data, unsigned char ScreenCol)
{
  AnimScreen[0][ScreenCol] = data;
  AnimScreen[1][ScreenCol] = data >> 8;
  #ifdef  _ROWS_24_
  AnimScreen[2][ScreenCol] = data >> 16;
  #endif
  #ifdef  _ROWS_32_
  AnimScreen[3][ScreenCol] = data >> 24;
  #endif
}

#ifdef  _AREA_BORDERS_ACTIVE_
void DrawAreaBorders(TArea *Area, BOOL ClearAllBorders);
void DrawBorders();
#endif

#include "primary.c"

#include "internal_fonts.c"

#include "mem_map.c"

#include "Animations.c"

#include "page_effects.c"

//#include <leddigits.c>

//Clock variables
// unsigned int Millisecond = 0;
// unsigned char Second = 0, Minute = 0, Hour = 0;
// unsigned char Month = 1, Day = 6;
// unsigned int Year = 1387;


#ifdef  _COLOR_DISPLAY_
void update_color_arrays();
#endif

void reset_CurrentStageElapsedTime()
{
  get_time(&StageTime);
}

unsigned long int CurrentStageElapsedTime()
{
  return(time_elapsed(StageTime, FALSE));
}

void reset_AreaElapsedTime(unsigned char AreaIndex)
{
  get_time(&AreaTimes[AreaIndex]);
}

void reset_AllAreasElapsedTime()
{
  unsigned char i;
  
  get_time(&AreaTimes[0]);
  
  for(i = 1; i < 4; i++)
    AreaTimes[i] = AreaTimes[0];
}

unsigned long int AreaElapsedTime(unsigned char AreaIndex)
{
  return(time_elapsed(AreaTimes[AreaIndex], FALSE));
}

void ChangeStage(unsigned char NewStageIndex, BOOL FirstRun)
{
  unsigned char i;
  //unsigned char j;
  //TContentsData cd[4], cdtemp;
  //BOOL Found;
  //unsigned char OldStageIndex;
  
  //OldStageIndex = CurrentStageIndex;
  
  //TAreaPositionData apd[4];
  
  /*
  if(!FirstRun)
  {
    for(i = 0; i < 4; i++)
    {
      apd[i].ContentType = CurrentStage.Areas[i].ContentType;
      switch(apd[i].ContentType)
      {
        case 1:  //Time
          get_content_settings(i, sizeof(TTimeData), (unsigned char *) &(cd[i].TimeData));
          break;
        case 2:  //Date
          get_content_settings(i, sizeof(TDateData), (unsigned char *) &(cd[i].DateData));
          break;
        case 6:  //Temperature
          get_content_settings(i, sizeof(TTemperature), (unsigned char *) &(cd[i].TempData));
          break;
      }
      apd[i].x1 = CurrentStage.Areas[i].x1;
      apd[i].x2 = CurrentStage.Areas[i].x2;
      apd[i].y1 = CurrentStage.Areas[i].y1;
      apd[i].y2 = CurrentStage.Areas[i].y2;
    }
  }
  else
  {
    for(i = 0; i < 4; i++)
    {
      apd[i].ContentType = 0;
      apd[i].x1 = 0;
      apd[i].x2 = 0;
      apd[i].y1 = 0;
      apd[i].y2 = 0;
    }
  }
  */
  
  update_data_pointers(NewStageIndex, &CurrentStage);
  
  CurrentStageIndex = NewStageIndex;
  Stages(CurrentStageIndex, &CurrentStage);
  
  #ifdef  _COLOR_DISPLAY_
  update_color_arrays();
  #endif
  
  
  //Clear areas only if necessary
  ClearAnimScreen();
  
  ClearScreen(TRUE);
  
  #ifdef  _AREA_BORDERS_ACTIVE_
  //DrawBorders();  --> Must not be included here, because the borders may appear before the page effects (if available)
  #endif
  
  /*
  if(NewStageIndex != 0)
  {
    for(i = 0; i < 4; i++)
    {
      if(apd[i].ContentType != 1 ||  //Time
         apd[i].ContentType != 2 ||  //Date
         apd[i].ContentType != 6)    //Temperature
      {
        ClearAreaXY(apd[i].x1, apd[i].y1, apd[i].x2, apd[i].y2);
      }
      else
      {
        Found = FALSE;
        for(j = 0; j < 4; j++)
        {
          if((CurrentStage.Areas[j].ContentType == apd[i].ContentType) &&
             (CurrentStage.Areas[j].x1 == apd[i].x1) &&
             (CurrentStage.Areas[j].x2 == apd[i].x2) &&
             (CurrentStage.Areas[j].y1 == apd[i].y1) &&
             (CurrentStage.Areas[j].y2 == apd[i].y2) )
          {
            switch(CurrentStage.Areas[j].ContentType)
            {
              #ifdef  _TIME_ACTIVE_
              case 1:  //Time
                get_content_settings(j, sizeof(TTimeData), (unsigned char *) &(cdtemp.TimeData));
                if(memcmp(&cd[i].TimeData, &cdtemp.TimeData, sizeof(TTimeData)) == 0)
                  Found = TRUE;
                break;
              #endif
              #ifdef  _DATE_ACTIVE_
              case 2:  //Date
                get_content_settings(j, sizeof(TDateData), (unsigned char *) &(cdtemp.DateData));
                if(memcmp(&cd[i].DateData, &cdtemp.DateData, sizeof(TDateData)) == 0)
                  Found = TRUE;
                break;
              #endif
              #ifdef  _TEMPERATURE_ACTIVE_
              case 6:  //Temperature
                get_content_settings(j, sizeof(TTemperature), (unsigned char *) &(cdtemp.TempData));
                if(memcmp(&cd[i].TempData, &cdtemp.TempData, sizeof(TTemperature)) == 0)
                  Found = TRUE;
                break;
              #endif
            }
            if(Found)
              break;
          }
        }
        
        if(!Found)
        {
          ClearAreaXY(apd[i].x1, apd[i].y1, apd[i].x2, apd[i].y2);
        }
      }
    }
  }
  */
  
  //Initialize stage settings
  
  //Timing
  StageSettings.ForceUpdate = TRUE;
  
  StageSettings.StageEffectDone = FALSE;  //Prevent potential software bugs
  StageSettings.EffectLastTickCount = 0;  //Force to start stage effect on start
  
  #ifdef  _TIME_SPAN_ACTIVE_
  StageSettings.TimeSpanDefined = (CurrentStage.HourFrom != CurrentStage.HourTo) ||
                                  (CurrentStage.MinuteFrom != CurrentStage.MinuteTo);
  #endif
  
  for(i = 0; i < 4; i++)
  {
    if(CurrentStage.Areas[i].x1 >= COL_COUNT ||
       CurrentStage.Areas[i].x2 >= COL_COUNT ||
       CurrentStage.Areas[i].x1 > CurrentStage.Areas[i].x2 ||
       CurrentStage.Areas[i].y1 >= ROW_COUNT ||
       CurrentStage.Areas[i].y2 >= ROW_COUNT ||
       CurrentStage.Areas[i].y1 > CurrentStage.Areas[i].y2)
    {
      //Invalid geometry for the area
      CurrentStage.Areas[i].ContentType = 0;  //Unused area
    }
    
    StageSettings.AreasDone[i] = FALSE;
    //No need to update the value of LastTickCount
    StageSettings.LastTickCount[i] = 0;
    ////////
    StageSettings.EntranceAnimDone[i] = FALSE;
    StageSettings.AnimInitialized[i] = FALSE;
    StageSettings.AreaRepeatCount[i] = 0;
    
    switch(CurrentStage.Areas[i].ContentType)
    {
      #ifdef  _TIME_ACTIVE_
      case 1:  //Time
        StageSettings.Num1[i] = 250;  //Any value greater than 59
        StageSettings.Num2[i] = 0;  //Dots are not being shown
        break;
      #endif
      #ifdef  _DATE_ACTIVE_
      case 2:  //Date
        StageSettings.Num1[i] = 0xFF;  //For Day
        StageSettings.Num2[i] = 0;  //Used for separate format (if selected by user) (Show month and day first)
        StageSettings.Num3[i] = 0xFF;  //For Month
        break;
      #endif
      #ifdef  _SCROLLING_TEXT_ACTIVE_
      case 3:  //Single-Line Scrolling Text
        //StageSettings.SLST[i].DelayCounter = 0;
        StageSettings.SLST[i].StartCol = 0;
        StageSettings.SLST[i].NormalScroll = FALSE;
        break;
      #endif
      #ifdef  _ANIMATION_ACTIVE_
      case 4:  //Framed Animation
        //StageSettings.FA[i].DelayCounter = 0;
        StageSettings.FA[i].CurrentFrame = 0;
        StageSettings.FA[i].FirstFrameLoaded = FALSE;
        break;
      #endif
      case 5:  //Font Text
        break;
      #ifdef  _TEMPERATURE_ACTIVE_
      case 6:  //Temperature
        StageSettings.Num1[i] = 0xff;  //Temperature low byte  --  MUST SET A VALUE FOR THESE TWO BYTES THAT CAUSE A DIFFERENCE OF 2 DEGREES FOR THE TEMPERATURE AT THE FIRST UPDATE
        StageSettings.Num2[i] = 0xff;  //Temperature high byte
        StageSettings.Num3[i] = 1;  //1 means that force refresh at first run
        LM35_State = 0;  //Means we want to measure new values
        break;
      #endif
      case 7:  //Empty
        StageSettings.Num1[i] = 0;  //Means if the Empty area is refreshed (= 1) or not (= 0) because only one time it is needed to be refreshed.
        break;
      default:  //Unused or Unknown
        StageSettings.AreasDone[i] = TRUE;
        break;
    }
  }
  
  //Page effect
  if(CurrentStage.EntranceEffectID > 0)
    InitPageEffect(CurrentStage.EntranceEffectID);
  else
  {
    StageSettings.StageEffectDone = TRUE;
    #ifdef  _AREA_BORDERS_ACTIVE_
    DrawBorders();  //Page effects change the contents of all the display screen, so the borders ar redrawn if a page effect is available, but when no page effect is available, the borders must be drawn here.
    #endif
  }
  /////////////

  //CurrentStageElapsedTime = 0;
  reset_CurrentStageElapsedTime();
  reset_AllAreasElapsedTime();
}

/*
eeprom unsigned char *DigitsFont[10];  //Pointer to fonts for digits 0 to 9; used in LEDTime, LEDDate, and \mperature, and maybe in new functions in the future!

unsigned char SelectDigitsFont(unsigned char AreaWidth, unsigned char AreaHeight, unsigned char lang)
{
  unsigned char i;
  unsigned char CharHeight;
  
  //------------------------------
  //Select font
  if(lang == 0)
  {
    if(AreaHeight >= 24)
    {
      CharHeight = 24;
      for(i = 0; i < 10; i++)
        DigitsFont[i] = LEDDigitsFa24[i];
    }
    else if(AreaHeight >= 16)
    {
      CharHeight = 16;
      for(i = 0; i < 10; i++)
        DigitsFont[i] = LEDDigitsFa16[i];
    }
    else
    {
      CharHeight = 8;
      if(AreaWidth < 40)
      {
        for(i = 0; i < 10; i++)
          DigitsFont[i] = LEDDigitsFa8_SMALL[i];
      }
      else
      {
        for(i = 0; i < 10; i++)
          DigitsFont[i] = LEDDigitsFa8[i];
      }
    }
  }
  else
  {
    if(AreaHeight >= 24)
    {
      CharHeight = 24;
      for(i = 0; i < 10; i++)
        DigitsFont[i] = LEDDigitsEn24[i];
    }
    else if(AreaHeight >= 16)
    {
      CharHeight = 16;
      for(i = 0; i < 10; i++)
        DigitsFont[i] = LEDDigitsEn16[i];
    }
    else
    {
      CharHeight = 8;
      if(AreaWidth < 40)
      {
        for(i = 0; i < 10; i++)
          DigitsFont[i] = LEDDigitsEn8_SMALL[i];
      }
      else
      {
        for(i = 0; i < 10; i++)
          DigitsFont[i] = LEDDigitsEn8[i];
      }
    }
  }
  return(CharHeight);
}
*/

unsigned char GetCharHeight(unsigned char AreaHeight, TArea *Area)
{
  unsigned char CharHeight;
  unsigned char bf;  //To store value of BordersFilled
  unsigned char HeightCompensate;
  //unsigned char bwh;
  //unsigned char bwv;
  
  bf = Area->BordersFilled;
  //bwh = Area->BordersWidthH;
  //bwv = Area->BordersWidthV;
  //Only checking top and bottom borders is necessary in this version - and only at most 2 pixels
  HeightCompensate = 0;
  if((bf & (1 << 2)) != 0)  //Has top border?
    HeightCompensate++;
  if((bf & (1 << 3)) != 0)  //Has bottom border?
    HeightCompensate++;
  
  if(AreaHeight >= (24 - HeightCompensate))
  {
    CharHeight = 24;
  }
  else if(AreaHeight >= (16 - HeightCompensate))
  {
    CharHeight = 16;
  }
  else
  {
    CharHeight = 8;
  }
  
  return(CharHeight);
}

#ifdef  _TIME_ACTIVE_
void LEDTime(unsigned char AreaIndex, TArea Area, unsigned char dp_index /*data pointer index*/)
{
  //StageSettings.Num1[AreaIndex] is used to store old second value (for implementing blink dots)
  char TimeStr[9];
  TTimeData td;
  unsigned char i;
  unsigned char Hour, Minute, Second;
  unsigned int TotalColumnCount;
  //eeprom unsigned char *ColonFont;
  unsigned char CharHeight;
  unsigned char x, y;
  BOOL Refresh;
  unsigned char AreaWidth, AreaHeight;
  BOOL ShowDots = TRUE;
  unsigned char CharWidthTemp;
  BOOL UseSmallWidthChars;
  
  if(StageSettings.AreasDone[AreaIndex])
  {
    //It is also possible to keep this area alive until all other areas are done.
    //This can be implemented as an option.
    if(!Area.RepeatAfterDone)
    {
      //Clear the area and return
      ClearArea(Area);
      return;
    }
  }
  
  //td = (TTimeData flash*) DataStart;
  get_content_settings(dp_index, sizeof(TTimeData), (unsigned char *) &td);
  
  //lcd_putnumuc(td.TotalDisplayTime);
  if(AreaElapsedTime(AreaIndex) >= td.TotalDisplayTime)
  {
    StageSettings.AreasDone[AreaIndex] = TRUE;
  }
  
  rtc_get_time(&Hour, &Minute, &Second);
  
  //Apply 12-Hour format if requested
  if(td.type == 1)  //12-Hour
  {
    if(Hour > 12)
      Hour -= 12;
    else if(Hour == 0)
      Hour = 12;
  }
  
  if(td.format == 0)
    sprintf(TimeStr, "%02d:%02d:%02d", Hour, Minute, Second);
  else
    sprintf(TimeStr, "%02d:%02d", Hour, Minute);
  
  AreaWidth = Area.x2 - Area.x1 + 1;
  AreaHeight = Area.y2 - Area.y1 + 1;
  
  //------------------------------
  //Select font
  CharHeight = GetCharHeight(AreaHeight, &Area);
  UseSmallWidthChars = (AreaWidth <= 34) || (AreaWidth < 50 && td.format == 0);
  
  //CharHeight = SelectDigitsFont(AreaWidth, AreaHeight, td.lang);
/*  if(td.lang == 0)
  {
    if(AreaHeight >= 24)
    {
      CharHeight = 24;
      for(i = 0; i < 10; i++)
        DigitsFont[i] = LEDDigitsFa24[i];
    }
    else if(AreaHeight >= 16)
    {
      CharHeight = 16;
      for(i = 0; i < 10; i++)
        DigitsFont[i] = LEDDigitsFa16[i];
    }
    else
    {
      CharHeight = 8;
      if(AreaWidth < 36)
      {
        for(i = 0; i < 10; i++)
          DigitsFont[i] = LEDDigitsFa8_SMALL[i];
      }
      else
      {
        for(i = 0; i < 10; i++)
          DigitsFont[i] = LEDDigitsFa8[i];
      }
    }
  }
  else
  {
    if(AreaHeight >= 24)
    {
      CharHeight = 24;
      for(i = 0; i < 10; i++)
        DigitsFont[i] = LEDDigitsEn24[i];
    }
    else if(AreaHeight >= 16)
    {
      CharHeight = 16;
      for(i = 0; i < 10; i++)
        DigitsFont[i] = LEDDigitsEn16[i];
    }
    else
    {
      CharHeight = 8;
      if(AreaWidth < 36)
      {
        for(i = 0; i < 10; i++)
          DigitsFont[i] = LEDDigitsEn8_SMALL[i];
      }
      else
      {
        for(i = 0; i < 10; i++)
          DigitsFont[i] = LEDDigitsEn8[i];
      }
    }
  }*/
  
  /*
  switch(CharHeight)
  {
    case 8:
      ColonFont = Colon;
      break;
    case 16:
      ColonFont = Colon16;
      break;
    case 24:
      ColonFont = Colon24;
      break;
  }
  */
  //Font selection complete
  //------------------------------
  
  if(StageSettings.Num1[AreaIndex] != Second)
  {
    Refresh = TRUE;
    StageSettings.LastTickCount[AreaIndex] = TickCount;
  }
  else
    Refresh = FALSE;
  
  //------ NOT IMPLEMENTED -------
  //Second dots blink
  if(td.BlinkDots == 1)
  {
    if(Refresh)
      ShowDots = TRUE;
    else
    {
      if((TickCount - StageSettings.LastTickCount[AreaIndex]) >= (4000 / OVERALL_SPEED_SETTING))//(7813 / OVERALL_SPEED_SETTING))
        ShowDots = FALSE;
      else
        ShowDots = TRUE;
      if(ShowDots && StageSettings.Num2[AreaIndex] == 0)
        Refresh = TRUE;
      else if(!ShowDots && StageSettings.Num2[AreaIndex] == 1)
        Refresh = TRUE;
    }
  }
  else
    ShowDots = TRUE;
  //------------------------------
  Refresh = TRUE;
  if(Refresh)
  {

  //Count the number of columns clock occupies (to put clock at screen center)
  TotalColumnCount = 0;
  for(i = 0; i < strlen(TimeStr); i++)
  {
    if((TimeStr[i] == ':') || (TimeStr[i] >= '0' && TimeStr[i] <= '9'))  //These may not be digits when DS1307 is not available
      TotalColumnCount += GetCharWidth(td.lang, CharHeight, UseSmallWidthChars, TimeStr[i]);
    /*
    if(TimeStr[i] == ':')
    {
      //LEDPutChar(Area.x1, Area.y1, Colon, 0);
      TotalColumnCount += ColonFont[0];
    }
    else
    {
      if(TimeStr[i] >= '0' && TimeStr[i] <= '9')  //These may not be digits when DS1307 is not available
        TotalColumnCount += DigitsFont[TimeStr[i] - 48][0];
    }
    */
  }
  
  x = Area.x1;
  y = Area.y1;
  //Center horizontally
  if(td.CenterHorizontally && TotalColumnCount < AreaWidth)
  {
    x = Area.x1 + (AreaWidth - TotalColumnCount) / 2;
  }
  //Center vertically
  if(td.CenterVertically && AreaHeight > CharHeight)
  {
    y = Area.y1 + (AreaHeight - CharHeight) / 2;
  }
  
  if(x > Area.x1)
  {
    LEDPutSpace(Area.x1, y, Area.y2, x - Area.x1 /*must not be plus 1*/, CharHeight, Area.x2);
  }
  
  for(i = 0; i < strlen(TimeStr); i++)
  {
    if(TimeStr[i] == ':')
    {
      CharWidthTemp = GetCharWidth(td.lang, CharHeight, UseSmallWidthChars, ':');
      
      if(ShowDots)
        StageSettings.Num2[AreaIndex] = 1;
      else
        StageSettings.Num2[AreaIndex] = 0;
      
      if(i == (strlen(TimeStr) - 3))
      {
        if(ShowDots)
          LEDPutCharNEW(x, y, Area.y2, td.lang, CharHeight, UseSmallWidthChars, ':', Area.x2);
        else
          LEDPutSpace(x, y, Area.y2, CharWidthTemp, CharHeight, Area.x2);
      }
      else
      {
        LEDPutCharNEW(x, y, Area.y2, td.lang, CharHeight, UseSmallWidthChars, ':', Area.x2);
      }
      x += CharWidthTemp;
    }
    else
    {
      if(TimeStr[i] < '0' || TimeStr[i] > '9')  //This may occur when DS1307 is not available
        break;
      
      LEDPutCharNEW(x, y, Area.y2, td.lang, CharHeight, UseSmallWidthChars, TimeStr[i], Area.x2);
      x += GetCharWidth(td.lang, CharHeight, UseSmallWidthChars, TimeStr[i]);
    }
    
    if(x > Area.x2)
      break;
  }
  
  if(Area.x2 >= x)
    LEDPutSpace(x, y, Area.y2, Area.x2 - x + 1, CharHeight, Area.x2);
  
  }
  
  StageSettings.Num1[AreaIndex] = Second;
}
#endif

#ifdef  _DATE_ACTIVE_
void LEDDate(unsigned char AreaIndex, TArea Area, unsigned char dp_index /*data pointer index*/)
{
  TDateData dd;
  char DateStr[11];
  unsigned char i;
  unsigned int Year;
  unsigned char Month, Day;
  unsigned int TotalColumnCount;
  //eeprom unsigned char *SlashFont, *DashFont;
  unsigned char CharHeight;
  unsigned char x, y;
  BOOL Refresh;
  unsigned char AreaWidth, AreaHeight;
  BOOL UseSmallWidthChars;
  
  if(StageSettings.AreasDone[AreaIndex])
  {
    //It is also possible to keep this area alive until all other areas are done.
    //This can be implemented as an option.
    if(!Area.RepeatAfterDone)
    {
      //Clear the area and return
      ClearArea(Area);
      return;
    }
  }
  
  //dd = (TDateData flash*) DataStart;
  get_content_settings(dp_index, sizeof(TDateData), (unsigned char *) &dd);
  
  if(AreaElapsedTime(AreaIndex) >= dd.TotalDisplayTime)
  {
    StageSettings.AreasDone[AreaIndex] = TRUE;
  }
  
  
  if(dd.type == 0)
  {
    //Solar date
    get_date(&Year, &Month, &Day, 1);
  }
  else
  {
    //Gregorian date
    get_date(&Year, &Month, &Day, 0);
  }
  
  if(StageSettings.Num1[AreaIndex] != Day || StageSettings.Num3[AreaIndex] != Month)
    Refresh = TRUE;
  else
    Refresh = FALSE;
  
  //Generate date string
  switch(dd.format)
  {
    case 0:  //1387/01/01
      sprintf(DateStr, "%04d/%02d/%02d", Year, Month, Day);
      break;
    case 1:  //87/01/01
      sprintf(DateStr, "%02d/%02d/%02d", Year % 100 /*2 rightmost digits*/, Month, Day);
      break;
    case 2:  //1387-01-01
      sprintf(DateStr, "%04d-%02d-%02d", Year, Month, Day);
      break;
    case 3:  //87-01-01
      sprintf(DateStr, "%02d-%02d-%02d", Year % 100 /*2 rightmost digits*/, Month, Day);
      break;
    case 4:
    case 5:
      Refresh = TRUE;  //Always refresh in this format(just like clock)
      if(StageSettings.Num2[AreaIndex] == 0)
      {
        //Show month and day
        if((AreaElapsedTime(AreaIndex) - StageSettings.LastTickCount[AreaIndex]) >= 3)
        {
          StageSettings.LastTickCount[AreaIndex] = AreaElapsedTime(AreaIndex);
          StageSettings.Num2[AreaIndex] = 1;
        }
        if(dd.format == 4)
          sprintf(DateStr, "%02d/%02d", Month, Day);
        else
          sprintf(DateStr, "%02d-%02d", Month, Day);
      }
      else //if(StageSettings.Num2[AreaIndex] == 1)
      {
        //Show year
        if((AreaElapsedTime(AreaIndex) - StageSettings.LastTickCount[AreaIndex]) >= 3)
        {
          StageSettings.LastTickCount[AreaIndex] = AreaElapsedTime(AreaIndex);
          StageSettings.Num2[AreaIndex] = 0;
        }
        sprintf(DateStr, "%04d", Year);
      }
      break;
  }
  
  AreaWidth = Area.x2 - Area.x1 + 1;
  AreaHeight = Area.y2 - Area.y1 + 1;
  
  //------------------------------
  //Select font
  CharHeight = GetCharHeight(AreaHeight, &Area);
  UseSmallWidthChars = (AreaWidth <= 50 && dd.format != 4 && dd.format != 5) || ( AreaWidth <= 63 && (dd.format == 0 || dd.format == 2) ) || (AreaWidth <= 50 && (dd.format == 1 || dd.format == 2)) || (AreaWidth <= 32 & (dd.format == 4 || dd.format == 5));
  //CharHeight = SelectDigitsFont(AreaWidth, AreaHeight, dd.lang);
/*
  if(dd.lang == 0)
  {
    if(AreaHeight >= 24)
    {
      CharHeight = 24;
      for(i = 0; i < 10; i++)
        DigitsFont[i] = LEDDigitsFa24[i];
    }
    else if(AreaHeight >= 16)
    {
      CharHeight = 16;
      for(i = 0; i < 10; i++)
        DigitsFont[i] = LEDDigitsFa16[i];
    }
    else
    {
      CharHeight = 8;
      if(AreaWidth < 40)
      {
        for(i = 0; i < 10; i++)
          DigitsFont[i] = LEDDigitsFa8_SMALL[i];
      }
      else
      {
        for(i = 0; i < 10; i++)
          DigitsFont[i] = LEDDigitsFa8[i];
      }
    }
  }
  else
  {
    if(AreaHeight >= 24)
    {
      CharHeight = 24;
      for(i = 0; i < 10; i++)
        DigitsFont[i] = LEDDigitsEn24[i];
    }
    else if(AreaHeight >= 16)
    {
      CharHeight = 16;
      for(i = 0; i < 10; i++)
        DigitsFont[i] = LEDDigitsEn16[i];
    }
    else
    {
      CharHeight = 8;
      if(AreaWidth < 40)
      {
        for(i = 0; i < 10; i++)
          DigitsFont[i] = LEDDigitsEn8_SMALL[i];
      }
      else
      {
        for(i = 0; i < 10; i++)
          DigitsFont[i] = LEDDigitsEn8[i];
      }
    }
  }
*/
  /*
  switch(CharHeight)
  {
    case 8:
      SlashFont = Slash;
      DashFont = Dash;
      break;
    case 16:
      SlashFont = Slash16;
      DashFont = Dash16;
      break;
    case 24:
      SlashFont = Slash24;
      DashFont = Dash24;
      break;
  }
  */
  //Font selection complete
  //------------------------------
  
  if(Refresh)
  {
  //Count the number of columns date occupies (to put date at screen center)
  TotalColumnCount = 0;
  for(i = 0; i < strlen(DateStr); i++)
  {
    if((DateStr[i] == '/') || (DateStr[i] == '-') || (DateStr[i] >= '0' && DateStr[i] <= '9') )  //These may not be digits when DS1307 is not available
    TotalColumnCount += GetCharWidth(dd.lang, CharHeight, UseSmallWidthChars, DateStr[i]);
    /*
    if(DateStr[i] == '/')
    {
      //LEDPutChar(Area.x1, Area.y1, Slash, 0);
      TotalColumnCount += SlashFont[0];
    }
    else if(DateStr[i] == '-')
    {
      //LEDPutChar(Area.x1, Area.y1, Dash, 0);
      TotalColumnCount += DashFont[0];
    }
    else
    {
      if(DateStr[i] >= '0' && DateStr[i] <= '9')  //These may not be digits when DS1307 is not available
        TotalColumnCount += DigitsFont[DateStr[i] - 48][0];
    }
    */
  }

  x = Area.x1;
  y = Area.y1;
  //Center horizontally
  if(dd.CenterHorizontally && TotalColumnCount < AreaWidth)
  {
    x = Area.x1 + (AreaWidth - TotalColumnCount) / 2;
  }
  //Center vertically
  if(dd.CenterVertically && AreaHeight > CharHeight)
  {
    y = Area.y1 + (AreaHeight - CharHeight) / 2;
  }
  
  if(x > Area.x1)
  {
    LEDPutSpace(Area.x1, y, Area.y2, x - Area.x1 /*must not be plus 1*/, CharHeight, Area.x2);
  }
  
  for(i = 0; i < strlen(DateStr); i++)
  {
    if( !( (DateStr[i] == '/') || (DateStr[i] == '-') || (DateStr[i] >= '0' && DateStr[i] <= '9') ) )  //This may occur when DS1307 is not available
      break;
    
    LEDPutCharNEW(x, y, Area.y2, dd.lang, CharHeight, UseSmallWidthChars, DateStr[i], Area.x2);
    x += GetCharWidth(dd.lang, CharHeight, UseSmallWidthChars, DateStr[i]);
    
    if(x > Area.x2)
      break;
    /*
    if(DateStr[i] == '/')
    {
      
      if((x + SlashFont[0] - 1) > Area.x2 && CheckRightLimit)
        break;
      
      LEDPutChar(x, y, Area.y2, SlashFont, 0, CharHeight);
      x += SlashFont[0];
    }
    else if(DateStr[i] == '-')
    {
      
      if((x + DashFont[0] - 1) > Area.x2 && CheckRightLimit)
        break;
      
      LEDPutChar(x, y, Area.y2, DashFont, 0, CharHeight);
      x += DashFont[0];
    }
    else
    {
      if(DateStr[i] < '0' || DateStr[i] > '9')  //This may occur when DS1307 is not available
        break;
      
      if((x + DigitsFont[DateStr[i] - 48][0] - 1) > Area.x2 && CheckRightLimit)
        break;
      
      LEDPutChar(x, y, Area.y2, DigitsFont[DateStr[i] - 48], 0, CharHeight);
      x += DigitsFont[DateStr[i] - 48][0];
    }
    */
  }
  
  if(Area.x2 >= x)
    LEDPutSpace(x, y, Area.y2, Area.x2 - x + 1, CharHeight, Area.x2);
  }
  
  StageSettings.Num1[AreaIndex] = Day;
  StageSettings.Num3[AreaIndex] = Month;
}
#endif


eeprom unsigned char SCROLL_STEP_ADJUST = 0;  //This value always is in EEPROM even if scrolling text is inactive.

#ifdef  _SCROLLING_TEXT_ACTIVE_

/*
#define   SCROLL_STEP_VERY_FAST     5
#define   SCROLL_STEP_FAST          4
#define   SCROLL_STEP_MEDIUM        3
#define   SCROLL_STEP_SLOW          2
#define   SCROLL_STEP_VERY_SLOW     1
*/

/*
unsigned char DefineTextScrollStep(unsigned char slstSpeed)
{
  unsigned char ScrollStep;
  unsigned char NewScrollStep;
  
  //Very Fast (0-51), Fast (52-103), Medium (104-155), Slow (156-207), Very Slow (208-255)
  if(slstSpeed <= 51)  //Very Fast
    ScrollStep = SCROLL_STEP_VERY_FAST;
  else if(slstSpeed <= 103)  //Fast
    ScrollStep = SCROLL_STEP_FAST;
  else if(slstSpeed <= 103)  //Medium
    ScrollStep = SCROLL_STEP_MEDIUM;
  else if(slstSpeed <= 103)  //Slow
    ScrollStep = SCROLL_STEP_SLOW;
  else //if(slstSpeed <= 103)  //Very Slow
    ScrollStep = SCROLL_STEP_VERY_SLOW;
  
  NewScrollStep = ScrollStep + SCROLL_STEP_ADJUST;
  if(NewScrollStep >= ScrollStep)
    ScrollStep = NewScrollStep;
  
  return(ScrollStep);
}
*/

typedef unsigned char (*DATAPTR)( unsigned char dp_index, unsigned long int offset );   /* Pointer to event handler */

unsigned long GetData(DATAPTR DataFun, unsigned char dp_index, long d_offset, unsigned char BytesPerCol)
{
  unsigned long c;
  
  #pragma warn-
  c = DataFun(dp_index, d_offset);
  if(BytesPerCol > 1)
    c = (c << 8) | DataFun(dp_index, d_offset + 1UL);  //Get MSB
  #ifdef  _ROWS_24_
  if(BytesPerCol > 2)
    c = (c << 8) | DataFun(dp_index, d_offset + 2UL);  //Get MSB
  #endif
  #ifdef  _ROWS_32_
  if(BytesPerCol > 3)
    c = (c << 8) | DataFun(dp_index, d_offset + 3UL);  //Get MSB
  #endif
  #pragma warn+
  
  return(c);
}

void LEDSingleLineScrollingText(unsigned char AreaIndex, TArea Area, unsigned char dp_index /*data pointer index*/)
{
//  unsigned int TotalRefreshTimems;  //in milliseconds
  TSingleLineScrollingText slst;
  unsigned int i, NextCol, StartCol;
  unsigned long b1, b2, b, c;
  unsigned int ScreenCol;
  unsigned char AreaWidth, AreaHeight;
  unsigned char BytesPerCol;
  BOOL ResetTextPlay = FALSE;
  long d_offset;
  //unsigned char *ScreenToUpdate[SCREEN_ARRAY_BOUND];
  unsigned char ScrollStep;
  
  BOOL UpdateAnim = FALSE;
  
  if(StageSettings.AreasDone[AreaIndex])
  {
    //It is also possible to keep this area alive until all other areas are done.
    //This can be implemented as an option.
    if(!Area.RepeatAfterDone)
    {
      //Clear the area and return
      ClearArea(Area);
      return;
    }
  }
  
  //slst = (TSingleLineScrollingText flash*) DataStart;
  get_content_settings(dp_index, sizeof(TSingleLineScrollingText), (unsigned char *) &slst);
  
  //ScrollStep = DefineTextScrollStep(slst.Speed);
  ScrollStep = slst.ScrollStep;
  BytesPerCol = ScrollStep + SCROLL_STEP_ADJUST;  //**BytesPerCol is used as a temp variable here
  if(BytesPerCol > ScrollStep)  //Prevent overflow in 8-bit addition
    ScrollStep = BytesPerCol;
  if(ScrollStep == 0)
    ScrollStep = 2;
 
//  slst.FixedText = 1;
  
////////////ddddddddddddddddddddd=============
//  Area.EntranceAnimID = 2;  //Index of the gif file of the effect is this index plus 1 (1 -> Effect2.gif, 2 -> Effect3.gif, etc.)
//  slst.ScrollType = 1;
////////////ddddddddddddddddddddd=============

//  lcd_putnumuc(Area.EntranceAnimID);
  
  
  if(!StageSettings.EntranceAnimDone[AreaIndex])
  {
    if(Area.EntranceAnimID == 0)
    {
      StageSettings.EntranceAnimDone[AreaIndex] = TRUE;
    }
    else
    {
      if(StageSettings.AnimInitialized[AreaIndex])
      {
        //Timing: Area Animation
        if( TickCount - StageSettings.LastTickCount[AreaIndex] < (unsigned long)((float)Area.AnimSpeed * CONTENT_SPEED_MULTIPLIER) &&
            TickCount >= StageSettings.LastTickCount[AreaIndex] )
            //&& StageSettings.EntranceAnimDone[AreaIndex])  //No Entrance Animation is applied to a stage
        {
          return;
        }
        ////////
        StageSettings.EntranceAnimDone[AreaIndex] = ApplyAnimation(AreaIndex, &Area, Area.EntranceAnimID);
        if(StageSettings.EntranceAnimDone[AreaIndex])
          reset_AreaElapsedTime(AreaIndex);
        StageSettings.LastTickCount[AreaIndex] = TickCount;
        return;
      }
      else
      {
        StageSettings.AnimInitialized[AreaIndex] = TRUE;
        InitAnim(AreaIndex, &Area, Area.EntranceAnimID);
        UpdateAnim = TRUE;
        slst.ScrollType = 1;
      }
    }
  }

  #pragma warn-
  //TotalRefreshTimems = (unsigned int) OVERALL_REFRESH_COUNT * (unsigned int) ( (COL_COUNT * REFRESH_DELAY)/1000);
  #pragma warn+
  //StageSettings.SLST[AreaIndex].SpeedDelayCount = slst.Speed / 10;
  //StageSettings.SLST[AreaIndex].DelayCounter++;
//  nmsg("DelayCounter", StageSettings.SLST[AreaIndex].DelayCounter);
//  delay_ms(400);
  
  //Timing
  if( TickCount - StageSettings.LastTickCount[AreaIndex] < (unsigned long)((float)slst.Speed * CONTENT_SPEED_MULTIPLIER)
      && !StageSettings.ForceUpdate
      && StageSettings.EntranceAnimDone[AreaIndex])
  {
    return;
  }
  ////////
  
  //Scroll the text one column
  //StageSettings.SLST[AreaIndex].StartCol++;
  StartCol = StageSettings.SLST[AreaIndex].StartCol;  //Use StartCol first to decrease code size and also speed up
  if(StartCol == 0)
    StartCol = 1;
  else
    StartCol += ScrollStep;
  StageSettings.SLST[AreaIndex].StartCol = StartCol;  //StartCol value is used in the next steps and must be stored in the StageSettings.SLST[AreaIndex].StartCol variable
  
  AreaWidth = Area.x2 - Area.x1 + 1;
  AreaHeight = Area.y2 - Area.y1 + 1;
  
  //============================================================
  //Variables Description for future debugging:
  //NextCol: This indicates the column number (starting from the left of the area) that drawing the text will be start frrom there (as ScreenCol = Area.x1 + NextCol - 1;).
  //StartCol: This indicates the next data column to get data from it.
  //============================================================
  
  //Set next column index according to the direction of the text
  if(slst.Direction == 0)  //Right
  {
    if(slst.FixedText)
    {
      if(slst.ColCount < AreaWidth)
      {
        NextCol = AreaWidth - (AreaWidth - slst.ColCount) / 2;
        if(StartCol > NextCol)  //Don't allow the text to go beyond its limit when the text width is less than the area width
          StartCol = NextCol;
      }
      else
        NextCol = AreaWidth;
    }
    else
      NextCol = AreaWidth;
    
    if((slst.ScrollType == 0) && !StageSettings.SLST[AreaIndex].NormalScroll && (StartCol < NextCol))
    {
      //if( (StartCol + 1) >= NextCol)
      if( (StartCol + ScrollStep) >= NextCol)
      {
        StageSettings.SLST[AreaIndex].NormalScroll = TRUE;
        if(slst.FixedText == 1)
          reset_AreaElapsedTime(AreaIndex);
        StageSettings.SLST[AreaIndex].StartCol = 0;
      }
      NextCol = StartCol;
      StartCol = 1;
    }
  }
  else if(slst.Direction == 1)  //Left
  {
    if(slst.FixedText)
    {
      if(slst.ColCount < AreaWidth)
      {
        NextCol = (AreaWidth - slst.ColCount) / 2;
        if(StartCol > (AreaWidth - (AreaWidth - slst.ColCount) / 2))  //Don't allow the text to go beyond its limit when the text width is less than the area width
          StartCol = (AreaWidth - (AreaWidth - slst.ColCount) / 2);
        BytesPerCol = AreaWidth - (AreaWidth - slst.ColCount) / 2;  //BytesPerCol is used as a temp variable here (= limit of StartCol)
      }
      else
      {
        BytesPerCol = AreaWidth;  //**BytesPerCol is used as a temp variable here (= limit of StartCol)
        NextCol = 1;
      }
      if((slst.ScrollType == 0) && !StageSettings.SLST[AreaIndex].NormalScroll && (StartCol < BytesPerCol /* **BytesPerCol is used as a temp variable here*/))
      {
        //if( (StartCol + 1) >= (AreaWidth - (AreaWidth - slst.ColCount) / 2))
        if( (StartCol + ScrollStep) >= BytesPerCol)//(AreaWidth - (AreaWidth - slst.ColCount) / 2))
        {
          StageSettings.SLST[AreaIndex].NormalScroll = TRUE;
          if(slst.FixedText == 1)
            reset_AreaElapsedTime(AreaIndex);
          StageSettings.SLST[AreaIndex].StartCol = 0;
        }
        NextCol = AreaWidth - StartCol;
        StartCol = 1;
      }
    }
    else
    {
      
      NextCol = 1;
      
      if((slst.ScrollType == 0) && !StageSettings.SLST[AreaIndex].NormalScroll && (StartCol < AreaWidth))
      {
        //if( (StartCol + 1) >= AreaWidth)
        if( (StartCol + ScrollStep) >= AreaWidth )
        {
          StageSettings.SLST[AreaIndex].NormalScroll = TRUE;
          if(slst.FixedText == 1)
            reset_AreaElapsedTime(AreaIndex);
          StageSettings.SLST[AreaIndex].StartCol = 0;
        }
        NextCol = AreaWidth - StartCol;
        StartCol = 1;
      }
     
    }
  }
    
  //Define the number of data bytes per each column of the text
  if(AreaHeight <= 8)
    BytesPerCol = 1;
  else if(AreaHeight <= 16)
    BytesPerCol = 2;
  else if(AreaHeight <= 24)
    BytesPerCol = 3;
  else
    BytesPerCol = 4;
  
  //Apply FixedText setting
  if(slst.FixedText == 1)
    StartCol = 1;
  
  b1 = 0xFFFFFFFF << Area.y1;
  b2 = 0xFFFFFFFF >> (31 - Area.y2);
  b = ~(b1 & b2);

  d_offset = ((long) StartCol - 1) * BytesPerCol - (long) BytesPerCol;  //b2 is used to convert multiplication operation into addition operation
  for(i = StartCol - 1; i < slst.ColCount; i++)
  {
    //b2 = i * BytesPerCol;  --> Converted to addition operation
    d_offset += (long) BytesPerCol;
    
    c = GetData(slst_Data, dp_index, d_offset, BytesPerCol);
    /*
    switch(BytesPerCol)
    {
      case 1:
        //c = 0;
        c = slst_Data(dp_index, d_offset);
        break;
      case 2:
        //Exchange MSB and LSB
        c =  slst_Data(dp_index, d_offset);  //Get LSB
        #pragma warn-
        c = (c << 8) | slst_Data(dp_index, d_offset + 1UL);  //Get MSB
        #pragma warn+
        break;
      case 3:
        //Exchange MSB and LSB
        c =  slst_Data(dp_index, d_offset);  //Get LSB
        #pragma warn-
        c = (c << 8) | slst_Data(dp_index, d_offset + 1UL);  //Get MSB
        c = (c << 8) | slst_Data(dp_index, d_offset + 2UL);  //Get MSB
        #pragma warn+
        break;
      case 4:
        //Exchange MSB and LSB
        c =  slst_Data(dp_index, d_offset);  //Get LSB
        #pragma warn-
        c = (c << 8) | slst_Data(dp_index, d_offset + 1UL);  //Get MSB
        c = (c << 8) | slst_Data(dp_index, d_offset + 2UL);  //Get MSB
        c = (c << 8) | slst_Data(dp_index, d_offset + 3UL);  //Get MSB
        #pragma warn+
        break;
    }
    */
    
    ScreenCol = Area.x1 + NextCol - 1;
    
/*--> DID NOT WORK CORRECTLY! WHY? I DO NOT KNOW! IT IS A MISTRY!
    if(UpdateAnim)
    {
      for(i = 0; i < SCREEN_ARRAY_BOUND; i++)
        ScreenToUpdate[i] = AnimScreen[i];
    }
    else
    {
      for(i = 0; i < SCREEN_ARRAY_BOUND; i++)
        ScreenToUpdate[i] = Screen[i];
    }
*/


    if(UpdateAnim)
    {
      b1 = LoadFromAnimScreen(ScreenCol);
    }
    else
    {
      b1 = LoadFromScreen(ScreenCol);
    }

    
    c <<= Area.y1;
    
    //c = MirrorBits(c, Area.y1, Area.y2);  --> Implemented directly in the delphi program

    //if(slst.Invert == 1)  --> Implemented directly in the delphi program
    //  c = NotBits(c, Area.y1, Area.y2);

    /* This part is not needed because the other bits have become zero in the delphi program
    if(Area.y1 > 0)
      c = AndBits(c, 0, Area.y1 - 1, 0);
    if(Area.y2 < (ROW_COUNT - 1))
      c = AndBits(c, Area.y2 + 1, ROW_COUNT - 1, 0);
    */
  
    b1 = (b & b1) | c;
  
    if(UpdateAnim)
    {
      StoreToAnimScreen(b1, ScreenCol);
    }
    else
    {
      StoreToScreen(b1, ScreenCol);
    }
    
    if(slst.Direction == 0)  //Right
    {
      if(NextCol == 0)
        break;
      NextCol--;
      if(NextCol == 0)
        break;
    }
    else if(slst.Direction == 1)  //Left
    {
      if(NextCol >= AreaWidth)
        break;
      NextCol++;
    }
  }
  
  if( (NextCol > 0 && slst.Direction == 0) || (NextCol < AreaWidth && slst.Direction == 1) )
  {
    //Fill with zero
    c = AndBits(0xffffffff, Area.y1, Area.y2, 0);
    while(1)
    {
      if(UpdateAnim)
      {
        /*
        //Don't use StoreToAnimScreen here because we have &=
        AnimScreen[0][Area.x1 + NextCol - 1] &= c;//0xFF >> (8 - Area.y1);
        AnimScreen[1][Area.x1 + NextCol - 1] &= c >> 8;//0xFF << Area.y1;
        #ifdef  _ROWS_24_
        AnimScreen[2][Area.x1 + NextCol - 1] &= c >> 16;//0xFF << Area.y1;
        #endif
        #ifdef  _ROWS_32_
        AnimScreen[3][Area.x1 + NextCol - 1] &= c >> 24;//0xFF << Area.y1;
        #endif
        */
        StoreToAnimScreen(LoadFromAnimScreen(Area.x1 + NextCol - 1) & c, Area.x1 + NextCol - 1);
      }
      else
      {
        /*
        //Don't use StoreToScreen here because we have &=
        Screen[0][Area.x1 + NextCol - 1] &= c;//0xFF >> (8 - Area.y1);
        Screen[1][Area.x1 + NextCol - 1] &= c >> 8;//0xFF << Area.y1;
        #ifdef  _ROWS_24_
        Screen[2][Area.x1 + NextCol - 1] &= c >> 16;//0xFF << Area.y1;
        #endif
        #ifdef  _ROWS_32_
        Screen[3][Area.x1 + NextCol - 1] &= c >> 24;//0xFF << Area.y1;
        #endif
        */
        StoreToScreen(LoadFromScreen(Area.x1 + NextCol - 1) & c, Area.x1 + NextCol - 1);
      }
      if(slst.Direction == 0)  //Right
      {
        NextCol--;
        if(NextCol == 0)
          break;
      }
      else  //slst.Direction == 1  //Left
      {
        NextCol++;
        if(NextCol > AreaWidth)
          break;
      }          
    }
  }  //if(NextCol > 0)

  if(slst.FixedText)
  {
    if(slst.TotalDisplayTime > 0)
    {
      if(AreaElapsedTime(AreaIndex) >= slst.TotalDisplayTime)
      {
        if(slst.ScrollType == 0)
        {
          if(StageSettings.SLST[AreaIndex].NormalScroll)  //If the effect is scrolling into the screen, wait for it to complete, then start measuring the time again
            StageSettings.AreasDone[AreaIndex] = TRUE;
        }
        else
          StageSettings.AreasDone[AreaIndex] = TRUE;
      }
    }
    else
      StageSettings.AreasDone[AreaIndex] = TRUE;
  }
  else if(slst.RepetitionTimes > 0)
  {
    if(StartCol > slst.ColCount)
    {
      ResetTextPlay = TRUE;
      StageSettings.AreaRepeatCount[AreaIndex]++;
    }
    if(StageSettings.AreaRepeatCount[AreaIndex] >= slst.RepetitionTimes)
      StageSettings.AreasDone[AreaIndex] = TRUE;
  }
  else if(slst.TotalDisplayTime > 0)
  {
    if(StartCol > slst.ColCount)
      ResetTextPlay = TRUE;
    if(AreaElapsedTime(AreaIndex) >= slst.TotalDisplayTime)
      StageSettings.AreasDone[AreaIndex] = TRUE;
  }
  else if(StartCol > slst.ColCount)
  {
    StageSettings.AreasDone[AreaIndex] = TRUE;
    ResetTextPlay = TRUE;
  }
  if(ResetTextPlay)
  {
    StageSettings.SLST[AreaIndex].StartCol = 0;
    StageSettings.SLST[AreaIndex].NormalScroll = FALSE;
    StageSettings.EntranceAnimDone[AreaIndex] = FALSE;
    StageSettings.AnimInitialized[AreaIndex] = FALSE;
  }
  
  StageSettings.LastTickCount[AreaIndex] = TickCount;
}
#endif

#ifdef  _ANIMATION_ACTIVE_
void LEDFramedAnimation(unsigned char AreaIndex, TArea Area, unsigned char dp_index /*data pointer index*/)
{
  TFramedAnimation fa;
  unsigned long FrameDataIndex;
  unsigned long b1, b2, b, c;
  unsigned char Col;
  
  
  if(StageSettings.AreasDone[AreaIndex])
  {
    //It is also possible to keep this area alive until all other areas are done.
    //This can be implemented as an option.
    if(!Area.RepeatAfterDone)
    {
      //Clear the area and return
      ClearArea(Area);
      return;
    }
  }

  //fa = (TFramedAnimation flash*) DataStart;
  get_content_settings(dp_index, sizeof(TFramedAnimation), (unsigned char *) &fa);
  
  //Timing
  if( TickCount - StageSettings.LastTickCount[AreaIndex] < (unsigned long)((float)fa.Speed * CONTENT_SPEED_MULTIPLIER)
      && !StageSettings.ForceUpdate)
      //&& StageSettings.EntranceAnimDone[AreaIndex])  //Framed Animation has no entrance animation
  {
    return;
  }
  ////////
  
  //StageSettings.FA[AreaIndex].DelayCounter = 0;
  StageSettings.FA[AreaIndex].CurrentFrame++;
  
  #pragma warn-
  FrameDataIndex = ((unsigned long) StageSettings.FA[AreaIndex].CurrentFrame - 1) * (unsigned long) fa.FrameColCount * (unsigned long) fa.BytesPerCol;
  #pragma warn+
  
  if(fa.CenterHorizontally == 1)
  {
    Area.x1 += (Area.x2 - Area.x1 + 1) / 2 - fa.FrameColCount / 2;
  }
  
  if(!StageSettings.FA[AreaIndex].FirstFrameLoaded ||
     fa.FrameCount > 1)
  {
    b1 = 0xFFFFFFFF << Area.y1;
    b2 = 0xFFFFFFFF >> (31 - Area.y2);
    b = ~(b1 & b2);
    for(Col = 0; Col < fa.FrameColCount; Col++)
    {
      b1 = FrameDataIndex + (unsigned long) Col * fa.BytesPerCol;
      
      c = GetData(fa_Data, dp_index, b1, fa.BytesPerCol);
      
/*
      switch(fa.BytesPerCol)
      {
        case 1:
          //c = 0;
          c = fa_Data(dp_index, b1);
          break;
        case 2:
          c = fa_Data(dp_index, b1);  //Higher byte
          c = (c << 8) | fa_Data(dp_index, b1 + 1UL);  //Lower byte
          break;
        case 3:
          c = fa_Data(dp_index, b1);  //Higher byte
          c = (c << 8) | fa_Data(dp_index, b1 + 1UL);  //Lower byte
          c = (c << 8) | fa_Data(dp_index, b1 + 2UL);  //Lower byte
          break;
        case 4:
          c = fa_Data(dp_index, b1);  //Higher byte
          c = (c << 8) | fa_Data(dp_index, b1 + 1UL);  //Lower byte
          c = (c << 8) | fa_Data(dp_index, b1 + 2UL);  //Lower byte
          c = (c << 8) | fa_Data(dp_index, b1 + 3UL);  //Lower byte
          break;
      }
*/
      
      //lcd_puthex(c);
      
      b1 = LoadFromScreen(Area.x1);
      
      c <<= Area.y1;
      
      //c = MirrorBits(c, Area.y1, Area.y2);  --> Implemented directly in the delphi program

      //if(fa.Invert == 1)  --> Implemented directly in the delphi program
      //  c = NotBits(c, Area.y1, Area.y2);

      /* This part is not needed because the other bits have become zero in the delphi program
      if(Area.y1 > 0)
        c = AndBits(c, 0, Area.y1 - 1, 0);
      if(Area.y2 < (ROW_COUNT - 1))
        c = AndBits(c, Area.y2 + 1, ROW_COUNT - 1, 0);
      */
      
      b1 = (b & b1) | c;
      
      
      StoreToScreen(b1, Area.x1);
      
      Area.x1++;
    }
    
    StageSettings.FA[AreaIndex].FirstFrameLoaded = TRUE;
  }
  
  if(fa.RepetitionTimes > 0)
  {
    if(StageSettings.FA[AreaIndex].CurrentFrame >= fa.FrameCount)
      StageSettings.AreaRepeatCount[AreaIndex]++;
    if(StageSettings.AreaRepeatCount[AreaIndex] >= fa.RepetitionTimes)
      StageSettings.AreasDone[AreaIndex] = TRUE;
  }
  else if(fa.TotalDisplayTime > 0)
  {
    if(AreaElapsedTime(AreaIndex) >= fa.TotalDisplayTime)
      StageSettings.AreasDone[AreaIndex] = TRUE;
  }
  else if(StageSettings.FA[AreaIndex].CurrentFrame >= fa.FrameCount)
  {
    StageSettings.AreasDone[AreaIndex] = TRUE;
    //This area is done. But keep it alive until all other areas are done.
  }
  if(StageSettings.FA[AreaIndex].CurrentFrame >= fa.FrameCount)
    StageSettings.FA[AreaIndex].CurrentFrame = 0;

  //Timing
  StageSettings.LastTickCount[AreaIndex] = TickCount;
  ////////
}
#endif

#ifdef  _TEMPERATURE_ACTIVE_
void LEDTemperature(unsigned char AreaIndex, TArea Area, unsigned char dp_index /*data pointer index*/)
{
  TTemperature t;
  char TempStr[10];  //+/-xxx0C
  unsigned char i;
  unsigned int TotalColumnCount;
  unsigned char x, y;
  //eeprom unsigned char *PositiveFont, *DashFont, *CFont, *FFont;
  unsigned char CharHeight;
  int TempVal, OldTemp;
  BOOL Refresh;
  unsigned char AreaWidth, AreaHeight;
  BOOL UseSmallWidthChars;
  
  if(StageSettings.AreasDone[AreaIndex])
  {
    //It is also possible to keep this area alive until all other areas are done.
    //This can be implemented as an option.
    if(!Area.RepeatAfterDone)
    {
      //Clear the area and return
      ClearArea(Area);
      return;
    }
  }
  
  //t = (TTemperature flash*) DataStart;
  get_content_settings(dp_index, sizeof(TTemperature), (unsigned char *) &t);
  
  if(AreaElapsedTime(AreaIndex) >= t.TotalDisplayTime)
  {
    StageSettings.AreasDone[AreaIndex] = TRUE;
  }
  
  //Read temperature every 1 seconds
  // ** IMPORTANT NOTE: If LM75 is used, a very short delay (for example 100ms) is necessary between any read operation, unless LM75 will always give you the last read value. ** //
  if(StageSettings.Num3[AreaIndex] == 0)  //0 means refresh temperature value normally
    if((AreaElapsedTime(AreaIndex) - StageSettings.LastTickCount[AreaIndex]) < 10)
      return;
  
  if(!temperature_read(TempStr, t.unit, &TempVal))
    return;
  
  StageSettings.Num3[AreaIndex] = 0;  //1 means force refresh, 0 means normal refresh
  
  StageSettings.LastTickCount[AreaIndex] = AreaElapsedTime(AreaIndex);
  
  OldTemp = (((unsigned int) StageSettings.Num2[AreaIndex]) << 8) | (unsigned int) StageSettings.Num1[AreaIndex];
  if(abs(TempVal - OldTemp) < 1)  //at least 2 degrees must have to update the temperature because of boundary errors in refresh
    return;
  
  Refresh = TRUE;
  
  i = strlen(TempStr);
  if(t.unit == 0)  //Centigrade
    TempStr[i] = 'C';
  else
    TempStr[i] = 'F';
  #pragma warn-
  TempStr[i + 1] = 0;  //Terminate the string
  #pragma warn+
  
  AreaWidth = Area.x2 - Area.x1 + 1;
  AreaHeight = Area.y2 - Area.y1 + 1;
  
  //------------------------------
  //Select font
  CharHeight = GetCharHeight(AreaHeight, &Area);
  UseSmallWidthChars = (AreaWidth < 36);
  //CharHeight = SelectDigitsFont(AreaWidth, AreaHeight, t.lang);
/*
  if(t.lang == 0)
  {
    if(AreaHeight >= 24)
    {
      CharHeight = 24;
      for(i = 0; i < 10; i++)
        DigitsFont[i] = LEDDigitsFa24[i];
    }
    else if(AreaHeight >= 16)
    {
      CharHeight = 16;
      for(i = 0; i < 10; i++)
        DigitsFont[i] = LEDDigitsFa16[i];
    }
    else
    {
      CharHeight = 8;
      if(AreaWidth < 36)
      {
        for(i = 0; i < 10; i++)
          DigitsFont[i] = LEDDigitsFa8_SMALL[i];
      }
      else
      {
        for(i = 0; i < 10; i++)
          DigitsFont[i] = LEDDigitsFa8[i];
      }
    }
  }
  else
  {
    if(AreaHeight >= 24)
    {
      CharHeight = 24;
      for(i = 0; i < 10; i++)
        DigitsFont[i] = LEDDigitsEn24[i];
    }
    else if(AreaHeight >= 16)
    {
      CharHeight = 16;
      for(i = 0; i < 10; i++)
        DigitsFont[i] = LEDDigitsEn16[i];
    }
    else
    {
      CharHeight = 8;
      if(AreaWidth < 36)
      {
        for(i = 0; i < 10; i++)
          DigitsFont[i] = LEDDigitsEn8_SMALL[i];
      }
      else
      {
        for(i = 0; i < 10; i++)
          DigitsFont[i] = LEDDigitsEn8[i];
      }
    }
  }
*/
  
  /*
  switch(CharHeight)
  {
    case 8:
      PositiveFont = Positive;
      DashFont = Dash;
      CFont = DegreeCentigradeSign;
      FFont = DegreeFahrenheitSign;
      break;
    case 16:
      PositiveFont = Positive16;
      DashFont = Dash16;
      CFont = DegreeCentigradeSign16;
      FFont = DegreeFahrenheitSign16;
      break;
    case 24:
      PositiveFont = Positive24;
      DashFont = Dash24;
      CFont = DegreeCentigradeSign24;
      FFont = DegreeFahrenheitSign24;
      break;
  }
  */
  //Font selection complete
  //------------------------------
  
  if(Refresh)
  {
  
  //Count the number of columns temperature occupies (to put temperature at screen center)
  TotalColumnCount = 0;
  for(i = 0; i < strlen(TempStr); i++)
  {
    if((TempStr[i] == '+') || (TempStr[i] == '-') || (TempStr[i] == 'C') || (TempStr[i] == 'F') || (TempStr[i] >= '0' && TempStr[i] <= '9'))  //These may not be digits when LM75 is not available
      TotalColumnCount += GetCharWidth(t.lang, CharHeight, UseSmallWidthChars, TempStr[i]);
    /*
    if
    {
      //LEDPutChar(Area.x1, Area.y1, Positive, 0);
      TotalColumnCount += PositiveFont[0];
    }
    else if
    {
      //LEDPutChar(Area.x1, Area.y1, Dash, 0);
      TotalColumnCount += DashFont[0];
    }
    else if
    {
      //LEDPutChar(Area.x1, Area.y1, DegreeCentigradeSign, 0);
      TotalColumnCount += CFont[0];
    }
    else if
    {
      //LEDPutChar(Area.x1, Area.y1, DegreeFahrenheitSign, 0);
      TotalColumnCount += FFont[0];
    }
    else
    {
      if(TempStr[i] >= '0' && TempStr[i] <= '9')  //These may not be digits when LM75 is not available
        TotalColumnCount += DigitsFont[TempStr[i] - 48][0];
    }
    */
  }

  x = Area.x1;
  y = Area.y1;
  //Center horizontally
  if(t.CenterHorizontally && TotalColumnCount < AreaWidth)
  {
    x = Area.x1 + (AreaWidth - TotalColumnCount) / 2;
  }
  //Center vertically
  if(t.CenterVertically && AreaHeight > CharHeight)
  {
    y = Area.y1 + (AreaHeight - CharHeight) / 2;
  }
  
  if(x > Area.x1)
  {
    LEDPutSpace(Area.x1, y, Area.y2, x - Area.x1 /*must not be plus 1*/, CharHeight, Area.x2);
  }
  
  for(i = 0; i < strlen(TempStr); i++)
  {
    if( !( (TempStr[i] == '+') || (TempStr[i] == '-') || (TempStr[i] == 'C') || (TempStr[i] == 'F') || (TempStr[i] >= '0' && TempStr[i] <= '9') ) )  //This may occur when LM75 is not available
      break;
    
    LEDPutCharNEW(x, y, Area.y2, t.lang, CharHeight, UseSmallWidthChars, TempStr[i], Area.x2);
    x += GetCharWidth(t.lang, CharHeight, UseSmallWidthChars, TempStr[i]);
    
    if(x > Area.x2)
      break;
    /*
    if(TempStr[i] == '+')
    {
      
      if((x + PositiveFont[0] - 1) > Area.x2 && CheckRightLimit)
        break;
      
      LEDPutChar(x, y, Area.y2, PositiveFont, 0, CharHeight);
      x += PositiveFont[0];
    }
    else if(TempStr[i] == '-')
    {
      
      if((x + DashFont[0] - 1) > Area.x2 && CheckRightLimit)
        break;
      
      LEDPutChar(x, y, Area.y2, DashFont, 0, CharHeight);
      x += DashFont[0];
    }
    else if(TempStr[i] == 'C')
    {
      
      if((x + CFont[0] - 1) > Area.x2 && CheckRightLimit)
        break;
      
      LEDPutChar(x, y, Area.y2, CFont, 0, CharHeight);
      x += CFont[0];
    }
    else if(TempStr[i] == 'F')
    {
      
      if((x + FFont[0] - 1) > Area.x2 && CheckRightLimit)
        break;
      
      LEDPutChar(x, y, Area.y2, FFont, 0, CharHeight);
      x += FFont[0];
    }
    else
    {
      if(TempStr[i] < '0' || TempStr[i] > '9')  //This may occur when LM75 is not available
        break;

      if((x + DigitsFont[TempStr[i] - 48][0] - 1) > Area.x2 && CheckRightLimit)
        break;
      
      LEDPutChar(x, y, Area.y2, DigitsFont[TempStr[i] - 48], 0, CharHeight);
      x += DigitsFont[TempStr[i] - 48][0];
    }
    */
  }
  
  if(Area.x2 >= x)  //If this condition is not satisfied, the program will crash.
    LEDPutSpace(x, y, Area.y2, Area.x2 - x + 1, CharHeight, Area.x2);
  
  }
  
  StageSettings.Num1[AreaIndex] = (unsigned int) TempVal;
  StageSettings.Num2[AreaIndex] = (unsigned int) TempVal >> 8;
}
#endif

void LEDEmpty(unsigned char AreaIndex, TArea Area, unsigned char dp_index /*data pointer index*/)
{
  TEmpty e;
  
  if(StageSettings.AreasDone[AreaIndex])
  {
    //It is also possible to keep this area alive until all other areas are done.
    //This can be implemented as an option.
    if(!Area.RepeatAfterDone)
    {
      //Clear the area and return
      ClearArea(Area);
      return;
    }
  }
  
  //e = (TEmpty flash*) DataStart;
  get_content_settings(dp_index, sizeof(TEmpty), (unsigned char *) &e);
  
  if(AreaElapsedTime(AreaIndex) >= e.TotalDisplayTime)
  {
    StageSettings.AreasDone[AreaIndex] = TRUE;
  }
  
  if(StageSettings.Num1[AreaIndex] == 0)  //This ensures that the Empty area is refreshed only one time (and no more refresh is needed!).
  {
    StageSettings.Num1[AreaIndex] = 1;
    if(e.Filled == 1)
    {
      FillArea(Area);
    }
    else
    {
      //ClearArea(Area);  --> This also clears borders of the area, but we don't want to do that, so use ClearAreaXY instead.
      ClearAreaXY(Area.x1, Area.y1, Area.x2, Area.y2);
    }
  }
}

#ifdef  _TIME_SPAN_ACTIVE_
BOOL ValidateStageTimeSpan()
{
  unsigned char Hour, Minute, Second;
  
  rtc_get_time(&Hour, &Minute, &Second);
  
  //Check time span
  if(CurrentStage.HourFrom <= CurrentStage.HourTo)
  {
    if(!(Hour >= CurrentStage.HourFrom && Hour <= CurrentStage.HourTo))
      return(FALSE);
  }
  else  //CurrentStage.HourFrom > CurrentStage.HourTo
  {
    if(Hour < CurrentStage.HourFrom && Hour > CurrentStage.HourTo)
      return(FALSE);
  }
  if(CurrentStage.HourFrom == Hour)
  {
    if(CurrentStage.MinuteFrom > Minute)
      return(FALSE);
  }
  if(CurrentStage.HourTo == Hour)
  {
    if(CurrentStage.MinuteTo <= Minute)  //For example, when we want the show to be played from 08:00 to 08:30, in fact when time reaches 08:00 the show must be strated and as soon as it reaches 08:30, it must be stopped. So when Hour is equal to HourTo, we stop playing if Minute is less than or equal to MinuteTo.
      return(FALSE);
  }
  /////////////////
  
  return(TRUE);
}
#endif

BOOL SelectStage()
{
  static unsigned char StageRepeatedTimes = 0;
  unsigned char NextStageIndex;
  unsigned char i;
  BOOL AllDone = TRUE;
  #ifdef  _TIME_SPAN_ACTIVE_
  static unsigned char OldClkSecond = 0xff;  //Must be 0xff to force check in the first run, because ClkSecond never becomes 0xff.
  #endif
  
  #ifdef  _TIME_SPAN_ACTIVE_
  if(StageSettings.TimeSpanDefined)
  {
    if(OldClkSecond != ClkSecond)
    {
      if(!ValidateStageTimeSpan())
      {
        for(i = 0; i < 4; i++)
          StageSettings.AreasDone[i] = TRUE;
        StageRepeatedTimes = 0xff;
      }
      OldClkSecond = ClkSecond;
    }
  }
  #endif
  
  for(i = 0; i < 4; i++)
    AllDone = AllDone & StageSettings.AreasDone[i];
  if(AllDone)
  {
    StageRepeatedTimes++;
  }
  else
  {
    return(TRUE);
  }
  NextStageIndex = CurrentStageIndex;
  if(StageRepeatedTimes >= CurrentStage.RepeatitionTimes)
  {
    NextStageIndex = NextStageIndex++;
    if(NextStageIndex >= StageCount)
      NextStageIndex = 0;
    StageRepeatedTimes = 0;
  }
  if(AllDone)
  {
    //No need to ChangeState if it is time to reset!
    if(NextStageIndex == 0)
    {
      ClearScreen(FALSE);
      //if(StageCount > 1)
      if(MICRO_RESET_AFTER_EACH_SHOW != 0x00)  //0x00 = No (Don't Reset), Any other value = Yes (Reset)
        MicroReset();
      
      /*
      if(StageCount > 1)
      {
        //Warm reset
        MicroReset();
      }
      else
      {
        //Warm reset
        MicroReset();
      }
      */
    }
    ChangeStage(NextStageIndex, FALSE);  //Not The First Run
    
    #ifdef  _TIME_SPAN_ACTIVE_
    if(!ValidateStageTimeSpan())
    {
      OldClkSecond = 0xff;  //because ClkSecond never becomes 0xff
      return(FALSE);
    }
    else
    {
      return(TRUE);
    }
    #endif
  }
  return(TRUE);
}


#define   DATE_TIME_TEMP_REFRESH_COUNT_MAX  6
void UpdateScreen()
{
  register unsigned char i;
  static unsigned char DateTimeTempRefreshCount = 0;
  
/*  do
  {
    i = SelectStage();
  } while(i == FALSE);
  */
  if(!SelectStage())
    return;
  
  if(!StageSettings.StageEffectDone)
  {
    //Timing: Page Effect
    if( TickCount - StageSettings.EffectLastTickCount < (unsigned long)((float)CurrentStage.EffectSpeed * CONTENT_SPEED_MULTIPLIER) )
        //&& StageSettings.EntranceAnimDone[AreaIndex])  //No Entrance Animation is applied to a stage
    {
      return;
    }
    ////////
    
    StageSettings.StageEffectDone = ApplyStageEffect(CurrentStage.EntranceEffectID);
    StageSettings.EffectLastTickCount = TickCount;
    if(StageSettings.StageEffectDone)
    {
      #ifdef  _AREA_BORDERS_ACTIVE_
      DrawBorders();  //Page effects change the contents of all the display screen, so redraw areas' borders if available
      #endif
      
      reset_CurrentStageElapsedTime();
      reset_AllAreasElapsedTime();
    }
    return;
  }
  //reset_AllAreasElapsedTime() is called in the ChangeStage() function, so even if StageSettings.StageEffectDone is set to TRUE in the ChangeStage() function, no time is elapsed for stage effect and so no problem occurs in timing
  
  //Clear the Screen
  //ClearScreen();  --> Makes problems in refresh
  
  //Timing: Reset TickCount if reaching to top value
  if(TickCount > (4294967295 - 500))
  {
    TickCount = 0;
    StageSettings.ForceUpdate = TRUE;
  }
  
  //Iterate through display areas
  DateTimeTempRefreshCount++;
  if(DateTimeTempRefreshCount > DATE_TIME_TEMP_REFRESH_COUNT_MAX)
    DateTimeTempRefreshCount = 0;
  for(i = 0; i < 4; i++)
  {
    #ifndef   _STAGE_LAYOUT_ACTIVE_
      if(i > 0)
      {
        StageSettings.AreasDone[i] = TRUE;
        continue;
      }
      else
      {
        //Only 1 area in the size of the display is allowed
        if(CurrentStage.Areas[i].x1 != 0 ||
           CurrentStage.Areas[i].y1 != 0 ||
           CurrentStage.Areas[i].x2 != (COL_COUNT - 1) ||
           CurrentStage.Areas[i].y2 != (ROW_COUNT - 1) )
        {
          StageSettings.AreasDone[i] = TRUE;
          continue;
        }
      }
    #endif
    
    if(CurrentStageElapsedTime() < CurrentStage.Areas[i].DelayTime)  //Timing
      reset_AreaElapsedTime(i);
    else //if(CurrentStageElapsedTime() >= CurrentStage.Areas[i].DelayTime)
    {
      switch(CurrentStage.Areas[i].ContentType)
      {
        #ifdef  _TIME_ACTIVE_
        case 1:  //Time
          //if(update == 1)
          if(DateTimeTempRefreshCount == 0)
            LEDTime(i, CurrentStage.Areas[i], i);
          break;
        #endif
        #ifdef  _DATE_ACTIVE_
        case 2:  //Date
          //if(update == 1)
          if(DateTimeTempRefreshCount == 0)
            LEDDate(i, CurrentStage.Areas[i], i);
          break;
        #endif
        #ifdef  _SCROLLING_TEXT_ACTIVE_
        case 3: //Single-Line Scrolling Text
          //if(update == 1)
            LEDSingleLineScrollingText(i, CurrentStage.Areas[i], i);
          break;
        #endif
        #ifdef  _ANIMATION_ACTIVE_
        case 4:  //Framed Animation
          //if(update == 1)
            LEDFramedAnimation(i, CurrentStage.Areas[i], i);
          break;
        #endif
        case 5:  //Font Text
          break;
        #ifdef  _TEMPERATURE_ACTIVE_
        case 6:  //Temperature
          //if(update == 1)
          if(DateTimeTempRefreshCount == 0)
            LEDTemperature(i, CurrentStage.Areas[i], i);
          break;
        #endif
        case 7:  //Empty
          //if(update == 1)
            LEDEmpty(i, CurrentStage.Areas[i], i);
          break;
        default:
          ;
      }
    }
  }  //for
  
  StageSettings.ForceUpdate = FALSE;
}

void DisableUnusedRowLatches()
{
  #asm("cli")
  PORTB = ROWS_NOT;
  if(ROW_COUNT <= 24)
  {
    PORTD.6 = 1;
    PORTD.6 = 0;
  }
  if(ROW_COUNT <= 16)
  {
    PORTD.5 = 1;
    PORTD.5 = 0;
  }
  if(ROW_COUNT <= 8)
  {
    PORTD.4 = 1;
    PORTD.4 = 0;
  }
  if(ROW_COUNT == 0)
  {
    PORTD.3 = 1;
    PORTD.3 = 0;
  }
  #asm("sei")
}

void display_init()
{
  TGlobalSettings gs;
  
  get_global_settings(&gs);
  ROW_COUNT = gs.RowCount;
  COL_COUNT = gs.ColCount;
  StageCount = gs.StageCount;
  
  //Stages = (TDisplayStage flash*) (DISPLAY_DATA + sizeof(TGlobalSettings));
  ChangeStage(0, TRUE);  //First Run
  
  DisableUnusedRowLatches();
}

void PrepareForNewData()
{
  display_init();
  TickCount = 0;
}

bit ScreenCleared = 0;
void ShowInvalidDataMessage()
{
  ROW_COUNT = MAX_ROW_COUNT;
  COL_COUNT = MAX_COL_COUNT;
  FILTER_OFF = 0xFF;
  
  if(!ScreenCleared)
  {
    ClearScreen(TRUE);
    ScreenCleared = 1;
  }
  
  LEDPutCharE(0, 0, ROW_COUNT - 1, InvalidDataErrorMsg, 0, 8, MAX_COL_COUNT);
  //ClearScreen(TRUE);
}

void ValidateData()
{
  TGlobalSettings gs;
  
  get_global_settings(&gs);
  if(gs.RowCount > MAX_ROW_COUNT || gs.ColCount > MAX_COL_COUNT ||
     gs.RowCount == 0 || gs.ColCount == 0 || (gs.ColCount % 8) != 0 ||
     gs.StageCount == 0)
  {
    DataIsValid = 0;
    //DATA_VALIDATION_ERR_COUNT++;
  }
  else
    DataIsValid = 1;
}

#ifdef  _COLOR_DISPLAY_
TColor GetCellColor(unsigned char Row, unsigned char Col)
{
  unsigned char i;
  
  /* FOR TEST (TOP ROW GREEN AND BOTTOM ROW RED)
  if(Row < 8)
    return(COLOR_GREEN);
  else
    return(COLOR_RED);
  */
  for(i = 0; i < 4; i++)
  {
    if(Row >= CurrentStage.Areas[i].y1 && Row <= CurrentStage.Areas[i].y2)
    {
      if(Col >= CurrentStage.Areas[i].x1 && Col <= CurrentStage.Areas[i].x2)
      {
        return(CurrentStage.Areas[i].Color);
      }
    }
  }
  return(COLOR_RED);  //Defaul color is red
}
#endif

#ifdef  _COLOR_DISPLAY_
void update_color_arrays()
{
  unsigned char Row, Col, FilterCol, bit_count;
  unsigned char c_Red, c_Green;
  TColor Color;
  
  for(Row = 0; Row < ROW_COUNT; Row++)
  {
    c_Red = 0x00;
    c_Green = 0x00;
    bit_count = 0;
    FilterCol = 0;
    
    /* FOR TEST (TOP ROW GREEN AND BOTTOM ROW RED)
    for(FilterCol = 0; FilterCol < 8; FilterCol++)
    {
      GreenFilter[Row][FilterCol] = 0x00;
      RedFilter[Row][FilterCol] = 0x00;
      if(Row < 8)    
        GreenFilter[Row][FilterCol] = 0xff;
      else
        RedFilter[Row][FilterCol] = 0xff
    }
    continue;
    */

    for(Col = 0; Col < COL_COUNT; Col++)
    {
      c_Red <<= 1;
      c_Green <<= 1;
      
      Color = GetCellColor(Row, Col);
      switch(Color)
      {
        case COLOR_RED:
          c_Red |= 0x01;
          break;
        case COLOR_GREEN:
          c_Green |= 0x01;
          break;
        case COLOR_RED_AND_GREEN:
          c_Red |= 0x01;
          c_Green |= 0x01;
          break;
      }
      bit_count++;
      
      if(bit_count == 8)
      {
        RedFilter[Row][FilterCol] = c_Red;
        GreenFilter[Row][FilterCol] = c_Green;
        
        FilterCol++;
        bit_count = 0;
        c_Red = 0x00;
        c_Green = 0x00;
      }
    }
  }
}
#endif

#ifdef  _COLOR_DISPLAY_
void FillAreaColorXY(unsigned char x1, unsigned char y1, unsigned char x2, unsigned char y2, unsigned char color)
{
  unsigned char row, col;
  unsigned char green_val, red_val;
  unsigned char XL, XR;
  unsigned char c1, c2;
  
  if(x1 > x2 || y1 > y2 || y2 > SCREEN_FILTER_ARRAY_BOUND)
    return;
  
  for(row = y1; row < y2; row++)
  {
    for(col = 0; col < (MAX_COL_COUNT_FOR_ARRAY - 1) / 8; col++)
    {
      XL = col * 8;
      XR = XL + 7;
      if((x1 < XL && x2 < XL) || (x1 > XR && x2 > XR))
        continue;
      
      red_val = RedFilter[row][col];
      green_val = GreenFilter[row][col];
      
      c1 = 0xff;
      c2 = 0xff;
      if(x1 > XL && x1 <= XR)
        c1 >>= (x1 - XL);
      if(x2 < XR && x2 >= XL)
        c2 <<= (XR - x2);
      c1 = c1 & c2;
      c2 = ~c1;
      
      red_val &= c2;
      green_val &= c2;
      
      switch(color)
      {
        case COLOR_RED:
          red_val |= c1;
          break;
        case COLOR_GREEN:
          green_val |= c1;
          break;
        case COLOR_RED_AND_GREEN:
          red_val |= c1;
          green_val |= c1;
          break;
        case COLOR_NONE:
          //Nothing to do - the area already is cleared
          break;
      }
      RedFilter[row][col] = red_val;
      GreenFilter[row][col] = green_val;
    }
  }
}
#endif

#ifdef  _AREA_BORDERS_ACTIVE_
void DrawAreaBorders(TArea *Area, BOOL ClearAllBorders)
{
  unsigned char bwh, bwv, bf;
  unsigned char x1, y1, x2, y2;
  unsigned char y1_f, y2_f;
  unsigned char color;
  BOOL LB, RB, TB, BB;
  BOOL LBf, RBf, TBf, BBf;
  
  if(Area->ContentType != 0)  //Only if not an unused area
  {
    bwh = Area->BordersWidthH;
    bwv = Area->BordersWidthV;
    bf = Area->BordersFilled;
    x1 = Area->x1;
    y1 = Area->y1;
    x2 = Area->x2;
    y2 = Area->y2;
    color = Area->Color;
    
    LB = (bf & (1 << 0)) != 0;
    RB = (bf & (1 << 1)) != 0;
    TB = (bf & (1 << 2)) != 0;
    BB = (bf & (1 << 3)) != 0;
    
    LBf = (bf & (1 << 4)) != 0;
    RBf = (bf & (1 << 5)) != 0;
    TBf = (bf & (1 << 6)) != 0;
    BBf = (bf & (1 << 7)) != 0;
    
    if(bwh > 0)
    {
      y1_f = y1;
      y2_f = y2;
      if(bwv > 0)  //Has any vertical borders?
      {
        if(TB && y1 >= bwh)  //Has top border?
          y1_f = y1 - bwv;
        if(BB)  //Has bottom border?
          y2_f = y2 + bwv;
      }
      //--------------------------------------
      //Check Left Border (bit 0)
      if(LB && x1 >= bwh)
      {
        if(LBf && !ClearAllBorders)
        {
          FillAreaXY(x1 - bwh, y1_f, x1 - 1, y2_f);
          #ifdef  _COLOR_DISPLAY_
          FillAreaColorXY(x1 - bwh, y1_f, x1 - 1, y2_f, color);
          #endif
        }
        else
        {
          ClearAreaXY(x1 - bwh, y1_f, x1 - 1, y2_f);
          #ifdef  _COLOR_DISPLAY_
          FillAreaColorXY(x1 - bwh, y1_f, x1 - 1, y2_f, COLOR_NONE);
          #endif
        }
      }
      //--------------------------------------
      
      //--------------------------------------
      //Check Right Border (bit 1)
      if(RB)
      {
        if(RBf && !ClearAllBorders)
        {
          FillAreaXY(x2 + 1, y1_f, x2 + bwh, y2_f);
          #ifdef  _COLOR_DISPLAY_
          FillAreaColorXY(x2 + 1, y1_f, x2 + bwh, y2_f, color);
          #endif
        }
        else
        {
          ClearAreaXY(x2 + 1, y1_f, x2 + bwh, y2_f);
          #ifdef  _COLOR_DISPLAY_
          FillAreaColorXY(x2 + 1, y1_f, x2 + bwh, y2_f, COLOR_NONE);
          #endif
        }
      }
      //--------------------------------------
    }
    
    if(bwv > 0)
    {
      //--------------------------------------
      //Check Top Border (bit 2)
      if(TB && y1 >= bwv)
      {
        if(TBf && !ClearAllBorders)
        {
          FillAreaXY(x1, y1 - bwv, x2, y1 - 1);
          #ifdef  _COLOR_DISPLAY_
          FillAreaColorXY(x1, y1 - bwv, x2, y1 - 1, color);
          #endif
        }
        else
        {
          ClearAreaXY(x1, y1 - bwv, x2, y1 - 1);
          #ifdef  _COLOR_DISPLAY_
          FillAreaColorXY(x1, y1 - bwv, x2, y1 - 1, COLOR_NONE);
          #endif
        }
      }
      //--------------------------------------
      
      //--------------------------------------
      //Check Bottom Border (bit 3)
      if(BB)
      {
        if(BBf && !ClearAllBorders)
        {
          FillAreaXY(x1, y2 + 1, x2, y2 + bwv);
          #ifdef  _COLOR_DISPLAY_
          FillAreaColorXY(x1, y2 + 1, x2, y2 + bwv, color);
          #endif
        }
        else
        {
          ClearAreaXY(x1, y2 + 1, x2, y2 + bwv);
        }
          #ifdef  _COLOR_DISPLAY_
          FillAreaColorXY(x1, y2 + 1, x2, y2 + bwv, COLOR_NONE);
          #endif
      }
      //--------------------------------------
    }
  }  //end of main if statement
}

void DrawBorders()
{
  unsigned char i;
  
  //Iterate through areas
  for(i = 0; i < 4; i++)
    DrawAreaBorders(&CurrentStage.Areas[i], FALSE);
}
#endif
