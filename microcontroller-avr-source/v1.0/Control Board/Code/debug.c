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
