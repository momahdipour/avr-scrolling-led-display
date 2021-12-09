
//Select product////////
//#define   _NORMAL_MODEL_
//#define   _FULL_BRIGHT_
////////////////////////

#define   _INTERNAL_EEPROM_   0
#define   _EXTERNAL_EEPROM_   1

//===================================================================================
//===================================================================================
//FINAL CONFIGURATIONS FOR SALE
#define   LED_DISPLAY_MAX_ROW_COUNT     32   //Can be any value between 4 and 32
#define   LED_DISPLAY_MAX_COL_COUNT     96  //Must be a multiple of 8
#define     _ROWS_24_
#define     _ROWS_32_
//#define     _COLOR_DISPLAY_METHOD_1_  //column based
//#define     _COLOR_DISPLAY_METHOD_2_  //row-based
#define     _FULL_LATCH_  //This must only be activated in single-color mode
//#define   _STRICT_LOCK_ACTIVE_

////////////////////////////
//Memory cache configuration

#ifdef  _COLOR_DISPLAY_METHOD_1_
  #ifndef _COLOR_DISPLAY_
    #define _COLOR_DISPLAY_
  #endif
#endif
#ifdef  _COLOR_DISPLAY_METHOD_2_
  #ifndef _COLOR_DISPLAY_
    #define _COLOR_DISPLAY_
  #endif
#endif

#if LED_DISPLAY_MAX_ROW_COUNT == 8
  #ifdef _CHIP_ATMEGA128_
    #error ERROR: To use Mega128 you must define at least 16 rows for the LEd Display.
  #else
    #error ERROR: Cache settings currently are not defined for 8 rows on Mega32. Define them now (and test the newly defined settings) or use another settings!
  #endif
#elif LED_DISPLAY_MAX_ROW_COUNT == 16
  #ifdef _CHIP_ATMEGA128_
    #ifdef _COLOR_DISPLAY_
      #define   CACHE_COUNT   69
      #define   CACHE_SIZE    30
    #else
      #define   CACHE_COUNT   72
      #define   CACHE_SIZE    30
    #endif
  #else
    #if LED_DISPLAY_MAX_COL_COUNT <= 80
      #define   CACHE_COUNT   24
      #define   CACHE_SIZE    22
    #else
      #define   CACHE_COUNT   18
      #define   CACHE_SIZE    20
    #endif
  #endif
#elif LED_DISPLAY_MAX_ROW_COUNT == 24
  #ifdef _CHIP_ATMEGA128_
    #define   CACHE_COUNT   61
    #define   CACHE_SIZE    32
  #else
    #if LED_DISPLAY_MAX_COL_COUNT <= 80
      #define   CACHE_COUNT   19
      #define   CACHE_SIZE    20
    #elif LED_DISPLAY_MAX_COL_COUNT <= 96
      #define   CACHE_COUNT   15
      #define   CACHE_SIZE    20
    #else
      #define   CACHE_COUNT   8
      #define   CACHE_SIZE    18
    #endif
  #endif
#elif LED_DISPLAY_MAX_ROW_COUNT == 32
  #ifdef _CHIP_ATMEGA128_
    #if LED_DISPLAY_MAX_COL_COUNT <= 80
      #define   CACHE_COUNT   69
      #define   CACHE_SIZE    30
    #else
      #define   CACHE_COUNT   57
      #define   CACHE_SIZE    30
    #endif
  #else
    #if LED_DISPLAY_MAX_COL_COUNT <= 64
      #define   CACHE_COUNT   19
      #define   CACHE_SIZE    18
    #elif LED_DISPLAY_MAX_COL_COUNT <= 96
      #define   CACHE_COUNT   7
      #define   CACHE_SIZE    18
    #else
      //out of memory error here
      #define   CACHE_COUNT   1
      #define   CACHE_SIZE    35
    #endif
  #endif
#endif

//32x128 Mega128 Single Color
//#define   CACHE_COUNT   3
//#define   CACHE_SIZE    45

//32x128 Mega128 Single Color
//#define   CACHE_COUNT   60
//#define   CACHE_SIZE    30

