
unsigned long MemoryData_next_addr;

unsigned char ub_1;  //usart byte 1
unsigned char ub_2;  //usart byte 2
unsigned char ub_3;  //usart byte 3

#define RXB8 1
#define TXB8 0
#define UPE 2
#define OVR 3
#define FE 4
#define UDRE 5
#define RXC 7

#define FRAMING_ERROR (1<<FE)
#define PARITY_ERROR (1<<UPE)
#define DATA_OVERRUN (1<<OVR)
#define DATA_REGISTER_EMPTY (1<<UDRE)
#define RX_COMPLETE (1<<RXC)

// USART0 Receiver buffer
#define RX_BUFFER_SIZE0 MAX_EEPROM_IC_PAGE_SIZE+4+3  //128 for max page size + 4 for crc32 + 3 additional byte = 135 bytes total
char rx_buffer0[RX_BUFFER_SIZE0];

#if RX_BUFFER_SIZE0<256
unsigned char rx_wr_index0,rx_rd_index0,rx_counter0;
#else
unsigned int rx_wr_index0,rx_rd_index0,rx_counter0;
#endif

// This flag is set on USART Receiver buffer overflow
bit rx_buffer_overflow0;

#define   USART_INIT_BYTE_1    0xED
#define   USART_INIT_BYTE_2    0xCB

//unsigned char usart_status = 0;  --> In the oldest version, this variable was used to process usart directly in the usart interrupt, but in newer versions usart data is not processed in this way, and so there is no need to this variable at all.
/*

  usart_status VALUES:
  0: Waiting for the first initial byte
  1: Waiting for the second initial byte
  2: Waiting for a command
  3: Executing a command
  4 and more: Next stage in the current command

*/

//usart_cmd_stage is declared in the MAIN.c file to make it possible to allocate a register to it

bit DataMemoryChanged = 0;
bit MemoryDataOverlow = 0;

/*
  Commands:
  0x01: Set time
  0x02: Set date
  0x03: Send display size
  0x04: Send memory size (in bytes)
  0x05: Is there a temperature sensor?
  0x06: Is there a humidity sensor?
  0x07: Is there time and date features?
  0x11: Change EEPROMs data
  
*/

void usart_cmd_SetTime(unsigned char data);
void usart_cmd_SetDate(unsigned char data);
//void usart_cmd_SendDisplaySize(unsigned char data);
//void usart_cmd_SendMemorySize(unsigned char data);
//void usart_cmd_QueryTemperatureFeature(unsigned char data);
//void usart_cmd_QueryHumidityFeature(unsigned char data);
//void usart_cmd_QueryDateTimeFeature(unsigned char data);
//void usart_cmd_SendTemperature(unsigned char data);
//void usart_cmd_SendHumidity(unsigned char data);
//void usart_cmd_SendTime(unsigned char data);
//void usart_cmd_SendDate(unsigned char data);
void usart_cmd_SetMemoryData(unsigned char data);
void usart_cmd_SetFontData(unsigned char data);
#ifdef  _ALARM_ACTIVE_
void usart_cmd_SetAlarmData(unsigned char data);
void usart_cmd_GetAlarmData(unsigned char data);
void usart_cmd_Set_ALARM_CHEK_COUNTER(unsigned char data);
#endif
void usart_cmd_ClearAllMemoryData(unsigned char data);
//void usart_cmd_ReadFlashMemoryData(unsigned char data);
void usart_cmd_GetMemoryData(unsigned char data);
void usart_cmd_SetEEPROMs(unsigned char data);
void usart_cmd_GetConfiguration(unsigned char data);
void usart_cmd_SetRefreshRate(unsigned char data);
#ifdef  _TRIAL_LIMIT_ACTIVE_
void usart_cmd_SetTrialLimit(unsigned char data);
#endif
void usart_cmd_SetMaxSize(unsigned char data);
void usart_cmd_SetTemperatureOffset(unsigned char data);
/*
void usart_cmd_SetErrCounter(unsigned char data);
*/
void usart_cmd_Set_COLUMNS_NOT(unsigned char data);
void usart_cmd_Set_ROWS_NOT(unsigned char data);
void usart_cmd_Set_CLEAR_OLD_MEMORY_DATA(unsigned char data);
void usart_cmd_Set_OVERALL_SPEED_SETTING(unsigned char data);
//void usart_cmd_Set_SCROLL_STEP_ADJUST(unsigned char data);  --> Removed from updates
#ifdef  _STRICT_LOCK_ACTIVE_
void usart_cmd_UpdateStrictLock(unsigned char data);
#endif
#ifdef  _Set_MICRO_RESET_AFTER_EACH_SHOW_ENBLED_
void usart_cmd_Set_MICRO_RESET_AFTER_EACH_SHOW(unsigned char data);
#endif
#ifdef  _TIME_SPAN_ACTIVE_
void usart_cmd_Set_Off_Time(unsigned char data);
void usart_cmd_Get_Off_Time(unsigned char data);
#endif
void usart_cmd_SetTextScrollStep(unsigned char data);
void usart_cmd_GetTextScrollStep(unsigned char data);

void execute_usart_cmd(unsigned char usart_cmd, unsigned char data)
{
   switch(usart_cmd)
   {
     case 0x01:
       usart_cmd_SetTime(data);
       break;
     case 0x02:
       usart_cmd_SetDate(data);
       break;
/*
     case 0x03:
//       usart_cmd_SendDisplaySize(data);
       break;
     case 0x04:
//       usart_cmd_SendMemorySize(data);
       break;
     case 0x05:
//       usart_cmd_QueryTemperatureFeature(data);
       break;
     case 0x06:
//       usart_cmd_QueryHumidityFeature(data);
       break;
     case 0x07:
//       usart_cmd_QueryDateTimeFeature(data);
       break;
     case 0x08:
//       usart_cmd_SendTemperature(data);
       break;
     case 0x09:
//       usart_cmd_SendHumidity(data);
       break;
     case 0x0a:
//       usart_cmd_SendTime(data);
       break;
     case 0x0b:
//       usart_cmd_SendDate(data);
       break;
*/
     case 0x11:
       usart_cmd_SetMemoryData(data);
       break;
     case 0x22:
       usart_cmd_SetFontData(data);
       break;
     #ifdef _ALARM_ACTIVE_
     case 0x33:
       usart_cmd_SetAlarmData(data);
       break;
     #endif
//     case 0xa1:
//       usart_cmd_ReadFlashMemoryData(data);
//       break;
     case 0xa2:
       usart_cmd_GetMemoryData(data);
       break;
     case 0xb1:
       usart_cmd_SetEEPROMs(data);
       break;
     case 0xb2:
       usart_cmd_GetConfiguration(data);
       break;
     case 0xb4:
       usart_cmd_SetMaxSize(data);
       break;
     case 0xb8:
       usart_cmd_SetRefreshRate(data);
       break;
     case 0xc1:
       usart_cmd_SetTemperatureOffset(data);
       break;
     /*
     case 0xc2:
       usart_cmd_SetErrCounter(data);
       break;
     */
     case 0xc4:
       usart_cmd_Set_ROWS_NOT(data);
       break;
     case 0xc8:
       usart_cmd_Set_COLUMNS_NOT(data);
       break;
     case 0xd1:
       usart_cmd_Set_CLEAR_OLD_MEMORY_DATA(data);
       break;
     case 0xd2:
       usart_cmd_Set_OVERALL_SPEED_SETTING(data);
       break;
     #ifdef _TRIAL_LIMIT_ACTIVE_
     case 0xd4:
       usart_cmd_SetTrialLimit(data);
       break;
     #endif
     #ifdef _ALARM_ACTIVE_
     case 0xd8:
       usart_cmd_GetAlarmData(data);
       break;
     #endif
     #ifdef _ALARM_ACTIVE_
     case 0xe1:
       usart_cmd_Set_ALARM_CHEK_COUNTER(data);
       break;
     #endif
     case 0xe2:
       usart_cmd_ClearAllMemoryData(data);
       break;
     //case 0xe4:  --> Don't use this code for another command for future compatibility
     //  usart_cmd_Set_SCROLL_STEP_ADJUST(data);
     //  break;
     #ifdef _STRICT_LOCK_ACTIVE_
     case 0xe8:
       usart_cmd_UpdateStrictLock(data);
       break;
     #endif
     case 0xf1:  //Command to reset the LED Display (cold reset)
       MicroResetCold();
       break;
     #ifdef _Set_MICRO_RESET_AFTER_EACH_SHOW_ENBLED_
     case 0xf2:
       usart_cmd_Set_MICRO_RESET_AFTER_EACH_SHOW(data);
       break;
     #endif
     //default:  //Invalid command
     //  usart_status = 0;
     //  break;
     #ifdef  _TIME_SPAN_ACTIVE_
     case 0xf4:
       usart_cmd_Set_Off_Time(data);
       break;
     case 0xf8:
       usart_cmd_Get_Off_Time(data);
       break;
     #endif
     case 0xf9:
       usart_cmd_SetTextScrollStep(data);
       break;
     case 0xfa:
       usart_cmd_GetTextScrollStep(data);
       break;
   }
}


//TTime usart_last_rcv_time = {0, 0, 0};
TTime usart_last_operation_time;

