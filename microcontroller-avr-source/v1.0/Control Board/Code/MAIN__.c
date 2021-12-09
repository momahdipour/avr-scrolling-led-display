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

#include <mega32.h>
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
#include <math.h>
#include <string.h>
#include "defs.c"

//Determines speed of playing speed modes (very fast, fast, medium, slow, very slow)
//Higher values dcereases overall speed, lower values increases overall speed.
#define CONTENT_SPPED_MULTIPLIER 0.35


//External EEPROM Memory Settings
//#define   ICSIZE    32768  //in bytes - FM24C256 (32KB External EEPROM IC)
#define   ICSIZE    8192  //in bytes - FM24C64 (8KB External EEPROM IC)

#define   EEPROM_WRITE_DELAY    5  //in milliseconds (original value was 10ms)

//Memor cache configuration
#define   CACHE_COUNT   4
#define   CACHE_SIZE    50


//Maximum display size
#define MAX_ROW_COUNT 32
#define MAX_COL_COUNT 128

//#define NOT_THE_OUTPUT 1  //1 = NOT, 0 = Don't NOT  -- Not used
//#define REFRESH_DELAY 250  //us -- Not used
//#define OVERALL_REFRESH_COUNT 1  //Not used anymore

//LED Display Size that this program is running on it

//#define   LED_DISPLAY_HEIGHT    16
//#define   LED_DISPLAY_WIDTH     96

//Display capabilities to be reported to computer via serial port
#define   TEMPERATURE_EXISTS    1   //1 = Yes, 0 = No
#define   HUMIDITY_EXISTS       1
#define   DATE_TIME_EXISTS      1

//Pulse duration for latches to operate correctly
#define   LATCH_PULSE_DURATION  1  //us
#include "misc.c"

#define WDR #asm("wdr")
#include "types.c"

#define TRUE (1==1)
#define FALSE (1==0)
typedef char BOOL;

typedef struct
{
  unsigned char RowCount;
  unsigned char ColCount;
  unsigned char StageCount;
} TGlobalSettings;

//Area Content Type description:
//0 = Unused Area
//1 = Time
//2 = Date
//3 = Single-Line Scrolling Text
//4 = Framed Animation
//5 = Font Text
//6 = Temperature
typedef struct
{
  unsigned char x1, y1, x2, y2;
  unsigned char ContentType;
  unsigned char DelayTime;  //in seconds - not dependent to TotalDisplayTime
  unsigned int DataSize;  //in bytes
  //New settings added:
  unsigned char ContinuesToNextStage;  //0 = No, 1 = Yes
  unsigned char AdvanceStageWhenDone;
  unsigned char ForceAdvanceStageWhenDone;  //When this area is done, go to next stage regardless of current state of other areas only if no one has the CompleteBeforeNextStage property set to Yes.
  unsigned char CompleteBeforeNextStage;  //0 = Not required, 1 = Yes (Must be completed)
  unsigned char RepeatAfterDone;  //Repeat this area until all other ares are done.  -- IN THIS VERSION only is applied to Time and Date and Temperature areas.

  unsigned char EntranceAnimID;
  unsigned char MiddleAnimID;
  unsigned char ExitAnimID;
} TArea;

typedef struct
{
  unsigned char TotalDisplayTime;  //in seconds
  unsigned char RepeatitionTimes;
  unsigned int DataOffset;  //***--> Can be omitted without any change in data (also must be omitted from data) <--***//
  unsigned char EntranceEffectID;
  unsigned char ExitEffectID;
  TArea Areas[4];
} TDisplayStage;

typedef struct
{
  unsigned char lang;  //0 = Farsi, 1 = English
  unsigned char format;  //0 = hh:mm:ss, 1 = hh:mm
  unsigned char type;  //0 = 24-Hour, 1 = 12-Hour
  unsigned char TotalDisplayTime;
  unsigned char CenterHorizontally;
  unsigned char CenterVertically;
} TTimeData;

typedef struct
{
  unsigned char lang;  //(Digits lang) 0 = Farsi, 1 = English
  unsigned char format;  //0 = 1387/01/01, 1 = 87/01/01, 2 = 1387-01-01, 3 = 87-01-01
  unsigned char type;  //0 = Solar, 1 = Gregorian
  unsigned char TotalDisplayTime;
  unsigned char CenterHorizontally;
  unsigned char CenterVertically;
} TDateData;

typedef struct
{
  unsigned char FixedText;  //0 = No, 1 = Yes - (Is this a scrolling text or a fixed text?)
  unsigned char Direction;  //0 = Right, 1 = Left, 2 = Up, 3 = Down
  unsigned char ScrollType;  //0 = Text scrolls into the display area (normal), 1 = Text is displayed first
  unsigned char Speed;  //0 = Very Fast, 255 = Very Slow
  unsigned int ColCount;
  unsigned char BytesPerCol;
  unsigned char Invert;  //0 = No, 1 = Yes
  unsigned char RepetitionTimes;  //This value is ignored if zero
  unsigned char TotalDisplayTime;  //If not zero, the text is displayed until the specified time is elapsed.
  /*Notes:
    1. The RepetitionTimes in independent from RepetitionTimes of TDisplayStage.
    2. RepetitionsTimes has more priority than TotalDisplayTime. So, when TotalDisplayTime is not zero,
       you should set RepetitionTimes to zero to enable TotalDisplayTime.
  */
  unsigned char Data[1];
} TSingleLineScrollingText;

typedef struct
{
  unsigned char Speed;
  unsigned char BytesPerCol;
  unsigned char FrameColCount;
  unsigned int FrameCount;
  unsigned char RepetitionTimes;  //This value is ignored if zero
  unsigned char TotalDisplayTime;  //If not zero, the animatin is played until the specified time is elapsed.
  /*Notes:
    1. The RepetitionTimes in independent from RepetitionTimes of TDisplayStage.
    2. RepetitionsTimes has more priority than TotalDisplayTime. So, when TotalDisplayTime is not zero,
       you should set RepetitionTimes to zero to enable TotalDisplayTime.
  */
  unsigned char Invert;  //0 = No, 1 = Yes
  unsigned char CenterHorizontally;  //0 = No, 1 = Yes
  unsigned char CenterVertically;  //0 = No, 1 = Yes  --> Cannot apply this option inside microcontroller, do it in the designer program
  unsigned char Data[1];
} TFramedAnimation;

typedef struct
{
  unsigned char Direction;  //0 = Right, 1 = Left, 2 = Up, 3 = Down
  unsigned char ScrollType;  //0 = Text scrolls into the display area (normal), 1 = Text is displayed first
  unsigned char Speed;  //0 = Very Fast, 255 = Very Slow
  unsigned int CharCount;
  unsigned char CharacterSource;  //0 = Internal Font
                                  //1 = External Font (stored in EEPROM) (Reserved - Not used in this version)
                                  //2 = External Character Table (Stored in EEPROM)
  unsigned char Data[1];
} TFontText;

typedef struct
{
  unsigned char lang;  //0 = Farsi, 1 = English
  unsigned char unit;  //0 = Centigrade, 1 = Fahrenheit
  unsigned int TotalDisplayTime;
  unsigned char CenterHorizontally;
  unsigned char CenterVertically;
} TTemperature;

typedef struct {
  unsigned char StartCol;  //Starting from 0
  BOOL NormalScroll;
} TStageSettings1;

typedef struct {
  unsigned int CurrentFrame;
} TStageSettings2;

typedef struct {
  //Single-Line Scrolling Text
  BOOL AreasDone[4];
  BOOL EntranceAnimDone[4];
  BOOL AnimInitialized[4];
  unsigned char AreaRepeatCount[4];
  BOOL StageEffectDone;
  TStageSettings1 SLST[4];  //SingleLineScrollingTexts
  TStageSettings2 FA[4];  //FramedAnimations
  //Timing
  BOOL ForceUpdate;
  unsigned char DelayTickCount[4];
  unsigned long LastTickCount[4];

  unsigned char RepeatedTimes;
} TStageSettings;

typedef struct {
  unsigned char h, m, s;
} TTime;
#include "atkbd.c"
//////////////////////////////////////////////////////////////
//atkbd.c:
//
//  kbd_init():  initialize keyboard (int0 in the GICR and MCUCR is set)
//  unsigned char kbd_ReadKey():  Read a key from keyboard (if no key is pressed, waits for a key)
//  unsigned char kbd_KeyExists():  Check if a key is ready in the keyboard buffer
//
//Other routines:
//
//  kbd_putbuff(unsigned char c):  put the character c in the keyboard buffer
//
//Info:
//
//  Optimized and improved by M. Mahdipour (mo.mahdipour@gmail.com)
//////////////////////////////////////////////////////////////

#include "AT_ScanCodes.h"

#define KBD_BUFF_SIZE 15

typedef struct
{
  unsigned char LCtrl: 1;
  unsigned char RCtrl: 1;
  unsigned char LShif: 1;
  unsigned char RShift: 1;
  unsigned char LAlt: 1;
  unsigned char RAlt: 1;
  unsigned char CapsLock: 1;  //not used
  unsigned char NumLock: 1;  //not used
} KBD_STATE;

#pragma used+
void kbd_init();
void kbd_putbuff(unsigned char c);
void kbd_keystroke(unsigned char sc, unsigned char keystroke, unsigned char shift);
void kbd_DecodeDataByte(unsigned char sc);
interrupt [EXT_INT0] void ext_int0_isr(void);
unsigned char kbd_ReadKey(void);
unsigned char kbd_KeyExists();
#pragma used-


unsigned char Edge;  //For RS232 simulation
unsigned char ReceivedBitsCount;  //Number of bits received from keyboard

unsigned char kbd_buffer[KBD_BUFF_SIZE];
unsigned char kbd_buffcount;
unsigned char *inpt, *outpt;  //inpt: pointer to the next byte to be read from the buffer
                              //outpt: pointer to the next place in the buffer to store a key

void kbd_init()
{
  GICR |= 0b01000000;  //Enable INT0 interrupt
  MCUCR = (MCUCR & 0b11111100) | 0b00000010;       // Set interrupt on falling edge
  //no need to set port direction
  Edge = 0;                                        //initially wait for falling edge on the keyboard data pin
  ReceivedBitsCount = 0;
}

void kbd_putbuff(unsigned char c)
{
  if (kbd_buffcount < KBD_BUFF_SIZE)                      // If buffer not full
  {
    *inpt = c;                                // Put character into buffer
    inpt++;                                   // Increment pointer

    kbd_buffcount++;

    if (inpt >= kbd_buffer + KBD_BUFF_SIZE)        // Pointer wrapping
      inpt = kbd_buffer;
  }
}

void kbd_keystroke(unsigned char sc, unsigned char keystroke, unsigned char shift)
{
  unsigned char i;

  //may check for available space in the keyboard buffer before continuing

  if(keystroke != 0)
  {
    kbd_putbuff(keystroke);
  }
  else
  {
    //an extended keystroke
    //put 0 only if the keystroke for that extended key is mapped in the tables
    if(!shift)
    {
      for(i = 0; kbd_extended_keys_normal[i][0] != sc && kbd_extended_keys_normal[i][0]; i++);
      if(kbd_extended_keys_normal[i][0] == sc)
      {
        kbd_putbuff(0);
        kbd_putbuff(kbd_extended_keys_normal[i][1]);
      }
    }
    else
    {
      for(i = 0; kbd_extended_keys_shifted[i][0] != sc && kbd_extended_keys_shifted[i][0]; i++);
      if(kbd_extended_keys_shifted[i][0] == sc)
      {
        kbd_putbuff(0);
        kbd_putbuff(kbd_extended_keys_shifted[i][1]);
      }
    }
  }
}

void kbd_DecodeDataByte(unsigned char sc)
{
    static unsigned char is_up=0, lshift = 0, rshift = 0, lctrl = 0, rctrl = 0;
    static unsigned char lalt = 0, ralt = 0, is_extend=0;
    unsigned char i;
    unsigned char shift, ctrl, alt;

    shift = lshift || rshift;
    ctrl = lctrl || rctrl;
    alt = lalt || ralt;

    if (!is_up)                // Last data received was the up-key identifier
    {
        switch (sc)
        {

          case 0xF0 :        // The up-key identifier
            is_up = 1;
            break;

          case 0x12 :        // Left SHIFT
            lshift = 1;
            break;

          case 0x59 :        // Right SHIFT
            rshift = 1;
            break;

          case 0x14:         //CTRL
            if(is_extend != 0xE0)
              lctrl = 1;
            else
              rctrl = 1;
            break;

          case 0x11:         //Alt
            if(is_extend != 0xE0)
              lalt = 1;
            else
              ralt = 1;
            break;

          default:

               if(is_extend!=0xE0)
               {
                 for(i = 0; normal_keys[i].sc!=sc && normal_keys[i].sc; i++);
                 if(normal_keys[i].sc == sc)
                 {
                   if(!shift)                    // If shift not pressed,
                     kbd_keystroke(sc, normal_keys[i].unshifted, shift);
                   else
                     kbd_keystroke(sc, normal_keys[i].shifted, shift);
                 }
               }
               else  //extended 'make' scancode
               {
                 for(i = 0; extended_keys[i].sc!=sc && extended_keys[i].sc; i++);
                 if(extended_keys[i].sc == sc)
                 {
                   if(!shift)
                     kbd_keystroke(sc, extended_keys[i].unshifted, shift);
                   else
                     kbd_keystroke(sc, extended_keys[i].shifted, shift);
                 }
               }
               break;
        }  //switch (sc)
    } else {
        is_up = 0;                            // Two 0xF0 in a row not allowed
        switch (sc)
        {
          case 0x12 :                        // Left SHIFT
            lshift = 0;
            break;

          case 0x59 :                        // Right SHIFT
            rshift = 0;
            break;

          case 0x14:         //CTRL
            if(is_extend != 0xE0)
              lctrl = 0;
            else
              rctrl = 0;
            break;

          case 0x11:         //Alt
            if(is_extend != 0xE0)
              lalt = 0;
            else
              ralt = 0;
            break;
        }
    }

  if(sc != 0xF0)  //because release sequence for extended codes is : E0 F0 xx
    is_extend=sc;

}

interrupt [EXT_INT0] void ext_int0_isr(void)
{
  static unsigned char DataByte;  //Data received from keyboard

  //Simulate RS232 operation
  if (!Edge)                                // Routine entered at falling edge
  {
      if(ReceivedBitsCount < 11 && ReceivedBitsCount > 2)    // Bit 3 to 10 is data. Parity bit,
      {                                    // start and stop bits are ignored.
          DataByte = (DataByte >> 1);
          if(PIND & 8)
              DataByte = DataByte | 0x80;            // Store a '1'
      }

      MCUCR = (MCUCR & 0b11111100) | 0b00000011;                            // Set interrupt on rising edge
      Edge = 1;

  } else {                                // Routine entered at rising edge

      MCUCR = (MCUCR & 0b11111100) | 0b00000010;                            // Set interrupt on falling edge
      Edge = 0;

      if(--ReceivedBitsCount == 0)                    // All bits received
      {
          kbd_DecodeDataByte(DataByte);
          ReceivedBitsCount = 11;
      }
  }
}

unsigned char kbd_ReadKey(void)
{
    int byte;
    while(kbd_buffcount == 0);                        // Wait for data

    byte = *outpt;                                // Get byte
    outpt++;                                    // Increment pointer

    if (outpt >= kbd_buffer + KBD_BUFF_SIZE)            // Pointer wrapping
        outpt = kbd_buffer;

    kbd_buffcount--;                                    // Decrement buffer count

    return byte;
}

unsigned char kbd_KeyExists()
{
  return(kbd_buffcount > 0);
}
#include "solardate.c"
/* Solar Date Routines */

// the function check a miladiyear is leap or not.

unsigned char MiladiIsLeap(unsigned int miladiYear)
{
  if(((miladiYear % 100)!= 0 && (miladiYear % 4) == 0) || ((miladiYear % 100)== 0 && (miladiYear % 400) == 0))
    return 1;
  else
    return 0;
}

void MiladiToShamsi(unsigned int iMiladiYear, unsigned char iMiladiMonth, unsigned char iMiladiDay, unsigned int *SYear, unsigned char *SMonth, unsigned char *SDay)
{
  int shamsiDay, shamsiMonth, shamsiYear;
  int dayCount,farvardinDayDiff,deyDayDiff ;
  int sumDayMiladiMonth[] = {0,31,59,90,120,151,181,212,243,273,304,334};
  int sumDayMiladiMonthLeap[]= {0,31,60,91,121,152,182,213,244,274,305,335};

  farvardinDayDiff=79;

  if (MiladiIsLeap(iMiladiYear))
  {
    dayCount = sumDayMiladiMonthLeap[iMiladiMonth-1] + iMiladiDay;
  }
  else
  {
    dayCount = sumDayMiladiMonth[iMiladiMonth-1] + iMiladiDay;
  }

  if((MiladiIsLeap(iMiladiYear - 1)))
  {
    deyDayDiff = 11;
  }
  else
  {
    deyDayDiff = 10;
  }

  if (dayCount > farvardinDayDiff)
  {
    dayCount = dayCount - farvardinDayDiff;
    if (dayCount <= 186)
    {
      switch (dayCount%31) {
        case 0:
                shamsiMonth = dayCount / 31;
                shamsiDay = 31;
                break;
        default:
                shamsiMonth = (dayCount / 31) + 1;
                shamsiDay = (dayCount%31);
                break;
    }
    shamsiYear = iMiladiYear - 621;
  }
  else
  {
    dayCount = dayCount - 186;
    switch (dayCount%30) {
      case 0:
              shamsiMonth = (dayCount / 30) + 6;
              shamsiDay = 30;
              break;
      default:
              shamsiMonth = (dayCount / 30) + 7;
              shamsiDay = (dayCount%30);
              break;
    }
    shamsiYear = iMiladiYear - 621;
  }
}
else
{
  dayCount = dayCount + deyDayDiff;
  switch (dayCount%30) {
    case 0 :
            shamsiMonth = (dayCount / 30) + 9;
            shamsiDay = 30;
            break;
    default:
            shamsiMonth = (dayCount / 30) + 10;
            shamsiDay = (dayCount%30);
            break;
  }
  shamsiYear = iMiladiYear - 622;
}

  *SYear = shamsiYear;
  *SMonth = shamsiMonth;
  *SDay = shamsiDay;
}