//32x128 Mega128 with _COLOR_DISPLAY_METHOD_1_ (80 columns)
//#define   CACHE_COUNT   40
//#define   CACHE_SIZE    40

//#define   CACHE_COUNT   17
//#define   CACHE_SIZE    145
////////////////////////////

/////////////////////////////
//////  ALARM SETTINGS //////
//#define     _ALARM_ACTIVE_

#define     MAX_ALARM_COUNT_PER_MONTH     31  //--> max 254 (an unsigned char value - 1)

//#define     _ALARM_TYPE_ONLY_1_MONTH
#define     _ALARM_TYPE_12_MONTHS  //365 days
/////////////////////////////

#define     _AREA_BORDERS_ACTIVE_
#ifdef  _CHIP_ATMEGA128_  //Trial capabilities is available only on Mega128
  #define     _TRIAL_LIMIT_ACTIVE_
#endif


#define   _NO_FEATURES_1_     0
#define   _NO_FEATURES_2_     0
#define   _NO_FEATURES_3_     0

#ifdef  _CHIP_ATMEGA32_
  //#define   _NO_FEATURES_1_     1
  //#define   _NO_FEATURES_2_     1
  #define   _NO_FEATURES_3_     1
#endif

#if  (_NO_FEATURES_1_ == 1 && _NO_FEATURES_2_ == 1) || (_NO_FEATURES_1_ == 1 && _NO_FEATURES_3_ == 1) || (_NO_FEATURES_2_ == 1 && _NO_FEATURES_3_ == 1)
  #error ERROR: Only one _NO_FEATURES_ directive can be used at the same time
#endif

#ifndef _CHIP_ATMEGA32_
  #if  _NO_FEATURES_1_ == 1 || _NO_FEATURES_2_ == 1 || _NO_FEATURES_3_ == 1
    #error ERROR: Only on Mega32 features can be deactivated
  #endif
#endif

#define     _DATE_TIME_ADJUST_BUTTONS_ACTIVE
#define     _TIME_SPAN_ACTIVE_
#define     _TEMPERATURE_ACTIVE_
#define     _ANIMATION_ACTIVE_
#define     _SCROLLING_TEXT_ACTIVE_
#define     _TIME_ACTIVE_
#define     _DATE_ACTIVE_
#define     _TEXT_ANIMATIONS_ACTIVE_
#define     _PAGE_EFFECTS_ACTIVE_
#define     _STAGE_LAYOUT_ACTIVE_
//animations:
#define _ANIM_1_ACTIVE_
#define _ANIM_2_ACTIVE_
#define _ANIM_4_ACTIVE_
#define _ANIM_5_ACTIVE_
#define _ANIM_7_ACTIVE_
#define _ANIM_8_ACTIVE_
#define _ANIM_9_ACTIVE_
#define _ANIM_10_ACTIVE_
#define _ANIM_12_ACTIVE_


#if  _NO_FEATURES_1_ == 1
/*Description:
includes date-time adjust buttons and time-span and temperature, but excludes effects
*/
  #undef _ANIM_1_ACTIVE_
  #undef _ANIM_2_ACTIVE_
  #undef _ANIM_4_ACTIVE_
  #undef _ANIM_5_ACTIVE_
  #undef _ANIM_7_ACTIVE_
  #undef _ANIM_8_ACTIVE_
  #undef _ANIM_9_ACTIVE_
  #undef _ANIM_10_ACTIVE_
  #undef _ANIM_12_ACTIVE_
#endif

#if  _NO_FEATURES_2_ == 1
/*Description:
includes date-time adjust buttons and effects and temperature, but excludes temperature capabilities
*/
  #undef  _TEMPERATURE_ACTIVE_
#endif

#if  _NO_FEATURES_3_ == 1
/*Description:
includes time-span and effects and temperature, but excludes date-time adjust buttons
*/
  #undef  _DATE_TIME_ADJUST_BUTTONS_ACTIVE
#endif

#ifdef  _CHIP_ATMEGA32_
  #ifdef _COLOR_DISPLAY_
    #undef     _DATE_TIME_ADJUST_BUTTONS_ACTIVE
  #endif