// USART0 Receiver interrupt service routine
#ifdef  _CHIP_ATMEGA128_
interrupt [USART0_RXC] void usart_rx_isr(void)
#endif
#ifdef  _CHIP_ATMEGA32_
interrupt [USART_RXC] void usart_rx_isr(void)
#endif
{
char status,data;
//static unsigned char command;
#ifdef  _CHIP_ATMEGA128_
status=UCSR0A;
data=UDR0;
#endif
#ifdef  _CHIP_ATMEGA32_
status=UCSRA;
data=UDR;
#endif

/*
if(time_elapsed(usart_last_rcv_time) >= 1)
  usart_status = 0;
*/

//if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
   {
     
     rx_buffer0[rx_wr_index0]=data;
     if (++rx_wr_index0 == RX_BUFFER_SIZE0) rx_wr_index0=0;
     if (++rx_counter0 == RX_BUFFER_SIZE0)
        {
        rx_counter0=0;
        rx_buffer_overflow0=1;
        };
     
     /*switch(usart_status)
     {
       case 0:
         if(data == USART_INIT_BYTE_1)
           usart_status++;
         break;
       case 1:
         if(data == USART_INIT_BYTE_2)
           usart_status++;
         break;
       case 2:
         command = data;
         usart_cmd_stage = 0;
         execute_usart_cmd(command, data);
         break;
       default:  //Invalid status
         usart_status = 0;
         break;
     }*/
   }
   /*else
   {
     usart_status = 0;
   }
   
  get_time(&usart_last_rcv_time);*/
}

#ifndef _DEBUG_TERMINAL_IO_
// Get a character from the USART Receiver buffer
#define _ALTERNATE_GETCHAR_
#pragma used+
char getchar(void)
{
char data;
while (rx_counter0==0);
data=rx_buffer0[rx_rd_index0];
if (++rx_rd_index0 == RX_BUFFER_SIZE0) rx_rd_index0=0;
#asm("cli")
--rx_counter0;
#asm("sei")
return data;
}
#pragma used-
#endif

char usart_char_available()
{
  return(rx_counter0 > 0);
}

void reset_usart_buffer()
{
  while(usart_char_available())
  {
    getchar();
  }
}

eeprom unsigned char CLEAR_OLD_MEMORY_DATA = CLEAR_OLD_MEMORY_DATA_DEFAULT_STATE;

#define   FIRMWARE_VERSION_CHECK

void handle_usart()
{
  unsigned char c, command;
  unsigned long TimeOut;
  unsigned long LEDLastTickCount = 0;
  unsigned long TimeFailSafeTickCount;
  //unsigned long eeprom_clear_addr;

//  pulse(500);
  
  PORTA.7 = 1;  //Indicate receipt of USART data (This does not mean receipt of correct data.)
  delay_ms(300);  //THIS DELAY IS NECESSARY NOT FOR DEBUG: Wait for the initialization data (3 bytes) to come into cache (:: avoid usart_char_available() to return no data is available.)
  PORTA.7 = 0;  //Turn the LED off and continue
  
  c = getchar();

//  putchar(c);
//  return;
  
  if(c != USART_INIT_BYTE_1)
  {
    reset_usart_buffer();
    return;
  }
  if(!usart_char_available())
    return;
  c = getchar();
  if(c != USART_INIT_BYTE_2)
    return;
  if(!usart_char_available())
    return;

  command = getchar();
  //Send ACK
  putchar(USART_INIT_BYTE_1);
  putchar(USART_INIT_BYTE_2);
  putchar(command);
  
  ////////////////////////////////////////////////////////////
  //FIRMWARE VERSION CHECK
  #ifdef FIRMWARE_VERSION_CHECK
  
    putchar(PROGRAM_MAJOR_VERSION_NUMBER_CHAR);
    putchar(PROGRAM_MINOR_VERSION_NUMBER_CHAR);
  
    //Now read back the version number
    delay_ms(100);
    if(!usart_char_available())
      return;
    c = getchar();
    if(c != PROGRAM_MAJOR_VERSION_NUMBER_CHAR)
      return;
    if(!usart_char_available())
      return;
    c = getchar();
    if(c != PROGRAM_MINOR_VERSION_NUMBER_CHAR)
      return;
    //Version Number OK
    delay_ms(100);
    putchar(command);
  #endif
  //FIRMWARE VERSION CHECKING DONE
  ////////////////////////////////////////////////////////////
  
  //Now go on!
  
  usart_cmd_stage = 0;
  execute_usart_cmd(command, command);
  
  //Select correct timeout
  if(command == 0x11 || command == 0x22)
    TimeOut = USART_TIME_OUT_1;
  else
    TimeOut = USART_TIME_OUT_2;
  
  if(command == 0x11)
  {
    MemoryData_next_addr = MEM_START_OFFSET;
  }
  
  DataMemoryChanged = 0;
  MemoryDataOverlow = 0;
  
  PORTA.7 = 1;
  //stop_refresh();
  
  rx_buffer_overflow0 = 0;
  LEDLastTickCount = TickCount;
  
  get_time(&usart_last_operation_time);
  TimeFailSafeTickCount = TickCount;
  
  //eeprom_clear_addr = 0;
  while(1)
  {
    /*
    if(command == 0x11)
    {
      if(eeprom_clear_addr < MemoryData_next_addr)
        eeprom_clear_addr = MemoryData_next_addr;
    }
    */
    
    while(!usart_char_available() && (time_elapsed(usart_last_operation_time, FALSE) < TimeOut))
    {
      if((TickCount - LEDLastTickCount) >= USART_LED_BLINK_TICK_COUNT)
      {
        PORTA.7 = ~PINA.7;
        LEDLastTickCount = TickCount;
      }
      if((TickCount - TimeFailSafeTickCount) >= USART_TIME_FAIL_SAFE_TICK_COUNT)
      {
        break;
      }
      /*
      if(command == 0x11)
      {
        mem_write(eeprom_clear_addr, 0);
        eeprom_clear_addr++;
      }
      */
    }
    if(!usart_char_available())
      break;
    
    c = getchar();
    
    execute_usart_cmd(command, c);
    
    //It is necessary here to update the status of the LED here too, because it is possible that data come into the usart buffer continually and the LED status not be updated at the above statements.
    if((TickCount - LEDLastTickCount) >= USART_LED_BLINK_TICK_COUNT)
    {
      PORTA.7 = ~PINA.7;
      LEDLastTickCount = TickCount;
    }
    
    //putchar(c);
    
    get_time(&usart_last_operation_time);
    TimeFailSafeTickCount = TickCount;
    //pulse(100);
  }
  
  
  //If font data has been changed, invalidate all memory caches to force using new font data for displaying time, date, and temperature
  if(command == 0x22)  //usart_cmd_SetFontData
  {
    InvalidateMemoryCaches();  //Invalidate all memory caches to force using new data for displaying time, date, and temperature
  }
  
  //Clear old data only if Data Memory has been changed
  if(command == 0x11 && CLEAR_OLD_MEMORY_DATA && DataMemoryChanged == 1)
  {
    PORTA.7 = 1;
    //Now MemoryData_next_addr points to the first byte of the next page in the memory
    ClearMemoryFast(MemoryData_next_addr, NUM_OF_BYTES_TO_CLEAR_AFTER_SET_MEMORY);
  }
  
  #ifdef  _ALARM_ACTIVE_
  else if(command == 0x33)  //SetAlarmData
  {
    InitAlarms();
  }
  #endif
  
  if(command == 0x11 || command == 0x33)
  {
    //Check trial state
    if(TrialLimit > 0)
    {
      if(TrialCount <= TrialLimit)
        TrialCount++;
    }
    CheckTrial();
    
    /*
    //Check trial state
    if(TrialApplied)
    {
      ResetMemoryData(TRUE);
      rx_buffer_overflow = 0;
    }
    */
  }
  
  //start_refresh();
  PORTA.7 = 0;
  
  start_refresh();  //refresh may be stopped by any usart command that needs more speed
  
  if(rx_buffer_overflow0 == 1)
  {
    ResetMemoryData(FALSE);
    Alert(USART_BUFFER_OVERFLOW_ALERT);
    printf("USART Buffer overflow");
  }
  else
  {
    if(DataMemoryChanged == 1)
    {
      if(MemoryDataOverlow == 1)
      {
        ResetMemoryData(FALSE);
        Alert(MEMORY_DATA_OVERFLOW_ALERT);
        printf("Memory Data Overflow");
      }
      else
      {
        //--> No need to do anything, only reset the uc.
        
        //ValidateData();
        //if(DataIsValid == 0)
        //  DATA_VALIDATION_ERR_COUNT++;
        
        //Always reset
        //if(DataIsValid)
        //{
          MicroReset();
          //PrepareForNewData();
        //}
      }
    }
  }
}


void Increase_cmd_stage()
{
  if(usart_cmd_stage != 0xff)
    usart_cmd_stage++;
}


/* USART COMMANDS */
void usart_cmd_SetTime(unsigned char data)
{
  //static unsigned char h, m, s;
  
  switch(usart_cmd_stage)
  {
    case 0:
      break;
    case 1:  //Get hour
      ub_1 = data;
      break;
    case 2:  //Get minute
      ub_2 = data;
      break;
    case 3:  //Get second
      ub_3 = data;
      //DONE
      //usart_status = 0;
      rtc_set_time(ub_1, ub_2, ub_3);
      
      //ClkHour = ub_1;  --> No need to also set the internal clock to the current time. Actual clock and internal clock are completely independent from each other
      //ClkMinute = ub_2;
      //ClkSecond = ub_3;
      
      break;
  }
  Increase_cmd_stage();
}

void usart_cmd_SetDate(unsigned char data)
{
//  static unsigned char y, m, d;
  
  switch(usart_cmd_stage)
  {
    case 0:
      break;
    case 1:  //Get year
      ub_1 = data;
      break;
    case 2:  //Get month
      ub_2 = data;
      break;
    case 3:  //Get day
      ub_3 = data;
      //DONE
      //usart_status = 0;
      rtc_set_date(ub_3, ub_2, ub_1);
      break;
  }
  Increase_cmd_stage();
}