void ShamsiToMiladi(unsigned int ShamsiYear, unsigned char ShamsiMonth, unsigned char ShamsiDay, unsigned int *MYear, unsigned char *MMonth, unsigned char *MDay)
{

int         iYear, iMonth, iDay;
int           marchDayDiff, remainDay;
int           dayCount, miladiYear, i;


// this buffer has day count of Miladi month from April to January for a none year.

int miladiMonth[12]  =  {30,31,30,31,31,30,31,30,31,31,28,31};
miladiYear = ShamsiYear + 621;

//Detemining the Farvardin the First

if(MiladiIsLeap(miladiYear))
{
//this is a Miladi leap year so Shamsi is leap too so the 1st of Farvardin is March 20 (3/20)
  marchDayDiff = 12;
}
else
{
//this is not a Miladi leap year so Shamsi is not leap too so the 1st of Farvardin is March 21 (3/21)
  marchDayDiff = 11;
}

// If next year is leap we will add one day to Feb.
if(MiladiIsLeap(miladiYear+1))
{
miladiMonth[10] = miladiMonth[10] + 1; //Adding one day to Feb
}

//Calculate the day count for input shamsi date from 1st Farvadin

if((ShamsiMonth>=1)&&( ShamsiMonth<=6))
 dayCount = (((int) ShamsiMonth-1) * 31) + ShamsiDay;
else
 dayCount =(6 * 31) + (((int) ShamsiMonth - 7) * 30) + ShamsiDay;

//Finding the correspond miladi month and day

if (dayCount <= marchDayDiff) //So we are in 20(for leap year) or 21for none leap year) to 31 march
{
 iDay = dayCount + (31 - marchDayDiff);
 iMonth = 3;
 iYear=miladiYear;
}
else

{
 remainDay = dayCount - marchDayDiff;


  i = 0; //starting from April

while ((remainDay > miladiMonth[i]))
{
 remainDay = remainDay - miladiMonth[i];
 i++;
}
 iDay = remainDay;

if (i > 8) // We are in the next Miladi Year
{
 iMonth = i - 8;
 iYear =  miladiYear + 1;
}
else
{
 iMonth = i + 4;
 iYear =  miladiYear;
 }

}

 *MYear = iYear;
 *MMonth = iMonth;
 *MDay = iDay;
}

#include <stdio.h>  /* Standard Input/Output functions */

// Alphanumeric LCD Module functions
#asm
    .equ __lcd_port=0x1B ;PORTA
#endasm
#include <lcd.h>

#include "debug.c"
//Debug routines

void lcd_puthex(unsigned char c)
{
  char s[10];

  sprintf(s, "%X", c);
  lcd_putsf(";");
  lcd_puts(s);
}

void lcd_putnumuc(unsigned char c)
{
  char s[10];

  sprintf(s, "%u", c);
  lcd_putsf(";");
  lcd_puts(s);
}

void lcd_putnumul(unsigned long n)
{
  char s[20];

  sprintf(s, "%d", n);
  lcd_putsf(";");
  lcd_puts(s);
}

void lcd_putnumi(int n)
{
  char s[20];

  sprintf(s, "%d", n);
  lcd_putsf(";");
  lcd_puts(s);
}

void lcd_putnumui(unsigned int n)
{
  char s[10];

  sprintf(s, "%u", n);
  lcd_putsf(";");
  lcd_puts(s);
}

void pulse(unsigned int delay)
{
  PORTA.7 = 1;
  delay_ms(delay);
  PORTA.7 = 0;
}

// I2C Bus functions
#asm
   .equ __i2c_port=0x15 ;PORTC
   .equ __sda_bit=1
   .equ __scl_bit=0
#endasm
#include <i2c.h>

#include "memory.c"  /* External EEPROM Memory Access Routines */
/* External EEPROM access routines */

typedef struct {
  unsigned long int start_addr;
  unsigned char data[CACHE_SIZE];
} TMemCache;

unsigned char EEPROM_BUS_ADDRESS;
TMemCache caches[CACHE_COUNT];

