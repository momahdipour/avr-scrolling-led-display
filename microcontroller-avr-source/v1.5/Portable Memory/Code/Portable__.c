/*****************************************************
This program was produced by the
CodeWizardAVR V1.25.8 Professional
Automatic Program Generator
© Copyright 1998-2007 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project :
Version :
Date    : 2008/08/19
Author  : F4CG
Company : F4CG
Comments:


Chip type           : ATmega8
Program type        : Application
Clock frequency     : 12.000000 MHz
Memory model        : Small
External SRAM size  : 0
Data Stack size     : 256
*****************************************************/

#include <mega8.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
#include <delay.h>

#include "pconfig.c"
#include "config.c"
//CONFIGURATION
#define     _FULL_LATCH_  //This must only be activated in single-color mode

//Portable memory configuration values

//Only should be defined for the portable memory program - this is used in the function usart_cmd_GetConfiguration.
#define     _THIS_IS_PORTABLE_MEMORY_

#define   MAX_EEPROM_IC_PAGE_SIZE   128  //128 for 512Kbs IC
#define   MEM_START_OFFSET          0  //MEM_START_OFFSET is always 0 in the portable memory

#ifdef    _FULL_LATCH_

#define   PROGRAM_MAJOR_VERSION_NUMBER_CHAR     '3'
#define   PROGRAM_MINOR_VERSION_NUMBER_CHAR     '0'

#else

#define   PROGRAM_MAJOR_VERSION_NUMBER_CHAR     '1'
#define   PROGRAM_MINOR_VERSION_NUMBER_CHAR     '5'

#endif

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
//#include "defs.c"


//#include <debug.c>

//--------------------
//Type definitions

#define TRUE (1==1)
#define FALSE (1==0)
typedef char BOOL;

//--------------------


///////////////////////////////////////////////////////////////
// ** --> This structure must be eaxctly the same as in the main microcontroller program
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


/////////////////////////////////////////////////////////////////////////
//Watchdog timer enabling and disabling routines for different chip types
#ifdef  _CHIP_ATMEGA16_
  #define   EnableWatchdog()        WDTCR=0x0F
  #define   EnableWatchdogShort()   WDTCR=0x08  //Watchdog Timer Prescaler: OSC/16k (OSC/2048k = about 2.1 seconds)

WDTCR=;
#endif
#ifdef  _CHIP_ATMEGA32_
  #define   EnableWatchdog()        WDTCR=0x0F
  #define   EnableWatchdogShort()   WDTCR=0x08  //Watchdog Timer Prescaler: OSC/16k (OSC/16k = about 16.3 milliseconds)
#endif

#ifndef EnableWatchdog()
  #ifndef _CHIP_ATMEGA8_
    #ifndef _CHIP_ATMEGA64_
      #ifndef _CHIP_ATMEGA128_
        #error ERROR: Unsupported chip for the function EnableWatchdog(). Please update this function to support this new chip.
      #endif
    #endif
  #endif
#endif
#ifndef EnableWatchdog()
//EnableWatchdog() is the same for Mega8, Mega64, and Mega128
void EnableWatchdog()
{
  // Watchdog Timer Prescaler: OSC/2048k
  //Use max time for watchdog timer (OSC/2048k = about 2.1 seconds)
  #asm("cli")
  WDTCR=0x1F;  //Enable change
  WDTCR=0x0F;
  #asm("wdr")
  #asm("sei")
}

void EnableWatchdogShort()
{
  // Watchdog Timer Prescaler: OSC/16k
  //Use max time for watchdog timer (OSC/16k = about 16.3 milliseconds)
  #asm("cli")
  WDTCR=0x18;
  WDTCR=0x08;
  #asm("wdr")
  #asm("sei")
}
#endif

void DisableWatchdog()
{
  #asm("cli")
  WDTCR |= (1<<4) | (1<<3);  //Don't change prescalar by settings only these two bits
  WDTCR = 0x00;
  #asm("sei")
}
/////////////////////////////////////////////////////////////////////////

void MicroReset()
{
  //--> Always warm reset because when an alarm is active, it must not be dectivated during startup after reset
  #asm("jmp 0x0000")
}

void MicroResetCold()
{
  //This is a hardware reset.
  //Watchdog enabling procedure differs for different chip types
  //Enable watchdog for short time to reset almost with no delay
  EnableWatchdogShort();
  while(1)
  {
  }
}