/*
void usart_cmd_SendDisplaySize(unsigned char data)
{
  //Exmaple for 16x64: first send 16, then send 64
  if(usart_cmd_stage == 0)
  {
    //putchar(LED_DISPLAY_HEIGHT);
    //putchar(LED_DISPLAY_WIDTH);
    putchar(0);
    putchar(0);
  }
  //DONE
  //usart_status = 0;
}
*/

/*
void usart_cmd_SendMemorySize(unsigned char data)
{
}
*/

/*
void usart_cmd_QueryTemperatureFeature(unsigned char data)
{
  if(usart_cmd_stage == 0)
  {
    putchar(TEMPERATURE_EXISTS);
  }
  //DONE
  //usart_status = 0;
}
*/

/*
void usart_cmd_QueryHumidityFeature(unsigned char data)
{
  if(usart_cmd_stage == 0)
  {
    putchar(HUMIDITY_EXISTS);
  }
  //DONE
  //usart_status = 0;
}
*/

/*
void usart_cmd_QueryDateTimeFeature(unsigned char data)
{
  if(usart_cmd_stage == 0)
  {
    putchar(DATE_TIME_EXISTS);
  }
  //DONE
  //usart_status = 0;
}
*/

/*
void usart_cmd_SendTemperature(unsigned char data)
{
}
*/

/*
void usart_cmd_SendHumidity(unsigned char data)
{
}
*/

/*
void usart_cmd_SendTime(unsigned char data)
{
  unsigned char h, m, s;
  
  if(usart_cmd_stage == 0)
  {
    rtc_get_time(&h, &m, &s);
    putchar(h);
    putchar(m);
    putchar(s);
  }
  //DONE
  //usart_status = 0;
}
*/

/*
void usart_cmd_SendDate(unsigned char data)
{
  unsigned char y, m, d;
  
  if(usart_cmd_stage == 0)
  {
    rtc_get_date(&d, &m, &y);
    putchar(y);
    putchar(m);
    putchar(d);
  }
  //DONE
  //usart_status = 0;
}
*/

/*
void InitializeCheckSum()
{
  CheckSum = 0xFFFFFFFF;  //CRC-32
}

void FinalizeCheckSum()
{
  CheckSum = ~CheckSum;  //CRC-32
}

void AddToCheckSum(unsigned char data)
{
  unsigned char bit_pos;
  
  CheckSum ^= data;
  for(bit_pos = 0; bit_pos < 8; bit_pos++)
  {
    if(CheckSum & 1)
      CheckSum = (CheckSum >> 1) ^ 0xEDB88320;
    else
      CheckSum = (CheckSum >> 1);
  }
}
*/

unsigned long CalcCRC32(unsigned char *data, unsigned char n)
{
  unsigned long CheckSum = 0xFFFFFFFF;  //CRC-32  //InitializeCheckSum
  unsigned char i;
  unsigned char bit_pos;
  
  for(i = 0; i < n; i++)
  {
    //AddToCheckSum
    CheckSum ^= data[i];
    for(bit_pos = 0; bit_pos < 8; bit_pos++)
    {
      if(CheckSum & 1)
        CheckSum = (CheckSum >> 1) ^ 0xEDB88320;
      else
        CheckSum = (CheckSum >> 1);
    }
  }
  
  return(~CheckSum);  //FinalizeCheckSum
}

#define   WRITE_FAIL          '!'//0xFF
#define   WRITE_SUCCESSFUL    '@'//0x00

void usart_cmd_SetMemoryData(unsigned char data)
{
  //unsigned int PageStartAddr;
  unsigned char i;
  //unsigned char PageSize;
  unsigned long crc32;
  BOOL PageSizeValid;
  
  unsigned char DataBuffer[MAX_EEPROM_IC_PAGE_SIZE + 4];  //plus 4 bytes for the crc32
  
  //PageSize = EEPROM_IC_PAGE_SIZE;
  
  if(usart_cmd_stage == 0)
  {
    MemoryData_next_addr = MEM_START_OFFSET;  //must be a multiple of PageSize
    usart_cmd_stage = 1;
    ClearScreen(TRUE);
    //delay_ms(100);  --> No need because we will wait in the following instruction  //Wait to completely refresh the output display with new data (screen will be cleared)
    
    //Send page size 5 times to prevent communication errors
    delay_ms(500);  //--> This delay is also used to completely refresh the output screen with new data (cleared screen)
    for(i = 0; i < 5; i++)
      putchar(EEPROM_IC_PAGE_SIZE);
    
    stop_refresh();  //Refresh is started again the handle_usart() function or upon reset
  }
  else
  {
    //if(data != PageSize)
    if(data != EEPROM_IC_PAGE_SIZE)
    {
      PageSizeValid = FALSE;
    }
    else
    {
      PageSizeValid = TRUE;
    }
    
    if(PageSizeValid)
      DataMemoryChanged = 1;
    
    //get data
    // Watchdog Timer Prescaler: OSC/2048k
    EnableWatchdog();  //Use watchdog to prevent the LED Display to hang when in the getchar() function
    #asm("wdr")
    for(i = 0; i < (EEPROM_IC_PAGE_SIZE + 4); i++)  //plus 4 bytes for the crc32
    {
      #asm("wdr")
      DataBuffer[i] = getchar();
    }
    //Disable watchdog
    DisableWatchdog();
    
    //PageStartAddr = ((unsigned int) DataBuffer[1] << 8) | DataBuffer[0];
    
    crc32 = DataBuffer[3];
    crc32 = (crc32 << 8) | DataBuffer[2];
    crc32 = (crc32 << 8) | DataBuffer[1];
    crc32 = (crc32 << 8) | DataBuffer[0];
    
    if(PageSizeValid && CalcCRC32(&DataBuffer[4], EEPROM_IC_PAGE_SIZE) == crc32)  //Don't include crc32 values in the crc32 calculation
    {
      if(!TrialTimedOut())  //Check trial state
      {
        if(MemoryData_next_addr < GetMemSize())
        {
          mem_write_block(MemoryData_next_addr, EEPROM_IC_PAGE_SIZE, &DataBuffer[4]);
          MemoryData_next_addr += (unsigned long) EEPROM_IC_PAGE_SIZE;
        }
        else
        {
          MemoryDataOverlow = 1;
        }
      }
      putchar(WRITE_SUCCESSFUL);
    }
    else
    {
      PORTA.7 = 1;  //Upon failure, turn on the LED to show activity. It will be turned off when the operation is done completely in the handle_usart function or when the uc is reset by the watchdog timer.
      putchar(WRITE_FAIL);
    }
  }
}

void usart_cmd_GetMemoryData(unsigned char data)
{
  unsigned long int next_read_addr;
  unsigned int InternalEEPROMSize;
  eeprom unsigned char *edata;
  unsigned char temp;
  
  if(usart_cmd_stage == 0)
  {
    usart_cmd_stage = 1;
  }
  else if(usart_cmd_stage == 1)
  {
    usart_cmd_stage = 2;
    //ClearScreen(TRUE);  --> No need to do this at all
    //delay_ms(100);  //Wait to completely refresh the output display with new data (screen will be cleared)
    //stop_refresh();  --> Refresh is stopped in the handle_usart() function
    PORTA.7 = 1;  //It will be turned off when the operation is done completely in the handle_usart function.
    switch(data)
    {
      case 0x00:  //Get internal EEPROM data
        InternalEEPROMSize = _INTERNAL_EEPROM_SIZE_;
        
        #warning ATTENTION: If "TrialPassword" is stored on the internal EEPROM, change usart_cmd_GetMemoryData to not to allow to read it via usart.
        
        for(edata = 0; edata < InternalEEPROMSize; edata++)
        {
          putchar(*edata);
          //delay_ms(5)
        }
        break;
      case 0xFF:  //Get external EEPROMs data
        delay_ms(200);  //Wait for the next char to come into usart buffer
        if(!usart_char_available())
          break;
        temp = getchar();
        //Select the memory location to start sending data from
        if(temp == 0x00)
          next_read_addr = 0;  //Start from the beginning of the memory (including font data, alarm data if available, and so on)
        else
          next_read_addr = MEM_START_OFFSET;  //Start from the beginning of display data (only get display data)
        for(; next_read_addr < GetMemSize(); next_read_addr++)
        {
          putchar(mem_read(next_read_addr));
          //delay_ms(5);
        }
        break;
    }
  }
}

/*CANNOT BE IMPLEMENTED DIE TO THE BOOT LOADER
void usart_cmd_ReadFlashMemoryData(unsigned char data)
{
  //static unsigned char addr_low;
  flash char *c;
  unsigned int addr;
  
  if(usart_cmd_stage == 0)
  {
    ub_1 = 0;
    usart_cmd_stage++;
  }
  else if(usart_cmd_stage == 1)
  {
    ub_1 = data;
    usart_cmd_stage++;
  }
  else if(usart_cmd_stage == 2)
  {
    addr = (unsigned int) ub_1 | ( (unsigned int) data << 8);
    c = (flash char *) addr;
    putchar(*c);
    usart_cmd_stage++;
  }
}
*/