#endif


//#define     _THIS_IS_PORTABLE_MEMORY_  --> Only should be defined for the portable memory program - this is used in the function usart_cmd_GetConfiguration.

//#define     MAX_FONT_DATA_SIZE    110  --> NOT USED IN THIS VERSION

/////////////////////////////////////////////////////////////////////
//TRIAL PASSWORD
#ifdef  _CHIP_ATMEGA128_
  #define   TrialPassword   0xABCDEF00  //unsigned long value (32 bits) - 0x00000000 means no password
#else
  #define   TrialPassword   0x00000000  //unsigned long value (32 bits) - 0x00000000 means no password
#endif
/////////////////////////////////////////////////////////////////////

//////////////////////////////////////
//////////////////////////////////////
//////  ALARM ADVANCED SETTINGS //////
//DO NOT CHANGE THESE SETTINGS UNLESS YOU KNOW EXACTLY WHAT YOU ARE DOING

//Don't check this only when _ALARM_ACTIVE_ is defined, because I never allow to have incorrect settings in my file even when the corresponding part is not active!
#ifdef  _ALARM_TYPE_ONLY_1_MONTH
  #ifdef  _ALARM_TYPE_12_MONTHS
    #error ERROR: Only one type of the alarm system can be active at the same time: either "_ALARM_TYPE_ONLY_1_MONTH" or "_ALARM_TYPE_12_MONTHS".
  #endif
#endif

#ifdef  _ALARM_ACTIVE_
  //Select internal or external memory to store alarm data
  #ifdef  _ALARM_TYPE_ONLY_1_MONTH
    #define     _ALARM_STORAGE_SELECT_        _INTERNAL_EEPROM_  //_INTERNAL_EEPROM_ = Internal EEPROM, _EXTERNAL_EEPROM_ = External EEPROM
  #else
    #ifdef  _ALARM_TYPE_12_MONTHS
      #define     _ALARM_STORAGE_SELECT_        _EXTERNAL_EEPROM_  //_INTERNAL_EEPROM_ = Internal EEPROM, _EXTERNAL_EEPROM_ = External EEPROM
    #endif
  #endif

  //Alarm system type select
  #ifdef  _ALARM_TYPE_ONLY_1_MONTH
    #define   _1_MONTH_ALARM_SYSTEM_
  #else
    #ifdef  _ALARM_TYPE_12_MONTHS
      #define   _12_MONTH_ALARM_SYSTEM_
    #endif
  #endif
#endif
//////////////////////////////////////
//////////////////////////////////////

#ifndef _TRIAL_LIMIT_ACTIVE_
  #if TrialPassword != 0x00000000
    #error ERROR: If the trial limit is not active, why you have set a value for "TrialPassword".
  #endif
#endif

#ifdef  _TRIAL_LIMIT_ACTIVE_
  #if TrialPassword == 0x00000000
    #error ERROR: You have activated trial limit, but you have not defined a password for it using "TrialPassword".
  #endif
#endif

#ifdef  _ALARM_ACTIVE_
  #ifndef _TIME_ACTIVE_
    #ifndef _DATE_ACTIVE_
      #warning IMPORTANT ATTENTION: You have activated alarms, but time and date are inactive. Be sure to add DS1307 to your circuit.
    #endif
  #endif
#endif

#ifdef  _TIME_ACTIVE_
  #ifndef _DATE_ACTIVE_
    #warning ATTENTION: Time is active, but date is inactive. Both of time and date can exist without any problems.
  #endif
#endif

#ifdef  _DATE_ACTIVE_
  #ifndef _TIME_ACTIVE_
    #warning ATTENTION: Date is active, but time is inactive. Both of date and time can exist without any problems.
  #endif
#endif
//===================================================================================
//===================================================================================

#ifdef  _COLOR_DISPLAY_METHOD_1_
  #ifdef  _COLOR_DISPLAY_METHOD_2_
    #error  ERROR: Only one of the color display refresh methods can be active at the same time.
  #endif
#endif

