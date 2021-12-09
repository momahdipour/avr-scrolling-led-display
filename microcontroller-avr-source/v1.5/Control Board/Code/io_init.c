
void init_ADC();
void init_analog_comparator();
void init_usart();
void init_timer_counter1();
void init_timer_counter2();
#ifdef  _CHIP_ATMEGA128_
void init_timer_counter3();
#endif
void init_external_interrupts();
void init_ports();

void io_init()
{
  unsigned char h, min, s;
  unsigned char y, month, d;
  
  if(ColdReset == 1)
  {
    //DS1307 substitute  *************************
    init_timer_counter1();
    TIMSK = 0b10010000;  //Timer 1 and Timer 2 compare match interrupt enabled
    
    init_ports();
    
    #ifndef _ALARM_ACTIVE_
    PORTC.2 = 0;  //Must be done before refresh routine is activated (start_refresh())
    #endif
    
    start_refresh();
    
    //Timer/Conter 0 is initialized in the start_refresh() function
    
    init_timer_counter2();
    
    #ifdef  _CHIP_ATMEGA128_
    init_timer_counter3();
    #endif
    
    init_external_interrupts();
    
    init_usart();
    
    init_analog_comparator();
    
    init_ADC();
  }
  
  // I2C Bus initialization
  i2c_init();
  
  #ifdef  _TEMPERATURE_ACTIVE_
  lm75_init(0,75,80,0);
  #endif

  rtc_init(0,0,1);
  //------------------------------------------------------
  //Check if DS1307 is set correctly and return valid values for time and date. If not, set it to valid initial values.
  rtc_get_time(&h, &min, &s);  //h = hour, min = minute, s = second
  rtc_get_date(&d, &month, &y);  //d = day, month = month, y = year
  //date limit: DATE MUST BE GREATER THAN OR EQUAL TO 1388/01/01 IN SOLAR DATE (2001) (ONLY IT IS NEEDED TO CHECK THE YEAR - MONTH AND DATE JUST MUST MEET THEIRE VALUE LIMITES (1 <= MONTH <= 12 AND 1 <= DAY <= 31)
  if(h > 23 || min > 59 || s > 59 || y < 1 /*1 means year 2001 (1380 in solar date system*/ || month < 1 || month > 12 || d < 1 || d > 31)
  {
    rtc_set_time(0, 0, 0);  //initial time: 00:00:00
    rtc_set_date(21, 3, 9);  //initial date: 1388/01/01 (1 Farvardin 1388) in solar date
  }
  //------------------------------------------------------
  //--> [[NO NEED TO THIS (-->) AT ALL]] +++rtc_get_time(&ClkHour, &ClkMinute, &ClkSecond);  --> Why we sould initialize internal clock from the rtc? No need for it.Also sometimes it makes problems when rtc is not fnctioning correctly at the startup.
  
  // Watchdog Timer initialization
  // Watchdog Timer Prescaler: OSC/2048k
  //Disabel Watchdog Timer
  //IT IS NECESSARY TO DISABLE WATCHDOG DUE TO RESETS THAT ARE INITIATED USING WATCHDOG TIMER IN THE PROGRAM
  //DisableWatchdog();  --> It is better here to disable watchdog directly not using the DisableWatchdog() function to prevent potential software bugs because it disables and enabled interrupts globally.
  WDTCR = 0b00011000;
  WDTCR = 0x00;

  // Global enable interrupts
  #asm("sei")
}

void init_analog_comparator()
{
  // Analog Comparator initialization
  // Analog Comparator: Off
  // Analog Comparator Input Capture by Timer/Counter 1: Off
  ACSR=0x80;
  SFIOR=0x00;
}

void init_ADC()
{
  // ADC initialization
  // ADC Clock frequency: 687.500 kHz
  // ADC Voltage Reference: Int., cap. on AREF
  //ADMUX=ADC_VREF_TYPE & 0xff;
  ADCSRA=0b10000111;//0x87;  =  125 KHz -- Same value for Mega32 and Mega128
}

void init_usart()
{
  // USART0 initialization
  // Communication Parameters: 8 Data, 1 Stop, No Parity
  // USART0 Receiver: On
  // USART0 Transmitter: On
  // USART0 Mode: Asynchronous
  // USART0 Baud Rate: 38400
  #ifdef  _CHIP_ATMEGA128_
  UCSR0A=0x00;
  UCSR0B=0x98;
  UCSR0C=0x06;
  UBRR0H=0x00;
  UBRR0L=0x19;
  #endif
  #ifdef  _CHIP_ATMEGA32_
  UCSRA=0x00;
  UCSRB=0x98;
  UCSRC=0x86;
  UBRRH=0x00;
  UBRRL=0x19;
  #endif
}