void mem_init()
{
  char i;

  for(i = 0; i < CACHE_COUNT; i++)
    caches[i].start_addr = 0xffffffff;
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

unsigned int MapMemoryAddress(unsigned long int addr)
{
  if( addr < ICSIZE )
  {
    EEPROM_BUS_ADDRESS = 0xa0;
    return addr;
  }
  else if( addr < (2 * ICSIZE - 1) )
  {
    EEPROM_BUS_ADDRESS = 0xa2;
    return addr - ICSIZE;
  }
  else if( addr < (3 * ICSIZE - 1) )
  {
    EEPROM_BUS_ADDRESS = 0xa4;
    return addr - 2 * ICSIZE;
  }
  else if( addr < (4 * ICSIZE - 1) )
  {
    EEPROM_BUS_ADDRESS = 0xa6;
    return addr - 3 * ICSIZE;
  }
  else
  {
    EEPROM_BUS_ADDRESS = 0xa8;
    return addr - 4 * ICSIZE;
  }
}

unsigned char mem_read(unsigned long int addr)
{
  unsigned int actual_addr;

  actual_addr = MapMemoryAddress(addr);
  return eeprom_read(actual_addr);
}

void mem_write(unsigned long int addr, unsigned char data)
{
  unsigned int actual_addr;

  actual_addr = MapMemoryAddress(addr);
  eeprom_write(actual_addr, data);
}

void mem_read_block(unsigned long int start_addr, unsigned int size, unsigned char data[])
{
  unsigned int actual_addr;
  unsigned int offset, read_size1, read_size2;

  actual_addr = MapMemoryAddress(start_addr);

  read_size1 = ICSIZE - actual_addr;
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
    actual_addr = MapMemoryAddress(start_addr + read_size1);  //Next memory address
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

void mem_write_block(unsigned long int start_addr, unsigned int size, unsigned char data[])
{
  //--> This function must be rewritten and be optimized for higher efficiency
  unsigned int offset;

  for(offset = 0; offset < size; offset++)
  {
    mem_write(start_addr + offset, data[offset]);
  }
}

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
#include <ds1307.h>  /* DS1307 Real Time Clock functions */
#include "datetime.c"  /* Date-Time Routines */
/* Date-Time Routines */

void get_time(TTime *time)
{
  unsigned char h, m, s;

/*
  -- FOR TEST --
  time->h = 19;
  time->m = 41;
  time->s = 34;
  return;
*/

  rtc_get_time(&h, &m, &s);
  time->h = h;
  time->m = m;
  time->s = s;
}

void set_time(TTime time)
{
  rtc_set_time(time.h, time.m, time.s);
}

unsigned long int time_elapsed(TTime time)
{
  TTime current;
  unsigned long int sum;

  get_time(&current);

  sum = (current.h - time.h) * 60 * 60;
  if(current.h == time.h)
  {
    sum = sum + (current.m - time.m) * 60;
  }
  else
  {
    sum = sum + current.m * 60 + (60 - time.m) * 60;
  }

  if(current.h == time.h && current.m == time.m)
  {
    sum = sum + (current.s - time.s);
  }
  else
  {
    sum = sum + current.s + (60 - time.s);
  }

  return(sum);
}

void get_date(unsigned int *year, unsigned char *month, unsigned char *day, unsigned char shamsi)
{
  //shamsi: 0 = Yes, 1 = No
  unsigned char y, m, d;

/*
  -- FOR TEST --
  *year = 1385;
  *month = 12;
  *day = 23;
  return;
*/

  rtc_get_date(&d, &m, &y);
  if(shamsi == 0)
  {
    *year = y + 2000;
    *month = m;
    *day = d;
  }
  else
  {
    MiladiToShamsi(y + 2000, m, d, year, month, day);
  }
}

void set_date(unsigned int year, unsigned char month, unsigned char day, unsigned char shamsi)
{
  //shamsi: 0 = Yes, 1 = No
  unsigned int y;
  unsigned char m, d;

  if(shamsi == 0)
  {
    y = year - 2000;
    m = month;
    d = day;
  }
  else
  {
    ShamsiToMiladi(year, month, day, &y, &m, &d);
    y = y - 2000;
  }

  rtc_set_date(d, m, y);
}
#include "adc.c"  /* ADC Routines */

#define ADC_VREF_TYPE 0xC0

// Read the AD conversion result
unsigned int read_adc(unsigned char adc_input)
{
ADMUX=adc_input | (ADC_VREF_TYPE & 0xff);
// Delay needed for the stabilization of the ADC input voltage
delay_us(10);
// Start the AD conversion
ADCSRA|=0x40;
// Wait for the AD conversion to complete
while ((ADCSRA & 0x10)==0);
ADCSRA|=0x10;
return ADCW;
}
#include "io_init.c"  //io_init()
void io_init()
{
  // Input/Output Ports initialization
  // Port A initialization
  // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
  // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
  PORTA=0x00;
  DDRA=0b10000000;

  // Port B initialization
  // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
  // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
  PORTB=0x00;
  DDRB=0xFF;

  // Port C initialization
  // Func7=Out Func6=Out Func5=Out Func4=Out Func3=In Func2=In Func1=In Func0=In
  // State7=0 State6=0 State5=0 State4=0 State3=T State2=T State1=T State0=T
  PORTC=0x00;
  DDRC=0xF8;

  // Port D initialization
  // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
  // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
  PORTD=0x00;
  DDRD=0b01111000;

  // Timer/Counter 0 initialization
  // Clock source: System Clock
  // Clock value: Timer 0 Stopped
  // Mode: Normal top=FFh
  // OC0 output: Disconnected
  TCCR0=0x00;
  TCNT0=0x00;
  OCR0=0x00;

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
  TCCR1A=0x00;
  TCCR1B=0x00;
  TCNT1H=0x00;
  TCNT1L=0x00;
  ICR1H=0x00;
  ICR1L=0x00;
  OCR1AH=0x00;
  OCR1AL=0x00;
  OCR1BH=0x00;
  OCR1BL=0x00;

  // Timer/Counter 2 initialization
  // Clock source: System Clock
  // Clock value: Timer 2 Stopped
  // Mode: Normal top=FFh
  // OC2 output: Disconnected
  ASSR=0x00;
  TCCR2=0x00;
  TCNT2=0x00;
  OCR2=0x00;

  // External Interrupt(s) initialization
  // INT0: Off
  // INT1: Off
  // INT2: Off
  MCUCR=0x00;
  MCUCSR=0x00;

  // Timer(s)/Counter(s) Interrupt(s) initialization
  TIMSK=0x00;

  // USART initialization
  // Communication Parameters: 8 Data, 1 Stop, No Parity
  // USART Receiver: On
  // USART Transmitter: On
  // USART Mode: Asynchronous
  // USART Baud Rate: 38400
//  UCSRA=0x00;
//  UCSRB=0x98;
//  UCSRC=0x86;  //**************************************************************** >>>>>>>>>>>>>>>>> Not supported in proteus
//  UBRRH=0x00;
//  UBRRL=0x11;

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

  // ADC initialization
  // ADC Clock frequency: 687.500 kHz
  // ADC Voltage Reference: Int., cap. on AREF
  ADMUX=ADC_VREF_TYPE & 0xff;
  ADCSRA=0x84;

  // I2C Bus initialization
  i2c_init();

  // DS1307 Real Time Clock initialization
  // Square wave output on pin SQW/OUT: Off
  // SQW/OUT pin state: 1
  rtc_init(0,0,1);

  // Watchdog Timer initialization
  // Watchdog Timer Prescaler: OSC/2048k
  //WDTCR=0x0F;

  // Global enable interrupts
  #asm("sei")
}
#include "temperature.c"
/* LM35 Temperature Sensor Functions */

/* LM35 output is connected to AD0. AD1 is connected to the GND. */


unsigned char round(float d)
{
  int r1;
  float t;

  r1 = floor(d);
  t = d - r1;
  if(t >= 0.5)
    r1++;
  return(r1);
}

void temperature_read(char *s, unsigned char unit)  //unit: 0 = Centigrade, 1 = Fahrenheit
{
  /* return temperatue in the form +/-45 */
  unsigned int adc_val, dc_val;
  float voltage;
  char voltage_sign;
  unsigned char temperature;
  int tc, f;

  adc_val = read_adc(16);
  if( (adc_val & 0x0200) != 0)
  {
    dc_val = ~(adc_val - 1) & 0x03ff;
    voltage_sign = 1;
  }
  else
  {
    dc_val = adc_val;
    voltage_sign = 0;
  }
  voltage = (float) dc_val * 5.0e-3;
  temperature = round(voltage * 100.0);
  if(temperature > 999 | temperature < -999)
    temperature = 0;

  //Check temperature unit
  if(voltage_sign == 1)
    tc = - (int) temperature;
  else
    tc = (int) temperature;
  if(unit == 1)
  {
    //Convert to fahrenheit
    f = (float) tc * 9.0 / 5.0 + 32.0;  //automatically rounded to an integer
    if(f < 0)
    {
      voltage_sign = 1;
      temperature = (unsigned char) -f;
    }
    else
    {
      voltage_sign = 0;
      temperature = f;
    }
  }

  if(voltage_sign == 1)
  {
    s[0] = '-';
    sprintf(&s[1], "%u", temperature);  //There was an error in direct conversion of negative values to string
  }
  else
  {
    sprintf(s, "%u", temperature);  //There was an error in direct conversion of negative values to string
  }
}


unsigned long TickCount = 0;


#include "screen.c"

//===================================================
//===================================================
//PIN configuration

unsigned char ROW_COUNT = 0;
unsigned char COL_COUNT = 0;

//===================================================
//===================================================

unsigned char Screen[MAX_ROW_COUNT / 8][MAX_COL_COUNT];
unsigned char AnimScreen[MAX_ROW_COUNT / 8][MAX_COL_COUNT];

TTime StageTime;

unsigned char StageCount, CurrentStageIndex;

TDisplayStage CurrentStage;
//unsigned char CurrentStageElapsedTime;  //in seconds
TStageSettings StageSettings;

#include "primary.c"
unsigned int MirrorBits(unsigned int w, unsigned char from_bit, unsigned char to_bit)
{
  unsigned int result, b1, b2;
  unsigned char i;

  b1 = 0xFFFF << from_bit;
  b2 = 0xFFFF >> (15 - to_bit);
  result = w & ~(b1 & b2);
  for(i = 0; i < (to_bit - from_bit + 1) / 2; i++)
  {
    #pragma warn-
    b1 = (w >> (from_bit + i)) & 0x0001;
    #pragma warn+
    b2 = (w >> (to_bit - i)) & 0x0001;

    #pragma warn-
    result = result | (b2 << (from_bit + i));
    #pragma warn+
    result = result | (b1 << (to_bit - i));
  }
  return(result);
}

unsigned int ShiftBitsLeft(unsigned int w, unsigned char from_bit, unsigned char to_bit, unsigned char shift_count)
{
  unsigned int b1, b2;
  unsigned int ba1, ba2;

  b1 = 0xFFFF << from_bit;
  b2 = 0xFFFF >> (15 - to_bit);
  ba1 = w & ~(b1 & b2);

  ba2 = w & (b1 & b2);
  ba2 <<= shift_count;
  ba2 &= (b1 & b2);

  return(ba1 | ba2);
}

unsigned int ShiftBitsRight(unsigned int w, unsigned char from_bit, unsigned char to_bit, unsigned char shift_count)
{
  unsigned int b1, b2;
  unsigned int ba1, ba2;

  b1 = 0xFFFF << from_bit;
  b2 = 0xFFFF >> (15 - to_bit);
  ba1 = w & ~(b1 & b2);

  ba2 = w & (b1 & b2);
  ba2 >>= shift_count;
  ba2 &= (b1 & b2);

  return(ba1 | ba2);
}

unsigned int AndBits(unsigned int w, unsigned char from_bit, unsigned char to_bit, unsigned int wa)
{
  unsigned int b1, b2;
  unsigned int ba1, ba2;

  b1 = 0xFFFF << from_bit;
  b2 = 0xFFFF >> (15 - to_bit);
  ba1 = w & (b1 & b2);

  ba1 &= wa;

  ba2 = w & ~(b1 & b2);

  return(ba1 | ba2);
}

unsigned int NotBits(unsigned int w, unsigned char from_bit, unsigned char to_bit)
{
  unsigned int b1, b2;
  unsigned int ba1, ba2;

  b1 = 0xFFFF << from_bit;
  b2 = 0xFFFF >> (15 - to_bit);

  ba1 = ~w & (b1 & b2);
  ba2 = w & ~(b1 & b2);
  return(ba1 | ba2);
}

void LEDPutChar(unsigned char x, unsigned char y, unsigned char flash *Data, unsigned char CharColCount)
{
  unsigned char b1, b2;
  unsigned char c, col;
  unsigned char ColCount, StartCol, EndCol;

  //If CharColCount is zero, get number of column from the first byte of the character data.
  if(CharColCount == 0)
  {
    ColCount = Data[0];
    StartCol = 1;
  }
  else
  {
    ColCount = CharColCount;
    StartCol = 0;
  }
  EndCol = StartCol + ColCount - 1;

  for(col = StartCol; col <= EndCol; col++)
  {
    //c = MirrorByte(Data[col]);
    c = MirrorBits((unsigned int) Data[col], 0, 7);

    b1 = c << y;
    b2 = c >> (8 - y);
    Screen[0][x] &= 0xFF >> (8 - y);
    Screen[1][x] &= 0xFF << y;
    Screen[0][x] |= b1;
    Screen[1][x] |= b2;
    x++;
  }
}

/*
flash unsigned char RowSelectors[32] = {
1, 2, 4, 8, 16, 32, 64, 128,
1, 2, 4, 8, 16, 32, 64, 128,
1, 2, 4, 8, 16, 32, 64, 128,
1, 2, 4, 8, 16, 32, 64, 128
};
*/

flash unsigned char RowSelectors[32] = {
128, 64, 32, 16, 8, 4, 2, 1,
128, 64, 32, 16, 8, 4, 2, 1,
128, 64, 32, 16, 8, 4, 2, 1,
128, 64, 32, 16, 8, 4, 2, 1
};

void SelectRow(unsigned char row /*starting from 0*/)
{
  //unsigned char temp;

  /*
  0..7: clkR0=PORTD.3
  8..15: clkR0=PORTD.4
  16..23: clkR0=PORTD.5
  24..31: clkR0=PORTD.6
  */

  //temp = 0x01 << (row % 8);
  //PORTB = temp;
  PORTB = RowSelectors[row];

  //Generate pulse
  if(row < 8)
  {
    PORTD.3 = 1;
    //delay_us(LATCH_PULSE_DURATION);
    PORTD.3 = 0;
  }
  else if(row <= 15)
  {
    PORTD.4 = 1;
    //delay_us(LATCH_PULSE_DURATION);
    PORTD.4 = 0;
  }
  else if(row <= 23)
  {
    PORTD.5 = 1;
    //delay_us(LATCH_PULSE_DURATION);
    PORTD.5 = 0;
  }
  else
  {
    PORTD.6 = 1;
    //delay_us(LATCH_PULSE_DURATION);
    PORTD.6 = 0;
  }
}

flash unsigned char RowCatcherBytes[8] = {
0b00000001, 0b00000010, 0b00000100, 0b00001000,
0b00010000, 0b00100000, 0b01000000, 0b10000000
};

unsigned char GetRowData(unsigned char Row, unsigned char FromCol, unsigned char ToCol)
{
  //Row starting from 0
  unsigned char RowData = 0x00;
  unsigned char i, temp, bitpos = 0;
  unsigned char a;
  unsigned char r;
  //unsigned char r_index;

  //a = 0b10000000 >> (7 - Row);
  //r_index = Row / 8;
/*  return( (Screen[0][FromCol] & a) >> Row |
  ((Screen[r_index][FromCol + 1] & a) >> Row) << 1 |
  ((Screen[r_index][FromCol + 2] & a) >> Row) << 2 |
  ((Screen[r_index][FromCol + 3] & a) >> Row) << 3 |
  ((Screen[r_index][FromCol + 4] & a) >> Row) << 4 |
  ((Screen[r_index][FromCol + 5] & a) >> Row) << 5 |
  ((Screen[r_index][FromCol + 6] & a) >> Row) << 6 |
  ((Screen[r_index][FromCol + 7] & a) >> Row) << 7
  );*/

  if(Row < 8)
  {
    //a = 0b10000000 >> (7 - Row);
    r = Row;
    a = RowCatcherBytes[r];

    for(i = FromCol; i <= ToCol; i++)
    {
      temp = (Screen[0][i]) & a;
      temp = temp >> r;
      RowData |= temp << bitpos;
      bitpos++;
    }
    return(RowData);
  }
  else if(Row < 16)
  {
    //a = 0b10000000 >> (15 - Row);
    r = Row - 8;
    a = RowCatcherBytes[r];

    for(i = FromCol; i <= ToCol; i++)
    {
      temp = (Screen[1][i]) & a;
      temp = temp >> r;
      RowData |= temp << bitpos;
      bitpos++;
    }
    return(RowData);
  }
  else if(Row < 24)
  {
    //a = 0b10000000 >> (23 - Row);
    r = Row - 16;
    a = RowCatcherBytes[r];

    for(i = FromCol; i <= ToCol; i++)
    {
      temp = (Screen[2][i]) & a;
      temp = temp >> r;
      RowData |= temp << bitpos;
      bitpos++;
    }
    return(RowData);
  }
  else if(Row < 32)
  {
    //a = 0b10000000 >> (31 - Row);
    r = Row - 24;
    a = RowCatcherBytes[r];

    for(i = FromCol; i <= ToCol; i++)
    {
      temp = (Screen[3][i]) & a;
      temp = temp >> r;
      RowData |= temp << bitpos;
      bitpos++;
    }
    return(RowData);
  }
}

flash unsigned char ColumnLatchSelector[16] = {
0x80, 0x88, 0x90, 0x98, 0xa0, 0xa8, 0xb0, 0xb8,
0xc0, 0xc8, 0xd0, 0xd8, 0xe0, 0xe8, 0xf0, 0xf8
};

void PutDataOnColumnLatch(unsigned char LatchNum, unsigned char Data)
{
  // >> LatchNum starting from 0 <<

  PORTB = ~Data;  //We select rows, so to light a LED in a column, make that column GND

  //PORTC = (LatchNum << 3) | 0x80;
  PORTC = ColumnLatchSelector[LatchNum];

  //Generate a pulse
  //Enable and disable decoder output
  PORTC.7 = 0;
  //delay_us(LATCH_PULSE_DURATION);  //Pulse duration
  PORTC.7 = 1;
}

#define LATCH_COUNT (COL_COUNT / 8)
void RefreshDisplayLatch()
{
  static unsigned char Row = 0;
  unsigned char i;
  unsigned char FromCol;
  static unsigned char LatchToDisable = 0;
  unsigned char latch_count;

  latch_count = LATCH_COUNT;

  //iterate through latches
  //=========================================================
  //LatchNum starting from 0
  PORTB = 0x00;  //We select rows, so to light a LED in a column, make that column GND
  for(i = 0; i < latch_count; i++)
  {
    //PutDataOnColumnLatch(i, 0);  --> Converted to direct code for more speed

    //PORTC = (/*LatchNum*/ i << 3) | 0x80;
    PORTC = ColumnLatchSelector[i];

    //Generate a pulse
    //Enable and disable decoder output
    PORTC.7 = 0;
    //delay_us(LATCH_PULSE_DURATION);  //Pulse duration
    PORTC.7 = 1;
  }
  //=========================================================

  SelectRow(Row);

  if((Row % 8) == 0)
  {
    //Disable latch no. LatchToDisable
    PORTB = 0x00;

    //Generate pulse
    switch(LatchToDisable)
    {
      case 1:
        PORTD.3 = 1;
        //delay_us(LATCH_PULSE_DURATION);
        PORTD.3 = 0;
        break;
      case 2:
        PORTD.4 = 1;
        //delay_us(LATCH_PULSE_DURATION);
        PORTD.4 = 0;
        break;
      case 3:
        PORTD.5 = 1;
        //delay_us(LATCH_PULSE_DURATION);
        PORTD.5 = 0;
        break;
      case 4:
        PORTD.6 = 1;
        //delay_us(LATCH_PULSE_DURATION);
        PORTD.6 = 0;
        break;
    }
  }


  //iterate through latches
  //=========================================================
  FromCol = 0;
  for(i = 0; i < latch_count; i++)
  {
    //PutDataOnColumnLatch(i, GetRowData(Row, i * 8, i * 8 + 7));

    //LatchNum starting from 0
    PORTB = GetRowData(Row, FromCol, FromCol + 7);  //We select rows, so to light a LED in a column, make that column GND

    //PORTC = (/*LatchNum*/ i << 3) | 0x80;
    PORTC = ColumnLatchSelector[i];

    //Generate a pulse
    //Enable and disable decoder output
    PORTC.7 = 0;
    //delay_us(LATCH_PULSE_DURATION);  //Pulse duration
    PORTC.7 = 1;

    FromCol += 8;
  }
  //=========================================================

  Row++;
  if((ROW_COUNT > 8) && (Row % 8) == 0)
  {
    LatchToDisable = Row >> 3;  //Row / 8;
  }
  if(Row == ROW_COUNT)
    Row = 0;
}

/*void RefreshDisplayLatch()
{
  static unsigned char Row = 0;
  unsigned char i;

  //iterate through latches
  for(i = 0; i < latch_count; i++)
  {
    PutDataOnColumnLatch(i, 0);
  }

  SelectRow(Row);

  //iterate through latches
  for(i = 0; i < latch_count; i++)
  {
    PutDataOnColumnLatch(i, GetRowData(Row, i * 8, i * 8 + 7));
  }

  Row++;
  if(Row == ROW_COUNT)
    Row = 0;
}*/

void ClearScreen()
{
  unsigned char Col;

  //Speed up this routine
  if(ROW_COUNT <= 8)
  {
    for(Col = 0; Col < COL_COUNT; Col++)
    {
      Screen[0][Col] = 0x00;
    }
  }
  else if(ROW_COUNT <= 16)
  {
    for(Col = 0; Col < COL_COUNT; Col++)
    {
      Screen[0][Col] = 0x00;
      Screen[1][Col] = 0x00;
    }
  }
}

void ClearArea(TArea Area)
{
  unsigned char col;
  unsigned int b1, b2, b;

  b1 = 0xFFFF << Area.y1;
  b2 = 0xFFFF >> (15 - Area.y2);
  b = ~(b1 & b2);

  for(col = Area.x1; col <= Area.x2; col++)
  {

    b1 = Screen[1][col];
    b1 = (b1 << 8) | Screen[0][col];

    b1 = b & b1;
    //c is 0x00
    //c <<= Area.y1;
    //b1 |= c;

    Screen[0][col] = b1;
    Screen[1][col] = b1 >> 8;
  }
}

#include "internal_fonts.c"
//Internal fonts and symbols stored in the internal EEPROM memory and program memory (FLASH)

flash unsigned char LEDDigitsFa[10][9] = {
{8, 0x00, 0x00, 0x38, 0x28, 0x38, 0x00, 0x00, 0x00},  //0
{8, 0x00, 0x00, 0x00, 0x00, 0x7E, 0x00, 0x00, 0x00},  //1
{8, 0x00, 0x00, 0x7E, 0x10, 0x10, 0x60, 0x00, 0x00},  //2
{8, 0x00, 0x7E, 0x10, 0x10, 0x70, 0x10, 0x70, 0x00},  //3
{8, 0x00, 0x00, 0x7E, 0x10, 0x70, 0x50, 0x50, 0x00},  //4
{8, 0x00, 0x0E, 0x32, 0x66, 0x26, 0x12, 0x0E, 0x00},  //5
{8, 0x00, 0x00, 0x72, 0x54, 0x58, 0x10, 0x00, 0x00},  //6
{8, 0x00, 0x40, 0x38, 0x06, 0x18, 0x60, 0x00, 0x00},  //7
{8, 0x00, 0x02, 0x1C, 0x60, 0x18, 0x06, 0x00, 0x00},  //8
{8, 0x00, 0x00, 0x70, 0x50, 0x70, 0x3E, 0x00, 0x00}   //9
};

flash unsigned char LEDDigitsEn[10][9] = {
{8, 0x00, 0x7C, 0xFE, 0x82, 0x92, 0x82, 0xFE, 0x7C},  //0
{8, 0x00, 0x22, 0x42, 0xFE, 0xFE, 0x02, 0x02, 0x00},  //1
{8, 0x00, 0x46, 0xCE, 0x9A, 0x92, 0xF6, 0x66, 0x00},  //2
{8, 0x00, 0x44, 0xC6, 0x92, 0x92, 0xFE, 0x6C, 0x00},  //3
{8, 0x00, 0x18, 0x38, 0x68, 0xCA, 0xFE, 0xFE, 0x0A},  //4
{8, 0x00, 0xE4, 0xE6, 0xA2, 0xA2, 0xBE, 0x9C, 0x00},  //5
{8, 0x00, 0x3C, 0x7E, 0xD2, 0x92, 0x9E, 0x0C, 0x00},  //6
{8, 0x00, 0xC0, 0xC0, 0x8E, 0x9E, 0xF0, 0xE0, 0x00},  //7
{8, 0x00, 0x6C, 0xFE, 0x92, 0x92, 0xFE, 0x6C, 0x00},  //8
{8, 0x00, 0x60, 0xF2, 0x92, 0x96, 0xFC, 0x78, 0x00}   //9
};

flash unsigned char LEDDigitsSmallFa[10][7] = {
{6, 0x00, 0x1C, 0x22, 0x22, 0x22, 0x1C},  //0
{6, 0x00, 0x00, 0x7E, 0x7E, 0x00, 0x00},  //1
{6, 0x00, 0x7E, 0x10, 0x70, 0x00, 0x00},  //2
{6, 0x00, 0x7E, 0x10, 0x70, 0x10, 0x70},  //3
{6, 0x00, 0x7E, 0x10, 0x70, 0x50, 0x00},  //4
{6, 0x00, 0x3E, 0x72, 0x66, 0x72, 0x3E},  //5
{6, 0x00, 0x73, 0xF6, 0x9C, 0x98, 0xB0},  //6
{6, 0x00, 0x70, 0x1E, 0x03, 0x1E, 0x70},  //7
{6, 0x00, 0x07, 0x3C, 0x60, 0x3C, 0x07},  //8
{6, 0x00, 0x30, 0x48, 0x48, 0x48, 0x7F}  //9
};

flash unsigned char Colon[5] = {
4,  //Character column count
0x00, 0x66, 0x66, 0x00
};

flash unsigned char Slash[9] = {
8, 0x00, 0x06, 0x0C, 0x18, 0x30, 0x60, 0x40, 0x00
};

flash unsigned char Dash[9] = {
8, 0x00, 0x10, 0x10, 0x10, 0x10, 0x10, 0x10, 0x00
};

flash unsigned char Positive[9] = {
8, 0x00, 0x10, 0x10, 0x7C, 0x10, 0x10, 0x00, 0x00
};

flash unsigned char DegreeCentigradeSign[13] =
{
12,
0x00, 0x70, 0x50, 0x70, 0x00, 0x1C, 0x3E, 0x63, 0x41, 0x41, 0x63, 0x22
};

flash unsigned char DegreeFahrenheitSign[13] =
{
12,
0x00, 0x70, 0x50, 0x70, 0x00, 0x41, 0x7F, 0x7F, 0x49, 0x5C, 0x40, 0x60
};

//flash unsigned char LEDLettersEn[26][9] = {
//};

#include "mem_map.c"
void get_global_settings(TGlobalSettings *gs)
{
  mem_read_block(0, sizeof(TGlobalSettings), gs);
}

void Stages(unsigned char StageIndex /*starting from 0*/, TDisplayStage *Stage)
{
  unsigned long int addr;

  addr = sizeof(TGlobalSettings) + StageIndex * sizeof(TDisplayStage);
  mem_read_block(addr, sizeof(TDisplayStage), Stage);
}

unsigned long int data_pointers_addr[4];

unsigned long int CalcStageTotalDataSize(unsigned char s_index)
{
  unsigned long int StageDataSize = 0;
  unsigned char i;
  TDisplayStage ThisStage;

  Stages(s_index, &ThisStage);
  for(i = 0; i < 4; i++)
    if(ThisStage.Areas[i].ContentType != 0)  //if not an unused area
      StageDataSize = StageDataSize + ThisStage.Areas[i].DataSize;

  return(StageDataSize);
}

void update_data_pointers(unsigned char s_index /*stage index*/)
{
  unsigned long int stage_data_offset;
  TDisplayStage ds;
  unsigned char i;

  //Calc data offset of the new stage
  #pragma warn-
  stage_data_offset = sizeof(TGlobalSettings) + sizeof(TDisplayStage) * StageCount;
  for(i = 0; i < s_index; i++)
    stage_data_offset = stage_data_offset + CalcStageTotalDataSize(i);
  #pragma warn+

  data_pointers_addr[0] = stage_data_offset;
  Stages(s_index, &ds);
  for(i = 1; i < 4; i++)
    data_pointers_addr[i] = data_pointers_addr[i - 1] + ds.Areas[i - 1].DataSize;
}

unsigned char DataPointers(unsigned char AreaIndex, unsigned long int offset)
{
  return(mem_read_cache(data_pointers_addr[AreaIndex] + offset));
}

//-------------------------------------------------
void get_content_settings(unsigned char dp_index, unsigned char size, unsigned char *data)
{
  unsigned char i;

  for(i = 0; i < size /*for Data[1]*/; i++)
  {
    data[i] = DataPointers(dp_index, i);
  }
}

unsigned char fa_Data(unsigned char dp_index, unsigned long int offset)
{
  return(DataPointers(dp_index, sizeof(TFramedAnimation) - 1 /*for Data[1]*/ + offset));
}

unsigned char slst_Data(unsigned char dp_index, unsigned long int offset)
{
  return(DataPointers(dp_index, sizeof(TSingleLineScrollingText) - 1 /*for Data[1]*/ + offset));
}

#include "Animations.c"
//Animations
typedef struct
{
  unsigned char NextCol;
  unsigned char AnimStage;
} TAnimSettings;

TAnimSettings as[4];

unsigned char Anim1(unsigned char AreaID, TArea Area);
void InitAnim1(unsigned char AreaID, TArea Area);
unsigned char Anim2(unsigned char AreaID, TArea Area);
void InitAnim2(unsigned char AreaID, TArea Area);
unsigned char Anim3(unsigned char AreaID, TArea Area);
void InitAnim3(unsigned char AreaID, TArea Area);
unsigned char Anim4(unsigned char AreaID, TArea Area);
void InitAnim4(unsigned char AreaID, TArea Area);
unsigned char Anim5(unsigned char AreaID, TArea Area);
void InitAnim5(unsigned char AreaID, TArea Area);
unsigned char Anim6(unsigned char AreaID, TArea Area);
void InitAnim6(unsigned char AreaID, TArea Area);
unsigned char Anim7(unsigned char AreaID, TArea Area);
void InitAnim7(unsigned char AreaID, TArea Area);
unsigned char Anim8(unsigned char AreaID, TArea Area);
void InitAnim8(unsigned char AreaID, TArea Area);
unsigned char Anim9(unsigned char AreaID, TArea Area);
void InitAnim9(unsigned char AreaID, TArea Area);
unsigned char Anim10(unsigned char AreaID, TArea Area);
void InitAnim10(unsigned char AreaID, TArea Area);
unsigned char Anim11(unsigned char AreaID, TArea Area);
void InitAnim11(unsigned char AreaID, TArea Area);
unsigned char Anim12(unsigned char AreaID, TArea Area);
void InitAnim12(unsigned char AreaID, TArea Area);
unsigned char Anim13(unsigned char AreaID, TArea Area);
void InitAnim13(unsigned char AreaID, TArea Area);
unsigned char Anim14(unsigned char AreaID, TArea Area);
void InitAnim14(unsigned char AreaID, TArea Area);
unsigned char Anim15(unsigned char AreaID, TArea Area);
void InitAnim15(unsigned char AreaID, TArea Area);

unsigned char ApplyAnimation(unsigned char AreaID, TArea Area, unsigned char AnimID)
{
//Returns 1 if the animation is done
  switch(AnimID)
  {
    case 1:
      return(Anim1(AreaID, Area));
      break;
    case 2:
      return(Anim2(AreaID, Area));
      break;
    case 3:
      return(Anim3(AreaID, Area));
      break;
    case 4:
      return(Anim4(AreaID, Area));
      break;
    case 5:
      return(Anim5(AreaID, Area));
      break;
    case 6:
      return(Anim6(AreaID, Area));
      break;
    case 7:
      return(Anim7(AreaID, Area));
      break;
    case 8:
      return(Anim8(AreaID, Area));
      break;
    case 9:
      return(Anim9(AreaID, Area));
      break;
    case 10:
      return(Anim10(AreaID, Area));
      break;
    case 11:
      return(Anim11(AreaID, Area));
      break;
    case 12:
      return(Anim12(AreaID, Area));
      break;
    case 13:
      return(Anim13(AreaID, Area));
      break;
    case 14:
      return(Anim14(AreaID, Area));
      break;
    case 15:
      return(Anim15(AreaID, Area));
      break;
  }
}

void InitAnim(unsigned char AreaID, TArea Area, unsigned char AnimID)
{
  switch(AnimID)
  {
    case 1:
      InitAnim1(AreaID, Area);
      break;
    case 2:
      InitAnim2(AreaID, Area);
      break;
    case 3:
      InitAnim3(AreaID, Area);
      break;
    case 4:
      InitAnim4(AreaID, Area);
      break;
    case 5:
      InitAnim5(AreaID, Area);
      break;
    case 6:
      InitAnim6(AreaID, Area);
      break;
    case 7:
      InitAnim7(AreaID, Area);
      break;
    case 8:
      InitAnim8(AreaID, Area);
      break;
    case 9:
      InitAnim9(AreaID, Area);
      break;
    case 10:
      InitAnim10(AreaID, Area);
      break;
    case 11:
      InitAnim11(AreaID, Area);
      break;
    case 12:
      InitAnim12(AreaID, Area);
      break;
    case 13:
      InitAnim13(AreaID, Area);
      break;
    case 14:
      InitAnim14(AreaID, Area);
      break;
    case 15:
      InitAnim15(AreaID, Area);
      break;
  }
}

////////////  ANIMATIONS

void InitAnim1(unsigned char AreaID, TArea Area)
{
  as[AreaID].NextCol = 0;
}

unsigned char Anim1(unsigned char AreaID, TArea Area)
{
  //Fill from left
  //static unsigned char NextCol = 0;
  unsigned int b1, b2, b, c;


      b1 = 0xFFFF << Area.y1;
      b2 = 0xFFFF >> (15 - Area.y2);
      b = (b1 & b2);

      //b1 = 0;
      //if(BytesPerCol == 2)
        b1 = AnimScreen[1][as[AreaID].NextCol + Area.x1];
      b1 = (b1 << 8) | AnimScreen[0][as[AreaID].NextCol + Area.x1];

      b = b & b1;
//      c <<= Area.y1;
//      b |= c;
  c = b;

      b1 = 0xFFFF << Area.y1;
      b2 = 0xFFFF >> (15 - Area.y2);
      b = ~(b1 & b2);

      //b1 = 0;
      //if(BytesPerCol == 2)
        b1 = Screen[1][as[AreaID].NextCol + Area.x1];
      b1 = (b1 << 8) | Screen[0][as[AreaID].NextCol + Area.x1];

      //c = AnimScreen[0][as[AreaID].NextCol];
      //c

      b = b & b1;
      //c <<= Area.y1;
      b |= c;

        Screen[0][as[AreaID].NextCol + Area.x1] = b;
        Screen[1][as[AreaID].NextCol + Area.x1] = b >> 8;
//      Screen[0][as[AreaID].NextCol + Area.x1] = c;
      as[AreaID].NextCol++;
      if(as[AreaID].NextCol + Area.x1 > Area.x2)
        return(TRUE);
      else
        return(FALSE);
}

void InitAnim2(unsigned char AreaID, TArea Area)
{
  as[AreaID].NextCol = 0;
}

unsigned char Anim2(unsigned char AreaID, TArea Area)
{
  //Fill from right
  //static unsigned char NextCol = 0;
  unsigned int b1, b2, b, c;


      b1 = 0xFFFF << Area.y1;
      b2 = 0xFFFF >> (15 - Area.y2);
      b = (b1 & b2);

      //b1 = 0;
      //if(BytesPerCol == 2)
        b1 = AnimScreen[1][Area.x2 - as[AreaID].NextCol];
      b1 = (b1 << 8) | AnimScreen[0][Area.x2 - as[AreaID].NextCol];

      b = b & b1;
//      c <<= Area.y1;
//      b |= c;
  c = b;

      b1 = 0xFFFF << Area.y1;
      b2 = 0xFFFF >> (15 - Area.y2);
      b = ~(b1 & b2);

      //b1 = 0;
      //if(BytesPerCol == 2)
        b1 = Screen[1][Area.x2 - as[AreaID].NextCol];
      b1 = (b1 << 8) | Screen[0][Area.x2 - as[AreaID].NextCol];

      //c = AnimScreen[0][as[AreaID].NextCol];
      //c

      b = b & b1;
      //c <<= Area.y1;
      b |= c;

        Screen[0][Area.x2 - as[AreaID].NextCol] = b;
        Screen[1][Area.x2 - as[AreaID].NextCol] = b >> 8;
//      Screen[0][Area.x2 - as[AreaID].NextCol] = c;
      as[AreaID].NextCol++;
      if(Area.x2 - as[AreaID].NextCol <= Area.x1)
        return(TRUE);
      else
        return(FALSE);
}

void InitAnim3(unsigned char AreaID, TArea Area)
{
  as[AreaID].NextCol = Area.y2 - Area.y1 + 1;
}

unsigned char Anim3(unsigned char AreaID, TArea Area)
{
  //Dividing lines
  unsigned char Col;
  unsigned int b1, b2, b, c;

  for(Col = Area.x1; Col <= Area.x2; Col++)
  {
      b1 = 0xFFFF << Area.y1;
      b2 = 0xFFFF >> (15 - Area.y2);
      b = (b1 & b2);

      //b1 = 0;
      //if(BytesPerCol == 2)
        b1 = AnimScreen[1][Col];
      b1 = (b1 << 8) | AnimScreen[0][Col];

      b = b & b1;
   //      c <<= Area.y1;
   //      b |= c;
    c = b;

    if((Col % 4 == 0) || (Col % 4 == 1))
    {
      c <<= as[AreaID].NextCol;
    }
    else if((Col % 4 == 2) || (Col % 4 == 3))
    {
      c >>= as[AreaID].NextCol;
    }

      b1 = 0xFFFF << Area.y1;
      b2 = 0xFFFF >> (15 - Area.y2);
      b = ~(b1 & b2);

      //b1 = 0;
      //if(BytesPerCol == 2)
        b1 = Screen[1][Col];
      b1 = (b1 << 8) | Screen[0][Col];

      //c = AnimScreen[0][as[AreaID].NextCol];
      //c

      b = b & b1;
      //c <<= Area.y1;
      b |= c;

        Screen[0][Col] = b;
        Screen[1][Col] = b >> 8;

  }
  as[AreaID].NextCol--;
  if(as[AreaID].NextCol == 0)
    return(TRUE);
  else
    return(FALSE);
}

void InitAnim4(unsigned char AreaID, TArea Area)
{
  as[AreaID].NextCol = 0;
  as[AreaID].AnimStage = 0;
}

unsigned char Anim4(unsigned char AreaID, TArea Area)
{
  //Å— ‘œ‰ «“ »«·« »’Ê—  ” Ê‰Ì Ìò œ— „Ì«‰
  unsigned char Col;
  unsigned int b1, b2, b, c;
  unsigned char filter;

  if(as[AreaID].AnimStage == 0)
    Col = Area.x1;
  else
    Col = Area.x1 + 1;

  filter = ~(0xffff << (as[AreaID].NextCol + Area.y1));

  for(; Col <= Area.x2; Col+=2)
  {
      b1 = 0xFFFF << Area.y1;
      b2 = 0xFFFF >> (15 - Area.y2);
      b = (b1 & b2);

      //b1 = 0;
      //if(BytesPerCol == 2)
        b1 = AnimScreen[1][Col];
      b1 = (b1 << 8) | AnimScreen[0][Col];

      b = b & b1;
   //      c <<= Area.y1;
   //      b |= c;
    c = b;

    c &= filter;

      b1 = 0xFFFF << Area.y1;
      b2 = 0xFFFF >> (15 - Area.y2);
      b = ~(b1 & b2);

      //b1 = 0;
      //if(BytesPerCol == 2)
        b1 = Screen[1][Col];
      b1 = (b1 << 8) | Screen[0][Col];

      //c = AnimScreen[0][as[AreaID].NextCol];
      //c

      b = b & b1;
      //c <<= Area.y1;
      b |= c;

        Screen[0][Col] = b;
        Screen[1][Col] = b >> 8;

  }

  as[AreaID].NextCol++;
  if(as[AreaID].NextCol >= (Area.y2 - Area.y1 + 1))
  {
    if(as[AreaID].AnimStage == 0)
    {
      as[AreaID].AnimStage = 1;
      as[AreaID].NextCol = 0;
    }
    else
    {
      return(TRUE);
    }
  }

  return(FALSE);
}

void InitAnim5(unsigned char AreaID, TArea Area)
{
  as[AreaID].NextCol = Area.y2 - Area.y1 + 1;
}

unsigned char Anim5(unsigned char AreaID, TArea Area)
{
  //‘Ì›  «“ »«·« ÅÂ Å«ÌÌ‰ Ê Õ—ò  »Â ”„  —«” 
  unsigned char Col;
  unsigned int b1, b2, b, c;

  for(Col = Area.x1; Col <= Area.x2; Col++)
  {
      b1 = 0xFFFF << Area.y1;
      b2 = 0xFFFF >> (15 - Area.y2);
      b = (b1 & b2);

      //b1 = 0;
      //if(BytesPerCol == 2)
        b1 = AnimScreen[1][Col];
      b1 = (b1 << 8) | AnimScreen[0][Col];

      b = b & b1;
   //      c <<= Area.y1;
   //      b |= c;
    c = b;

    c <<= Area.y1;
    //c >>= as[AreaID].NextCol;
    c = ShiftBitsRight(c, Area.y1, Area.y2, as[AreaID].NextCol);

      b1 = 0xFFFF << Area.y1;
      b2 = 0xFFFF >> (15 - Area.y2);
      b = ~(b1 & b2);

      //b1 = 0;
      //if(BytesPerCol == 2)
        b1 = Screen[1][Col];
      b1 = (b1 << 8) | Screen[0][Col];

      //c = AnimScreen[0][as[AreaID].NextCol];
      //c

      b = b & b1;
      //c <<= Area.y1;
      b |= c;

        Screen[0][Col] = b;
        Screen[1][Col] = b >> 8;

  }
  as[AreaID].NextCol--;
  if(as[AreaID].NextCol == 0)
    return(TRUE);
  else
    return(FALSE);
}

void InitAnim6(unsigned char AreaID, TArea Area)
{
  as[AreaID].NextCol = Area.y2 - Area.y1 + 1;
}

unsigned char Anim6(unsigned char AreaID, TArea Area)
{
  //‘Ì›  «“ Å«ÌÌ‰ »Â »«·« Ê Õ—ò  »Â ”„  —«” 
  unsigned char Col;
  unsigned int b1, b2, b, c;

  for(Col = Area.x1; Col <= Area.x2; Col++)
  {
      b1 = 0xFFFF << Area.y1;
      b2 = 0xFFFF >> (15 - Area.y2);
      b = (b1 & b2);

      //b1 = 0;
      //if(BytesPerCol == 2)
        b1 = AnimScreen[1][Col];
      b1 = (b1 << 8) | AnimScreen[0][Col];

      b = b & b1;
   //      c <<= Area.y1;
   //      b |= c;
    c = b;

    c <<= Area.y1;
    //c <<= as[AreaID].NextCol;
    c = ShiftBitsLeft(c, Area.y1, Area.y2, as[AreaID].NextCol);

      b1 = 0xFFFF << Area.y1;
      b2 = 0xFFFF >> (15 - Area.y2);
      b = ~(b1 & b2);

      //b1 = 0;
      //if(BytesPerCol == 2)
        b1 = Screen[1][Col];
      b1 = (b1 << 8) | Screen[0][Col];

      //c = AnimScreen[0][as[AreaID].NextCol];
      //c

      b = b & b1;
      //c <<= Area.y1;
      b |= c;

        Screen[0][Col] = b;
        Screen[1][Col] = b >> 8;

  }
  as[AreaID].NextCol--;
  if(as[AreaID].NextCol == 0)
    return(TRUE);
  else
    return(FALSE);
}

void InitAnim7(unsigned char AreaID, TArea Area)
{
  as[AreaID].NextCol = 0;
}

unsigned char Anim7(unsigned char AreaID, TArea Area)
{
  //Å—‘œ‰ »Â ’Ê—  „Ì·Â «Ì «“ Å«ÌÌ‰ «“ ”„  —«”  »Â çÅ
  unsigned char Col;
  unsigned int b1, b2, b, c, c1;
  int shift_outside;


  Col = Area.x2 - as[AreaID].NextCol;

      b1 = 0xFFFF << Area.y1;
      b2 = 0xFFFF >> (15 - Area.y2);
      b = (b1 & b2);

      //b1 = 0;
      //if(BytesPerCol == 2)
        b1 = AnimScreen[1][Col];
      b1 = (b1 << 8) | AnimScreen[0][Col];

      b = b & b1;
   //      c <<= Area.y1;
   //      b |= c;
    c = b;
    c1 = c;

  if(c1 != 0)
  {
    for(shift_outside = Area.y2 - Area.y1 + 1; shift_outside >= 0; shift_outside--)
    {
      c = c1 << Area.y1;
      c = ShiftBitsLeft(c, Area.y1, Area.y2, shift_outside);

        b1 = 0xFFFF << Area.y1;
        b2 = 0xFFFF >> (15 - Area.y2);
        b = ~(b1 & b2);

        //b1 = 0;
        //if(BytesPerCol == 2)
          b1 = Screen[1][Col];
        b1 = (b1 << 8) | Screen[0][Col];

        //c = AnimScreen[0][as[AreaID].NextCol];
        //c

        b = b & b1;
        //c <<= Area.y1;
        b |= c;

          Screen[0][Col] = b;
          Screen[1][Col] = b >> 8;

          delay_ms(30);
    }
  }

  as[AreaID].NextCol++;
  if((Area.x2 - as[AreaID].NextCol) <= Area.x1)
    return(TRUE);
  else
    return(FALSE);
}

void InitAnim8(unsigned char AreaID, TArea Area)
{
  as[AreaID].NextCol = 0;
  as[AreaID].AnimStage = 0;
}

unsigned char Anim8(unsigned char AreaID, TArea Area)
{
  //Å—‘œ‰ »’Ê—  „Ì·Â «Ì «“ »«·« Ê Å«ÌÌ‰ «“ ”„  —«”  »Â çÅ
  unsigned char Col;
  unsigned int b1, b2, b, c, c1;
  int shift_outside;


  Col = Area.x2 - as[AreaID].NextCol;

      b1 = 0xFFFF << Area.y1;
      b2 = 0xFFFF >> (15 - Area.y2);
      b = (b1 & b2);

      //b1 = 0;
      //if(BytesPerCol == 2)
        b1 = AnimScreen[1][Col];
      b1 = (b1 << 8) | AnimScreen[0][Col];

      b = b & b1;
   //      c <<= Area.y1;
   //      b |= c;
    c = b;
    c1 = c;

  if(c1 != 0)
  {
    for(shift_outside = Area.y2 - Area.y1 + 1; shift_outside >= 0; shift_outside--)
    {
      c = c1 << Area.y1;
      if(as[AreaID].AnimStage == 0)
        c = ShiftBitsLeft(c, Area.y1, Area.y2, shift_outside);
      else
        c = ShiftBitsRight(c, Area.y1, Area.y2, shift_outside);

        b1 = 0xFFFF << Area.y1;
        b2 = 0xFFFF >> (15 - Area.y2);
        b = ~(b1 & b2);

        //b1 = 0;
        //if(BytesPerCol == 2)
          b1 = Screen[1][Col];
        b1 = (b1 << 8) | Screen[0][Col];

        //c = AnimScreen[0][as[AreaID].NextCol];
        //c

        b = b & b1;
        //c <<= Area.y1;
        b |= c;

          Screen[0][Col] = b;
          Screen[1][Col] = b >> 8;

          delay_ms(30);
    }
  }

  as[AreaID].NextCol++;
  if(as[AreaID].AnimStage == 0)
    as[AreaID].AnimStage = 1;
  else
    as[AreaID].AnimStage = 0;
  if((Area.x2 - as[AreaID].NextCol) <= Area.x1)
    return(TRUE);
  else
    return(FALSE);
}

void InitAnim9(unsigned char AreaID, TArea Area)
{
  as[AreaID].NextCol = 0;
}

unsigned char Anim9(unsigned char AreaID, TArea Area)
{
  //Fill from top
  unsigned char Col;
  unsigned int b1, b2, b, c;
  unsigned char filter;

  Col = Area.x1;

  filter = ~(0xffff << (as[AreaID].NextCol + Area.y1));

  for(; Col <= Area.x2; Col++)
  {
      b1 = 0xFFFF << Area.y1;
      b2 = 0xFFFF >> (15 - Area.y2);
      b = (b1 & b2);

      //b1 = 0;
      //if(BytesPerCol == 2)
        b1 = AnimScreen[1][Col];
      b1 = (b1 << 8) | AnimScreen[0][Col];

      b = b & b1;
   //      c <<= Area.y1;
   //      b |= c;
    c = b;

    c &= filter;

      b1 = 0xFFFF << Area.y1;
      b2 = 0xFFFF >> (15 - Area.y2);
      b = ~(b1 & b2);

      //b1 = 0;
      //if(BytesPerCol == 2)
        b1 = Screen[1][Col];
      b1 = (b1 << 8) | Screen[0][Col];

      //c = AnimScreen[0][as[AreaID].NextCol];
      //c

      b = b & b1;
      //c <<= Area.y1;
      b |= c;

        Screen[0][Col] = b;
        Screen[1][Col] = b >> 8;

  }

  as[AreaID].NextCol++;
  if(as[AreaID].NextCol >= (Area.y2 - Area.y1 + 1))
  {
    return(TRUE);
  }

  return(FALSE);
}

void InitAnim10(unsigned char AreaID, TArea Area)
{
  as[AreaID].NextCol = 0;
}

unsigned char Anim10(unsigned char AreaID, TArea Area)
{
  //Å—‘œ‰ «“ ÿ—›Ì‰ »Â ”„  œ«Œ·
  unsigned char Col, Col2;
  unsigned int b1, b2, b, c;

  Col2 = Area.x1 + (Area.x2 - Area.x1 + 1) / 2 - as[AreaID].NextCol;
  for(Col = Area.x1; Col <= Area.x1 + as[AreaID].NextCol; Col++)
  {
    b1 = 0xFFFF << Area.y1;
    b2 = 0xFFFF >> (15 - Area.y2);
    b = (b1 & b2);

      //b1 = 0;
      //if(BytesPerCol == 2)
        b1 = AnimScreen[1][Col2];
      b1 = (b1 << 8) | AnimScreen[0][Col2];

      b = b & b1;
     //      c <<= Area.y1;
     //      b |= c;
      c = b;

      b1 = 0xFFFF << Area.y1;
      b2 = 0xFFFF >> (15 - Area.y2);
      b = ~(b1 & b2);

      //b1 = 0;
      //if(BytesPerCol == 2)
        b1 = Screen[1][Col];
      b1 = (b1 << 8) | Screen[0][Col];

      //c = AnimScreen[0][as[AreaID].NextCol];
      //c

      b = b & b1;
      //c <<= Area.y1;
      b |= c;

        Screen[0][Col] = b;
        Screen[1][Col] = b >> 8;

    Col2++;
  }

  Col2 = Area.x1 + (Area.x2 - Area.x1 + 1) / 2 + as[AreaID].NextCol;
  for(Col = Area.x2; Col >= Area.x2 - as[AreaID].NextCol; Col--)
  {
    b1 = 0xFFFF << Area.y1;
    b2 = 0xFFFF >> (15 - Area.y2);
    b = (b1 & b2);

      //b1 = 0;
      //if(BytesPerCol == 2)
        b1 = AnimScreen[1][Col2];
      b1 = (b1 << 8) | AnimScreen[0][Col2];

      b = b & b1;
     //      c <<= Area.y1;
     //      b |= c;
      c = b;

      b1 = 0xFFFF << Area.y1;
      b2 = 0xFFFF >> (15 - Area.y2);
      b = ~(b1 & b2);

      //b1 = 0;
      //if(BytesPerCol == 2)
        b1 = Screen[1][Col];
      b1 = (b1 << 8) | Screen[0][Col];

      //c = AnimScreen[0][as[AreaID].NextCol];
      //c

      b = b & b1;
      //c <<= Area.y1;
      b |= c;

        Screen[0][Col] = b;
        Screen[1][Col] = b >> 8;

    Col2--;
  }

  as[AreaID].NextCol++;
  if(as[AreaID].NextCol >= ((Area.x2 - Area.x1) / 2))
  {
    return(TRUE);
  }
  return(FALSE);
}

void InitAnim11(unsigned char AreaID, TArea Area)
{
  as[AreaID].NextCol = 0;
  as[AreaID].AnimStage = Area.x1;
}

unsigned char Anim11(unsigned char AreaID, TArea Area)
{
  unsigned char Col, ColToScroll;
  unsigned int b1, b2, b, c;

    ColToScroll = Area.x2 - as[AreaID].NextCol;

    b1 = 0xFFFF << Area.y1;
    b2 = 0xFFFF >> (15 - Area.y2);
    b = (b1 & b2);

      //b1 = 0;
      //if(BytesPerCol == 2)
        b1 = AnimScreen[1][ColToScroll];
      b1 = (b1 << 8) | AnimScreen[0][ColToScroll];

      b = b & b1;
     //      c <<= Area.y1;
     //      b |= c;
      c = b;

      if(c == 0)
        as[AreaID].AnimStage = ColToScroll;

//  if(c != 0)

      ///Clear old column
      Col = as[AreaID].AnimStage - 1;
      b1 = 0xFFFF << Area.y1;
      b2 = 0xFFFF >> (15 - Area.y2);
      b = ~(b1 & b2);

      //b1 = 0;
      //if(BytesPerCol == 2)
        b1 = Screen[1][Col];
      b1 = (b1 << 8) | Screen[0][Col];

      //c = AnimScreen[0][as[AreaID].NextCol];
      //c

      b = b & b1;
      //c <<= Area.y1;
      //b |= c;  --> c == 0
        if(Col != ColToScroll)
        {
        Screen[0][Col] = b;
        Screen[1][Col] = b >> 8;
        }


  Col = as[AreaID].AnimStage;
//  for(Col = Area.x1; Col <= ColToScroll; Col++)
//  {
      b1 = 0xFFFF << Area.y1;
      b2 = 0xFFFF >> (15 - Area.y2);
      b = ~(b1 & b2);

      //b1 = 0;
      //if(BytesPerCol == 2)
        b1 = Screen[1][Col];
      b1 = (b1 << 8) | Screen[0][Col];

      //c = AnimScreen[0][as[AreaID].NextCol];
      //c

      b = b & b1;
      //c <<= Area.y1;
      b |= c;

        Screen[0][Col] = b;
        Screen[1][Col] = b >> 8;

  //}  delay_ms(100);

  as[AreaID].AnimStage++;
  if(as[AreaID].AnimStage > ColToScroll)
  {
    as[AreaID].AnimStage = Area.x1;
    as[AreaID].NextCol++;
  }
  if(as[AreaID].NextCol >= (Area.x2 - Area.x1 + 1))
  {
    return(TRUE);
  }
  return(FALSE);
}

void InitAnim12(unsigned char AreaID, TArea Area)
{
  as[AreaID].NextCol = 0;
}

unsigned char Anim12(unsigned char AreaID, TArea Area)
{
  //Å—‘œ‰ «“ »«·« »Â ”„  çÅ Ê «“ Å«ÌÌ‰ »Â ”„  —«” 
  unsigned char LeftCol, RightCol;
  unsigned int b1, b2, b, left_c, right_c;

  LeftCol = Area.x1 + as[AreaID].NextCol;
  RightCol = Area.x2 - as[AreaID].NextCol;

    b1 = 0xFFFF << Area.y1;
    b2 = 0xFFFF >> (15 - Area.y2);
    b = (b1 & b2);

      //b1 = 0;
      //if(BytesPerCol == 2)
        b1 = AnimScreen[1][LeftCol];
      b1 = (b1 << 8) | AnimScreen[0][LeftCol];

      b = b & b1;
     //      c <<= Area.y1;
     //      b |= c;
      left_c = b;

    b1 = 0xFFFF << Area.y1;
    b2 = 0xFFFF >> (15 - Area.y2);
    b = (b1 & b2);

      //b1 = 0;
      //if(BytesPerCol == 2)
        b1 = AnimScreen[1][RightCol];
      b1 = (b1 << 8) | AnimScreen[0][RightCol];

      b = b & b1;
     //      c <<= Area.y1;
     //      b |= c;
      right_c = b;

  left_c &= AndBits(left_c, Area.y1, Area.y2 - (Area.y2 - Area.y1) / 2, 0);
  right_c &= AndBits(right_c, Area.y2 - (Area.y2 - Area.y1) / 2 + 1, Area.y2, 0);



      b1 = 0xFFFF << Area.y1;
      b2 = 0xFFFF >> (15 - Area.y2);
      b = ~(b1 & b2);

      //b1 = 0;
      //if(BytesPerCol == 2)
        b1 = Screen[1][LeftCol];
      b1 = (b1 << 8) | Screen[0][LeftCol];

      //c = AnimScreen[0][as[AreaID].NextCol];
      //c

      b = b & b1;
      //c <<= Area.y1;
      b |= left_c;

        Screen[0][LeftCol] |= b;
        Screen[1][LeftCol] |= b >> 8;



      b1 = 0xFFFF << Area.y1;
      b2 = 0xFFFF >> (15 - Area.y2);
      b = ~(b1 & b2);

      //b1 = 0;
      //if(BytesPerCol == 2)
        b1 = Screen[1][RightCol];
      b1 = (b1 << 8) | Screen[0][RightCol];

      //c = AnimScreen[0][as[AreaID].NextCol];
      //c

      b = b & b1;
      //c <<= Area.y1;
      b |= right_c;

        Screen[0][RightCol] |= b;
        Screen[1][RightCol] |= b >> 8;

  as[AreaID].NextCol++;
  if((as[AreaID].NextCol + Area.x1) > Area.x2)
  {
    return(TRUE);
  }
  return(FALSE);
}

void InitAnim13(unsigned char AreaID, TArea Area)
{
  as[AreaID].NextCol = 0;
}

unsigned char Anim13(unsigned char AreaID, TArea Area)
{
  //Å—‘œ‰ «“ çÅ Ê —«”  »Â ÿ—› œ«Œ·
  unsigned char Col, Col2;
  unsigned int b1, b2, b, c;

  //Col2 = Area.x1 + (Area.x2 - Area.x1 + 1) / 2 - as[AreaID].NextCol;
  Col2 = Area.x1;
  for(Col = Area.x1; Col <= Area.x1 + as[AreaID].NextCol; Col++)
  {
    b1 = 0xFFFF << Area.y1;
    b2 = 0xFFFF >> (15 - Area.y2);
    b = (b1 & b2);

      //b1 = 0;
      //if(BytesPerCol == 2)
        b1 = AnimScreen[1][Col2];
      b1 = (b1 << 8) | AnimScreen[0][Col2];

      b = b & b1;
     //      c <<= Area.y1;
     //      b |= c;
      c = b;

      b1 = 0xFFFF << Area.y1;
      b2 = 0xFFFF >> (15 - Area.y2);
      b = ~(b1 & b2);

      //b1 = 0;
      //if(BytesPerCol == 2)
        b1 = Screen[1][Col];
      b1 = (b1 << 8) | Screen[0][Col];

      //c = AnimScreen[0][as[AreaID].NextCol];
      //c

      b = b & b1;
      //c <<= Area.y1;
      b |= c;

        Screen[0][Col] = b;
        Screen[1][Col] = b >> 8;

    Col2++;
  }

  //Col2 = Area.x1 + (Area.x2 - Area.x1 + 1) / 2 + as[AreaID].NextCol;
  Col2 = Area.x2;
  for(Col = Area.x2; Col >= Area.x2 - as[AreaID].NextCol; Col--)
  {
    b1 = 0xFFFF << Area.y1;
    b2 = 0xFFFF >> (15 - Area.y2);
    b = (b1 & b2);

      //b1 = 0;
      //if(BytesPerCol == 2)
        b1 = AnimScreen[1][Col2];
      b1 = (b1 << 8) | AnimScreen[0][Col2];

      b = b & b1;
     //      c <<= Area.y1;
     //      b |= c;
      c = b;

      b1 = 0xFFFF << Area.y1;
      b2 = 0xFFFF >> (15 - Area.y2);
      b = ~(b1 & b2);

      //b1 = 0;
      //if(BytesPerCol == 2)
        b1 = Screen[1][Col];
      b1 = (b1 << 8) | Screen[0][Col];

      //c = AnimScreen[0][as[AreaID].NextCol];
      //c

      b = b & b1;
      //c <<= Area.y1;
      b |= c;

        Screen[0][Col] = b;
        Screen[1][Col] = b >> 8;

    Col2--;
  }

  as[AreaID].NextCol++;
  if(as[AreaID].NextCol >= ((Area.x2 - Area.x1) / 2))
  {
    return(TRUE);
  }
  return(FALSE);
}

void InitAnim14(unsigned char AreaID, TArea Area)
{
  as[AreaID].NextCol = 0;  //This variable is used to store the number of flash times.
  as[AreaID].AnimStage = 0;
}

unsigned char Anim14(unsigned char AreaID, TArea Area)
{
  //Flash
  unsigned char Col;
  unsigned int b1, b2, b, c;

  for(Col = Area.x1; Col <= Area.x2; Col++)
  {
    b1 = 0xFFFF << Area.y1;
    b2 = 0xFFFF >> (15 - Area.y2);
    b = (b1 & b2);

      //Get the data
      //b1 = 0;
      //if(BytesPerCol == 2)
      if(as[AreaID].AnimStage == 1)
      {
        b1 = ~AnimScreen[1][Col];
        b1 = (b1 << 8) | ~AnimScreen[0][Col];
      }
      else
      {
        b1 = AnimScreen[1][Col];
        b1 = (b1 << 8) | AnimScreen[0][Col];
      }

      b = b & b1;
     //      c <<= b |= c;
      c = b;


      //Now, put it on the screen
      b1 = 0xFFFF << Area.y1;
      b2 = 0xFFFF >> (15 - Area.y2);
      b = ~(b1 & b2);

      //b1 = 0;
      //if(BytesPerCol == 2)
        b1 = Screen[1][Col];
      b1 = (b1 << 8) | Screen[0][Col];

      //c = AnimScreen[0][as[AreaID].NextCol];
      //c

      b = b & b1;
      //c <<= Area.y1;
      b |= c;

        Screen[0][Col] = b;
        Screen[1][Col] = b >> 8;
  }

  if(as[AreaID].AnimStage == 0)
    as[AreaID].AnimStage = 1;
  else
    as[AreaID].AnimStage = 0;
  delay_ms(80);

  as[AreaID].NextCol++;  //This variable is used to store the number of flash times.
  if(as[AreaID].NextCol == 10)  //Flash 6 (= 10 / 2) times
  {
    return(TRUE);
  }
  return(FALSE);
}

void InitAnim15(unsigned char AreaID, TArea Area)
{
}

unsigned char Anim15(unsigned char AreaID, TArea Area)
{
  return(TRUE);
}

#include "page_effects.c"
//Page effects
typedef struct
{
  unsigned char NextCol;
  unsigned char EffectStage;
} TPageEffectSettings;

TPageEffectSettings pes;

BOOL PageEffect1();
void InitPageEffect1();
BOOL PageEffect2();
void InitPageEffect2();
BOOL PageEffect3();
void InitPageEffect3();
BOOL PageEffect4();
void InitPageEffect4();
BOOL PageEffect5();
void InitPageEffect5();
BOOL PageEffect6();
void InitPageEffect6();
BOOL PageEffect7();
void InitPageEffect7();
BOOL PageEffect8();
void InitPageEffect8();
BOOL PageEffect9();
void InitPageEffect9();
BOOL PageEffect10();
void InitPageEffect10();

BOOL ApplyStageEffect(unsigned char PageEffectID)
{
  switch(PageEffectID)
  {
    case 1:
      return(PageEffect1());
      break;
    case 2:
      return(PageEffect2());
      break;
    case 3:
      return(PageEffect3());
      break;
    case 4:
      return(PageEffect4());
      break;
    case 5:
      return(PageEffect5());
      break;
    case 6:
      return(PageEffect6());
      break;
    case 7:
      return(PageEffect7());
      break;
    case 8:
      return(PageEffect8());
      break;
    case 9:
      return(PageEffect9());
      break;
    case 10:
      return(PageEffect10());
      break;
  }
}

void InitPageEffect(unsigned char PageEffectID)
{
  switch(PageEffectID)
  {
    case 1:
      InitPageEffect1();
      break;
    case 2:
      InitPageEffect2();
      break;
    case 3:
      InitPageEffect3();
      break;
    case 4:
      InitPageEffect4();
      break;
    case 5:
      InitPageEffect5();
      break;
    case 6:
      InitPageEffect6();
      break;
    case 7:
      InitPageEffect7();
      break;
    case 8:
      InitPageEffect8();
      break;
    case 9:
      InitPageEffect9();
      break;
    case 10:
      InitPageEffect10();
      break;
  }
}


//Effects

void InitPageEffect1()
{
  pes.NextCol = 0;
}

BOOL PageEffect1()
{
  //Empty from left to right
  unsigned char Col;

  for(Col = 0; Col < pes.NextCol; Col++)
  {
    Screen[0][Col] = 0;
    Screen[1][Col] = 0;
  }

  for(Col = pes.NextCol; Col < COL_COUNT; Col++)
  {
    Screen[0][Col] = 0xff;
    Screen[1][Col] = 0xff;
  }

  pes.NextCol++;
  if(pes.NextCol >= COL_COUNT)
  {
    return(TRUE);
  }
  return(FALSE);
}

void InitPageEffect2()
{
  pes.NextCol = 0;
}

BOOL PageEffect2()
{
  //Empty from right to left
  unsigned char Col;

  for(Col = COL_COUNT - 1; Col > COL_COUNT - pes.NextCol; Col--)
  {
    Screen[0][Col] = 0;
    Screen[1][Col] = 0;
  }

  for(Col = 0; Col < COL_COUNT - pes.NextCol; Col++)
  {
    Screen[0][Col] = 0xff;
    Screen[1][Col] = 0xff;
  }

  pes.NextCol++;
  if(pes.NextCol >= COL_COUNT)
  {
    return(TRUE);
  }
  return(FALSE);
}

void InitPageEffect3()
{
  pes.NextCol = 0;
}

void VerticalEmpty(BOOL bottom_to_top, unsigned char NextCol)
{
  unsigned int v = 0xffff;
  unsigned char Col;


  if(bottom_to_top)
    v >>= NextCol;
  else
    v <<= NextCol;


  for(Col = 0; Col < COL_COUNT; Col++)
  {
    Screen[0][Col] = v;
    Screen[1][Col] = v >> 8;
  }
}

BOOL PageEffect3()
{
  //Empty from top to bottom
  VerticalEmpty(FALSE, pes.NextCol);
  delay_ms(20);

  pes.NextCol++;
  if(pes.NextCol > ROW_COUNT)
  {
    return(TRUE);
  }
  return(FALSE);
}

void InitPageEffect4()
{
  pes.NextCol = 0;
}

BOOL PageEffect4()
{
  //Empty from bottom to top
  VerticalEmpty(TRUE, pes.NextCol);
  delay_ms(20);

  pes.NextCol++;
  if(pes.NextCol > ROW_COUNT)
  {
    return(TRUE);
  }
  return(FALSE);
}

void InitPageEffect5()
{
  pes.NextCol = 0;
}

BOOL PageEffect5()
{
  //Horizontal from center
  unsigned char Col, i;

  Col = COL_COUNT / 2;
  for(i = 0; i < pes.NextCol; i++)
  {
    Screen[0][Col - i] = 0;
    Screen[1][Col - i] = 0;
    Screen[0][Col + i] = 0;
    Screen[1][Col + i] = 0;
  }

  for(Col = 0; Col < (COL_COUNT / 2 - pes.NextCol); Col++)
  {
    Screen[0][Col] = 0xff;
    Screen[1][Col] = 0xff;
    Screen[0][COL_COUNT - Col - 1] = 0xff;
    Screen[1][COL_COUNT - Col - 1] = 0xff;
  }

  pes.NextCol++;
  if(pes.NextCol >= (COL_COUNT / 2))
  {
    Screen[0][COL_COUNT - 1] = 0;
    Screen[1][COL_COUNT - 1] = 0;
    Screen[0][0] = 0;
    Screen[0][1] = 0;
    return(TRUE);
  }

  return(FALSE);
}

void InitPageEffect6()
{
  pes.NextCol = 0;
}

BOOL PageEffect6()
{
  //Horizontal from left and right
  unsigned char Col;

  for(Col = 0; Col < pes.NextCol; Col++)
  {
    Screen[0][Col] = 0;
    Screen[1][Col] = 0;
    Screen[0][COL_COUNT - Col - 1] = 0;
    Screen[1][COL_COUNT - Col - 1] = 0;
  }

  for(Col = pes.NextCol; Col < (COL_COUNT - pes.NextCol); Col++)
  {
    Screen[0][Col] = 0xff;
    Screen[1][Col] = 0xff;
  }

  pes.NextCol++;
  if(pes.NextCol > (COL_COUNT / 2))
  {
    return(TRUE);
  }

  return(FALSE);
}

void InitPageEffect7()
{
  pes.NextCol = 0;
}

BOOL PageEffect7()
{
  //Vertical from center
  unsigned int v;
  unsigned char Col;

  v = NotBits(0xffff, ROW_COUNT / 2 - pes.NextCol, ROW_COUNT / 2 + pes.NextCol - 1);

  for(Col = 0; Col < (COL_COUNT - 1); Col++)
  {
    Screen[0][Col] = v;
    Screen[1][Col] = v >> 8;
  }

  delay_ms(30);

  pes.NextCol++;
  if(pes.NextCol > ROW_COUNT / 2)
  {
    return(TRUE);
  }

  return(FALSE);
}

void InitPageEffect8()
{
  pes.NextCol = 0;
}

BOOL PageEffect8()
{
  //Vertical from bottom and top
  unsigned int v;
  unsigned char Col;

  v = NotBits(0xffff, 0, pes.NextCol);
  v = NotBits(v, ROW_COUNT - 1 - pes.NextCol, ROW_COUNT - 1);

  for(Col = 0; Col < (COL_COUNT - 1); Col++)
  {
    Screen[0][Col] = v;
    Screen[1][Col] = v >> 8;
  }

  delay_ms(30);

  pes.NextCol++;
  if(pes.NextCol >= ROW_COUNT / 2)
  {
    return(TRUE);
  }

  return(FALSE);
}

void InitPageEffect9()
{
  pes.NextCol = 0;
}

BOOL PageEffect9()
{
}

void InitPageEffect10()
{
}

BOOL PageEffect10()
{
}

//#include <leddigits.c>

//Clock variables
// unsigned int Millisecond = 0;
// unsigned char Second = 0, Minute = 0, Hour = 0;
// unsigned char Month = 1, Day = 6;
// unsigned int Year = 1387;

void reset_CurrentStageElapsedTime()
{
  get_time(&StageTime);
}

unsigned long int CurrentStageElapsedTime()
{
  return(time_elapsed(StageTime));
}

void ChangeStage(unsigned char NewStageIndex)
{
  unsigned char i;
  unsigned char ContentSpeed;

  if(CurrentStageIndex != NewStageIndex)
    ClearScreen();
  CurrentStageIndex = NewStageIndex;
  Stages(CurrentStageIndex, &CurrentStage);

  update_data_pointers(NewStageIndex);

  //Initialize stage settings

  //Timing
  StageSettings.ForceUpdate = TRUE;
  //No need to update the value of LastTickCount
  ////////

  for(i = 0; i < 4; i++)
  {
    StageSettings.AreasDone[i] = FALSE;
    StageSettings.EntranceAnimDone[i] = FALSE;
    StageSettings.AnimInitialized[i] = FALSE;
    StageSettings.AreaRepeatCount[i] = 0;
    StageSettings.StageEffectDone = FALSE;

    switch(CurrentStage.Areas[i].ContentType)
    {
      case 1:  //Time
        break;
      case 2:  //Date
        break;
      case 3:  //Single-Line Scrolling Text
        //StageSettings.SLST[i].DelayCounter = 0;
        StageSettings.SLST[i].StartCol = 0;
        StageSettings.SLST[i].NormalScroll = FALSE;
        break;
      case 4:  //Framed Animation
        //StageSettings.FA[i].DelayCounter = 0;
        StageSettings.FA[i].CurrentFrame = 0;
        break;
      default:  //Unused or Unknown
        StageSettings.AreasDone[i] = TRUE;
        break;
    }
  }

  //Page effect
  if(CurrentStage.EntranceEffectID > 0)
    InitPageEffect(CurrentStage.EntranceEffectID);
  else
    StageSettings.StageEffectDone = TRUE;
  /////////////

  //CurrentStageElapsedTime = 0;
  reset_CurrentStageElapsedTime();
}


void LEDTime(unsigned char AreaIndex, TArea Area, unsigned char dp_index /*data pointer index*/)
{
  char TimeStr[9];
  TTimeData td;
  unsigned char i;
  unsigned char Hour, Minute, Second;
  unsigned char TotalColumnCount;


  if(StageSettings.AreasDone[AreaIndex])
  {
    //It is also possible to keep this area alive until all other areas are done.
    //This can be implemented as an option.
    if(!Area.RepeatAfterDone)
    {
      //Clear the area and return
      ClearArea(Area);
      return;
    }
  }

  //td = (TTimeData flash*) DataStart;
  get_content_settings(dp_index, sizeof(TTimeData), &td);

  //lcd_putnumuc(td.TotalDisplayTime);
  if(CurrentStageElapsedTime() >= td.TotalDisplayTime)
  {
    StageSettings.AreasDone[AreaIndex] = TRUE;
  }

  rtc_get_time(&Hour, &Minute, &Second);

  if(td.format == 0)
    sprintf(TimeStr, "%02d:%02d:%02d", Hour, Minute, Second);
  else
    sprintf(TimeStr, "%02d:%02d", Hour, Minute);

  //Count the number of columns clock occupies (to put clock at screen center)
  TotalColumnCount = 0;
  for(i = 0; i < strlen(TimeStr); i++)
  {
    if(TimeStr[i] == ':')
    {
      //LEDPutChar(Area.x1, Area.y1, Colon, 0);
      TotalColumnCount += Colon[0];
    }
    else
    {
      if(td.lang == 0)
      {
        //LEDPutChar(Area.x1, Area.y1, LEDDigitsFa[TimeStr[i] - 48], 0);  //-----------------------Fa
        TotalColumnCount += LEDDigitsFa[TimeStr[i] - 48][0];
      }
      else
      {
        //LEDPutChar(Area.x1, Area.y1, LEDDigitsEn[TimeStr[i] - 48], 0);
        TotalColumnCount += LEDDigitsEn[TimeStr[i] - 48][0];
      }
    }
  }

  //Center horizontally
  if(td.CenterHorizontally && TotalColumnCount < (Area.x2 - Area.x1 + 1))
  {
    Area.x1 = ((Area.x2 - Area.x1 + 1) - TotalColumnCount) / 2;
  }
  //Center vertically
  if(td.CenterVertically && (Area.y2 - Area.y1 + 1) > 8)
  {
    Area.y1 = ((Area.y2 - Area.y1 + 1) - 8) / 2;
  }

  for(i = 0; i < strlen(TimeStr); i++)
  {
    if(TimeStr[i] == ':')
    {
      LEDPutChar(Area.x1, Area.y1, Colon, 0);
      Area.x1 += Colon[0];
    }
    else
    {
      if(td.lang == 0)
      {
        LEDPutChar(Area.x1, Area.y1, LEDDigitsFa[TimeStr[i] - 48], 0);  //-----------------------Fa
        Area.x1 += LEDDigitsFa[TimeStr[i] - 48][0];
      }
      else
      {
        LEDPutChar(Area.x1, Area.y1, LEDDigitsEn[TimeStr[i] - 48], 0);
        Area.x1 += LEDDigitsEn[TimeStr[i] - 48][0];
      }
    }
  }
}

void LEDDate(unsigned char AreaIndex, TArea Area, unsigned char dp_index /*data pointer index*/)
{
  TDateData dd;
  char DateSep;
  char DateStr[11];
  unsigned char i;
  unsigned int Year;
  unsigned char Month, Day;
  unsigned char TotalColumnCount;

  if(StageSettings.AreasDone[AreaIndex])
  {
    //It is also possible to keep this area alive until all other areas are done.
    //This can be implemented as an option.
    if(!Area.RepeatAfterDone)
    {
      //Clear the area and return
      ClearArea(Area);
      return;
    }
  }

  //dd = (TDateData flash*) DataStart;
  get_content_settings(dp_index, sizeof(TDateData), &dd);

  if(CurrentStageElapsedTime() >= dd.TotalDisplayTime)
  {
    StageSettings.AreasDone[AreaIndex] = TRUE;
  }


  if(dd.type == 0)
  {
    //Solar date
    get_date(&Year, &Month, &Day, 1);
  }
  else
  {
    //Gregorian date
    get_date(&Year, &Month, &Day, 0);
  }

  //Generate date string
  switch(dd.format)
  {
    case 0:  //1387/01/01
      sprintf(DateStr, "%04d/%02d/%02d", Year, Month, Day);
      break;
    case 1:  //87/01/01
      sprintf(DateStr, "%02d/%02d/%02d", Year % 100 /*2 rightmost digits*/, Month, Day);
      break;
    case 2:  //1387-01-01
      sprintf(DateStr, "%04d-%02d-%02d", Year, Month, Day);
      break;
    case 3:  //87-01-01
      sprintf(DateStr, "%02d-%02d-%02d", Year % 100 /*2 rightmost digits*/, Month, Day);
      break;
  }

  //Count the number of columns date occupies (to put date at screen center)
  TotalColumnCount = 0;
  for(i = 0; i < strlen(DateStr); i++)
  {
    if(DateStr[i] == '/')
    {
      //LEDPutChar(Area.x1, Area.y1, Slash, 0);
      TotalColumnCount += Slash[0];
    }
    else if(DateStr[i] == '-')
    {
      //LEDPutChar(Area.x1, Area.y1, Dash, 0);
      TotalColumnCount += Dash[0];
    }
    else
    {
      if(dd.lang == 0)
      {
        //LEDPutChar(Area.x1, Area.y1, LEDDigitsFa[DateStr[i] - 48], 0);
        TotalColumnCount += LEDDigitsFa[DateStr[i] - 48][0];
      }
      else
      {
        //LEDPutChar(Area.x1, Area.y1, LEDDigitsEn[DateStr[i] - 48], 0);
        TotalColumnCount += LEDDigitsEn[DateStr[i] - 48][0];
      }
    }
  }

  //Center horizontally
  if(dd.CenterHorizontally && TotalColumnCount < (Area.x2 - Area.x1 + 1))
  {
    Area.x1 = ((Area.x2 - Area.x1 + 1) - TotalColumnCount) / 2;
  }
  //Center vertically
  if(dd.CenterVertically && (Area.y2 - Area.y1 + 1) > 8)
  {
    Area.y1 = ((Area.y2 - Area.y1 + 1) - 8) / 2;
  }

  for(i = 0; i < strlen(DateStr); i++)
  {
    if(DateStr[i] == '/')
    {
      LEDPutChar(Area.x1, Area.y1, Slash, 0);
      Area.x1 += Slash[0];
    }
    else if(DateStr[i] == '-')
    {
      LEDPutChar(Area.x1, Area.y1, Dash, 0);
      Area.x1 += Dash[0];
    }
    else
    {
      if(dd.lang == 0)
      {
        LEDPutChar(Area.x1, Area.y1, LEDDigitsFa[DateStr[i] - 48], 0);
        Area.x1 += LEDDigitsFa[DateStr[i] - 48][0];
      }
      else
      {
        LEDPutChar(Area.x1, Area.y1, LEDDigitsEn[DateStr[i] - 48], 0);
        Area.x1 += LEDDigitsEn[DateStr[i] - 48][0];
      }
    }
  }
}

void LEDSingleLineScrollingText(unsigned char AreaIndex, TArea Area, unsigned char dp_index /*data pointer index*/)
{
  unsigned int TotalRefreshTimems;  //in milliseconds
  TSingleLineScrollingText slst;
  int i, NextCol, StartCol;
  unsigned int b1, b2, b, c;
  unsigned char ScreenCol;
  unsigned char AreaWidth;
  unsigned char BytesPerCol;
  BOOL ResetTextPlay = FALSE;

  BOOL UpdateAnim = FALSE;


  if(StageSettings.AreasDone[AreaIndex])
  {
    //It is also possible to keep this area alive until all other areas are done.
    //This can be implemented as an option.
    if(!Area.RepeatAfterDone)
    {
      //Clear the area and return
      ClearArea(Area);
      return;
    }
  }

  //slst = (TSingleLineScrollingText flash*) DataStart;
  get_content_settings(dp_index, sizeof(TSingleLineScrollingText), &slst);

////////////ddddddddddddddddddddd=============
//  Area.EntranceAnimID = 2;  //Index of the gif file of the effect is this index plus 1 (1 -> Effect2.gif, 2 -> Effect3.gif, etc.)
//  slst.ScrollType = 1;
////////////ddddddddddddddddddddd=============

  if(!StageSettings.EntranceAnimDone[AreaIndex])
  {
    if(Area.EntranceAnimID == 0)
    {
      StageSettings.EntranceAnimDone[AreaIndex] = TRUE;
    }
    else
    {
      if(StageSettings.AnimInitialized[AreaIndex])
      {
        /* To control speed of animation
        if( TickCount - StageSettings.LastTickCount[AreaIndex] < (unsigned long)((float)slst.Speed * CONTENT_SPPED_MULTIPLIER))
        {
          return;
        }*/

        StageSettings.EntranceAnimDone[AreaIndex] = ApplyAnimation(AreaIndex, Area, Area.EntranceAnimID);
        /*StageSettings.LastTickCount[AreaIndex] = TickCount;*/
        return;
      }
      else
      {
        StageSettings.AnimInitialized[AreaIndex] = TRUE;
        InitAnim(AreaIndex, Area, Area.EntranceAnimID);
        UpdateAnim = TRUE;
        slst.ScrollType = 1;
      }
    }
  }

  #pragma warn-
  //TotalRefreshTimems = (unsigned int) OVERALL_REFRESH_COUNT * (unsigned int) ( (COL_COUNT * REFRESH_DELAY)/1000);
  #pragma warn+
  //StageSettings.SLST[AreaIndex].SpeedDelayCount = slst.Speed / 10;
  //StageSettings.SLST[AreaIndex].DelayCounter++;
//  nmsg("DelayCounter", StageSettings.SLST[AreaIndex].DelayCounter);
//  delay_ms(400);

  //Timing
  if( TickCount - StageSettings.LastTickCount[AreaIndex] < (unsigned long)((float)slst.Speed * CONTENT_SPPED_MULTIPLIER)
      && !StageSettings.ForceUpdate
      && StageSettings.EntranceAnimDone[AreaIndex])
  {
    return;
  }
  ////////

  //Scroll the text one column
  StageSettings.SLST[AreaIndex].StartCol++;
  StartCol = StageSettings.SLST[AreaIndex].StartCol;

  //Set next column index according to the direction of the text
  AreaWidth = Area.x2 - Area.x1 + 1;
  if(slst.Direction == 0)  //Right
  {
    NextCol = AreaWidth;
    if((slst.ScrollType == 0) && !StageSettings.SLST[AreaIndex].NormalScroll && (StartCol < NextCol))
    {
      if( (StartCol + 1) == NextCol)
      {
        StageSettings.SLST[AreaIndex].NormalScroll = TRUE;
        StageSettings.SLST[AreaIndex].StartCol = 0;
      }
      NextCol = StartCol;
      StartCol = 1;
    }
  }
  else if(slst.Direction == 1)  //Left
  {
    NextCol = 1;
    if((slst.ScrollType == 0) && !StageSettings.SLST[AreaIndex].NormalScroll && (StartCol < AreaWidth))
    {
      if( (StartCol + 1) == AreaWidth)
      {
        StageSettings.SLST[AreaIndex].NormalScroll = TRUE;
        StageSettings.SLST[AreaIndex].StartCol = 0;
      }
      NextCol = AreaWidth - StartCol;
      StartCol = 1;
    }
  }

  //Define the number of data bytes per each column of the text
  if( (Area.y2 - Area.y1 + 1) <= 8)
    BytesPerCol = 1;
  else
    BytesPerCol = 2;

  //Apply FizedText setting
  if(slst.FixedText == 1)
    StartCol = 1;

  for(i = StartCol - 1; i < slst.ColCount; i++)
  {
    c = 0x00;
    if(BytesPerCol == 2)
    {
      c = slst_Data(dp_index, i * BytesPerCol + 1);
//      c <<= (15 - (Area.y2 - Area.y1));
    }
    c = (c << 8) | slst_Data(dp_index, i * BytesPerCol);
    if(BytesPerCol == 2)
    {
      //Exchange MSB and LSB
      b1 = c;
      c >>= 8;
      c |= b1 << 8;
    }

    /*c1 = slst->Data[(StartCol - 1) * BytesPerCol + i - StartCol + 1];
    if(BytesPerCol == 2)
      c2 = slst->Data[(StartCol - 1) * BytesPerCol + i + 1 - StartCol + 1];*/

    ScreenCol = Area.x1 + NextCol - 1;

    b1 = 0xFFFF << Area.y1;
    b2 = 0xFFFF >> (15 - Area.y2);
    b = ~(b1 & b2);

    //b1 = 0;
    //if(BytesPerCol == 2)
      b1 = Screen[1][ScreenCol];
    b1 = (b1 << 8) | Screen[0][ScreenCol];

    b = b & b1;
    c <<= Area.y1;
    if(slst.Invert == 1)
      c = NotBits(c, Area.y1, Area.y2);
    b |= c;

    //b = MirrorBits(b, Area.y1, Area.y2);
    if(BytesPerCol == 2)
      b = MirrorBits(b, 0, 15);
    else
      b = MirrorBits(b, Area.y1, Area.y2);

    if(UpdateAnim)
    {
      AnimScreen[0][ScreenCol] = b;
      AnimScreen[1][ScreenCol] = b >> 8;
    }
    else
    {
      Screen[0][ScreenCol] = b;
      Screen[1][ScreenCol] = b >> 8;
    }

/*    if(BytesPerCol == 1)
    {
      c1 = MirrorByte(c1);
      b1 = c1 << Area.y1;
      b2 = c1 >> (8 - Area.y1);
    }
    else
    {
      MirrorWord(&c1, &c2);
      b1 = c1;
      b2 = c2;
    }

    //nmsg("Col", Area.x1 + NextCol - 1);
    //delay_ms(200);

    if(BytesPerCol == 1)
    {
      Screen[0][Area.x1 + NextCol - 1] &= 0xFF >> (8 - Area.y1);
      Screen[1][Area.x1 + NextCol - 1] &= 0xFF << Area.y1;
    }
    else
    {
      Screen[0][Area.x1 + NextCol - 1] = 0x00;
      Screen[1][Area.x1 + NextCol - 1] = 0x00;
    }
    Screen[0][Area.x1 + NextCol - 1] |= b1;
    Screen[1][Area.x1 + NextCol - 1] |= b2;  */

    if(slst.Direction == 0)  //Right
    {
      NextCol--;
      if(NextCol <= 0)
        break;
    }
    else if(slst.Direction == 1)  //Left
    {
      if(NextCol >= AreaWidth)
        break;
      NextCol++;
    }
  }

  if( (NextCol > 0 && slst.Direction == 0) || (NextCol < AreaWidth && slst.Direction == 1) )
  {
    //Fill with zero
    while(1)
    {
      if(BytesPerCol == 1)
      {
        if(UpdateAnim)
        {
          AnimScreen[0][Area.x1 + NextCol - 1] &= 0xFF >> (8 - Area.y1);
          AnimScreen[1][Area.x1 + NextCol - 1] &= 0xFF << Area.y1;
        }
        else
        {
          Screen[0][Area.x1 + NextCol - 1] &= 0xFF >> (8 - Area.y1);
          Screen[1][Area.x1 + NextCol - 1] &= 0xFF << Area.y1;
        }
      }
      else
      {
        if(UpdateAnim)
        {
          AnimScreen[0][Area.x1 + NextCol - 1] = 0x00;
          AnimScreen[1][Area.x1 + NextCol - 1] = 0x00;
        }
        else
        {
          Screen[0][Area.x1 + NextCol - 1] = 0x00;
          Screen[1][Area.x1 + NextCol - 1] = 0x00;
        }
      }
      if(slst.Direction == 0)  //Right
      {
        NextCol--;
        if(NextCol <= 0)
          break;
      }
      else  //slst.Direction == 1  //Left
      {
        NextCol++;
        if(NextCol >= AreaWidth)
          break;
      }
    }
  }  //if(NextCol > 0)

  if(slst.FixedText)
  {
    if(slst.TotalDisplayTime > 0)
    {
      if(CurrentStageElapsedTime() >= slst.TotalDisplayTime)
        StageSettings.AreasDone[AreaIndex] = TRUE;
    }
    else
      StageSettings.AreasDone[AreaIndex] = TRUE;
  }
  else if(slst.RepetitionTimes > 0)
  {
    if(StartCol >= slst.ColCount)
    {
      ResetTextPlay = TRUE;
      StageSettings.AreaRepeatCount[AreaIndex]++;
    }
    if(StageSettings.AreaRepeatCount[AreaIndex] >= slst.RepetitionTimes)
      StageSettings.AreasDone[AreaIndex] = TRUE;
  }
  else if(slst.TotalDisplayTime > 0)
  {
    if(StartCol >= slst.ColCount)
      ResetTextPlay = TRUE;
    if(CurrentStageElapsedTime() >= slst.TotalDisplayTime)
      StageSettings.AreasDone[AreaIndex] = TRUE;
  }
  else if(StartCol >= slst.ColCount)
  {
    StageSettings.AreasDone[AreaIndex] = TRUE;
    ResetTextPlay = TRUE;
  }
  if(ResetTextPlay)
  {
    StageSettings.SLST[AreaIndex].StartCol = 0;
    StageSettings.SLST[AreaIndex].NormalScroll = FALSE;
    StageSettings.EntranceAnimDone[AreaIndex] = FALSE;
    StageSettings.AnimInitialized[AreaIndex] = FALSE;
  }

  StageSettings.LastTickCount[AreaIndex] = TickCount;
}

void LEDFramedAnimation(unsigned char AreaIndex, TArea Area, unsigned char dp_index /*data pointer index*/)
{
  TFramedAnimation fa;
  unsigned FrameDataIndex;
  unsigned int b1, b2, b, c;
  unsigned int Col;


  if(StageSettings.AreasDone[AreaIndex])
  {
    //It is also possible to keep this area alive until all other areas are done.
    //This can be implemented as an option.
    if(!Area.RepeatAfterDone)
    {
      //Clear the area and return
      ClearArea(Area);
      return;
    }
  }

  //fa = (TFramedAnimation flash*) DataStart;
  get_content_settings(dp_index, sizeof(TFramedAnimation), &fa);

  //Timing
  if( TickCount - StageSettings.LastTickCount[AreaIndex] < (unsigned long)((float)fa.Speed * CONTENT_SPPED_MULTIPLIER)
      && !StageSettings.ForceUpdate)
      //&& StageSettings.EntranceAnimDone[AreaIndex])
  {
    return;
  }
  ////////

  //StageSettings.FA[AreaIndex].DelayCounter = 0;
  StageSettings.FA[AreaIndex].CurrentFrame++;

  #pragma warn-
  FrameDataIndex = (StageSettings.FA[AreaIndex].CurrentFrame - 1) * fa.FrameColCount * fa.BytesPerCol;
  #pragma warn+

  if(fa.CenterHorizontally == 1)
  {
    Area.x1 += (Area.x2 - Area.x1 + 1) / 2 - fa.FrameColCount / 2;
  }

  for(Col = 0; Col < fa.FrameColCount; Col++)
  {
    c = 0x00;
    if(fa.BytesPerCol == 2)
      c = fa_Data(dp_index, FrameDataIndex + Col * fa.BytesPerCol + 1);
    c = (c << 8) | fa_Data(dp_index, FrameDataIndex + Col * fa.BytesPerCol);

    if(fa.Invert == 1)
      c = ~c;

    b1 = 0xFFFF << Area.y1;
    b2 = 0xFFFF >> (15 - Area.y2);
    b = ~(b1 & b2);

    //b1 = 0;
    //if(fa.BytesPerCol == 2)
      b1 = Screen[1][Area.x1];
    b1 = (b1 << 8) | Screen[0][Area.x1];

    b = b & b1;
    c <<= Area.y1;
    b = b | c;

    b = MirrorBits(b, Area.y1, Area.y2);

    Screen[0][Area.x1] = b >> 8;
    Screen[1][Area.x1] = b;

    Area.x1++;
  }

  if(fa.RepetitionTimes > 0)
  {
    if(StageSettings.FA[AreaIndex].CurrentFrame >= fa.FrameCount)
      StageSettings.AreaRepeatCount[AreaIndex]++;
    if(StageSettings.AreaRepeatCount[AreaIndex] >= fa.RepetitionTimes)
      StageSettings.AreasDone[AreaIndex] = TRUE;
  }
  else if(fa.TotalDisplayTime > 0)
  {
    if(CurrentStageElapsedTime() >= fa.TotalDisplayTime)
      StageSettings.AreasDone[AreaIndex] = TRUE;
  }
  else if(StageSettings.FA[AreaIndex].CurrentFrame >= fa.FrameCount)
  {
    StageSettings.AreasDone[AreaIndex] = TRUE;
    //This area is done. But keep it alive until all other areas are done.
  }
  if(StageSettings.FA[AreaIndex].CurrentFrame >= fa.FrameCount)
    StageSettings.FA[AreaIndex].CurrentFrame = 0;

  //Timing
  StageSettings.LastTickCount[AreaIndex] = TickCount;
  ////////
}

void LEDTemperature(unsigned char AreaIndex, TArea Area, unsigned char dp_index /*data pointer index*/)
{
  TTemperature t;
  char TempStr[10];  //+/-xxx0C
  int Temperature;
  unsigned char i;
  unsigned char TotalColumnCount;

  if(StageSettings.AreasDone[AreaIndex])
  {
    //It is also possible to keep this area alive until all other areas are done.
    //This can be implemented as an option.
    if(!Area.RepeatAfterDone)
    {
      //Clear the area and return
      ClearArea(Area);
      return;
    }
  }

  //t = (TTemperature flash*) DataStart;
  get_content_settings(dp_index, sizeof(TTemperature), &t);

  temperature_read(TempStr, t.unit);
  i = strlen(TempStr);
  if(t.unit == 0)  //Centigrade
    TempStr[i] = 'C';
  else
    TempStr[i] = 'F';
  TempStr[i + 1] = 0;  //Terminate the string

  //Count the number of columns temperature occupies (to put temperature at screen center)
  TotalColumnCount = 0;
  for(i = 0; i < strlen(TempStr); i++)
  {
    if(TempStr[i] == '+')
    {
      //LEDPutChar(Area.x1, Area.y1, Positive, 0);
      TotalColumnCount += Positive[0];
    }
    else if(TempStr[i] == '-')
    {
      //LEDPutChar(Area.x1, Area.y1, Dash, 0);
      TotalColumnCount += Dash[0];
    }
    else if(TempStr[i] == 'C')
    {
      //LEDPutChar(Area.x1, Area.y1, DegreeCentigradeSign, 0);
      TotalColumnCount += DegreeCentigradeSign[0];
    }
    else if(TempStr[i] == 'F')
    {
      //LEDPutChar(Area.x1, Area.y1, DegreeFahrenheitSign, 0);
      TotalColumnCount += DegreeFahrenheitSign[0];
    }
  }

  //Center horizontally
  if(t.CenterHorizontally && TotalColumnCount < (Area.x2 - Area.x1 + 1))
  {
    Area.x1 = ((Area.x2 - Area.x1 + 1) - TotalColumnCount) / 2;
  }
  //Center vertically
  if(t.CenterVertically && (Area.y2 - Area.y1 + 1) > 8)
  {
    Area.y1 = ((Area.y2 - Area.y1 + 1) - 8) / 2;
  }

  for(i = 0; i < strlen(TempStr); i++)
  {
    if(TempStr[i] == '+')
    {
      LEDPutChar(Area.x1, Area.y1, Positive, 0);
      Area.x1 += Positive[0];
    }
    else if(TempStr[i] == '-')
    {
      LEDPutChar(Area.x1, Area.y1, Dash, 0);
      Area.x1 += Dash[0];
    }
    else if(TempStr[i] == 'C')
    {
      LEDPutChar(Area.x1, Area.y1, DegreeCentigradeSign, 0);
      Area.x1 += DegreeCentigradeSign[0];
    }
    else if(TempStr[i] == 'F')
    {
      LEDPutChar(Area.x1, Area.y1, DegreeFahrenheitSign, 0);
      Area.x1 += DegreeFahrenheitSign[0];
    }
  }
}

void SelectStage()
{
  static unsigned char StageRepeatedTimes = 0;
  unsigned char NextStageIndex;
  unsigned char i;
  BOOL AllDone = TRUE;

  for(i = 0; i < 4; i++)
    AllDone = AllDone & StageSettings.AreasDone[i];
  if(AllDone)
  {
    StageRepeatedTimes++;
  }
  NextStageIndex = CurrentStageIndex;
  if(StageRepeatedTimes >= CurrentStage.RepeatitionTimes)
  {
    NextStageIndex = NextStageIndex++;
    if(NextStageIndex >= StageCount)
      NextStageIndex = 0;
    StageRepeatedTimes = 0;
  }
  if(AllDone)
    ChangeStage(NextStageIndex);
}


void UpdateScreen()
{
  unsigned char i;
  unsigned char update;

  SelectStage();

  if(!StageSettings.StageEffectDone)
  {
    StageSettings.StageEffectDone = ApplyStageEffect(CurrentStage.EntranceEffectID);
    if(StageSettings.StageEffectDone)
      reset_CurrentStageElapsedTime();
    return;
  }

  //Clear the Screen
  //ClearScreen();  --> Makes problems in refresh

  //Timing
  if(TickCount > (4294967295 - 500))
  {
    TickCount = 0;
    StageSettings.ForceUpdate = TRUE;
  }

  //Iterate through display areas
  for(i = 0; i < 4; i++)
  {
    if(CurrentStageElapsedTime() < CurrentStage.Areas[i].DelayTime)
      update = 0;
    else
      update = 1;

    switch(CurrentStage.Areas[i].ContentType)
    {
      case 1:  //Time
        if(update == 1)
          LEDTime(i, CurrentStage.Areas[i], i);
        break;
      case 2:  //Date
        if(update == 1)
          LEDDate(i, CurrentStage.Areas[i], i);
        break;
      case 3: //Single-Line Scrolling Text
        if(update == 1)
          LEDSingleLineScrollingText(i, CurrentStage.Areas[i], i);
        break;
      case 4:  //Framed Animation
        if(update == 1)
          LEDFramedAnimation(i, CurrentStage.Areas[i], i);
        break;
      case 5:  //Font Text
        break;
      case 6:  //Temperature
        if(update == 1)
          LEDTemperature(i, CurrentStage.Areas[i], i);
        break;
      default:
    }
  }  //for

  StageSettings.ForceUpdate = FALSE;
}

void display_init()
{
  TGlobalSettings gs;

  get_global_settings(&gs);
  ROW_COUNT = gs.RowCount;
  COL_COUNT = gs.ColCount;
  StageCount = gs.StageCount;

  //Stages = (TDisplayStage flash*) (DISPLAY_DATA + sizeof(TGlobalSettings));
  ChangeStage(0);
}

void PrepareForNewData()
{
  display_init();
  TickCount = 0;
}

BOOL DataIsValid()
{
  TGlobalSettings gs;

  get_global_settings(&gs);
  if(gs.RowCount > 16 || gs.ColCount > 128)
    return(FALSE);

  return(TRUE);
}
#include "usart.c"  /* USART Communication Handler */
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
#define RX_BUFFER_SIZE 100  //We don't use this buffer, so set it to zero (or 1). Original value was 8.
char rx_buffer[RX_BUFFER_SIZE];

#if RX_BUFFER_SIZE<256
unsigned char rx_wr_index,rx_rd_index,rx_counter;
#else
unsigned int rx_wr_index,rx_rd_index,rx_counter;
#endif

// This flag is set on USART Receiver buffer overflow
bit rx_buffer_overflow;

#define   USART_INIT_BYTE_1    0xED
#define   USART_INIT_BYTE_2    0xCB

unsigned char usart_status = 0;
unsigned char usart_cmd_stage;

bit DataMemoryChanged = 0;

/*

  usart_status VALUES:
  0: Waiting for the first initial byte
  1: Waiting for the second initial byte
  2: Waiting for a command
  3: Executing a command
  4 and more: Next stage in the current command

*/

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
void usart_cmd_SendDisplaySize(unsigned char data);
void usart_cmd_SendMemorySize(unsigned char data);
void usart_cmd_QueryTemperatureFeature(unsigned char data);
void usart_cmd_QueryHumidityFeature(unsigned char data);
void usart_cmd_QueryDateTimeFeature(unsigned char data);
void usart_cmd_SendTemperature(unsigned char data);
void usart_cmd_SendHumidity(unsigned char data);
void usart_cmd_SendTime(unsigned char data);
void usart_cmd_SendDate(unsigned char data);
void usart_cmd_SetMemoryData(unsigned char data);

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
     case 0x03:
       usart_cmd_SendDisplaySize(data);
       break;
     case 0x04:
       usart_cmd_SendMemorySize(data);
       break;
     case 0x05:
       usart_cmd_QueryTemperatureFeature(data);
       break;
     case 0x06:
       usart_cmd_QueryHumidityFeature(data);
       break;
     case 0x07:
       usart_cmd_QueryDateTimeFeature(data);
       break;
     case 0x08:
       usart_cmd_SendTemperature(data);
       break;
     case 0x09:
       usart_cmd_SendHumidity(data);
       break;
     case 0x0a:
       usart_cmd_SendTime(data);
       break;
     case 0x0b:
       usart_cmd_SendDate(data);
       break;
     case 0x11:
       usart_cmd_SetMemoryData(data);
       break;
     default:  //Invalid command
       usart_status = 0;
       break;
   }
}


