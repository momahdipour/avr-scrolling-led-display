//Page effects

#ifdef  _PAGE_EFFECTS_ACTIVE_

#define   SINGLE_VERTICAL_PAGE_EFFECT_DELAY   15  //in milliseconds
#define   DOUBLE_VERTICAL_PAGE_EFFECT_DELAY   (SINGLE_VERTICAL_PAGE_EFFECT_DELAY * 2)  //in milliseconds

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
/*
BOOL PageEffect9();
void InitPageEffect9();
BOOL PageEffect10();
void InitPageEffect10();
*/

#endif

BOOL ApplyStageEffect(unsigned char PageEffectID)
{
#ifndef  _PAGE_EFFECTS_ACTIVE_
  return(TRUE);
#else
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
    /*
    case 9:
      return(PageEffect9());
      break;
    case 10:
      return(PageEffect10());
      break;
    */
    default:
      return(TRUE);  //Undefied page effects must be returned successfully
  }
#endif
}

void InitPageEffect(unsigned char PageEffectID)
{
#ifdef  _PAGE_EFFECTS_ACTIVE_
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
    /*
    case 9:
      InitPageEffect9();
      break;
    case 10:
      InitPageEffect10();
      break;
    */
    default:
      ;
  }
#endif
}


//Effects

#ifdef  _PAGE_EFFECTS_ACTIVE_

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
    StoreToScreen(0, Col);
  }
  
  for(Col = pes.NextCol; Col < COL_COUNT; Col++)
  {
    StoreToScreen(0xffffffff, Col);
  }
  
  pes.NextCol++;
  if(pes.NextCol > COL_COUNT)
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
  int Col;
  
  for(Col = COL_COUNT - 1; Col > COL_COUNT - pes.NextCol; Col--)
  {
    StoreToScreen(0, Col);
  }
  
  for(Col = 0; Col < COL_COUNT - pes.NextCol; Col++)
  {
    StoreToScreen(0xffffffff, Col);
  }
  
  pes.NextCol++;
  if(pes.NextCol > COL_COUNT)
  {
    StoreToScreen(0, 0);
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
  unsigned long v = 0xffffffff;
  unsigned char Col;
  
  
  if(bottom_to_top)
    v >>= (NextCol + 32 - ROW_COUNT);
  else
    v <<= NextCol;
  
  
  for(Col = 0; Col < COL_COUNT; Col++)
  {
    StoreToScreen(v, Col);
  }
}

BOOL PageEffect3()
{
  //Empty from top to bottom
  VerticalEmpty(FALSE, pes.NextCol);
  delay_ms(SINGLE_VERTICAL_PAGE_EFFECT_DELAY);
  
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
  delay_ms(SINGLE_VERTICAL_PAGE_EFFECT_DELAY);
  
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
    StoreToScreen(0, (int) Col - i);
    
    StoreToScreen(0, (int) Col + i);
  }
  
  for(Col = 0; Col < (COL_COUNT / 2 - pes.NextCol); Col++)
  {
    StoreToScreen(0xffffffff, Col);
    
    StoreToScreen(0xffffffff, COL_COUNT - Col - 1);
  }
  
  pes.NextCol++;
  if(pes.NextCol > (COL_COUNT / 2))
  {
    StoreToScreen(0, COL_COUNT - 1);  //To ensure the page is completely cleared
    
    StoreToScreen(0, 0);
    
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
    StoreToScreen(0, Col);
    
    StoreToScreen(0, COL_COUNT - Col - 1);
  }
  
  for(Col = pes.NextCol; Col < (COL_COUNT - pes.NextCol); Col++)
  {
    StoreToScreen(0xffffffff, Col);
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
  unsigned long v;
  unsigned char Col;
  
  v = NotBits(0xffffffff, ROW_COUNT / 2 - pes.NextCol, ROW_COUNT / 2 + pes.NextCol - 1);  //No matter if (ROW_COUNT / 2 + pes.NextCol - 1) becomes lower than (ROW_COUNT / 2 - pes.NextCol), because it is handled by the NotBits function
  
  for(Col = 0; Col < COL_COUNT; Col++)
  {
    StoreToScreen(v, Col);
  }
  
  delay_ms(DOUBLE_VERTICAL_PAGE_EFFECT_DELAY);
  
  pes.NextCol++;
  if(pes.NextCol > (ROW_COUNT / 2))
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
  //Vertical from bottom and top toward center
  unsigned long v = 0xffffffff;
  unsigned char Col;
  
  if(pes.NextCol > 0)
  {
    v = NotBits(v, 0, pes.NextCol - 1);
    v = NotBits(v, ROW_COUNT - pes.NextCol, ROW_COUNT - 1);
  }
  
  for(Col = 0; Col < COL_COUNT; Col++)
  {
    StoreToScreen(v, Col);
  }
  
  delay_ms(DOUBLE_VERTICAL_PAGE_EFFECT_DELAY);
  
  pes.NextCol++;
  if(pes.NextCol > ROW_COUNT / 2)
  {
    return(TRUE);
  }

  return(FALSE);
}

/*
void InitPageEffect9()
{
  pes.NextCol = 0;
}

BOOL PageEffect9()
{
  return(TRUE);
}

void InitPageEffect10()
{
}

BOOL PageEffect10()
{
  return(TRUE);
}
*/

#endif