void usart_cmd_SetEEPROMs(unsigned char data)
{
  //static unsigned char size_low;  --> ub_1
  //static unsigned char EEPROMIndex;  --> ub_2
  
  switch(usart_cmd_stage)
  {
    case 1:
      EEPROM_IC_Count_EEP = data;
      break;
    case 2:
      ub_1 = data;
      break;
    case 3:
      EEPROM_IC_Size_EEP = ( (unsigned int) data << 8) | ub_1;
      delay_ms(500);
      MicroResetCold();  //Reset microcontroller (cold reset)
      break;
  }
  Increase_cmd_stage();
}

void SetCRC32AndSendUntilACK(unsigned char* DataBuffer, unsigned char SettingsDataSize)
{
  unsigned long crc32;
  unsigned char i;
  //Add CRC32 to DataBuffer
  crc32 = CalcCRC32(DataBuffer, SettingsDataSize);
  DataBuffer[SettingsDataSize + 0] = crc32;  //lowest byte first
  DataBuffer[SettingsDataSize + 1] = crc32 >> 8;
  DataBuffer[SettingsDataSize + 2] = crc32 >> 16;
  DataBuffer[SettingsDataSize + 3] = crc32 >> 24;  //highest byte
      
  //Send data until ACK is received
  while(1)
  {
    delay_ms(50);
    for(i = 0; i < (SettingsDataSize + 4); i++)
      putchar(DataBuffer[i]);
        
    delay_ms(200);  //wait for ACK or NACK to come into usart buffer
    if(!usart_char_available())
      break;
    if(getchar() == WRITE_SUCCESSFUL)
      break;
  }
}

#define   CONFIGURATION_DATA_SIZE   31  //size of all the data bytes sent out via usart as configuration data (in bytes)  -  If changed, also update the same value in the portable memory.
void usart_cmd_GetConfiguration(unsigned char data)
{
  #pragma warn-  //--> Works only in function level!
  unsigned int Size; /*always must be unsigned int*/  //--> This variable may not be used when some capabilities are inactive, so prevent from shoing a 'unreferenced local variable' warning.
  #pragma warn+
  unsigned char DataBuffer[CONFIGURATION_DATA_SIZE + 4];  //4 bytes for CRC32
  //unsigned long crc32;
  //unsigned char i;
  
  switch(usart_cmd_stage)
  {
    case 0:
      usart_cmd_stage = 1;
      break;
    case 1:
      usart_cmd_stage = 2;
      if(data != 0xFF)
        break;
      
      //Collect configuration data into DataBuffer
      //Firmware Version number
      DataBuffer[0] = PROGRAM_MAJOR_VERSION_NUMBER_CHAR;
      DataBuffer[1] = PROGRAM_MINOR_VERSION_NUMBER_CHAR;
      
      //EEPROM memories configuration
      DataBuffer[2] = EEPROM_IC_Count_EEP;  //EEPROM count
      Size = EEPROM_IC_Size_EEP;  //Size is used as a temp here to decrease code size
      DataBuffer[3] = Size;  //EEPROM IC Size low byte
      DataBuffer[4] = Size >> 8;  //EEPROM IC Size high byte
      
      DataBuffer[5] = CLEAR_OLD_MEMORY_DATA;  //Clear Old Memory
      
      DataBuffer[6] = MAX_ROW_COUNT;
      DataBuffer[7] = MAX_COL_COUNT;
      DataBuffer[8] = ROW_COUNT;
      DataBuffer[9] = COL_COUNT;
      
      DataBuffer[10] = OCR0_VALUE;  //Refresh rate
      
      DataBuffer[11] = COLUMNS_NOT;
      DataBuffer[12] =  ROWS_NOT;
      
      #ifdef  _TRIAL_LIMIT_ACTIVE_
        if(TrialLimit == 0 && TrialCount > 0)
          TrialCount = 0;
        if(TrialLimit < TrialCount)
          Size = 0;
        else
          Size = TrialLimit - TrialCount;
        DataBuffer[13] = TrialLimit;  //Trial Limit low byte
        DataBuffer[14] = TrialLimit >> 8;  //Trial Limit high byte
        DataBuffer[15] = Size;  //Trial Times Left low byte
        DataBuffer[16] = Size >> 8;  //Trial Times Left high byte
      #else
        DataBuffer[13] = 0;
        DataBuffer[14] = 0;
        DataBuffer[15] = 0;
        DataBuffer[16] = 0;
      #endif
      
      #ifdef  _TEMPERATURE_ACTIVE_
        DataBuffer[17] = (unsigned int) TemperatureOffset;  //Temperature Offset low byte
        DataBuffer[18] = ((unsigned int) TemperatureOffset) >> 8;  //Temperature Offset high byte
      #else
        DataBuffer[17] = 0;
        DataBuffer[18] = 0;
      #endif
      
      DataBuffer[19] = OVERALL_SPEED_SETTING;  //Overall Speed Setting
      
      //Alarm Configuration
      #ifdef  _ALARM_ACTIVE_
        DataBuffer[20] = MAX_ALARM_COUNT_PER_MONTH;
        #ifdef  _1_MONTH_ALARM_SYSTEM_
          DataBuffer[21] = 0;  //Alarm System = 1-Month
        #else

        #ifdef  _12_MONTH_ALARM_SYSTEM_
          DataBuffer[21] = 1;  //Alarm System = 12-Month
        #endif

        #endif
      #else
        DataBuffer[20] = 0;
        DataBuffer[21] = 0;
      #endif
      
      DataBuffer[22] = SCROLL_STEP_ADJUST;  //text scroll step adjust
      
      DataBuffer[23] = LED_DISPLAY_MAX_ROW_COUNT;
      DataBuffer[24] = LED_DISPLAY_MAX_COL_COUNT;
      
      DataBuffer[25] = DEFAULT_ALARM_CHEK_COUNTER;
      
      DataBuffer[26] = MAX_EEPROM_IC_PAGE_SIZE;
      
      DataBuffer[27] = EEPROM_WRITE_DELAY;
      
      DataBuffer[28] = MAX_CONTENT_SETTINGS_SIZE;
      
      //BIT 0-------------------------------------------------------------
      #ifdef  _TIME_ACTIVE_
        #define   _TIME_ACTIVE_BIT  (1 << 0)
      #else
        #define   _TIME_ACTIVE_BIT  0
      #endif
      //BIT 1-------------------------------------------------------------
      #ifdef  _DATE_ACTIVE_
        #define   _DATE_ACTIVE_BIT  (1 << 1)
      #else
        #define   _DATE_ACTIVE_BIT  0
      #endif
      //BIT 2-------------------------------------------------------------
      #ifdef  _SCROLLING_TEXT_ACTIVE_
        #define   _SCROLLING_TEXT_ACTIVE_BIT  (1 << 2)
      #else
        #define   _SCROLLING_TEXT_ACTIVE_BIT  0
      #endif
      //BIT 3-------------------------------------------------------------
      #ifdef  _ANIMATION_ACTIVE_
        #define   _ANIMATION_ACTIVE_BIT  (1 << 3)
      #else
        #define   _ANIMATION_ACTIVE_BIT  0
      #endif
      //BIT 4-------------------------------------------------------------
      #ifdef  _TEMPERATURE_ACTIVE_
        #define   _TEMPERATURE_ACTIVE_BIT  (1 << 4)
      #else
        #define   _TEMPERATURE_ACTIVE_BIT  0
      #endif
      //BIT 5-------------------------------------------------------------
      #ifdef  _TEXT_ANIMATIONS_ACTIVE_
        #define   _TEXT_ANIMATIONS_ACTIVE_BIT  (1 << 5)
      #else
        #define   _TEXT_ANIMATIONS_ACTIVE_BIT  0
      #endif
      //BIT 6-------------------------------------------------------------
      #ifdef  _PAGE_EFFECTS_ACTIVE_
        #define   _PAGE_EFFECTS_ACTIVE_BIT  (1 << 6)
      #else
        #define   _PAGE_EFFECTS_ACTIVE_BIT  0
      #endif
      //BIT 7-------------------------------------------------------------
      #ifdef  _STAGE_LAYOUT_ACTIVE_
        #define   _STAGE_LAYOUT_ACTIVE_BIT  (1 << 7)
      #else
        #define   _STAGE_LAYOUT_ACTIVE_BIT  0
      #endif
      //------------------------------------------------------------------

      // ** IF THIS VALUES IS CHANGED, ALSO MUST UPDATE usart_cmd_UpdateStrictLock and CheckStrictLock ** //
      //This flag byte is full - all of its 8 bits are used
      DataBuffer[29] = _TIME_ACTIVE_BIT |
                       _DATE_ACTIVE_BIT |
                       _SCROLLING_TEXT_ACTIVE_BIT |
                       _ANIMATION_ACTIVE_BIT |
                       _TEMPERATURE_ACTIVE_BIT |
                       _TEXT_ANIMATIONS_ACTIVE_BIT |
                       _PAGE_EFFECTS_ACTIVE_BIT |
                       _STAGE_LAYOUT_ACTIVE_BIT;
      
      //BIT 0-------------------------------------------------------------
      #ifdef  _TIME_SPAN_ACTIVE_
        #define   _TIME_SPAN_ACTIVE_BIT  (1 << 0)
      #else
        #define   _TIME_SPAN_ACTIVE_BIT  0
      #endif
      //BIT 1-------------------------------------------------------------
      #ifdef  _ALARM_ACTIVE_
        #define   _ALARM_ACTIVE_BIT  (1 << 1)
      #else
        #define   _ALARM_ACTIVE_BIT  0
      #endif
      //BIT 2-------------------------------------------------------------
      #ifdef  _COLOR_DISPLAY_METHOD_1_
        #define   _COLOR_DISPLAY_METHOD_1_BIT  (1 << 2)
      #else
        #define   _COLOR_DISPLAY_METHOD_1_BIT  0
      #endif
      //BIT 3-------------------------------------------------------------
      #ifdef  _COLOR_DISPLAY_METHOD_2_
        #define   _COLOR_DISPLAY_METHOD_2_BIT  (1 << 3)
      #else
        #define   _COLOR_DISPLAY_METHOD_2_BIT  0
      #endif
      //BIT 4-------------------------------------------------------------
      #ifdef  _ROWS_24_
        #define   _ROWS_24_BIT  (1 << 4)
      #else
        #define   _ROWS_24_BIT  0
      #endif
      //BIT 5-------------------------------------------------------------
      #ifdef  _ROWS_32_
        #define   _ROWS_32_BIT  (1 << 5)
      #else
        #define   _ROWS_32_BIT  0
      #endif
      //BIT 6-------------------------------------------------------------
      #ifdef  _TRIAL_LIMIT_ACTIVE_
        #define   _TRIAL_LIMIT_ACTIVE_BIT  (1 << 6)
      #else
        #define   _TRIAL_LIMIT_ACTIVE_BIT  0
      #endif
      //BIT 7-------------------------------------------------------------
      #ifdef  _THIS_IS_PORTABLE_MEMORY_
        #define   _THIS_IS_PORTABLE_MEMORY_BIT  (1 << 7)
      #else
        #define   _THIS_IS_PORTABLE_MEMORY_BIT  0
      #endif
      //------------------------------------------------------------------
      
      //This flag byte is full - all of its 8 bits are used
      // ** IF THIS VALUES IS CHANGED, ALSO MUST UPDATE usart_cmd_UpdateStrictLock and CheckStrictLock ** //
      DataBuffer[30] = _TIME_SPAN_ACTIVE_BIT |
                       _ALARM_ACTIVE_BIT |
                       _COLOR_DISPLAY_METHOD_1_BIT |
                       _COLOR_DISPLAY_METHOD_2_BIT |
                       _ROWS_24_BIT |
                       _ROWS_32_BIT |
                       _TRIAL_LIMIT_ACTIVE_BIT |
                       _THIS_IS_PORTABLE_MEMORY_BIT;
      
      //Data collected - done!
      
      SetCRC32AndSendUntilACK(DataBuffer, CONFIGURATION_DATA_SIZE);
      /*
      //Add CRC32 to DataBuffer
      crc32 = CalcCRC32(DataBuffer, CONFIGURATION_DATA_SIZE);
      DataBuffer[CONFIGURATION_DATA_SIZE + 0] = crc32;  //lowest byte first
      DataBuffer[CONFIGURATION_DATA_SIZE + 1] = crc32 >> 8;
      DataBuffer[CONFIGURATION_DATA_SIZE + 2] = crc32 >> 16;
      DataBuffer[CONFIGURATION_DATA_SIZE + 3] = crc32 >> 24;  //highest byte
      
      //Send data until ACK is received
      while(1)
      {
        delay_ms(50);
        for(i = 0; i < (CONFIGURATION_DATA_SIZE + 4); i++)
          putchar(DataBuffer[i]);
        
        delay_ms(200);  //wait for ACK or NACK to come into usart buffer
        if(!usart_char_available())
          break;
        if(getchar() == WRITE_SUCCESSFUL)
          break;
      }
      */
      
    break;
  }
}

