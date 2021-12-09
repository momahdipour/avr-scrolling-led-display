/* External EEPROM access routines */

// **** Maximum size of each eeprom is 65535(0xFFFF). ****
typedef struct {
  //unsigned int Size;  //in bytes
  //unsigned char DeviceAddress;  //I2C Device Address
  unsigned long TotalSizeUntil;  //Total size until this eeprom including this eeprom
} TEEPROMSettings;

eeprom unsigned int EEPROM_IC_Size_EEP = 8192;//2048 = AT24C16, 4096 = AT24C32, 8192 = AT24C64, 65536-1 = AT24C512  //AT24C64 - in bytes - can be set via usart command usart_cmd_SetEEPROMs - AT24C32 = 4KB (minimum reasonable memory)
unsigned int EEPROM_IC_Size;
unsigned char EEPROM_IC_PAGE_SIZE = 128;
eeprom unsigned char EEPROM_IC_Count_EEP = 1;  //min 1, up to MAX_EEPROM_COUNT EEPROM ICs can be connected

TEEPROMSettings EEPROMs[MAX_EEPROM_COUNT];

typedef struct {
  unsigned long int start_addr;
  unsigned char data[CACHE_SIZE];
} TMemCache;

unsigned char EEPROM_BUS_ADDRESS;
TMemCache caches[CACHE_COUNT];

unsigned long GetMemSize()
{
  //return(EEPROMs[MAX_EEPROM_COUNT - 1].TotalSizeUntil);
  return((unsigned long) EEPROM_IC_Count_EEP * (unsigned long) EEPROM_IC_Size);
}

void mem_init()
{
  char i;
  unsigned int ICSize;
  unsigned char ICCount;
  
  EEPROM_IC_Size = EEPROM_IC_Size_EEP;
  
  if(EEPROM_IC_Size <= 2048)
    EEPROM_IC_PAGE_SIZE = 16;
  else if(EEPROM_IC_Size <= 8192)
    EEPROM_IC_PAGE_SIZE = 32;
  else if(EEPROM_IC_Size <= 32768)
    EEPROM_IC_PAGE_SIZE = 64;
  else
    EEPROM_IC_PAGE_SIZE = MAX_EEPROM_IC_PAGE_SIZE;  //=128; Greater than the value of MAX_EEPROM_IC_PAGE_SIZE is not allowed
  
  ICCount = EEPROM_IC_Count_EEP;
  
  for(i = 0; i < CACHE_COUNT; i++)
    caches[i].start_addr = 0xffffffff;
  
  if(ICCount >= 1)
    ICSize = EEPROM_IC_Size;
  else
    ICSize = 0;
  EEPROMs[0].TotalSizeUntil = ICSize;
  for(i = 1; i < MAX_EEPROM_COUNT; i++)
  {
    if(ICCount > i)
      ICSize = EEPROM_IC_Size;
    else
      ICSize = 0;
    EEPROMs[i].TotalSizeUntil = EEPROMs[i - 1].TotalSizeUntil + (unsigned long) ICSize;
  }
}

char eeprom_read(unsigned int address){
	char data;
	i2c_start();
	i2c_write(EEPROM_BUS_ADDRESS);
	i2c_write(address>>8);
	i2c_write(address);
	i2c_start();
	i2c_write(EEPROM_BUS_ADDRESS | 1);
	data=i2c_read(0);
	i2c_stop();
	return data;
}

void eeprom_write(unsigned int address, char data){
	i2c_start();
	i2c_write(EEPROM_BUS_ADDRESS);
	i2c_write(address>>8);
	i2c_write(address);
	i2c_write(data);
	i2c_stop();
	/* delay to complete the write operation */
	delay_ms(EEPROM_WRITE_DELAY);
}

/*
void CalcTotalEEPROMsSize(unsigned char EEPROMIndex, unsigned long *ICSize)
{
  unsigned char i;
  
  ICSize = 0;
  for(i = 0; i < EEPROMIndex; i++)
    ICSize += EEPROMs[i].Size;
}
*/

