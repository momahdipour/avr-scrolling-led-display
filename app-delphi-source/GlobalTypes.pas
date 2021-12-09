unit GlobalTypes;

interface

uses
  Controls, sPanel, sStagePanel, Graphics, Classes, Types;

const
  MAX_AREA_COUNT = 4;

  DISPLAY_SETTINGS_RESERVED_BYTES_COUNT = 15;
  AREA_RESERVED_BYTES_COUNT = 30;
  STAGE_RESERVED_BYTES_COUNT = 15;
  ALARM_RESERVED_BYTES_COUNT = 6;

type
  TSWFInfo = record
    FrameCount: Integer;
    FrameRate: Byte;
    Width: Integer;
    Height: Integer;
  end;

  TApplicationState = (asLoading,  //Application is loading and creating the forms
                       asTerminating  //Application is about to terminate and the main form close is pending
                      );

  TWaitState = (wsGeneratingData);  //wsGeneratingData: when GenerateAllData is called

  //HighGUI
  THighGUIItem = record
    Item: TComponent;
  end;
  THighGUIItems = array of TComponent;

  TSoundOptions = record
    LEDDisplayDataChangeFinishedSoundFileName: WideString;
  end;

  TSoundItem = (siLEDDisplayDataChangeFinished);
  TAlarmSystem = (as1MonthAlarmSystem, as12MonthAlarmSystem);

  TLEDDisplayConfiguration = record
    FirmwareVersionMajorNumberChar: Char;
    FirmwareVersionMinorNumberChar: Char;

    EEPROMICCount: Integer;
    EEPROMICSize: Word;

    ClearOldMemoryData: Boolean;

    MaxRowCount, MaxColCount: Integer;
    RowCount, ColCount: Integer;

    RefreshRateOCR0_VALUE: Byte;

    ColumnsNOTInRefresh: Boolean;
    RowsNOTInRefresh: Boolean;

    TrialLimit: Word;
    TrialTimesLeft: Word;

    TemperatureOffset: Smallint;

    OVERALL_SPEED_SETTING: Integer;

    MaxAlarmCountPerMonth: Integer;
    AlarmSystem: TAlarmSystem;

    SCROLL_STEP_ADJUST: Integer;

    LED_DISPLAY_MAX_ROW_COUNT: Integer;
    LED_DISPLAY_MAX_COL_COUNT: Integer;

    DEFAULT_ALARM_CHEK_COUNTER: Integer;

    MAX_EEPROM_IC_PAGE_SIZE: Integer;

    EEPROM_WRITE_DELAY: Integer;

    MAX_CONTENT_SETTINGS_SIZE: Integer;

    TimeActive: Boolean;
    DateActive: Boolean;
    ScrollingTextActive: Boolean;
    AnimationActive: Boolean;
    TemperatureActive: Boolean;
    TextAnimationsActive: Boolean;
    PageEffectsActive: Boolean;
    StageLayoutActive: Boolean;
    TimeSpanActive: Boolean;
    AlarmActive: Boolean;
    _COLOR_DISPLAY_METHOD_1_: Boolean;
    _COLOR_DISPLAY_METHOD_2_: Boolean;
    _ROWS_24_: Boolean;
    _ROWS_32_: Boolean;
    TrialLimitActive: Boolean;
    PortableMemory: Boolean;
  end;

  TLEDDisplaySettings = record  //***IMPORTANT: If this record is changed, also TLEDDisplaySettingsForFile must be updated.
    Height, Width: Integer;
    Memory: Integer;  //in KBs
    ColorCount: Integer;
    Color1: WideString;
    Color2: WideString;

    CanShowDateTime: Boolean;
    CanShowTemperature: Boolean;
    CanShowScrollingText: Boolean;
    CanShowPicture: Boolean;
    CanShowAnimation: Boolean;
    CanShowTextEffects: Boolean;
    CanShowPageEffects: Boolean;
    CanChangePageLayout: Boolean;
    CanSetAlarms: Boolean;
    CanSetTimeSpan: Boolean;
    CanShowSWFFiles: Boolean;

    AlarmCount: Integer;
    AlarmSystem: TAlarmSystem;

    //Reserved bytes - set to 0 for compatibility
    ReservedBytes: array[1..DISPLAY_SETTINGS_RESERVED_BYTES_COUNT] of Byte;
  end;
  TLEDDisplaySettingsForFile = record
    Height, Width: Integer;
    Memory: Integer;  //in KBs
    ColorCount: Integer;
    //Color1: WideString;
    //Color2: WideString;

    CanShowDateTime: Boolean;
    CanShowTemperature: Boolean;
    CanShowScrollingText: Boolean;
    CanShowPicture: Boolean;
    CanShowAnimation: Boolean;
    CanShowTextEffects: Boolean;
    CanShowPageEffects: Boolean;
    CanChangePageLayout: Boolean;
    CanSetAlarms: Boolean;
    CanSetTimeSpan: Boolean;
    CanShowSWFFiles: Boolean;

    AlarmCount: Integer;
    AlarmSystem: TAlarmSystem;

    //Reserved bytes - set to 0 for compatibility
    ReservedBytes: array[1..DISPLAY_SETTINGS_RESERVED_BYTES_COUNT] of Byte;
  end;

  TDataArray = array of Byte;
  TLanguage = (laEnglish, laFarsi, laMixed);
  TTimingStyle = (tsRepeatNTimes, tsExactTiming);
  TContentType = (ctTime, ctDate, ctScrollingText, ctAnimation,
                  {ctPageEffect, }ctPicture {Scroll if big}, ctTemperature, ctEmpty, ctSWF);//, ctScrollingPicture);

  TTextType = (ttSimpleText, ttAdvancedText);
  TPictureSource = (psDirect, psLFGFile);

  TContentControl = record
    Button: TControl;
    OptionsPage: TsPanel;
    DefaultControl: TWinControl;
    OriginalPositionInRightPanel: TPoint;
  end;

  TLDCAlarm = record
    AlarmIndexOnTheLEDDisplay: Integer;  //This value only is used in the program and in run-time and is not used at all when saving alarms to file or loading alarms from file
    EveryDay: Boolean;
    Day, Month, Year: Integer;
    Hour, Minute, Second: Integer;
    Duration: Integer;
    //Reserved bytes - set to 0 for compatibility
    ReservedBytes: array[1..ALARM_RESERVED_BYTES_COUNT] of Byte;
  end;

  TLDCAlarms = array of TLDCAlarm;

  TLCDGIFAnimation = record
    Description: WideString;
    FileName: WideString;
  end;

  TLCDGIFAnimations = array of TLCDGIFAnimation;

  TDefaultPicture = record
    Description: WideString;
    FileName: WideString;
  end;

  TDefaultPictures = array of TDefaultPicture;

  TLCDFont = record
    Language: TLanguage;
    Path: WideString;
    PreviewImageFileName: String;
    Name: WideString;
  end;
  TLCDFontList = array of TLCDFont;

  TFontSettings = record
    Name: String[255];
    Size: Integer;
    Height: Integer;
    Pitch: TFontPitch;
    Color: TColor;
    Style: TFontStyles;
    Charset: TFontCharset;
  end;

  TFontType = (ftSystemFont, ftLCDFont);
  TAreaFontSettings = record
    FontType: TFontType;
    FarsiLCDFontName: WideString;
    EnglishLCDFontName: WideString;
    SystemFontSettings: TFontSettings;
  end;
  TAreaFontSettingsForFile = record
    FontType: TFontType;
    //FarsiLCDFontName: WideString;
    //EnglishLCDFontName: WideString;
    SystemFontSettings: TFontSettings;
  end;

  //TAreaStaticInfo is the information that need time to be calculate again and it is better to store it in memory until it is changed
  //for example, we store number of frames of a swf movie that has been loaded
  TAreaStaticInfo = record
    //InfoValid: Boolean;  No need to this //Determines if the information stored in the swtruct is valid and can be used
    SWFFrameWidth: Integer;
    SWFFrameHeight: Integer;
    SWFFrameCount: Integer;
    SWFInfoValid: Boolean;
  end;

  TAreaSizeChanging = (scHorizontal, scVertical, scNone);
  TArea = record
    StaticInfo: TAreaStaticInfo;
    
    x1, y1, x2, y2: Integer;
    SizeChangingMode: TAreaSizeChanging;

    DelayTime: Integer;
    ContinuesToNextStage: Boolean;
    AdvanceStageWhenDone: Boolean;
    ForceAdvanceStageWhenDone: Boolean;
    CompleteBeforeNextStage: Boolean;
    RepeatAfterDone: Boolean;

    Color: Integer;  //ItemIndex of the color selection combobox

    //Animation
    //EntranceAnimID: Integer;
    //MiddleAnimID: Integer;
    //ExitAnimID: Integer;

    //Texts are not allowed in varinat records
    ScrollingText: WideString;
    ScrollingTextFontSettings: TAreaFontSettings;
    ScrollingTextLFGFileName: WideString;

    PictureAvailable: Boolean;
    PictureBitmap: TBitmap;
    PictureLFGFileName: WideString;

    SWFData: TMemoryStream;

    AnimationName: WideString;

    AnimSpeed: Integer;  //0(very fast) to 255(very slow)

    TopBorder, BottomBorder, LeftBorder, RightBorder: Boolean;
    BorderWidthHorizontal, BorderWidthVertical: Integer;
    BordersFilled: Boolean;

    //---------------------------------------------------------
    //---------------------------------------------------------
    //Reserved bytes - set to 0 for compatibility
    //Although these bytes must be at the end of the record, but because this is a variant-parted record, we cannot do so.
    //  Also by adding these reserved bytes to one of the variant parts of the record (or ll parts of it), it is possible to data loss when we set it to 0. 
    ReservedBytes: array[1..AREA_RESERVED_BYTES_COUNT] of Byte;
    //---------------------------------------------------------
    //---------------------------------------------------------

    //Content
    case ContentType: TContentType of
      ctTime: (
        TimeLanguage: TLanguage;  //0 = Farsi, 1 = English
        ClockFormat: Integer;  //0 = hh:mm:ss, 1 = hh:mm
        ClockType: Integer;  //0 = 24-Hour, 1 = 12-Hour
        ClockTotalDisplayTime: Integer;  //in seconds
        PutClockAtCenter: Boolean;
        ClockDotsBlink: Boolean;
        );
      ctDate: (
        DateLanguage: TLanguage;
        DateFormat: Integer;  //0 = 1387/01/01, 1 = 87/01/01, 2 = 1387-01-01, 3 = 87-01-01, 4 = Separately display (month and day, year) with '/', 5 = same as 4 with '-'
        DateType: Integer;  //0 = Solar, 1 = Gregorian
        DateTotalDisplayTime: Integer;  //in seconds
        PutDateAtCenter: Boolean;
        );
      ctScrollingText: (
        FixedText: Boolean;  //Is this a scrolling text or a fixed text?
        TextLanguage: TLanguage;
        //TextBiDiMode: TBiDiMode;
        TextDirection: Integer;  //0 = Right, 1 = Left
        TextScrollType: Integer;  //0 = Text scrolls into the display area (normal), 1 = Text is displayed first
        TextScrollSpeed: Integer;  //Combobox ItemIndex: 0 = Very Slow, 1 = Slow, 2 = Medium, 3 = Fast, 4 = Very Fast
        InvertScrollingText: Boolean;
        TextEntranceAnimID: Integer;

        TextTimingStyle: TTimingStyle;
        TextRepetitionTimes: Integer;
        TextTotalDisplayTime: Integer;

        ScrollingTextType: TTextType;

        SystemFontFromFavoriteFonts: Boolean;  //Must not be used to check if the presentation is changed
        //ScrollingTextLFGFileName
        //-> ScrollingText
        );
      ctSWF: (
        SWFPlaySpeed: Integer;
        SWFTimingStyle: TTimingStyle;
        SWFRepetitionTimes: Integer;
        SWFTotalDisplayTime: Integer;
        InvertSWF: Boolean;
        PutSWFAtCenter: Boolean;
        UseSWFTimings: Boolean;
        SWFSensitivity: Integer;  //from 0 to 255
        );
      ctAnimation: (
        AnimationIndex: Integer;  //Not used anymore - use AnimationName instead
        AnimationPlaySpeed: Integer;
        AnimationTimingStyle: TTimingStyle;
        AnimationRepetitionTimes: Integer;
        AnimationTotalDisplayTime: Integer;
        InvertAnimation: Boolean;
        PutAnimationAtCenter: Boolean;
        UseGIFTimings: Boolean;
        );
      ctPicture: (
        ScrollingPicture: Boolean;

        PictureTimingStyle: TTimingStyle;
        PictureRepetitionTimes: Integer;
        PictureTotalDisplayTime: Integer;

        InvertPicture: Boolean;
        PictureEntranceAnimID: Integer;

        PictureTextDirection: Integer;  //0 = Right, 1 = Left
        PictureTextScrollType: Integer;  //0 = Text scrolls into the display area (normal), 1 = Text is displayed first
        PictureTextScrollSpeed: Integer;  //Combobox ItemIndex: 0 = Very Slow, 1 = Slow, 2 = Medium, 3 = Fast, 4 = Very Fast

        PictureSource: TPictureSource;
        //PictureLFGFileName
        );
      ctTemperature: (
        TemperatureLanguage: TLanguage;  //0 = Farsi, 1 = English
        TemperatureUnit: Integer;  //0 = Centigrade, 1 = Fahrenheit
        TemperatureTotalDisplayTime: Integer;  //in seconds
        PutTemperatureAtCenter: Boolean;
        );
      ctEmpty: (
        EmptyAreaFilled: Boolean;
        EmptyAreaTotalDisplayTime: Integer;  //in seconds
        );
  end;

  TAreaForFile = record
    //StaticInfo: TAreaStaticInfo;

    x1, y1, x2, y2: Integer;
    SizeChangingMode: TAreaSizeChanging;

    DelayTime: Integer;
    ContinuesToNextStage: Boolean;
    AdvanceStageWhenDone: Boolean;
    ForceAdvanceStageWhenDone: Boolean;
    CompleteBeforeNextStage: Boolean;
    RepeatAfterDone: Boolean;

    Color: Integer;  //ItemIndex of the color selection combobox

    //Animation
    //EntranceAnimID: Integer;
    //MiddleAnimID: Integer;
    //ExitAnimID: Integer;

    //Texts are not allowed in varinat records
    //ScrollingText: WideString;
    ScrollingTextFontSettings: TAreaFontSettingsForFile;
    //ScrollingTextLFGFileName: WideString;

    PictureAvailable: Boolean;
    PictureBitmap: TBitmap;
    //PictureLFGFileName: WideString;

    SWFData: TMemoryStream;

    //AnimationName: WideString;

    AnimSpeed: Integer;  //0(very fast) to 255(very slow)

    TopBorder, BottomBorder, LeftBorder, RightBorder: Boolean;
    BorderWidthHorizontal, BorderWidthVertical: Integer;
    BordersFilled: Boolean;

    //---------------------------------------------------------
    //---------------------------------------------------------
    //Reserved bytes - set to 0 for compatibility
    //Although these bytes must be at the end of the record, but because this is a variant-parted record, we cannot do so.
    //  Also by adding these reserved bytes to one of the variant parts of the record (or ll parts of it), it is possible to data loss when we set it to 0. 
    ReservedBytes: array[1..AREA_RESERVED_BYTES_COUNT] of Byte;
    //---------------------------------------------------------
    //---------------------------------------------------------

    //Content
    case ContentType: TContentType of
      ctTime: (
        TimeLanguage: TLanguage;  //0 = Farsi, 1 = English
        ClockFormat: Integer;  //0 = hh:mm:ss, 1 = hh:mm
        ClockType: Integer;  //0 = 24-Hour, 1 = 12-Hour
        ClockTotalDisplayTime: Integer;  //in seconds
        PutClockAtCenter: Boolean;
        ClockDotsBlink: Boolean;
        );
      ctDate: (
        DateLanguage: TLanguage;
        DateFormat: Integer;  //0 = 1387/01/01, 1 = 87/01/01, 2 = 1387-01-01, 3 = 87-01-01, 4 = Separately display (month and day, year) with '/', 5 = same as 4 with '-'
        DateType: Integer;  //0 = Solar, 1 = Gregorian
        DateTotalDisplayTime: Integer;  //in seconds
        PutDateAtCenter: Boolean;
        );
      ctScrollingText: (
        FixedText: Boolean;  //Is this a scrolling text or a fixed text?
        TextLanguage: TLanguage;
        //TextBiDiMode: TBiDiMode;
        TextDirection: Integer;  //0 = Right, 1 = Left
        TextScrollType: Integer;  //0 = Text scrolls into the display area (normal), 1 = Text is displayed first
        TextScrollSpeed: Integer;  //Combobox ItemIndex: 0 = Very Slow, 1 = Slow, 2 = Medium, 3 = Fast, 4 = Very Fast
        InvertScrollingText: Boolean;
        TextEntranceAnimID: Integer;

        TextTimingStyle: TTimingStyle;
        TextRepetitionTimes: Integer;
        TextTotalDisplayTime: Integer;

        ScrollingTextType: TTextType;
        //ScrollingTextLFGFileName
        //-> ScrollingText

        SystemFontFromFavoriteFonts: Boolean;  //Must not be used to check if the presentation is changed
        );
      ctSWF: (
        SWFPlaySpeed: Integer;
        SWFTimingStyle: TTimingStyle;
        SWFRepetitionTimes: Integer;
        SWFTotalDisplayTime: Integer;
        InvertSWF: Boolean;
        PutSWFAtCenter: Boolean;
        UseSWFTimings: Boolean;
        SWFSensitivity: Integer;  //from 0 to 255
        );
      ctAnimation: (
        AnimationIndex: Integer;
        AnimationPlaySpeed: Integer;
        AnimationTimingStyle: TTimingStyle;
        AnimationRepetitionTimes: Integer;
        AnimationTotalDisplayTime: Integer;
        InvertAnimation: Boolean;
        PutAnimationAtCenter: Boolean;
        UseGIFTimings: Boolean;
        );
      ctPicture: (
        ScrollingPicture: Boolean;

        PictureTimingStyle: TTimingStyle;
        PictureRepetitionTimes: Integer;
        PictureTotalDisplayTime: Integer;

        InvertPicture: Boolean;
        PictureEntranceAnimID: Integer;

        PictureTextDirection: Integer;
        PictureTextScrollType: Integer;
        PictureTextScrollSpeed: Integer;

        PictureSource: TPictureSource;
        //PictureLFGFileName
        );
      ctTemperature: (
        TemperatureLanguage: TLanguage;  //0 = Farsi, 1 = English
        TemperatureUnit: Integer;  //0 = Centigrade, 1 = Fahrenheit
        TemperatureTotalDisplayTime: Integer;  //in seconds
        PutTemperatureAtCenter: Boolean;
        );
      ctEmpty: (
        EmptyAreaFilled: Boolean;
        EmptyAreaTotalDisplayTime: Integer;  //in seconds
        );
  end;

  TAreasArray = array[1..MAX_AREA_COUNT] of TArea;
  TAreasArrayForFile = array[1..MAX_AREA_COUNT] of TAreaForFile;

  TStage = record  //--> **If changed, also TStageForFile must be updated.
    StagePanel: TsStagePanel;

    TemporaryDisabled: Boolean;

    LayoutIndex: Integer;  //Starting from 1
    CustomLayout: Boolean;

    EntranceEffectID: Integer;
    ExitEffectID: Integer;
    EffectSpeed: Integer;  //0(very fast) to 255(very slow)
    //Time Span
    HourFrom, MinuteFrom: Integer;
    HourTo, MinuteTo: Integer;
    OnlyDoNotShowDuringTimeSpan: Boolean;
    DisplayInSpecificDate: Boolean;
    Year, Month, Day: Integer;

    Areas: TAreasArray;

    LastSelectedAreaIndex: Integer;  //This is used only in runtime and is no setting, so there is no need to save it to file or load it from file
    
    //Reserved bytes - set to 0 for compatibility
    ReservedBytes: array[1..STAGE_RESERVED_BYTES_COUNT] of Byte;
  end;
  TStageForFile = record
    LEDDisplaySettings: TLEDDisplaySettingsForFile;

    StagePanel: TsStagePanel;

    TemporaryDisabled: Boolean;

    LayoutIndex: Integer;  //Starting from 1
    CustomLayout: Boolean;

    EntranceEffectID: Integer;
    ExitEffectID: Integer;
    EffectSpeed: Integer;  //0(very fast) to 255(very slow)
    //Time Span
    HourFrom, MinuteFrom: Integer;
    HourTo, MinuteTo: Integer;
    OnlyDoNotShowDuringTimeSpan: Boolean;
    DisplayInSpecificDate: Boolean;
    Year, Month, Day: Integer;

    Areas: TAreasArrayForFile;

    StageCount: Integer;

    //Reserved bytes - set to 0 for compatibility
    ReservedBytes: array[1..STAGE_RESERVED_BYTES_COUNT] of Byte;
  end;

  TStagesForFileArray = array of TStageForFile;
  TStagesArray = array of TStage;

implementation

end.
