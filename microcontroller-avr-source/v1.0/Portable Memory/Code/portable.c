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
#include <delay.h>

#include "pconfig.c"
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

#include "alarms.c"

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

#include "io_init.c"

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