//TTime usart_last_rcv_time = {0, 0, 0};


// USART Receiver interrupt service routine
interrupt [USART_RXC] void usart_rx_isr(void)
{
char status,data;
static unsigned char command;

status=UCSRA;
data=UDR;

/*
if(time_elapsed(usart_last_rcv_time) >= 1)
  usart_status = 0;
*/

if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
   {

     rx_buffer[rx_wr_index]=data;
     if (++rx_wr_index == RX_BUFFER_SIZE) rx_wr_index=0;
     if (++rx_counter == RX_BUFFER_SIZE)
        {
        rx_counter=0;
        rx_buffer_overflow=1;
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

void reset_usart_buffer()
{
  while(usart_char_available())
  {
    getchar();
  }
}

void handle_usart()
{
  unsigned char c, command;

  pulse(500);

  c = getchar();

//  putchar(c);
//  return;

  if(c != USART_INIT_BYTE_1)
    return;
//  pulse(500);
  if(!usart_char_available())
    return;
//  pulse(500);
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

  usart_cmd_stage = 0;
  execute_usart_cmd(command, command);

  while(1)
  {
    c = getchar();
    putchar(c);
    execute_usart_cmd(command, c);
    //pulse(100);
  }

  if(DataMemoryChanged == 1)
  {
    //if(DataIsValid())
      PrepareForNewData();
  }
}



/* USART COMMANDS */
void usart_cmd_SetTime(unsigned char data)
{
  static unsigned char h, m, s;

  switch(usart_cmd_stage)
  {
    case 0:
      break;
    case 1:  //Get hour
      h = data;
      break;
    case 2:  //Get minute
      m = data;
      break;
    case 3:  //Get second
      s = data;
      //DONE
      usart_status = 0;
      rtc_set_time(h, m, s);
      break;
  }
  usart_cmd_stage++;
}

void usart_cmd_SetDate(unsigned char data)
{
  static unsigned char y, m, d;

  switch(usart_cmd_stage)
  {
    case 0:
      break;
    case 1:  //Get year
      y = data;
      break;
    case 2:  //Get month
      m = data;
      break;
    case 3:  //Get day
      d = data;
      //DONE
      usart_status = 0;
      rtc_set_date(d, m, y);
      break;
  }
  usart_cmd_stage++;
}

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
  usart_status = 0;
}

void usart_cmd_SendMemorySize(unsigned char data)
{
}

void usart_cmd_QueryTemperatureFeature(unsigned char data)
{
  if(usart_cmd_stage == 0)
  {
    putchar(TEMPERATURE_EXISTS);
  }
  //DONE
  usart_status = 0;
}

void usart_cmd_QueryHumidityFeature(unsigned char data)
{
  if(usart_cmd_stage == 0)
  {
    putchar(HUMIDITY_EXISTS);
  }
  //DONE
  usart_status = 0;
}

void usart_cmd_QueryDateTimeFeature(unsigned char data)
{
  if(usart_cmd_stage == 0)
  {
    putchar(DATE_TIME_EXISTS);
  }
  //DONE
  usart_status = 0;
}

void usart_cmd_SendTemperature(unsigned char data)
{
}

void usart_cmd_SendHumidity(unsigned char data)
{
}

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
  usart_status = 0;
}

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
  usart_status = 0;
}