/*OLD METHOD USING printf FUNCTION:
void usart_cmd_GetConfiguration(unsigned char data)
{
  //unsigned char EEPROMIndex;
  unsigned int Size;
  
  delay_ms(500);
  if(usart_cmd_stage == 0)
  {
    printf("[Firmware Version=%c.%c]", PROGRAM_MAJOR_VERSION_NUMBER_CHAR, PROGRAM_MINOR_VERSION_NUMBER_CHAR);
    
    //Send eeprom configuration
    printf(" <EEPROMs=%d, ICSIZE=%u>", EEPROM_IC_Count_EEP, EEPROM_IC_Size_EEP);
    /*
    printf(" <EEPROMs=%d>", EEPROM_IC_Count_EEP);
    //delay_ms(5);
    for(EEPROMIndex = 0; EEPROMIndex < EEPROM_IC_Count_EEP; EEPROMIndex++)
    {
      Size = 0;//EEPROMs[EEPROMIndex].Size;
      printf(" <E%d: Size=%u Bytes", EEPROMIndex + 1, Size);
      //delay_ms(5);
      //printf(", Address=0x%X", EEPROMs[EEPROMIndex].DeviceAddress);
      putchar('>');
      //delay_ms(5);
    }
    */
    /*
    printf(" <Clear Old Mem.=%X>", CLEAR_OLD_MEMORY_DATA);
    printf(" <Max. Rows=%d, Max. Cols=%d>", MAX_ROW_COUNT, MAX_COL_COUNT);
    printf(" <Rows=%u, Cols=%u>", ROW_COUNT, COL_COUNT);
    printf(" <Refresh=%u> <COLS NOT=%X, ROWS NOT=%X>", OCR0_VALUE, COLUMNS_NOT, ROWS_NOT);

    //Trial info
    //printf("     <Trial Limit=%u Days, Days Left=%u, Trial Enabled=%u>\n", TrialLimit, TrialLimit - TrialDaysElapsed, TrialEnabled);
    if(TrialLimit == 0 && TrialCount > 0)
      TrialCount = 0;
    if(TrialLimit < TrialCount)
      Size = 0;
    else
      Size = TrialLimit - TrialCount;
    printf(" <Trial Limit=%u Times, Times Left=%u>\n", TrialLimit, Size);

    printf(" <Temp. Offset=%d>", TemperatureOffset);
    //printf(" <Err Count=%u>", DATA_VALIDATION_ERR_COUNT);
    printf(" <OverAllSpeed=%u>", OVERALL_SPEED_SETTING);
    printf(" <Alarm Count Per Month=%u, ", MAX_ALARM_COUNT_PER_MONTH);
    #ifdef  _1_MONTH_ALARM_SYSTEM_
      printf("Alarm System=1-Month>");
    #else
      #ifdef  _12_MONTH_ALARM_SYSTEM_
        printf("Alarm System=12-Month>");
      #endif
    #endif
  }
  
  if(usart_cmd_stage != 0xff)
    usart_cmd_stage++;
}
*/

void usart_cmd_SetRefreshRate(unsigned char data)
{
  switch(usart_cmd_stage)
  {
    case 0:
      usart_cmd_stage = 1;
      break;
    case 1:
      //process received data
      OCR0_VALUE = data;
      //Force to use new refresh settings
      stop_refresh();
      start_refresh();
      usart_cmd_stage = 2;
      break;
  }
}

void usart_cmd_SetMaxSize(unsigned char data)
{
  //Removed in LDC 1.5
  /*
  switch(usart_cmd_stage)
  {
    case 0:
      break;
    case 1:
      MAX_ROW_COUNT = data;
      if(MAX_ROW_COUNT >= MAX_ROW_COUNT_FOR_ARRAY)
        MAX_ROW_COUNT = MAX_ROW_COUNT_FOR_ARRAY - 1;
      break;
    case 2:
      MAX_COL_COUNT = data;
      if(MAX_COL_COUNT >= MAX_COL_COUNT_FOR_ARRAY)
        MAX_COL_COUNT = MAX_COL_COUNT_FOR_ARRAY - 1;
      break;
  }
  */
  
  Increase_cmd_stage();
}

void usart_cmd_SetTemperatureOffset(unsigned char data)
{
  //static unsigned char low_byte;  --> ub_1

  unsigned int w;
  
  if(usart_cmd_stage == 1)
  {
    ub_1 = data;
  }
  else if(usart_cmd_stage == 2)
  {
    w = data;
    w = (w << 8) | ub_1;
    TemperatureOffset = (int) w;
  }
  
  Increase_cmd_stage();
}

/*
void usart_cmd_SetErrCounter(unsigned char data)
{
  //static unsigned char low_byte;  --> ub_1

  unsigned int w;
  
  if(usart_cmd_stage == 1)
  {
    ub_1 = data;
  }
  else if(usart_cmd_stage == 2)
  {
    w = data;
    w = (w << 8) | ub_1;
    DATA_VALIDATION_ERR_COUNT = w;
  }
  
  Increase_cmd_stage();
}
*/

void usart_cmd_Set_ROWS_NOT(unsigned char data)
{
  if(usart_cmd_stage == 1)
  {
    if(data == 0x00 || data == 0xff)
      ROWS_NOT_EEP = data;
    else
      ROWS_NOT_EEP = ROWS_NOT_EEP_DEFAULT;

    ApplyRefreshSettings();
  }
  
  Increase_cmd_stage();
}

void usart_cmd_Set_COLUMNS_NOT(unsigned char data)
{
  if(usart_cmd_stage == 1)
  {
    if(data == 0x00 || data == 0xff)
      COLUMNS_NOT_EEP = data;
    else
      COLUMNS_NOT_EEP = COLUMNS_NOT_EEP_DEFAULT;

    ApplyRefreshSettings();
  }
  
  Increase_cmd_stage();
}

void usart_cmd_Set_CLEAR_OLD_MEMORY_DATA(unsigned char data)
{
  if(usart_cmd_stage == 1)
  {
    if(data == 0x00 || data == 0xff)
      CLEAR_OLD_MEMORY_DATA = data;
    else
      CLEAR_OLD_MEMORY_DATA = CLEAR_OLD_MEMORY_DATA_DEFAULT_STATE;
  }
  
  Increase_cmd_stage();
}