unsigned int MapMemoryAddress(unsigned long int addr, unsigned int *ICSize)
{
  unsigned char EEPROMIndex;
  unsigned long TotalICSize;
  
  if( addr < EEPROMs[0].TotalSizeUntil)
  {
    EEPROMIndex = 0;
    EEPROM_BUS_ADDRESS = 0xa0;
    //return addr;
  }
  else if( addr < (EEPROMs[1].TotalSizeUntil - 1) )
  {
    EEPROMIndex = 1;
    EEPROM_BUS_ADDRESS = 0xa2;
    //return addr - ICSIZE;
  }
  else if( addr < (EEPROMs[2].TotalSizeUntil - 1) )
  {
    EEPROMIndex = 2;
    EEPROM_BUS_ADDRESS = 0xa4;
    //return addr - 2 * ICSIZE;
  }
  else if( addr < (EEPROMs[3].TotalSizeUntil - 1) )
  {
    EEPROMIndex = 3;
    EEPROM_BUS_ADDRESS = 0xa6;
    //return addr - 3 * ICSIZE;
  }
  else
  {
    EEPROMIndex = 4;
    EEPROM_BUS_ADDRESS = 0xa8;
    //return addr - 4 * ICSIZE;
  }

  //*ICSize = EEPROMs[EEPROMIndex].Size;
  *ICSize = EEPROM_IC_Size;
  
  //EEPROM_BUS_ADDRESS = EEPROMs[EEPROMIndex].DeviceAddress;
  
  //TotalICSize = EEPROMs[EEPROMIndex].TotalSizeUntil - EEPROMs[EEPROMIndex].Size;
  TotalICSize = EEPROMs[EEPROMIndex].TotalSizeUntil - EEPROM_IC_Size;
  
  //CalcTotalEEPROMsSize(EEPROMIndex, &TotalICSize);
  return addr - TotalICSize;
}

unsigned char mem_read(unsigned long int addr)
{
  unsigned int actual_addr;
  unsigned int ICSize;
  
  actual_addr = MapMemoryAddress(addr, &ICSize);
  return eeprom_read(actual_addr);
}

void mem_write(unsigned long int addr, unsigned char data)
{
  unsigned int actual_addr;
  unsigned int ICSize;
  
  actual_addr = MapMemoryAddress(addr, &ICSize);
  eeprom_write(actual_addr, data);
}

void mem_read_block(unsigned long int start_addr, unsigned int size, unsigned char data[])
{
  //IMPORTANT NOTE: Data to be read can be distributed at most between 2 EEPROM ICs
  
  unsigned int actual_addr;
  unsigned int offset, read_size1, read_size2;
  unsigned int ICSize;
  
  actual_addr = MapMemoryAddress(start_addr, &ICSize);
  
  read_size1 = ICSize - actual_addr;
  if(read_size1 >= size)
  {
    read_size1 = size;
    read_size2 = 0;
  }
  else
  {
    read_size2 = size - read_size1;
  }
  
	i2c_start();
	i2c_write(EEPROM_BUS_ADDRESS);
	i2c_write(actual_addr>>8);
	i2c_write(actual_addr);
	i2c_start();
	i2c_write(EEPROM_BUS_ADDRESS | 1);
	
	for(offset = 0; offset < (read_size1 - 1); offset++)
	{
	  data[offset] = i2c_read(1);  //send ack to read next sequential byte
	}
	data[offset] = i2c_read(0);  //no ack
	
	if(read_size2 > 0)
	{
    actual_addr = MapMemoryAddress(start_addr + read_size1, &ICSize);  //Next memory address
  	i2c_start();
  	i2c_write(EEPROM_BUS_ADDRESS);
  	i2c_write(actual_addr>>8);
  	i2c_write(actual_addr);
  	i2c_start();
  	i2c_write(EEPROM_BUS_ADDRESS | 1);
  	
  	for(offset++; offset < (size - 1); offset++)
  	{
  	  data[offset] = i2c_read(1);  //send ack to read next sequential byte
  	}
  	data[offset] = i2c_read(0);  //no ack
  }
}

