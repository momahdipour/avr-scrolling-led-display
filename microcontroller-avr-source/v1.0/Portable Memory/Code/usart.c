

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

// USART Receiver buffer
#define RX_BUFFER_SIZE 200
char rx_buffer[RX_BUFFER_SIZE];

#if RX_BUFFER_SIZE<256
unsigned char rx_wr_index,rx_rd_index,rx_counter;
#else
unsigned int rx_wr_index,rx_rd_index,rx_counter;
#endif

// This flag is set on USART Receiver buffer overflow
bit rx_buffer_overflow;

// USART Receiver interrupt service routine
interrupt [USART_RXC] void usart_rx_isr(void)
{
char status,data;
status=UCSRA;
data=UDR;
if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
   {
   rx_buffer[rx_wr_index]=data;
   if (++rx_wr_index == RX_BUFFER_SIZE) rx_wr_index=0;
   if (++rx_counter == RX_BUFFER_SIZE)
      {
      rx_counter=0;
      rx_buffer_overflow=1;
      };
   };
}

#ifndef _DEBUG_TERMINAL_IO_
// Get a character from the USART Receiver buffer
#define _ALTERNATE_GETCHAR_
#pragma used+
char getchar(void)
{
char data;
while (rx_counter==0);
data=rx_buffer[rx_rd_index];
if (++rx_rd_index == RX_BUFFER_SIZE) rx_rd_index=0;
#asm("cli")
--rx_counter;
#asm("sei")
return data;
}
#pragma used-
#endif

char usart_char_available()
{
  return(rx_counter > 0);
}

//USART global variables
unsigned char usart_cmd_stage;

//USART initialization bytes
#define   USART_INIT_BYTE_1    0xED
#define   USART_INIT_BYTE_2    0xCB

//==============================================
//Supported USART commadn in the portable memory
#define   USART_CMD_SET_MEMORY_DATA     0x11
#define   USART_CMD_GET_MEMORY_DATA     0xa2
#define   USART_CMD_SET_EERPOM          0xb1
#define   USART_CMD_SET_ALARM_DATA      0x33
#define   USART_CMD_GET_ALARM_DATA      0xd8
#define   USART_CMD_CLEAR_ALL_MEMORY    0xe2
#define   USART_CMD_GET_CONFIGURATION   0xb2
//==============================================

void usart_cmd_SetMemoryData(unsigned char data);
void usart_cmd_GetMemoryData(unsigned char data);
void usart_cmd_SetEEPROMs(unsigned char data);
//void usart_cmd_SetAlarmData(unsigned char data);
//void usart_cmd_GetAlarmData(unsigned char data);
void usart_cmd_ClearAllMemoryData(unsigned char data);
void usart_cmd_GetConfiguration(unsigned char data);

void execute_usart_cmd(unsigned char usart_cmd, unsigned char data)
{
  switch(usart_cmd)
  {
    case USART_CMD_SET_MEMORY_DATA:
      usart_cmd_SetMemoryData(data);
      break;
    case USART_CMD_GET_MEMORY_DATA:
      usart_cmd_GetMemoryData(data);
      break;
    case USART_CMD_SET_EERPOM:
      usart_cmd_SetEEPROMs(data);
      break;
    /*
    case USART_CMD_SET_ALARM_DATA:
      usart_cmd_SetAlarmData(data);
      break;
    case USART_CMD_GET_ALARM_DATA:
      usart_cmd_GetAlarmData(data);
      break;
    */
    case USART_CMD_CLEAR_ALL_MEMORY:
      usart_cmd_ClearAllMemoryData(data);
      break;
    case USART_CMD_GET_CONFIGURATION:
      usart_cmd_GetConfiguration(data);
      break;
  }
}

unsigned char IsSupportedCommand(unsigned char command)
{
  unsigned char ValidCommand = 0;
  switch(command)
  {
    case USART_CMD_SET_MEMORY_DATA:
    case USART_CMD_GET_MEMORY_DATA:
    case USART_CMD_SET_EERPOM:
    //case USART_CMD_SET_ALARM_DATA:
    //case USART_CMD_GET_ALARM_DATA:
    case USART_CMD_CLEAR_ALL_MEMORY:
    case USART_CMD_GET_CONFIGURATION:
      ValidCommand = 1;
      break;
  }
  
  return(ValidCommand == 1);
}

void reset_usart_buffer()
{
  while(usart_char_available())
  {
    getchar();
  }
}

//=========================================
bit DataMemoryChanged = 0;
bit MemoryDataOverlow = 0;

unsigned long MemoryData_next_addr;

unsigned char ub_1;  //usart byte 1
//unsigned char ub_2;  //usart byte 2
//unsigned char ub_3;  //usart byte 3
//=========================================

#define   FIRMWARE_VERSION_CHECK

