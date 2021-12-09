/*****************************************************
This program was produced by the
CodeWizardAVR V1.25.8 Professional
Automatic Program Generator
© Copyright 1998-2007 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : 
Version : 
Date    : 2008/08/06
Author  : F4CG                            
Company : F4CG                            
Comments: 


Chip type           : ATmega32
Program type        : Application
Clock frequency     : 11.000000 MHz
Memory model        : Small
External SRAM size  : 0
Data Stack size     : 512
*****************************************************/

#ifdef  _CHIP_ATMEGA128_
#include <mega128.h>
#endif
#ifdef  _CHIP_ATMEGA32_
#include <mega32.h>
#endif
#ifdef  _CHIP_ATMEGA16_
#include <mega32.h>
#endif

#include <delay.h>
#include <math.h>
#include <string.h>
#include "defs.c"
#include "misc.c"
#include "types.c"
//#include "atkbd.c"
#include "solardate.c"

#include <stdio.h>  /* Standard Input/Output functions */



//This function is used both for debugging and for other purposes. Always must be included.
/*
void pulse(unsigned int delay)
{
  PORTA.7 = 1;
  delay_ms(delay);
  PORTA.7 = 0;
}
*/
/*
void pulse2(unsigned int delay)
{
  DDRC.2 = 1;
  PORTC.2 = 1;
  delay_ms(delay);
  PORTC.2 = 0;
  delay_ms(delay);
}
*/

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
    PORTA.7 = 0;
    delay_ms(500);
    PORTA.7 = 1;
    delay_ms(500);
  }
  PORTA.7 = 0;
}


/*
// Alphanumeric LCD Module functions
#asm
    .equ __lcd_port=0x1B ;PORTA
#endasm
#include <lcd.h>
*/

//#include "debug.c"

// I2C Bus functions
#asm
   .equ __i2c_port=0x15 ;PORTC
   .equ __sda_bit=1
   .equ __scl_bit=0
#endasm
#include <i2c.h>

#ifdef  _TEMPERATURE_ACTIVE_
#include <lm75.h>
#endif

#include "memory.c"  /* External EEPROM Memory Access Routines */


register unsigned char RefreshRowNum = 0;
//volatile unsigned char RefreshRowNum = 0;

//declare usart_cmd_stage here to make it possible to allocate a register to it
register unsigned char usart_cmd_stage;

//volatile unsigned char ClkSecond = 0, ClkMinute = 0, ClkHour = 0;
unsigned char ClkSecond = 0, ClkMinute = 0, ClkHour = 0;


#include <ds1307.h>  /* DS1307 Real Time Clock functions */
#include "datetime.c"  /* Date-Time Routines */
#include "adc.c"  /* ADC Routines */

unsigned long TickCount = 0;

bit DataIsValid = 1;

bit ColdReset;
bit WatchdogReset;


#define   MAX_OVERALL_SPEED_SETTING     150
eeprom unsigned char OVERALL_SPEED_SETTING = 16;  //Used for LED Display timing


#include "alarms.c"

//////////////////////
//mem_reset.c uses the funtion CheckTrial() in the trial.c, and trial.c uses the function ResetMemoryData() in the mem_reset.c, so we have to add the declaration of the CheckTrial() function before mem_reset.c.
BOOL CheckTrial();
#include "mem_reset.c"
#include "trial.c"
//////////////////////

#include "temperature.c"
#include "screen.c"

//DS1307 substitute
interrupt [TIM1_COMPA] void timer1_compa_isr(void)
{
  ClkSecond++;
  if(ClkSecond >= 60)
  {
    ClkSecond = 0;
    ClkMinute++;
    if(ClkMinute >= 60)
    {
      ClkMinute = 0;
      ClkHour++;
      if(ClkHour >= 24)
      {
        ClkHour = 0;
      }
    }
  }
}

//**********************************************************************************************************
//** DO NOT CHANGE THIS VALUES - THESE VALUES ARE EXAMINED ON THE LED DISPLAY AND ARE GOOD INITIAL VALUES **
#if LED_DISPLAY_MAX_ROW_COUNT <= 8
  #ifdef _COLOR_DISPLAY_METHOD_2_
    eeprom unsigned char OCR0_VALUE = 15;  //Same value for both mega32 and mega128  --> This is actually 16 rows for refresh
  #else
    eeprom unsigned char OCR0_VALUE = 30;  //Same value for both mega32 and mega128
  #endif