void Alert(unsigned char BlinkTimes)
{
  unsigned char i;

  for(i = 1; i <= BlinkTimes; i++)
  {
    PORTD.4 = 0;
    delay_ms(500);
    PORTD.4 = 1;
    delay_ms(500);
  }
  PORTD.4 = 0;
}

BOOL TrialTimedOut()
{
  //Portable memory has no trial feature, so always return FALSE to have no limitation on the USART commands
  return(FALSE);
}

// I2C Bus functions
#asm
   .equ __i2c_port=0x15 ;PORTC
   .equ __sda_bit=4
   .equ __scl_bit=5
#endasm
#include <i2c.h>

/*
// Alphanumeric LCD Module functions
#asm
   .equ __lcd_port=0x18 ;PORTB
#endasm
#include <lcd.h>
*/

// Standard Input/Output functions
#include <stdio.h>

#include "memory.c"
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


#include "alarms.c"
//Alarm management routines
/*

void WriteAlarmData(unsigned int mem_start_offset, unsigned char *data)
{
  unsigned int mem_offset;
  unsigned char i;

  mem_offset = mem_start_offset;

  #if     _ALARM_STORAGE_SELECT_ == _EXTERNAL_EEPROM_
    for(i = 0; i < sizeof(TLDCAlarm); i++)
    {
      mem_write(mem_offset, data[i]);
      mem_offset++;
    }
  #elif   _ALARM_STORAGE_SELECT_ == _INTERNAL_EEPROM_
    for(i = 0; i < sizeof(TLDCAlarm); i++)
    {
      AlarmData[mem_offset] = data[i];
      mem_offset++;
    }
  #endif
}

void ReadAlarmData(unsigned int mem_start_offset, unsigned char *data)
{
  #if     _ALARM_STORAGE_SELECT_ == _EXTERNAL_EEPROM_
    mem_read_block(mem_start_offset, sizeof(TLDCAlarm), data);
  #elif   _ALARM_STORAGE_SELECT_ == _INTERNAL_EEPROM_
    unsigned int mem_offset;
    unsigned char i;

    mem_offset = mem_start_offset;

    for(i = 0; i < sizeof(TLDCAlarm); i++)
    {
      data[i] = AlarmData[mem_offset];
      mem_offset++;
    }
  #endif
}

BOOL WriteAlarm(unsigned char month, unsigned char AlarmIndex, unsigned char *AlarmData)
{
  //If alarm data is valid and there is enough memory to store the alarm, stores the alarm in the memory and returns TRUE,
  //  otherwise returns FALSE.
  //Valid alarm is an alarm that its month is in valid range and its Duration is greater than 0 (in fact it is an active alarm).
  unsigned int AlarmMemStartOffset;

  //DEBUG -----------------------
  //PORTC.2 = 1;
  //delay_ms(4000);
  //PORTC.2 = 0;
  //printf("AlarmMonth=%d, AlarmIndex=%d", month, AlarmIndex);
  //for(i = 0; i < sizeof(TLDCAlarm); i++)
  //  printf("<%X>", AlarmData[i]);
  //-----------------------------

  if(month > 0 && month <= 12 && AlarmIndex < MAX_ALARM_COUNT_PER_MONTH)
  {
    AlarmMemStartOffset = ALARM_DATA_MEM_START_OFFSET + (unsigned int) (month - 1) * MAX_ALARM_COUNT_PER_MONTH * ALARM_SYSTEM_BYTES_PER_ALARM + (unsigned int) AlarmIndex * sizeof(TLDCAlarm);
    WriteAlarmData(AlarmMemStartOffset, AlarmData);
  }
}

void ReadAlarm(unsigned char Month, unsigned char AlarmIndex, unsigned char *Alarm)  //Alarm in a pointer to the beginning of a TLDCAlarm structure
{
  unsigned char i;
  unsigned int AlarmMemStartOffset;

  if(Month > 0 && Month <= 12 && AlarmIndex < MAX_ALARM_COUNT_PER_MONTH)
  {
    AlarmMemStartOffset = ALARM_DATA_MEM_START_OFFSET + (unsigned int) (Month - 1) * MAX_ALARM_COUNT_PER_MONTH * ALARM_SYSTEM_BYTES_PER_ALARM + (unsigned int) AlarmIndex * sizeof(TLDCAlarm);
    //printf("Mem Offset = %u", AlarmMemStartOffset);
    ReadAlarmData(AlarmMemStartOffset, Alarm);
  }
  else
  {
    //printf("Invalid Alarm No. %d", AlarmIndex);
    //Invalid month number - no alarm: fill with 0
    for(i = 0; i < sizeof(TLDCAlarm); i++)
      Alarm[i] = 0;
  }
}

unsigned char CountActiveAlarms(unsigned char AlarmMonth)
{
  TLDCAlarm a;
  unsigned char i;
  unsigned char ActiveAlarmCount = 0;

  //DEBUG ---------------------------
  //PORTC.2 = 1;
  //delay_ms(6000);
  //PORTC.2 = 0;
  //---------------------------------
  for(i = 0; i < MAX_ALARM_COUNT_PER_MONTH; i++)
  {
    //printf("<Alarm No. %d,", i);
    ReadAlarm(AlarmMonth, i, (unsigned char *) &a);
    //printf(", Month=%d, Duration=%d>\n", a.Month, a.Duration);
    if(a.Duration > 0)
      ActiveAlarmCount++;
  }
  //printf("\n\nAll Done");

  return(ActiveAlarmCount);
}
*/

