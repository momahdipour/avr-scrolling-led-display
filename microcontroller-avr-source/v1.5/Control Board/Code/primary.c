/*
unsigned long MirrorBits(unsigned long w, unsigned char from_bit, unsigned char to_bit)
{
  unsigned long result, b1, b2;
  unsigned char i, count;;
  
  b1 = 0xFFFFFFFF << from_bit;
  b2 = 0xFFFFFFFF >> (31 - to_bit);
  result = w & ~(b1 & b2);
  count = (to_bit - from_bit + 1) / 2;
  if(((to_bit - from_bit + 1) % 2) != 0)
    count++;  //Round up
  for(i = 0; i < count; i++)
  {
    #pragma warn-
    b1 = (w >> (from_bit + i)) & 0x00000001;
    #pragma warn+
    b2 = (w >> (to_bit - i)) & 0x00000001;
    
    #pragma warn-
    result = result | (b2 << (from_bit + i));
    #pragma warn+
    result = result | (b1 << (to_bit - i));
  }
  return(result);
}
*/

unsigned long ShiftBitsLeft(unsigned long w, unsigned char from_bit, unsigned char to_bit, unsigned char shift_count)
{
  unsigned long b1, b2;
  unsigned long ba1, ba2;
  
  b1 = 0xFFFFFFFF << from_bit;
  b2 = 0xFFFFFFFF >> (31 - to_bit);
  ba1 = w & ~(b1 & b2);
  
  ba2 = w & (b1 & b2);
  ba2 <<= shift_count;
  ba2 &= (b1 & b2);
  
  return(ba1 | ba2);
}

unsigned long ShiftBitsRight(unsigned long w, unsigned char from_bit, unsigned char to_bit, unsigned char shift_count)
{
  unsigned long b1, b2;
  unsigned long ba1, ba2;
  
  b1 = 0xFFFFFFFF << from_bit;
  b2 = 0xFFFFFFFF >> (31 - to_bit);
  ba1 = w & ~(b1 & b2);
  
  ba2 = w & (b1 & b2);
  ba2 >>= shift_count;
  ba2 &= (b1 & b2);
  
  return(ba1 | ba2);
}

unsigned long AndBits(unsigned long w, unsigned char from_bit, unsigned char to_bit, unsigned long wa)
{
  unsigned long b1, b2;
  unsigned long ba1, ba2;

  b1 = 0xFFFFFFFF << from_bit;
  b2 = 0xFFFFFFFF >> (31 - to_bit);
  ba1 = w & (b1 & b2);
  
  ba1 &= wa;

  ba2 = w & ~(b1 & b2);
  
  return(ba1 | ba2);
}

unsigned long NotBits(unsigned long w, char from_bit, char to_bit)
{
  unsigned long b1, b2;
  unsigned long ba1, ba2;

  if(to_bit < from_bit)
    return(w);
  
  b1 = 0xFFFFFFFF << from_bit;
  b2 = 0xFFFFFFFF >> (31 - to_bit);
  
  ba1 = ~w & (b1 & b2);
  ba2 = w & ~(b1 & b2);
  return(ba1 | ba2);
}

void LEDPutCharXX(unsigned char x, unsigned char y1, unsigned char y2, unsigned char *Data, unsigned char CharColCount, unsigned char BytesPerCol, unsigned char RightLimit)
{
  unsigned long b1, b2, b, c;
  unsigned char i;
  unsigned char ColCount, StartCol, EndCol;
  int index;
  
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
  
  b1 = 0xFFFFFFFF << y1;
  b2 = 0xFFFFFFFF >> (31 - y2);
  b = ~(b1 & b2);
  index = (int) StartCol - (int) BytesPerCol;
  
  if(ColCount > 254)
    ColCount = 254;
  
  for(i = 1; i <= ColCount; i++)
  {
    if(x > RightLimit)
      break;
    
    //c = 0;
    //index = (unsigned int) StartCol + ((unsigned int) i - 1) * (unsigned long)BytePerCol;
    index += (int) BytesPerCol;
    
    #pragma warn-
    c = Data[index];  //MSB
    if(BytesPerCol > 1)
      c = (c << 8) | Data[index + 1];  //LSB
    #ifdef  _ROWS_24_
    if(BytesPerCol > 2)
        c = (c << 8) | Data[index + 2];  //LSB
    #endif
    #ifdef  _ROWS_32_
    if(BytesPerCol > 3)
        c = (c << 8) | Data[index + 3];  //LSB
    #endif
    #pragma warn+
    /*
    switch(BytesPerCol)
    {
      case 1:
        c = Data[index];  //MSB
        break;
      case 2:
        c = Data[index];  //MSB
        #pragma warn-
        c = (c << 8) | Data[index + 1];  //LSB
        #pragma warn+
        break;
      case 3:
        c = Data[index];  //MSB
        #pragma warn-
        c = (c << 8) | Data[index + 1];  //LSB
        c = (c << 8) | Data[index + 2];  //LSB
        #pragma warn+
        break;
      case 4:
        c = Data[index];  //MSB
        #pragma warn-
        c = (c << 8) | Data[index + 1];  //LSB
        c = (c << 8) | Data[index + 2];  //LSB
        c = (c << 8) | Data[index + 3];  //LSB
        #pragma warn+
        break;
    }
    */
    
    //c = MirrorBits(c, 0, 15);
    
    c <<= y1;
    
    if(y1 > 0)
      c = AndBits(c, 0, y1 - 1, 0);
    if(y2 < (ROW_COUNT - 1))
      c = AndBits(c, y2 + 1, ROW_COUNT - 1, 0);
    
    b1 = LoadFromScreen(x);
    
    b1 = (b & b1) | c;
    
    StoreToScreen(b1, x);
    
    x++;
  }
}