#elif LED_DISPLAY_MAX_ROW_COUNT <= 16
  #ifdef _COLOR_DISPLAY_METHOD_2_
    eeprom unsigned char OCR0_VALUE = 5;  //Same value for both mega32 and mega128  --> This is actally 32 rows for refresh
  #else
    eeprom unsigned char OCR0_VALUE = 15;  //Same value for both mega32 and mega128
  #endif
#elif LED_DISPLAY_MAX_ROW_COUNT <= 24  //_COLOR_DISPLAY_METHOD_2_ is not supported for row count greater than 16
eeprom unsigned char OCR0_VALUE = 10;  //Same value for both mega32 and mega128
#else  //#elif LED_DISPLAY_MAX_ROW_COUNT <= 32
eeprom unsigned char OCR0_VALUE = 5;  //Same value for both mega32 and mega128
#endif
//**********************************************************************************************************

//Refresh timer settings
#ifdef  _CHIP_ATMEGA32_
#define TCCR0_VALUE 0b00001101//For Mega128: <<< 0b00001111 >>>
#endif

#ifdef  _CHIP_ATMEGA128_
#define TCCR0_VALUE 0b00001111
#endif


void start_refresh()
{
  // Timer/Counter 0 initialization
  #ifdef  _CHIP_ATMEGA128_
  ASSR=0x00;
  #endif
  OCR0 = OCR0_VALUE;
  TCCR0=TCCR0_VALUE;  //0b00001100;
  TCNT0=0b00000000;
  // Timer(s)/Counter(s) Interrupt(s) initialization
  TIMSK=0b10010010;  //Timer0 and Timer1 and Timer 2 compare match interrupt enabled
}

void stop_refresh()
{
  // Timer/Counter 0 initialization
  TCCR0=0x00;  //Timer stopped
  TCNT0=0b00000000;
  //Do not disable Timer 1 interrupt because it is the system clock
}


#include "io_init.c"  //io_init()


#ifdef  _CHIP_ATMEGA32_
  #pragma optsize-  //Always optimize this routine for maximum execution speed
#endif

#ifdef  _COLOR_DISPLAY_METHOD_2_
bit RedTurn;
#endif

