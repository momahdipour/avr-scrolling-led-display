
#if defined(_CHIP_ATMEGA32_) || defined(_CHIP_ATMEGA128_)
#define ADC_VREF_TYPE 0b11000000  //VRef: Internal 2.56 v  --  Same value for Mega32 and Mega128
#else
  #error ADC ERROR: Chip type not supported. Please change adc.c to support this chip.
#endif

#ifdef  _TEMPERATURE_ACTIVE_
//******************************************************************************************************//
//** ADC is only used for temperature, so disable its functions when temperature feature is not used. **//
//******************************************************************************************************//

void adc_start(unsigned char adc_input)
{
  ADMUX=adc_input | (ADC_VREF_TYPE & 0xff);
  // Delay needed for the stabilization of the ADC input voltage
  delay_us(10);
  // Start the AD conversion
  ADCSRA |= 0x40;  //Same value for Mega32 and Mega128
}

unsigned int read_adc()
{
  // Wait for the AD conversion to complete
  while ((ADCSRA & 0x10)==0);  //Same value for Mega32 and Mega128
  ADCSRA|=0x10;  //Same value for Mega32 and Mega128
  return ADCW;
}

#endif

/*
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
*/