void LEDPutChar(unsigned char x, unsigned char y1, unsigned char y2, unsigned char *Data, unsigned char CharColCount, unsigned char CharHeight, unsigned char RightLimit)
{
  switch(CharHeight)
  {
    case 8:
      LEDPutCharXX(x, y1, y2, Data, CharColCount, 1, RightLimit);
      break;
    case 16:
      LEDPutCharXX(x, y1, y2, Data, CharColCount, 2, RightLimit);
      break;
    #ifdef  _ROWS_24_
    case 24:
      LEDPutCharXX(x, y1, y2, Data, CharColCount, 3, RightLimit);
      break;
    #endif
    #ifdef  _ROWS_32_
    case 32:
      LEDPutCharXX(x, y1, y2, Data, CharColCount, 4, RightLimit);
      break;
    #endif
  }
}

void LEDPutCharE(unsigned char x, unsigned char y1, unsigned char y2, unsigned char eeprom *Data, unsigned char CharColCount, unsigned char CharHeight, unsigned char RightLimit)
{
  #define   MAX_INTERNAL_EEP_CHAR_DATA_SIZE     50
  unsigned char CharData[MAX_INTERNAL_EEP_CHAR_DATA_SIZE];
  unsigned char i;
  
  #warning IMPORTANT ATTENTION: "MAX_INTERNAL_EEP_CHAR_DATA_SIZE" must be greater than or equal to the size of each of the font chars stored on the internal EEPROM. Check it in the final release.
  
  for(i = 0; i < MAX_INTERNAL_EEP_CHAR_DATA_SIZE; i++)
    CharData[i] = Data[i];
  
  LEDPutChar(x, y1, y2, CharData, CharColCount, CharHeight, RightLimit);
}

/*
void LEDPutChar8f(unsigned char x, unsigned char y1, unsigned char y2, unsigned char flash *Data, unsigned char CharColCount)
{
  unsigned long b1, b2, b, c;
  unsigned char col;
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
  
  b1 = 0xFFFFFFFF << y1;
  b2 = 0xFFFFFFFF >> (31 - y2);
  b = ~(b1 & b2);

  for(col = StartCol; col <= EndCol; col++)
  {
    if(x >= MAX_COL_COUNT)
      break;
    
    //c = MirrorByte(Data[col]);
    c = MirrorBits((unsigned long) Data[col], 0, 7);
    
    c <<= y1;
    
    if(y1 > 0)
      c = AndBits(c, 0, y1 - 1, 0);
    if(y2 < (ROW_COUNT - 1))
      c = AndBits(c, y2 + 1, ROW_COUNT - 1, 0);
    
    b1 = LoadFromScreen(x);
    
    b1 = (b & b1) | c;
    
    StoreToScreen(b1, x);
    
    x++;
  }
}
*/