void usart_cmd_Set_OVERALL_SPEED_SETTING(unsigned char data)
{
  if(usart_cmd_stage == 1)
  {
    if(data <= MAX_OVERALL_SPEED_SETTING)
    {
      OVERALL_SPEED_SETTING = data;
      OCR2 = data;
      MSElapsed_unit_ms = 1.024 * (float) (OVERALL_SPEED_SETTING - 4) / 16.0;  //number of milliseconds per tick
    }
  }
  
  Increase_cmd_stage();
}

/*
unsigned int GetEepromFontInfo(unsigned char FontIndex, eeprom unsigned char **data)
{
  unsigned int MaxSize;
  
  switch(FontIndex)
  {
    case 0:
      *data = LEDDigitsFa8_SMALL;
      MaxSize = sizeof(LEDDigitsFa8_SMALL);
      break;
    case 1:
      *data = LEDDigitsFa8;
      MaxSize = sizeof(LEDDigitsFa8);
      break;
    case 2:
      *data = LEDDigitsFa16;
      MaxSize = sizeof(LEDDigitsFa16);
      break;
    case 3:
      *data = LEDDigitsEn8_SMALL;
      MaxSize = sizeof(LEDDigitsEn8_SMALL);
      break;
    case 4:
      *data = LEDDigitsEn8;
      MaxSize = sizeof(LEDDigitsEn8);
      break;
    case 5:
      *data = LEDDigitsEn16;
      MaxSize = sizeof(LEDDigitsEn16);
      break;
    case 6:
      *data = Colon;
      MaxSize = sizeof(Colon);
      break;
    case 7:
      *data = Colon16;
      MaxSize = sizeof(Colon16);
      break;
    case 8:
      *data = Slash;
      MaxSize = sizeof(Slash);
      break;
    case 9:
      *data = Slash16;
      MaxSize = sizeof(Slash16);
      break;
    case 10:
      *data = Dash;
      MaxSize = sizeof(Dash);
      break;
    case 11:
      *data = Dash16;
      MaxSize = sizeof(Dash16);
      break;
    #ifdef  _TEMPERATURE_ACTIVE_
    case 12:
      *data = Positive;
      MaxSize = sizeof(Positive);
      break;
    case 13:
      *data = Positive16;
      MaxSize = sizeof(Positive16);
      break;
    case 14:
      *data = DegreeCentigradeSign;
      MaxSize = sizeof(DegreeCentigradeSign);
      break;
    case 15:
      *data = DegreeCentigradeSign16;
      MaxSize = sizeof(DegreeCentigradeSign16);
      break;
    case 16:
      *data = DegreeFahrenheitSign;
      MaxSize = sizeof(DegreeFahrenheitSign);
      break;
    case 17:
      *data = DegreeFahrenheitSign16;
      MaxSize = sizeof(DegreeFahrenheitSign16);
      break;
    #endif
    case 18:
      *data = LEDDigitsFa24;
      MaxSize = sizeof(LEDDigitsFa24);
      break;
    case 19:
      *data = LEDDigitsEn24;
      MaxSize = sizeof(LEDDigitsEn24);
      break;
    case 20:
      *data = Colon24;
      MaxSize = sizeof(Colon24);
      break;
    case 21:
      *data = Slash24;
      MaxSize = sizeof(Slash24);
      break;
    case 22:
      *data = Dash24;
      MaxSize = sizeof(Dash24);
      break;
    #ifdef  _TEMPERATURE_ACTIVE_
    case 23:
      *data = Positive24;
      MaxSize = sizeof(Positive24);
      break;
    case 24:
      *data = DegreeCentigradeSign24;
      MaxSize = sizeof(DegreeCentigradeSign24);
      break;
    case 25:
      *data = DegreeFahrenheitSign24;
      MaxSize = sizeof(DegreeFahrenheitSign24);
      break;
    #endif
    default:
      MaxSize = 0;
  }
  
  return(MaxSize);
}
*/

//define EEPROMFontWrite as a macro to both speed up and decrease code size
#define EEPROMFontWrite(address, data)    mem_write(address, data)

/*
void EEPROMFontWrite(unsigned int address, unsigned char data)
{
  mem_write(address, data);
}
*/

void usart_cmd_SetFontData(unsigned char data)
{
  //static unsigned char FontIndex;
  //unsigned int MemOffset;
  //eeprom unsigned char* font;
  //unsigned long crc32;
  //unsigned char FontDataSize;
  //unsigned char i;  //--> This is protected from overflow by a compiler #error directive.
  static unsigned int MemOffset;
  
  //#warning ATTENTION: Be sure to set a correct value for "MAX_FONT_DATA_SIZE". It is currently set to MAX_FONT_DATA_SIZE bytes. Also upsate the delphi program (LDC Font Manager) to use this value.
  //unsigned char DataBuffer[MAX_FONT_DATA_SIZE + 1 + 2 + 4];  //1 byte for font data size in bytes, 2 bytes for mem_start_offset, 4 bytes for CRC32
  
  //#if (MAX_FONT_DATA_SIZE + 1 + 2 + 4) >= 255
  //  #error  ERROR: The value of "MAX_FONT_DATA_SIZE" is too high for usart_cmd_SetFontData. Either use a lower value or revise the usart_cmd_SetFontData function to handle values greater than MAX_FONT_DATA_SIZE by changing data types to unsigned int.
  //#endif
  
  //static unsigned char FontIndex;
  //static unsigned char next_addr;

  //*(LEDDigitsFa8 + 3) = 1;
  
  switch(usart_cmd_stage)
  {
    case 0:
      usart_cmd_stage = 1;
      break;
    case 1:
      MemOffset = data;  //mem start offset low byte
      usart_cmd_stage = 2;
      break;
    case 2:
      MemOffset = ((unsigned int) data << 8) | MemOffset;  //mem start offset high byte
      usart_cmd_stage = 3;
      break;
    default:
      EEPROMFontWrite(MemOffset, data);
      MemOffset++;
  }
  
  /*CRC32 added - Not implemented completely in this version
  switch(usart_cmd_stage)
  {
    case 0:
      usart_cmd_stage = 1;
      break;
    case 1:
      usart_cmd_stage = 2;
      
      PORTA.7 = 1;  //It will be turned off when the operation is done completely in the handle_usart function or when the uc is reset by the watchdog timer.
      while(1)
      {
        //get data
        delay_ms(100);
        // Watchdog Timer Prescaler: OSC/2048k
        EnableWatchdog();  //Use watchdog to prevent the LED Display to hang when in the getchar() function
        #asm("wdr")
        for(i = 0; i < (MAX_FONT_DATA_SIZE + 1 + 2 + 4); i++)
        {
          #asm("wdr")
          DataBuffer[i] = getchar();
        }
        //Disable watchdog
        DisableWatchdog();
        
        //CRC32 is the last four bytes of the received data
        crc32 = DataBuffer[MAX_FONT_DATA_SIZE + 1 + 2 + 4 - 1];
        crc32 = (crc32 << 8) | DataBuffer[MAX_FONT_DATA_SIZE + 1 + 2 + 4 - 2];
        crc32 = (crc32 << 8) | DataBuffer[MAX_FONT_DATA_SIZE + 1 + 2 + 4 - 3];
        crc32 = (crc32 << 8) | DataBuffer[MAX_FONT_DATA_SIZE + 1 + 2 + 4 - 4];

        if(CalcCRC32(DataBuffer, MAX_FONT_DATA_SIZE + 1 + 2) == crc32)  //Don't include crc32 values in the crc32 calculation
        {
          FontDataSize = DataBuffer[0];
          MemOffset = ((unsigned int) DataBuffer[2] << 8) | DataBuffer[1];
          if(!TrialTimedOut())  //Check trial state
          {
            for(i = 0; i < FontDataSize; i++)
            {
              #pragma warn-  //--> Overflow of (i + 3) is prevented by a compiler #error directive.
              EEPROMFontWrite(MemOffset, DataBuffer[i + 3]);  //First 3 bytes are for FomtDataSize and MemOffset
              #pragma warn+
              
              MemOffset++;
            }
          }
          putchar(WRITE_SUCCESSFUL);
          //No need to delay - all the operation is done successfully
          break;  //Just exit the loop
        }
        else
        {
          putchar(WRITE_FAIL);
          //delay_ms(100);  --> Delay is done at the beginning of the while loop  //--> Delay only if data is invalid and need to be sent again because only one time data is sent to the LED Display
        }
      }  //while
  
  }
  */

  
  /*OLD METHOD
  if(usart_cmd_stage == 0)
  {
    //next_addr = 0;
    usart_cmd_stage = 1;
    //ClearScreen(TRUE);
    //delay_ms(100);  //Wait to completely refresh the output display with new data (screen will be cleared)
    //stop_refresh();  --> Refresh is stopped in the handle_usart() function
  }
  else if(usart_cmd_stage == 1)
  {
    FontIndex = data;
    //GetEepromFontInfo(FontIndex, &font);
    usart_cmd_stage = 2;
  }
  else
  {
    //GetEepromFontInfo(FontIndex, font);
    if(next_addr < GetEepromFontInfo(FontIndex, &font))
    {
      *(font + next_addr) = data;
      //font++;
      next_addr++;
    }
  }
  */
}

#ifdef  _ALARM_ACTIVE_