void init_timer_counter1()
{
  // Timer/Counter 1 initialization
  // Clock source: System Clock
  // Clock value: Timer 1 Stopped
  // Mode: Normal top=FFFFh
  // OC1A output: Discon.
  // OC1B output: Discon.
  // OC1C output: Discon.
  // Noise Canceler: Off
  // Input Capture on Falling Edge
  // Timer 1 Overflow Interrupt: Off
  // Input Capture Interrupt: Off
  // Compare A Match Interrupt: Off
  // Compare B Match Interrupt: Off
  // Compare C Match Interrupt: Off
  TCCR1A=0b00000000;//0x00;
  TCCR1B=0b00001101;//0x00;
  TCNT1H=0x00;
  TCNT1L=0x00;
  ICR1H=0x00;
  ICR1L=0x00;
  
  //OCR1A = 15625;  //For 1 second (3D09)
  OCR1AH=0x3D;
  OCR1AL=0x09;
  
  OCR1BH=0x00;
  OCR1BL=0x00;
  //OCR1CH=0x00;
  //OCR1CL=0x00;
}

void init_timer_counter2()
{
  #ifdef  _CHIP_ATMEGA32_
    ASSR=0x00;
    TCCR2=0b000011111;  //Prescalar: 1024
    TCNT2=0x00;
    OCR2=OVERALL_SPEED_SETTING;
  #endif
  #ifdef  _CHIP_ATMEGA128_
    TCCR2=0b00001101;  //Prescalar: 1024
    TCNT2=0x00;
    OCR2=OVERALL_SPEED_SETTING;
  #endif
}

#ifdef  _CHIP_ATMEGA128_
void init_timer_counter3()
{
  // Timer/Counter 3 initialization
  // Clock source: System Clock
  // Clock value: Timer 3 Stopped
  // Mode: Normal top=FFFFh
  // Noise Canceler: Off
  // Input Capture on Falling Edge
  // OC3A output: Discon.
  // OC3B output: Discon.
  // OC3C output: Discon.
  // Timer 3 Overflow Interrupt: Off
  // Input Capture Interrupt: Off
  // Compare A Match Interrupt: Off
  // Compare B Match Interrupt: Off
  // Compare C Match Interrupt: Off

  TCCR3A=0x00;
  TCCR3B=0x00;
  TCNT3H=0x00;
  TCNT3L=0x00;
  ICR3H=0x00;
  ICR3L=0x00;
  OCR3AH=0x00;
  OCR3AL=0x00;
  OCR3BH=0x00;
  OCR3BL=0x00;
  OCR3CH=0x00;
  OCR3CL=0x00;
}
#endif

void init_external_interrupts()
{
  // External Interrupt(s) initialization
  // INT0: Off
  // INT1: Off
  // INT2: Off
  // INT3: Off
  // INT4: Off
  // INT5: Off
  // INT6: Off
  // INT7: Off
//  EICRA=0x00;
//  EICRB=0x00;
//  EIMSK=0x00;
// External Interrupt(s) initialization
// INT0: Off
// INT1: Off
// INT2: Off
MCUCR=0x00;
MCUCSR=0x00;
}

void init_ports()
{
  // Input/Output Ports initialization
  // Port A initialization
  // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
  // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
  #ifndef _DEBUG_
  PORTA=0x00;
  DDRA=0b10000001;
  #endif
  
  // Port B initialization
  // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
  // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
  PORTB=0x00;
  DDRB=0xFF;
  
  // Port C initialization
  // Func7=Out Func6=Out Func5=Out Func4=Out Func3=In Func2=In Func1=In Func0=In 
  // State7=0 State6=0 State5=0 State4=0 State3=T State2=T State1=T State0=T 
  PORTC=0x00;
  DDRC=0b11111100;//0xF8;
  
  // Port D initialization
  // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
  // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
  PORTD=0x00;
  DDRD=0b01111000;
  
  #ifdef  _CHIP_ATMEGA128_
  // Port E initialization
  // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
  // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
  PORTE=0x00;
  DDRE=0x00;
  
  // Port F initialization
  // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
  // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
  PORTF=0x00;
  DDRF=0x00;
  
  // Port G initialization
  // Func4=In Func3=In Func2=In Func1=In Func0=In 
  // State4=T State3=T State2=T State1=T State0=T 
  PORTG=0x00;
  DDRG=0x00;
  #endif
}
