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