void usart_cmd_SetAlarmData(unsigned char data)
{
  //static unsigned char AlarmIndex;  --> ub_1
  //static unsigned char AlarmDataIndex;
  //unsigned char AlarmData[sizeof(TLDCAlarm)];
  //unsigned char AlarmMonth, AlarmIndex, i;
  unsigned char DataBuffer[sizeof(TLDCAlarm) + 2 + 4];  //2 bytes for AlarmIndex and AlarmMonth, 4 bytes for the crc32
  unsigned char AlarmCount, i;
  unsigned long crc32;
  
  //eeprom unsigned char *AlarmData;
  
  if(usart_cmd_stage == 0)
  {
    usart_cmd_stage = 1;
  }
  else if(usart_cmd_stage == 1)
  {
    usart_cmd_stage = 2;
    
    AlarmCount = data;
    delay_ms(100);
    PORTA.7 = 1;  //It will be turned off when the operation is done completely in the handle_usart function or when the uc is reset by the watchdog timer.
    while(AlarmCount > 0)
    {
      //get data
      // Watchdog Timer Prescaler: OSC/2048k
      EnableWatchdog();  //Use watchdog to prevent the LED Display to hang when in the getchar() function
      #asm("wdr")
      for(i = 0; i < (sizeof(TLDCAlarm) + 2 + 4); i++)
      {
        #asm("wdr")
        DataBuffer[i] = getchar();
      }
      //Disable watchdog
      DisableWatchdog();
      
      //DataBuffer[0] is AlarmIndex
      //DataBuffer[1] is AlarmMonth
      
      //CRC32 is the last four bytes of the received data
      crc32 = DataBuffer[sizeof(TLDCAlarm) + 2 + 4 - 1];
      crc32 = (crc32 << 8) | DataBuffer[sizeof(TLDCAlarm) + 2 + 4 - 2];
      crc32 = (crc32 << 8) | DataBuffer[sizeof(TLDCAlarm) + 2 + 4 - 3];
      crc32 = (crc32 << 8) | DataBuffer[sizeof(TLDCAlarm) + 2 + 4 - 4];
      
      if(CalcCRC32(DataBuffer, sizeof(TLDCAlarm) + 2) == crc32)  //Don't include crc32 values in the crc32 calculation
      {
        if(!TrialTimedOut())  //Check trial state
        {
          WriteAlarm(DataBuffer[1], DataBuffer[0], &DataBuffer[2]);
        }
        putchar(WRITE_SUCCESSFUL);
        AlarmCount--;
      }
      else
      {
        putchar(WRITE_FAIL);
      }
      delay_ms(200);
    }
  }
}

void usart_cmd_GetAlarmData(unsigned char data)
{
  //unsigned char AlarmData[sizeof(TLDCAlarm)];
  unsigned char AlarmIndex, i;
  unsigned long crc32;
  unsigned char DataBuffer[sizeof(TLDCAlarm) + 1 + 4];  //1 bytes for AlarmIndex, 4 bytes for the crc32
  TLDCAlarm *alarm;
  unsigned char ActiveAlarmCount, NumOfAlarmsToSend, NumOfAlarmsSent;
  
  switch(usart_cmd_stage)
  {
    case 0:
      usart_cmd_stage = 1;
      break;
    case 1:
      //data = AlarmMonth
      usart_cmd_stage = 2;
      
      delay_ms(10);
      //putchar(MAX_ALARM_COUNT_PER_MONTH);  //Send alarm count
      ActiveAlarmCount = CountActiveAlarms(data);
      //if(ActiveAlarmCount < 31)
      if(ActiveAlarmCount == 0)
        NumOfAlarmsToSend = 1;
      else
        NumOfAlarmsToSend = ActiveAlarmCount;
      putchar(NumOfAlarmsToSend);  //Send number of active alarms only
      delay_ms(100);
      
      alarm = (TLDCAlarm *) &DataBuffer[1];
      
      PORTA.7 = 1;  //It will be turned off when the operation is done completely in the handle_usart function or when the uc is reset by the watchdog timer.
      
      AlarmIndex = 0;
      NumOfAlarmsSent = 0;
      
      while(NumOfAlarmsSent < NumOfAlarmsToSend && AlarmIndex < MAX_ALARM_COUNT_PER_MONTH)  //Check both conditions to prevent potential software bugs
      {
        DataBuffer[0] = AlarmIndex;  //AlarmIndex
        ReadAlarm(data, AlarmIndex, &DataBuffer[1]);
        
        if(alarm->Duration == 0 && ActiveAlarmCount > 0)
        {
          AlarmIndex++;
          continue;
        }
        
        //Add CRC32
        crc32 = CalcCRC32(DataBuffer, sizeof(TLDCAlarm) + 1);
        DataBuffer[sizeof(TLDCAlarm) + 1 + 0] = crc32;
        DataBuffer[sizeof(TLDCAlarm) + 1 + 1] = crc32 >> 8;
        DataBuffer[sizeof(TLDCAlarm) + 1 + 2] = crc32 >> 16;
        DataBuffer[sizeof(TLDCAlarm) + 1 + 3] = crc32 >> 24;
        
        //Send data
        for(i = 0; i < (sizeof(TLDCAlarm) + 1 + 4); i++)
          putchar(DataBuffer[i]);
        
        delay_ms(200);
        
        // Watchdog Timer Prescaler: OSC/2048k
        EnableWatchdog();  //Use watchdog to prevent the LED Display to hang when in the getchar() function
        #asm("wdr")
        i = getchar();
        //Disable watchdog
        DisableWatchdog();
        
        if(i == WRITE_SUCCESSFUL)
        {
          NumOfAlarmsSent++;
          AlarmIndex++;
        }
        
        delay_ms(10);
      }
      break;
  }
}

void usart_cmd_Set_ALARM_CHEK_COUNTER(unsigned char data)
{
  switch(usart_cmd_stage)
  {
    case 0:
      usart_cmd_stage = 1;
      break;
    case 1:
      usart_cmd_stage = 2;
      //process received data
      ALARM_CHEK_COUNTER = data;
      break;
  }
}

#endif

#ifdef  _TRIAL_LIMIT_ACTIVE_
void usart_cmd_SetTrialLimit(unsigned char data)
{
  unsigned long TP;  //TrialPassword
  unsigned int w;
  BOOL Reset;
  
  Reset = FALSE;
  switch(usart_cmd_stage)
  {
    case 1:
      ub_1 = data;  //lowest byte
      break;
    case 2:
      if(data != ub_1)
        Reset = TRUE;
      break;
    case 3:
      ub_2 = data;
      break;
    case 4:
      if(data != ub_2)
        Reset = TRUE;
      break;
    case 5:
      ub_3 = data;
      break;
    case 6:
      if(data != ub_3)
        Reset = TRUE;
      break;
    case 7:
      // Watchdog Timer Prescaler: OSC/2048k
      EnableWatchdog();  //Use watchdog to prevent the LED Display to hang when in the getchar() function
      #asm("wdr")
      if(getchar() != data)
        Reset = TRUE;
      //Disable watchdog
      DisableWatchdog();
      
      TP = data;  //highest byte
      TP = (TP << 8) | ub_3;
      TP = (TP << 8) | ub_2;
      TP = (TP << 8) | ub_1;
      delay_ms(500);
      if(TP != TrialPassword)
      {
        usart_cmd_stage = 0xff;  //Disable settings TrialLimit if password does not match
        putchar(WRITE_FAIL);
      }
      else
      {
        putchar(WRITE_SUCCESSFUL);
      }
      break;
    case 8:
      ub_1 = data;  //low byte
      break;
    case 9:
      w = ((unsigned int) data << 8) | ub_1;
      TrialLimit = w;
      TrialCount = 0;
      break;
  }
  
  if(Reset)
    MicroReset();
  
  Increase_cmd_stage();  
}
#endif

void usart_cmd_ClearAllMemoryData(unsigned char data)
{
  unsigned long mem_addr;
  unsigned char i;
  unsigned char DummyData[MAX_EEPROM_IC_PAGE_SIZE];
  
  switch(usart_cmd_stage)
  {
    case 0:
      usart_cmd_stage = 1;
      break;
    case 1:
      usart_cmd_stage = 2;
      if(data != 0xFF)
        return;
      //Clear all the memory
      PORTA.7 = 1;  //It will be turned off when the operation is done completely in the handle_usart function.
      for(i = 0; i < MAX_EEPROM_IC_PAGE_SIZE; i++)
        DummyData[i] = 0x00;  //Reset all the memory to 0x00
      for(mem_addr = 0; mem_addr < GetMemSize(); mem_addr += (unsigned long) EEPROM_IC_PAGE_SIZE)
        mem_write_block(mem_addr, EEPROM_IC_PAGE_SIZE, DummyData);
      //Now cold reset the uc because memory buffer and other refresh settings are invalid due to changing all the data
      MicroResetCold();
      break;
  }
}

/*
This function is removed in the updates and must not be used anymore.
void usart_cmd_Set_SCROLL_STEP_ADJUST(unsigned char data)
{
  switch(usart_cmd_stage)
  {
    case 0:
      usart_cmd_stage = 1;
      break;
    case 1:
      usart_cmd_stage = 2;
      ub_1 = data;
      break;
    case 2:
      usart_cmd_stage = 3;
      if(data == ub_1)
        SCROLL_STEP_ADJUST = data;
      break;
  }
}
*/