#ifdef  _COLOR_DISPLAY_METHOD_2_
  #if LED_DISPLAY_MAX_ROW_COUNT > 16
    #error ERROR: In Color Display Method 2 only a maximum of 16 rows can be used in the circuit. Set "LED_DISPLAY_MAX_ROW_COUNT" to a maximum value of 16.
  #endif
#endif

//***********************************************************
//***********************************************************
//Configuration Parameters for Conditional Compiling

//*MICROCONTROLLER SELECTION
//Only change the microcontroller in the compiler options page and all is done.
//**************************


#ifdef  _ROWS_32_
  #ifndef   _ROWS_24_
    #define   _ROWS_24_
  #endif
#endif


/*
#ifdef  _CHIP_ATMEGA32_
  #ifdef  _TEMPERATURE_ACTIVE_
    #ifdef  _COLOR_DISPLAY_
      #undef  _TEMPERATURE_ACTIVE_  //Because the program does not fit in the flash
    #endif
  #endif
#endif
*/



#ifdef  _ROWS_24_
  #ifdef  _ROWS_32_
    #if LED_DISPLAY_MAX_ROW_COUNT < 32
      #error LDC ERROR: set "LED_DISPLAY_MAX_ROW_COUNT" to 32 because "_ROWS_32_" is defined.
    #endif
  #elif LED_DISPLAY_MAX_ROW_COUNT < 24
    #error LDC ERROR: set "LED_DISPLAY_MAX_ROW_COUNT" to 24 becuase "_ROWS_24_" is defined.
  #endif
#endif

#ifndef _ROWS_24_
  #if LED_DISPLAY_MAX_ROW_COUNT > 16
    #error LDC ERROR: You have disabled "_ROWS_24_" but "LED_DISPLAY_MAX_ROW_COUNT" is greater than 16;
  #endif
#endif
#ifndef _ROWS_32_
  #if LED_DISPLAY_MAX_ROW_COUNT > 24
    #error LDC ERROR: You have disabled "_ROWS_32_" but "LED_DISPLAY_MAX_ROW_COUNT" is greater than 24.
  #endif
#endif

#ifdef  _CHIP_ATMEGA128_
  //Optimize for maximum execution speed
  #pragma optsize-
#else
  //Optimize for minimum size
  #pragma optsize+
#endif

#ifdef  _CHIP_ATMEGA32_
  #warning IMPORTANT ATTENTION: The maximum size of the program must be less than or equal to 15360 words. [FOR BOOTLOADER]
#endif

#ifndef _DATE_TIME_ADJUST_BUTTONS_ACTIVE
  #warning ATTENTION: Date/Time adjusting buttons are disabled.
#endif

#define MAX_LATCH_COUNT LED_DISPLAY_MAX_COL_COUNT / 8

/* ***** ** *** ****** **** ****** *** **** ***** ** ** * ***** **** ** * ******** ** **** ***** */
/* ***** If you change this value, you must round it to a value that is a multiple of 128. ***** */
#define   _INTERNAL_FONTS_MEMORY_SIZE_    4096UL  //in bytes -- 4KB for fonts - MUST BE A MULTIPLE OF 128 BYTES
/* ***** ** *** ****** **** ****** *** **** ***** ** ** * ***** **** ** * ******** ** **** ***** */

///////////////////////////////////////////////////////////////
// ** --> If this structure is changed, also update delphi program because it accesses data as byte by byte. **
typedef struct
{
  unsigned int Duration;  //0 means no alarm (alarm is disabled)
  unsigned char EveryDay;  //1 = Yes, Otherwise = No
  unsigned char Day;
  unsigned char Month;
  unsigned int Year;
  unsigned char Hour;
  unsigned char Minute;
  unsigned char Second;
  unsigned char AlarmFlags;  //Bit 0: 1=Disable this alarm after deactivation, 0=Do not disable this alarm
  //reserved byte - set to 0 for compatibility with future versions
  unsigned char reserved2;
} TLDCAlarm;
///////////////////////////////////////////////////////////////