/*  --> THIS FUNCTION MUST BE CHANGED AS IN LEDPutChar8f OR BE CHANGED AS LEDPutCharXX
void LEDPutChar16f(unsigned char x, unsigned char y1, unsigned char y2, unsigned char flash *Data, unsigned char CharColCount)
{
  unsigned int b1, b2, b, c;
  unsigned char i;
  unsigned char ColCount, StartCol, EndCol;
  unsigned int index;
  
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
  
  b1 = 0xFFFF << y1;
  b2 = 0xFFFF >> (15 - y2);
  b = ~(b1 & b2);
  for(i = 1; i <= ColCount; i++)
  {
    if(x >= MAX_COL_COUNT)
      break;

    //c = 0;
    index = (unsigned int) StartCol + ((unsigned int) i - 1) * 2U;
    c = Data[index];  //MSB
    c = (c << 8) | Data[index + 1];  //LSB
    c = MirrorBits(c, 0, 15);
    
    c <<= y1;
    
    if(y1 > 0)
      c = AndBits(c, 0, y1 - 1, 0);
    if(y2 < (ROW_COUNT - 1))
      c = AndBits(c, y2 + 1, ROW_COUNT - 1, 0);
    
    b1 = Screen[1][x];
    b1 = (b1 << 8) | Screen[0][x];
    
    b1 = (b & b1) | c;
    
    Screen[0][x] = b1;
    Screen[1][x] = b1 >> 8;

    x++;
  }
}
*/

/*
void LEDPutCharf(unsigned char x, unsigned char y1, unsigned char y2, unsigned char flash *Data, unsigned char CharColCount, unsigned char CharHeight)
{
  if(CharHeight == 8)
    LEDPutChar8f(x, y1, y2, Data, CharColCount);
//  else if(CharHeight == 16)
//    LEDPutChar16f(x, y1, y2, Data, CharColCount);
}
*/

void LEDPutSpace(unsigned char x, unsigned char y1, unsigned char y2, unsigned char SpaceColCount, unsigned char CharHeight, unsigned char RightLimit)
{
  unsigned char col;
  unsigned char EmptyChar[4] = {0x00, 0x00, 0x00, 0x00};
  
  for(col = 1; col <= SpaceColCount; col++)
  {
    LEDPutChar(x, y1, y2, EmptyChar, 1, CharHeight, RightLimit);
    x++;
  }
}

#ifndef _DEBUG_
eeprom unsigned char RowSelectorsDONTNOT_EEP[32] = {
//This array must be used when there is no need to NOT rows when we want to select a row.
1, 2, 4, 8, 16, 32, 64, 128,
1, 2, 4, 8, 16, 32, 64, 128,
1, 2, 4, 8, 16, 32, 64, 128,
1, 2, 4, 8, 16, 32, 64, 128
};
#endif


//This array must be used when rows must be NOT to select a row.
unsigned char RowSelectorsNOT[32];

//This array must be used when there is no need to NOT rows when we want to select a row.
unsigned char RowSelectorsDONTNOT[32];

/*
//This array must be used when rows must be NOT to select a row.
unsigned char RowSelectorsNOT[32] = {
0xfe, 0xfd, 0xfb, 0xf7, 0xef, 0xdf, 0xbf, 0x7f,
0xfe, 0xfd, 0xfb, 0xf7, 0xef, 0xdf, 0xbf, 0x7f,
0xfe, 0xfd, 0xfb, 0xf7, 0xef, 0xdf, 0xbf, 0x7f,
0xfe, 0xfd, 0xfb, 0xf7, 0xef, 0xdf, 0xbf, 0x7f
};

unsigned char RowSelectorsDONTNOT[32] = {
//This array must be used when there is no need to NOT rows when we want to select a row.
1, 2, 4, 8, 16, 32, 64, 128,
1, 2, 4, 8, 16, 32, 64, 128,
1, 2, 4, 8, 16, 32, 64, 128,
1, 2, 4, 8, 16, 32, 64, 128
};
*/

/*
//This array is for the first LED Display in which rows were not connected correctly.
flash unsigned char RowSelectors[32] = {
128, 64, 32, 16, 8, 4, 2, 1,
128, 64, 32, 16, 8, 4, 2, 1,
1, 2, 4, 8, 16, 32, 64, 128,
1, 2, 4, 8, 16, 32, 64, 128
};
*/

unsigned char* RowSelectors;

#ifdef  _CHIP_ATMEGA32_
  #pragma optsize-  //Always optimize this routine for maximum execution speed
#endif

