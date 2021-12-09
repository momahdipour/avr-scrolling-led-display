
#include "config.c"

#define FRAME_HEADER_SIZE           2
#define MAX_CONTENT_SETTINGS_SIZE   12

//Maximum display size
//#define MAX_ROW_COUNT 16
//#define MAX_COL_COUNT   128
eeprom unsigned char MAX_ROW_COUNT_TEMP_UNUSED = LED_DISPLAY_MAX_ROW_COUNT;
eeprom unsigned char MAX_COL_COUNT_TEMP_UNUSED = LED_DISPLAY_MAX_COL_COUNT;
#define MAX_ROW_COUNT LED_DISPLAY_MAX_ROW_COUNT
#define MAX_COL_COUNT LED_DISPLAY_MAX_COL_COUNT

#define MAX_ROW_COUNT_FOR_ARRAY LED_DISPLAY_MAX_ROW_COUNT//*** Must be MAX_ROW_COUNT  --> *** If changed, also take care of 'usart_cmd_SetMaxSize'
#define MAX_COL_COUNT_FOR_ARRAY LED_DISPLAY_MAX_COL_COUNT + 1//*** Must be MAX_COL_COUNT + 1

#define MAX_COLUMN_LATCH_COUNT_ON_CIRCUIT   (128 / 8)  //This value is the maximum number of column latches that can be connected to the circuit and is not related to MAX_COL_COUNT.
#define MAX_ROW_LATCH_COUNT_ON_CIRCUIT      (32 / 8)  //This value is the maximum number of row latches that can be connected to the circuit and is not related to MAX_ROW_COUNT.

//Determines speed of playing speed modes (very fast, fast, medium, slow, very slow)
//Higher values dcereases overall speed, lower values increases overall speed.
#define CONTENT_SPEED_MULTIPLIER 0.4//Original Value was 0.7


//External EEPROM Memory Settings
//#define   ICSIZE    32768  //in bytes - FM24C256 (32KB External EEPROM IC)
//#define   ICSIZE    8192  //in bytes - FM24C64 (8KB External EEPROM IC)

#define   EEPROM_WRITE_DELAY    10  //in milliseconds (original value was 10ms)

#define   MAX_EEPROM_COUNT      5

//#define NOT_THE_OUTPUT 1  //1 = NOT, 0 = Don't NOT  -- Not used
//#define REFRESH_DELAY 250  //us -- Not used
//#define OVERALL_REFRESH_COUNT 1  //Not used anymore

//LED Display Size that this program is running on it

//#define   LED_DISPLAY_HEIGHT    16
//#define   LED_DISPLAY_WIDTH     96

//Display capabilities to be reported to computer via serial port
//#define   TEMPERATURE_EXISTS    1   //1 = Yes, 0 = No
//#define   HUMIDITY_EXISTS       0
//#define   DATE_TIME_EXISTS      1

//Pulse duration for latches to operate correctly
//#define   LATCH_PULSE_DURATION  1  //us  --> No delay is required

//USART Settings
// *** > If changed, also change USART_TIME_FAIL_SAFE_TICK_COUNT
// *** > If changed, also update the corresponding values in the delphi program
#define   USART_TIME_OUT_1      3  //In seconds - For long-time commands - Must be greater than 1
#define   USART_TIME_OUT_2      2  //In seconds - For short-time commands - Must be greater than 1

#define   USART_LED_BLINK_TICK_COUNT    450

#define   USART_TIME_FAIL_SAFE_TICK_COUNT   15000   //About 15 seconds

//Temperature sampling timeout
#define   TEMPERATURE_SAMPLING_TICK_COUNT   4000

#define   DEFAULT_ALARM_CHEK_COUNTER      5

//Alerts
#define   USART_BUFFER_OVERFLOW_ALERT       4
#define   MEMORY_DATA_OVERFLOW_ALERT        6
#define   STRICT_LOCK_ALERT                 10

#define   COLUMNS_NOT_EEP_DEFAULT     0x00//0x00 = No, 0xFF = Yes
#define   ROWS_NOT_EEP_DEFAULT        0xFF//0x00 (for color display method 2 (row-based) //0xFF (for normal display)  //0x00 = No, 0xFF = Yes

#ifdef    _FULL_LATCH_

#define   PROGRAM_MAJOR_VERSION_NUMBER_CHAR     '3'
#define   PROGRAM_MINOR_VERSION_NUMBER_CHAR     '0'

#else

#define   PROGRAM_MAJOR_VERSION_NUMBER_CHAR     '1'
#define   PROGRAM_MINOR_VERSION_NUMBER_CHAR     '5'

#endif

#define   CLEAR_OLD_MEMORY_DATA_DEFAULT_STATE   0xFF  //0x00: Inactive (Don't clear), 0xFF: Active (Clear)

#define   LEDDISPLAY_RESET_BYTE_1_FROM_MICRO    0xCB
#define   LEDDISPLAY_RESET_BYTE_2_TO_MICRO      0x56
#define   LEDDISPLAY_RESET_BYTE_3_FROM_MICRO    0xAE
#define   LEDDISPLAY_RESET_BYTE_4_TO_MICRO      0x94

//Configuration of four buttons connected to the circuit
#define   BUTTON_OTHER    PINA.3
#define   BUTTON_SET      PINA.4
#define   BUTTON_UP       PINA.5
#define   BUTTON_DOWN     PINA.6

#define   MAX_EEPROM_IC_PAGE_SIZE   128  //128 for 512Kbs IC