void usart_cmd_SetMemoryData(unsigned char data)
{
  static unsigned long int next_addr;

  if(usart_cmd_stage == 0)
  {
    next_addr = 0;
    usart_cmd_stage = 1;
  }
  else
  {
    DataMemoryChanged = 1;
    mem_write(next_addr, data);
    next_addr++;
  }
}
#include "buttons.c"
/* This file contains routines for handling buttons */

#define ON  TRUE
#define OFF FALSE

//===================================================
//===================================================
//Clock specific definitions
#define BUTTON_OTHER PINA.3
#define BUTTON_SET PINA.4
#define BUTTON_UP PINA.5
#define BUTTON_DOWN PINA.6

#define KEY_UP      1
#define KEY_DOWN    2
#define KEY_SET     3
#define KEY_FONT    4

#define MODE_LED      PORTA.7
#define MODE_LED_PIN  PINA.7

#define MODE_EXIT_TIME_OUT  30  //in seconds
#define BUTTON_REPEAT_TICK_COUNT  100L
//===================================================
//===================================================

typedef struct
{
  BOOL SetMode;
  //BOOL FontMode;

  unsigned char SetItem;  //0 = Second, 1 = Minute, 2 = Hour, 3 = Year, 4 = Month, 5 = Day
  int SetValue;
  BOOL SetValueChanged;
  BOOL EditValueOn;

  //int DigitsFontIndex;

  BOOL AllButtonsReleased;

  TTime ModeLastTime;
  unsigned long ButtonLastTickCount;
} TClockStatus;