void SelectRow(unsigned char row /*starting from 0*/)
{
  register unsigned char row_reg;
  //unsigned char temp;
  
  /*
  0..7: clkR0=PORTD.3
  8..15: clkR0=PORTD.4
  16..23: clkR0=PORTD.5
  24..31: clkR0=PORTD.6
  */
  
  //temp = 0x01 << (row % 8);
  //PORTB = temp;
  row_reg = row;
  
  PORTB = RowSelectors[row_reg];
  
  //Generate pulse
  if(row_reg < 8)
  {
    PORTD.3 = 1;
    //delay_us(LATCH_PULSE_DURATION);
    PORTD.3 = 0;
  }
  else if(row_reg <= 15)
  {
    PORTD.4 = 1;
    //delay_us(LATCH_PULSE_DURATION);
    PORTD.4 = 0;
  }
  #if defined(_ROWS_24_) || defined(_COLOR_DISPLAY_METHOD_2_)
  else if(row_reg <= 23)
  {
    PORTD.5 = 1;
    //delay_us(LATCH_PULSE_DURATION);
    PORTD.5 = 0;
  }
  #endif
  #if defined(_ROWS_32_) || defined(_COLOR_DISPLAY_METHOD_2_)
  else
  {
    PORTD.6 = 1;
    //delay_us(LATCH_PULSE_DURATION);
    PORTD.6 = 0;
  }
  #endif
}

#ifdef  _CHIP_ATMEGA32_
  #pragma optsize+
#endif

unsigned char RowCatcherBytes[8] = {
0b00000001, 0b00000010, 0b00000100, 0b00001000,
0b00010000, 0b00100000, 0b01000000, 0b10000000
};

#ifdef  _CHIP_ATMEGA32_
  #pragma optsize-  //Always optimize this routine for maximum execution speed
#endif

unsigned char RowDataForLatches[16];  //Max 128 columns (= 16 * 8) i.e. max 16 column latches

void PrepareRowData(unsigned char Row)
{
  unsigned char a, r, i;
  unsigned char RowData;
  unsigned char ScreenRow;
  unsigned char FromCol;
  unsigned char ToCol;
  unsigned char LatchIndex = 0;
  
  i = Row;
  
  if(i < 8)
    r = i;
  else if(i < 16)
    r = i - 8;
  else if(i < 24)
    r = i - 16;
  else if(i < 32)
    r = i - 24;
  
  a = RowCatcherBytes[r];
  
  ScreenRow = i / 8;  //possible resulting values: 0, 1, 2, 3
  
  for(FromCol = 0; FromCol < COL_COUNT; FromCol+=8)
  {
    ToCol = FromCol + 7;
    RowData = 0x00;
    for(i = ToCol; i > FromCol; i--)  //If we write i >= FromCol, it will be an infinite loop when FromCol is 0 because i is an unsigned char variable.
    {
      RowData <<= 1;
      RowData |= (Screen[ScreenRow][i] & a) >> r;
    }
    RowData <<= 1;
    RowData |= (Screen[ScreenRow][FromCol] & a) >> r;
    
    RowDataForLatches[LatchIndex] = RowData;
    LatchIndex++;
  }
}

#ifdef  _CHIP_ATMEGA32_
  #pragma optsize+
#endif


#ifdef  _CHIP_ATMEGA32_
  #pragma optsize-  //Always optimize this routine for maximum execution speed
#endif

