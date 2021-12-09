
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
