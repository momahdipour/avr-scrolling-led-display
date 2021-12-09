//usart routines for debugging
//usrdebug.c
///*
void usart_puthex(unsigned char c)
{
  char s[10];
  
  sprintf(s, "%X", c);
  putsf(";");
  puts(s);
}

void usart_putnumuc(unsigned char c)
{
  char s[10];
  
  sprintf(s, "%u", c);
  putsf(";");
  puts(s);
}

void usart_putnumul(unsigned long n)
{
  char s[20];
  
  sprintf(s, "%d", n);
  putsf(";");
  puts(s);
}

void usart_putnumi(int n)
{
  char s[20];
  
  sprintf(s, "%d", n);
  putsf(";");
  puts(s);
}

void usart_putnumui(unsigned int n)
{
  char s[10];
  
  sprintf(s, "%u", n);
  putsf(";");
  puts(s);
}
//*/