TClockStatus ClockStatus;

void SetIndicator(BOOL Status)
{
  if(Status == ON)
  {
    MODE_LED = 1;
  }
  else
  {
    MODE_LED = 0;
  }
  ClockStatus.EditValueOn = Status;
}

flash unsigned char ClockStatusChar[6][21] = {
{  //Hour char
20,
0x00, 0x1C, 0x04, 0x24, 0x24, 0x04, 0x1C, 0x04, 0x1C, 0x14,
0x14, 0x00, 0x7C, 0x04, 0x04, 0x1C, 0x04, 0x1C, 0x04, 0x1C
},

{  //Minute char
20,
0x00, 0x38, 0x28, 0x3C, 0x05, 0x04, 0x1D, 0x04, 0x5C, 0x14,
0x5D, 0x04, 0x1D, 0x04, 0x5C, 0x14, 0x5C, 0x00, 0x14, 0x1C
},

{  //Second char
20,
0x00, 0x00, 0x00, 0x00, 0x38, 0x28, 0x3C, 0x05, 0x04, 0x1D,
0x04, 0x44, 0x1C, 0x00, 0xFC, 0x04, 0x24, 0x4C, 0x20, 0x00
},

{  //Day char
16,
0x00, 0x00, 0x01, 0x01, 0x5E, 0x00, 0x00, 0x31, 0x49, 0x49,
0x3E, 0x00, 0x00, 0x01, 0x01, 0x1E, 0x00, 0x00, 0x00, 0x00
},

{  //Month char
16,
0x00, 0x00, 0x00, 0x0C, 0x32, 0x12, 0x0C, 0x00, 0xFC, 0x02,
0x02, 0x02, 0x1C, 0x22, 0x22, 0x1C, 0x00, 0x00, 0x00, 0x00
},

{  //Year char
16,
0x0E, 0x01, 0x01, 0x7E, 0x00, 0x7E, 0x02, 0x02, 0x02, 0x0C,
0x02, 0x02, 0x0C, 0x02, 0x02, 0x1C, 0x00, 0x00, 0x00, 0x00
}

};