unsigned long int TickCount = 0;  //Can be used for timings - not used is this version

//This interrupt is used as the system clock
//This interupt is triggered every 21.84ms
// Timer 0 overflow interrupt service routine
interrupt [TIM0_OVF] void timer0_ovf_isr(void)
{
  TickCount++;
}

unsigned char reset_flag;
eeprom unsigned long TotalDisplayDataReceivedBytes = 0;
eeprom unsigned int TotalAlarmCountReceived = 0;

// Timer 1 output compare A interrupt service routine
interrupt [TIM1_COMPA] void timer1_compa_isr(void)
{
  reset_flag = 1;
}

unsigned char LEDBinkTime;
static unsigned char NumOfTimesLEDInterruptOccurred = 0;
// Timer 2 output compare interrupt service routine
//This timer is used only for blinking the LED
interrupt [TIM2_COMP] void timer2_comp_isr(void)
{
  //This interrupt occurs about every 5.034 milliseconds

  NumOfTimesLEDInterruptOccurred++;
  if(NumOfTimesLEDInterruptOccurred >= LEDBinkTime)
  {
    PORTD.4 = ~PIND.4;
    NumOfTimesLEDInterruptOccurred = 0;
  }
}

void StopTickCountTimer()
{
  //Timer 0 overflow interrupt
  TIMSK &= 0b11111110;
}

void StartTickCountTimer()
{
  //Timer 0 overflow interrupt
  TCNT0 = 0;
  TIMSK |= 0b00000001;
}

void StopLEDBlink()
{
  //Timer 2 compare match interrupt
  TIMSK &= 0b01111111;
  PORTD.4 = 0;
}

void StartLEDBlink(unsigned char BlinkSpeed)
{
  //Timer 2 compare match interrupt

  StopLEDBlink();  //Disable timer 2 interrupt

  NumOfTimesLEDInterruptOccurred = 0;
  LEDBinkTime = BlinkSpeed;
  TCNT2 = 0;

  //Enable timer 2 interrupt
  TIMSK |= 0b10000000;
  PORTD.4 = 1;
}



#include "usart.c"


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

// External Interrupt 0 service routine
interrupt [EXT_INT0] void ext_int0_isr(void)
{
}

// External Interrupt 1 service routine
interrupt [EXT_INT1] void ext_int1_isr(void)
{
//  GIFR = 0xff;
}

#include "send_data.c"
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

#include "io_init.c"