/*
unsigned char GetRowData8(unsigned char Row, unsigned char FromCol)
{
  //Row starting from 0
  unsigned char RowData = 0x00;
  unsigned char i;
  unsigned char a;
  unsigned char r;
  unsigned char ToCol, FromColReg;
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
/*
  i = Row;
  FromColReg = FromCol;
  ToCol = FromColReg + 7;
  
  if(i < 8)
  {
    //a = 0b10000000 >> (7 - Row);
    r = i;
    a = RowCatcherBytes[r];
    
    for(i = ToCol; i > FromColReg; i--)  //If we write i >= FromCol, it will be an infinite loop when FromCol is 0 because i is an unsigned char variable.
    {
      RowData <<= 1;
      RowData |= (Screen[0][i] & a) >> r;
    }
    RowData <<= 1;
    RowData |= (Screen[0][FromColReg] & a) >> r;
    
    return(RowData);
  }
  else if(i < 16)
  {
    //a = 0b10000000 >> (15 - Row);
    r = i - 8;
    a = RowCatcherBytes[r];
    
    for(i = ToCol; i > FromColReg; i--)  //If we write i >= FromCol, it will be an infinite loop when FromCol is 0 because i is an unsigned char variable.
    {
      RowData <<= 1;
      RowData |= (Screen[1][i] & a) >> r;
    }
    RowData <<= 1;
    RowData |= (Screen[1][FromColReg] & a) >> r;
    
    return(RowData);
  }
  #ifdef  _ROWS_24_
  else if(i < 24)
  {
    //a = 0b10000000 >> (23 - Row);
    r = i - 16;
    a = RowCatcherBytes[r];
    
    for(i = ToCol; i > FromColReg; i--)  //If we write i >= FromCol, it will be an infinite loop when FromCol is 0 because i is an unsigned char variable.
    {
      RowData <<= 1;
      RowData |= (Screen[2][i] & a) >> r;
    }
    RowData <<= 1;
    RowData |= (Screen[2][FromColReg] & a) >> r;
    
    return(RowData);
  }
  #endif
  #ifdef  _ROWS_32_
  else if(i < 32)
  {
    //a = 0b10000000 >> (31 - Row);
    r = i - 24;
    a = RowCatcherBytes[r];
    
    for(i = ToCol; i > FromColReg; i--)  //If we write i >= FromCol, it will be an infinite loop when FromCol is 0 because i is an unsigned char variable.
    {
      RowData <<= 1;
      RowData |= (Screen[3][i] & a) >> r;
    }
    RowData <<= 1;
    RowData |= (Screen[3][FromColReg] & a) >> r;
    
    return(RowData);
  }
  #endif
}
*/

#ifdef  _CHIP_ATMEGA32_
  #pragma optsize+
#endif


/*
#ifdef  _CHIP_ATMEGA32_
  #pragma optsize-  //Always optimize this routine for maximum execution speed
#endif

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
//  return( (Screen[0][FromCol] & a) >> Row |
//  ((Screen[r_index][FromCol + 1] & a) >> Row) << 1 |
//  ((Screen[r_index][FromCol + 2] & a) >> Row) << 2 |
//  ((Screen[r_index][FromCol + 3] & a) >> Row) << 3 |
//  ((Screen[r_index][FromCol + 4] & a) >> Row) << 4 |
//  ((Screen[r_index][FromCol + 5] & a) >> Row) << 5 |
//  ((Screen[r_index][FromCol + 6] & a) >> Row) << 6 |
//  ((Screen[r_index][FromCol + 7] & a) >> Row) << 7
//  );

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
  #ifdef  _ROWS_24_
  else if(Row < 24)
  {
    //a = 0b10000000 >> (23 - Row);
    r = Row - 16;
    a = RowCatcherBytes[r];
    
    for(i = FromCol; i <= ToCol; i++)
    {
      #pragma warn-
      temp = (Screen[2][i]) & a;
      #pragma warn+
      temp = temp >> r;
      RowData |= temp << bitpos;
      bitpos++;
    }
    return(RowData);
  }
  #endif
  #ifdef  _ROWS_32_
  else if(Row < 32)
  {
    //a = 0b10000000 >> (31 - Row);
    r = Row - 24;
    a = RowCatcherBytes[r];
    
    for(i = FromCol; i <= ToCol; i++)
    {
      #pragma warn-
      temp = (Screen[3][i]) & a;
      #pragma warn+
      temp = temp >> r;
      RowData |= temp << bitpos;
      bitpos++;
    }
    return(RowData);
  }
  #endif
}

#ifdef  _CHIP_ATMEGA32_
  #pragma optsize+
#endif
*/

/*
flash unsigned char ColumnLatchSelector[16] = {
0x80, 0x88, 0x90, 0x98, 0xa0, 0xa8, 0xb0, 0xb8,
0xc0, 0xc8, 0xd0, 0xd8, 0xe0, 0xe8, 0xf0, 0xf8
};
*/

/*
flash unsigned char ColumnLatchSelectorPC3[16] = {
0, 1, 0, 1, 0, 1, 0, 1,
0, 1, 0, 1, 0, 1, 0, 1
};

flash unsigned char ColumnLatchSelectorPC4[16] = {
0, 0, 1, 1, 0, 0, 1, 1,
0, 0, 1, 1, 0, 0, 1, 1
};

flash unsigned char ColumnLatchSelectorPC5[16] = {
0, 0, 0, 0, 1, 1, 1, 1,
0, 0, 0, 0, 1, 1, 1, 1
};

flash unsigned char ColumnLatchSelectorPC6[16] = {
0, 0, 0, 0, 0, 0, 0, 0,
1, 1, 1, 1, 1, 1, 1, 1
};
*/

/*
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
*/