void mem_write_block(unsigned long int start_addr, unsigned char size, unsigned char data[])
{
  #warning IMPORTANT ATTENTION: Usage requirements of the "mem_write_block" function must be checked.
  //IMPORTANT NOTES TO USE THIS FUNCTION:
  //  1. start_addr must be address of the beginning of a page in the EEPROM IC
  //  2. size must be exactly equal to size of a page on the EEPROM IC (i.e. max 128)
  //  3. Currently this function is only for use in the usart_cmd_SetMemoryData function
  unsigned int offset;
  unsigned int PageStartAddr;
  unsigned int ICSize;
  
  PageStartAddr = MapMemoryAddress(start_addr, &ICSize);
  
  i2c_start();
  i2c_write(EEPROM_BUS_ADDRESS);
  i2c_write(PageStartAddr >> 8);
  i2c_write(PageStartAddr);

	for(offset = 0; offset < size; offset++)
	{
	  i2c_write(data[offset]);
	  //delay_ms(10);
	}
	
	i2c_stop();
	/* delay to complete the write operation */
	delay_ms(EEPROM_WRITE_DELAY);
}

/*
void mem_write_block_f(unsigned long int start_addr, unsigned int size, flash unsigned char data[])
{
  //--> This function must be rewritten and be optimized for higher efficiency
  unsigned int offset;
  
  for(offset = 0; offset < size; offset++)
  {
    mem_write(start_addr + offset, data[offset]);
  }
}
*/

unsigned char mem_find_unused_cache()
{
  static unsigned char replaced_cache = 0;
  
  replaced_cache++;
  if(replaced_cache >= CACHE_COUNT)
    replaced_cache = 0;
  return(replaced_cache);
}

unsigned char mem_read_cache(unsigned long int addr)
{
  char i;
  
  for(i = 0; i < CACHE_COUNT; i++)
  {
    if( addr >= caches[i].start_addr && addr < (caches[i].start_addr + CACHE_SIZE) )
    {
      return(caches[i].data[addr - caches[i].start_addr]);
    }
  }
  //Data not in caches
  i = mem_find_unused_cache();
  mem_read_block(addr, CACHE_SIZE, &caches[i].data[0]);
  caches[i].start_addr = addr;
  return(caches[i].data[0]);
}

/*
void ClearMemory(unsigned long start_addr)
{
  //unsigned long addr;
  unsigned long end_addr, temp;
  
  //  ** Only clear next 500 bytes (about 5 seconds)  **
  //  ** In next versions use Page Write mode.        **

    end_addr = EEPROMs[EEPROM_IC_Count_EEP - 1].TotalSizeUntil - 1;
    temp = start_addr + 500 - 1;
    if(temp < end_addr)
      end_addr = temp;
  
  
  for(temp = start_addr; temp <= end_addr; temp++)
    mem_write(temp, 0);
}
*/

void ClearMemoryFast(unsigned long start_addr, unsigned int NumBytesToClear)
{
  //start_addr must be the first byte of a page in the EEPROM IC memory
  
  unsigned char DataBuffer[MAX_EEPROM_IC_PAGE_SIZE];
  unsigned char i;
  unsigned int BytesWritten = 0;
  
  #if MAX_EEPROM_IC_PAGE_SIZE > 254
    #error ERROR: If you want to use EEPROM ICs with page size greater than 254 bytes, you must update the function ClearMemoryFast to support greater values (convert unsigned char to unsigned int).
  #endif
  
  //Fill write buffer with 0
  for(i = 0; i < MAX_EEPROM_IC_PAGE_SIZE; i++)
  {
    DataBuffer[i] = 0;
  }
  
  //Write page by page
  while(start_addr < GetMemSize() && BytesWritten < NumBytesToClear)
  {
    mem_write_block(start_addr, EEPROM_IC_PAGE_SIZE, DataBuffer);
    start_addr += (unsigned long) EEPROM_IC_PAGE_SIZE;
    BytesWritten += (unsigned int) EEPROM_IC_PAGE_SIZE;
  }
}
 