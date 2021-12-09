//Routines for sending stored data to the LED Display (or maybe another portable memory!)

BOOL CheckUSARTByte(unsigned char CheckByte1, unsigned char CheckByte2)
{
  unsigned char c;
  
  EnableWatchdog();
  c = getchar();
  DisableWatchdog();
  if(c == CheckByte1 && c == CheckByte2)
    return(TRUE);
  else
    return(FALSE);
}

void SendMemoryDataFast()
{
  unsigned long int mem_addr;
  unsigned char c, c1, c2;
  unsigned long crc32;
  unsigned char ICPageSize;
  unsigned char i;
  unsigned long SendBytesCount = 0;
  
  unsigned char DataBuffer[MAX_EEPROM_IC_PAGE_SIZE + 4];  //plus 4 bytes for the crc32
  
  //==================================================================================================================
  //============                                                                                          ============
  //==================================================================================================================
  //Send data via serial port
  putchar(USART_INIT_BYTE_1);
  putchar(USART_INIT_BYTE_2);
  putchar(USART_CMD_SET_MEMORY_DATA);
  
  if(!CheckUSARTByte(USART_INIT_BYTE_1, USART_INIT_BYTE_1)) return;
  if(!CheckUSARTByte(USART_INIT_BYTE_2, USART_INIT_BYTE_2)) return;
  if(!CheckUSARTByte(USART_CMD_SET_MEMORY_DATA, USART_CMD_SET_MEMORY_DATA)) return;
  
  //DEBUG
  //StartLEDBlink(7);
  //delay_ms(10000);
  
  //Check Firmware Version
  EnableWatchdog();
  c1 = getchar();
  c2 = getchar();
  DisableWatchdog();
  
  if(c1 != PROGRAM_MAJOR_VERSION_NUMBER_CHAR && c1 != '0') return;  //0.0 should also be supported
  if(c2 != PROGRAM_MINOR_VERSION_NUMBER_CHAR && c2 != '0') return;
  
  putchar(c1);
  putchar(c2);
  
  EnableWatchdog();
  c = getchar();
  DisableWatchdog();
  
  if(c != USART_CMD_SET_MEMORY_DATA) return;
  //==================================================================================================================
  //============        HANDSHAKING WITH LED DISPLAY DONE HERE - NOW FROM THIS POINT, DO OUR WORK         ============
  //==================================================================================================================
  
  //Receive IC page size 5 times - all the bytes must be equal, otherwise an error has been occurred and must not continue
  EnableWatchdog();
  c = getchar();  //receive firs byte
  for(i = 0; i < 4; i++)  //receive next 4 bytes
  {
    if(getchar() != c)
    {
      DisableWatchdog();
      return;
    }
  }
  DisableWatchdog();
  //Page size received correctly - now c contains IC Page Size
  
  ICPageSize = c;
  mem_addr = 0;
  
  while(SendBytesCount < TotalDisplayDataReceivedBytes)
  {
    putchar(ICPageSize);  //Send page size
    
    //Prepare data buffer
    mem_read_block(mem_addr, ICPageSize, &DataBuffer[4]);  //Fisrt 4 bytes of the data buffer are for crc32
    //add crc32
    crc32 = CalcCRC32(&DataBuffer[4], ICPageSize);
    DataBuffer[0] = crc32;  //lowest byte
    DataBuffer[1] = crc32 >> 8;
    DataBuffer[2] = crc32 >> 16;
    DataBuffer[3] = crc32 >> 24;  //highest byte
    
    //Send data
    for(i = 0; i < (ICPageSize + 4); i++)  //4 bytes for crc32
      putchar(DataBuffer[i]);
    
    //Wait for ACK or NACK
    EnableWatchdog();
    c = getchar();
    DisableWatchdog();
    if(c == WRITE_SUCCESSFUL)
    {
      SendBytesCount += (unsigned long) ICPageSize;
      mem_addr += (unsigned long) ICPageSize;
    }
  }
}
