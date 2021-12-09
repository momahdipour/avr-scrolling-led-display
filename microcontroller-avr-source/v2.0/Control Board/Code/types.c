
#define TRUE (1==1)
#define FALSE (1==0)
typedef char BOOL;

#define ON  TRUE
#define OFF FALSE

typedef unsigned char TColor;
#define COLOR_RED             0
#define COLOR_GREEN           1
#define COLOR_RED_AND_GREEN   2
#define COLOR_NONE            4

typedef struct
{
  unsigned char RowCount;
  unsigned char ColCount;
  unsigned char StageCount;
} TGlobalSettings;

//Area Content Type description:
//0 = Unused Area
//1 = Time
//2 = Date
//3 = Single-Line Scrolling Text
//4 = Framed Animation
//5 = Font Text
//6 = Temperature
//7 = Empty (Blank)
typedef struct
{
  unsigned char x1, y1, x2, y2;
  unsigned char ContentType;
  unsigned char DelayTime;  //in seconds - not dependent to TotalDisplayTime
  unsigned int DataSize;  //in bytes
  //New settings added:
  unsigned char ContinuesToNextStage;  //0 = No, 1 = Yes
  unsigned char AdvanceStageWhenDone;
  unsigned char ForceAdvanceStageWhenDone;  //When this area is done, go to next stage regardless of current state of other areas only if no one has the CompleteBeforeNextStage property set to Yes.
  unsigned char CompleteBeforeNextStage;  //0 = Not required, 1 = Yes (Must be completed)
  unsigned char RepeatAfterDone;  //Repeat this area until all other ares are done.  -- IN THIS VERSION only is applied to Time and Date and Temperature areas.
  
  unsigned char EntranceAnimID;
  unsigned char MiddleAnimID;
  unsigned char ExitAnimID;

  unsigned char AnimSpeed;  //0 = Very Fast, 255 = Very Slow
  
  unsigned char Color;  //0 = Red, 1 = Green
  
  unsigned char BordersFilled;  //bits0..3: Left Border, Right Border, Top Border, Bottom Border
                                //bits4..7: LB Filled  , RB Filled   , TB Filled , BB Filled
  unsigned char BordersWidthH;  //Can also be 0
  unsigned char BordersWidthV;  //Can also be 0
  
  unsigned int dummy1;  //set to 0 for compatibility with future version
  unsigned int dummy2;  //set to 0 for compatibility with future version
} TArea;

//TAreaPositionData is used to minimize data stack usage in the ChangeStage routine
typedef struct
{
  unsigned char x1, y1, x2, y2;
  unsigned char ContentType;
} TAreaPositionData;

typedef struct
{
  unsigned char TotalDisplayTime;  //in seconds
  unsigned char RepeatitionTimes;
  unsigned int DataOffset;  //***--> Can be omitted without any change in data (also must be omitted from data) <--***//
  unsigned char EntranceEffectID;
  unsigned char ExitEffectID;
  unsigned char EffectSpeed;  //0 = Very Fast, 255 = Very Slow
  unsigned char HourFrom, MinuteFrom;
  unsigned char HourTo, MinuteTo;
  unsigned int Year;  //if 0, date is disabled in timespan  //1 byte may be used as StageID  --  set to 0 for compatibility with future version
  unsigned char Month;
  unsigned char Day;
  TArea Areas[4];
} TDisplayStage;

typedef struct
{
  unsigned char lang;  //0 = Farsi, 1 = English
  unsigned char format;  //0 = hh:mm:ss, 1 = hh:mm
  unsigned char type;  //0 = 24-Hour, 1 = 12-Hour
  unsigned int TotalDisplayTime;
  unsigned char CenterHorizontally;
  unsigned char CenterVertically;
  unsigned char BlinkDots;  //1 = Yes, 0 = No  --  In hh:mm mode, minute dots will blink and in hh:mm:ss mode, second dots will blink.
} TTimeData;

typedef struct
{
  unsigned char lang;  //(Digits lang) 0 = Farsi, 1 = English
  unsigned char format;  //0 = 1387/01/01, 1 = 87/01/01, 2 = 1387-01-01, 3 = 87-01-01, 4 = Separately display (month and day, year) with '/', 5 = same as 4 with '-'
  unsigned char type;  //0 = Solar, 1 = Gregorian
  unsigned int TotalDisplayTime;
  unsigned char CenterHorizontally;
  unsigned char CenterVertically;
} TDateData;

