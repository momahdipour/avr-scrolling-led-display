//debug routines

void pulse(unsigned int delay)
{
  PORTD.4 = 1;
  delay_ms(delay);
  PORTD.4 = 0;
}