//Refresh interrupt
// Timer 0 output compare interrupt service routine
interrupt [TIM0_COMP] void timer0_comp_isr(void)
{
  //RefreshDisplayLatch();  --CALL instruction removed
  
  unsigned char i;
  //unsigned char FromCol;
  static unsigned char LatchToDisable = 0;
  unsigned char latch_count;
  unsigned char RowData;
  #ifdef  _COLOR_DISPLAY_
  unsigned char Filter;
  #endif
  #ifdef  _COLOR_DISPLAY_METHOD_2_
  unsigned char ActualLatchRowNum;
  #endif
  register unsigned char PORTC_OR_Value;
  
  //++++++++++++++++++++++++++++++++
  //++++++++++++++++++++++++++++++++
  //** THIS IS NECESSARY HERE **//
  stop_refresh();
  //++++++++++++++++++++++++++++++++
  //++++++++++++++++++++++++++++++++
  
  latch_count = LATCH_COUNT;
  
  #ifdef  _COLOR_DISPLAY_METHOD_2_
  ActualLatchRowNum = (RefreshRowNum << 1) + !RedTurn;
  #endif
  
  PORTC_OR_Value = (PINC & 0b00000100) | 0x80;  //It is better to not to put this statement as the first statement in this routine, to prevent potential software bugs (allowing PINC to get its real value after any assignment to it before entering this routine although some other instructions are executed before entering this routine but if we use this routine in a direct place in the future, it will cause problems reading real value of the PINC!).
  
  //iterate through latches
  //=========================================================
  //LatchNum starting from 0
  PORTB = COLUMNS_NOT;//0x00;  //We select rows, so to light a LED in a column, make that column GND
  RowData = latch_count * 8;  //RowData is used as a temporary variable here to speed up this routine
  for(i = 0; i < RowData; i += 8)
  //for(i = 0; i < latch_count; i++)
  //for(i = 0; i < (latch_count* 8); i += 8)
  //for(i = 0; i < (MAX_LATCH_COUNT* 8); i += 8)
  {
    //PORTC = (/*LatchNum*/ i << 3) | 0x80;
    //PORTC = i;  //This also makes PORTC.7 = 0
    //PORTC = (i << 3) | PORTC_OR_Value;
    PORTC = i | PORTC_OR_Value;
    PORTC.7 = 0;
    PORTC.7 = 1;
    
    #ifdef  _COLOR_DISPLAY_METHOD_1_
    PORTA.0 = 0;
    PORTA.0 = 1;
    #endif
  }
  //=========================================================
  
  
  #ifdef  _COLOR_DISPLAY_METHOD_2_
  if((ActualLatchRowNum % 8) == 0)
  #else
  if((RefreshRowNum % 8) == 0)
  #endif
  {
    //Disable latch no. LatchToDisable
    PORTB = ROWS_NOT;//~0x00;
    
    //Generate pulse
    switch(LatchToDisable)
    {
      case 1:
        PORTD.3 = 1;
        PORTD.3 = 0;
        break;
      case 2:
        PORTD.4 = 1;
        PORTD.4 = 0;
        break;
      #if defined(_ROWS_24_) || defined(_COLOR_DISPLAY_METHOD_2_)
      case 3:
        PORTD.5 = 1;
        PORTD.5 = 0;
        break;
      #endif
      #if defined(_ROWS_32_) || defined(_COLOR_DISPLAY_METHOD_2_)
      case 4:
        PORTD.6 = 1;
        PORTD.6 = 0;
        break;
      #endif
    }
  }
  
  
  #ifdef  _COLOR_DISPLAY_METHOD_2_
  SelectRow(ActualLatchRowNum);
  #else
  SelectRow(RefreshRowNum);
  #endif
  
  
  //iterate through latches
  //=========================================================
  PrepareRowData(RefreshRowNum);
  //FromCol = 0;
  for(i = 0; i < latch_count; i++)
  //for(i = 0; i < MAX_LATCH_COUNT; i++)
  {
    //LatchNum starting from 0
    //RowData = GetRowData8(RefreshRowNum, FromCol);  //We select rows, so to light a LED in a column, make that column GND
    RowData = RowDataForLatches[i];  //i = LatchIndex
    
    #ifdef  _COLOR_DISPLAY_METHOD_2_
    
    if(RedTurn)
      Filter = RedFilter[RefreshRowNum][i] | FILTER_OFF;
    else
      Filter = GreenFilter[RefreshRowNum][i] | FILTER_OFF;
    
    if(COLUMNS_NOT)
      PORTB = ~(RowData & Filter);
    else
      PORTB = RowData & Filter;
    
    //PORTC = i;  //This also makes PORTC.7 = 0
    //PORTC = (/*LatchNum*/ i << 3) | 0x80;
    PORTC = (i << 3) | PORTC_OR_Value;
    
    PORTC.7 = 0;
    PORTC.7 = 1;
    
    #else
    
      #ifdef  _COLOR_DISPLAY_METHOD_1_
      //-- Red --
      Filter = RedFilter[RefreshRowNum][i] | FILTER_OFF;
      if(COLUMNS_NOT)
        PORTB = ~(RowData & Filter);
      else
        PORTB = RowData & Filter;
      #else
      if(COLUMNS_NOT)
        PORTB = ~RowData;
      else
        PORTB = RowData;
      #endif
      
      //PORTC = i;  //This also makes PORTC.7 = 0
      //PORTC = (/*LatchNum*/ i << 3) | 0x80;
      PORTC = (i << 3) | PORTC_OR_Value;
  
      //Generate a pulse
      //Enable and disable decoder output
      PORTC.7 = 0;
      PORTC.7 = 1;
      #ifdef  _COLOR_DISPLAY_METHOD_1_
      //-- Green --
      Filter = GreenFilter[RefreshRowNum][i] | FILTER_OFF;
      if(COLUMNS_NOT)
        PORTB = ~(RowData & Filter);
      else
        PORTB = RowData & Filter;
      PORTA.0 = 0;
      //delay_us(LATCH_PULSE_DURATION);  //Pulse duration
      PORTA.0 = 1;
      #endif
      
    #endif
    
    //FromCol += 8;
  }
  //=========================================================
  
  #ifdef  _COLOR_DISPLAY_METHOD_2_
  ActualLatchRowNum++;
  if(!RedTurn)
  #endif
    RefreshRowNum++;
  
  #ifdef  _COLOR_DISPLAY_METHOD_2_
    if((ROW_COUNT > 4) && (ActualLatchRowNum % 8) == 0)
    {
      LatchToDisable = (ActualLatchRowNum >> 3);  //Row / 8;
    }
  #else
    if((ROW_COUNT > 8) && (RefreshRowNum % 8) == 0)
    {
      LatchToDisable = (RefreshRowNum >> 3);  //Row / 8;
    }
  #endif
  
  if(RefreshRowNum == ROW_COUNT)
  {
    #ifdef  _COLOR_DISPLAY_METHOD_2_
      if(ROW_COUNT > 4 && (ActualLatchRowNum % 8) != 0)
        LatchToDisable = (ActualLatchRowNum >> 3) + 1;  //RefreshRowNum / 8 + 1  --> The parentheses around RefreshRowNum >> 3 are necessary, otherwise it will be RefreshRowNum >> (3 + 1)!!!!
    #else
      if(ROW_COUNT > 8 && (RefreshRowNum % 8) != 0)
        LatchToDisable = (RefreshRowNum >> 3) + 1;  //RefreshRowNum / 8 + 1  --> The parentheses around RefreshRowNum >> 3 are necessary, otherwise it will be RefreshRowNum >> (3 + 1)!!!!
    #endif
    
    RefreshRowNum = 0;
  }
  
  #ifdef  _COLOR_DISPLAY_METHOD_2_
  RedTurn = !RedTurn;
  #endif
  
  //++++++++++++++++++++++++++++++++
  //++++++++++++++++++++++++++++++++
  //** THIS IS NECESSARY HERE **//
  start_refresh();
  //++++++++++++++++++++++++++++++++
  //++++++++++++++++++++++++++++++++
  /*  
  if(TrialEnabled)
  {
    TrialCounter++;
    if(TrialCounter >= TickCountsPerMinute)
    {
      TrialMinuteCounter++;
      TrialCounter = 0;
      if(TrialMinuteCounter >= 1440)  //one day
      {
        TrialMinuteCounter = 0;
        if(TrialDaysElapsed < TrialLimit)
          TrialDaysElapsed++;
        CheckTrial();
      }
    }
  }
  */
}
#ifdef  _CHIP_ATMEGA32_
  #pragma optsize+