void handle_usart()
{
  unsigned char c, command;
  //unsigned long eeprom_clear_addr;
  
  //pulse(500);
  
  PORTD.4 = 0;
  delay_ms(150);
  PORTD.4 = 1;  //Indicate receipt of USART data (This does not mean receipt of correct data.)
  delay_ms(150);  //THIS DELAY IS NECESSARY NOT FOR DEBUG: Wait for the initialization data (3 bytes) to come into cache (:: avoid usart_char_available() to return no data is available.)
  PORTD.4 = 0;  //Turn the LED off and continue
  
  c = getchar();
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
  if(IsSupportedCommand(command))
  {
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
  }
  else
  {
    return;
  }
  
  //Now go on!
  usart_cmd_stage = 0;
  execute_usart_cmd(command, command);
  
  //commands initialization
  PORTD.4 = 1;
  StartLEDBlink(LED_BLINK_SPEED_FOR_RECEIVE);
  
  rx_buffer_overflow = 0;
  
  //upon any change in the memory data, make old stored data invalid
  if(command == USART_CMD_SET_MEMORY_DATA ||
     command == USART_CMD_SET_EERPOM ||
     command == USART_CMD_CLEAR_ALL_MEMORY ||
     command == USART_CMD_SET_ALARM_DATA)
  {
    if(TotalDisplayDataReceivedBytes != 0)  //Write to eeprom only if the values are not same
      TotalDisplayDataReceivedBytes = 0;
    if(TotalAlarmCountReceived != 0)  //Write to eeprom only if the values are not same
      TotalAlarmCountReceived = 0;
  }
  
  TCNT1 = 0;
  reset_flag = 0;
  
  while(1)
  {
    while(!usart_char_available() && reset_flag == 0)
    {
    }
    
    if(!usart_char_available())
      break;
    
    c = getchar();
    
    execute_usart_cmd(command, c);
    
    TCNT1 = 0;
    reset_flag = 0;
  }
  
  StopLEDBlink();
  
  if(rx_buffer_overflow == 1)
  {
    //ResetMemoryData(FALSE);  -> Not for portable memory
    Alert(USART_BUFFER_OVERFLOW_ALERT);
    printf("USART Buffer overflow");
    return;  //return because of a critical error
  }
  else if(DataMemoryChanged == 1)
  {
    if(MemoryDataOverlow == 1)
    {
      //ResetMemoryData(FALSE);  -> Not for portable memory
      Alert(MEMORY_DATA_OVERFLOW_ALERT);
      printf("Memory Data Overflow");
      return;  //return because of a critical error
    }
  }
  
  if(command == USART_CMD_SET_MEMORY_DATA)// && CLEAR_OLD_MEMORY_DATA)
  {
    TotalDisplayDataReceivedBytes = MemoryData_next_addr;
    PORTD.4 = 1;
    //Now MemoryData_next_addr points to the first byte of the next page in the memory
    ClearMemoryFast(MemoryData_next_addr, NUM_OF_BYTES_TO_CLEAR_AFTER_SET_MEMORY);
  }
  else if(command == USART_CMD_SET_ALARM_DATA)
  {
    //NOT IMPLEMENTED YET
  }
}

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
  
  unsigned char DataBuffer[MAX_EEPROM_IC_PAGE_SIZE + 4];  //plus 4 bytes for the crc32
  
  //PageSize = EEPROM_IC_PAGE_SIZE;
  
  if(usart_cmd_stage == 0)
  {
    if(TotalDisplayDataReceivedBytes != 0)  //Write to eeprom only if the values are not same
      TotalDisplayDataReceivedBytes = 0;
    
    MemoryData_next_addr = MEM_START_OFFSET;  //must be a multiple of PageSize
    usart_cmd_stage = 1;
    //ClearScreen(TRUE);  --> Invalid in portable memory
    //delay_ms(100);  --> No need because we will wait in the following instruction  //Wait to completely refresh the output display with new data (screen will be cleared)
    
    //Send page size 5 times to prevent communication errors
    delay_ms(500);  //--> This delay is also used to completely refresh the output screen with new data (cleared screen)
    for(i = 0; i < 5; i++)
      putchar(EEPROM_IC_PAGE_SIZE);
    
    //stop_refresh();  --> Refresh is stopped in the handle_usart() function
  }
  else
  {
    //if(data != PageSize)
    if(data != EEPROM_IC_PAGE_SIZE)
    {
      delay_ms(1000);
      putchar(WRITE_FAIL);
      return;
    }
    
    DataMemoryChanged = 1;
    
    //get data
    // Watchdog Timer Prescaler: OSC/2048k
    WDTCR=0x0F;  //Use watchdog to prevent the LED Display to hang when in the getchar() function
                 //Use max time for watchdog timer (OSC/2048k = about 2.1 seconds)
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
    
    if(CalcCRC32(&DataBuffer[4], EEPROM_IC_PAGE_SIZE) == crc32)  //Don't include crc32 values in the crc32 calculation
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
      PORTD.4 = 1;  //Upon failure, turn on the LED to show activity. It will be turned off when the operation is done completely in the handle_usart function or when the uc is reset by the watchdog timer.
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
    PORTD.4 = 1;  //It will be turned off when the operation is done completely in the handle_usart function.
    switch(data)
    {
      case 0x00:  //Get internal EEPROM data
        #ifdef  _CHIP_ATMEGA32_
          InternalEEPROMSize = 1 * 1024;  //1KB for Mega32
          #else
            #ifdef  _CHIP_ATMEGA64_
              InternalEEPROMSize = 2 * 1024;  //2KB for Mega64
            #else
              #ifdef  _CHIP_ATMEGA128_
                InternalEEPROMSize = 4 * 1024;  //4KB for Mega128
              #else
                #ifdef  _CHIP_ATMEGA8_
                  InternalEEPROMSize = 512;  //512 bytes for Mega8
                #else
                  #error ERROR: Chip type not supported by the usart_cmd_GetMemoryData function. Please change this function to support selected chip.
                #endif
              #endif
            #endif
        #endif
        
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
  
  if(usart_cmd_stage != 0xff)
    usart_cmd_stage++;
}

/*
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
    PORTD.4 = 1;  //It will be turned off when the operation is done completely in the handle_usart function or when the uc is reset by the watchdog timer.
    while(AlarmCount > 0)
    {
      //get data
      // Watchdog Timer Prescaler: OSC/2048k
      WDTCR=0x0F;  //Use watchdog to prevent the LED Display to hang when in the getchar() function
                   //Use max time for watchdog timer (OSC/2048k = about 2.1 seconds)
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
      
      PORTD.4 = 1;  //It will be turned off when the operation is done completely in the handle_usart function or when the uc is reset by the watchdog timer.
      
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
        WDTCR=0x0F;  //Use watchdog to prevent the LED Display to hang when in the getchar() function
                     //Use max time for watchdog timer (OSC/2048k = about 2.1 seconds)
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
*/

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
      PORTD.4 = 1;  //It will be turned off when the operation is done completely in the handle_usart function.
      for(i = 0; i < MAX_EEPROM_IC_PAGE_SIZE; i++)
        DummyData[i] = 0x00;  //Reset all the memory to 0x00
      for(mem_addr = 0; mem_addr < GetMemSize(); mem_addr += (unsigned long) EEPROM_IC_PAGE_SIZE)
        mem_write_block(mem_addr, EEPROM_IC_PAGE_SIZE, DummyData);
      //Now cold reset the uc because memory buffer and other refresh settings are invalid due to changing all the data
      MicroResetCold();
      break;
  }
}

