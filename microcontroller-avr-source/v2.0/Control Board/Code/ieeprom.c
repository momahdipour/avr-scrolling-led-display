//ieeprom.c (Internal EEPROM)
//All EERPOM settings are collected here

#ifndef _DEBUG_

//======================================================================================================================
//======================================================================================================================
//======================================================================================================================
//-----------------------
//MAIN.c
//-----------------------




//-----------------------
//screen.c
//-----------------------



//-----------------------
//internal_fonts.c
//-----------------------


//-----------------------
//memory.c
//-----------------------

//-----------------------
//temperatur.c
//-----------------------


//-----------------------
//primary.c
//-----------------------



//-----------------------
//trial.c
//-----------------------


//-----------------------
//defs.c
//-----------------------


//some characters in buttons.c
//MEMORY_DATA_RESET in mem_reset.c
//Alarm settings in alarms.c

//======================================================================================================================
//======================================================================================================================
//======================================================================================================================

#else

//ifdef _DEBUG_

//======================================================================================================================
//======================================================================================================================
//======================================================================================================================

//-----------------------
//MAIN.c
//-----------------------
#define   MAX_OVERALL_SPEED_SETTING     150
unsigned char OVERALL_SPEED_SETTING = 16;  //Used for LED Display timing


//**********************************************************************************************************
//** DO NOT CHANGE THIS VALUES - THESE VALUES ARE EXAMINED ON THE LED DISPLAY AND ARE GOOD INITIAL VALUES **
#if LED_DISPLAY_MAX_ROW_COUNT <= 8
  #ifdef _COLOR_DISPLAY_METHOD_2_
    unsigned char OCR0_VALUE = 15;  //Same value for both mega32 and mega128  --> This is actually 16 rows for refresh
  #else
    unsigned char OCR0_VALUE = 30;  //Same value for both mega32 and mega128
  #endif
#elif LED_DISPLAY_MAX_ROW_COUNT <= 16
  #ifdef _COLOR_DISPLAY_METHOD_2_
    unsigned char OCR0_VALUE = 5;  //Same value for both mega32 and mega128  --> This is actally 32 rows for refresh
  #else
    unsigned char OCR0_VALUE = 15;  //Same value for both mega32 and mega128
  #endif
#elif LED_DISPLAY_MAX_ROW_COUNT <= 24  //_COLOR_DISPLAY_METHOD_2_ is not supported for row count greater than 16
unsigned char OCR0_VALUE = 10;  //Same value for both mega32 and mega128
#else  //#elif LED_DISPLAY_MAX_ROW_COUNT <= 32
unsigned char OCR0_VALUE = 5;  //Same value for both mega32 and mega128
#endif
//**********************************************************************************************************


//-----------------------
//screen.c
//-----------------------
//eeprom unsigned int DATA_VALIDATION_ERR_COUNT = 0;  --> Removed for privacy policy

unsigned char MICRO_RESET_AFTER_EACH_SHOW = 0xFF;  //0x00 = No (Don't Reset), Any other value = Yes (Reset)

unsigned char SCROLL_STEP_ADJUST = 0;  //This value always is in EEPROM even if scrolling text is inactive.


//-----------------------
//internal_fonts.c
//-----------------------
unsigned char InvalidDataErrorMsg[8] = {
7,
/* OLD - NOT MIRRORED
0xFE, 0xC6, 0xAA, 0x92, 0xAA, 0xC6, 0xFE
*/
0x7F, 0x63, 0x55, 0x49, 0x55, 0x63, 0x7F
};


//-----------------------
//memory.c
//-----------------------
unsigned int EEPROM_IC_Size_EEP = 8192;//2048 = AT24C16, 4096 = AT24C32, 8192 = AT24C64, 65536-1 = AT24C512  //AT24C64 - in bytes - can be set via usart command usart_cmd_SetEEPROMs - AT24C32 = 4KB (minimum reasonable memory)

unsigned char EEPROM_IC_Count_EEP = 1;  //min 1, up to MAX_EEPROM_COUNT EEPROM ICs can be connected

//-----------------------
//temperatur.c
//-----------------------
int TemperatureOffset = 0;


//-----------------------
//primary.c
//-----------------------
unsigned char RowSelectorsDONTNOT_EEP[32] = {
//This array must be used when there is no need to NOT rows when we want to select a row.
1, 2, 4, 8, 16, 32, 64, 128,
1, 2, 4, 8, 16, 32, 64, 128,
1, 2, 4, 8, 16, 32, 64, 128,
1, 2, 4, 8, 16, 32, 64, 128
};

#define   COLUMNS_NOT_EEP_DEFAULT     0x00  //0x00 = No, 0xFF = Yes
#define   ROWS_NOT_EEP_DEFAULT        0xFF//(for color display method 2 (row-based) //0xFF (for normal display)  //0x00 = No, 0xFF = Yes
unsigned char COLUMNS_NOT_EEP = COLUMNS_NOT_EEP_DEFAULT;  //0xFF: NOT, otherwise (must be 0x00) do not NOT
unsigned char ROWS_NOT_EEP = ROWS_NOT_EEP_DEFAULT;  //0xFF: NOT, otherwise (must be 0x00) do not NOT


//-----------------------
//trial.c
//-----------------------
unsigned int TrialLimit = 0;  //Maximum numbr of times allowed to change data
unsigned int TrialCount = 0;  //Number of times data has been changed


//-----------------------
//defs.c
//-----------------------
//Maximum display size
//#define MAX_ROW_COUNT 16
//#define MAX_COL_COUNT   128
unsigned char MAX_ROW_COUNT = LED_DISPLAY_MAX_ROW_COUNT;
unsigned char MAX_COL_COUNT = LED_DISPLAY_MAX_COL_COUNT;

//======================================================================================================================
//======================================================================================================================
//======================================================================================================================

#endif