flash unsigned char Year13[9] = {
8,
0x00, 0x7E, 0x00, 0x7E, 0x10, 0x60, 0x10, 0x60
};

flash unsigned char Year14[9] = {
8,
0x00, 0x7E, 0x00, 0x7E, 0x10, 0x70, 0x50, 0x50
};

BOOL KeyPressed()
{
  unsigned char Buttons[4];
  unsigned char i, j;

  if(!ClockStatus.AllButtonsReleased)
  {
    if(TickCount - ClockStatus.ButtonLastTickCount < BUTTON_REPEAT_TICK_COUNT)
      return FALSE;
  }

  //Read buttons status
  Buttons[0] = !BUTTON_UP;
  delay_ms(5);
  Buttons[1] = !BUTTON_DOWN;
  delay_ms(5);
  Buttons[2] = !BUTTON_SET;
  delay_ms(5);
  Buttons[3] = !BUTTON_OTHER;
  delay_ms(5);


  //Prevent multiple keys to be pressed simultaneously
  for(i = 0; i < 4; i++)
    if(Buttons[i])
      for(j = 0; j < 4; j++)
        if((i != j) && Buttons[j])
          return(FALSE);


  return Buttons[0] || Buttons[1] || Buttons[2] || Buttons[3];
}

unsigned char ReadKey()
{
  ClockStatus.AllButtonsReleased = FALSE;
  ClockStatus.ButtonLastTickCount = TickCount;

  if(!BUTTON_UP)
    return KEY_UP;
  else if(!BUTTON_DOWN)
    return KEY_DOWN;
  else if(!BUTTON_SET)
    return KEY_SET;
  else if(!BUTTON_OTHER)
    return KEY_FONT;
  else
    return 0;
}