typedef struct
{
  unsigned char FixedText;  //0 = No, 1 = Yes - (Is this a scrolling text or a fixed text?)
  unsigned char Direction;  //0 = Right, 1 = Left, 2 = Up, 3 = Down
  unsigned char ScrollType;  //0 = Text scrolls into the display area (normal), 1 = Text is displayed first
  
  //Very Fast (0-51), Fast (52-103), Medium (104-155), Slow (156-207), Very Slow (208-255)
  //Also see the ScrollStep field
  unsigned char Speed;
  
  unsigned int ColCount;
  unsigned char BytesPerCol;
  unsigned char Invert;  //0 = No, 1 = Yes
  unsigned char RepetitionTimes;  //This value is ignored if zero
  unsigned int TotalDisplayTime;  //If not zero, the text is displayed until the specified time is elapsed.
  /*Notes:
    1. The RepetitionTimes in independent from RepetitionTimes of TDisplayStage.
    2. RepetitionsTimes has more priority than TotalDisplayTime. So, when TotalDisplayTime is not zero,
       you should set RepetitionTimes to zero to enable TotalDisplayTime.
  */

  unsigned char ScrollStep;  //depends on the text scroll speed and is set by LDC program automatically  --> THIS FIELD IS REMOVED IN UPDATES AND IS NOT USED ANYMORE AND ALWAYS IS ASSUMED TO BE 1 EVEN IF ANY VALUE IS STORED IN THIS FIELD
  
  //unsigned char Data[1];
  
} TSingleLineScrollingText;

typedef struct
{
  unsigned char Speed;
  unsigned char BytesPerCol;
  unsigned char FrameColCount;
  unsigned int FrameCount;
  unsigned char RepetitionTimes;  //This value is ignored if zero
  unsigned int TotalDisplayTime;  //If not zero, the animatin is played until the specified time is elapsed.
  /*Notes:
    1. The RepetitionTimes in independent from RepetitionTimes of TDisplayStage.
    2. RepetitionsTimes has more priority than TotalDisplayTime. So, when TotalDisplayTime is not zero,
       you should set RepetitionTimes to zero to enable TotalDisplayTime.
  */
  unsigned char Invert;  //0 = No, 1 = Yes
  unsigned char CenterHorizontally;  //0 = No, 1 = Yes
  unsigned char CenterVertically;  //0 = No, 1 = Yes  --> Cannot apply this option inside microcontroller, do it in the designer program
  
  unsigned char UseGIFTimings;  //0 = No, 1 = Yes

  //unsigned char Data[1];
} TFramedAnimation;

typedef struct
{
  unsigned char Direction;  //0 = Right, 1 = Left, 2 = Up, 3 = Down
  unsigned char ScrollType;  //0 = Text scrolls into the display area (normal), 1 = Text is displayed first
  unsigned char Speed;  //0 = Very Fast, 255 = Very Slow
  unsigned int CharCount;
  unsigned char CharacterSource;  //0 = Internal Font
                                  //1 = External Font (stored in EEPROM) (Reserved - Not used in this version)
                                  //2 = External Character Table (Stored in EEPROM)
  
  //unsigned char Data[1];
} TFontText;

typedef struct
{
  unsigned char lang;  //0 = Farsi, 1 = English
  unsigned char unit;  //0 = Centigrade, 1 = Fahrenheit
  unsigned int TotalDisplayTime;
  unsigned char CenterHorizontally;
  unsigned char CenterVertically;
} TTemperature;

typedef struct
{
  unsigned char Filled;  //1 = Yes, 0 = No
  unsigned int TotalDisplayTime;
} TEmpty;

typedef union {
  TTimeData TimeData;
  TDateData DateData;
  TTemperature TempData;
} TContentsData;

typedef struct {
  unsigned int StartCol;  //Starting from 0
  BOOL NormalScroll;
} TStageSettings1;

typedef struct {
  int Delay;  //in milliseconds - a value of -1 means that the frame is not loaded yet
  unsigned int CurrentFrame;
  BOOL FirstFrameLoaded;
} TStageSettings2;

#define   NormalTimingStyle     0
#define   OnlyTextTimingStyle   1

typedef struct {
  //Single-Line Scrolling Text
  BOOL AreasDone[4];
  BOOL EntranceAnimDone[4];
  BOOL AnimInitialized[4];
  unsigned char AreaRepeatCount[4];
  BOOL StageEffectDone;
  TStageSettings1 SLST[4];  //SingleLineScrollingTexts
  TStageSettings2 FA[4];  //FramedAnimations
  unsigned char Num1[4];  //Can be used for any purpose depending on the content of the area
  unsigned char Num2[4];  //Can be used for any purpose depending on the content of the area
  unsigned char Num3[4];  //Can be used for any purpose depending on the content of the area
  //Timing
  BOOL ForceUpdate;
//  unsigned char DelayTickCount[4];  --> Used to delay before starting an area -- NOT IMPLEMENTED YET
  unsigned long LastTickCount[4];
  unsigned long EffectLastTickCount;

  unsigned char RepeatedTimes;
  BOOL TimeSpanDefined;
  unsigned char AreaCount;
  //unsigned char PlayDelay[4];
  unsigned char TimingStyle;
  BOOL CompatibleWithTextTimingStyle;
  BOOL ScreenFilledAtStart[4];  //This field is currently used in scrolling text only
} TStageSettings;

typedef struct {
  unsigned char h, m, s;
} TTime;