/////////////////////////////
//Preproces alarm settings
#ifdef  _1_MONTH_ALARM_SYSTEM_
  #ifdef  _12_MONTH_ALARM_SYSTEM_
    #error  ALARM SETTINGS ERROR: Either "_1_MONTH_ALARM_SYSTEM_" or "_12_MONTH_ALARM_SYSTEM_" can be active at the same time.
  #endif
#endif

#ifdef  _1_MONTH_ALARM_SYSTEM_
  #define   _ALARM_MONTH_COUNT_   1
#endif
#ifdef  _12_MONTH_ALARM_SYSTEM_
  #define   _ALARM_MONTH_COUNT_   12
#endif

#ifdef  _ALARM_ACTIVE_
  #if   _ALARM_STORAGE_SELECT_ == _EXTERNAL_EEPROM_
    //--> Alarms should be saved in an address where all alarms fit below 64KB boundary of the memory because the address variables used for addressing alarm data are of type unsigned int (to reduce code size and also to speed up)
    #define _ALARMS_MEMORY_SIZE_      (16/*offset to make total a multiple of 128 bytes*/ + _ALARM_MONTH_COUNT_ * MAX_ALARM_COUNT_PER_MONTH * 12/*12=sizeof(TLDCAlarm)=12 bytes*/) //(_ALARM_MONTH_COUNT_ * MAX_ALARM_COUNT_PER_MONTH * sizeof(TLDCAlarm))  //MUST BE A MULTIPLE OF 128 BYTES
    #if (_ALARMS_MEMORY_SIZE_ % 128) > 0
      //_ALARMS_MEMORY_SIZE_  = _ALARMS_MEMORY_SIZE_ + (_ALARMS_MEMORY_SIZE_ % 128)  --> Is not supported by the compiler even in the form of a #define statement
      #error  CRITICAL ERROR: Adjust "_ALARMS_MEMORY_SIZE_" to be a multiple of 128 bytes.
    #endif
  #else
    #define _ALARMS_MEMORY_SIZE_      0
  #endif
#else
  #define _ALARMS_MEMORY_SIZE_      0
#endif
/////////////////////////////

#define   MEM_START_OFFSET                  (_INTERNAL_FONTS_MEMORY_SIZE_ + _ALARMS_MEMORY_SIZE_)

#ifdef  _ALARM_ACTIVE_
  #if (_ALARMS_MEMORY_SIZE_ == 0) && (_ALARM_STORAGE_SELECT_ == _INTERNAL_EEPROM_)
    #define   ALARM_DATA_MEM_START_OFFSET   0
  #elif (_ALARMS_MEMORY_SIZE_ > 0) && (_ALARM_STORAGE_SELECT_ == _EXTERNAL_EEPROM_)
    #define   ALARM_DATA_MEM_START_OFFSET     _INTERNAL_FONTS_MEMORY_SIZE_
  #endif
#endif
//***********************************************************
//***********************************************************

#define   NUM_OF_BYTES_TO_CLEAR_AFTER_SET_MEMORY    2048  //in bytes

#ifdef    _THIS_IS_PORTABLE_MEMORY_
  #error CRITICAL ERROR: You have defined that this program is for portable memory, but it is not true. Please undef "_THIS_IS_PORTABLE_MEMORY_" and compile again.
#endif

#ifdef  _CHIP_ATMEGA32_
  #define _INTERNAL_EEPROM_SIZE_      (1 * 1024)  //1KB for Mega32
#else
  #ifdef  _CHIP_ATMEGA64_
    #define _INTERNAL_EEPROM_SIZE_    (2 * 1024)  //2KB for Mega64
  #else
    #ifdef  _CHIP_ATMEGA128_
      #define _INTERNAL_EEPROM_SIZE_  (4 * 1024)  //4KB for Mega128
    #else
      #error ERROR: Chip type not supported. "_INTERNAL_EEPROM_SIZE_" is undefined for this chip type.
    #endif
  #endif
#endif

#ifdef  _CHIP_ATMEGA128_
  #define _Set_MICRO_RESET_AFTER_EACH_SHOW_ENBLED_  //This command is excluded in mega32 to decrease program size
#endif