#define   CONFIGURATION_DATA_SIZE   31  //size of all the data bytes sent out via usart as configuration data (in bytes)
void usart_cmd_GetConfiguration(unsigned char data)
{
  #pragma warn-  //--> Works only in function level!
  unsigned int Size; /*always must be unsigned int*/  //--> This variable may not be used when some capabilities are inactive, so prevent from shoing a 'unreferenced local variable' warning.
  #pragma warn+
  unsigned char DataBuffer[CONFIGURATION_DATA_SIZE + 4];  //4 bytes for CRC32
  unsigned long crc32;
  unsigned char i;
  
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
      
      DataBuffer[5] = 0xFF;//CLEAR_OLD_MEMORY_DATA;  //Clear Old Memory
      
      DataBuffer[6] = 0;//MAX_ROW_COUNT;
      DataBuffer[7] = 0;//MAX_COL_COUNT;
      DataBuffer[8] = 0;//ROW_COUNT;
      DataBuffer[9] = 0;//COL_COUNT;
      
      DataBuffer[10] = 0;//OCR0_VALUE;  //Refresh rate
      
      DataBuffer[11] = 0;//COLUMNS_NOT;
      DataBuffer[12] =  0;//ROWS_NOT;
      
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
      
      DataBuffer[19] = 0;//OVERALL_SPEED_SETTING;  //Overall Speed Setting
      
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
      
      DataBuffer[22] = 0;//SCROLL_STEP_ADJUST;  //text scroll step adjust
      
      DataBuffer[23] = 0;//LED_DISPLAY_MAX_ROW_COUNT;
      DataBuffer[24] = 0;//LED_DISPLAY_MAX_COL_COUNT;
      
      DataBuffer[25] = 0;//DEFAULT_ALARM_CHEK_COUNTER;
      
      DataBuffer[26] = MAX_EEPROM_IC_PAGE_SIZE;
      
      DataBuffer[27] = EEPROM_WRITE_DELAY;
      
      DataBuffer[28] = 0;//MAX_CONTENT_SETTINGS_SIZE;
      
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
      DataBuffer[30] = _TIME_SPAN_ACTIVE_BIT |
                       _ALARM_ACTIVE_BIT |
                       _COLOR_DISPLAY_METHOD_1_BIT |
                       _COLOR_DISPLAY_METHOD_2_BIT |
                       _ROWS_24_BIT |
                       _ROWS_32_BIT |
                       _TRIAL_LIMIT_ACTIVE_BIT |
                       _THIS_IS_PORTABLE_MEMORY_BIT;
      
      //Data collected - done!
      
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
      
    break;
  }
}
