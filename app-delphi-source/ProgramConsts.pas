unit ProgramConsts;

interface

uses
  GlobalTypes;

const
  //**TO CHANGE DEFAULT CONTENT TYPE FOR THE AREAS OF NEW STAGES, MODIFY THE CORRISPONDING LINE
  //   IN THE NewStage FUNCTION

  //TEMPERATURE_PREVIEW_SAMPLE_VALUE = 00;  --> Not used

  {$INCLUDE ConfigSize.inc}

  DEFAULT_SWF_SENSITIVITY = 140;
  NORMAL_SPEED_VALUE = 128;  //0 TO 255 (SLOW, MEDIUM, FAST, VERY FAST) -> SEE ALSO TMainForm.SpeedIndexToSpeedValue(SpeedIndex: Integer): Integer;

  BYTES_PER_ALARM = 12;  // --> this value must be equal to sizeof(TLDCAlarm) in the microcontroller program

  TEMPORARY_FILES_PREFIX = 'tmps';

  TIME_SETTING_COMPENSATION_VALUE = 2;  //in seconds - This value is added to the second when settings LED Display time to the system time

  NUMBER_OF_TIMES_TO_SET_TIME_AND_DATE = 2;  //It is better to set time and date multiple times to ensure communication with the LED Display is established corectly and time/date is set correctly.
  NUMBER_OF_TIMES_TO_SET_OFF_TIME = 2;

  MAX_STAGE_COUNT = 254;

  DEFAULT_LED_DISPLAY_ALARM_COUNT = 31;  //Default number of alarms on the LED Display
  MAX_LED_DISPLAY_ALARM_COUNT = 254;  //By changing this value, the value of MaxValue property of AlarmCountSpin in the ChangeDisplaySettingsForm is set automatically at application startup, so there is no need to set it manually
  DEFAULT_LED_DISPLAY_ALARM_SYSTEM = as1MonthAlarmSystem;

  //USART communication bytes
  WRITE_SUCCESSFUL = '@';
  WRITE_FAIL       = '!';

  //====================================================================
  //LED DISPLAY MEMORY SETTINGS
  LED_DISPLAY_SELECTABLE_MEMORIES: array[1..13] of Integer = (  //in KBs
    8, 12, 16, 20, 24, 32, 40, 48, 64, 96, 128, 192, 256
    );
  LED_DISPLAY_MINIMUM_MEMORY = 4;  //at least LED_DISPLAY_MEM_START_OFFSET bytes  --  in KBs
  LED_DISPLAY_MAXIMUM_MEMORY = 256;  //256KB  --  in KBs
  //====================================================================

  DATA_WRITE_DELAY = 150;  //in milliseconds
  ALARM_DATA_WRITE_DELAY = 4;  //in milliseconds - No need to sleep a long time

  { USART }
  USART_TIMEOUT_1 = 4000;  //Better to be graeter than the original value
  USART_TIMEOUT_2 = 2500;  //Better to be graeter than the original value
  MAX_USART_TRY_COUNT = 3;

  LED_DISPLAY_CHANGE_WAIT = 4000;  //Time to wait for the LED Display to process received data (in milliseconds)

  //LED Display limits
  //Dimensions
  LED_DISPLAY_SELECTABLE_ROW_COUNTS: array[1..13] of Integer = (
    8, 10, 12, 14, 16, 18, 20, 22, 24, 26, 28, 30, 32
    );

  LED_DISPLAY_SELECTABLE_COL_COUNTS: array[1..16] of Integer = (
    8, 16, 24, 32, 40, 48, 56, 64, 72, 80, 88, 96, 104, 112, 120, 128
    );

  MINIMUM_COL_COUNT = 8;
  MAXIMUM_COL_COUNT = 128;
  COL_COUNT_MULTIPLE_OF = 8;  //Column count of the LED Display must be a multiple of 8 columns - Set to 1 to disable this limitation (like ROW_COUNT_MULTIPLE_OF)
  MINIMUM_ROW_COUNT = 4;
  MAXIMUM_ROW_COUNT = 32;
  ROW_COUNT_MULTIPLE_OF = 1;  //1 means no limitation

  { Main Application }

  //Version number
  {$IFDEF FULL_BRIGHT}
  MAJOR_VERSION_NUMBER = 1;
  MAJOR_VERSION_NUMBER_STR = '1';  //--> If changed, also must be changed in the license units and the LCDConsts unit of LFG4LDC
  MINOR_VERSION_NUMBER = 0;
  MINOR_VERSION_NUMBER_STR = '0';  //--> If changed, also must be changed in the license units and the LCDConsts unit of LFG4LDC
  {$ENDIF}
  {$IFDEF NORMAL_MODEL}
  MAJOR_VERSION_NUMBER = 1;
  MAJOR_VERSION_NUMBER_STR = '1';  //--> If changed, also must be changed in the license units and the LCDConsts unit of LFG4LDC
  MINOR_VERSION_NUMBER = 5;
  MINOR_VERSION_NUMBER_STR = '5';  //--> If changed, also must be changed in the license units and the LCDConsts unit of LFG4LDC
  {$ENDIF}

  MAJOR_VERSION_NUMBER_STR_FOR_LICENSE = '1';  //--> If changed, also must be changed in the license units and the LCDConsts unit of LFG4LDC
  MINOR_VERSION_NUMBER_STR_FOR_LICENSE = '0';  //--> If changed, also must be changed in the license units and the LCDConsts unit of LFG4LDC

  //Firmware Version that this program supports
  {$IFDEF FULL_BRIGHT}
  FirmwareVersion_Major = '3';
  FirmwareVersion_Minor = '0';
  {$ENDIF}
  {$IFDEF NORMAL_MODEL}
  FirmwareVersion_Major = '1';
  FirmwareVersion_Minor = '5';
  {$ENDIF}

  {LDC File Info}
  LDC_FILE_MAJOR_VERSION_NUMBER_STR = '01';
  LDC_FILE_MINOR_VERSION_NUMBER_STR = '50';
  LDC_FILE_SIGNATURE = ('LDC' + LDC_FILE_MAJOR_VERSION_NUMBER_STR + '.' + LDC_FILE_MINOR_VERSION_NUMBER_STR);
  LDC_ALARM_FILE_SIGNATURE = ('LDCALARM' + LDC_FILE_MAJOR_VERSION_NUMBER_STR + '.' + LDC_FILE_MINOR_VERSION_NUMBER_STR);

  //LFG Version number
  LFG_MAJOR_VERSION_NUMBER = 2;
  LFG_MAJOR_VERSION_NUMBER_STR = '2';
  LFG_MINOR_VERSION_NUMBER = 0;
  LFG_MINOR_VERSION_NUMBER_STR = '0';

  LFG_SOFTWARE_NAME = 'LED Font Generator';
  {$IFDEF FULL_BRIGHT}
  SOFTWARE_NAME = 'LED Display Control Software SunLight';  //--> If changed, also must be changed in the license units and the LCDConsts unit of LFG4LDC
  {$ENDIF}
  {$IFDEF NORMAL_MODEL}
  SOFTWARE_NAME = 'LED Display Control Software';  //--> If changed, also must be changed in the license units and the LCDConsts unit of LFG4LDC
  {$ENDIF}
  APPLICATION_STATIC_CAPTION = SOFTWARE_NAME + ' ' + MAJOR_VERSION_NUMBER_STR + '.' + MINOR_VERSION_NUMBER_STR;
  APPLICATION_EXE_FILE_NAME = 'LEDDisplayControl.exe';
  UNTITLED_DOCUMENT_NAME = 'Presentation';
  ///////////////

  //Registry paths
  REG_USER_SETTINGS_PATH = ('Software\' + SOFTWARE_NAME + '\' + MAJOR_VERSION_NUMBER_STR + '.' + MINOR_VERSION_NUMBER_STR);
  LFG_REG_USER_SETTINGS_PATH = ('Software\' + SOFTWARE_NAME + '\' + MAJOR_VERSION_NUMBER_STR + '.' + MINOR_VERSION_NUMBER_STR + '\' + LFG_SOFTWARE_NAME + '\' + LFG_MAJOR_VERSION_NUMBER_STR + '.' + LFG_MINOR_VERSION_NUMBER_STR);

  //Web urls
  SOFTWARE_HOME_PAGE_NEW = 'http://www.noorsun-em.com';
  SOFTWARE_HOME_PAGE_OLD = 'http://www.lcddesigner.com';
  SOFTWARE_REGISTRATION_PAGE = 'http://www.noorsun-em.com';
  SOFTWARE_DEFAULT_UPDATE_URL = 'http://www.noorsun-em.com/updates';
  SOFTWARE_WEBSITE_ROOT_URL = 'localhost';  //'www.noorsun-em.com';

  COMPANY_IMAGE_FILENAME = 'Data\CompanyImage000.bmp';

implementation

end.