#define   COLUMNS_NOT_EEP_DEFAULT     0xFF//0x00  //0x00 = No, 0xFF = Yes
#define   ROWS_NOT_EEP_DEFAULT        0x00//0x00//(for color display method 2 (row-based) //0xFF (for normal display)  //0x00 = No, 0xFF = Yes
eeprom unsigned char COLUMNS_NOT_EEP = COLUMNS_NOT_EEP_DEFAULT;  //0xFF: NOT, otherwise (must be 0x00) do not NOT
eeprom unsigned char ROWS_NOT_EEP = ROWS_NOT_EEP_DEFAULT;  //0xFF: NOT, otherwise (must be 0x00) do not NOT

unsigned char COLUMNS_NOT = COLUMNS_NOT_EEP_DEFAULT;
unsigned char ROWS_NOT = ROWS_NOT_EEP_DEFAULT;

unsigned char FILTER_OFF = 0x00;  //0x00: Red and Green filter is on and applied to the output
                                  //0xff: Red and Green filter is not used (everything on the Screen array is displayed)

void ApplyRefreshSettings()
{
  COLUMNS_NOT = COLUMNS_NOT_EEP;
  ROWS_NOT = ROWS_NOT_EEP;
  if(ROWS_NOT)
    RowSelectors = RowSelectorsNOT;
  else
    RowSelectors = RowSelectorsDONTNOT;
}

#define LATCH_COUNT (COL_COUNT >> 3)//(COL_COUNT / 8)


/*
void RefreshDisplayLatch()
{
  
}
*/


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

void ClearScreen(BOOL ForceFullClear)
{
  unsigned char Col;
  
//  if(ForceFullClear)
//  {
    for(Col = 0; Col < MAX_COL_COUNT; Col++)
    {
      StoreToScreen(0, Col);
    }
/*  }
  else
  {
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
    #ifdef  _ROWS_24_
    else if(ROW_COUNT <= 24)
    {
      for(Col = 0; Col < COL_COUNT; Col++)
      {
        Screen[0][Col] = 0x00;
        Screen[1][Col] = 0x00;
        Screen[2][Col] = 0x00;
      }
    }
    #endif
    #ifdef  _ROWS_32_
    else
    {
      for(Col = 0; Col < COL_COUNT; Col++)
      {
        Screen[0][Col] = 0x00;
        Screen[1][Col] = 0x00;
        Screen[2][Col] = 0x00;
        Screen[3][Col] = 0x00;
      }
      #endif
    }
  }*/
}

void ClearAnimScreen()
{
  unsigned char Col;
  
  //No need to speed up this routine
  for(Col = 0; Col < COL_COUNT; Col++)
  {
    StoreToAnimScreen(0, Col);
  }
}

void ClearAreaXY(unsigned char x1, unsigned char y1, unsigned char x2, unsigned char y2)
{
  unsigned char col;
  unsigned long b1, b2, b;
  
  b1 = 0xFFFFFFFF << y1;
  b2 = 0xFFFFFFFF >> (31 - y2);
  b = ~(b1 & b2);
  
  for(col = x1; col <= x2; col++)
  {
    b1 = LoadFromScreen(col);
 
    b1 = b & b1;
    //c is 0x0000
    //c <<= y1;
    //b1 |= c;
    
    StoreToScreen(b1, col);
  }
}

void ClearArea(TArea Area)
{
  ClearAreaXY(Area.x1, Area.y1, Area.x2, Area.y2);
  //DrawAreaBorders(&Area, TRUE);  //Clear all borders of this area (if any available)  --> Don't clear tje area borders because the screen layout on the LED Display is destroyed in bad shape
}

void FillAreaXY(unsigned char x1, unsigned char y1, unsigned char x2, unsigned char y2)
{
  unsigned char col;
  unsigned long b1, b2, b, c;
  
  b1 = 0xFFFFFFFF << y1;
  b2 = 0xFFFFFFFF >> (31 - y2);
  b = ~(b1 & b2);
  
  c = NotBits(0x00000000, y1, y2);
//  c = 0xffff << y1;
//  c = 0xffff  << y1;
  for(col = x1; col <= x2; col++)
  {
    b1 = LoadFromScreen(col);
    
    b1 = b & b1;
    //c is 0xffff
    //c <<= y1;
    b1 |= c;
    
    StoreToScreen(b1, col);
  }
}

void FillArea(TArea Area)
{
  FillAreaXY(Area.x1, Area.y1, Area.x2, Area.y2);
}