#endif

// Timer 2 output compare interrupt service routine
interrupt [TIM2_COMP] void timer2_comp_isr(void)
{
  TickCount++;
}



#include "usart.c"  /* USART Communication Handler */
#include "buttons.c"

void main(void)
{
  unsigned char c, c2;
  #ifdef  _ALARM_ACTIVE_
  unsigned char AlarmCounter;
  #endif
  
  //==========================================================
  //INIT REFRESH
  ApplyRefreshSettings();
  for(c = 0; c < 32; c++)  //32 rows max
  {
    c2 = RowSelectorsDONTNOT_EEP[c];
    RowSelectorsDONTNOT[c] = c2;
    RowSelectorsNOT[c] = ~c2;  // ** MUST BE NOT BECAUSE THIS ARRAY IS USED TO SELECT ROWS IN NOT MODE ROW REFRESH TYPE **
  }
  //==========================================================
  
  
  
/* THIS METHOD DOES NOT WORK CORRECTLY IN OUR SPECIFIC APPLICATION (SOFTWARE RESET). IN FACT WE WANT TO DISTINGUISH BETWEEN SOFTWARE AND HARDWARE RESET (WARM AND COLD RESET).
  // Reset Source checking
  if (MCUCSR & 1)
  {
    // Power-on Reset
    MCUCSR=0;
  }
  else if (MCUCSR & 2)
  {
    // External Reset
    MCUCSR=0;
  }
  else if (MCUCSR & 4)
  {
    // Brown-Out Reset
    MCUCSR=0;
  }
  else
  {
    // Watchdog Reset
    MCUCSR=0;
  };
*/

  if(DDRB != 0xff)
    ColdReset = 1;
  else
    ColdReset = 0;
  
  /*
  WatchdogReset = 0;
  
  // Reset Source checking
  if (MCUCSR & 1)
  {
     // Power-on Reset
  }
  else if (MCUCSR & 2)
  {
     // External Reset
  }
  else if (MCUCSR & 4)
  {
     // Brown-Out Reset
  }
  else
  {
     // Watchdog Reset
     WatchdogReset = 1;
  };
  */
  
  if(MCUCSR & 8)
    WatchdogReset = 1;
  else
    WatchdogReset = 0;
  MCUCSR=0;
  
  ROW_COUNT = MAX_ROW_COUNT;
  COL_COUNT = MAX_COL_COUNT;
  if(ColdReset && !WatchdogReset)
    ClearScreen(TRUE);
  
  io_init();
  
  if(ColdReset && !WatchdogReset)
  {
    //ClearScreen(TRUE);
    //Show that the micro is alive
    //DDRA.7 = 1;  --> Already is configured in the io_init() function
    PORTA.7 = 1;
    delay_ms(50);
    PORTA.7 = 0;
    delay_ms(50);
    //Wait until the display is completely cleared
    //while(RefreshRowNum != ROW_COUNT)  --> Does not work correctly
    //{
    //;
    //}
  }
  
  
  if(ColdReset && !WatchdogReset)
  {
    //delay_ms(1000);  //Wait for 1 second
    while(!BUTTON_DOWN || !BUTTON_UP)  //Wait until BUTTON_DOWN is released. This is used to hold the program at startup
    {
      PORTA.7 = 1;
      delay_ms(400);
      PORTA.7 = 0;
      delay_ms(400);
    }
  }
/*
  stop_refresh();
  while(1)
  {
  PORTB = ~0b00101011;
  PORTD.3 = 1;
  PORTD.3 = 0;
  PORTB = 0b00101011;
  PORTC = (0 << 3) | 0x80;
  PORTC.7 = 0;
  PORTC.7 = 1;
  PORTC = (1 << 3) | 0x80;
  PORTC.7 = 0;
  PORTC.7 = 1;
  PORTC = (2 << 3) | 0x80;
  PORTC.7 = 0;
  PORTC.7 = 1;
  PORTC = (3 << 3) | 0x80;
  PORTC.7 = 0;
  PORTC.7 = 1;
  }
  while(1)
  {
  }
  */

  // LCD module initialization
  //lcd_init(16);
  //lcd_clear();
  //lcd_putsf("RESET");
  //DDRA = 0x00;
  
  
  mem_init();
  
  
  if(ColdReset && !WatchdogReset)
  {
    //Load eeprom with test data
    PORTA.7 = 1;
    
    ///////////////////////////////////////////////
    //Check for memory data reset command via usart
    putchar(LEDDISPLAY_RESET_BYTE_1_FROM_MICRO);
    delay_ms(400);
    if(usart_char_available())
    {
      c = getchar();
      if(c == LEDDISPLAY_RESET_BYTE_2_TO_MICRO)
      {
        putchar(LEDDISPLAY_RESET_BYTE_3_FROM_MICRO);
        delay_ms(400);
        if(usart_char_available())
        {
          c = getchar();
          if(c == LEDDISPLAY_RESET_BYTE_4_TO_MICRO)
          {
            ResetMemoryData(FALSE);
          }
        }
      }
    }
    ///////////////////////////////////////////////
    
    //  for(i = 0; i < 1161; i++)
    //    mem_write(i, data[i]);
    if(!BUTTON_OTHER)
    {
      ResetMemoryData(FALSE);
      //ClearMemory(0);
    }
    //delay_ms(1000);
    PORTA.7 = 0;
  }
  
  
  //ResetMemoryData(FALSE);
  
  //display_init();
  //PrepareForNewData();
  
  
    //===============ddddddddddddddddddddddd sd f dsf
    //===============ddddddddddddddddddddddd sd f dsf
    //CurrentStage.EntranceEffectID = 8;
    //CurrentStage.ExitEffectID = 0;
    //===============ddddddddddddddddddddddd sd f dsf
    //===============ddddddddddddddddddddddd sd f dsf
  
  
  //ROW_COUNT = 16;
  //COL_COUNT = 64;
  
  //CheckTrial();
  //ValidateData();
  
  #ifdef  _ALARM_ACTIVE_
  //CheckAllAlarms();
  InitAlarms();
  AlarmCounter = ALARM_CHEK_COUNTER;
  #endif
  
  CheckTrial();
  
  ValidateData();
  if(DataIsValid == 1)
  {
    PrepareForNewData();
  }
  ////////////////////////////
  ////////////////////////////
  //Strict Lock Check
  #ifdef  _STRICT_LOCK_ACTIVE_
  CheckStrictLock();
  #endif
  ////////////////////////////
  ////////////////////////////
  
  //do
  while (1)
  {
    //WDR
    
    if(usart_char_available())
    {
      handle_usart();
    }
    
    
    #ifdef  _DATE_TIME_ADJUST_BUTTONS_ACTIVE
    if(CheckDateTimeButtons() == 1)
    {
      reset_usart_buffer();
      FILTER_OFF = 0x00;  //This statement is not necessary here
    }
    #endif
    
    
    if(DataIsValid == 1)
    {
      EnableWatchdog();
      UpdateScreen();
      DisableWatchdog();
    }
    else
      ShowInvalidDataMessage();
    
    #ifdef  _ALARM_ACTIVE_
    
    AlarmCounter--;
    if(AlarmCounter == 0)
    {
      AlarmCounter = ALARM_CHEK_COUNTER;
      CheckAlarms();
    }
    
    #endif
  }
}