void io_init()
{
  // Input/Output Ports initialization
  // Port B initialization
  // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
  // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
  PORTB=0x00;
  DDRB=0x00;

  // Port C initialization
  // Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
  // State6=T State5=T State4=T State3=T State2=T State1=T State0=T
  PORTC=0x00;
  DDRC=0x00;

  // Port D initialization
  // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
  // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
  DDRD=0b11110000;//0xfc;
  PORTD=0x00;

  // Timer/Counter 0 initialization
  // Clock source: System Clock
  // Clock value: Timer 0 Stopped
  TCCR0=0b00000101;
  TCNT0=0x00;

  // Timer/Counter 1 initialization
  // Clock source: System Clock
  // Clock value: Timer 1 Stopped
  // Mode: Normal top=FFFFh
  // OC1A output: Discon.
  // OC1B output: Discon.
  // Noise Canceler: Off
  // Input Capture on Falling Edge
  // Timer 1 Overflow Interrupt: Off
  // Input Capture Interrupt: Off
  // Compare A Match Interrupt: Off
  // Compare B Match Interrupt: Off
  TCCR1A=0b00000000;//0x00;
  TCCR1B=0b00001101;//0x00;Prescaler = 1024
  TCNT1H=0x00;
  TCNT1L=0x00;
  ICR1H=0x00;
  ICR1L=0x00;
  //23438 = 0x5B8E:  --> 2 Seconds on 12MHz frequency
  //11719 = 0x2DC7:  --> 1 Seconds on 12MHz frequency
  OCR1AH=0x2D;
  OCR1AL=0xC7;
  OCR1BH=0x00;
  OCR1BL=0x00;

  // Timer/Counter 2 initialization
  // Clock source: System Clock
  // Clock value: Timer 2 Stopped
  // Mode: Normal top=FFh
  // OC2 output: Disconnected
  ASSR=0x00;
  TCCR2=0b00001111;  //Prescalar: 1024, TOP = OCR2
  TCNT2=0x00;
  OCR2=59;  //59 = every 5.034 milliseconds

  // External Interrupt(s) initialization
  // INT0: On
  // INT0 Mode: Rising Edge
  // INT1: On
  // INT1 Mode: Rising Edge
//  GICR|=0xC0;
//  MCUCR=0x0F;
//  GIFR=0xC0;

  // External Interrupt(s) initialization
  // INT0: Off
  // INT1: Off
  MCUCR=0x00;

  // Timer(s)/Counter(s) Interrupt(s) initialization
  TIMSK=0b00010000;//0x00;  //Timer 1 Compare Match ! interrupt enabled - all other timer interrupts are disabled - other timers will be enabled whenever necessary in the program

  // USART initialization
  // Communication Parameters: 8 Data, 1 Stop, No Parity
  // USART Receiver: On
  // USART Transmitter: On
  // USART Mode: Asynchronous
  // USART Baud Rate: 38400 (Double Speed Mode)
  UCSRA=0x02;
  UCSRB=0x98;
  UCSRC=0x86;
  UBRRH=0x00;
  UBRRL=0x26;

  // Analog Comparator initialization
  // Analog Comparator: Off
  // Analog Comparator Input Capture by Timer/Counter 1: Off
  ACSR=0x80;
  SFIOR=0x00;

  // I2C Bus initialization
  i2c_init();

/*
  // LCD module initialization
  //lcd_init(16);
*/

  // Global enable interrupts
  #asm("sei")
}

// Declare your global variables here

void UpdateLEDStatus()
{
  //Check display data and alarm data
  if(TotalDisplayDataReceivedBytes > 0 || TotalAlarmCountReceived > 0)
    PORTD.4 = 1;
  else
    PORTD.4 = 0;
}

void main(void)
{
  //unsigned char c;
  //unsigned long addr;

  io_init();

  PORTD.4 = 1;
  delay_ms(500);
  PORTD.4 = 0;
  delay_ms(500);  //Allow to distinguish between blinking LED and valid-data-is-stored state of the LED

  mem_init();

  StartTickCountTimer();

  while(1)
  {
    UpdateLEDStatus();

    //Receive and store data
    if(usart_char_available())
    {
      handle_usart();
      StopLEDBlink();
    }

    //Send stored data
    if(!BUTTON_SEND && TotalDisplayDataReceivedBytes > 0)  //TotalDisplayDataReceivedBytes > 0 means there is some display data stored on the memory
    {
      StartLEDBlink(LED_BLINK_SPEED_FOR_SEND);
      SendMemoryDataFast();
      StopLEDBlink();
    }

    if(!BUTTON_OTHER)  //CLEAR button
    {
      if(TotalDisplayDataReceivedBytes > 0)  //Only call write operation on the EEPROM if the new value is different from the old value
        TotalDisplayDataReceivedBytes = 0;
      UpdateLEDStatus();
      delay_ms(400);
      PORTD.4 = 1;
      delay_ms(400);
      PORTD.4 = 0;
      delay_ms(400);
    }
  }
}
