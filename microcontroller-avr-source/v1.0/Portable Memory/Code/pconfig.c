//Portable memory configuration values

//Only should be defined for the portable memory program - this is used in the function usart_cmd_GetConfiguration.
#define     _THIS_IS_PORTABLE_MEMORY_

#define   MAX_EEPROM_IC_PAGE_SIZE   128  //128 for 512Kbs IC
#define   MEM_START_OFFSET          0  //MEM_START_OFFSET is always 0 in the portable memory

#define   PROGRAM_MAJOR_VERSION_NUMBER_CHAR     '1'
#define   PROGRAM_MINOR_VERSION_NUMBER_CHAR     '0'

#define   NUM_OF_BYTES_TO_CLEAR_AFTER_SET_MEMORY    2048  //in bytes

#define   MAX_EEPROM_COUNT      5

#define   MAX_ALARM_COUNT_PER_MONTH     31  //--> max 254 (an unsigned char value - 1)

#define   ALARM_DATA_MEM_START_OFFSET     0   //Always 0 in the portable memory

//#define   USART_LED_BLINK_TICK_COUNT_RECEIVE    3
//#define   USART_LED_BLINK_TICK_COUNT_SEND       24
#define   LED_BLINK_SPEED_FOR_RECEIVE           80//30
#define   LED_BLINK_SPEED_FOR_SEND              80


////////////////////////////
//Memory cache configuration
#define   CACHE_COUNT   1
#define   CACHE_SIZE    1
////////////////////////////

#define   BUTTON_SEND   PIND.2
#define   BUTTON_OTHER  PIND.3

#define   EEPROM_WRITE_DELAY    10  //in milliseconds (original value was 10ms)

//Alerts
#define   USART_BUFFER_OVERFLOW_ALERT       4
#define   MEMORY_DATA_OVERFLOW_ALERT        6
