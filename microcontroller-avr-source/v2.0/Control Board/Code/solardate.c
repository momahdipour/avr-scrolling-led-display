/* Solar Date Routines */

// the function check a miladiyear is leap or not.

unsigned char MiladiIsLeap(unsigned int miladiYear)
{
  if(((miladiYear % 100)!= 0 && (miladiYear % 4) == 0) || ((miladiYear % 100)== 0 && (miladiYear % 400) == 0))
    return 1;
  else
    return 0;
}

void MiladiToShamsi(unsigned int iMiladiYear, unsigned char iMiladiMonth, unsigned char iMiladiDay, unsigned int *SYear, unsigned char *SMonth, unsigned char *SDay)
{
  int shamsiDay, shamsiMonth, shamsiYear;
  int dayCount,farvardinDayDiff,deyDayDiff ;
  int sumDayMiladiMonth[] = {0,31,59,90,120,151,181,212,243,273,304,334};
  int sumDayMiladiMonthLeap[12]= {0,31,60,91,121,152,182,213,244,274,305,335};

  farvardinDayDiff=79;

  if (MiladiIsLeap(iMiladiYear))
  {
    dayCount = sumDayMiladiMonthLeap[iMiladiMonth-1] + iMiladiDay;
  }
  else
  {
    dayCount = sumDayMiladiMonth[iMiladiMonth-1] + iMiladiDay;
  }

  if((MiladiIsLeap(iMiladiYear - 1)))
  {
    deyDayDiff = 11;
  }
  else
  {
    deyDayDiff = 10;
  }

  if (dayCount > farvardinDayDiff)
  {
    dayCount = dayCount - farvardinDayDiff;
    if (dayCount <= 186)
    {
      switch (dayCount%31) {
        case 0:
                shamsiMonth = dayCount / 31;
                shamsiDay = 31;
                break;
        default:
                shamsiMonth = (dayCount / 31) + 1;
                shamsiDay = (dayCount%31);
                break;
    }
    shamsiYear = iMiladiYear - 621;
  }
  else
  {
    dayCount = dayCount - 186;
    switch (dayCount%30) {
      case 0:
              shamsiMonth = (dayCount / 30) + 6;
              shamsiDay = 30;
              break;
      default:
              shamsiMonth = (dayCount / 30) + 7;
              shamsiDay = (dayCount%30);
              break;
    }
    shamsiYear = iMiladiYear - 621;
  }
}
else
{
  dayCount = dayCount + deyDayDiff;
  switch (dayCount%30) {
    case 0 :
            shamsiMonth = (dayCount / 30) + 9;
            shamsiDay = 30;
            break;
    default:
            shamsiMonth = (dayCount / 30) + 10;
            shamsiDay = (dayCount%30);
            break;
  }
  shamsiYear = iMiladiYear - 622;
}

  *SYear = shamsiYear;
  *SMonth = shamsiMonth;
  *SDay = shamsiDay;
}

#ifdef  _DATE_TIME_ADJUST_BUTTONS_ACTIVE
void ShamsiToMiladi(unsigned int ShamsiYear, unsigned char ShamsiMonth, unsigned char ShamsiDay, unsigned int *MYear, unsigned char *MMonth, unsigned char *MDay)
{

int         iYear, iMonth, iDay;
int           marchDayDiff, remainDay;
int           dayCount, miladiYear, i;
 

// this buffer has day count of Miladi month from April to January for a none year.

unsigned char miladiMonth[12]  =  {30,31,30,31,31,30,31,30,31,31,28,31};
miladiYear = ShamsiYear + 621;

//Detemining the Farvardin the First

if(MiladiIsLeap(miladiYear))
{
//this is a Miladi leap year so Shamsi is leap too so the 1st of Farvardin is March 20 (3/20)
  marchDayDiff = 12;
}
else
{
//this is not a Miladi leap year so Shamsi is not leap too so the 1st of Farvardin is March 21 (3/21)
  marchDayDiff = 11;
}

// If next year is leap we will add one day to Feb.
if(MiladiIsLeap(miladiYear+1))
{
miladiMonth[10] = miladiMonth[10] + 1; //Adding one day to Feb
}

//Calculate the day count for input shamsi date from 1st Farvadin

if((ShamsiMonth>=1)&&( ShamsiMonth<=6))
 dayCount = (((int) ShamsiMonth-1) * 31) + ShamsiDay;
else
 dayCount =(6 * 31) + (((int) ShamsiMonth - 7) * 30) + ShamsiDay;

//Finding the correspond miladi month and day

if (dayCount <= marchDayDiff) //So we are in 20(for leap year) or 21for none leap year) to 31 march
{
 iDay = dayCount + (31 - marchDayDiff);
 iMonth = 3;
 iYear=miladiYear;
}
else 

{
 remainDay = dayCount - marchDayDiff;


  i = 0; //starting from April

while ((remainDay > miladiMonth[i]))
{
 remainDay = remainDay - (int) miladiMonth[i];
 i++;
}
 iDay = remainDay;

if (i > 8) // We are in the next Miladi Year
{
 iMonth = i - 8;
 iYear =  miladiYear + 1;
}
else
{
 iMonth = i + 4;
 iYear =  miladiYear;
 }

}

 *MYear = iYear;
 *MMonth = iMonth;
 *MDay = iDay;
}
#endif
