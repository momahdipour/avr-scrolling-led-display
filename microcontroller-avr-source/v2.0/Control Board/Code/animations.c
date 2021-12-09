//Animations

//Animation delay constants (in milliseconds)
#define   ANIM_BLINK_DELAY        140  //in milliseconds
#define   ANIM_DELAY_1            10  //scrolls vertically half a time
#define   ANIM_DELAY_2            (ANIM_DELAY_1 / 4)  //scrolls vertically 2 times
#define   ANIM_DELAY_3            (ANIM_DELAY_1 / 2)  //scrolls vertically 1 time
#define   ANIM_COL_BY_COL_DELAY   5  //e.g. Anim7 - Defined for max row count of 16 - for height row count values, must be defined again
///////////////////////////

#ifdef  _TEXT_ANIMATIONS_ACTIVE_
  
typedef struct
{
  int NextCol;
  unsigned char AnimStage;
  unsigned long LastTickCount;
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

#endif

unsigned char ApplyAnimation(unsigned char AreaID, TArea *Area, unsigned char AnimID)
{
  #ifndef   _TEXT_ANIMATIONS_ACTIVE_
    return(TRUE);
  #else
//Returns 1 if the animation is done
  int i;
  static BOOL CallFlag = FALSE;
  
  CallFlag = !CallFlag;
  
  switch(AnimID)
  {
    case 1:
      return(Anim1(AreaID, *Area));
      break;
    case 2:
      return(Anim2(AreaID, *Area));
      break;
    case 3:
      return(Anim3(AreaID, *Area));
      break;
    case 4:
      return(Anim4(AreaID, *Area));
      break;
    case 5:
      return(Anim5(AreaID, *Area));
      break;
    case 6:
      return(Anim6(AreaID, *Area));
      break;
    case 7:
      return(Anim7(AreaID, *Area));
      break;
    case 8:
      return(Anim8(AreaID, *Area));
      break;
    case 9:
      return(Anim9(AreaID, *Area));
      break;
    case 10:
      return(Anim10(AreaID, *Area));
      break;
    case 11:
      //This animation should be run several times in each call
      for(i = 1; i < 12; i++)
      {
        if(Anim11(AreaID, *Area))
          return(TRUE);
      }
      return(FALSE);
      break;
    case 12:
      return(Anim12(AreaID, *Area));
      break;
    case 13:
      //This animation should be called one time every two calls
      if(CallFlag)
        return(Anim13(AreaID, *Area));
      else
        return(FALSE);
      break;
    case 14:
      return(Anim14(AreaID, *Area));
      break;
    case 15:
      return(Anim15(AreaID, *Area));
      break;
    default:
      return(TRUE);  //Undefined animation IDs must be returned successfully
  }
  #endif
}

void InitAnim(unsigned char AreaID, TArea *Area, unsigned char AnimID)
{        
#ifdef  _TEXT_ANIMATIONS_ACTIVE_

  switch(AnimID)
  {
    case 1:
      InitAnim1(AreaID, *Area);
      break;
    case 2:
      InitAnim2(AreaID, *Area);
      break;
    case 3:
      InitAnim3(AreaID, *Area);
      break;
    case 4:
      InitAnim4(AreaID, *Area);
      break;
    case 5:
      InitAnim5(AreaID, *Area);
      break;
    case 6:
      InitAnim6(AreaID, *Area);
      break;
    case 7:
      InitAnim7(AreaID, *Area);
      break;
    case 8:
      InitAnim8(AreaID, *Area);
      break;
    case 9:
      InitAnim9(AreaID, *Area);
      break;
    case 10:
      InitAnim10(AreaID, *Area);
      break;
    case 11:
      InitAnim11(AreaID, *Area);
      break;
    case 12:
      InitAnim12(AreaID, *Area);
      break;
    case 13:
      InitAnim13(AreaID, *Area);
      break;
    case 14:
      InitAnim14(AreaID, *Area);
      break;
    case 15:
      InitAnim15(AreaID, *Area);
      break;
    default:
      ;
  }
  
#endif
}

////////////  ANIMATIONS

#ifdef  _TEXT_ANIMATIONS_ACTIVE_

//////////////////////////
//Primary functions
unsigned long GetAnimData(unsigned char Col, unsigned char y1, unsigned char y2)
{
  unsigned long b1, b2, b;
  
  b1 = 0xFFFFFFFF << y1;
  b2 = 0xFFFFFFFF >> (31 - y2);
  b = (b1 & b2);
  
  b1 = LoadFromAnimScreen(Col);  //v >>= (NextCol + 32 - ROW_COUNT);
  
  b = b & b1;
  return(b);
}

unsigned long GetAnimDataNOT(unsigned char Col, unsigned char y1, unsigned char y2)
{
  unsigned long b1, b2, b;

  b1 = 0xFFFFFFFF << y1;
  b2 = 0xFFFFFFFF >> (31 - y2);
  b = (b1 & b2);
  
  b1 = ~LoadFromAnimScreen(Col);
  
  /*
  #ifdef  _ROWS_32_
  b1 = ~AnimScreen[3][Col];
  b1 = (b1 << 8) | ~AnimScreen[2][Col];
  b1 = (b1 << 8) | ~AnimScreen[1][Col];
  b1 = (b1 << 8) | ~AnimScreen[0][Col];
  #else
    #ifdef  _ROWS_24_
    b1 = ~AnimScreen[2][Col];
    b1 = (b1 << 8) | ~AnimScreen[1][Col];
    b1 = (b1 << 8) | ~AnimScreen[0][Col];
    #else
    b1 = ~AnimScreen[1][Col];
    b1 = (b1 << 8) | ~AnimScreen[0][Col];
    #endif
  #endif
  */
   
  b = b & b1;
  return(b);
}

unsigned long GetScreenData(unsigned char Col, unsigned char y1, unsigned char y2)
{
  unsigned long b1, b2, b;

  b1 = 0xFFFFFFFF << y1;
  b2 = 0xFFFFFFFF >> (31 - y2);
  b = ~(b1 & b2);
  
  b1 = LoadFromScreen(Col);
  
  b = b & b1;
  return(b);
}
//End of primary functions
//////////////////////////

void InitAnim1(unsigned char AreaID, TArea Area)
{
  #ifdef  _ANIM_1_ACTIVE_
  
  as[AreaID].NextCol = 0;
  
  #endif
}

unsigned char Anim1(unsigned char AreaID, TArea Area)
{
  //Fill from left - Å— ‘œ‰ «“ çÅ »Â ”„  —«” 
  #ifndef  _ANIM_1_ACTIVE_
  
    return(TRUE);  //This text effect is not available on Mega32 due to low memory space
    
  #else
  
  unsigned long b, c;
  
  c = GetAnimData(as[AreaID].NextCol + Area.x1, Area.y1, Area.y2);
  b = GetScreenData(as[AreaID].NextCol + Area.x1, Area.y1, Area.y2);
  b |= c;
  
  StoreToScreen(b, as[AreaID].NextCol + Area.x1);
  
  as[AreaID].NextCol++;
  if(as[AreaID].NextCol + Area.x1 > Area.x2)
    return(TRUE);
  else
    return(FALSE);
  
  #endif
}

void InitAnim2(unsigned char AreaID, TArea Area)
{
  #ifdef  _ANIM_2_ACTIVE_
  
  as[AreaID].NextCol = 0;
  
  #endif
}

unsigned char Anim2(unsigned char AreaID, TArea Area)
{
  //Fill from right - Å— ‘œ‰ «“ —«”  »Â ”„  çÅ
  #ifndef  _ANIM_2_ACTIVE_
  
    return(TRUE);  //This text effect is not available on Mega32 due to low memory space
    
  #else
  
  unsigned long b, c;
  
  c = GetAnimData(Area.x2 - as[AreaID].NextCol, Area.y1, Area.y2);
  b = GetScreenData(Area.x2 - as[AreaID].NextCol, Area.y1, Area.y2);
  b |= c;
  
  StoreToScreen(b, Area.x2 - as[AreaID].NextCol);
  
  as[AreaID].NextCol++;
//      if( (int) ((int) Area.x2 - (int) as[AreaID].NextCol) <= (int) Area.x1 )
  if(Area.x2 - as[AreaID].NextCol <= Area.x1)
    return(TRUE);
  else
    return(FALSE);
  
  #endif
}

void InitAnim3(unsigned char AreaID, TArea Area)
{
  as[AreaID].NextCol = (int) Area.y2 - Area.y1 + 1;
  as[AreaID].LastTickCount = TickCount;
}

unsigned char Anim3(unsigned char AreaID, TArea Area)
{
  //Dividing lines - —ÌŒ ‰ «“ »«·« Ê Å«ÌÌ‰ »’Ê—  ‘«‰Â «Ì
  unsigned char Col;
  unsigned long b, c;
  
  if(MSElapsed(as[AreaID].LastTickCount) < ANIM_DELAY_1)
  {
    return(FALSE);
  }
  //if((TickCount - as[AreaID].LastTickCount) < ANIM_DELAY_1)
  //  return(FALSE);
  
  for(Col = Area.x1; Col <= Area.x2; Col++)
  {
    c = GetAnimData(Col, Area.y1, Area.y2);
    
    if((Col % 4) <= 1)  //(Col % 4 == 0) || (Col % 4 == 1))
    {
      c = ShiftBitsLeft(c, Area.y1, Area.y2, as[AreaID].NextCol);
      //c <<= as[AreaID].NextCol;
    }
    else if((Col % 4) <= 3)  //(Col % 4 == 2) || (Col % 4 == 3))
    {
      c = ShiftBitsRight(c, Area.y1, Area.y2, as[AreaID].NextCol);
      //c >>= as[AreaID].NextCol;
    }
    
//    if(Area.y1 > 0)
//      c = AndBits(c, 0, Area.y1 - 1, 0);
//    if(Area.y2 < 15)
//      c = AndBits(c, Area.y2 + 1, 15, 0);
    
    b = GetScreenData(Col, Area.y1, Area.y2);
    
    b |= c;
    
    StoreToScreen(b, Col);
  }

  //delay_ms(ANIM_DELAY_1);
  
  as[AreaID].LastTickCount = TickCount;

  as[AreaID].NextCol--;
  if(as[AreaID].NextCol < 0)
    return(TRUE);
  else
    return(FALSE);
}

void InitAnim4(unsigned char AreaID, TArea Area)
{
  #ifdef  _ANIM_4_ACTIVE_
  
  as[AreaID].NextCol = 0;
  as[AreaID].AnimStage = 0;
  as[AreaID].LastTickCount = TickCount;
  
  #endif
}

unsigned char Anim4(unsigned char AreaID, TArea Area)
{
  //Å— ‘œ‰ «“ »«·« »’Ê—  ” Ê‰Ì Ìò œ— „Ì«‰
  #ifndef  _ANIM_4_ACTIVE_
  
    return(TRUE);  //This text effect is not available on Mega32 due to low memory space
    
  #else
  
  unsigned char Col;
  unsigned long b, c;
  unsigned long filter;
  
  if(MSElapsed(as[AreaID].LastTickCount) < ANIM_DELAY_2)
  {
    return(FALSE);
  }
  //if((TickCount - as[AreaID].LastTickCount) < ANIM_DELAY_2)
  //  return(FALSE);

  if(as[AreaID].AnimStage == 0)
    Col = Area.x1;
  else
    Col = Area.x1 + 1;

  #pragma warn-
  filter = ~(0xffffffff << (as[AreaID].NextCol + Area.y1));
  #pragma warn+
  
  for(; Col <= Area.x2; Col+=2)
  {
    b = GetAnimData(Col, Area.y1, Area.y2);

    //c = b;
    
    //c &= filter;
    
    c = b & filter;
    
    b = GetScreenData(Col, Area.y1, Area.y2);

    b |= c;
    
    StoreToScreen(b, Col);
  }
  
  //delay_ms(ANIM_DELAY_2);
  
  as[AreaID].LastTickCount = TickCount;

  as[AreaID].NextCol++;
  if(as[AreaID].NextCol > (Area.y2 - Area.y1 + 1))
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
  
  #endif
}

void InitAnim5(unsigned char AreaID, TArea Area)
{
  #ifdef  _ANIM_5_ACTIVE_
  
  as[AreaID].NextCol = (int) Area.y2 - Area.y1 + 1;
  as[AreaID].LastTickCount = TickCount;
  
  #endif
}

unsigned char Anim5(unsigned char AreaID, TArea Area)
{
  //Ê—Êœ «“ »«·« 
  #ifndef  _ANIM_5_ACTIVE_
  
    return(TRUE);  //This text effect is not available on Mega32 due to low memory space
    
  #else
  
  unsigned char Col;
  unsigned long b, c;
  
  if(MSElapsed(as[AreaID].LastTickCount) < ANIM_DELAY_3)
  {
    return(FALSE);
  }
  //if((TickCount - as[AreaID].LastTickCount) < ANIM_DELAY_3)
  //  return(FALSE);

  for(Col = Area.x1; Col <= Area.x2; Col++)
  {
    //b = GetAnimData(Col, Area.y1, Area.y2);
    //c = b;
    c = GetAnimData(Col, Area.y1, Area.y2);
    
    //c <<= Area.y1;
    c = ShiftBitsRight(c, Area.y1, Area.y2, as[AreaID].NextCol);

    b = GetScreenData(Col, Area.y1, Area.y2);
    b |= c;
    
    StoreToScreen(b, Col);
  }
  
  //delay_ms(ANIM_DELAY_3);
  
  as[AreaID].LastTickCount = TickCount;

  as[AreaID].NextCol--;
  if(as[AreaID].NextCol < 0)
    return(TRUE);
  else
    return(FALSE);
  
  #endif
}

void InitAnim6(unsigned char AreaID, TArea Area)
{
  as[AreaID].NextCol = (int) Area.y2 - Area.y1 + 1;
  as[AreaID].LastTickCount = TickCount;
}

unsigned char Anim6(unsigned char AreaID, TArea Area)
{
  //Ê—Êœ «“ Å«ÌÌ‰
  unsigned char Col;
  unsigned long b, c;
  
  if(MSElapsed(as[AreaID].LastTickCount) < ANIM_DELAY_3)
  {
    return(FALSE);
  }
  //if((TickCount - as[AreaID].LastTickCount) < ANIM_DELAY_3)
  //  return(FALSE);

  for(Col = Area.x1; Col <= Area.x2; Col++)
  {
    c = GetAnimData(Col, Area.y1, Area.y2);
    
    //c <<= Area.y1;
    c = ShiftBitsLeft(c, Area.y1, Area.y2, as[AreaID].NextCol);


    b = GetScreenData(Col, Area.y1, Area.y2);
    b |= c;
    
    StoreToScreen(b, Col);
  }
  
  //delay_ms(ANIM_DELAY_3);
  
  as[AreaID].LastTickCount = TickCount;

  as[AreaID].NextCol--;
  
  if(as[AreaID].NextCol < 0)
    return(TRUE);
  else
    return(FALSE);
}

void InitAnim7(unsigned char AreaID, TArea Area)
{
  #ifdef  _ANIM_7_ACTIVE_
  
  as[AreaID].NextCol = 0;
  
  #endif
}

unsigned char CalculateAnim7And8Delay(unsigned char AreaHeight)
{
  unsigned char res;
  
  if(AreaHeight <= 8)
    res = 8;
  else if(AreaHeight <= 16)
    res = 5;
  else if(AreaHeight <= 24)
    res = 4;
  else //if(AreaHeight <= 32)
    res = 4;
  
  return(res);
}

unsigned char Anim7(unsigned char AreaID, TArea Area)
{
  //Å—‘œ‰ »Â ’Ê—  „Ì·Â «Ì «“ Å«ÌÌ‰ «“ ”„  —«”  »Â çÅ
  #ifndef  _ANIM_7_ACTIVE_
  
    return(TRUE);  //This text effect is not available on Mega32 due to low memory space
    
  #else
  
  unsigned char Col;
  unsigned long b, c, c1;
  int shift_outside;
  unsigned char delay;
  
  //delay = (unsigned char) ( (float)((float) Area.y2 - Area.y1 + 1 - 16.0) * (float)(-ANIM_COL_BY_COL_DELAY) / 8.0 + (float)ANIM_COL_BY_COL_DELAY);
  delay = CalculateAnim7And8Delay(Area.y2 - Area.y1);
  
  Col = Area.x2 - as[AreaID].NextCol;
  
  b = GetAnimData(Col, Area.y1, Area.y2);
  c1 = b;
  
  if(c1 != 0)
  {
    for(shift_outside = (int) Area.y2 - Area.y1 + 1; shift_outside >= 0; shift_outside--)
    {
      c = ShiftBitsLeft(c1, Area.y1, Area.y2, shift_outside);
      
      b = GetScreenData(Col, Area.y1, Area.y2);
      b |= c;
      
      StoreToScreen(b, Col);
      
      delay_ms(delay);
    }
  }
  
  as[AreaID].NextCol++;
  if((Area.x2 - as[AreaID].NextCol) <= Area.x1)
    return(TRUE);
  else
    return(FALSE);
  
  #endif
}

void InitAnim8(unsigned char AreaID, TArea Area)
{
  #ifdef  _ANIM_8_ACTIVE_
  
  as[AreaID].NextCol = 0;
  as[AreaID].AnimStage = 0;
  
  #endif
}

unsigned char Anim8(unsigned char AreaID, TArea Area)
{
  //Å—‘œ‰ »’Ê—  „Ì·Â «Ì «“ »«·« Ê Å«ÌÌ‰ «“ ”„  —«”  »Â çÅ
  #ifndef  _ANIM_8_ACTIVE_
  
    return(TRUE);  //This text effect is not available on Mega32 due to low memory space
    
  #else
  
  unsigned char Col;
  unsigned long b, c, c1;
  int shift_outside;
  unsigned char delay;
  
  //delay = (unsigned char) ( (float)((float) Area.y2 - Area.y1 + 1 - 16.0) * (float)(-ANIM_COL_BY_COL_DELAY) / 8.0 + (float)ANIM_COL_BY_COL_DELAY);
  delay = CalculateAnim7And8Delay(Area.y2 - Area.y1);
  
  
  Col = Area.x2 - as[AreaID].NextCol;
  
  b = GetAnimData(Col, Area.y1, Area.y2);
  c1 = b;
  
  if(c1 != 0)
  {
    for(shift_outside = (int) Area.y2 - Area.y1 + 1; shift_outside >= 0; shift_outside--)
    {
      if(as[AreaID].AnimStage == 0)
        c = ShiftBitsLeft(c1, Area.y1, Area.y2, shift_outside);
      else
        c = ShiftBitsRight(c1, Area.y1, Area.y2, shift_outside);
      
      b = GetScreenData(Col, Area.y1, Area.y2);
      b |= c;
      
      StoreToScreen(b, Col);
      
      delay_ms(delay);
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
  
  #endif
}

void InitAnim9(unsigned char AreaID, TArea Area)
{
  #ifdef  _ANIM_9_ACTIVE_
  
  as[AreaID].NextCol = 0;
  as[AreaID].LastTickCount = TickCount;
  
  #endif
}

unsigned char Anim9(unsigned char AreaID, TArea Area)
{
  //Fill from top - Å— ‘œ‰ «“ »«·«
  #ifndef  _ANIM_9_ACTIVE_
  
    return(TRUE);  //This text effect is not available on Mega32 due to low memory space
    
  #else
  
  unsigned char Col;
  unsigned long b, c;
  unsigned long filter;
  
  if(MSElapsed(as[AreaID].LastTickCount) < ANIM_DELAY_3)
  {
    return(FALSE);
  }
  //if((TickCount - as[AreaID].LastTickCount) < ANIM_DELAY_3)
  //  return(FALSE);
  
  Col = Area.x1;

  #pragma warn-
  filter = ~(0xffffffff << (as[AreaID].NextCol + Area.y1));
  #pragma warn+
  
  for(; Col <= Area.x2; Col++)
  {
    b = GetAnimData(Col, Area.y1, Area.y2);
    
    c = b & filter;
    
    
    b = GetScreenData(Col, Area.y1, Area.y2);
    b |= c;
    
    StoreToScreen(b, Col);
  }
  
  //delay_ms(ANIM_DELAY_3);
  
  as[AreaID].LastTickCount = TickCount;

  as[AreaID].NextCol++;
  if(as[AreaID].NextCol >= (Area.y2 - Area.y1 + 1))
  {
    return(TRUE);
  }
  
  return(FALSE);
  
  #endif
}

void InitAnim10(unsigned char AreaID, TArea Area)
{
  #ifdef  _ANIM_10_ACTIVE_
  
  as[AreaID].NextCol = 0;
  as[AreaID].AnimStage = 0;  //AnimStage is used to implement a delay after the effect is done so that the viewer can see all the text upon completion of the effect
  
  #endif
}

unsigned char Anim10(unsigned char AreaID, TArea Area)
{
  //Å—‘œ‰ «“ ÿ—›Ì‰ »Â ”„  œ«Œ·
  #ifndef  _ANIM_10_ACTIVE_
  
    return(TRUE);  //This text effect is not available on Mega32 due to low memory space
    
  #else
  
  unsigned char Col, Col2;
  unsigned long b, c;
  
  if(as[AreaID].AnimStage == 0)
  {
    Col2 = Area.x1 + (Area.x2 - Area.x1 + 1) / 2 - as[AreaID].NextCol;
    for(Col = Area.x1; Col <= Area.x1 + as[AreaID].NextCol; Col++)
    {
      c = GetAnimData(Col2, Area.y1, Area.y2);
      
      b = GetScreenData(Col, Area.y1, Area.y2);
      b |= c;
      
      StoreToScreen(b, Col);
      
      Col2++;
    }
    
    Col2 = Area.x1 + (Area.x2 - Area.x1 + 1) / 2 + as[AreaID].NextCol;
    for(Col = Area.x2; Col >= Area.x2 - as[AreaID].NextCol; Col--)
    {
      c = GetAnimData(Col2, Area.y1, Area.y2);
      
      b = GetScreenData(Col, Area.y1, Area.y2);
      b |= c;
      
      StoreToScreen(b, Col);
      
      Col2--;
    }
    
    as[AreaID].NextCol++;
  }
  
  if(as[AreaID].NextCol > ((Area.x2 - Area.x1) / 2))
  {
    if(as[AreaID].AnimStage < 3)
      as[AreaID].AnimStage++;
    else
      return(TRUE);
  }
  return(FALSE);
  
  #endif
}

void InitAnim11(unsigned char AreaID, TArea Area)
{
  as[AreaID].NextCol = 0;
  as[AreaID].AnimStage = Area.x1;
}

unsigned char Anim11(unsigned char AreaID, TArea Area)
{
  //Å—‘œ‰ «“ çÅ »’Ê—  ‘Ì›   ò ” Ê‰Ì
  unsigned char Col, ColToScroll;
  unsigned long b, c;
  
  ColToScroll = Area.x2 - as[AreaID].NextCol;
    
  c = GetAnimData(ColToScroll, Area.y1, Area.y2);
    
  if(c == 0)  //Skip this column if empty
    as[AreaID].AnimStage = ColToScroll;
      
  //Clear old column
  if(as[AreaID].AnimStage > Area.x1)
  {
    Col = as[AreaID].AnimStage - 1;
    b = GetScreenData(Col, Area.y1, Area.y2);
    
    //c <<= Area.y1;
    //b |= c;  --> c == 0
    
    if(Col != ColToScroll)
    {
      StoreToScreen(b, Col);
    }
  }
  
  Col = as[AreaID].AnimStage;
//  for(Col = Area.x1; Col <= ColToScroll; Col++)
//  {
      b = GetScreenData(Col, Area.y1, Area.y2);
      //c <<= Area.y1;
      b |= c;
      
      StoreToScreen(b, Col);
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
  #ifdef  _ANIM_12_ACTIVE_
  
  as[AreaID].NextCol = 0;
  
  #endif
}

unsigned char Anim12(unsigned char AreaID, TArea Area)
{
  //Å—‘œ‰ «“ »«·« »Â ”„  çÅ Ê «“ Å«ÌÌ‰ »Â ”„  —«” 
  #ifndef  _ANIM_12_ACTIVE_
  
    return(TRUE);  //This text effect is not available on Mega32 due to low memory space
    
  #else
  
  unsigned char LeftCol, RightCol;
  unsigned long b, left_c, right_c;
  
  LeftCol = Area.x1 + as[AreaID].NextCol;
  RightCol = Area.x2 - as[AreaID].NextCol;
  
  b = GetAnimData(LeftCol, Area.y1, Area.y2);
  left_c = b;

  b = GetAnimData(RightCol, Area.y1, Area.y2);
  right_c = b;
      
  left_c &= AndBits(left_c, Area.y1, Area.y2 - (Area.y2 - Area.y1) / 2, 0);
  right_c &= AndBits(right_c, Area.y2 - (Area.y2 - Area.y1) / 2 + 1, Area.y2, 0);



  b = GetScreenData(LeftCol, Area.y1, Area.y2);
  //c <<= Area.y1;
  b |= left_c;
  
  /*
  //Don't use StoreToScreen here because we have |=
  Screen[0][LeftCol] |= b;
  Screen[1][LeftCol] |= b >> 8;
  #ifdef  _ROWS_24_
  Screen[2][LeftCol] |= b >> 16;
  #endif
  #ifdef  _ROWS_32_
  Screen[3][LeftCol] |= b >> 24;
  #endif
  */
  //unsigned long 
  StoreToScreen(LoadFromScreen(LeftCol) | b, LeftCol);



  b = GetScreenData(RightCol, Area.y1, Area.y2);
  //c <<= Area.y1;
  b |= right_c;
  
  /*
  //Don't use StoreToScreen here because we have |=
  Screen[0][RightCol] |= b;
  Screen[1][RightCol] |= b >> 8;
  #ifdef  _ROWS_24_
  Screen[2][RightCol] |= b >> 16;
  #endif
  #ifdef  _ROWS_32_
  Screen[3][RightCol] |= b >> 24;
  #endif
  */
  StoreToScreen(LoadFromScreen(RightCol) | b, RightCol);

  as[AreaID].NextCol++;
  if((as[AreaID].NextCol + Area.x1) > Area.x2)
  {
    return(TRUE);
  }
  return(FALSE);
  
  #endif
}

void InitAnim13(unsigned char AreaID, TArea Area)
{
  as[AreaID].NextCol = 0;
}

unsigned char Anim13(unsigned char AreaID, TArea Area)
{
  //Å—‘œ‰ «“ çÅ Ê —«”  »Â ÿ—› œ«Œ·
  unsigned char Col, Col2;
  unsigned long b, c;
  
  //Col2 = Area.x1 + (Area.x2 - Area.x1 + 1) / 2 - as[AreaID].NextCol;
  Col2 = Area.x1;
  for(Col = Area.x1; Col <= Area.x1 + as[AreaID].NextCol; Col++)
  {
  
    c = GetAnimData(Col2, Area.y1, Area.y2);
    
    b = GetScreenData(Col, Area.y1, Area.y2);
    //c <<= Area.y1;
    b |= c;
    
    StoreToScreen(b, Col);
    
    Col2++;
  }
  
  //Col2 = Area.x1 + (Area.x2 - Area.x1 + 1) / 2 + as[AreaID].NextCol;
  Col2 = Area.x2;
  for(Col = Area.x2; Col >= Area.x2 - as[AreaID].NextCol; Col--)
  {
    c = GetAnimData(Col2, Area.y1, Area.y2);
    
    b = GetScreenData(Col, Area.y1, Area.y2);
    //c <<= Area.y1;
    b |= c;
    
    StoreToScreen(b, Col);
    
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
  as[AreaID].LastTickCount = TickCount;
}

unsigned char Anim14(unsigned char AreaID, TArea Area)
{
  //Flash - Â‘  »«— ‰„«Ì‘ „⁄òÊ”
  unsigned char Col;
  unsigned long b, c;
  
  if(MSElapsed(as[AreaID].LastTickCount) < ANIM_BLINK_DELAY)
    return(FALSE);
  //if((TickCount - as[AreaID].LastTickCount) < ANIM_BLINK_DELAY)
  //  return(FALSE);

  for(Col = Area.x1; Col <= Area.x2; Col++)
  {
    
      //Get the data
      if(as[AreaID].AnimStage == 1)
      {
        c = GetAnimDataNOT(Col, Area.y1, Area.y2);
      }
      else
      {
        c = GetAnimData(Col, Area.y1, Area.y2);
      }

      //Now, put it on the screen
      b = GetScreenData(Col, Area.y1, Area.y2);
      //c <<= Area.y1;
      b |= c;
      
      StoreToScreen(b, Col);
  }
  
  if(as[AreaID].AnimStage == 0)
    as[AreaID].AnimStage = 1;
  else
    as[AreaID].AnimStage = 0;

  //delay_ms(ANIM_BLINK_DELAY);

  as[AreaID].LastTickCount = TickCount;

  as[AreaID].NextCol++;  //This variable is used to store the number of flash times.
  if(as[AreaID].NextCol == 17)  //Flash 8 time (= (int)(17 / 2)) times
  {
    return(TRUE);
  }
  return(FALSE);
}

void InitAnim15(unsigned char AreaID, TArea Area)
{
  as[AreaID].NextCol = 0;
  as[AreaID].AnimStage = 0;
}

void Anim15_PutColByCol2(unsigned char ScreenRightCol, unsigned char AnimRightCol, BOOL NotValues, TArea Area)
{
  unsigned long b, c;
  int col, col2;
  
  col2 = ScreenRightCol;
  for(col = AnimRightCol; col >= Area.x1; col--)
  {
    if(NotValues)
      c = GetAnimDataNOT(col, Area.y1, Area.y2);
    else
      c = GetAnimData(col, Area.y1, Area.y2);
    b = GetScreenData(col2, Area.y1, Area.y2);
    b |= c;
    
    StoreToScreen(b, col2);
    
    col2--;
    if(col2 < Area.x1)
      break;
    b = GetScreenData(col2, Area.y1, Area.y2);
    
    StoreToScreen(b, col2);
    
    col2--;
    if(col2 < Area.x1)
      break;
  }
}

void Anim15_PutColByCol1(unsigned char ScreenRightCol, unsigned char ScreenLeftCol, unsigned char AnimRightCol, BOOL NotValues, TArea Area)
{
  unsigned long b, c;
  int col, col2;
  
  col2 = ScreenRightCol;
  for(col = AnimRightCol; col >= Area.x1; col--)
  {
    if(NotValues)
      c = GetAnimDataNOT(col, Area.y1, Area.y2);
    else
      c = GetAnimData(col, Area.y1, Area.y2);
    b = GetScreenData(col2, Area.y1, Area.y2);
    b |= c;
    
    StoreToScreen(b, col2);
    
    col2--;
    if(col2 <= ScreenLeftCol)
      break;
  }
}

unsigned char Anim15(unsigned char AreaID, TArea Area)
{
  TSingleLineScrollingText slst;
  
  get_content_settings(AreaID, sizeof(TSingleLineScrollingText), (unsigned char *) &slst);  // ** Effects are only for text contents in this version ** //
  
  if(as[AreaID].AnimStage == 0)
  {
    Anim15_PutColByCol2(Area.x1 + as[AreaID].NextCol, Area.x2, !slst.Invert, Area);
    //Anim15_PutColByCol2(Area.x1 + as[AreaID].NextCol, Area.x2, FALSE, Area);
  }
  else
  {
    Anim15_PutColByCol1(Area.x2, Area.x2 - as[AreaID].NextCol, Area.x2, !slst.Invert, Area);
    Anim15_PutColByCol2(Area.x2 - as[AreaID].NextCol, Area.x2 - as[AreaID].NextCol, !slst.Invert, Area);
    //Anim15_PutColByCol1(Area.x2, Area.x2 - as[AreaID].NextCol, Area.x2, FALSE, Area);
    //Anim15_PutColByCol2(Area.x2 - as[AreaID].NextCol, Area.x2 - as[AreaID].NextCol, FALSE, Area);
  }
  
  as[AreaID].NextCol++;
  if(as[AreaID].AnimStage == 0)
  {
    if(as[AreaID].NextCol + Area.x1 > Area.x2)
    {
      as[AreaID].AnimStage = 1;
      as[AreaID].NextCol = 0;
    }
  }
  else if(as[AreaID].AnimStage == 1)
  {
    if(as[AreaID].NextCol + Area.x1 > Area.x2)
    {
      as[AreaID].AnimStage++;
      as[AreaID].NextCol--;
    }
  }
  else
  {
    //This section is used for delay
    as[AreaID].AnimStage++;
    if(as[AreaID].AnimStage == 5)
      return(TRUE);
    as[AreaID].NextCol--;
  }
  
  return(FALSE);
}

/*New Anim
void InitAnim16(unsigned char AreaID, TArea Area)
{
  as[AreaID].NextCol = 0;
}

unsigned char Anim16(unsigned char AreaID, TArea Area)
{
  unsigned long b, c;
  int col;
  unsigned char col2;
  
  col2 = Area.x1;
  for(col = as[AreaID].NextCol; col > 0; col--)
  {
    c = ~GetAnimData(Area.x2 - col, Area.y1, Area.y2);
    b = GetScreenData(col2, Area.y1, Area.y2);
    b |= c;
    
    StoreToScreen(b, col2);
    
    col2++;
  }
  
  as[AreaID].NextCol++;
  if(as[AreaID].NextCol + Area.x1 > Area.x2)
    return(TRUE);
  else
    return(FALSE);
  
  return(TRUE);
}
*/

#endif  //#ifdef  _TEXT_ANIMATIONS_ACTIVE_