#ifdef  _STRICT_LOCK_ACTIVE_
void GetStrictLockBytes(unsigned char *c1, unsigned char *c2, unsigned char *c3, unsigned char *c4)
{
  *c1 = LED_DISPLAY_MAX_ROW_COUNT;
  *c2 = LED_DISPLAY_MAX_COL_COUNT;
  *c3                = _TIME_ACTIVE_BIT |
                       _DATE_ACTIVE_BIT |
                       _SCROLLING_TEXT_ACTIVE_BIT |
                       _ANIMATION_ACTIVE_BIT |
                       _TEMPERATURE_ACTIVE_BIT |
                       _TEXT_ANIMATIONS_ACTIVE_BIT |
                       _PAGE_EFFECTS_ACTIVE_BIT |
                       _STAGE_LAYOUT_ACTIVE_BIT;
  *c4                = _TIME_SPAN_ACTIVE_BIT |
                       _ALARM_ACTIVE_BIT |
                       _COLOR_DISPLAY_METHOD_1_BIT |
                       _COLOR_DISPLAY_METHOD_2_BIT |
                       _ROWS_24_BIT |
                       _ROWS_32_BIT |
                       _TRIAL_LIMIT_ACTIVE_BIT |
                       _THIS_IS_PORTABLE_MEMORY_BIT;
}

void usart_cmd_UpdateStrictLock(unsigned char data)
{
  unsigned char DataBuffer[2];
  unsigned long crc32, crc32_in;
  unsigned char c, c1, c2, c3, c4;
  eeprom unsigned char *eep_byte;
  
  switch(usart_cmd_stage)
  {
    case 0:
      usart_cmd_stage = 1;
      delay_ms(500);
      
      GetStrictLockBytes(&c1, &c2, &c3, &c4);
      
      EnableWatchdog();
      #asm("wdr")  //It takes about 2 seconds to timeout, so no need to further WDR
      
      c = c1 ^ c2 ^ getchar();
      DataBuffer[0] = c;
      putchar(c);  //Send low byte

      c = c3 ^ c4 ^ getchar();
      DataBuffer[1] = c;
      putchar(c);  //Send high byte
      
      crc32 = CalcCRC32(DataBuffer, 2);
      delay_ms(100);
      
      crc32_in = getchar();
      crc32_in |= (unsigned long) getchar() << 8;
      crc32_in |= (unsigned long) getchar() << 16;
      crc32_in |= (unsigned long) getchar() << 24;
      
      DisableWatchdog();
      
      if(crc32_in != crc32)
      {
        return;
      }
      
      DisableWatchdog();
      
      eep_byte = (eeprom unsigned char *) (_INTERNAL_EEPROM_SIZE_ - 1);  //last byte of EEPROM
      *eep_byte = c1;
      
      eep_byte--;
      *eep_byte = c2;
      
      eep_byte--;
      *eep_byte = c3;
      
      eep_byte--;
      *eep_byte = c4;
      break;
  }
}

void CheckStrictLock()
{
  eeprom unsigned char *eep_byte;
  BOOL Valid;
  unsigned char c1, c2, c3, c4;
  
  GetStrictLockBytes(&c1, &c2, &c3, &c4);
  
  eep_byte = (eeprom unsigned char *) (_INTERNAL_EEPROM_SIZE_ - 1);  //last byte of EEPROM
  Valid = (*eep_byte == c1);
  eep_byte--;
  Valid = Valid && (*eep_byte == c2);
  eep_byte--;
  Valid = Valid && (*eep_byte == c3);
  eep_byte--;
  Valid = Valid && (*eep_byte == c4);
  
  if(!Valid)
  {
    delay_ms(2000);
    if(usart_char_available())
      handle_usart();
    Alert(STRICT_LOCK_ALERT);
    MicroReset();
  }
}

#endif

#ifdef  _Set_MICRO_RESET_AFTER_EACH_SHOW_ENBLED_

void usart_cmd_Set_MICRO_RESET_AFTER_EACH_SHOW(unsigned char data)
{
  switch(usart_cmd_stage)
  {
    case 0:
      usart_cmd_stage = 1;
      break;
    case 1:
      usart_cmd_stage = 2;
      ub_1 = data;
      break;
    case 2:
      usart_cmd_stage = 3;
      if(data == ub_1)
      {
        if(ub_1 == 0x00)
          MICRO_RESET_AFTER_EACH_SHOW = 0x00;  //0x00 = No (Don't Reset), Any other value = Yes (Reset)
        else
          MICRO_RESET_AFTER_EACH_SHOW = 0xFF;  //0x00 = No (Don't Reset), Any other value = Yes (Reset)
      }
      break;
  }
}

#endif

#ifdef  _TIME_SPAN_ACTIVE_
void usart_cmd_Set_Off_Time(unsigned char data)
{
  switch(usart_cmd_stage)
  {
    case 0:
      break;
    case 1:
      if(data == 0xFF)
        OffTimeDefined = TRUE;
      else
        OffTimeDefined = FALSE;
      break;
    case 2:
      OffTimeHourFrom = data;
      break;
    case 3:
      OffTimeHourTo = data;
      break;
    case 4:
      OffTimeMinuteFrom = data;
      break;
    case 5:
      OffTimeMinuteTo = data;
      break;
  }
  Increase_cmd_stage();
}

#define   OFF_TIME_SETTINGS_DATA_SIZE   5  //size of all the data bytes sent out via usart as off time settings data (in bytes)  -  If changed, also update the same value in the delphi program.
void usart_cmd_Get_Off_Time(unsigned char data)
{
  unsigned char DataBuffer[OFF_TIME_SETTINGS_DATA_SIZE + 4];  //4 bytes for CRC32];
  //unsigned long crc32;
  //unsigned char i;
  
  switch(usart_cmd_stage)
  {
    case 0:
      usart_cmd_stage = 1;
      break;
    case 1:
      usart_cmd_stage = 2;
      if(data != 0xFF)
        break;
      
      if(OffTimeDefined)
        DataBuffer[0] = 0xFF;
      else
        DataBuffer[0] = 0x00;
      DataBuffer[1] = OffTimeHourFrom;
      DataBuffer[2] = OffTimeHourTo;
      DataBuffer[3] = OffTimeMinuteFrom;
      DataBuffer[4] = OffTimeMinuteTo;
      
      SetCRC32AndSendUntilACK(DataBuffer, OFF_TIME_SETTINGS_DATA_SIZE);
      /*
      //Add CRC32 to DataBuffer
      crc32 = CalcCRC32(DataBuffer, OFF_TIME_SETTINGS_DATA_SIZE);
      DataBuffer[OFF_TIME_SETTINGS_DATA_SIZE + 0] = crc32;  //lowest byte first
      DataBuffer[OFF_TIME_SETTINGS_DATA_SIZE + 1] = crc32 >> 8;
      DataBuffer[OFF_TIME_SETTINGS_DATA_SIZE + 2] = crc32 >> 16;
      DataBuffer[OFF_TIME_SETTINGS_DATA_SIZE + 3] = crc32 >> 24;  //highest byte
      
      //Send data until ACK is received
      while(1)
      {
        delay_ms(50);
        for(i = 0; i < (OFF_TIME_SETTINGS_DATA_SIZE + 4); i++)
          putchar(DataBuffer[i]);
        
        delay_ms(200);  //wait for ACK or NACK to come into usart buffer
        if(!usart_char_available())
          break;
        if(getchar() == WRITE_SUCCESSFUL)
          break;
      }
      */
      
      break;
  }
}
#endif

void usart_cmd_SetTextScrollStep(unsigned char data)
{
  switch(usart_cmd_stage)
  {
    case 0:
      break;
    case 1:
      TextScrollStepSlow = data;
      break;
    case 2:
      TextScrollStepMedium = data;
      break;
    case 3:
      TextScrollStepFast = data;
      break;
    case 4:
      TextScrollStepVeryFast = data;
      break;
  }
  Increase_cmd_stage();
}

#define TEXT_SCROLL_STEP_SETTINGS_DATA_SIZE   4

void usart_cmd_GetTextScrollStep(unsigned char data)
{
  unsigned char DataBuffer[TEXT_SCROLL_STEP_SETTINGS_DATA_SIZE + 4];  //4 bytes for CRC32];
  //unsigned long crc32;
  //unsigned char i;
  
  switch(usart_cmd_stage)
  {
    case 0:
      usart_cmd_stage = 1;
      break;
    case 1:
      usart_cmd_stage = 2;
      if(data != 0xFF)
        break;
      
      DataBuffer[0] = TextScrollStepSlow;
      DataBuffer[1] = TextScrollStepMedium;
      DataBuffer[2] = TextScrollStepFast;
      DataBuffer[3] = TextScrollStepVeryFast;
      
      SetCRC32AndSendUntilACK(DataBuffer, TEXT_SCROLL_STEP_SETTINGS_DATA_SIZE);
      /*
      //Add CRC32 to DataBuffer
      crc32 = CalcCRC32(DataBuffer, TEXT_SCROLL_STEP_SETTINGS_DATA_SIZE);
      DataBuffer[TEXT_SCROLL_STEP_SETTINGS_DATA_SIZE + 0] = crc32;  //lowest byte first
      DataBuffer[TEXT_SCROLL_STEP_SETTINGS_DATA_SIZE + 1] = crc32 >> 8;
      DataBuffer[TEXT_SCROLL_STEP_SETTINGS_DATA_SIZE + 2] = crc32 >> 16;
      DataBuffer[TEXT_SCROLL_STEP_SETTINGS_DATA_SIZE + 3] = crc32 >> 24;  //highest byte
      
      //Send data until ACK is received
      while(1)
      {
        delay_ms(50);
        for(i = 0; i < (TEXT_SCROLL_STEP_SETTINGS_DATA_SIZE + 4); i++)
          putchar(DataBuffer[i]);
        
        delay_ms(200);  //wait for ACK or NACK to come into usart buffer
        if(!usart_char_available())
          break;
        if(getchar() == WRITE_SUCCESSFUL)
          break;
      }
      */
      
      break;
  }
}