void AddToSetValue(int Value)
{
  ClockStatus.SetValue += Value;
  switch(ClockStatus.SetItem)
  {
    case 0:  //Hour
      if(ClockStatus.SetValue < 0)
        ClockStatus.SetValue = 23;
      else if(ClockStatus.SetValue > 23)
        ClockStatus.SetValue = 0;
      break;
    case 1:  //Minute
    case 2:  //Second
      if(ClockStatus.SetValue < 0)
        ClockStatus.SetValue = 59;
      else if(ClockStatus.SetValue > 59)
        ClockStatus.SetValue = 0;
      break;
    case 3:  //Day
      if(ClockStatus.SetValue < 1)
        ClockStatus.SetValue = 31;
      else if(ClockStatus.SetValue > 31)
        ClockStatus.SetValue = 1;
      break;
    case 4:  //Month
      if(ClockStatus.SetValue < 1)
        ClockStatus.SetValue = 12;
      else if(ClockStatus.SetValue > 12)
        ClockStatus.SetValue = 1;
      break;
    case 5:  //Year
      if(ClockStatus.SetValue < 1300)
        ClockStatus.SetValue = 1499;
      else if(ClockStatus.SetValue > 1499)
        ClockStatus.SetValue = 1300;
      break;
  }
}

void AdjustDateTime(unsigned char Key)
{
  switch(Key)
  {
    case KEY_UP:
      AddToSetValue(+1);
      break;
    case KEY_DOWN:
      AddToSetValue(-1);
      break;
    default:;
  }
  ClockStatus.SetValueChanged = TRUE;
}

void SetEditItem(unsigned char SetItem, int Value)
{
  TTime t;
  unsigned int year;
  unsigned char month, day;

  get_time(&t);
  get_date(&year, &month, &day, 1);  //Get shamsi date

  switch(SetItem)
  {
    case 0:  //Hour
      t.h = Value;
      set_time(t);
      break;
    case 1:  //Minute
      t.m = Value;
      set_time(t);
      break;
    case 2:  //Second
      t.s = Value;
      set_time(t);
      break;
    case 3:  //Day
      day = Value;
      set_date(year, month, day, 1);  //Year is shamsi
      break;
    case 4:  //Month
      month = Value;
      set_date(year, month, day, 1);  //Year is shamsi
      break;
    case 5:  //Year
      year = Value;
      set_date(year, month, day, 1);  //Year is shamsi
      break;
  }
}

int GetEditItem(unsigned char SetItem)
{
  TTime t;
  unsigned int year;
  unsigned char month, day;

  get_time(&t);
  get_date(&year, &month, &day, 1);  //Get shamsi date

  switch(SetItem)
  {
    case 0:  //Hour
      return(t.h);
      break;  //Not Required Here (because of return statement)
    case 1:  //Minute
      return(t.m);
      break;  //Not Required Here (because of return statement)
    case 2:  //Second
      return(t.s);
      break;  //Not Required Here (because of return statement)
    case 3:  //Day
      return(day);
      break;  //Not Required Here (because of return statement)
    case 4:  //Month
      return(month);
      break;  //Not Required Here (because of return statement)
    case 5:  //Year
      return(year);
      break;  //Not Required Here (because of return statement)
  }
  return(0);
}

BOOL ButtonsReleased()
{
  return (BUTTON_UP == 1) && (BUTTON_DOWN == 1) && (BUTTON_SET == 1) && (BUTTON_OTHER == 1);
}

void LEDDateTimeSetMode()
{
  unsigned char x = 0, y;
  unsigned char value;
  char s[3];
  unsigned char i;

  //y = (ROW_COUNT - 8) / 2;
  y = 0;

  if(ClockStatus.SetItem == 5)  //Year
  {
    if(ClockStatus.SetValue < 1400)
    {
      LEDPutChar(x, y, Year13, 0);
      x += Year13[0];
    }
    else
    {
      LEDPutChar(x, y, Year14, 0);
      x += Year14[0];
    }
    value = ClockStatus.SetValue % 100;
  }
  else
  {
    value = ClockStatus.SetValue;
  }

  sprintf(s, "%02d", value);

  for(i = 0; i < strlen(s); i++)
  {
    LEDPutChar(x, y, LEDDigitsFa[s[i] - 48], 0);
    x += LEDDigitsFa[s[i] - 48][0];
  }

  /*
  if(ClockStatus.SetMode < 3)  //Hour, Minute, Second
    LEDPutChar(x, 0, ClockStatusChar[ClockStatus.SetItem], 20);
  else
    LEDPutChar(x, 0, ClockStatusChar[ClockStatus.SetItem], 16);
  */
  LEDPutChar(x, y, ClockStatusChar[ClockStatus.SetItem], 0);
}

unsigned char CheckDateTimeButtons()
{
  unsigned char Key;

  if(BUTTON_SET)  //if the set button is not pressed return with 0
    return(0);

  //ClearScreen();  --> May cause not to capture key press

  while(1)
  {
    if(KeyPressed())
    {

      Key = ReadKey();
      if(Key == KEY_SET)
      {
        if(ClockStatus.SetMode)
        {
          switch(ClockStatus.SetItem)
          {
            case 0:  //Hour
              if(ClockStatus.SetValueChanged)
                SetEditItem(ClockStatus.SetItem, ClockStatus.SetValue);
              ClockStatus.SetItem++;
              ClockStatus.SetValue = GetEditItem(ClockStatus.SetItem);
              break;
            case 1:  //Minute
              if(ClockStatus.SetValueChanged)
                SetEditItem(ClockStatus.SetItem, ClockStatus.SetValue);
              ClockStatus.SetItem++;
              ClockStatus.SetValue = GetEditItem(ClockStatus.SetItem);
              break;
            case 2:  //Second
              if(ClockStatus.SetValueChanged)
                SetEditItem(ClockStatus.SetItem, ClockStatus.SetValue);
              ClockStatus.SetItem++;
              ClockStatus.SetValue = GetEditItem(ClockStatus.SetItem);
              break;
            case 3:  //Day
              if(ClockStatus.SetValueChanged)
                SetEditItem(ClockStatus.SetItem, ClockStatus.SetValue);
              ClockStatus.SetItem++;
              ClockStatus.SetValue = GetEditItem(ClockStatus.SetItem);
              break;
            case 4:  //Month
              if(ClockStatus.SetValueChanged)
                SetEditItem(ClockStatus.SetItem, ClockStatus.SetValue);
              ClockStatus.SetItem++;
              ClockStatus.SetValue = GetEditItem(ClockStatus.SetItem);
              break;
            case 5:  //Year
              ClockStatus.SetMode = FALSE;
              SetIndicator(OFF);
              if(ClockStatus.SetValueChanged)
                SetEditItem(ClockStatus.SetItem, ClockStatus.SetValue);
              break;
          }
          ClearScreen();
        }
        else  //if(ClockStatus.SetMode)
        {
          ClearScreen();
          ClockStatus.SetMode = TRUE;
          SetIndicator(ON);
          ClockStatus.SetItem = 0;  //Hour
          ClockStatus.SetValue = GetEditItem(ClockStatus.SetItem);
        }
        ClockStatus.SetValueChanged = FALSE;
      }  //if(Key == KEY_SET)
      else if(Key == KEY_UP)
      {
        if(ClockStatus.SetMode)
          AdjustDateTime(Key);
      }  //if(Key == KEY_SET)
      else if(Key == KEY_DOWN)
      {
      if(ClockStatus.SetMode)
        AdjustDateTime(Key);
      }
      get_time(&ClockStatus.ModeLastTime);
    }

    if(ClockStatus.SetMode)
      LEDDateTimeSetMode();

    if(time_elapsed(ClockStatus.ModeLastTime) >= MODE_EXIT_TIME_OUT)
    {
      ClockStatus.SetMode = FALSE;
    }

    ClockStatus.AllButtonsReleased = ClockStatus.AllButtonsReleased | ButtonsReleased();

    if(!ClockStatus.SetMode)
      break;
  }
  SetIndicator(OFF);
  ClearScreen();
  return(1);
}


//Refresh timer settings
#define TCCR0_VALUE 0b00001101
#define OCR0_VALUE 10

//Refresh interrupt
// Timer 0 output compare interrupt service routine
interrupt [TIM0_COMP] void timer0_comp_isr(void)
{
  // Place your code here
//  lcd_clear();
//  lcd_putsf("New");
//  #asm("sei")
  //TCCR0 = 0x00;
 // TIMSK=0b00010000;

  RefreshDisplayLatch();
  TickCount++;

  //ROWS1 = ~0;
 // TIMSK=0b00010010;
  //TCCR0 = TCCR0_VALUE;
}


flash unsigned char data[299] = {
	0x10, 0x40, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x3F, 0x0F, 0x03, 0x00, 0xE2,
	0x00, 0x00, 0x00, 0x00, 0x01, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01, 0x00, 0x80, 0x6C, 0x00, 0x02,
	0x00, 0x01, 0x00, 0x08, 0x20, 0x0F, 0xE0, 0x0F, 0xE0, 0x09, 0x20, 0x09, 0x20, 0x0F, 0xE0, 0x06,
	0xC0, 0x00, 0x00, 0x08, 0x20, 0x0F, 0xE0, 0x0F, 0xE0, 0x09, 0x20, 0x09, 0x20, 0x0F, 0xE0, 0x06,
	0xC0, 0x00, 0x00, 0x08, 0x20, 0x0F, 0xE0, 0x0F, 0xE0, 0x09, 0x20, 0x09, 0x20, 0x0F, 0xE0, 0x06,
	0xC0, 0x00, 0x00, 0x08, 0x20, 0x0F, 0xE0, 0x0F, 0xE0, 0x09, 0x20, 0x09, 0x20, 0x0F, 0xE0, 0x06,
	0xC0, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x03, 0x80, 0x07, 0xC0, 0x0C, 0x60, 0x08, 0x20, 0x08,
	0x20, 0x0C, 0x60, 0x04, 0x40, 0x00, 0x00, 0x03, 0x80, 0x07, 0xC0, 0x0C, 0x60, 0x08, 0x20, 0x08,
	0x20, 0x0C, 0x60, 0x04, 0x40, 0x00, 0x00, 0x03, 0x80, 0x07, 0xC0, 0x0C, 0x60, 0x08, 0x20, 0x08,
	0x20, 0x0C, 0x60, 0x04, 0x40, 0x00, 0x00, 0x03, 0x80, 0x07, 0xC0, 0x0C, 0x60, 0x08, 0x20, 0x08,
	0x20, 0x0C, 0x60, 0x04, 0x40, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x08, 0x20, 0x0F, 0xE0, 0x0F,
	0xE0, 0x08, 0x20, 0x0C, 0x60, 0x07, 0xC0, 0x03, 0x80, 0x00, 0x00, 0x08, 0x20, 0x0F, 0xE0, 0x0F,
	0xE0, 0x08, 0x20, 0x0C, 0x60, 0x07, 0xC0, 0x03, 0x80, 0x00, 0x00, 0x08, 0x20, 0x0F, 0xE0, 0x0F,
	0xE0, 0x08, 0x20, 0x0C, 0x60, 0x07, 0xC0, 0x03, 0x80, 0x00, 0x00, 0x08, 0x20, 0x0F, 0xE0, 0x0F,
	0xE0, 0x08, 0x20, 0x0C, 0x60, 0x07, 0xC0, 0x03, 0x80, 0x00, 0x00, 0x08, 0x20, 0x0F, 0xE0, 0x0F,
	0xE0, 0x08, 0x20, 0x0C, 0x60, 0x07, 0xC0, 0x03, 0x80, 0x00, 0x00
};

void main(void)
{
  char c;
  unsigned long int i;
  //TTimeData td;

  ///>>>>>>> Correct UCSRC in io_init()  <<<<<<<<<<<<<<<<<
  io_init();


  // LCD module initialization
  //lcd_init(16);

  //lcd_clear();
  //lcd_putsf("Start");
  //DDRA = 0x00;


  // Timer/Counter 0 initialization
  // Clock source: System Clock
  // Clock value: Timer 0 Stopped
  OCR0 = OCR0_VALUE;
  TCCR0=TCCR0_VALUE;  //0b00001100;
  TCNT0=0b00000000;
  // Timer(s)/Counter(s) Interrupt(s) initialization
  TIMSK=0b00010010;  //0x10;


  mem_init();

//  for(i = 0; i < 299; i++)
//    mem_write(i, data[i]);


/*
  -- EEPROM TEST --
  //#asm("cli");
  PORTA.7 = 1;
  delay_ms(500);
  PORTA.7 = 0;
  c = 187;
  //EEPROM_BUS_ADDRESS = 0xa0;
  mem_write(0x20, c);
  c = mem_read(0x20);
  if(c == 187)
    PORTA.7 = 1;
  while(1)
  {
  }
*/


  //display_init();
  PrepareForNewData();


  //ROW_COUNT = 12;
  //COL_COUNT = 32;
  ClearScreen();
  //UpdateScreen();

    //===============ddddddddddddddddddddddd sd f dsf
    //===============ddddddddddddddddddddddd sd f dsf
    //CurrentStage.EntranceEffectID = 8;
    //CurrentStage.ExitEffectID = 0;
    //===============ddddddddddddddddddddddd sd f dsf
    //===============ddddddddddddddddddddddd sd f dsf


/*
  #asm("cli")

  SelectRow(1);
  PutDataOnColumnLatch(0, x00);
  PutDataOnColumnLatch(1, 0xff);
  PutDataOnColumnLatch(2, 0xff);
  PutDataOnColumnLatch(3, 0xff);
  PutDataOnColumnLatch(4, 0xff);
  PutDataOnColumnLatch(5, 0xff);
  PutDataOnColumnLatch(6, 0xff);
  PutDataOnColumnLatch(7, 0xff);

  while(1)
  {
  }
*/

  ROW_COUNT = 16;
  COL_COUNT = 64;

//  rtc_set_time(11, 22, 33);

  while (1)
  {
    //WDR

    if(DataIsValid())
      UpdateScreen();

    if(CheckDateTimeButtons() == 1)
    {
      reset_usart_buffer();
    }

    if(usart_char_available())
      handle_usart();
  }
}
