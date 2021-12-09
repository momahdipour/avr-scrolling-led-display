unit MainUnit;

{$INCLUDE Config.inc}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, sSkinProvider, sSkinManager, TntForms, ExtCtrls, TntExtCtrls,
  sPanel, ComCtrls, TntComCtrls, Buttons, TntButtons, sSpeedButton,
  AboutFormUnit, sPageControl, StdCtrls, ToolWin, sToolBar, TntStdCtrls,
  sGroupBox, SpecialProcsUnit, AdvGrid, sLabel, sRadioButton, sEdit,
  sSpinEdit, sCheckBox, sScrollBox, sStagePanel, sTntDialogs, LayoutFormUnit,
  TntDelayedComboBox, sComboBox, ImgList, LEDTime, ProgrammerFormUnit,
  Layouts, LEDDate, TextPicturePreviewFormUnit, TextToLCDUnit, Grids,
  BaseGrid, GlobalTypes, MMAdvancedGrid, LCDProcsUnit, TntClasses, GIFImage,
  LEDScrollingText, TntDelayedEdit, sBitBtn, ProcsUnit, sListBox, Mask,
  sMaskEdit, sCustomComboEdit, sTooledit, LEDAnimation,
  ImportGraphicsFormUnit, cmpStandardSystemMenu, LEDPicture, LEDTemperature,
  Menus, TntMenus, TntXPMenu, ChangeDisplaySettingsFormUnit, SoundDialogs,
  Registry, ProgramConsts, SelectNormalEffectFormUnit,
  SelectPageEffectFormUnit, sTrackBar, LEDEmpty, DateUtils, UnitKDCommon,
  UnitKDSerialPort, ProgramOptionsFormUnit, BiDiSoundDialogs,
  BiDiDialogs, TntSysUtils, TntSystem, PreviewUnit, TntFileCtrl, FileCtrl,
  ShlObj, AppEvnts, MPlayer, TntRegistry, AlarmSettingsFormUnit,
  sDelayedEdit, Clipbrd, LayoutDesignerFormUnit, StrUtils, CommDlg,
  TntDialogs, CutCopyPasteEdit, BorderStyleFormUnit,
  ScheduleStageFormUnit, AnimationLineSummaryFormUnit, WaitFormUnit,
  FadedDraw, sButton, ProgressFormUnit, OTAImage, RAR, sDialogs,
  DefaultPicturesFormUnit, AlarmProgressFormUnit,
  LEDDisplayDataResetFormUnit, sRichEdit, PngImageList, fe_flashole,
  fe_flashwnd, fe_flashplayer, LEDSWF, MMSWF, LicenseTypes,
  MMSWFHeaderReader, sDelayedTrackBar, SWFPreviewFormUnit;

  //**TO CHANGE DEFAULT CONTENT TYPE FOR THE AREAS OF NEW STAGES, MODIFY THE CORRISPONDING LINE
  //   IN THE NewStage FUNCTION

type
  TUserMappedChar = record
    Character: Char;
    MappedFName: String;
  end;

  THighGUISkinInfo = record
    HighGUIGroupBoxSkinSection: String;
    HighGUIGroupBoxCaptionSkin: String;
  end;

const
  SupportEnKey: String = 'h6%2Sw0991@34k=+8Hyt%4hfcm,ksl#2kDrU';
  SUPPORT_FILE_VERSION_STR = '1.0';

  //WM_LFG_DESIGN_SAVED = WM_USER + 342;  //For communication between LFG4LDC and LDC  --> Implemented with Application.OnActivate event (without messaging)

  //Cursors
  ANI_HOUR_GLASS = 101;  //Number 100 is used in the LEDDisplayControl application source

  //Registry paths
  RUFLRegPath = '\Recently Opened Presentations';
  ////////////////

  //Custom ModalResult constants
  mrLayoutDesigner = 100;
  mrLayoutSameAsPreviousStage = 101;
  mrSelectLayout = 102;
  //////////////////////////////

  //Skin information
  SKIN_COUNT = 8;
  SkinNames: array[1..SKIN_COUNT] of String = (
    'Office2003 (internal)', 'WLM (internal)', 'LongHorn (internal)',
    'Neutral (internal)', 'Neutral3 (internal)', 'Neutral4 (internal)',
    'TheFrog (internal)', 'Wood (internal)'
    );
  HighGUISkinsInfo: array[1..SKIN_COUNT] of THighGUISkinInfo = (
    (HighGUIGroupBoxSkinSection: 'BARPANEL'; HighGUIGroupBoxCaptionSkin: 'ALPHAEDIT'),
    (HighGUIGroupBoxSkinSection: 'MAINMENU'; HighGUIGroupBoxCaptionSkin: 'ALPHAEDIT'),
    (HighGUIGroupBoxSkinSection: 'ALPHACOMBOBOX'; HighGUIGroupBoxCaptionSkin: 'ALPHAEDIT'),
    (HighGUIGroupBoxSkinSection: 'TOOLBAR'; HighGUIGroupBoxCaptionSkin: 'ALPHAEDIT'),
    (HighGUIGroupBoxSkinSection: 'FORM'; HighGUIGroupBoxCaptionSkin: 'ALPHAEDIT'),
    (HighGUIGroupBoxSkinSection: 'COMBOBTN'; HighGUIGroupBoxCaptionSkin: 'ALPHAEDIT'),
    (HighGUIGroupBoxSkinSection: 'BARPANEL'; HighGUIGroupBoxCaptionSkin: 'ALPHAEDIT'),
    (HighGUIGroupBoxSkinSection: 'MAINMENU'; HighGUIGroupBoxCaptionSkin: 'ALPHAEDIT')
    );
  //////////////////

  /////////////////////////////////////////////////////
  //Language
  STATIC_LANG_RESID_START_NUM = 0;
  DYNAMIC_LANG_RESID_START_NUM = 500;
  DYNAMIC_TEXTS_COUNT = 144;
  /////////////////////////////////////////////////////

  COMPLETE_HELP_FILE_NAME = 'LDCHelp.pdf';
  QUICK_HELP_FILE_NAME = 'LDCQuickHelp.pdf';
  HELP_PATH = 'Help';

  FARSI_FONTS_PATH = 'LED Font Generator 2.0 Limited Edition\Character Library\Farsi Fonts';
  ENGLISH_FONTS_PATH = 'LED Font Generator 2.0 Limited Edition\Character Library\English Fonts';
  FONT_INFO_FILE_NAME = 'description.txt';
  FONT_PREVIEW_FILE_NAME = 'preview.gif';
  //USER_MAPPED_CHARS_FILE_NAME = 'CharMap.cfg';  --> Not Used
  GIF_ANIMATIONS_FOLDER_NAME = 'Animations';
  GIF_ANIMATIONS_FILE_NAME = 'Animations.cfg';

  PICTURES_FOLDER_NAME = 'Pictures and Symbols';
  PICTURES_FILE_NAME = 'Pictures.cfg';

  SMS_PICTURES_FOLDER_NAME = 'SMS Pictures';

  UNRAR_DLL_NAME = 'datamgr.dll';
  DATA_FILES_RAR_PASSWORD = '_NOORSUN-EM-88-RAR_';
  DATA_FOLDER_NAME = 'Data';
  ANIMATIONS_DATA_FILE_NAME = 'Data1.dat';
  PICTURES_DATA_FILE_NAME = 'Data2.dat';
  SMS_PICTURES_DATA_FILE_NAME = 'Data3.dat';

  
  MUSIC_FOLDER_NAME = 'Music';

  SOUNDS_FOLDER_NAME = 'Sounds';

  LFG_FULL_FILE_NAME = 'LED Font Generator 2.0 Limited Edition\LFG4LDC.exe';

  LCDFilledColor = clBlue;
  LCDClearedColor = clWhite;
  LCDGridLineColor = clSilver;

  GIFFilledColor = clBlue;
  GIFClearedColor = clWhite;

  NORMAL_EFFECTS_COUNT = 16;
  MAX_NORMAL_EFFECT_ID = 16;

  PAGE_EFFECTS_COUNT   = 8;
  MAX_PAGE_EFFECT_ID = 8;

  FONT_SIZE_WARNING_BLINK_COUNT = 4;

  MY_LED_DESIGNS_FOLDER_NAME = 'My LED Designs';
  MY_TEXT_DESIGNS_FOLDER_NAME = 'Text Designs';
  MY_PICTURE_DESIGNS_FOLDER_NAME = 'Picture Designs';

  NEW_LFG_TEXT_FILE_NAME = 'New Text.LCD';
  NEW_LFG_PICTURE_FILE_NAME = 'New Picture.LCD';

  NEW_ALARM_SETTINGS_FILE_NAME = 'AlarmSettings.LDCAlarm';

  MAX_NUM_OF_LED_DISPLAYS = 2;

  //Default favorite fonts (will be loaded if the list is empty)
  DEFAULT_FAVORITE_FONTS: array[1..6] of String = (
      'Arial',
      'Tahoma',
      'Wingdings',
      'Wingdings 2',
      'Wingdings 3',
      'Webdings'
  );

  //Default User-Mapped Characters (will be loaded in the LoadDefaultConfig procedure)
  DEFAULT_USER_MAPPED_CHARS: array[1..11] of TUserMappedChar = (
      (Character: ' '; MappedFName: 'SPACE'),
      (Character: '/'; MappedFName: 'SLASH'),
      (Character: '\'; MappedFName: 'BACKSLASH'),
      (Character: '.'; MappedFName: 'DOT'),
      (Character: ':'; MappedFName: 'COLON'),
      (Character: '?'; MappedFName: 'QUESTION'),
      (Character: '>'; MappedFName: 'GREATER THAN'),
      (Character: '<'; MappedFName: 'LESS THAN'),
      (Character: '*'; MappedFName: 'ASTERISK'),
      (Character: '"'; MappedFName: 'QUOTATION'),
      (Character: '|'; MappedFName: 'PIPE')
  );

type
  TGlobalOptions = record
    LEDDisplaySettings: TLEDDisplaySettings;

    NumOfLEDDisplays: Integer;
    ComPort1, ComPort2: TPortNumber;

    MY_LED_DESIGNS_FOLDER_FULL_PATH: String;  //Run-Time Option
    MY_TEXT_DESIGNS_FOLDER_FULL_PATH: String;  //Run-Time Option
    MY_PICTURE_DESIGNS_FOLDER_FULL_PATH: String;  //Run-Time Option

    NewLFGFileDefaultWidth: Integer;  //Run-Time Option
    NewLFGFileDefaultHeight: Integer;  //Run-Time Option

    HueOffset: Integer;
    SkinNumber: Integer;
    DontUseHighGUI: Boolean;

    MusicON: Boolean;
    SelectedMusicIndex: Integer;

    SystemFontsSectionActivePageIndex: Integer;

    FavFont: TFontSettings;  //For Scrolling Text Content
    AllFont: TFontSettings;  //For Scrolling Text Content

    FarsiFontName: WideString;  //For Scrolling Text Content
    EnglishFontName: WideString;  //For Scrolling Text Content

    RUFLCount: Integer;

    SelectPageEffectOnNewStage: Boolean;
    SelectPageLayoutOnNewStage: Boolean;

    SoundOptions: TSoundOptions;

    AutomaticallyRefreshTimePreview: Boolean;
    AutomaticallyRefreshTextPreview: Boolean;

    MainFormState: TWindowState;

    DefaultSWFSensitivity: Integer;
  end;
  TRuntimeGlobalOptions = record
    OriginalLEDDisplaySettings: TLEDDisplaySettings;
    UsingTemporaryLEDDisplaySettings: Boolean;

    FirstUserRun: Boolean;

    //Default appearance settings (used in the ProgramOptionsForm form)
    AppearanceDefaultHueOffset: Integer;
    AppearanceDefaultSkinNumber: Integer;

    LayoutButtonSkin: String;

    PopupFormsMainPanelSkin: String;

    WaitFormMainPanelSkin: String;

    UnselectedStagePanelNormalSkin: String;
    UnselectedStagePanelDisabledSkin: String;
    SelectedStagePanelNormalSkin: String;
    SelectedStagePanelDisabledSkin: String;

    HighGUIDeactivatedByLicense: Boolean;

    ShowTextPreview: Boolean;
  end;

  TMainForm = class(TTntForm)
    sSkinManager1: TsSkinManager;
    PreviewPanel: TsPanel;
    RightPanel: TsPanel;
    MenuPanel: TsPanel;
    ExitBtn: TsSpeedButton;
    AboutBtn: TsSpeedButton;
    MenuBarPanel: TsPanel;
    SetDateTimeBtn: TsSpeedButton;
    ChangeLEDDisplayDataBtn: TsSpeedButton;
    NewShowBtn: TsSpeedButton;
    TimeContentPanel: TsPanel;
    TimeContentBtn: TsSpeedButton;
    DateContentBtn: TsSpeedButton;
    ScrollingTextContentBtn: TsSpeedButton;
    AnimationContentBtn: TsSpeedButton;
    PictureContentBtn: TsSpeedButton;
    ComboBox1: TComboBox;
    StagesPanel: TsPanel;
    StageOptionsPanel: TsPanel;
    sPanel11: TsPanel;
    sPanel8: TsPanel;
    sPanel5: TsPanel;
    AddNewStageBtn: TsSpeedButton;
    DeleteCurrentStageBtn: TsSpeedButton;
    TimeTypeGroup: TsGroupBox;
    AnimationLineWhiteImage: TTntImage;
    AnimationLineScrollBox: TScrollBox;
    HelpBtn: TsSpeedButton;
    TemperatureContentBtn: TsSpeedButton;
    LayoutPanel: TsGroupBox;
    LayoutGroup: TsGroupBox;
    LayoutBtn1: TsSpeedButton;
    LayoutBtn2: TsSpeedButton;
    LayoutBtn3: TsSpeedButton;
    LayoutBtn4: TsSpeedButton;
    TitlePanel: TsPanel;
    TitleImage: TImage;
    AreaPreviewGroup: TsGroupBox;
    ShowPreviewBtn: TsSpeedButton;
    AutoPreviewCheck: TsCheckBox;
    DateContentPanel: TsPanel;
    DateTypeGroup: TsGroupBox;
    TimeLanguageGroup: TsGroupBox;
    ClockDigitsFarsiRadio: TsRadioButton;
    ClockDigitsEnglishRadio: TsRadioButton;
    TimeFormatGroup: TsGroupBox;
    Clock24HourRadio: TsRadioButton;
    Clock12HourRadio: TsRadioButton;
    DateLanguageGroup: TsGroupBox;
    DateDigitsFarsiRadio: TsRadioButton;
    DateDigitsEnglishRadio: TsRadioButton;
    DateFormatGroup: TsGroupBox;
    DateSolarRadio: TsRadioButton;
    DateGregorianRadio: TsRadioButton;
    ScrollingTextContentPanel: TsPanel;
    TextFontGroupBox: TsGroupBox;
    SimpleTextGroupBox: TsGroupBox;
    sLabel7: TsLabel;
    LCDFontsSourceRadio: TsRadioButton;
    SystemFontsSourceRadio: TsRadioButton;
    LCDFontsSection: TsGroupBox;
    sLabel3: TsLabel;
    sLabel4: TsLabel;
    FarsiLCDFontsCombo: TsComboBox;
    EnglishLCDFontsCombo: TsComboBox;
    SystemFontsSection: TsPageControl;
    FavoriteFontsTabSheet: TsTabSheet;
    AllFontsTabSheet: TsTabSheet;
    sLabel9: TsLabel;
    AllFontsCombo: TsComboBox;
    FontDialogBtn: TsSpeedButton;
    FontDialog1: TFontDialog;
    sGroupBox13: TsGroupBox;
    FontSamplePanel: TsPanel;
    TextEffectsGroupBox: TsGroupBox;
    InvertScrollingTextCheck: TsCheckBox;
    AnimationContentPanel: TsPanel;
    AnimationDisplaySettingsGroup: TsGroupBox;
    UseGIFTimingsCheck: TsCheckBox;
    sLabel19: TsLabel;
    AnimationSpeedCombo: TsComboBox;
    PictureContentPanel: TsPanel;
    TemperatureContentPanel: TsPanel;
    TemperatureLanguageGroup: TsGroupBox;
    TempLangFarsiRadio: TsRadioButton;
    TempLangEnglishRadio: TsRadioButton;
    ContentImages: TImageList;
    NextLayoutBtn: TsSpeedButton;
    PreviousLayoutBtn: TsSpeedButton;
    SelectLayoutBtn: TsSpeedButton;
    sSkinProvider1: TsSkinProvider;
    SaveDialog1: TSaveDialog;
    Bold2: TsSpeedButton;
    Italic2: TsSpeedButton;
    Underlined2: TsSpeedButton;
    FontSizeCombo2: TsComboBox;
    AddToFavoriteFontsBtn: TsSpeedButton;
    FarsiLCDFontPreviewImage: TImage;
    EnglishLCDFontPreviewImage: TImage;
    sLabel8: TsLabel;
    FavoriteFontsCombo: TsComboBox;
    Underlined1: TsSpeedButton;
    Italic1: TsSpeedButton;
    Bold1: TsSpeedButton;
    FontSizeCombo1: TsComboBox;
    RemoveFromFavoriteFontsBtn: TsSpeedButton;
    sGroupBox24: TsGroupBox;
    FavoriteFontSamplePanel: TsPanel;
    Bevel1: TBevel;
    Bevel11: TBevel;
    Bevel3: TBevel;
    TextToLCDGrid: TMMAdvancedGrid;
    TextMovementGroupBox: TsGroupBox;
    sLabel11: TsLabel;
    sLabel12: TsLabel;
    TextDirectionRightRadio: TsRadioButton;
    TextDirectionLeftRadio: TsRadioButton;
    TextScrollSpeedCombo: TsComboBox;
    InputTextFarsiRadio: TsRadioButton;
    InputTextEnglishRadio: TsRadioButton;
    AnimationPreviewGroup: TsGroupBox;
    AnimationPreviewImage: TImage;
    AnimationTimeGroup: TsGroupBox;
    AnimationTotalDisplayTimeSpin: TsSpinEdit;
    AnimLabel3: TsLabel;
    AnimationTimingStyle1Radio: TsRadioButton;
    AnimationRepetitionTimesSpin: TsSpinEdit;
    AnimLabel1: TsLabel;
    AnimationTimingStyle2Radio: TsRadioButton;
    AnimLabel2: TsLabel;
    AnimationListGroupBox: TsGroupBox;
    GIFAnimationsList: TsListBox;
    AddNewAnimationBtn: TsBitBtn;
    PictureMovementGroupBox: TsGroupBox;
    PictureLabel1: TsLabel;
    PictureLabel2: TsLabel;
    PictureDirectionRightRadio: TsRadioButton;
    PictureDirectionLeftRadio: TsRadioButton;
    PictureSpeedCombo: TsComboBox;
    PictureEffectsGroupBox: TsGroupBox;
    InvertPictureCheck: TsCheckBox;
    PictureTimeGroupBox: TsGroupBox;
    sLabel24: TsLabel;
    sLabel26: TsLabel;
    PictureTotalDisplayTimeSpin: TsSpinEdit;
    PicturePreviewGroupBox: TsGroupBox;
    PicturePreviewImage: TImage;
    StandardSystemMenu1: TStandardSystemMenu;
    TemperatureUnitGroup: TsGroupBox;
    TempUnitCentigradeRadio: TsRadioButton;
    TempUnitFahrenheitRadio: TsRadioButton;
    TemperatureTimeGroupBox: TsGroupBox;
    sLabel30: TsLabel;
    sLabel31: TsLabel;
    TempTotalDisplayTimeSpin: TsSpinEdit;
    StagePanelPopup: TTntPopupMenu;
    N1: TTntMenuItem;
    N2: TTntMenuItem;
    N3: TTntMenuItem;
    SelectLayoutMenuItem: TTntMenuItem;
    SelectPageEffectMenuItem: TTntMenuItem;
    N6: TTntMenuItem;
    N7: TTntMenuItem;
    TntXPMenu1: TTntXPMenu;
    PageEffectsPanel: TsGroupBox;
    LEDDisplayInfoGroup: TsGroupBox;
    sLabel32: TsLabel;
    sLabel33: TsLabel;
    ChangeLEDDisplaySettingsBtn: TsSpeedButton;
    DisplaySizeLabel: TsLabel;
    MemorySizeLabel: TsLabel;
    SelectTextEntranceEffectBtn: TsBitBtn;
    TextEntranceEffectImage: TImage;
    TextEntranceEffectCheck: TsCheckBox;
    PictureEntranceEffectImage: TImage;
    PictureEntranceEffectCheck: TsCheckBox;
    SelectPictureEntranceEffectBtn: TsBitBtn;
    PageEffectImage: TImage;
    SelectPageEffectBtn: TsSpeedButton;
    NoPageEffectLabel: TsLabel;
    DateTimeGroupBox: TsGroupBox;
    sLabel5: TsLabel;
    DateTotalDisplayTimeSpin: TsSpinEdit;
    sLabel6: TsLabel;
    DateFormat1Radio: TsRadioButton;
    DateFormat3Radio: TsRadioButton;
    DateFormat0Radio: TsRadioButton;
    DateFormat2Radio: TsRadioButton;
    PutDateAtCenterCheck: TsCheckBox;
    RepeatDateAfterDoneCheck: TsCheckBox;
    TimeTimeGroupBox: TsGroupBox;
    ClockTotalDisplayTimeSpin: TsSpinEdit;
    sLabel2: TsLabel;
    sLabel1: TsLabel;
    ClockHHMMFormatRadio: TsRadioButton;
    ClockHHMMSSFormatRadio: TsRadioButton;
    PutClockAtCenterCheck: TsCheckBox;
    RepeatClockAfterDoneCheck: TsCheckBox;
    RepeatTemperatureAfterDoneCheck: TsCheckBox;
    TemperatureDisplayGroupBox: TsGroupBox;
    PutTemperatureAtCenterCheck: TsCheckBox;
    FontSizeWarningBtn1: TsSpeedButton;
    TextTimeGroupBox: TsGroupBox;
    sLabel20: TsLabel;
    TextLabel1: TsLabel;
    sLabel23: TsLabel;
    TextTotalDisplayTimeSpin: TsSpinEdit;
    TextTimingStyle1Radio: TsRadioButton;
    TextRepetitionTimesSpin: TsSpinEdit;
    TextTimingStyle2Radio: TsRadioButton;
    RepeatTextAfterDoneCheck: TsCheckBox;
    PutAnimationAtCenterCheck: TsCheckBox;
    RepeatAnimationAfterDoneCheck: TsCheckBox;
    sLabel28: TsLabel;
    PictureWidthLabel: TsLabel;
    sLabel29: TsLabel;
    PictureHeightLabel: TsLabel;
    RepeatPictureAfterDoneCheck: TsCheckBox;
    MenuCorrectTimer: TTimer;
    DisplayStageMenuBtn: TsSpeedButton;
    MenuImages: TImageList;
    StageEffectsLabel1: TsLabel;
    EffectsSpeedTrackbar: TsTrackBar;
    StageEffectsLabel3: TsLabel;
    StageEffectsLabel2: TsLabel;
    Bevel2: TBevel;
    PictureTimingStyle1Radio: TsRadioButton;
    PictureTimingStyle2Radio: TsRadioButton;
    PictureRepetitionTimesSpin: TsSpinEdit;
    PictureLabel3: TsLabel;
    sGroupBox2: TsGroupBox;
    AreaHeightLabel: TsLabel;
    AreaSizeSpin: TsSpinEdit;
    AreaWidthLabel: TsLabel;
    EmptyContentBtn: TsSpeedButton;
    EmptyContentPanel: TsPanel;
    EmptyDisplayGroupBox: TsGroupBox;
    EmptyAreaFilledRadio: TsRadioButton;
    EmptyAreaClearedRadio: TsRadioButton;
    EmptyTimeGroupBox: TsGroupBox;
    sLabel17: TsLabel;
    sLabel18: TsLabel;
    EmptyAreaTotalDisplayTimeSpin: TsSpinEdit;
    InputTextMixedRadio: TsRadioButton;
    ProgramOptionsBtn: TsSpeedButton;
    Image1: TImage;
    Image3: TImage;
    Image2: TImage;
    Image4: TImage;
    Image5: TImage;
    Image6: TImage;
    Image7: TImage;
    Image8: TImage;
    RegistrationPanel: TTntPanel;
    Far8: TBevel;
    Far2: TImage;
    SoftwareNameLabelFa: TsLabel;
    SoftwareNameLabelEn: TsLabel;
    ProgressTimer: TTimer;
    Image9: TImage;
    Image10: TImage;
    Image11: TImage;
    Image12: TImage;
    FontSizeWarningTimer: TTimer;
    ContentTitleLabel: TsLabel;
    ContentTextImage: TImage;
    ContentTextImages: TImageList;
    ForwardCurrentStageBtn: TsSpeedButton;
    BackwardCurrentStageBtn: TsSpeedButton;
    GotoLFGBtn: TsSpeedButton;
    ShowTextPreviewBtn: TsSpeedButton;
    TextTypeGroupBox: TsGroupBox;
    ScrollingTextRadio: TsRadioButton;
    FixedTextRadio: TsRadioButton;
    SimpleTextTabBtn: TsBitBtn;
    AdvancedTextTabBtn: TsBitBtn;
    AdvancedTextGroupBox: TsGroupBox;
    sLabel34: TsLabel;
    SelectScrollingTextDesignFileBtn: TsSpeedButton;
    ScrollingTextDesignFilePathLabel: TsLabel;
    EditScrollingTextDesignFileBtn: TsSpeedButton;
    LFGFileOpenDialog: TTntOpenDialog;
    CreateScrollingTextDesignFileBtn: TsSpeedButton;
    ScrollingTextDesignFilePathEdit: TsEdit;
    LFGFileSaveDialog: TTntSaveDialog;

    PictureTypeGroupBox: TsGroupBox;
    FixedPictureRadio: TsRadioButton;
    ScrollingPictureRadio: TsRadioButton;
    SimplePictureTabBtn: TsBitBtn;
    AdvancedPictureTabBtn: TsBitBtn;
    AdvancedPictureGroupBox: TsGroupBox;
    SelectPictureDesignFileBtn: TsSpeedButton;
    PictureDesignFilePathLabel: TsLabel;
    EditPictureDesignFileBtn: TsSpeedButton;
    CreatePictureDesignFileBtn: TsSpeedButton;
    sLabel27: TsLabel;
    PictureDesignFilePathEdit: TsEdit;
    SimplePictureGroupBox: TsGroupBox;
    ImportPictureBtn: TsBitBtn;
    RefreshAdvancedTextPreviewBtn: TsSpeedButton;
    RefreshAdvancedPicturePreviewBtn: TsSpeedButton;
    ApplicationEvents1: TApplicationEvents;
    MusicBtn: TsSpeedButton;
    SelectMusicBtn: TsSpeedButton;
    MusicPopup: TTntPopupMenu;
    MediaPlayer1: TMediaPlayer;
    MenuImages16: TImageList;
    ApplyAfterShowConfigTimer: TTimer;
    ChangeLEDDisplayDataPopup: TTntPopupMenu;
    SetDateTimePopup: TTntPopupMenu;
    ChangeLEDDisplayDataMenuItem1: TTntMenuItem;
    ChangeLEDDisplayDataMenuItem2: TTntMenuItem;
    SetDateTimeMenuItem1: TTntMenuItem;
    SetDateTimeMenuItem2: TTntMenuItem;
    SetAlarmsBtn: TsSpeedButton;
    ClockDotsBlinkCheck: TsCheckBox;
    InputText: TsDelayedEdit;
    GeneralEditPopupMenu: TTntPopupMenu;
    GECutPopupMenuItem: TTntMenuItem;
    GECopyPopupMenuItem: TTntMenuItem;
    GEPastePopupMenuItem: TTntMenuItem;
    SaveBtn: TsSpeedButton;
    OpenBtn: TsSpeedButton;
    OpenShowDialog: TTntOpenDialog;
    SaveShowDialog: TTntSaveDialog;
    SaveDropDownBtn: TsSpeedButton;
    SaveOptionsPopup: TTntPopupMenu;
    SaveMenuItem: TTntMenuItem;
    SaveAsMenuItem: TTntMenuItem;
    OpenDropDownBtn: TsSpeedButton;
    RUFLPopup: TTntPopupMenu;
    RUFLMenuSplitter: TTntMenuItem;
    RUFLMenuLastItem: TTntMenuItem;
    LicenseTimer: TTimer;
    LFGFileSizeWarningBtn1: TsSpeedButton;
    AreaDelayGroup: TsGroupBox;
    sLabel10: TsLabel;
    AreaDelaySpin: TsSpinEdit;
    sLabel13: TsLabel;
    AreaColorGroup: TsGroupBox;
    sLabel35: TsLabel;
    AreaColorCombo: TsComboBox;
    AreaBorderGroup: TsGroupBox;
    BorderStyleImage: TImage;
    EditBorderStyleSpeedBtn: TsSpeedButton;
    TopBorderLabel: TsLabel;
    BottomBorderLabel: TsLabel;
    LeftBorderLabel: TsLabel;
    RightBorderLabel: TsLabel;
    AreaBorderWidthSpin: TsSpinEdit;
    DefaultPicturesCombo: TsComboBox;
    UseDefaultPicturesRadio: TsRadioButton;
    ImportNewPictureRadio: TsRadioButton;
    HighGUITimer: TTimer;
    ContentPreviewPanel: TsGroupBox;
    TextPreviewPanel: TsPanel;
    TextPreviewImage: TImage;
    ProgressGroup: TsGroupBox;
    ProgressImage: TImage;
    ProgressLabel: TsLabel;
    ScheduleStageBtn: TsSpeedButton;
    ScheduleStageMenuItem: TTntMenuItem;
    OpenDialog1: TOpenDialog;
    SoundItemMediaPlayer: TMediaPlayer;
    AnimationLineSummaryBtn: TsSpeedButton;
    TimePreviewPanel: TsPanel;
    TimePreviewImage: TImage;
    DatePreviewPanel: TsPanel;
    DatePreviewImage: TImage;
    TimePreviewTimer: TTimer;
    TemperaturePreviewPanel: TsPanel;
    TemperaturePreviewImage: TImage;
    EmptyPreviewPanel: TsPanel;
    EmptyPreviewImage: TImage;
    TemporaryDisableStageMenuItem: TTntMenuItem;
    N5: TTntMenuItem;
    N4: TTntMenuItem;
    SortAnimationLineByTimeMenuItem: TTntMenuItem;
    HelpPopup: TTntPopupMenu;
    N10: TTntMenuItem;
    N9: TTntMenuItem;
    AnimationLineRedImage: TTntImage;
    AnimationLineTimer: TTimer;
    FadedTitleImage: TImage;
    ShowWaitStateTimer: TTimer;
    EditBorderStyleSpeedBtn2: TsSpeedButton;
    PicturePreviewPanel: TsPanel;
    PictureContentPreviewImage: TImage;
    ImportSMSPicBtn: TsBitBtn;
    OpenSMSPictureDialog: TTntOpenDialog;
    SelectDefaultPictureBtn: TsBitBtn;
    sLabel14: TsLabel;
    AnimationWidthLabel: TsLabel;
    sLabel16: TsLabel;
    AnimationHeightLabel: TsLabel;
    N8: TTntMenuItem;
    DateFormat4Radio: TsRadioButton;
    DateFormat5Radio: TsRadioButton;
    FullBorderBtn: TsSpeedButton;
    NoBorderBtn: TsSpeedButton;
    DatePreviewTimer: TTimer;
    RepeatEmptyAreaAfterDoneCheck: TsCheckBox;
    NoPageEffectLabelForClickLabel: TsLabel;
    SWFContentPanel: TsPanel;
    SWFDisplaySettingsGroup: TsGroupBox;
    sLabel15: TsLabel;
    InvertSWFCheck: TsCheckBox;
    SWFSpeedCombo: TsComboBox;
    PutSWFAtCenterCheck: TsCheckBox;
    SWFPreviewGroupBox: TsGroupBox;
    SWFTimeGroupBox: TsGroupBox;
    SWFLabel3: TsLabel;
    SWFLabel1: TsLabel;
    SWFLabel2: TsLabel;
    SWFTotalDisplayTimeSpin: TsSpinEdit;
    SWFTimingStyle1Radio: TsRadioButton;
    SWFRepetitionTimesSpin: TsSpinEdit;
    SWFTimingStyle2Radio: TsRadioButton;
    RepeatSWFAfterDoneCheck: TsCheckBox;
    OpenSWFFileBtn: TsBitBtn;
    OpenSWFDialog: TTntOpenDialog;
    SWFContentBtn: TsSpeedButton;
    PngImageList40x40: TPngImageList;
    FlashPlayer: TfeFlashPlayer;
    sLabel42: TsLabel;
    SWFFrameCountLabel: TsLabel;
    sLabel25: TsLabel;
    SWFSizeLabel: TsLabel;
    sSpeedButton6: TsSpeedButton;
    sSpeedButton1: TsSpeedButton;
    SetOffTimeBtn: TsSpeedButton;
    PngImageList32x32: TPngImageList;
    InvertAnimationCheck: TsCheckBox;
    UseSWFTimingsCheck: TsCheckBox;
    ActivationCodeGroup: TsGroupBox;
    CUIDWord6: TEdit;
    CUIDWord5: TEdit;
    CUIDWord4: TEdit;
    CUIDWord3: TEdit;
    CUIDWord2: TEdit;
    CUIDWord1: TEdit;
    ACWord6: TCopyPasteEdit;
    ACWord5: TCopyPasteEdit;
    ACWord4: TCopyPasteEdit;
    ACWord3: TCopyPasteEdit;
    ACWord2: TCopyPasteEdit;
    ACWord1: TCopyPasteEdit;
    Far3: TImage;
    Far4: TImage;
    Dash5: TLabel;
    Dash11: TLabel;
    Dash10: TLabel;
    Dash4: TLabel;
    Dash3: TLabel;
    Dash9: TLabel;
    Dash8: TLabel;
    Dash2: TLabel;
    Dash1: TLabel;
    Dash7: TLabel;
    Far7: TImage;
    Far6: TImage;
    Far5: TImage;
    CUIDWord7: TEdit;
    Dash6: TLabel;
    SelectModelGroup: TsGroupBox;
    ModelsListBox: TsListBox;
    Image13: TImage;
    Image14: TImage;
    ModelExitBtn: TImage;
    ModelOKBtn: TImage;
    Image15: TImage;
    SWFSWFSettingsGroup: TsGroupBox;
    sLabel36: TsLabel;
    SWFSensitivityTrackBar: TsDelayedTrackBar;
    SWFPreviewBtn: TsSpeedButton;
    SWFSensitivityLabel: TsLabel;
    NormalModelList: TsListBox;
    FullBrightModelList: TsListBox;
    procedure AboutBtnClick(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure ExitBtnClick(Sender: TObject);
    procedure TntFormCreate(Sender: TObject);
    procedure TimeContentBtnClick(Sender: TObject);
    procedure DateContentBtnClick(Sender: TObject);
    procedure ScrollingTextContentBtnClick(Sender: TObject);
    procedure AnimationContentBtnClick(Sender: TObject);
    procedure PictureContentBtnClick(Sender: TObject);
    procedure AddNewStageBtnClick(Sender: TObject);
    procedure DeleteCurrentStageBtnClick(Sender: TObject);
    procedure TntFormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure sSpeedButton6Click(Sender: TObject);
    procedure TemperatureContentBtnClick(Sender: TObject);
    procedure InputTextChange(Sender: TObject);
    procedure FontDialogBtnClick(Sender: TObject);
    procedure ChangeLEDDisplayDataBtnClick(Sender: TObject);
    procedure NextLayoutBtnClick(Sender: TObject);
    procedure PreviousLayoutBtnClick(Sender: TObject);
    procedure LayoutBtn1Click(Sender: TObject);
    procedure InputTextDelayedChange(Sender: TObject);
    procedure AllFontsComboChange(Sender: TObject);
    procedure FavoriteFontsComboChange(Sender: TObject);
    procedure Bold1Click(Sender: TObject);
    procedure TntFormDestroy(Sender: TObject);
    procedure LCDFontsSourceRadioClick(Sender: TObject);
    procedure SystemFontsSourceRadioClick(Sender: TObject);
    procedure FarsiLCDFontsComboChange(Sender: TObject);
    procedure EnglishLCDFontsComboChange(Sender: TObject);
    procedure InputTextFarsiRadioClick(Sender: TObject);
    procedure InputTextEnglishRadioClick(Sender: TObject);
    procedure ShowTextPreviewBtnClick(Sender: TObject);
    procedure InputTextKeyPress(Sender: TObject; var Key: Char);
    procedure GIFAnimationsListClick(Sender: TObject);
    procedure ImportPictureBtnClick(Sender: TObject);
    procedure SelectLayoutBtnClick(Sender: TObject);
    procedure StagePanelPopupPopup(Sender: TObject);
    procedure SelectLayoutMenuItemClick(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure N6Click(Sender: TObject);
    procedure N7Click(Sender: TObject);
    procedure ChangeLEDDisplaySettingsBtnClick(Sender: TObject);
    procedure MenuPanelResize(Sender: TObject);
    procedure TntFormClose(Sender: TObject; var Action: TCloseAction);
    procedure SelectTextEntranceEffectBtnClick(Sender: TObject);
    procedure TextEntranceEffectCheckClick(Sender: TObject);
    procedure PictureEntranceEffectCheckClick(Sender: TObject);
    procedure SelectPictureEntranceEffectBtnClick(Sender: TObject);
    procedure SelectPageEffectBtnClick(Sender: TObject);
    procedure SelectPageEffectMenuItemClick(Sender: TObject);
    procedure MenuCorrectTimerTimer(Sender: TObject);
    procedure DateContentPanelResize(Sender: TObject);
    procedure TimeContentPanelResize(Sender: TObject);
    procedure TemperatureContentPanelResize(Sender: TObject);
    procedure AnimationContentPanelResize(Sender: TObject);
    procedure DisplayStageMenuBtnClick(Sender: TObject);
    procedure sSpeedButton1Click(Sender: TObject);
    procedure AnimationTimingStyle1RadioClick(Sender: TObject);
    procedure FixedPictureRadioClick(Sender: TObject);
    procedure EffectsSpeedTrackbarChange(Sender: TObject);
    procedure ScrollingTextRadioClick(Sender: TObject);
    procedure AreaSizeSpinChange(Sender: TObject);
    procedure EmptyContentBtnClick(Sender: TObject);
    procedure NewShowBtnClick(Sender: TObject);
    procedure SetDateTimeBtnClick(Sender: TObject);
    procedure InputTextMixedRadioClick(Sender: TObject);
    procedure ProgramOptionsBtnClick(Sender: TObject);
    procedure TntFormShow(Sender: TObject);
    procedure Far6Click(Sender: TObject);
    procedure Far5Click(Sender: TObject);
    procedure Far7Click(Sender: TObject);
    procedure RegistrationPanelMouseMove(Sender: TObject;
      Shift: TShiftState; X, Y: Integer);
    procedure ProgressTimerTimer(Sender: TObject);
    procedure FontSizeWarningBtn1Click(Sender: TObject);
    procedure FontSizeWarningTimerTimer(Sender: TObject);
    procedure ForwardCurrentStageBtnClick(Sender: TObject);
    procedure BackwardCurrentStageBtnClick(Sender: TObject);
    procedure GotoLFGBtnClick(Sender: TObject);
    procedure SimpleTextTabBtnMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure AdvancedTextTabBtnMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure SelectScrollingTextDesignFileBtnClick(Sender: TObject);
    procedure SimpleTextTabBtnClick(Sender: TObject);
    procedure AdvancedTextTabBtnClick(Sender: TObject);
    procedure EditScrollingTextDesignFileBtnClick(Sender: TObject);
    procedure CreateScrollingTextDesignFileBtnClick(Sender: TObject);
    procedure ScrollingTextDesignFilePathLabelMouseEnter(Sender: TObject);
    procedure ScrollingTextDesignFilePathLabelMouseLeave(Sender: TObject);
    procedure ScrollingTextDesignFilePathLabelClick(Sender: TObject);
    procedure LFGFileSaveDialogCanClose(Sender: TObject;
      var CanClose: Boolean);
    procedure SimplePictureTabBtnClick(Sender: TObject);
    procedure AdvancedPictureTabBtnClick(Sender: TObject);
    procedure SimplePictureTabBtnMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure AdvancedPictureTabBtnMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure SelectPictureDesignFileBtnClick(Sender: TObject);
    procedure EditPictureDesignFileBtnClick(Sender: TObject);
    procedure CreatePictureDesignFileBtnClick(Sender: TObject);
    procedure PictureDesignFilePathLabelMouseEnter(Sender: TObject);
    procedure PictureDesignFilePathLabelMouseLeave(Sender: TObject);
    procedure PictureDesignFilePathLabelClick(Sender: TObject);
    procedure RefreshAdvancedTextPreviewBtnClick(Sender: TObject);
    procedure RefreshAdvancedPicturePreviewBtnClick(Sender: TObject);
    procedure ApplicationEvents1Activate(Sender: TObject);
    procedure PictureContentPanelResize(Sender: TObject);
    procedure ScrollingTextContentPanelResize(Sender: TObject);
    procedure SelectMusicBtnClick(Sender: TObject);
    procedure MusicBtnClick(Sender: TObject);
    procedure ApplyAfterShowConfigTimerTimer(Sender: TObject);
    procedure ChangeLEDDisplayDataMenuItem1Click(Sender: TObject);
    procedure ChangeLEDDisplayDataMenuItem2Click(Sender: TObject);
    procedure SetDateTimeMenuItem1Click(Sender: TObject);
    procedure SetDateTimeMenuItem2Click(Sender: TObject);
    procedure AddToFavoriteFontsBtnClick(Sender: TObject);
    procedure RemoveFromFavoriteFontsBtnClick(Sender: TObject);
    procedure SetAlarmsBtnClick(Sender: TObject);
    procedure GeneralEditPopupMenuPopup(Sender: TObject);
    procedure GECutPopupMenuItemClick(Sender: TObject);
    procedure GECopyPopupMenuItemClick(Sender: TObject);
    procedure GEPastePopupMenuItemClick(Sender: TObject);
    procedure SaveBtnClick(Sender: TObject);
    procedure OpenBtnClick(Sender: TObject);
    procedure SaveShowDialogCanClose(Sender: TObject;
      var CanClose: Boolean);
    procedure SaveDropDownBtnClick(Sender: TObject);
    procedure SaveMenuItemClick(Sender: TObject);
    procedure SaveAsMenuItemClick(Sender: TObject);
    procedure OpenDropDownBtnClick(Sender: TObject);
    procedure OpenShowDialogShow(Sender: TObject);
    procedure LicenseTimerTimer(Sender: TObject);
    procedure LFGFileSizeWarningBtn1Click(Sender: TObject);
    procedure HelpBtnClick(Sender: TObject);
    procedure ACWord1Enter(Sender: TObject);
    procedure ACWord1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ACWord1KeyPress(Sender: TObject; var Key: Char);
    procedure ACWord1Paste(Sender: TObject);
    procedure MediaPlayer1Notify(Sender: TObject);
    procedure EditBorderStyleSpeedBtnClick(Sender: TObject);
    procedure TopBorderLabelClick(Sender: TObject);
    procedure UseDefaultPicturesRadioClick(Sender: TObject);
    procedure DefaultPicturesComboChange(Sender: TObject);
    procedure ApplicationEvents1ShortCut(var Msg: TWMKey;
      var Handled: Boolean);
    procedure HighGUITimerTimer(Sender: TObject);
    procedure sSkinManager1AfterChange(Sender: TObject);
    procedure ApplicationEvents1Deactivate(Sender: TObject);
    procedure sSkinManager1BeforeChange(Sender: TObject);
    procedure PreviewPanelResize(Sender: TObject);
    procedure ScheduleStageBtnClick(Sender: TObject);
    procedure ScheduleStageMenuItemClick(Sender: TObject);
    procedure InputTextEnter(Sender: TObject);
    procedure Image10Click(Sender: TObject);
    procedure Image9Click(Sender: TObject);
    procedure PictureEntranceEffectImageClick(Sender: TObject);
    procedure TextEntranceEffectImageClick(Sender: TObject);
    procedure SystemFontsSectionChange(Sender: TObject);
    procedure SoundItemMediaPlayerNotify(Sender: TObject);
    procedure AnimationLineSummaryBtnClick(Sender: TObject);
    procedure Image12Click(Sender: TObject);
    procedure Image11Click(Sender: TObject);
    procedure ClockDigitsFarsiRadioClick(Sender: TObject);
    procedure DateDigitsFarsiRadioClick(Sender: TObject);
    procedure TimePreviewTimerTimer(Sender: TObject);
    procedure TempLangFarsiRadioClick(Sender: TObject);
    procedure EmptyAreaFilledRadioClick(Sender: TObject);
    procedure Image5Click(Sender: TObject);
    procedure Image6Click(Sender: TObject);
    procedure Image2Click(Sender: TObject);
    procedure Image4Click(Sender: TObject);
    procedure Image1Click(Sender: TObject);
    procedure Image3Click(Sender: TObject);
    procedure Image7Click(Sender: TObject);
    procedure Image8Click(Sender: TObject);
    procedure TemporaryDisableStageMenuItemClick(Sender: TObject);
    procedure SortAnimationLineByTimeMenuItemClick(Sender: TObject);
    procedure N9Click(Sender: TObject);
    procedure N10Click(Sender: TObject);
    procedure AnimationLineTimerTimer(Sender: TObject);
    procedure ShowWaitStateTimerTimer(Sender: TObject);
    procedure EditBorderStyleSpeedBtn2Click(Sender: TObject);
    procedure TextTotalDisplayTimeSpinChange(Sender: TObject);
    procedure TextRepetitionTimesSpinChange(Sender: TObject);
    procedure PictureTotalDisplayTimeSpinChange(Sender: TObject);
    procedure PictureRepetitionTimesSpinChange(Sender: TObject);
    procedure AnimationTotalDisplayTimeSpinChange(Sender: TObject);
    procedure AnimationRepetitionTimesSpinChange(Sender: TObject);
    procedure ImportSMSPicBtnClick(Sender: TObject);
    procedure SelectDefaultPictureBtnClick(Sender: TObject);
    procedure ApplicationEvents1Exception(Sender: TObject; E: Exception);
    procedure N8Click(Sender: TObject);
    procedure FullBorderBtnClick(Sender: TObject);
    procedure NoBorderBtnClick(Sender: TObject);
    procedure DatePreviewTimerTimer(Sender: TObject);
    procedure PageEffectImageClick(Sender: TObject);
    procedure NoPageEffectLabelClick(Sender: TObject);
    procedure AddNewAnimationBtnClick(Sender: TObject);
    procedure AnimationLineWhiteImageContextPopup(Sender: TObject;
      MousePos: TPoint; var Handled: Boolean);
    procedure sPanel5ContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
    procedure AnimationLineScrollBoxContextPopup(Sender: TObject;
      MousePos: TPoint; var Handled: Boolean);
    procedure ShowPreviewBtnClick(Sender: TObject);
    procedure AutoPreviewCheckClick(Sender: TObject);
    procedure OpenSWFFileBtnClick(Sender: TObject);
    procedure SWFContentBtnClick(Sender: TObject);
    procedure SWFContentPanelResize(Sender: TObject);
    procedure SetOffTimeBtnClick(Sender: TObject);
    procedure ModelOKBtnClick(Sender: TObject);
    procedure SWFSensitivityTrackBarChange(Sender: TObject);
    procedure SWFPreviewBtnClick(Sender: TObject);
  private
    { Private declarations }
    ModelOKBtnClicked: Boolean;
    
    SelectionInProgress: Boolean;

    LoadingContent: Boolean;
    ResetingContentPages: Boolean;

    LCDFonts: TLCDFontList;

    //Recently used file list
    RUFL: TTntStringList;
    RUFLLastOpenedFile: WideString;

    //License
    LicenseWasValid: Boolean;
    HaltIfInvalidState: Boolean;
    ISPrevSNEdit: Boolean;

    MusicFilesList: TTntStringList;

    DesignChangeFlag: Boolean;
    ForceDesignNotChanged: Boolean;

    HighGUIItems: THighGUIItems;
    HighGUISkinInfo: THighGUISkinInfo;

    //FadedDraw: TFadedDraw;

    LoadingConfig: Boolean;

    RARFileList: TTntStringList;

    LED_DISPLAY_MEM_START_OFFSET: Integer;

    procedure SetMessageDlgCaptions;

    procedure SetStagePanelDefaults(StagePanel: TsStagePanel);
    procedure StagePanelClick(Sender: TObject);
    procedure StagePanelDblClick(Sender: TObject);

    procedure SetStageDefaults(var Stage: TStage);

    function GenerateAllData(var Data: TDataArray): Boolean;

    procedure LoadAreaSpecificSettings(const Area: TArea);
    procedure LoadTimeContent(const Area: TArea);
    procedure LoadDateContent(const Area: TArea);
    procedure LoadTemperatureContent(const Area: TArea);
    procedure LoadEmptyContent(const Area: TArea);
    procedure LoadScrollingTextContent(const Area: TArea);
    procedure LoadSWFContent(const Area: TArea);
    procedure LoadAnimationContent(const Area: TArea);
    procedure LoadPictureContent(const Area: TArea);

    procedure ResetAllContentPages;

    procedure UpdateHxW(Font: TFont; HxWPanel: TTntPanel; Text: WideString);
    function PerformTextToLCDFromSystemFonts: Boolean;
    procedure UpdateTextPicturePreview;

    procedure UpdatePicturePicturePreview(OnlyClearPreview: Boolean = False);
    procedure UpdateTimePicturePreview;
    procedure UpdateDatePicturePreview;
    procedure UpdateTemperaturePicturePreview;
    procedure UpdateEmptyPicturePreview;

    procedure GetLCDFontList(var LCDFontList: TLCDFontList);

    function LoadLCDFontPreviewImage(const ImageFileName: WideString;
      PreviewImage: TImage): Boolean;
    procedure GenerateLCDFontPreviewImage(PreviewImage: TImage;
      Language: TLanguage);

    procedure SetLength_DisplayStages(var Stages: TStagesArray;
      NewSize: Integer);
    procedure FreeUpDisplayStage(var Stage: TStage);

    procedure SetupApplicationCursors;

    procedure ReadProgramSettings;
    procedure WriteProgramSettings;
    procedure LoadDefaultConfig(var AGlobalOptions: TGlobalOptions);
    procedure LoadRuntimeDefaultConfig(
      var ARuntimeGlobalOptions: TRuntimeGlobalOptions);
    procedure ApplyStartupConfig;
    procedure ApplyStartupOnShowConfig;
    procedure ApplyStartupAfterShowConfig;

    procedure UpdateLEDDisplayInfo;

    procedure PrepareAreaSizeSection(AreaIndex: Integer);
    function GetAreaSizeToChange(const Area: TArea): Integer;
    procedure SetAreaSizeToChange(AreaIndex: Integer; NewSize: Integer);
    procedure ActiveAreaSizeChanged;

    procedure PrepareRegistrationPanelView;
    procedure ApplyLicenseStatus(Enabled: Boolean);

    procedure LoadApplicationResources;

    procedure BuildMusicMenu;

    procedure MusicMenuItemClick(Sender: TObject);

    procedure WriteInstallDirRegistryEntry(WriteValues: Boolean);

    procedure SelectStagePanel(const Stage: TStage; ScrollToShow: Boolean);

    function SaveShowToFile(const FName: WideString): Boolean;
    function OpenShowFromFile(const FName: WideString): Boolean;

    function CreateEmptyLFGDesignFile(const FName: String;
      Width, Height: Integer): Boolean;

    procedure CreateAndSetApplicationDefaultFolders;

    procedure HighGUIInitialize;
    procedure HighGUIOnSkinChanged;
    procedure HighGUISetActive(Component: TComponent);
    procedure HighGUISetInactive(Component: TComponent);

    procedure ApplySkinExceptions;

    procedure PrepareRightPanel;

    function DisplaySettingsEqual(const DS1, DS2: TLEDDisplaySettings;
      CompareAllSettings: Boolean): Boolean; overload;
    function DisplaySettingsEqual(const DS1: TLEDDisplaySettings;
      const DS2FormFile: TLEDDisplaySettingsForFile;
      CompareAllSettings: Boolean): Boolean; overload;

    function ValidateStagesData(const Stages: TStagesForFileArray): Boolean;
    function ValidateLEDDisplaySettings(
      LEDDisplaySettings: TLEDDisplaySettings): Boolean; overload;
    function ValidateLEDDisplaySettings(
      LEDDisplaySettings: TLEDDisplaySettingsForFile): Boolean; overload;

    procedure SortAnimationLineByTime(Confirm, ShowMessage: Boolean);

    procedure WindowSize(var msg: TWMSize); message WM_SIZE;

    procedure RAROnListFileEventHandler(Sender: TObject;
      const FileInformation:TRARFileItem);
    procedure RAROnPasswordRequiredEventHandlerprocedure(Sender: TObject;
      const HeaderPassword:boolean; const FileName:AnsiString;
      out NewPassword:AnsiString; out Cancel:boolean);
    procedure SetupApplicationDataFiles;

    procedure CopyStage(SourceStageIndex, DesStageIndex: Integer);
  public
    { Public declarations }
    Data: TDataArray;

    ContentControls: array[Ord(Low(TContentType))..Ord(High(TContentType))] of TContentControl;
    DisplayStages: TStagesArray;
    OldDisplayStages: TStagesArray;

    ActiveDisplayStage: Integer;
    ActiveAreaIndex: Integer;

    LCDGIFAnimations: TLCDGIFAnimations;

    DefaultPictures: TDefaultPictures;

    WorkingDesignFileName: WideString;
    WorkingDesignIsReadOnly: Boolean;
    WorkingDesignUntitledCount: Integer;
    UntitledDesignFile: Boolean;

    LastChangeDisplayTickCount: Cardinal;

    function CommunicationWithLEDDisplayAllowed(ShowErrMessage: Boolean): Boolean;

    procedure PrepareEnvironmentForContent(ContentType: TContentType);
    procedure GetContentBitmap(ContentType: TContentType; Image, TextImage: TBitmap);
    procedure SelectContent(ContentType: TContentType;
      CallDisableOtherContents: Boolean);
    procedure DisableOtherContents(ContentType: TContentType);
    function NewStage(AutoSelect: Boolean;
      AfterThisStage: Integer = -2; ScrollToShow: Boolean = True; CopyOfActiveStage: Boolean = False): Integer;
    procedure SelectStage(StageIndex: Integer; ForceRefresh: Boolean; SaveActiveAreaSettings: Boolean = True);
    procedure DeleteStage(StageIndex: Integer; ScrollToShow: Boolean = True);
    procedure PositionStagePanel(StageIndex: Integer);

    procedure SetupLayout(Areas: TAreasArray;
      LayoutBtn1, LayoutBtn2, LayoutBtn3, LayoutBtn4: TsSpeedButton;
      LayoutContainer: TsGroupBox);

    procedure SaveAreaSettings(AreaIndex: Integer);
    procedure SelectArea(AreaIndex: Integer; SaveCurrentArea: Boolean);

    procedure LoadContentDefaultSettings(var Area: TArea);

    procedure LayoutChanged;

    procedure ApplyFontSectionSettings;

    function FindFont(const FontName: WideString; FontLanguage: TLanguage;
      var LCDFont: TLCDFont): Boolean;

    procedure GetFontSettings(Font: TFont; var AFontSettings: TFontSettings);
    procedure SetFontSettings(Font: TFont; const AFontSettings: TFontSettings);
    procedure PrepareFontSectionControls;

    function ConvertBinToHex(const BinStr: String): String;

    procedure GetGIFAnimationsList(var AnimList: TLCDGIFAnimations);

    function SpeedIndexToSpeedValue(SpeedIndex: Integer): Integer;

    function FitImageToArea(Bitmap: TBitmap; const Area: TArea; FitWidth: Boolean): Boolean;

    procedure LCDToBitmap(ALCD: TAdvStringGrid; ABitmap: TBitmap;
      ReserveOneColForTransparency: Boolean);
    procedure BitmapToLCD(Bitmap: TBitmap; ALCD: TAdvStringGrid;
      NumOfColsToIgnoreFromLeft: Integer; AdvGridCompensation: Boolean);

    procedure SetCellColor(ALCDGrid: TAdvStringGrid; ACol, ARow: Integer;
      Filled: Boolean);
    procedure ToggleCellColor(ALCDGrid: TAdvStringGrid; ACol, ARow: Integer);
    procedure InvertLCD(ALCD: TAdvStringGrid; OnlySelection: Boolean = False);

    procedure DisplayNormalEffect(Image: TImage; EffectID: Integer;
      AnimSpeed: Integer);
    procedure DisplayPageEffect(Image: TImage; EffectID: Integer);

    procedure ClearImage(Image: TImage);

    function IsUnusedArea(const Area: TArea): Boolean; overload;
    function IsUnusedArea(const Area: TAreaForFile): Boolean; overload;

    procedure RefreshStagePanels;
    procedure RefreshStagePanelsAppearance;

    procedure UpdateEnvironmentForAreaSelection(AreaIndex: Integer);

    procedure PrepareContentControls(ContentType: TContentType);

    function ReplaceInvalidUnicodeChars(const Str: WideString): WideString;
    procedure SetDynamicTexts(LangInstance: THandle);
    procedure LoadLanguageResources;

    procedure ShowProgress;
    procedure HideProgress;

    procedure ShowFontSizeWarning(Show: Boolean);

    procedure StartNewShow;

    procedure ExchangeStages(Stage1Index, Stage2Index: Integer);

    procedure ChangeKeyboardLanguage(Language: TLanguage);

    procedure RunLFG4LDC(const CmdLineParameters: String; ShowErrorMessage: Boolean);
    procedure OpenFileWithLFG4LDC(const FileName: String);

    function PromptForFileReplace(const FileName,
      Extension {Format: .xxxx (is not case sensitive)}: WideString;
      ForceExtension: Boolean = False): Boolean;

    function InformForReadOnlySelectedFile(const FName: WideString): Boolean;

    procedure ColorizeLCDGrid(ALCDGrid: TAdvStringGrid; FilledColor,
      ClearedColor: TColor; ClearText: Boolean = True);

    function LoadLFGDesignFromFile(ALCDGrid: TAdvStringGrid;
      const FName: String): Boolean;
    function OpenLFGFile(const LFGFileName: String; DesGrid: TAdvStringGrid): Boolean;

    procedure ShowAdvancedTextPreview(const LFGFileName: String);
    procedure ShowAdvancedPicturePreview(const LFGFileName: String);

    function SetCorrectKeyboardLayout: TBiDiMode;

    function GetSkinNumber: Integer;
    procedure SetSkin(SkinNumber: Integer);

    procedure SetLEDDisplayDateTime(LEDDisplayNumber: Integer);
    procedure ChangeLEDDisplayData(LEDDisplayNumber: Integer;
      OnlySaveToFile: Boolean; OnlyOpenFromFile: Boolean);

    function GetCOMPort(LEDDisplayNumber: Integer): TPortNumber;

    procedure WorkingOnNewDesignStarted(const OldFullFName,
      NewFullFName: WideString);
    function WorkingDesignChanged: Boolean;
    procedure UpdateMainFormCaption;
    procedure OnCaptionChanged;
    function CanProceedToOpenDesign(const DesignFileName: WideString): Boolean;
    procedure InitiateNewWorkingDesign;
    function OpenPresentationFile(const FName: WideString): Boolean;

    procedure DisableAllMenuChanges(Disabled: Boolean);
    procedure RUFLMenuItemClicked(Sender: TObject);
    procedure RUFLAdd(const FullFileName: WideString);
    procedure RUFLRemove(const FullFileName: WideString;
      RebuildMenuItems: Boolean = True);
    procedure RUFLReadEntries;
    procedure RUFLWriteEntries;
    procedure RUFLBuildMenuItems;

    procedure ProcessCommandLine;

    procedure OnLEDDisplaySettingsChanged;

    procedure GetDefaultPicturesList(var PictureList: TDefaultPictures);

    procedure TemporaryLEDDisplaySettingsMode(ModeOn: Boolean);

    function TimeSpanDefined(HourFrom, MinuteFrom, HourTo,
      MinuteTo: Integer): Boolean;

    function AnimSpeedToGIFAnimationSpeed(AnimSpeed: Integer): Integer;

    procedure WideLoadGIFImageFromFile(GIFFileName: WideString;
      GIFImage: TGIFImage);
    procedure WideLoadBitmapImageFormFile(BitmapImageFileName: WideString;
      Bitmap: TBitmap);

    procedure PlaySound(SoundItem: TSoundItem);

    procedure OnNewStagePanelAdded;

    function NewGroupBoxFromRef(Ref: TsGroupBox; P: TWinControl; Owner: TComponent): TsGroupBox;
    function NewLabelFromRef(Ref: TsLabel; P: TWinControl; Owner: TComponent): TsLabel;
    function NewCheckFromRef(Ref: TsCheckBox; P: TWinControl; Owner: TComponent; const NameValue: String): TsCheckBox;
    function NewSpinFromRef(Ref: TsSpinEdit; P: TWinControl; Owner: TComponent; const NameValue: String): TsSpinEdit;
    function NewComboFromRef(Ref: TsComboBox; P: TWinControl; Owner: TComponent; const NameValue: String): TsComboBox;
    function NewRadioBoxFromRef(Ref: TsRadioButton; P: TWinControl; Owner: TComponent; const NameValue: String): TsRadioButton;

    function GetAreaContentDescription(const Area: TArea): WideString;

    procedure CopyLEDDisplaySettings(const FromDS: TLEDDisplaySettings;
      var ToDSForFile: TLEDDisplaySettingsForFile); overload;
    procedure CopyLEDDisplaySettings(const FromDSForFile: TLEDDisplaySettingsForFile;
      var ToDS: TLEDDisplaySettings); overload;

    procedure ShowWaitState(WateState: TWaitState;
      NoWaitTimeMilliseconds: Cardinal);
    procedure HideLastWaitState;

    procedure HighGUIUpdateState(SelfForm: TCustomForm; HighGUITimer: TTimer;
      HighGUIItems: THighGUIItems);

    procedure OnDataExchangeStarted;
    procedure OnDataExchangeFinished;

    function CalculateCRC32(Data: array of Byte): LongWord;

    function LoadGIFFromResource(const ResName: String;
      Picture: TPicture): Boolean;

    procedure NormalizeBitmapForeground(Bitmap: TBitmap);

    procedure ScaleBitmapToAreaHeight(Bitmap: TBitmap; AreaHeight: Integer);

    procedure SetAreaUnused(var Area: TArea);

    function CountStageUsedAreas(Stage: TStage): Integer;

    procedure PutLCDAtCenter(ALCD: TAdvStringGrid; AreaWidth: Integer);
    procedure PutLCDBitmapAtCenter(ALCDBitmap: TBitmap; AreaWidth: Integer);

    procedure CheckAlSerialPortObjectsToBeClosed;

    procedure GetSWFInfo(Stream: TStream; var SWFInfo: TSWFInfo);

    function CalculateFrameDelayMultiplier(SpeedIndex: Integer): Double;
  end;

var
  MainForm: TMainForm;
  GlobalOptions: TGlobalOptions;
  RuntimeGlobalOptions: TRuntimeGlobalOptions;
  ApplicationPath: String;
  ApplicationState: set of TApplicationState;

  //Multilanguage
  Dyn_Texts: array[1..DYNAMIC_TEXTS_COUNT] of WideString;
  DIALOGS_TITLE: WideString = SOFTWARE_NAME;
  ///////////////

  //*******************************************
  //These variables are used as temporary variables in the CheckLicenseStatus
  // function in the License.pas.
  CUID: String = '';
  ActivationCode: String = '';
  SecurityCode: String = '';
  //*******************************************

implementation

uses Math, License3, License2, License4, License5, License6, License,
  HowToBuyFormUnit, SetOffTimeFormUnit, CreateSupportFileFormUnit;

{$R *.dfm}

procedure TMainForm.AboutBtnClick(Sender: TObject);
begin
  with TAboutForm.Create(nil) do
  begin
    ShowModal;
    Free;
  end;
end;

procedure TMainForm.ComboBox1Change(Sender: TObject);
begin
//  ImportPictureBtn.SkinData.SkinSection := ComboBox1.Text;
//  ImportSMSPicBtn.SkinData.SkinSection := ComboBox1.Text;
//  RuntimeGlobalOptions.PopupFormsMainPanelSkin := ComboBox1.Text;
//  FontSamplePanel.SkinData.SkinSection := ComboBox1.Text;
//  DisplayStages[ActiveDisplayStage].StagePanel.SkinData.SkinSection := ComboBox1.Text;
//  MenuPanel.SkinData.SkinSection := ComboBox1.Text;
//  ChangeLEDDisplaySettingsBtn.SkinData.SkinSection := ComboBox1.Text;
//  LayoutBtn1.SkinData.SkinSection := ComboBox1.Text;
//  LayoutBtn2.SkinData.SkinSection := ComboBox1.Text;
//  LayoutBtn3.SkinData.SkinSection := ComboBox1.Text;
//  LayoutBtn4.SkinData.SkinSection := ComboBox1.Text;
//  AreaSizeSpin.SkinData.SkinSection := ComboBox1.Text;
//  sGroupBox29.CaptionSkin := ComboBox1.Text;
//  sLabel4.SkinSection := ComboBox1.Text;
end;

procedure TMainForm.ExitBtnClick(Sender: TObject);
begin
  Close;
end;

procedure TMainForm.SelectContent(ContentType: TContentType;
  CallDisableOtherContents: Boolean);
var
  i: Integer;
  ct: TContentType;
begin
  if SelectionInProgress then
    Exit;
  SelectionInProgress := True;

  MenuCorrectTimer.Enabled := False;

  (ContentControls[Ord(ContentType)].Button as TsSpeedButton).Down := True;

  for ct := Low(TContentType) to High(TContentType) do
    ContentControls[Ord(ct)].OptionsPage.Enabled := True;

  ContentControls[Ord(ContentType)].OptionsPage.BringToFront;
  TitlePanel.BringToFront;
  TitleImage.Picture.Bitmap.Width := 0;
  TitleImage.Picture.Bitmap.Height := 0;
  ContentTextImage.Picture.Bitmap.Width := 0;
  ContentTextImage.Picture.Bitmap.Height := 0;
  GetContentBitmap(ContentType, TitleImage.Picture.Bitmap, ContentTextImage.Picture.Bitmap);
  ContentTitleLabel.Caption := (ContentControls[Ord(ContentType)].Button as TsSpeedButton).Caption;
  {
  FadedDraw.BackColor := clNone; //TitleImage.Picture.Bitmap.Canvas.Pixels[0, TitleImage.Picture.Bitmap.Height - 1];
  FadedDraw.BackBitmap.Assign(TitleImage.Picture.Bitmap);
  FadedDraw.SourceBitmap.Assign(TitleImage.Picture.Bitmap);
  FadedDraw.FadeIn;
  }

  if ContentType = ctScrollingText then
  begin
    if InputTextFarsiRadio.Checked or InputTextMixedRadio.Checked then
      ChangeKeyboardLanguage(laFarsi)
    else
      ChangeKeyboardLanguage(laEnglish);
  end
  else
    ChangeKeyboardLanguage(laEnglish);

  PrepareEnvironmentForContent(ContentType);

  if CallDisableOtherContents then
    DisableOtherContents(ContentType);

  //TitleImage.Picture.Graphic := (ContentControls[i].Button as TsSpeedButton).Glyph;

  try
    LayoutPanel.Enabled := False;
    for i := Low(ContentControls) to High(ContentControls) do
      SpecialProcs.GrowShrink(ContentControls[i].Button, gdToLeft, 117, 12, 3);
    SpecialProcs.GrowShrink(ContentControls[Ord(ContentType)].Button, gdToLeft, 164, 4, 3);
  finally
    LayoutPanel.Enabled := True;
  end;
  DisplayStages[ActiveDisplayStage].Areas[ActiveAreaIndex].ContentType := ContentType;

  RefreshStagePanels;

  MenuCorrectTimer.Enabled := True;

  SelectionInProgress := False;
end;

procedure TMainForm.TntFormCreate(Sender: TObject);
var
  i: Integer;
//  b: TBitmap;
  LicenseModel: TLicenseModel;
begin
  ModelOKBtnClicked := False;

  //License
  LicenseWasValid := False;
  ModelsListBox.Items.Clear;
  SoftwareNameLabelEn.Caption := SOFTWARE_NAME;
  {$IFDEF FULL_BRIGHT}
  ModelsListBox.Items.Assign(FullBrightModelList.Items);
  SoftwareNameLabelFa.Visible := False;
  {$ENDIF}
  {$IFDEF NORMAL_MODEL}
  ModelsListBox.Items.Assign(NormalModelList.Items);
  SoftwareNameLabelFa.Visible := True;
  {$ENDIF}
  FullBrightModelList.Free;
  NormalModelList.Free;

  RuntimeGlobalOptions.UsingTemporaryLEDDisplaySettings := False;
  RuntimeGlobalOptions.FirstUserRun := False;

  RuntimeGlobalOptions.AppearanceDefaultHueOffset := sSkinManager1.HueOffset;
  RuntimeGlobalOptions.AppearanceDefaultSkinNumber := GetSkinNumber;

  RuntimeGlobalOptions.HighGUIDeactivatedByLicense := False;

  RuntimeGlobalOptions.ShowTextPreview := True;

  ApplySkinExceptions;

  HighGUIInitialize;

  if (Win32Platform = VER_PLATFORM_WIN32s) or
     (Win32Platform = VER_PLATFORM_WIN32_WINDOWS) then
  begin
    Halt;  //Not allowed to be run in older versions of Windows
    //This windows version is a windows older than NT (and maybe not unicode)
  end;

  //Check Admin again
  if not Procs.IsWindowsAdmin then
    Halt;

  //License Step 1
  LicenseModel := License.DetermineRegisteredLicenseModel;
  if License2.DetermineRegisteredLicenseModel <> LicenseModel then
    Halt;
  if License3.DetermineRegisteredLicenseModel <> LicenseModel then
    Halt;
  if License4.DetermineRegisteredLicenseModel <> LicenseModel then
    Halt;
  if License5.DetermineRegisteredLicenseModel <> LicenseModel then
    Halt;
  if License6.DetermineRegisteredLicenseModel <> LicenseModel then
    Halt;

  if LicenseModel <> lmNone then
  begin
    License.SelectLicenseModel(LicenseModel);
    License2.SelectLicenseModel(LicenseModel);
    License3.SelectLicenseModel(LicenseModel);
    License4.SelectLicenseModel(LicenseModel);
    License5.SelectLicenseModel(LicenseModel);
    License6.SelectLicenseModel(LicenseModel);
    LicenseWasValid := License3.CheckLicenseStatusFull;
  end
  else
    LicenseWasValid := False;
  ////////////////

  //Load language resources from the application main file
  LoadLanguageResources;

  //Set all message dialog captions to application name
  { Standard Dialogs }
  Dialogs.MessageCaptions[mtWarning] := Application.Title;  //SMsgDlgWarning;
  Dialogs.MessageCaptions[mtError] := Application.Title;  //SMsgDlgError;
  Dialogs.MessageCaptions[mtInformation] := Application.Title;  //SMsgDlgInformation;
  Dialogs.MessageCaptions[mtConfirmation] := Application.Title;  //SMsgDlgConfirm;
  Dialogs.MessageCaptions[mtCustom] := Application.Title;  //Application.Title;

  { sTntDialogs }
  TntDialogs.MessageCaptions[mtWarning] := DIALOGS_TITLE;  //SMsgDlgWarning;
  TntDialogs.MessageCaptions[mtError] := DIALOGS_TITLE;  //SMsgDlgError;
  TntDialogs.MessageCaptions[mtInformation] := DIALOGS_TITLE;  //SMsgDlgInformation;
  TntDialogs.MessageCaptions[mtConfirmation] := DIALOGS_TITLE;  //SMsgDlgConfirm;
  TntDialogs.MessageCaptions[mtCustom] := DIALOGS_TITLE;  //Application.Title;

  { sTntDialogs }
  sTntDialogs.MessageCaptions[mtWarning] := DIALOGS_TITLE;  //SMsgDlgWarning;
  sTntDialogs.MessageCaptions[mtError] := DIALOGS_TITLE;  //SMsgDlgError;
  sTntDialogs.MessageCaptions[mtInformation] := DIALOGS_TITLE;  //SMsgDlgInformation;
  sTntDialogs.MessageCaptions[mtConfirmation] := DIALOGS_TITLE;  //SMsgDlgConfirm;
  sTntDialogs.MessageCaptions[mtCustom] := DIALOGS_TITLE;  //Application.Title;

  { BiDiDialogs }
  BiDiDialogs.BiDiMessageCaptions[mtWarning] := Application.Title;  //SMsgDlgWarning;
  BiDiDialogs.BiDiMessageCaptions[mtError] := Application.Title;  //SMsgDlgError;
  BiDiDialogs.BiDiMessageCaptions[mtInformation] := Application.Title;  //SMsgDlgInformation;
  BiDiDialogs.BiDiMessageCaptions[mtConfirmation] := Application.Title;  //SMsgDlgConfirm;
  BiDiDialogs.BiDiMessageCaptions[mtCustom] := Application.Title;  //Application.Title;

  //Set message dialog buttons cursor
  Dialogs.MessageDlgButtonCursor := crHandPoint;
  TntDialogs.MessageDlgButtonCursor := crHandPoint;
  sTntDialogs.MessageDlgButtonCursor := crHandPoint;
  BiDiDialogs.BiDiMessageDlgButtonCursor := crHandPoint;

  {All captions of the message dialogs are in English, so always display the
   caption in a Left-to-Right alignment even if the active language is a
   Right-to-Left aligned language.}
  Dialogs.ForceDlgCaptionLeftToRight := True;
  TntDialogs.ForceDlgCaptionLeftToRight := False;
  sTntDialogs.ForceDlgCaptionLeftToRight := False;
  /////////////////////////////////////////////////////

  HaltIfInvalidState := False;

  //Language initialization
  Application.BiDiMode := bdRightToLeft;
  SysLocale.MiddleEast := True;

  //Correct BiDiMode bug in InputText
  InputText.BiDiMode := bdLeftToRight;
  InputText.BiDiMode := bdRightToLeft;

  ApplicationPath := ExtractFilePath(Application.ExeName);

  ///////////////////////
  InitializeTyperModules;  //This must be invoked after the ApplicationPath is set correctly
  ///////////////////////

  {$ifndef _AREA_BORDERS_ACTIVE_}
  AreaBorderGroup.Visible := False;
  AreaColorGroup.Left := AreaDelayGroup.Left;
  AreaDelayGroup.Left := AreaBorderGroup.Left;
  {$endif}

  //Initialize TFadedDraw component
  {
  try
    FadedDraw := TFadedDraw.Create(Self);
    FadedDraw.Enabled := False;
    FadedDraw.FadeInterval := 50;
    FadedDraw.FadeStep := 9;
    FadedDraw.DrawingImage := FadedTitleImage;
    //FadedDraw.BackColor := clBtnFace;
    FadedDraw.MaxFadePercent := 100;
    FadedDraw.MinFadePercent := 0;
  except
  end;
  }

  CreateAndSetApplicationDefaultFolders;
  SetupApplicationDataFiles;

  try
    SetupApplicationCursors;
    LoadApplicationResources;
  except
  end;

  BuildMusicMenu;

  //Initialize content types
  ContentControls[Integer(ctTime)].Button := TimeContentBtn;
  ContentControls[Integer(ctTime)].OriginalPositionInRightPanel := TimeContentBtn.BoundsRect.TopLeft;
  ContentControls[Integer(ctTime)].OptionsPage := TimeContentPanel;
  ContentControls[Integer(ctTime)].DefaultControl := ClockDigitsFarsiRadio;

  ContentControls[Integer(ctDate)].Button := DateContentBtn;
  ContentControls[Integer(ctDate)].OriginalPositionInRightPanel := DateContentBtn.BoundsRect.TopLeft;
  ContentControls[Integer(ctDate)].OptionsPage := DateContentPanel;
  ContentControls[Integer(ctDate)].DefaultControl := DateDigitsFarsiRadio;

  ContentControls[Integer(ctScrollingText)].Button := ScrollingTextContentBtn;
  ContentControls[Integer(ctScrollingText)].OriginalPositionInRightPanel := ScrollingTextContentBtn.BoundsRect.TopLeft;
  ContentControls[Integer(ctScrollingText)].OptionsPage := ScrollingTextContentPanel;
  ContentControls[Integer(ctScrollingText)].DefaultControl := SimpleTextTabBtn;

  ContentControls[Integer(ctAnimation)].Button := AnimationContentBtn;
  ContentControls[Integer(ctAnimation)].OriginalPositionInRightPanel := AnimationContentBtn.BoundsRect.TopLeft;
  ContentControls[Integer(ctAnimation)].OptionsPage := AnimationContentPanel;
  ContentControls[Integer(ctAnimation)].DefaultControl := AnimationListGroupBox;

//  ContentControls[Integer(ctPageEffect)].Button := PageEffectContentBtn;
//  ContentControls[Integer(ctPageEffect)].OriginalPositionInRightPanel := PageEffectContentBtn.BoundsRect.TopLeft;
//  ContentControls[Integer(ctPageEffect)].OptionsPage := PageEffectContentPanel;
//  ContentControls[Integer(ctPageEffect)].DefaultControl := PageEffectContentPanel;

  ContentControls[Integer(GlobalTypes.ctPicture)].Button := PictureContentBtn;
  ContentControls[Integer(GlobalTypes.ctPicture)].OriginalPositionInRightPanel := PictureContentBtn.BoundsRect.TopLeft;
  ContentControls[Integer(GlobalTypes.ctPicture)].OptionsPage := PictureContentPanel;
  ContentControls[Integer(GlobalTypes.ctPicture)].DefaultControl := SimplePictureTabBtn;

  ContentControls[Integer(ctTemperature)].Button := TemperatureContentBtn;
  ContentControls[Integer(ctTemperature)].OriginalPositionInRightPanel := TemperatureContentBtn.BoundsRect.TopLeft;
  ContentControls[Integer(ctTemperature)].OptionsPage := TemperatureContentPanel;
  ContentControls[Integer(ctTemperature)].DefaultControl := TempLangFarsiRadio;

  ContentControls[Integer(ctEmpty)].Button := EmptyContentBtn;
  ContentControls[Integer(ctEmpty)].OriginalPositionInRightPanel := EmptyContentBtn.BoundsRect.TopLeft;
  ContentControls[Integer(ctEmpty)].OptionsPage := EmptyContentPanel;
  ContentControls[Integer(ctEmpty)].DefaultControl := EmptyAreaFilledRadio;

  ContentControls[Integer(ctSWF)].Button := SWFContentBtn;
  ContentControls[Integer(ctSWF)].OriginalPositionInRightPanel := SWFContentBtn.BoundsRect.TopLeft;
  ContentControls[Integer(ctSWF)].OptionsPage := SWFContentPanel;
  ContentControls[Integer(ctSWF)].DefaultControl := OpenSWFFileBtn;

  LoadingContent := False;
  ResetingContentPages := False;

  ///////////////////////////////////////////////////////////
  //It is necessary to get list of LCD fonts before calling ApplyStartupConfig, because it uses items in FarsiLCDFontsCombo and EnglishLCDFontsCombo.
  AllFontsCombo.Items.Assign(Screen.Fonts);
  AllFontsCombo.ItemIndex := AllFontsCombo.IndexOf('Tahoma');
  GetLCDFontList(LCDFonts);
  for i := 0 to High(LCDFonts) do
    if LCDFonts[i].Language = laFarsi then
      FarsiLCDFontsCombo.Items.Append(LCDFonts[i].Name)
    else if LCDFonts[i].Language = laEnglish then
      EnglishLCDFontsCombo.Items.Append(LCDFonts[i].Name);
  if FarsiLCDFontsCombo.Items.Count > 0 then
    FarsiLCDFontsCombo.ItemIndex := 0;
  if EnglishLCDFontsCombo.Items.Count > 0 then
    EnglishLCDFontsCombo.ItemIndex := 0;
  ///////////////////////////////////////////////////////////

  LoadRuntimeDefaultConfig(RuntimeGlobalOptions);
  try
    ReadProgramSettings;
  except
    WideMessageDlgSoundTop(Dyn_Texts[2] {'Occured an error while reading configuration. Default configuration loaded.'}, mtError, [mbOK], 0);
    LoadDefaultConfig(GlobalOptions);
    ApplyStartupConfig;
  end;

  WriteInstallDirRegistryEntry(False);  //Only check if this is the first time the user runs the program (don't write any values)

{  b := TBitmap.Create;
  b.Width := 10;
  b.Height := 10;
  b.Canvas.TextOut(0, 0, 'Hello');
  PicturePreviewImage.Picture.Bitmap.Assign(b);
  b.Free;
  UpdatePicturePicturePreview}

  GetGIFAnimationsList(LCDGIFAnimations);
  GIFAnimationsList.Items.Clear;
  for i := 0 to High(LCDGIFAnimations) do
    GIFAnimationsList.Items.Insert(i, LCDGIFAnimations[i].Description);

  GetDefaultPicturesList(DefaultPictures);
  //DefaultPicturesCombo.Items.Clear;
  //for i := 0 to High(DefaultPictures) do
  //  DefaultPicturesCombo.Items.Insert(i, DefaultPictures[i].Description);


  //Initialize animation line
  WorkingDesignUntitledCount := 0;
  //StartNewShow;
  ForceDesignNotChanged := True;
  NewShowBtn.Click;
  ForceDesignNotChanged := False;

  //License
  RegistrationPanel.Top := Trunc(MainForm.Height / 2 - RegistrationPanel.Height / 2);
  RegistrationPanel.Left := Trunc(MainForm.Width / 2 - RegistrationPanel.Width / 2) - 50;

  if not LicenseWasValid then
  begin
    //Self.Width := 800;
    //Self.Height := 620;
    Procs.SetWindowPosition(Self, poDesktopCenter, True);

    PrepareRegistrationPanelView;
    RegistrationPanel.Visible := True;
    HaltIfInvalidState := True;
    ApplyLicenseStatus(False);
  end
  else
    ProcessCommandLine;

   //a1.x1 := 0; a1.x2 := 63; a1.y1 := 0; a1.y2 := 15;
   //a2 := a1;
   //SetupLayout(a1, a2, a3, a4);
end;

procedure TMainForm.TimeContentBtnClick(Sender: TObject);
begin
  //************************************
  if not License3.CheckLicenseStatus then
    Halt;
  if not LicenseTimer.Enabled then
    LicenseTimer.Enabled := True;
  //************************************

  SelectContent(ctTime, True);  //don't use the Tag property because the order of values and buttons may be changed in future
  UpdateTimePicturePreview;
end;

procedure TMainForm.DateContentBtnClick(Sender: TObject);
begin
  SelectContent(ctDate, True);
  UpdateDatePicturePreview;

  //************************************
  if not License5.CheckLicenseStatus then
    Halt;
  if not LicenseTimer.Enabled then
    LicenseTimer.Enabled := True;
  //************************************
end;

procedure TMainForm.ScrollingTextContentBtnClick(Sender: TObject);
begin
  //************************************
  if not License.CheckLicenseStatus then
    Halt;
  if not LicenseTimer.Enabled then
    LicenseTimer.Enabled := True;
  //************************************

  SelectContent(ctScrollingText, True);
end;

procedure TMainForm.AnimationContentBtnClick(Sender: TObject);
begin
  SelectContent(ctAnimation, True);

  //************************************
  if not License2.CheckLicenseStatus then
    Halt;
  if not LicenseTimer.Enabled then
    LicenseTimer.Enabled := True;
  //************************************
end;

procedure TMainForm.PictureContentBtnClick(Sender: TObject);
begin
  //************************************
  if not License3.CheckLicenseStatus then
    Halt;
  if not LicenseTimer.Enabled then
    LicenseTimer.Enabled := True;
  //************************************

  SelectContent(GlobalTypes.ctPicture, True);
end;

function TMainForm.NewStage(AutoSelect: Boolean;
  AfterThisStage: Integer = -2; ScrollToShow: Boolean = True;
  CopyOfActiveStage: Boolean = False): Integer;
var
  StageIndex: Integer;
  i: Integer;
  Stage: TStage;
begin
  /////////////////////////////////////////////////////////////////////////////
  if (License._LED_DISPLAY_MAX_ROW_COUNT_ > 0) and
    (GlobalOptions.LEDDisplaySettings.Height > _LED_DISPLAY_MAX_ROW_COUNT_) then
    Halt;
  /////////////////////////////////////////////////////////////////////////////

  if Length(DisplayStages) = MAX_STAGE_COUNT then
  begin
    WideMessageDlgSound(Dyn_Texts[3] {'You can have maximum number of 255 stages.'}, mtInformation, [mbOK], 0);
    Exit;
  end;

  SetLength_DisplayStages(DisplayStages, Length(DisplayStages) + 1);
  StageIndex := High(DisplayStages);

  DisplayStages[StageIndex].StagePanel := TsStagePanel.Create(nil);
  SetStagePanelDefaults(DisplayStages[StageIndex].StagePanel);
  DisplayStages[StageIndex].StagePanel.Tag := StageIndex;
  DisplayStages[StageIndex].StagePanel.Top := 1;
  PositionStagePanel(StageIndex);
  DisplayStages[StageIndex].StagePanel.Parent := AnimationLineScrollBox;
  SetStageDefaults(DisplayStages[StageIndex]);

  if CopyOfActiveStage then
  begin
    SaveAreaSettings(ActiveAreaIndex);
    CopyStage(ActiveDisplayStage, StageIndex);
  end
  else
  begin
    with DisplayStages[StageIndex] do
    begin
      for i := 1 to 4 do
      begin
        //HERE WE CAN CHANGE THE DEFAULT CONTENT TYPE FOR THE AREAS OF NEW STAGES
        if GlobalOptions.LEDDisplaySettings.CanShowDateTime then
          Areas[i].ContentType := ctTime
        else if GlobalOptions.LEDDisplaySettings.CanShowScrollingText then
          Areas[i].ContentType := ctScrollingText
        else if GlobalOptions.LEDDisplaySettings.CanShowAnimation then
          Areas[i].ContentType := ctAnimation
        else if GlobalOptions.LEDDisplaySettings.CanShowPicture then
          Areas[i].ContentType := ctPicture
        else if GlobalOptions.LEDDisplaySettings.CanShowTemperature then
          Areas[i].ContentType := ctTemperature
        else
          Areas[i].ContentType := ctEmpty;

        LoadContentDefaultSettings(Areas[i]);
      end;

      if AfterThisStage >= -1 then
      begin
        Stage := DisplayStages[StageIndex];
        for i := High(DisplayStages) downto AfterThisStage + 2 do
        begin
          DisplayStages[i] := DisplayStages[i - 1];
          DisplayStages[i].StagePanel.Tag := i;
        end;
        DisplayStages[AfterThisStage + 1] := Stage;
        DisplayStages[AfterThisStage + 1].StagePanel.Tag := AfterThisStage + 1;
        StageIndex := AfterThisStage + 1;
        for i := 0 to High(DisplayStages) do
          PositionStagePanel(i);
      end;
    end;

    with DisplayStages[StageIndex] do
    begin
      if StageIndex > 0 then
      begin
        //LayoutIndex := 1;//DisplayStages[StageIndex - 1].LayoutIndex;
        //CustomLayout := False;
        LayoutIndex := DisplayStages[StageIndex - 1].LayoutIndex;
        CustomLayout := DisplayStages[StageIndex - 1].CustomLayout;
        for i := 1 to MAX_AREA_COUNT do
        begin
          Areas[i].x1 := DisplayStages[StageIndex - 1].Areas[i].x1;
          Areas[i].y1 := DisplayStages[StageIndex - 1].Areas[i].y1;
          Areas[i].x2 := DisplayStages[StageIndex - 1].Areas[i].x2;
          Areas[i].y2 := DisplayStages[StageIndex - 1].Areas[i].y2;
          Areas[i].SizeChangingMode := DisplayStages[StageIndex - 1].Areas[i].SizeChangingMode;
        end;
        //SetLayout(Areas, LayoutIndex, GlobalOptions.LEDDisplaySettings.Height, GlobalOptions.LEDDisplaySettings.Width);
        SetupLayout(Areas, LayoutBtn1, LayoutBtn2, LayoutBtn3, LayoutBtn4, LayoutGroup);
      end
      else
      begin
        LayoutIndex := 1;//2;
        //CustomLayout := False;
        SetLayout(Areas, LayoutIndex, GlobalOptions.LEDDisplaySettings.Height, GlobalOptions.LEDDisplaySettings.Width, CustomLayout);
        SetupLayout(Areas, LayoutBtn1, LayoutBtn2, LayoutBtn3, LayoutBtn4, LayoutGroup);
      end;
    end;
  end;

  RefreshStagePanels;
  Result := StageIndex;

  if AutoSelect then
  begin
    SelectStage(StageIndex, True);
    SelectStagePanel(DisplayStages[ActiveDisplayStage], ScrollToShow);
  end;
end;

procedure TMainForm.SetStagePanelDefaults(StagePanel: TsStagePanel);
begin
  StagePanel.Width := 94;
  StagePanel.Height := 83;
  StagePanel.Cursor := crHandPoint;
  StagePanel.OnAllClick := StagePanelClick;
  StagePanel.OnAllDblClick := StagePanelDblClick;
  StagePanel.PopupMenu := StagePanelPopup;
  with StagePanel.StageImage do
  begin
    Alignment := taCenter;
    UseSkinColor := False;
    Font.Color := clNavy;
  end;
end;

procedure TMainForm.AddNewStageBtnClick(Sender: TObject);
begin
  //************************************
  if not License3.CheckLicenseStatus then
    Halt;
  if not LicenseTimer.Enabled then
    LicenseTimer.Enabled := True;
  //************************************
  NewStage(True);
  OnNewStagePanelAdded;
end;

procedure TMainForm.StagePanelClick(Sender: TObject);
var
  ShowPopup: Boolean;
  p: TPoint;
begin
  p := Mouse.CursorPos;

  if Screen.ActiveControl is TsComboBox then
    AreaDelaySpin.SetFocus;

  //ShowPopup := ActiveDisplayStage = (Sender as TComponent).Tag;
  ShowPopup := False;  //Displaying a popup menu is not a good idea

  SelectStage((Sender as TComponent).Tag, False);
  //SelectStagePanel(DisplayStages[ActiveDisplayStage].StagePanel, True);  --> No need because the user clicks on the StagePanel

  //If StagePanelPopup.Tag is 1, the popupmenu is going to popup due to mouse right click.
  if (StagePanelPopup.Tag = 0) and ShowPopup then
  begin
    StagePanelPopup.PopupComponent := DisplayStages[ActiveDisplayStage].StagePanel;
    StagePanelPopup.Popup(p.X, p.Y);
  end;

  //Caption := IntToStr((Sender as TComponent).Tag)
end;

procedure TMainForm.StagePanelDblClick(Sender: TObject);
var
  //ShowPopup: Boolean;
  P: TPoint;
begin
  P := (Sender as TsStagePanel).Parent.ClientToScreen(Point((Sender as TsStagePanel).Left, (Sender as TsStagePanel).Top));
  if (P.Y - ScheduleStageForm.Height) >= 0 then
    ScheduleStageForm.Top := P.Y - ScheduleStageForm.Height
  else
    ScheduleStageForm.Top := p.Y + (Sender as TsStagePanel).Height;
  if (P.X - ScheduleStageForm.Width) < Screen.Width then
    ScheduleStageForm.Left := P.X
  else
    ScheduleStageForm.Left := P.X - ScheduleStageForm.Width;

  with ScheduleStageForm do
  begin
    HourFrom := DisplayStages[ActiveDisplayStage].HourFrom;
    MinuteFrom := DisplayStages[ActiveDisplayStage].MinuteFrom;
    HourTo := DisplayStages[ActiveDisplayStage].HourTo;
    MinuteTo := DisplayStages[ActiveDisplayStage].MinuteTo;
    OnlyDonNotShowDuringTimeSpan := DisplayStages[ActiveDisplayStage].OnlyDoNotShowDuringTimeSpan;
    DisplayInSpecificDate := DisplayStages[ActiveDisplayStage].DisplayInSpecificDate;
    Year := DisplayStages[ActiveDisplayStage].Year;
    Month := DisplayStages[ActiveDisplayStage].Month;
    Day := DisplayStages[ActiveDisplayStage].Day;
  end;
  ScheduleStageForm.Show;
  //ScheduleStageBtn.Click;
end;

procedure TMainForm.SelectStage(StageIndex: Integer; ForceRefresh: Boolean;
  SaveActiveAreaSettings: Boolean);
var
  i: Integer;
begin
  if (License._LED_DISPLAY_MAX_ROW_COUNT_ > 0) and
    (GlobalOptions.LEDDisplaySettings.Height > _LED_DISPLAY_MAX_ROW_COUNT_) then
    Exit;

  if (StageIndex = ActiveDisplayStage) and
     not ForceRefresh then
    Exit;

  MainForm.Enabled := False;

  try

  if SaveActiveAreaSettings then
    SaveAreaSettings(ActiveAreaIndex);
  //Deselect all stages
  for i := 0 to High(DisplayStages) do
    DisplayStages[i].StagePanel.Selected := False;
  SelectStagePanel(DisplayStages[StageIndex], False);
  ActiveDisplayStage := StageIndex;
  DisplayPageEffect(PageEffectImage, DisplayStages[ActiveDisplayStage].EntranceEffectID);

  EffectsSpeedTrackbar.Position := 255 - DisplayStages[StageIndex].EffectSpeed;

  SetupLayout(DisplayStages[StageIndex].Areas, LayoutBtn1, LayoutBtn2, LayoutBtn3, LayoutBtn4, LayoutGroup);

  ActiveAreaIndex := 1;  //Actually not necessary here because SelectArea is called with False value as its second parameter - but should be included here to prevent potential software bugs
  if (DisplayStages[StageIndex].LastSelectedAreaIndex >= 1) and  //Prevent potential software bugs
     (DisplayStages[StageIndex].LastSelectedAreaIndex <= CountStageUsedAreas(DisplayStages[StageIndex])) then
    SelectArea(DisplayStages[StageIndex].LastSelectedAreaIndex, False)
  else
    SelectArea(1, False);

  finally

  MainForm.Enabled := True;

  end;
end;

procedure TMainForm.DeleteStage(StageIndex: Integer;
  ScrollToShow: Boolean = True);
var
  i: Integer;
begin
  //At least one stage must exist
  if Length(DisplayStages) = 1 then
    Exit;
  if ActiveDisplayStage = StageIndex then
  begin
    if (High(DisplayStages) = StageIndex) and
       (Length(DisplayStages) > 1) then
      SelectStage(StageIndex - 1, False);
    SelectStagePanel(DisplayStages[ActiveDisplayStage], ScrollToShow);
  end;
  DisplayStages[StageIndex].StagePanel.Free;
  FreeUpDisplayStage(DisplayStages[StageIndex]);
  for i := StageIndex to High(DisplayStages) - 1 do
  begin
    DisplayStages[i] := DisplayStages[i + 1];
    DisplayStages[i].StagePanel.Tag := i;
    PositionStagePanel(i);
  end;
  SetLength_DisplayStages(DisplayStages, Length(DisplayStages) - 1);
  SelectStage(ActiveDisplayStage, True, False);
  SelectStagePanel(DisplayStages[ActiveDisplayStage], ScrollToShow);
end;

procedure TMainForm.PositionStagePanel(StageIndex: Integer);
begin
  if StageIndex > 0 then
    DisplayStages[StageIndex].StagePanel.Left := DisplayStages[StageIndex - 1].StagePanel.Left + DisplayStages[StageIndex - 1].StagePanel.Width + 5
  else if Length(DisplayStages) > 0 then
    DisplayStages[StageIndex].StagePanel.Left := 5- AnimationLineScrollBox.HorzScrollBar.Position;
  DisplayStages[StageIndex].StagePanel.TitleCaption := IntToStr(DisplayStages[StageIndex].StagePanel.Tag + 1);
end;

procedure TMainForm.DeleteCurrentStageBtnClick(Sender: TObject);
begin
  //************************************
  if not License4.CheckLicenseStatus then
    Halt;
  if not LicenseTimer.Enabled then
    LicenseTimer.Enabled := True;
  //************************************
  DeleteStage(ActiveDisplayStage, False);
end;

procedure TMainForm.TntFormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
var
  Response:Integer;
begin
  CanClose := True;
  if WorkingDesignChanged then
  begin
    Response := WideMessageDlgSoundTop(Dyn_Texts[63] {'Save changes to the current presentation?'}, mtWarning, mbYesNoCancel, 0);
    if Response = mrCancel then
      CanClose := False
    else if Response = mrNo then
      CanClose := True
    else
    begin
      SaveMenuItem.Click;
      CanClose := not WorkingDesignChanged;
    end;
  end;
  //CanClose := WideMessageDlgSoundTop(Dyn_Texts[4] {'Exit?'}, mtConfirmation, [mbYes, mbNo], 0) = mrYes;
end;

procedure TMainForm.sSpeedButton6Click(Sender: TObject);
begin
  SelectLayoutBtn.Click;
end;

procedure TMainForm.SetupLayout(Areas: TAreasArray;
  LayoutBtn1, LayoutBtn2, LayoutBtn3, LayoutBtn4: TsSpeedButton;
  LayoutContainer: TsGroupBox);

  function MapPointToLayout(x1, x2, y1, y2, x: Integer; H: Boolean = False): Integer;
  begin
    Result := Trunc((y2 - y1) / (x2 - x1) * (x - x1) + y1) - 1;
    Exit;
    if x = x1 then
      Result := y1
    else if x = x2 then
      Result := y2
    else
    begin
      if H then
        Result := Trunc((y2 - y1) / (x2 - x1) * (x + 1 - x1) + y1) - 1
      else
        Result := Trunc((y2 - y1) / (x2 - x1) * (x - x1) + y1) - 1
    end;
  end;

  procedure SetAreaLayout(Area: TArea; LayoutBtn: TsSpeedButton);
  var
    p: Double;
  begin
    if (Area.x1 = Area.x2) or (Area.y1 = Area.y2) then
    begin
      LayoutBtn.Visible := False;
      Exit;
    end;
    LayoutBtn.Left := MapPointToLayout(0, GlobalOptions.LEDDisplaySettings.Width - 1, 2, LayoutContainer.Width - 3, Area.x1);
    LayoutBtn.Width := MapPointToLayout(0, GlobalOptions.LEDDisplaySettings.Width - 1, 2, LayoutContainer.Width - 3, Area.x2) - LayoutBtn.Left + 1;

    p := (LayoutContainer.Height - 2 - 7) / GlobalOptions.LEDDisplaySettings.Height;
    LayoutBtn.Top := 8 + Trunc((Area.y1) * p);
    LayoutBtn.Height := Trunc((Area.y2 - Area.y1 + 1) * p);// - 7;
    //LayoutBtn.Top := MapPointToLayout(0, GlobalOptions.LEDDisplaySettings.Height - 1, 8, LayoutContainer.Height - 2, Area.y1);
    //LayoutBtn.Height := MapPointToLayout(0, GlobalOptions.LEDDisplaySettings.Height - 1, 8, LayoutContainer.Height - 2, Area.y2, True) - LayoutBtn.Top + 1;
    LayoutBtn.Visible := True;
  end;
begin
  SetAreaLayout(Areas[1], LayoutBtn1);
  SetAreaLayout(Areas[2], LayoutBtn2);
  SetAreaLayout(Areas[3], LayoutBtn3);
  SetAreaLayout(Areas[4], LayoutBtn4);
end;

procedure TMainForm.TemperatureContentBtnClick(Sender: TObject);
begin
  SelectContent(ctTemperature, True);
  UpdateTemperaturePicturePreview;

  //************************************
  if not License5.CheckLicenseStatus then
    Halt;
  if not LicenseTimer.Enabled then
    LicenseTimer.Enabled := True;
  //************************************
end;

procedure TMainForm.InputTextChange(Sender: TObject);
begin
  if FavoriteFontsCombo.ItemIndex >= 0 then
    FavoriteFontSamplePanel.Caption := InputText.Text;
  if AllFontsCombo.ItemIndex >= 0 then
    FontSamplePanel.Caption := InputText.Text;
  if SystemFontsSourceRadio.Checked then  //Update the size only if the System Fonts is selected as source because it is a time-consuming process
  begin
    if SystemFontsSection.ActivePageIndex = FavoriteFontsTabSheet.PageIndex then
    begin
      //if Length(InputText.Text) > 0 then
      //  UpdateHxW(FavoriteFontSamplePanel.Font, FavHxWPanel, InputText.Text)
      //else
      //  UpdateHxW(FavoriteFontSamplePanel.Font, FavHxWPanel, '');
      AllFontsTabSheet.Tag := 1;
    end
    else
    begin
      //if InsertTextAtCursorBtn.Enabled then
      //  UpdateHxW(FontSamplePanel.Font, HxWPanel, InputText.Text)
      //else
      //  UpdateHxW(FontSamplePanel.Font, HxWPanel, '');
      FavoriteFontsTabSheet.Tag := 1;
    end;
  end
  else
  begin
    FavoriteFontsTabSheet.Tag := 1;
    AllFontsTabSheet.Tag := 1;
  end;
end;

procedure TMainForm.FontDialogBtnClick(Sender: TObject);
begin
  FontDialog1.Font.Assign(FontSamplePanel.Font);
  if FontDialog1.Execute then
  begin
    FontSamplePanel.Font.Assign(FontDialog1.Font);
    FontSamplePanel.Font.Charset := DEFAULT_CHARSET;  //Always set the Charset to DEFAULT_CHARSET, otherwise the characters will not be displayed correctly
    //FontSamplePanel.Font.Color := FontDialog1.Font.Color;  --> Don't worry about the color and never change the color
    PrepareFontSectionControls;
  end;
end;

procedure TMainForm.LoadTimeContent(const Area: TArea);
begin
  LoadingContent := True;
  with Area do
  begin
    ClockDigitsFarsiRadio.Checked := TimeLanguage = laFarsi;
    ClockDigitsEnglishRadio.Checked := TimeLanguage = laEnglish;

    Clock24HourRadio.Checked := ClockType = 0;
    Clock12HourRadio.Checked := ClockType = 1;

    ClockTotalDisplayTimeSpin.Value := ClockTotalDisplayTime;
    PutClockAtCenterCheck.Checked := PutClockAtCenter;
    ClockDotsBlinkCheck.Checked := ClockDotsBlink;

    ClockHHMMFormatRadio.Checked := ClockFormat = 1;
    ClockHHMMSSFormatRadio.Checked := ClockFormat = 0;

    RepeatClockAfterDoneCheck.Checked := RepeatAfterDone;
  end;
  try
    PrepareContentControls(ctTime);
  finally
    LoadingContent := False;
  end;

  UpdateTextPicturePreview;
  UpdateTimePicturePreview;
end;

procedure TMainForm.LoadDateContent(const Area: TArea);
begin
  LoadingContent := True;
  with Area do
  begin
    DateDigitsFarsiRadio.Checked := DateLanguage = laFarsi;
    DateDigitsEnglishRadio.Checked := DateLanguage = laEnglish;

    DateSolarRadio.Checked := DateType = 0;
    DateGregorianRadio.Checked := DateType = 1;

    DateTotalDisplayTimeSpin.Value := DateTotalDisplayTime;
    PutDateAtCenterCheck.Checked := PutDateAtCenter;

    DateFormat0Radio.Checked := DateFormat = 0;
    DateFormat1Radio.Checked := DateFormat = 1;
    DateFormat2Radio.Checked := DateFormat = 2;
    DateFormat3Radio.Checked := DateFormat = 3;
    DateFormat4Radio.Checked := DateFormat = 4;
    DateFormat5Radio.Checked := DateFormat = 5;

    RepeatDateAfterDoneCheck.Checked := RepeatAfterDone;
  end;
  try
    PrepareContentControls(ctDate);
  finally
    LoadingContent := False;
  end;

  UpdateDatePicturePreview;
end;

procedure TMainForm.LoadTemperatureContent(const Area: TArea);
begin
  LoadingContent := True;
  with Area do
  begin
    TempLangFarsiRadio.Checked := TemperatureLanguage = laFarsi;
    TempLangEnglishRadio.Checked := TemperatureLanguage = laEnglish;

    TempUnitCentigradeRadio.Checked := TemperatureUnit = 0;
    TempUnitFahrenheitRadio.Checked := TemperatureUnit = 1;

    TempTotalDisplayTimeSpin.Value := TemperatureTotalDisplayTime;
    PutTemperatureAtCenterCheck.Checked := PutTemperatureAtCenter;

    RepeatTemperatureAfterDoneCheck.Checked := RepeatAfterDone;
  end;
  try
    PrepareContentControls(ctTime);
  finally
    LoadingContent := False;
  end;

  UpdateTemperaturePicturePreview;
end;

procedure TMainForm.LoadEmptyContent(const Area: TArea);
begin
  LoadingContent := True;
  with Area do
  begin
    EmptyAreaFilledRadio.Checked := EmptyAreaFilled;
    EmptyAreaClearedRadio.Checked := not EmptyAreaFilled;

    EmptyAreaTotalDisplayTimeSpin.Value := EmptyAreaTotalDisplayTime;

    RepeatEmptyAreaAfterDoneCheck.Checked := RepeatAfterDone;
  end;
  try
    PrepareContentControls(ctEmpty);
  finally
    LoadingContent := False;
  end;

  UpdateEmptyPicturePreview;
end;

procedure TMainForm.GetFontSettings(Font: TFont;
  var AFontSettings: TFontSettings);
begin
  with AFontSettings do
  begin
    Name := Font.Name;
    Size := Font.Size;
    Height := Font.Height;
    Pitch := Font.Pitch;
    Color := Font.Color;
    Style := Font.Style;
    Charset := Font.Charset;
  end;
end;

procedure TMainForm.SetFontSettings(Font: TFont;
  const AFontSettings: TFontSettings);
begin
  with AFontSettings do
  begin
    Font.Name := Name;
    Font.Size := Size;
    Font.Height := Height;
    Font.Pitch := Pitch;
    Font.Color := Color;
    Font.Style := Style;
    Font.Charset := Charset;
  end;
end;

procedure TMainForm.PrepareFontSectionControls;
begin
  with FavoriteFontSamplePanel.Font do
  begin
    Bold1.Down := fsBold in Style;
    Italic1.Down := fsItalic in Style;
    Underlined1.Down := fsUnderline in Style;
    if FontSizeCombo1.Items.IndexOf(IntToStr(Size)) >= 0 then
      FontSizeCombo1.ItemIndex := FontSizeCombo1.Items.IndexOf(IntToStr(Size))
    else
      FontSizeCombo1.Text := IntToStr(Size);

    if FavoriteFontsCombo.Items.Count > 0 then
    begin
      if FavoriteFontsCombo.Items.IndexOf(Name) >= 0 then
        FavoriteFontsCombo.ItemIndex := FavoriteFontsCombo.Items.IndexOf(Name)
      else
      begin
        FavoriteFontsCombo.ItemIndex := 0;
        FavoriteFontSamplePanel.Font.Name := FavoriteFontsCombo.Items.Strings[FavoriteFontsCombo.ItemIndex];
      end;
      RemoveFromFavoriteFontsBtn.Enabled := True;
    end
    else
      RemoveFromFavoriteFontsBtn.Enabled := False;
  end;

  with FontSamplePanel.Font do
  begin
    Bold2.Down := fsBold in Style;
    Italic2.Down := fsItalic in Style;
    Underlined2.Down := fsUnderline in Style;

    if FontSizeCombo2.Items.IndexOf(IntToStr(Size)) >= 0 then
      FontSizeCombo2.ItemIndex := FontSizeCombo2.Items.IndexOf(IntToStr(Size))
    else
    FontSizeCombo2.Text := IntToStr(Size);

    if AllFontsCombo.Items.Count > 0 then
    begin
      if AllFontsCombo.Items.IndexOf(Name) >= 0 then
        AllFontsCombo.ItemIndex := AllFontsCombo.Items.IndexOf(Name)
      else
      begin
        AllFontsCombo.ItemIndex := 0;
        FavoriteFontSamplePanel.Font.Name := AllFontsCombo.Items.Strings[AllFontsCombo.ItemIndex];
      end;
    end;
    AddToFavoriteFontsBtn.Enabled := not(FavoriteFontsCombo.Items.IndexOf(AllFontsCombo.Items.Strings[AllFontsCombo.ItemIndex]) >=0);
  end;
end;

procedure TMainForm.LoadScrollingTextContent(const Area: TArea);
begin
  LoadingContent := True;
  with Area do
  begin
    ScrollingTextRadio.Checked := not FixedText;
    FixedTextRadio.Checked := FixedText;

    InputTextFarsiRadio.Checked := TextLanguage = laFarsi;
    InputTextEnglishRadio.Checked := TextLanguage = laEnglish;
    InputTextMixedRadio.Checked := TextLanguage = laMixed;

    if (TextLanguage = laFarsi) or (TextLanguage = laMixed) then
      ChangeKeyboardLanguage(laFarsi)
    else
      ChangeKeyboardLanguage(laEnglish);

    TextDirectionRightRadio.Checked := TextDirection = 0;
    TextDirectionLeftRadio.Checked := TextDirection = 1;
    TextScrollSpeedCombo.ItemIndex := TextScrollSpeed;
    InvertScrollingTextCheck.Checked := InvertScrollingText;

    TextEntranceEffectCheck.Checked := TextEntranceAnimID > 0;
    TextEntranceEffectImage.Tag := TextEntranceAnimID;
    TextEntranceEffectCheck.OnClick(TextEntranceEffectCheck);  //This will automatically update the image

    TextTimingStyle1Radio.Checked := TextTimingStyle = tsRepeatNTimes;
    TextTimingStyle2Radio.Checked := TextTimingStyle = tsExactTiming;

    TextRepetitionTimesSpin.Value := TextRepetitionTimes;
    TextTotalDisplayTimeSpin.Value := TextTotalDisplayTime;

    RepeatTextAfterDoneCheck.Checked := RepeatAfterDone;

    //Text and font
    InputText.OnDelayedChange := nil;
    ShowFontSizeWarning(False);
    if Assigned(TextPicturePreviewForm) then
      with TextPicturePreviewForm.PreviewImage.Picture.Bitmap do
      begin
        Width := 0;
        Height := 0;
      end;
    with ScrollingTextFontSettings do
    begin
      LCDFontsSourceRadio.Checked := FontType = ftLCDFont;
      SystemFontsSourceRadio.Checked := FontType = ftSystemFont;
      LCDFontsSourceRadio.OnClick(LCDFontsSourceRadio);
      SystemFontsSourceRadio.OnClick(SystemFontsSourceRadio);

      if FontType = ftLCDFont then
      begin
        //Farsi font
        if FarsiLCDFontsCombo.Items.IndexOf(FarsiLCDFontName) >= 0 then
        begin
          FarsiLCDFontsCombo.ItemIndex := FarsiLCDFontsCombo.Items.IndexOf(FarsiLCDFontName);
          FarsiLCDFontsCombo.OnChange(FarsiLCDFontsCombo);
        end
        else if FarsiLCDFontsCombo.Items.Count > 0 then
          FarsiLCDFontsCombo.ItemIndex := 0;

        //English font
        if EnglishLCDFontsCombo.Items.IndexOf(EnglishLCDFontName) >= 0 then
        begin
          EnglishLCDFontsCombo.ItemIndex := EnglishLCDFontsCombo.Items.IndexOf(EnglishLCDFontName);
          EnglishLCDFontsCombo.OnChange(EnglishLCDFontsCombo);
        end;
      end
      else
      begin
        SetFontSettings(FontSamplePanel.Font, SystemFontSettings);
        if FavoriteFontsCombo.Items.IndexOf(SystemFontSettings.Name) >= 0 then
          SetFontSettings(FavoriteFontSamplePanel.Font, SystemFontSettings);
        PrepareFontSectionControls;
        if SystemFontFromFavoriteFonts then
          SystemFontsSection.ActivePage := FavoriteFontsTabSheet;
      end;
    end;

    InputText.OnDelayedChange := nil;
    InputText.Text := ScrollingText;
    InputText.CancelPendingDelay;
    InputTextDelayedChange(InputText);  //Call directly to ensure only one time refresh
    InputText.OnDelayedChange := InputTextDelayedChange;

    ScrollingTextDesignFilePathEdit.Text := ScrollingTextLFGFileName;
    if WideFileExists(ScrollingTextLFGFileName) then
    begin
      ScrollingTextDesignFilePathLabel.Caption := MinimizeName(ScrollingTextLFGFileName, ScrollingTextDesignFilePathLabel.Canvas, ScrollingTextDesignFilePathLabel.Width);
      EditScrollingTextDesignFileBtn.Enabled := True;
    end
    else
    begin
      ScrollingTextDesignFilePathLabel.Caption := '';
      EditScrollingTextDesignFileBtn.Enabled := False;
    end;

    if ScrollingTextType = ttAdvancedText then
      AdvancedTextTabBtn.Click  //This will automatically update picture preview
    else
      SimpleTextTabBtn.Click;
  end;
  try
    PrepareContentControls(ctScrollingText);
  finally
    LoadingContent := False;
  end;
end;

procedure TMainForm.LoadSWFContent(const Area: TArea);
var
  SWFInfo: TSWFInfo;
begin
  LoadingContent := True;
  with Area do
  begin
    SWFSensitivityTrackBar.Position := SWFSensitivity;
    if Assigned(SWFSensitivityTrackBar.OnChange) then
      SWFSensitivityTrackBar.OnChange(SWFSensitivityTrackBar);

    SWFSpeedCombo.ItemIndex := SWFPlaySpeed;
    InvertSWFCheck.Checked := InvertSWF;
    PutSWFAtCenterCheck.Checked := PutSWFAtCenter;
    UseSWFTimingsCheck.Checked := UseSWFTimings;

    SWFTimingStyle1Radio.Checked := SWFTimingStyle = tsRepeatNTimes;
    SWFTimingStyle2Radio.Checked := SWFTimingStyle = tsExactTiming;

    SWFRepetitionTimesSpin.Value := SWFRepetitionTimes;
    SWFTotalDisplayTimeSpin.Value := SWFTotalDisplayTime;

    RepeatSWFAfterDoneCheck.Checked := RepeatAfterDone;


    FlashPlayer.LoadMovieFromStream(0, Area.SWFData);
    if Area.SWFData.Size > 0 then
    begin
      FlashPlayer.Show;
      SWFFrameCountLabel.Caption := IntToStr(Area.StaticInfo.SWFFrameCount);
      SWFSizeLabel.Caption := WideFormat('%dx%d', [Area.StaticInfo.SWFFrameHeight, Area.StaticInfo.SWFFrameWidth]);
    end
    else
    begin
      SWFFrameCountLabel.Caption := '0';
      SWFSizeLabel.Caption := '';
      FlashPlayer.Stop;
      FlashPlayer.Show;
      FlashPlayer.Hide;
    end;
    FlashPlayer.Transparent := False;
    FlashPlayer.Transparent := True;
  end;
  try
    PrepareContentControls(ctSWF);
  finally
    LoadingContent := False;
  end;
end;

procedure TMainForm.LoadAnimationContent(const Area: TArea);
begin
  LoadingContent := True;
  with Area do
  begin
    AnimationSpeedCombo.ItemIndex := AnimationPlaySpeed;
    InvertAnimationCheck.Checked := InvertAnimation;
    PutAnimationAtCenterCheck.Checked := PutAnimationAtCenter;
    UseGIFTimingsCheck.Checked := UseGIFTimings;

    AnimationTimingStyle1Radio.Checked := AnimationTimingStyle = tsRepeatNTimes;
    AnimationTimingStyle2Radio.Checked := AnimationTimingStyle = tsExactTiming;

    AnimationRepetitionTimesSpin.Value := AnimationRepetitionTimes;
    AnimationTotalDisplayTimeSpin.Value := AnimationTotalDisplayTime;

    RepeatAnimationAfterDoneCheck.Checked := RepeatAfterDone;

    //GIFAnimationsList.ItemIndex := AnimationIndex;  --> AnimationIndex is not used anymore
    if GIFAnimationsList.Items.IndexOf(AnimationName) >= 0 then
      GIFAnimationsList.ItemIndex := GIFAnimationsList.Items.IndexOf(AnimationName)
    else
      GIFAnimationsList.ItemIndex := -1;

    GIFAnimationsList.OnClick(GIFAnimationsList);
  end;
  try
    PrepareContentControls(ctAnimation);
  finally
    LoadingContent := False;
  end;
end;

procedure TMainForm.LoadPictureContent(const Area: TArea);
var
  CanUpdatePicture: Boolean;
begin
  LoadingContent := True;
  with Area do
  begin
    FixedPictureRadio.Checked := not ScrollingPicture;
    ScrollingPictureRadio.Checked := ScrollingPicture;

    if PictureAvailable then
    begin
      CanUpdatePicture := (PictureBitmap.Width > 0) and (PictureBitmap.Height > 0);
    end
    else
      CanUpdatePicture := False;

    if CanUpdatePicture then
    begin
      PicturePreviewImage.Picture.Graphic := PictureBitmap;
      PictureWidthLabel.Caption := IntToStr(PicturePreviewImage.Picture.Bitmap.Width);
      PictureHeightLabel.Caption := IntToStr(PicturePreviewImage.Picture.Bitmap.Height);
    end
    else
    begin
      //PictureAvailable := False;
      PicturePreviewImage.Picture.Graphic := nil;
      PictureWidthLabel.Caption := '0';
      PictureHeightLabel.Caption := '0';
    end;

    UpdatePicturePicturePreview;


    PictureTimingStyle1Radio.Checked := PictureTimingStyle = tsRepeatNTimes;
    PictureTimingStyle2Radio.Checked := PictureTimingStyle = tsExactTiming;
    PictureRepetitionTimesSpin.Value := PictureRepetitionTimes;
    PictureTotalDisplayTimeSpin.Value := PictureTotalDisplayTime;

    RepeatPictureAfterDoneCheck.Checked := RepeatAfterDone;

    InvertPictureCheck.Checked := InvertPicture;

    PictureEntranceEffectCheck.Checked := PictureEntranceAnimID > 0;
    PictureEntranceEffectImage.Tag := PictureEntranceAnimID;
    PictureEntranceEffectCheck.OnClick(PictureEntranceEffectCheck);  //This will automatically update the image

    PictureDirectionRightRadio.Checked := PictureTextDirection = 0;
    PictureDirectionLeftRadio.Checked := PictureTextDirection = 1;
    PictureSpeedCombo.ItemIndex := PictureTextScrollSpeed;

    PictureDesignFilePathEdit.Text := PictureLFGFileName;
    if WideFileExists(PictureLFGFileName) then
    begin
      PictureDesignFilePathLabel.Caption := MinimizeName(PictureLFGFileName, PictureDesignFilePathLabel.Canvas, PictureDesignFilePathLabel.Width);
      EditPictureDesignFileBtn.Enabled := True;
    end
    else
    begin
      PictureDesignFilePathLabel.Caption := '';
      EditPictureDesignFileBtn.Enabled := False;
    end;

    if PictureSource = psLFGFile then
      AdvancedPictureTabBtn.Click
    else
      SimplePictureTabBtn.Click;
  end;
  try
    PrepareContentControls(ctPicture);
  finally
    LoadingContent := False;
  end;
end;

procedure TMainForm.SelectArea(AreaIndex: Integer; SaveCurrentArea: Boolean);
var
  TimePreviewTimerEnabled, DatePreviewTimerEnabled: Boolean;
  SWFInfo: TSWFInfo;
begin
  /////////////////////////////////////////////////////////////////////////////
  if (License._LED_DISPLAY_MAX_ROW_COUNT_ > 0) and
    (GlobalOptions.LEDDisplaySettings.Height > _LED_DISPLAY_MAX_ROW_COUNT_) then
    Exit;
  /////////////////////////////////////////////////////////////////////////////

  {
  1. Save current area settings
  2. Load new area settings
  }

  if SaveCurrentArea then
    SaveAreaSettings(ActiveAreaIndex);

  ActiveAreaIndex := AreaIndex;

  PrepareAreaSizeSection(AreaIndex);
  UpdateEnvironmentForAreaSelection(AreaIndex);
  with DisplayStages[ActiveDisplayStage].Areas[AreaIndex] do
  begin
    TimePreviewTimerEnabled := TimePreviewTimer.Enabled;
    DatePreviewTimerEnabled := DatePreviewTimer.Enabled;
    TimePreviewTimer.Enabled := False;  //Prevent incorrect refresh of the TimePreviewImage
    DatePreviewTimer.Enabled := False;

    SelectContent(ContentType, False);

    //Put ShowProgress after SelectContent because the SelectContent has a long delay because of its animation effect
    //if AreaIndex <> ActiveAreaIndex then
    ShowProgress;

    ResetAllContentPages;
    ChangeKeyboardLanguage(laEnglish);
    LoadAreaSpecificSettings(DisplayStages[ActiveDisplayStage].Areas[AreaIndex]);
    case ContentType of
      ctTime:
        LoadTimeContent(DisplayStages[ActiveDisplayStage].Areas[AreaIndex]);
      ctDate:
        LoadDateContent(DisplayStages[ActiveDisplayStage].Areas[AreaIndex]);
      ctScrollingText:
        LoadScrollingTextContent(DisplayStages[ActiveDisplayStage].Areas[AreaIndex]);
      ctSWF:
        begin
          //Prepare content data
          if (DisplayStages[ActiveDisplayStage].Areas[AreaIndex].SWFData.Size > 0) and
            (not DisplayStages[ActiveDisplayStage].Areas[AreaIndex].StaticInfo.SWFInfoValid) then
          begin
            GetSWFInfo(DisplayStages[ActiveDisplayStage].Areas[ActiveAreaIndex].SWFData, SWFInfo);
            DisplayStages[ActiveDisplayStage].Areas[ActiveAreaIndex].StaticInfo.SWFFrameCount := SWFInfo.FrameCount;
            DisplayStages[ActiveDisplayStage].Areas[ActiveAreaIndex].StaticInfo.SWFFrameHeight := SWFInfo.Height;
            DisplayStages[ActiveDisplayStage].Areas[ActiveAreaIndex].StaticInfo.SWFFrameWidth := SWFInfo.Width;
            DisplayStages[ActiveDisplayStage].Areas[ActiveAreaIndex].StaticInfo.SWFInfoValid := True;
          end;
          LoadSWFContent(DisplayStages[ActiveDisplayStage].Areas[AreaIndex]);
        end;
      ctAnimation:
        LoadAnimationContent(DisplayStages[ActiveDisplayStage].Areas[AreaIndex]);
      ctPicture:
        LoadPictureContent(DisplayStages[ActiveDisplayStage].Areas[AreaIndex]);
      ctTemperature:
        LoadTemperatureContent(DisplayStages[ActiveDisplayStage].Areas[AreaIndex]);
      ctEmpty:
        LoadEmptyContent(DisplayStages[ActiveDisplayStage].Areas[AreaIndex]);
    end;

    TimePreviewTimer.Enabled := TimePreviewTimerEnabled;  //Restore old values
    DatePreviewTimer.Enabled := DatePreviewTimerEnabled;

    //Disable other contents because it did not done in the SelectContent procedure
    DisableOtherContents(ContentType);
  end;
  HideProgress;
end;

procedure TMainForm.SaveAreaSettings(AreaIndex: Integer);

  procedure SaveAreaSpecificSettings(var Area: TArea);
  var
    i: Integer;
  begin
    Area.DelayTime := AreaDelaySpin.Value;
    Area.Color := AreaColorCombo.ItemIndex;

    //Area border settings
    Area.TopBorder := not TopBorderLabel.Transparent;
    Area.BottomBorder := not BottomBorderLabel.Transparent;
    Area.LeftBorder := not LeftBorderLabel.Transparent;
    Area.RightBorder := not RightBorderLabel.Transparent;
    Area.BorderWidthHorizontal := AreaBorderWidthSpin.Value;  //Horizontal and vertical border widths are have the same values in this version
    Area.BorderWidthVertical := AreaBorderWidthSpin.Value;
    //Area.BordersFilled is saved in the Active Area by the BorderStyleFormUnit
  end;

  procedure SaveTimeContent(var Area: TArea);
  begin
    with Area do
    begin
      if ClockDigitsFarsiRadio.Checked then
        TimeLanguage := laFarsi
      else
        TimeLanguage := laEnglish;

      if Clock24HourRadio.Checked then
        ClockType := 0
      else
        ClockType := 1;

      ClockTotalDisplayTime := ClockTotalDisplayTimeSpin.Value;
      PutClockAtCenter := PutClockAtCenterCheck.Checked;
      ClockDotsBlink := ClockDotsBlinkCheck.Checked;

      if ClockHHMMFormatRadio.Checked then
        ClockFormat := 1
      else
        ClockFormat := 0;

      RepeatAfterDone := RepeatClockAfterDoneCheck.Checked;
    end;
  end;

  procedure SaveDateContent(var Area: TArea);
  begin
    with Area do
    begin
      if DateDigitsFarsiRadio.Checked then
        DateLanguage := laFarsi
      else
        DateLanguage := laEnglish;

      if DateSolarRadio.Checked then
        DateType := 0
      else
        DateType := 1;

      DateTotalDisplayTime := DateTotalDisplayTimeSpin.Value;
      PutDateAtCenter := PutDateAtCenterCheck.Checked;

      if DateFormat0Radio.Checked then DateFormat := 0 else
      if DateFormat1Radio.Checked then DateFormat := 1 else
      if DateFormat2Radio.Checked then DateFormat := 2 else
      if DateFormat3Radio.Checked then DateFormat := 3 else
      if DateFormat4Radio.Checked then DateFormat := 4 else
      if DateFormat5Radio.Checked then DateFormat := 5;

      RepeatAfterDone := RepeatDateAfterDoneCheck.Checked;
    end;
  end;

  procedure SaveTemperatureContent(var Area: TArea);
  begin
    with Area do
    begin
      if TempLangFarsiRadio.Checked then
        TemperatureLanguage := laFarsi
      else
        TemperatureLanguage := laEnglish;

      if TempUnitCentigradeRadio.Checked then
        TemperatureUnit := 0  //Centigrade
      else
        TemperatureUnit := 1;  //Fahrenheit

      TemperatureTotalDisplayTime := TempTotalDisplayTimeSpin.Value;
      PutTemperatureAtCenter := PutTemperatureAtCenterCheck.Checked;

      RepeatAfterDone := RepeatTemperatureAfterDoneCheck.Checked;
    end;
  end;

  procedure SaveEmptyContent(var Area: TArea);
  begin
    with Area do
    begin
      EmptyAreaFilled := EmptyAreaFilledRadio.Checked;

      EmptyAreaTotalDisplayTime := EmptyAreaTotalDisplayTimeSpin.Value;

      RepeatAfterDone := RepeatEmptyAreaAfterDoneCheck.Checked;
    end;
  end;

  procedure SaveScrollingTextContent(var Area: TArea);
  begin
    with Area do
    begin
      FixedText := FixedTextRadio.Checked;

      if InputTextFarsiRadio.Checked then
        TextLanguage := laFarsi
      else if InputTextEnglishRadio.Checked then
        TextLanguage := laEnglish
      else
        TextLanguage := laMixed;

      if TextDirectionRightRadio.Checked then
        TextDirection := 0
      else
        TextDirection := 1;

      TextScrollSpeed := TextScrollSpeedCombo.ItemIndex;
      InvertScrollingText := InvertScrollingTextCheck.Checked;

      if TextEntranceEffectCheck.Checked then
        TextEntranceAnimID := TextEntranceEffectImage.Tag
      else
        TextEntranceAnimID := 0;

      if TextTimingStyle1Radio.Checked then
        TextTimingStyle := tsRepeatNTimes
      else
        TextTimingStyle := tsExactTiming;
      TextRepetitionTimes := TextRepetitionTimesSpin.Value;
      TextTotalDisplayTime := TextTotalDisplayTimeSpin.Value;

      RepeatAfterDone := RepeatTextAfterDoneCheck.Checked;

      ScrollingText := InputText.Text;

      SystemFontFromFavoriteFonts := False;
      with ScrollingTextFontSettings do
      begin
        if LCDFontsSourceRadio.Checked then
          FontType := ftLCDFont
        else
        begin
          FontType := ftSystemFont;
          SystemFontFromFavoriteFonts := SystemFontsSection.ActivePage = FavoriteFontsTabSheet;
        end;

        if FontType = ftLCDFont then
        begin
          FarsiLCDFontName := FarsiLCDFontsCombo.Items.Strings[FarsiLCDFontsCombo.ItemIndex];
          EnglishLCDFontName := EnglishLCDFontsCombo.Items.Strings[EnglishLCDFontsCombo.ItemIndex];
        end
        else
        begin
          if SystemFontsSection.ActivePage.PageIndex = AllFontsTabSheet.PageIndex then
            GetFontSettings(FontSamplePanel.Font, SystemFontSettings)
          else
            GetFontSettings(FavoriteFontSamplePanel.Font, SystemFontSettings)
        end;
      end;

      ScrollingTextLFGFileName := ScrollingTextDesignFilePathEdit.Text;
      if SimpleTextTabBtn.Down then
        ScrollingTextType := ttSimpleText
      else
        ScrollingTextType := ttAdvancedText;
    end;
  end;

  procedure SaveSWFContent(var Area: TArea);
  begin
    with Area do
    begin
      SWFSensitivity := SWFSensitivityTrackBar.Position;
      
      SWFPlaySpeed := SWFSpeedCombo.ItemIndex;
      InvertSWF := InvertSWFCheck.Checked;
      PutSWFAtCenter := PutSWFAtCenterCheck.Checked;
      UseSWFTimings := False;

      if SWFTimingStyle1Radio.Checked then
        SWFTimingStyle := tsRepeatNTimes
      else
        SWFTimingStyle := tsExactTiming;
      SWFRepetitionTimes := SWFRepetitionTimesSpin.Value;
      SWFTotalDisplayTime := SWFTotalDisplayTimeSpin.Value;

      RepeatAfterDone := RepeatSWFAfterDoneCheck.Checked;
    end;
  end;

  procedure SaveAnimationContent(var Area: TArea);
  begin
    with Area do
    begin
      AnimationPlaySpeed := AnimationSpeedCombo.ItemIndex;
      InvertAnimation := InvertAnimationCheck.Checked;
      PutAnimationAtCenter := PutAnimationAtCenterCheck.Checked;
      UseGIFTimings := UseGIFTimingsCheck.Checked;

      if AnimationTimingStyle1Radio.Checked then
        AnimationTimingStyle := tsRepeatNTimes
      else
        AnimationTimingStyle := tsExactTiming;
      AnimationRepetitionTimes := AnimationRepetitionTimesSpin.Value;
      AnimationTotalDisplayTime := AnimationTotalDisplayTimeSpin.Value;

      RepeatAfterDone := RepeatAnimationAfterDoneCheck.Checked;

      //AnimationIndex := GIFAnimationsList.ItemIndex;  --> AnimationIndex is not used anymore
      if GIFAnimationsList.ItemIndex >= 0 then
        AnimationName := GIFAnimationsList.Items.Strings[GIFAnimationsList.ItemIndex]
      else
        AnimationName := '';  //Means no animation
    end;
  end;

  procedure SavePictureContent(var Area: TArea);
  begin
    with Area do
    begin
      ScrollingPicture := ScrollingPictureRadio.Checked;
      if PictureAvailable then
        PictureBitmap.Assign(PicturePreviewImage.Picture.Bitmap);

      if PictureTimingStyle1Radio.Checked then
        PictureTimingStyle := tsRepeatNTimes
      else
        PictureTimingStyle := tsExactTiming;
      PictureRepetitionTimes := PictureRepetitionTimesSpin.Value;
      PictureTotalDisplayTime := PictureTotalDisplayTimeSpin.Value;

      RepeatAfterDone := RepeatPictureAfterDoneCheck.Checked;

      InvertPicture := InvertPictureCheck.Checked;

      if PictureEntranceEffectCheck.Checked then
        PictureEntranceAnimID := PictureEntranceEffectImage.Tag
      else
        PictureEntranceAnimID := 0;

      if PictureDirectionRightRadio.Checked then
        PictureTextDirection := 0
      else
        PictureTextDirection := 1;

      PictureTextScrollSpeed := PictureSpeedCombo.ItemIndex;

      PictureLFGFileName := PictureDesignFilePathEdit.Text;
      if SimplePictureTabBtn.Down then
        PictureSource := psDirect
      else
        PictureSource := psLFGFile;
    end;
  end;

begin
  //Saves current area settings to the specified area
  DisplayStages[ActiveDisplayStage].LastSelectedAreaIndex := AreaIndex;
  with DisplayStages[ActiveDisplayStage].Areas[AreaIndex] do
  begin
    SaveAreaSpecificSettings(DisplayStages[ActiveDisplayStage].Areas[AreaIndex]);
    case ContentType of
      ctTime:
        SaveTimeContent(DisplayStages[ActiveDisplayStage].Areas[AreaIndex]);
      ctDate:
        SaveDateContent(DisplayStages[ActiveDisplayStage].Areas[AreaIndex]);
      ctScrollingText:
        SaveScrollingTextContent(DisplayStages[ActiveDisplayStage].Areas[AreaIndex]);
      ctSWF:
        SaveSWFContent(DisplayStages[ActiveDisplayStage].Areas[AreaIndex]);
      ctAnimation:
        SaveAnimationContent(DisplayStages[ActiveDisplayStage].Areas[AreaIndex]);
      ctPicture:
        SavePictureContent(DisplayStages[ActiveDisplayStage].Areas[AreaIndex]);
      ctTemperature:
        SaveTemperatureContent(DisplayStages[ActiveDisplayStage].Areas[AreaIndex]);
      ctEmpty:
        SaveEmptyContent(DisplayStages[ActiveDisplayStage].Areas[AreaIndex]);
    end;
  end;
end;

function TMainForm.GenerateAllData(var Data: TDataArray): Boolean;
{******************************************************************************}
{*This function returns False if it is not possible to generate any data, for *}
{*  example when no active display stage is defined by the user, Otherwise it *}
{*  returns True by generating valid data for the LED Display.                *}
{******************************************************************************}

  procedure AppendToDataArray(const NewData: TDataArray; var TargetData: TDataArray);
  var
    NextIndex: Integer;
    i: Integer;
  begin
    if Length(NewData) = 0 then
      Exit;

    /////////////////////////////////////////////////////////////////////////////
    if (License._LED_DISPLAY_MAX_ROW_COUNT_ > 0) and
      (GlobalOptions.LEDDisplaySettings.Height > _LED_DISPLAY_MAX_ROW_COUNT_) then
      Halt;
    /////////////////////////////////////////////////////////////////////////////

    NextIndex := Length(TargetData);
    SetLength(TargetData, Length(TargetData) + Length(NewData));
    for i := NextIndex to High(TargetData) do
      TargetData[i] := NewData[i - NextIndex];
  end;

  function ContentTypeToData(const Area: TArea): Integer;
  begin
    Result := 0;  //0 means unused area
    case Area.ContentType of
      ctTime:  Result := {$ifdef _TIME_ACTIVE_} 1 {$else} 0 {$endif};
      ctDate:  Result := {$ifdef _DATE_ACTIVE_} 2 {$else} 0 {$endif};
      ctScrollingText:  Result := {$ifdef _SCROLLING_TEXT_ACTIVE_} 3 {$else} 0 {$endif};
      ctSWF:  Result := {$ifdef _SWF_ACTIVE_} 4 {$else} 0 {$endif};  //Implemented as FramedAnimation
      ctAnimation:  Result := {$ifdef _ANIMATION_ACTIVE_} 4 {$else} 0 {$endif};
      ctPicture: Result := {$ifdef _SCROLLING_TEXT_ACTIVE_} 3 {$else} 0 {$endif};  //Implemented as ScrollingText
      ctTemperature: Result := {$ifdef _TEMPERATURE_ACTIVE_} 6 {$else} 0 {$endif};
      ctEmpty: Result := 7;
    end;
  end;

  function GetEntranceAnimID(const Area: TArea): Integer;
  begin
    /////////////////////////////////////////////////////////////////////////////
    if (License._LED_DISPLAY_MAX_ROW_COUNT_ > 0) and
      (GlobalOptions.LEDDisplaySettings.Height > _LED_DISPLAY_MAX_ROW_COUNT_) then
      Halt;
    /////////////////////////////////////////////////////////////////////////////
    
    Result := 0;
    with Area do
    begin
      case Area.ContentType of
        ctScrollingText:
          begin
            if TextEntranceAnimID > 1 then
              Result := TextEntranceAnimID - 1;
          end;
        ctPicture:
          begin
            if PictureEntranceAnimID > 1 then
              Result := PictureEntranceAnimID - 1;
          end;
      end;
    end;
  end;

  function GetColorValue(ColorIndex: Integer): Byte;
  begin
    if not License._COLOR_DISPLAY_ then
      Result := 0;  //Always 1 color (default color is red)

    if License._COLOR_DISPLAY_ then
    begin
      case ColorIndex of
        0:  //Red
          Result := 0;
        1:  //Green
          Result := 1;
        2:  //Red and Green
          Result := 2;
        else
          Result := 0;  //Default color is red
      end;
    end;
  end;

  (*
  function GetAreaBorderStyleValue(const Area: TArea): Byte;
  var
    BorderWidth: Byte;
  begin
    Result := $00;
    if Area.TopBorder then Result := Result or $01;
    if Area.BottomBorder then Result := Result or $02;
    if Area.LeftBorder then Result := Result or $04;
    if Area.RightBorder then Result := Result or $08;

    //In this version only 1 or 0:
    BorderWidth := Area.BorderWidth;
    if BorderWidth > 1 then
      BorderWidth := 0;
    {
    if (Area.BorderWidth <= (Trunc((Area.x2 - Area.x1) / 2) - 1)) and
       (Area.BorderWidth <= (Trunc((Area.y2 - Area.y1) / 2) - 1)) then
    begin
      if Area.BorderWidth <= 15 then
        BorderWidth := Area.BorderWidth
      else
        BorderWidth := 15;
    end
    else
    begin
      BorderWidth := 0;
      //BorderWidth := Min(Trunc((Area.x2 - Area.x1) / 2) - 1, Trunc((Area.y2 - Area.y1) / 2) - 1);
      //if BorderWidth > 15 then
      //  BorderWidth := 15;
    end;
    }

    Result := Result or (BorderWidth shl 4);
  end;
  *)

const
  STAGE_SETTINGS_SIZE = 15;
  AREA_SIZE = 25;
  STAGE_TOTAL_SIZE = STAGE_SETTINGS_SIZE + MAX_AREA_COUNT * AREA_SIZE;

var
  MainData: TDataArray;
  StageIndex, AreaIndex: Integer;
  TempData: TDataArray;
  TempW: Word;
  Offset: Integer;
  i: Integer;
  HF, MF, HT, MT: Integer;  //Time Span
  TempArea: TArea;
  AnyStageAvailable: Boolean;
  TempB: Byte;
  b: Byte;
  LEDDataResult: Boolean;
begin
  Result := False;
  ////////////////////////////////////////////////////////////////////
  //Check if it is possible to generate data or not
  AnyStageAvailable := False;
  for StageIndex := 0 to High(DisplayStages) do
    if not DisplayStages[StageIndex].TemporaryDisabled then
    begin
      AnyStageAvailable := True;
      Break;
    end;

  if not AnyStageAvailable then
  begin
    WideShowMessageSoundTop(Dyn_Texts[122] {'To show presentation on the LED Display, at least one display stage must exist. Please make some display stages active and try again.'});
    Exit;
  end;
  ////////////////////////////////////////////////////////////////////

  Result := True;

  ///////////////////////////////////////////////////
  // Apply row count limit //
  b := GlobalOptions.LEDDisplaySettings.Height;
  if License3._LED_DISPLAY_MAX_ROW_COUNT_ < 17 then
  begin//  {$ifdef _ROW_LIMIT_16_}
    //16 = 00010000
    if (b and $E0) <> 0 then  //E0 = 11100000
      Halt;
    if (b and $10) <> 0 then  //10 = 00010000
    begin
      if (b and $0F) <> 0 then  //0F = 00001111
        Halt;
    end;
  end//  {$endif}
  else if License4._LED_DISPLAY_MAX_ROW_COUNT_ < 25 then//  {$ifdef _ROW_LIMIT_24_}
  begin
    //24 = 00011000
    if (b and $E0) <> 0 then  //E0 = 11100000
      Halt;
    if (b and $18) <> 0 then  //18 = 00011000
    begin
      if (b and $07) <> 0 then  //07 = 00000111
        Halt;
    end;
  end//  {$endif}
  else if License5._LED_DISPLAY_MAX_ROW_COUNT_ < 33 then//  {$ifdef _ROW_LIMIT_32_}
  begin
    //32 = 00100000
    {  --> 32-row model is our final model in this version with no limitation, so better to remove this limitation to avoid potential software bugs (as most customers buy this model)
    if (b and $C0) <> 0 then  //C0 = 11000000
      Halt;
    if (b and $20) <> 0 then  //20 = 00100000
    begin
      if (b and $1F) <> 0 then  //1F = 00011111
        Halt;
    end;
    }
  end;//  {$endif}
  // Row count limit applied //
  ///////////////////////////////////////////////////

  ShowWaitState(wsGeneratingData, 1000);

  try

  SetLength(MainData, 0);

  SetLength(Data, 3 + Length(DisplayStages) * STAGE_TOTAL_SIZE);
  Data[0] := GlobalOptions.LEDDisplaySettings.Height;  //RowCount
  Data[1] := GlobalOptions.LEDDisplaySettings.Width;  //ColCount
  Data[2] := Length(DisplayStages);  //StageCount

  for StageIndex := 0 to High(DisplayStages) do
  begin

  if (License._LED_DISPLAY_MAX_ROW_COUNT_ > 0) and
    (GlobalOptions.LEDDisplaySettings.Height > _LED_DISPLAY_MAX_ROW_COUNT_) then
    Exit;

  Application.ProcessMessages;
  if not DisplayStages[StageIndex].TemporaryDisabled then
  begin
    //Data[3 + StageIndex * STAGE_TOTAL_SIZE + 0]  = TotalDisplayTime
    //Data[3 + StageIndex * STAGE_TOTAL_SIZE + 1] = RepeatitionTimes
    //Data[3 + StageIndex * STAGE_TOTAL_SIZE + 2] = DataOffset (Not Used)
    //Data[3 + StageIndex * STAGE_TOTAL_SIZE + 3] = DataOffset (Not Used)
    Data[3 + StageIndex * STAGE_TOTAL_SIZE + 4] := {$ifdef _PAGE_EFFECTS_ACTIVE_} DisplayStages[StageIndex].EntranceEffectID {$else} 0 {$endif};  //EntranceEffectID = Page Effect
    Data[3 + StageIndex * STAGE_TOTAL_SIZE + 5] := DisplayStages[StageIndex].ExitEffectID;  //ExitEffectID
    Data[3 + StageIndex * STAGE_TOTAL_SIZE + 6] := DisplayStages[StageIndex].EffectSpeed;  //EffectSpeed

    //Time Span
    HF := {$ifdef _TIME_SPAN_ACTIVE_} DisplayStages[StageIndex].HourFrom {$else} 0 {$endif};
    MF := {$ifdef _TIME_SPAN_ACTIVE_} DisplayStages[StageIndex].MinuteFrom {$else} 0 {$endif};
    HT := {$ifdef _TIME_SPAN_ACTIVE_} DisplayStages[StageIndex].HourTo {$else} 0 {$endif};
    MT := {$ifdef _TIME_SPAN_ACTIVE_} DisplayStages[StageIndex].MinuteTo {$else} 0 {$endif};
    if TimeSpanDefined(HF, MF, HT, MT) then
    begin
      if DisplayStages[StageIndex].OnlyDoNotShowDuringTimeSpan then
      begin
        HF := DisplayStages[StageIndex].HourTo;
        MF := DisplayStages[StageIndex].MinuteTo;
        HT := DisplayStages[StageIndex].HourFrom;
        MT := DisplayStages[StageIndex].MinuteFrom;
      end;
    end;
    Data[3 + StageIndex * STAGE_TOTAL_SIZE + 7] := HF;  //HourFrom
    Data[3 + StageIndex * STAGE_TOTAL_SIZE + 8] := MF;  //MinuteFrom
    Data[3 + StageIndex * STAGE_TOTAL_SIZE + 9] := HT;  //HourTo
    Data[3 + StageIndex * STAGE_TOTAL_SIZE + 10] := MT;  //MinuteTo

    //Date setting
    if DisplayStages[StageIndex].DisplayInSpecificDate then
    begin
      TempW := DisplayStages[StageIndex].Year;
      Data[3 + StageIndex * STAGE_TOTAL_SIZE + 11] := LoByte(TempW);  //Year LSB
      Data[3 + StageIndex * STAGE_TOTAL_SIZE + 12] := HiByte(TempW);  //Year MSB
      Data[3 + StageIndex * STAGE_TOTAL_SIZE + 13] := DisplayStages[StageIndex].Month;  //Month
      Data[3 + StageIndex * STAGE_TOTAL_SIZE + 14] := DisplayStages[StageIndex].Day;  //Day
    end
    else
    begin
      Data[3 + StageIndex * STAGE_TOTAL_SIZE + 11] := 0;  //Year LSB
      Data[3 + StageIndex * STAGE_TOTAL_SIZE + 12] := 0;  //Year MSB
      Data[3 + StageIndex * STAGE_TOTAL_SIZE + 13] := 0;  //Month
      Data[3 + StageIndex * STAGE_TOTAL_SIZE + 14] := 0;  //Day
    end;

    for AreaIndex := 1 to MAX_AREA_COUNT do
    begin
      //Apply area border settings to area dimensions [but, only if border capabilities is active]
      TempArea := DisplayStages[StageIndex].Areas[AreaIndex];
      {$ifdef _AREA_BORDERS_ACTIVE_}
      if TempArea.LeftBorder then
        TempArea.x1 := TempArea.x1 + TempArea.BorderWidthHorizontal;
      if TempArea.RightBorder then
        TempArea.x2 := TempArea.x2 - TempArea.BorderWidthHorizontal;
      if TempArea.TopBorder then
        TempArea.y1 := TempArea.y1 + TempArea.BorderWidthVertical;
      if TempArea.BottomBorder then
        TempArea.y2 := TempArea.y2 - TempArea.BorderWidthVertical;
      {$endif}

      if IsUnusedArea(DisplayStages[StageIndex].Areas[AreaIndex]) then
      begin
        SetLength(TempData, 0);
      end
      else
      begin
        LEDDataResult := False;

        case DisplayStages[StageIndex].Areas[AreaIndex].ContentType of
          {$ifdef _TIME_ACTIVE_}
          ctTime:
            LEDDataResult := LEDTimeData(StageIndex, TempArea, TempData);
          {$endif}
          {$ifdef _DATE_ACTIVE_}
          ctDate:
            LEDDataResult := LEDDateData(StageIndex, TempArea, TempData);
          {$endif}
          {$ifdef _SCROLLING_TEXT_ACTIVE_}
          ctScrollingText:
            LEDDataResult := LEDScrollingTextData(StageIndex, TempArea, TempData);
          {$endif}
          {$ifdef _SWF_ACTIVE_}
          ctSWF:
            LEDDataResult := LEDSWFData(StageIndex, TempArea, TempData);
          {$endif}
          {$ifdef _ANIMATION_ACTIVE_}
          ctAnimation:
            LEDDataResult := LEDAnimationData(StageIndex, TempArea, TempData);
          {$endif}
          {$ifdef _SCROLLING_TEXT_ACTIVE_}
          GlobalTypes.ctPicture:
            LEDDataResult := LEDPictureData(StageIndex, TempArea, TempData);
          {$endif}
          {$ifdef _TEMPERATURE_ACTIVE_}
          ctTemperature:
            LEDDataResult := LEDTemperatureData(StageIndex, TempArea, TempData);
          {$endif}
          ctEmpty:
            LEDDataResult := LEDEmptyData(StageIndex, TempArea, TempData);
        end;
      end;

      if not LEDDataResult then
      begin
        Result := False;
        SetLength(TempData, 0);
        SetLength(Data, 0);
        SetLength(MainData, 0);
        Exit;
      end;

      TempW := Length(TempData);
      AppendToDataArray(TempData, MainData);
      SetLength(TempData, 0);

      Offset := 3 + StageIndex * STAGE_TOTAL_SIZE + STAGE_SETTINGS_SIZE + (AreaIndex - 1) * AREA_SIZE;
      if IsUnusedArea(DisplayStages[StageIndex].Areas[AreaIndex]) then
      begin
        for i := 0 to 15 do
          Data[Offset + i] := 0;
      end
      else
      begin
        with DisplayStages[StageIndex].Areas[AreaIndex] do
        begin
          Data[Offset + 0] := TempArea.x1;  //Apply borders settings if necessary
          Data[Offset + 1] := TempArea.y1;  //Apply borders settings if necessary
          Data[Offset + 2] := TempArea.x2;  //Apply borders settings if necessary
          Data[Offset + 3] := TempArea.y2;  //Apply borders settings if necessary

          Data[Offset + 4] := ContentTypeToData(DisplayStages[StageIndex].Areas[AreaIndex]);
          Data[Offset + 5] := DelayTime;

          //Offset 6: DataSize (two bytes)
          Data[Offset + 6] := LoByte(TempW);
          Data[Offset + 7] := HiByte(TempW);

          Data[Offset + 8] := IfThen(ContinuesToNextStage, 1, 0);
          Data[Offset + 9] := IfThen(AdvanceStageWhenDone, 1, 0);
          Data[Offset + 10] := IfThen(ForceAdvanceStageWhenDone, 1, 0);
          Data[Offset + 11] := IfThen(CompleteBeforeNextStage, 1, 0);
          Data[Offset + 12] := IfThen(RepeatAfterDone, 1, 0);
        end;

        //Area Animation
        //Data[Offset + 13] := EntranceAnimID;
        Data[Offset + 13] := {$ifdef _TEXT_ANIMATIONS_ACTIVE_} GetEntranceAnimID(DisplayStages[StageIndex].Areas[AreaIndex]) {$else} 0 {$endif};
        //Data[Offset + 14] := MiddleAnimID;
        Data[Offset + 14] := 0;
        //Data[Offset + 15] := ExitAnimID;
        Data[Offset + 15] := 0;
        //Data[Offset + 16] := AnimSpeed;
        Data[Offset + 16] := DisplayStages[StageIndex].Areas[AreaIndex].AnimSpeed;

        Data[Offset + 17] := GetColorValue(DisplayStages[StageIndex].Areas[AreaIndex].Color);

        //Area border settings
        //Data[Offset + 18] := GetAreaBorderStyleValue(DisplayStages[StageIndex].Areas[AreaIndex]);
        with DisplayStages[StageIndex].Areas[AreaIndex] do
        begin
          {$ifdef _AREA_BORDERS_ACTIVE_}

          TempB := $00;
          if LeftBorder or RightBorder then
          begin
            if LeftBorder then
              TempB := TempB or (1 shl 0);
            if RightBorder then
              TempB := TempB or (1 shl 1);
            if BordersFilled then
            begin
              if LeftBorder then
                TempB := TempB or (1 shl 4);
              if RightBorder then
                TempB := TempB or (1 shl 5);
            end;
            Data[Offset + 19] := BorderWidthHorizontal;  //BordersWidthH
          end
          else
          begin
            Data[Offset + 19] := 0;  //BordersWidthH
          end;

          if TopBorder or BottomBorder then
          begin
            if TopBorder then
              TempB := TempB or (1 shl 2);
            if BottomBorder then
              TempB := TempB or (1 shl 3);
            if BordersFilled then
            begin
              if TopBorder then
                TempB := TempB or (1 shl 6);
              if BottomBorder then
                TempB := TempB or (1 shl 7);
            end;
            Data[Offset + 20] := BorderWidthVertical;  //BordersWidthV
          end
          else
          begin
            Data[Offset + 20] := 0;  //BordersWidthV
          end;

          Data[Offset + 18] := TempB;  //BordersFilled

          {$else}

          Data[Offset + 18] := 0;  //BordersFilled
          Data[Offset + 19] := 0;  //BordersWidthH
          Data[Offset + 20] := 0;  //BordersWidthV

          {$endif}
        end;

        //Reserved bytes
        Data[Offset + 21] := 0;  //Reserved - set to 0 for compatibility
        Data[Offset + 22] := 0;  //Reserved - set to 0 for compatibility
        Data[Offset + 23] := 0;  //Reserved - set to 0 for compatibility
        Data[Offset + 24] := 0;  //Reserved - set to 0 for compatibility
      end;
    end;
  end;

  
  end;
  //Append MainData to final Data
  AppendToDataArray(MainData, Data);
  SetLength(MainData, 0);

  finally

  HideLastWaitState;

  end;
end;

procedure TMainForm.ChangeLEDDisplayDataBtnClick(Sender: TObject);
begin
  //************************************
  if not License4.CheckLicenseStatusFull then
    Halt;
  if not LicenseTimer.Enabled then
    LicenseTimer.Enabled := True;
  //************************************

  if not ChangeLEDDisplayDataBtn.Enabled then  //Prevent potential software bugd (--> Refer to compatibility mode settings)
    Exit;

  TntXPMenu1.Active := not TntXPMenu1.Active;
  TntXPMenu1.Active := not TntXPMenu1.Active;

  //Show menu or run direct
  if GlobalOptions.NumOfLEDDisplays = 1 then
  begin
    //Run direct
    ChangeLEDDisplayDataMenuItem1.Click;
  end
  else
    //Show menu
    SpecialProcs.PopupMenuAtControl(ChangeLEDDisplayDataBtn, ChangeLEDDisplayDataPopup);
end;

procedure TMainForm.NextLayoutBtnClick(Sender: TObject);
begin
  if (DisplayStages[ActiveDisplayStage].LayoutIndex + 1) <= GetMaxLayoutIndex(GlobalOptions.LEDDisplaySettings.Height, GlobalOptions.LEDDisplaySettings.Width) then
  begin
    DisplayStages[ActiveDisplayStage].LayoutIndex := DisplayStages[ActiveDisplayStage].LayoutIndex + 1;
    //DisplayStages[ActiveDisplayStage].CustomLayout := False;
    SetLayout(DisplayStages[ActiveDisplayStage].Areas, DisplayStages[ActiveDisplayStage].LayoutIndex, GlobalOptions.LEDDisplaySettings.Height, GlobalOptions.LEDDisplaySettings.Width, DisplayStages[ActiveDisplayStage].CustomLayout);
    SetupLayout(DisplayStages[ActiveDisplayStage].Areas, LayoutBtn1, LayoutBtn2, LayoutBtn3, LayoutBtn4, LayoutGroup);
    LayoutChanged;
  end;
end;

procedure TMainForm.PreviousLayoutBtnClick(Sender: TObject);
begin
  if DisplayStages[ActiveDisplayStage].LayoutIndex > 1 then
  begin
    DisplayStages[ActiveDisplayStage].LayoutIndex := DisplayStages[ActiveDisplayStage].LayoutIndex - 1;
    //DisplayStages[ActiveDisplayStage].CustomLayout := False;
    SetLayout(DisplayStages[ActiveDisplayStage].Areas, DisplayStages[ActiveDisplayStage].LayoutIndex, GlobalOptions.LEDDisplaySettings.Height, GlobalOptions.LEDDisplaySettings.Width, DisplayStages[ActiveDisplayStage].CustomLayout);
    SetupLayout(DisplayStages[ActiveDisplayStage].Areas, LayoutBtn1, LayoutBtn2, LayoutBtn3, LayoutBtn4, LayoutGroup);
    LayoutChanged;
  end;
end;

procedure TMainForm.LayoutBtn1Click(Sender: TObject);
begin
  SelectArea((Sender as TControl).Tag, True);
end;

procedure TMainForm.LoadContentDefaultSettings(var Area: TArea);
begin
  with Area do
  begin
    DelayTime := 0;
    ContinuesToNextStage := False;
    AdvanceStageWhenDone := False;
    ForceAdvanceStageWhenDone := False;
    CompleteBeforeNextStage := True;
    Color := 0;

    AnimSpeed := 64;  //Fasr speed

    //Area borders
    TopBorder := False;
    BottomBorder := False;
    LeftBorder := False;
    RightBorder := False;
    BorderWidthHorizontal := 1;
    BorderWidthVertical := 1;
    BordersFilled := True;

    case ContentType of
      ctTime:
        begin
          RepeatAfterDone := True;  //This is not actually content-dependant

          TimeLanguage := laFarsi;
          ClockFormat := 1;  //hh:mm  --  better because in many cases the width of the display area in which clock is displayed is small
          ClockType := 0;
          ClockTotalDisplayTime := 15;
          PutClockAtCenter := True;
          ClockDotsBlink := True;
        end;
      ctDate:
        begin
          RepeatAfterDone := True;  //This is not actually content-dependant

          DateLanguage := laFarsi;
          DateType := 0;
          DateFormat := 4;
          DateTotalDisplayTime := 15;
          PutDateAtCenter := True;
        end;
      ctScrollingText:
        begin
          RepeatAfterDone := False;  //This is not actually content-dependant

          FixedText := False;
          TextLanguage := laMixed;
          TextDirection := 0;
          //TextScrollType := 0;  --> Converted to an effect
          if GlobalOptions.LEDDisplaySettings.Height > 24 then
            TextScrollSpeed := 2  //Fast
          else
            TextScrollSpeed := 1;  //Medium
          InvertScrollingText := False;
          ScrollingText := '';

          if GlobalOptions.LEDDisplaySettings.CanShowTextEffects then
            TextEntranceAnimID := 1
          else
            TextEntranceAnimID := 0;  //No animation

          TextTimingStyle := tsRepeatNTimes;
          TextRepetitionTimes := 2;
          TextTotalDisplayTime := 30;
          with ScrollingTextFontSettings do
          begin
            FontType := ftLCDFont;
            FarsiLCDFontName := GlobalOptions.FarsiFontName;
            EnglishLCDFontName := GlobalOptions.EnglishFontName;
            SystemFontFromFavoriteFonts := False;
          end;
          ScrollingTextLFGFileName := '';
          ScrollingTextType := ttSimpleText;
        end;
      ctSWF:
        begin
          RepeatAfterDone := True;  //This is not actually content-dependant

          SWFSensitivity := GlobalOptions.DefaultSWFSensitivity;
          SWFPlaySpeed := 1;  //Medium
          SWFTimingStyle := tsRepeatNTimes;
          SWFRepetitionTimes := 2;
          SWFTotalDisplayTime := 30;
          InvertSWF := False;
          PutSWFAtCenter := True;
          UseSWFTimings := False;
          SWFData.Clear;
        end;
      ctAnimation:
        begin
          RepeatAfterDone := True;  //This is not actually content-dependant

          AnimationIndex := 0;  //AnimationIndex is not used anymore
          AnimationName := '';  //Means no animation is selected by default
          AnimationPlaySpeed := 1;  //Medium
          AnimationTimingStyle := tsRepeatNTimes;
          AnimationRepetitionTimes := 2;
          AnimationTotalDisplayTime := 30;
          InvertAnimation := False;
          PutAnimationAtCenter := True;
          UseGIFTimings := True;
        end;
      ctPicture:
        begin
          RepeatAfterDone := True;  //This is not actually content-dependant

          PictureAvailable := False;
          ScrollingPicture := False;
          PictureBitmap.Width := 0;
          PictureBitmap.Height := 0;
          PictureTimingStyle := tsExactTiming;
          PictureRepetitionTimes := 1;
          PictureTotalDisplayTime := 15;
          InvertPicture := False;

          {
          if GlobalOptions.LEDDisplaySettings.CanShowTextEffects then
            PictureEntranceAnimID := 1
          else
            PictureEntranceAnimID := 0;  //No animation
          }
          PictureEntranceAnimID := 0;  //default is always with no animations

          PictureTextDirection := 1;  //Left
          //PictureTextScrollType := 1;  --> Converted to an effect
          if GlobalOptions.LEDDisplaySettings.Height > 24 then
            PictureTextScrollSpeed := 2  //Fast
          else
            PictureTextScrollSpeed := 1;  //Medium
        end;
      ctTemperature:
        begin
          RepeatAfterDone := True;  //This is not actually content-dependant

          TemperatureLanguage := laFarsi;
          TemperatureUnit := 0;  //Centigrade
          TemperatureTotalDisplayTime := 15;
          PutTemperatureAtCenter := True;
        end;                           
      ctEmpty:
        begin
          RepeatAfterDone := True;  //This is not actually content-dependant

          EmptyAreaFilled := True;
          EmptyAreaTotalDisplayTime := 5; 
        end;
    end;
  end;
end;

procedure TMainForm.LayoutChanged;
var
  i: Integer;
  AreaCount: Integer;
begin
  AreaCount := 0;
  for i := 1 to MAX_AREA_COUNT do
    if IsUnusedArea(DisplayStages[ActiveDisplayStage].Areas[i]) then
      Break
    else
      Inc(AreaCount);
  if ActiveAreaIndex > AreaCount then
  begin
    SelectArea(1, True);
  end;
  //ActiveAreaIndex := 1;
  //LayoutBtn1.Down := True;
  RefreshStagePanels;
  PrepareAreaSizeSection(ActiveAreaIndex);
  ActiveAreaSizeChanged;
end;

procedure TMainForm.ResetAllContentPages;
var
  Area: TArea;
  ct: TContentType;
begin
  ResetingContentPages := True;

  try

  Area.PictureBitmap := TBitmap.Create;
  Area.PictureBitmap.Width := 0;
  Area.PictureBitmap.Height := 0;

  Area.SWFData := TMemoryStream.Create;
  Area.SWFData.Clear;

  for ct := Low(TContentType) to High(TContentType) do
  begin
    Area.ContentType := ct;
    LoadContentDefaultSettings(Area);
    LoadAreaSpecificSettings(Area);
    case ct of
      ctTime:  LoadTimeContent(Area);
      ctDate:  LoadDateContent(Area);
      ctScrollingText:  LoadScrollingTextContent(Area);
      ctSWF: LoadSWFContent(Area);
      ctAnimation:  LoadAnimationContent(Area);
      ctPicture:
        begin
          LoadPictureContent(Area);
          UpdatePicturePicturePreview(True);
        end;
      ctTemperature:  LoadTemperatureContent(Area);
      ctEmpty:  LoadEmptyContent(Area);
    end;
  end;

  Area.PictureBitmap.Free;
  Area.SWFData.Free;

  TimePreviewImage.Picture.Bitmap.Width := 0;
  TimePreviewImage.Picture.Bitmap.Height := 0;
  DatePreviewImage.Picture.Bitmap.Width := 0;
  DatePreviewImage.Picture.Bitmap.Height := 0;
  TemperaturePreviewImage.Picture.Bitmap.Width := 0;
  TemperaturePreviewImage.Picture.Bitmap.Height := 0;
  EmptyPreviewImage.Picture.Bitmap.Width := 0;
  EmptyPreviewImage.Picture.Bitmap.Height := 0;

  finally

  ResetingContentPages := False;

  end;
end;

procedure TMainForm.PrepareEnvironmentForContent(
  ContentType: TContentType);
begin
  //if Assigned(TextPicturePreviewForm) then
  //  TextPicturePreviewForm.Visible := ContentType = ctScrollingText;
  if ContentType <> ctScrollingText then
  begin
    TextPreviewPanel.Hide;
    if Assigned(TextPicturePreviewForm) then
      TextPicturePreviewForm.Hide;
    ShowTextPreviewBtn.Down := False;
    AreaPreviewGroup.Hide;
  end;
  if ContentType <> ctPicture then
  begin
    PicturePreviewPanel.Hide;
  end;
  if ContentType <> ctTime then
  begin
    TimePreviewPanel.Hide;
  end;
  if ContentType <> ctDate then
  begin
    DatePreviewPanel.Hide;
  end;
  if ContentType <> ctTemperature then
  begin
    TemperaturePreviewPanel.Hide;
  end;
  if ContentType <> ctEmpty then
  begin
    EmptyPreviewPanel.Hide;
  end;

  try
    case ContentType of
      ctTime:
         begin
          TimePreviewPanel.Show;
          ContentControls[Integer(ContentType)].DefaultControl.SetFocus;
          //TimeContentPanel.SetFocus;
        end;
      ctDate:
        begin
          DatePreviewPanel.Show;
          ContentControls[Integer(ContentType)].DefaultControl.SetFocus;
          //DateContentPanel.SetFocus;
        end;
      ctScrollingText:
        begin
          TextPreviewPanel.Show;
          AreaPreviewGroup.Show;
          if SimpleTextTabBtn.Down then
            InputText.SetFocus
          else
            ContentControls[Integer(ContentType)].DefaultControl.SetFocus;
          //Self.SetFocus;
        end;
      ctAnimation:
        ContentControls[Integer(ContentType)].DefaultControl.SetFocus;
        //AnimationContentPanel.SetFocus;
      ctPicture:
        begin
          PicturePreviewPanel.Show;
          if SimplePictureTabBtn.Down then
            SimplePictureGroupBox.SetFocus
          else
            ContentControls[Integer(ContentType)].DefaultControl.SetFocus;
          //PictureContentPanel.SetFocus;
        end;
      ctTemperature:
        begin
          TemperaturePreviewPanel.Show;
          ContentControls[Integer(ContentType)].DefaultControl.SetFocus;
          //TemperatureContentPanel.SetFocus;
        end;
      ctEmpty:
        begin
          EmptyPreviewPanel.Show;
          ContentControls[Integer(ContentType)].DefaultControl.SetFocus;
          //EmptyContentPanel.SetFocus;
        end;
    end;
  except
  end;
end;

procedure TMainForm.ApplyFontSectionSettings;
  function GetStyle(Button: TSpeedButton; Style: TFontStyle): TFontStyles;
  begin
    if Button.Down then
      Result := [Style]
    else
      Result := [];
  end;
begin
  with FavoriteFontSamplePanel.Font do
  begin
    Style := GetStyle(Bold1, fsBold) + GetStyle(Italic1, fsItalic) + GetStyle(Underlined1, fsUnderline);
    try
      Size := StrToInt(FontSizeCombo1.Text);
    except
      FontSizeCombo1.Text := IntToStr(Size);
    end;
    if Size < 0 then
    begin
      Size := - Size;
      FontSizeCombo1.Text := IntToStr(Size);
    end;

    Name := FavoriteFontsCombo.Items.Strings[FavoriteFontsCombo.ItemIndex];
    Charset := DEFAULT_CHARSET;  //Always set the Charset to DEFAULT_CHARSET, otherwise the characters will not be displayed correctly
  end;

  with FontSamplePanel.Font do
  begin
    Style := GetStyle(Bold2, fsBold) + GetStyle(Italic2, fsItalic) + GetStyle(Underlined2, fsUnderline);
    try
      Size := StrToInt(FontSizeCombo2.Text);
    except
      FontSizeCombo2.Text := IntToStr(Size);
    end;
    if Size < 0 then
    begin
      Size := - Size;
      FontSizeCombo2.Text := IntToStr(Size);
    end;

    Name := AllFontsCombo.Items.Strings[AllFontsCombo.ItemIndex];
    Charset := DEFAULT_CHARSET;  //Always set the Charset to DEFAULT_CHARSET, otherwise the characters will not be displayed correctly
  end;

  Application.ProcessMessages;
  //s := InputText.Text;
  //InputText.Text := '';
  //InputText.Text := s;
  if Assigned(InputText.OnDelayedChange) then
    InputText.OnDelayedChange(InputText);
end;

procedure TMainForm.UpdateHxW(Font: TFont; HxWPanel: TTntPanel; Text: WideString);
begin
  if Length(Text) > 0 then
  begin
    //TextToLCD(Text, Font,TextToLCDGrid);
    //HxWPanel.Caption := IntToStr(TextToLCDGrid.RowCount) + ' x ' + IntToStr(TextToLCDGrid.ColCount);
  end
  else
    //HxWPanel.Caption := 'H x W';
end;

{$HINTS OFF}
function TMainForm.PerformTextToLCDFromSystemFonts: Boolean;
var
  Row, Col: Integer;
begin
  Result := False;

  if SystemFontsSection.ActivePage.PageIndex = FavoriteFontsTabSheet.PageIndex then
    TextToLCD(InputText.Text, FavoriteFontSamplePanel.Font, TextToLCDGrid)
  else
    TextToLCD(InputText.Text, FontSamplePanel.Font, TextToLCDGrid);


  {if InputTextFarsiRadio.Checked then  //LCDGrid.BiDiMode = bdRightToLeft then
  begin
    TextToLCDGrid.SelectRows(0, TextToLCDGrid.RowCount);
    LCDProcs.FlipSelectionHorizontally(TextToLCDGrid);
  end;}

{  for Row := LCDGrid.Row to LCDGrid.Row + TextToLCDGrid.RowCount - 1 do
    for Col := LCDGrid.Col to LCDGrid.Col + TextToLCDGrid.ColCount - 1 do
    begin
      LCDGrid.Colors[Col, Row] := TextToLCDGrid.Colors[Col - LCDGrid.Col, Row - LCDGrid.Row];
      LCDGrid.ColorsTo[Col, Row] := TextToLCDGrid.ColorsTo[Col - LCDGrid.Col, Row - LCDGrid.Row];
    end;}

  Result := True;
end;
{$HINTS ON}

procedure TMainForm.InputTextDelayedChange(Sender: TObject);
var
  FontFolderList: TTntStringList;
  LCDFont: TLCDFont;
  TextBiDiMode: TBiDiMode;
begin
  if (InputText.Text <> '') and not RuntimeGlobalOptions.ShowTextPreview then
    Exit;
  
  ShowProgress;

  if InputTextEnglishRadio.Checked then
    TextBiDiMode := bdLeftToRight
  else
    TextBiDiMode :=  bdRightToLeft;

  if LCDFontsSourceRadio.Checked then
  begin
    FontFolderList := TTntStringList.Create;
    FontFolderList.Clear;
    if InputTextFarsiRadio.Checked or InputTextMixedRadio.Checked then
    begin
      if FindFont(FarsiLCDFontsCombo.Items.Strings[FarsiLCDFontsCombo.ItemIndex], laFarsi, LCDFont) then
        FontFolderList.Append(LCDFont.Path);
    end;
    if InputTextEnglishRadio.Checked or InputTextMixedRadio.Checked then
    begin
      if FindFont(EnglishLCDFontsCombo.Items.Strings[EnglishLCDFontsCombo.ItemIndex], laEnglish, LCDFont) then
        FontFolderList.Append(LCDFont.Path);
    end;
    TextToLCDGrid.RowCount := 1;
    TextToLCDGrid.ColCount := 1;

    PerformTextToLCDFromCharacterLibrary(InputText.Text, TextBiDiMode, FontFolderList, TextToLCDGrid);
    FontFolderList.Free;
  end
  else
    PerformTextToLCDFromSystemFonts;

  UpdateTextPicturePreview;

  HideProgress;
end;

procedure TMainForm.LCDToBitmap(ALCD: TAdvStringGrid; ABitmap: TBitmap;
  ReserveOneColForTransparency: Boolean);
var
  Row, Col, BitmapColOffset: Integer;
begin
  ABitmap.Width := ALCD.ColCount;
  ABitmap.Height := ALCD.RowCount;// - 1;
  if ReserveOneColForTransparency then
  begin
    if ALCD.Colors[0, ALCD.RowCount - 1] = LCDFilledColor then
    begin
      BitmapColOffset := 1;
      ABitmap.Width := ABitmap.Width + 1;
      for Row := 0 to ABitmap.Height - 1 do
        ABitmap.Canvas.Pixels[0, Row] := LCDClearedColor;
    end
    else
      BitmapColOffset := 0;
  end
  else
    BitmapColOffset := 0;

  for Row := 0 to ALCD.RowCount - 1 do
    for Col := 0 to ALCD.ColCount - 1 do
      if ALCD.Colors[Col, Row] = LCDFilledColor then  //*** Only use Colors values
        ABitmap.Canvas.Pixels[Col + BitmapColOffset, Row] := LCDFilledColor
      else
        ABitmap.Canvas.Pixels[Col + BitmapColOffset, Row] := LCDClearedColor;
end;

procedure TMainForm.UpdateTextPicturePreview;
var
  b: TBitmap;
begin
  if not Assigned(TextPicturePreviewForm) then
    Exit;

  if TextToLCDGrid.Tag = 0 then
  begin
    //-- Update TextPicturePreviewForm
    //No data is generated
    ClearImage(TextPicturePreviewForm.PreviewImage);  //Hides the image control
    //Hide any font size warning if available
    ShowFontSizeWarning(False);
    //Clear and reset the grid
    with TextPicturePreviewForm.TextPreviewGrid do
    begin
      ColCount := 8;
      RowCount := 9;
      DefaultRowHeight := DefaultRowHeight;
      RowHeights[RowCount - 1] := 0;
      LCDProcs.ClearLCD(TextPicturePreviewForm.TextPreviewGrid, LCDClearedColor);
      TextPicturePreviewForm.UpdateInfo;
      TextPicturePreviewForm.PositionLCD;
    end;
    //-- Update TextPreviewPanel(.TextPreviewImage)
    ClearImage(TextPreviewImage);  //Hides the image control
    Exit;
  end;
  //TextPicturePreviewForm.PreviewImage.Show;  --> TextPreviewGrid is used instead
  TextPreviewImage.Show;

//  if not TextPicturePreviewForm.Visible then
//    Exit;

//  TextPicturePreviewForm.Tag := 0;  //Up-to-date

//  if (LCDPicturePreviewForm.PreviewImage.Picture.Bitmap.Width <> LCDGrid.ColCount) or
//     (LCDPicturePreviewForm.PreviewImage.Picture.Bitmap.Height <> (LCDGrid.RowCount - 1)) then
//  begin
    b := TBitmap.Create;
    try
      LCDToBitmap(TextToLCDGrid, b, True);
      //Procs.ScaleBitmap(b, TextPicturePreviewForm.PreviewImage.Picture.Bitmap, Trunc(TextPicturePreviewForm.PreviewImage.Height * 100 / b.Height));
      ShowFontSizeWarning(FitImageToArea(b, DisplayStages[ActiveDisplayStage].Areas[ActiveAreaIndex], False));
      TextPicturePreviewForm.PreviewImage.Picture.Bitmap.Assign(b);
      TextPreviewImage.Picture.Bitmap.Assign(b);
      //The Stretch property is set to False by ClearImage procedure. Reset it to True.
      TextPicturePreviewForm.PreviewImage.Stretch := True;
      BitmapToLCD(b, TextPicturePreviewForm.TextPreviewGrid, 0, True);
      TextPicturePreviewForm.UpdateInfo;
      TextPicturePreviewForm.PositionLCD;
      TextPreviewImage.Stretch := True;
    finally
      b.Free;
    end;
//  end;
end;

procedure TMainForm.UpdatePicturePicturePreview(OnlyClearPreview: Boolean = False);
var
  b, btemp: TBitmap;
begin
  if OnlyClearPreview then  //Only reset (clear) the preview?
  begin
    ClearImage(PictureContentPreviewImage);  //The TImage control is also made hidden by this procedure
    Exit;
  end;

  if DisplayStages[ActiveDisplayStage].Areas[ActiveAreaIndex].ContentType <> ctPicture then Exit;

  if DisplayStages[ActiveDisplayStage].Areas[ActiveAreaIndex].PictureAvailable and
     (PicturePreviewImage.Picture.Bitmap.Width > 0) and
     (PicturePreviewImage.Picture.Bitmap.Height > 0) then  //So the picture contains bitmap with image
  begin
    b := TBitmap.Create;
    b.Assign(PicturePreviewImage.Picture.Bitmap);
    NormalizeBitmapForeground(b);
    FitImageToArea(b, DisplayStages[ActiveDisplayStage].Areas[ActiveAreaIndex], False);
    //Make the picture transparent
    if b.Canvas.Pixels[0, b.Height - 1] <> LCDClearedColor then
    begin
      //Add one column to the left of the bitmap and make its color LCDClearedColor
      btemp := TBitmap.Create;
      btemp.Width := b.Width + 1;
      btemp.Height := b.Height;
      btemp.Canvas.Brush.Style := bsSolid;
      btemp.Canvas.Brush.Color := clWhite;
      btemp.Canvas.FillRect(Rect(1, 1, btemp.Width, btemp.Height));
      btemp.Canvas.Draw(1, 0, b);
      b.Assign(btemp);
      btemp.Free;
    end;
    PictureContentPreviewImage.Picture.Bitmap.Assign(b);
    PictureContentPreviewImage.Stretch := True;
    PictureContentPreviewImage.Show;
    b.Free;
  end
  else
  begin  //no bitmap in the picture
    ClearImage(PictureContentPreviewImage);  //The TImage control is also made hidden by this procedure
  end;
end;

function TMainForm.FitImageToArea(Bitmap: TBitmap;
  const Area: TArea; FitWidth: Boolean): Boolean;

  //Returns True if the bitmap is changed
  //Returns False if no change has been applied to the bitmap

  function CountFilledCellsInRows(AGrid: TAdvStringGrid; RowNums: array of Integer): Integer;
  var
    Col, i: Integer;
  begin
    Result := 0;
    for i := Low(RowNums) to High(RowNums) do
    begin
      for Col := 0 to AGrid.ColCount - 1 do
        if AGrid.Colors[Col, RowNums[i]] = LCDFilledColor then
          Inc(Result);
    end;
  end;

  function CountFilledCellsInColumns(AGrid: TAdvStringGrid; ColNums: array of Integer): Integer;
  var
    Row, i: Integer;
  begin
    Result := 0;
    for i := Low(ColNums) to High(ColNums) do
    begin
      for Row := 0 to AGrid.RowCount - 1 do
        if AGrid.Colors[ColNums[i], Row] = LCDFilledColor then
          Inc(Result);
    end;
  end;

var
  LCDGrid: TAdvStringGrid;
  Row, Col: Integer;
  AreaHeight, AreaWidth: Integer;
  AddToTop, AddToLeft: Boolean;
  i: Integer;
  AddedCol: Integer;
  Count1, Count2: Integer;
begin
  {$HINTS OFF}
  Result := False;
  {$HINTS ON}

  LCDGrid := TAdvStringGrid.Create(nil);
  LCDGrid.Visible := False;
  LCDGrid.Parent := Self;

  LCDGrid.ColCount := Bitmap.Width;
  LCDGrid.RowCount := Bitmap.Height;

  for Row := 0 to LCDGrid.RowCount - 1 do
    for Col := 0 to LCDGrid.ColCount - 1 do
      LCDGrid.Colors[Col, Row] := Bitmap.Canvas.Pixels[Col, Row];

  AreaHeight := Area.y2 - Area.y1 + 1;
  AreaWidth := Area.x2 - Area.x1 + 1;

  //Fit height
  if LCDGrid.RowCount > AreaHeight then
  begin
    //Crop the image
    //Crop from bottom or top?
    if LCDGrid.RowCount > 3 then
    begin
      Count1 := CountFilledCellsInRows(LCDGrid, [0, 1, 2]);
      Count2 := CountFilledCellsInRows(LCDGrid, [LCDGrid.RowCount - 1, LCDGrid.RowCount - 2, LCDGrid.RowCount - 3]);
    end
    else if LCDGrid.RowCount > 2 then
    begin
      Count1 := CountFilledCellsInRows(LCDGrid, [0, 1]);
      Count2 := CountFilledCellsInRows(LCDGrid, [LCDGrid.RowCount - 1, LCDGrid.RowCount - 2]);
    end
    else
    begin
      Count1 := CountFilledCellsInRows(LCDGrid, [0]);
      Count2 := CountFilledCellsInRows(LCDGrid, [LCDGrid.RowCount - 1]);
    end;
    if Count1 < Count2 then
    begin
      //Crop from top
      LCDGrid.RemoveRows(0, LCDGrid.RowCount - AreaHeight);
    end
    else
    begin
      //Crop from bottom
      LCDGrid.RemoveRows(LCDGrid.RowCount - (LCDGrid.RowCount - AreaHeight), LCDGrid.RowCount - AreaHeight);
    end;
  end
  else if LCDGrid.RowCount < AreaHeight then
  begin
    //Add new rows and colorize them
    AddToTop := True;
    for i := 1 to AreaHeight - LCDGrid.RowCount do
    begin
      if AddToTop then
      begin
        LCDGrid.InsertRows(0, 1);
        LCDGrid.RowColor[0] := LCDClearedColor;
      end
      else
      begin
        LCDGrid.InsertRows(LCDGrid.RowCount, 1);
        LCDGrid.RowColor[LCDGrid.RowCount - 1] := LCDClearedColor;
      end;
      AddToTop := not AddToTop;
    end;
  end;


  //Fit width
  if FitWidth then
  begin
    if LCDGrid.ColCount > AreaWidth then
    begin
      //Crop the image
      //Crop from right or left?
      if LCDGrid.ColCount > 2 then
      begin
        Count1 := CountFilledCellsInColumns(LCDGrid, [0, 1]);
        Count2 := CountFilledCellsInColumns(LCDGrid, [LCDGrid.ColCount - 1, LCDGrid.ColCount - 2]);
      end
      else
      begin
        Count1 := CountFilledCellsInColumns(LCDGrid, [0]);
        Count2 := CountFilledCellsInColumns(LCDGrid, [LCDGrid.ColCount - 1]);
      end;
      if Count1 < Count2 then
      begin
        //Crop from left
        LCDGrid.RemoveCols(0, LCDGrid.ColCount - AreaWidth);
      end
      else
      begin
        //Crop from right
        LCDGrid.RemoveCols(LCDGrid.ColCount - 1, LCDGrid.ColCount - AreaWidth);
      end;
    end
    else
    begin
      //Add new columns and colorize them
      AddToLeft := True;
      for i := 1 to AreaWidth - LCDGrid.ColCount do
      begin
        if AddToLeft then
        begin
          LCDGrid.InsertCols(0, 1);
          AddedCol := 0;
        end
        else
        begin
          LCDGrid.InsertCols(LCDGrid.ColCount, 1);
          AddedCol := LCDGrid.ColCount - 1;
        end;
        //Colorize the new column
        for Row := 0 to LCDGrid.RowCount - 1 do
          LCDGrid.Colors[AddedCol, Row] := LCDClearedColor;
        AddToLeft := not AddToLeft;
      end;
    end;
  end;

  //Update image if necessary
  Result := (LCDGrid.ColCount < Bitmap.Width) or
            (LCDGrid.RowCount < Bitmap.Height);
  LCDToBitmap(LCDGrid, Bitmap, True);

  LCDGrid.Free;
end;

procedure TMainForm.AllFontsComboChange(Sender: TObject);
begin
  ApplyFontSectionSettings;
  AddToFavoriteFontsBtn.Enabled := not(FavoriteFontsCombo.Items.IndexOf(AllFontsCombo.Items.Strings[AllFontsCombo.ItemIndex]) >= 0);
  AllFontsCombo.Hint := AllFontsCombo.Items.Strings[AllFontsCombo.ItemIndex];
end;

procedure TMainForm.FavoriteFontsComboChange(Sender: TObject);
begin
  ApplyFontSectionSettings;
  RemoveFromFavoriteFontsBtn.Enabled := FavoriteFontsCombo.ItemIndex >= 0;
  if FavoriteFontsCombo.ItemIndex >= 0 then
    FavoriteFontsCombo.Hint := FavoriteFontsCombo.Items.Strings[FavoriteFontsCombo.ItemIndex]
  else
    FavoriteFontsCombo.Hint := '';
end;

procedure TMainForm.Bold1Click(Sender: TObject);
begin
  FontSizeCombo2.Enabled := False;
  FontSizeCombo1.Enabled := False;
  try
    ApplyFontSectionSettings;
  finally
    FontSizeCombo2.Enabled := True;
    FontSizeCombo1.Enabled := True;
    if Sender = FontSizeCombo2 then
      FontSizeCombo2.SetFocus
    else if Sender = FontSizeCombo1 then
      FontSizeCombo1.SetFocus;
  end;
end;

procedure TMainForm.GetLCDFontList(var LCDFontList: TLCDFontList);

  procedure GetFontInfo(const FontPath: WideString; var LCDFont: TLCDFont);
  var
    sl: TTntStringList;
  begin
    if WideFileExists(FontPath + '\' + FONT_INFO_FILE_NAME) then
    begin
      sl := TTntStringList.Create;
      sl.LoadFromFile(FontPath + '\' + FONT_INFO_FILE_NAME);

      LCDFont.Name := sl.Strings[0];
      LCDFont.PreviewImageFileName := FontPath + '\' + FONT_PREVIEW_FILE_NAME;

      sl.Free;
    end
    else
    begin
      LCDFont.Name := WideExtractFileName(FontPath);
      LCDFont.PreviewImageFileName := FontPath + '\' + FONT_PREVIEW_FILE_NAME;
    end;
  end;

  procedure GetFontDirList(const Path: WideString; var List: TLCDFontList; FontLanguage: TLanguage);
  var
    FSR: TSearchRecW;
  begin
    if WideFindFirst(Path + '\*.*', faAnyFile, FSR) = 0 then
    begin
      repeat
        if ((FSR.Attr and faSysFile)=0) and
           ((FSR.Attr and faSymLink)=0) and
           ((FSR.Attr and faVolumeID)=0) then
        begin
          if ((FSR.Attr and faDirectory) <> 0) and
             (FSR.Name[1] <> '.') then
          begin
            //FSR now is a directory only not a file
            SetLength(List, Length(List) + 1);
            List[High(List)].Path := Path + '\' + FSR.Name;
            List[High(List)].Language := FontLanguage;
            //List any font in the folder not only those fonts which have font info file.
            //if FileExists(Path + '\' + FSR.Name + '\' + FONT_INFO_FILE_NAME) then
            //begin
              GetFontInfo(Path + '\' + FSR.Name, List[High(List)]);
            //end;
          end;
        end;
      until WideFindNext(FSR)<>0;
    end;
    WideFindClose(FSR);
  end;

begin
  SetLength(LCDFontList, 0);
  GetFontDirList(ApplicationPath + FARSI_FONTS_PATH, LCDFontList, laFarsi);
  GetFontDirList(ApplicationPath + ENGLISH_FONTS_PATH, LCDFontList, laEnglish);
end;

procedure TMainForm.TntFormDestroy(Sender: TObject);
begin
  SetLength(LCDFonts, 0);
  SetLength(LCDGIFAnimations, 0);
  SetLength_DisplayStages(DisplayStages, 0);
  SetLength_DisplayStages(OldDisplayStages, 0);

  {
  try
    FadedDraw.Free;
  except
  end;
  }

  if Assigned(MusicFilesList) then
    MusicFilesList.Free;
end;

procedure TMainForm.LCDFontsSourceRadioClick(Sender: TObject);
begin
  PrepareContentControls(ctScrollingText);
  
  if LCDFontsSourceRadio.Checked then
  begin
    LCDFontsSection.BringToFront;
    if Assigned(InputText.OnDelayedChange) then
      InputText.OnDelayedChange(InputText);
  end;
end;

procedure TMainForm.SystemFontsSourceRadioClick(Sender: TObject);
begin
  PrepareContentControls(ctScrollingText);
  
  if SystemFontsSourceRadio.Checked then
  begin
    SystemFontsSection.BringToFront;
    if Assigned(InputText.OnDelayedChange) then
      InputText.OnDelayedChange(InputText);
  end;
end;

function TMainForm.FindFont(const FontName: WideString;
   FontLanguage: TLanguage; var LCDFont: TLCDFont): Boolean;
var
  i: Integer;
begin
  Result := False;
  for i := 0 to High(LCDFonts) do
    if (LCDFonts[i].Language = FontLanguage) and
       (WideCompareStr(LCDFonts[i].Name, FontName) = 0) then
    begin
      LCDFont := LCDFonts[i];
      Result := True;
      Break;
    end;
end;

procedure TMainForm.FarsiLCDFontsComboChange(Sender: TObject);
var
  LCDFont: TLCDFont;
begin
  if FarsiLCDFontsCombo.ItemIndex < 0 then
  begin
    with FarsiLCDFontPreviewImage.Picture.Bitmap do
    begin
      Width := 0;
      Height := 0;
    end;
    Exit;
  end;

  if FindFont(FarsiLCDFontsCombo.Items.Strings[FarsiLCDFontsCombo.ItemIndex], laFarsi, LCDFont) then
  begin
    if not LoadLCDFontPreviewImage(LCDFont.PreviewImageFileName, FarsiLCDFontPreviewImage) then
      GenerateLCDFontPreviewImage(FarsiLCDFontPreviewImage, laFarsi);
  end;
  if Assigned(InputText.OnDelayedChange) then
    InputText.OnDelayedChange(InputText);
end;

procedure TMainForm.EnglishLCDFontsComboChange(Sender: TObject);
var
  LCDFont: TLCDFont;
begin
  if EnglishLCDFontsCombo.ItemIndex < 0 then
  begin
    ClearImage(EnglishLCDFontPreviewImage);
    Exit;
  end;
  EnglishLCDFontPreviewImage.Show;

  if FindFont(EnglishLCDFontsCombo.Items.Strings[EnglishLCDFontsCombo.ItemIndex], laEnglish, LCDFont) then
  begin
    if not LoadLCDFontPreviewImage(LCDFont.PreviewImageFileName, EnglishLCDFontPreviewImage) then
      GenerateLCDFontPreviewImage(EnglishLCDFontPreviewImage, laEnglish);
  end;
  if Assigned(InputText.OnDelayedChange) then
    InputText.OnDelayedChange(InputText);
end;

function TMainForm.LoadLCDFontPreviewImage(const ImageFileName: WideString;
  PreviewImage: TImage): Boolean;
var
  GIFImage: TGIFImage;
begin
  Result := False;
  if WideFileExists(ImageFileName) then
  begin
    GIFImage := TGIFImage.Create;
    try
      WideLoadGIFImageFromFile(ImageFileName, GIFImage);
      //GIFImage.LoadFromFile(ImageFileName);
      PreviewImage.Picture.Graphic := GIFImage;
      Result := True;
    except
    end;
    GIFImage.Free;
  end;
end;

function TMainForm.ConvertBinToHex(const BinStr: String): String;
  function NibbleToHex(const Nibble:String):String;
  begin
    if      Nibble='0000' then Result:='0'
    else if Nibble='0001' then Result:='1'
    else if Nibble='0010' then Result:='2'
    else if Nibble='0011' then Result:='3'
    else if Nibble='0100' then Result:='4'
    else if Nibble='0101' then Result:='5'
    else if Nibble='0110' then Result:='6'
    else if Nibble='0111' then Result:='7'
    else if Nibble='1000' then Result:='8'
    else if Nibble='1001' then Result:='9'
    else if Nibble='1010' then Result:='A'
    else if Nibble='1011' then Result:='B'
    else if Nibble='1100' then Result:='C'
    else if Nibble='1101' then Result:='D'
    else if Nibble='1110' then Result:='E'
    else if Nibble='1111' then Result:='F';
  end;
var
  i:Integer;
  S:String;
begin
  Result:='';
  i:=Length(BinStr);
  while i>0 do
  begin
    if i>4 then
    begin
      S:=Copy(BinStr,i-3,4);
      i:=i-4;
    end
    else
    begin
      S:=Copy(BinStr,1,i);
      i:=0;
    end;
    Insert(StringOfChar('0',4-Length(S)),S,1);
    Insert(NibbleToHex(S),Result,1);
  end;
end;

procedure TMainForm.InputTextFarsiRadioClick(Sender: TObject);
begin
  InputText.BiDiMode := SetCorrectKeyboardLayout;

  //Force to change the language
  try
    InputText.SetFocus;
  except
  end;

  try
    InputTextFarsiRadio.SetFocus;
  except
  end;
  Application.ProcessMessages;

  TextDirectionRightRadio.Checked := InputTextFarsiRadio.Checked or InputTextMixedRadio.Checked;
  InputText.OnDelayedChange(InputText);
  InputText.SetFocus;
end;

procedure TMainForm.InputTextEnglishRadioClick(Sender: TObject);
begin
  InputText.BiDiMode := SetCorrectKeyboardLayout;

  //Force to change the language
  try
    InputText.SetFocus;
  except
  end;

  try
    InputTextEnglishRadio.SetFocus;
  except
  end;
  Application.ProcessMessages;

  TextDirectionLeftRadio.Checked := InputTextEnglishRadio.Checked;
  InputText.OnDelayedChange(InputText);
  try
    InputText.SetFocus;
  except
  end;
end;

procedure TMainForm.ShowTextPreviewBtnClick(Sender: TObject);
begin
//  ShowTextPreviewBtn.Down := not ShowTextPreviewBtn.Down;
  if Assigned(TextPicturePreviewForm) then
    TextPicturePreviewForm.Visible := ShowTextPreviewBtn.Down;
  try
    if MainForm.Enabled then
      MainForm.SetFocus;
  except
  end;
end;

procedure TMainForm.InputTextKeyPress(Sender: TObject; var Key: Char);
begin
  ShowTextPreviewBtn.Click;
end;

procedure TMainForm.GetGIFAnimationsList(var AnimList: TLCDGIFAnimations);
var
  sl: TTntStringList;
  i, j: Integer;
  FSR: TSearchRecW;
  OtherAnimsList: TTntStringList;
  NewAnim: Boolean;
  MainAnimsCount: Integer;
begin
  sl := TTntStringList.Create;
  if FileExists(ApplicationPath + GIF_ANIMATIONS_FOLDER_NAME + '\' + GIF_ANIMATIONS_FILE_NAME) then
    sl.LoadFromFile(ApplicationPath + GIF_ANIMATIONS_FOLDER_NAME + '\' + GIF_ANIMATIONS_FILE_NAME);
  SetLength(AnimList, sl.Count div 2);
  for i := 0 to High(AnimList) do
  begin
    AnimList[i].Description := sl.Strings[i * 2];
    AnimList[i].FileName := ApplicationPath + GIF_ANIMATIONS_FOLDER_NAME + '\' + sl.Strings[i * 2 + 1];
  end;
  sl.Free;

  //Get list of other files not listed in the GIF_ANIMATIONS_FILE_NAME
  OtherAnimsList := TTntStringList.Create;
  if WideFindFirst(ApplicationPath + GIF_ANIMATIONS_FOLDER_NAME + '\*.gif', faAnyFile, FSR) = 0 then
  begin
    repeat
      if ((FSR.Attr and faSysFile)=0) and
         ((FSR.Attr and faSymLink)=0) and
         ((FSR.Attr and faVolumeID)=0) then
      begin
        if ((FSR.Attr and faDirectory) = 0) and
           (FSR.Name[1] <> '.') then
        begin
          if WideFileExists(ApplicationPath + GIF_ANIMATIONS_FOLDER_NAME + '\' + FSR.Name) then
            OtherAnimsList.Append(ApplicationPath + GIF_ANIMATIONS_FOLDER_NAME + '\' + FSR.Name);
        end;
      end;
    until WideFindNext(FSR) <> 0;
  end;
  WideFindClose(FSR);

  //Add other animations to the AnimList
  OtherAnimsList.Sorted := True;
  MainAnimsCount := Length(AnimList);
  for i := 0 to OtherAnimsList.Count - 1 do
  begin
    NewAnim := True;
    for j := 0 to MainAnimsCount - 1 do
      if AnimList[j].FileName = OtherAnimsList.Strings[i] then
      begin
        NewAnim := False;
        Break;
      end;
    if NewAnim then
    begin
      SetLength(AnimList, Length(AnimList) + 1);
      AnimList[High(AnimList)].FileName := OtherAnimsList.Strings[i];
      AnimList[High(AnimList)].Description := Copy(WideExtractFileName(OtherAnimsList.Strings[i]), 1, Length(WideExtractFileName(OtherAnimsList.Strings[i])) - Length(WideExtractFileExt(OtherAnimsList.Strings[i])));
    end;
  end;
  OtherAnimsList.Free;
end;

procedure TMainForm.GIFAnimationsListClick(Sender: TObject);
var
  GIFImage: TGIFImage;
begin
  if (GIFAnimationsList.Items.Count > 0) and
     (GIFAnimationsList.ItemIndex >= 0) then
  begin
    if not WideFileExists(LCDGIFAnimations[GIFAnimationsList.ItemIndex].FileName) then
    begin
      WideMessageDlgSound(Dyn_Texts[74] {'File of the selected animation cannot be found.'}, mtError, [mbOK], 0);
      Exit;
    end;

    GIFImage := TGIFImage.Create;

    try
      WideLoadGIFImageFromFile(LCDGIFAnimations[GIFAnimationsList.ItemIndex].FileName, GIFImage);
      AnimationWidthLabel.Caption := IntToStr(GIFImage.Images[0].Bitmap.Width);
      AnimationHeightLabel.Caption := IntToStr(GIFImage.Images[0].Bitmap.Height);
    except
      GIFImage.Free;
      AnimationWidthLabel.Caption := '0';
      AnimationHeightLabel.Caption := '0';
      WideMessageDlgSound(Dyn_Texts[75] {'Invalid GIF animation file.'}, mtError, [mbOK], 0);
      Exit;
    end;

    AnimationPreviewImage.Picture.Graphic := GIFImage;
    GIFImage.Free;
  end
  else
  begin
    AnimationPreviewImage.Picture.Graphic := nil;
    AnimationWidthLabel.Caption := '0';
    AnimationHeightLabel.Caption := '0';
  end;
end;

function TMainForm.SpeedIndexToSpeedValue(SpeedIndex: Integer): Integer;
begin
  //If this function is changed, also update the SelectScrollStep function.
  //Very Fast (0-51), Fast (52-103), Medium (104-155), Slow (156-207), Very Slow (208-255)
  case SpeedIndex of
    //0:  //Very slow  --> Very Slow speed has been removed
    //  Result := 255;
    0:  //Slow
      Result := 192;
    1:  //Medium
      Result := 128;
    2:  //Fast
      Result := 64;
    3:  //Very fast
      Result := 0;
  end;
end;

procedure TMainForm.BitmapToLCD(Bitmap: TBitmap; ALCD: TAdvStringGrid;
  NumOfColsToIgnoreFromLeft: Integer; AdvGridCompensation: Boolean);
var
  Col, Row: Integer;
begin
  if NumOfColsToIgnoreFromLeft > Bitmap.Width then
    Exit;
  ALCD.ColCount := Bitmap.Width - NumOfColsToIgnoreFromLeft;
  ALCD.RowCount := Bitmap.Height;

  for Col := NumOfColsToIgnoreFromLeft to Bitmap.Width - 1 do
    for Row := 0 to Bitmap.Height - 1 do
      if Bitmap.Canvas.Pixels[Col, Row] = LCDFilledColor then
        ALCD.Colors[Col - NumOfColsToIgnoreFromLeft, Row] := LCDFilledColor
      else
        ALCD.Colors[Col - NumOfColsToIgnoreFromLeft, Row] := LCDClearedColor;
  if AdvGridCompensation then
  begin
    ALCD.RowCount := ALCD.RowCount + 1;
    ALCD.DefaultRowHeight := ALCD.DefaultRowHeight;
    ALCD.RowHeights[ALCD.RowCount - 1] := 0;
  end;
end;

procedure TMainForm.SetCellColor(ALCDGrid: TAdvStringGrid; ACol,
  ARow: Integer; Filled: Boolean);
begin
  ALCDGrid.ColorsTo[ACol, ARow] := clNone;  //This prevents potential software bugs by disabling the ColorsTo value
  
  if Filled then
    ALCDGrid.Colors[ACol, ARow] := LCDFilledColor
  else
    ALCDGrid.Colors[ACol, ARow] := LCDClearedColor;
end;

procedure TMainForm.ImportPictureBtnClick(Sender: TObject);
var
  b: TBitmap;
begin
  if not ImportNewPictureRadio.Checked then
    ImportNewPictureRadio.Checked := True;

  b := TBitmap.Create;
  ImportGraphicsForm.ResultBitmap := b;
  if ImportGraphicsForm.ShowModal = mrOk then
  begin
    PicturePreviewImage.Show;  //It may be hidden

    PicturePreviewImage.Picture.Graphic := b;

    PicturePreviewImage.Stretch := True;

    PictureWidthLabel.Caption := IntToStr(PicturePreviewImage.Picture.Bitmap.Width);
    PictureHeightLabel.Caption := IntToStr(PicturePreviewImage.Picture.Bitmap.Height);
    DisplayStages[ActiveDisplayStage].Areas[ActiveAreaIndex].PictureAvailable := True;

    DesignChangeFlag := True;

    UpdatePicturePicturePreview;
  end;
  b.Free;
end;

procedure TMainForm.ToggleCellColor(ALCDGrid: TAdvStringGrid; ACol,
  ARow: Integer);
begin
  if ALCDGrid.Colors[ACol, ARow] = LCDFilledColor then
    SetCellColor(ALCDGrid, ACol, ARow, False)
  else
    SetCellColor(ALCDGrid, ACol, ARow, True);
end;

procedure TMainForm.InvertLCD(ALCD: TAdvStringGrid;
  OnlySelection: Boolean);
var
  Row, Col: Integer;
  FromRow, ToRow, FromCol, ToCol: Integer;
begin
  if OnlySelection then
  begin
    FromRow := ALCD.Selection.Top;
    ToRow := ALCD.Selection.Bottom;
    FromCol := ALCD.Selection.Left;
    ToCol := ALCD.Selection.Right;
  end
  else
  begin
    FromRow := 0;
    ToRow := ALCD.RowCount - 2;
    FromCol := 0;
    ToCol := ALCD.ColCount - 1;
  end;

  try
    ALCD.BeginUpdate;

    for Row:=FromRow to ToRow do
      for Col:=FromCol to ToCol do
        ToggleCellColor(ALCD, Col, Row);
  finally
    ALCD.EndUpdate;
  end;
end;

procedure TMainForm.SetLength_DisplayStages(var Stages: TStagesArray;
  NewSize: Integer);
var
  i, j: Integer;
  OldSize: Integer;
begin
  if NewSize < Length(Stages) then
  begin
{    for i := High(Stages) downto NewSize do
      for j := 1 to MAX_AREA_COUNT do
        if Assigned(Stages[i].Areas[j].PictureBitmap) then
          Stages[i].Areas[j].PictureBitmap.Free;}
    SetLength(Stages, NewSize);
  end
  else if NewSize > Length(Stages) then
  begin
    OldSize := Length(Stages);
    SetLength(Stages, NewSize);
    for i := OldSize to NewSize - 1 do
      for j := 1 to MAX_AREA_COUNT do
      begin
        //Picture Content
        Stages[i].Areas[j].PictureBitmap := TBitmap.Create;
        Stages[i].Areas[j].PictureBitmap.Width := 0;
        Stages[i].Areas[j].PictureBitmap.Height := 0;
        //SWF Content
        Stages[i].Areas[j].SWFData := TMemoryStream.Create;
        Stages[i].Areas[j].SWFData.Clear;
      end;
  end;
end;

procedure TMainForm.SelectLayoutBtnClick(Sender: TObject);
var
  LayoutFormResult: Integer;
  i: Integer;
begin
  {$ifdef _STAGE_LAYOUT_ACTIVE_}
  LayoutFormResult := mrNone;
  repeat
    if (DisplayStages[ActiveDisplayStage].CustomLayout and (LayoutFormResult <> mrSelectLayout)) or (LayoutFormResult = mrLayoutDesigner) then
    begin
      LayoutDesignerForm.PrepareLayout(MainForm.DisplayStages[ActiveDisplayStage].Areas);
      LayoutFormResult := LayoutDesignerForm.ShowModal;
      if LayoutFormResult = mrOk then
      begin
        DisplayStages[ActiveDisplayStage].CustomLayout := True;
        LayoutDesignerForm.SetLayout(DisplayStages[ActiveDisplayStage].Areas);
        SetupLayout(DisplayStages[ActiveDisplayStage].Areas, LayoutBtn1, LayoutBtn2, LayoutBtn3, LayoutBtn4, LayoutGroup);
        LayoutChanged;
      end;
    end
    else //if not DisplayStages[ActiveDisplayStage].CustomLayout or (LayoutFormResult = mrSelectLayout) then
    begin
      LayoutForm.Prepare;
      LayoutForm.SelectedLayoutIndex := DisplayStages[ActiveDisplayStage].LayoutIndex;
      LayoutForm.SameAsPrviousStageLayoutBtn.Enabled := ActiveDisplayStage > 0;
      if LayoutForm.NumberOfLayouts > 1 then
        LayoutFormResult := LayoutForm.ShowModal
      else
        LayoutFormResult := LayoutForm.CreateCustomLayoutBtn.ModalResult;
      if LayoutFormResult = mrOk then
      begin
        //DisplayStages[ActiveDisplayStage].CustomLayout := False;
        DisplayStages[ActiveDisplayStage].LayoutIndex := LayoutForm.SelectedLayoutIndex;
        SetLayout(DisplayStages[ActiveDisplayStage].Areas, DisplayStages[ActiveDisplayStage].LayoutIndex, GlobalOptions.LEDDisplaySettings.Height, GlobalOptions.LEDDisplaySettings.Width, DisplayStages[ActiveDisplayStage].CustomLayout);
        SetupLayout(DisplayStages[ActiveDisplayStage].Areas, LayoutBtn1, LayoutBtn2, LayoutBtn3, LayoutBtn4, LayoutGroup);
        LayoutChanged;
      end
      else if LayoutFormResult = mrLayoutSameAsPreviousStage then
      begin
        DisplayStages[ActiveDisplayStage].CustomLayout := DisplayStages[ActiveDisplayStage - 1].CustomLayout;
        DisplayStages[ActiveDisplayStage].LayoutIndex := DisplayStages[ActiveDisplayStage - 1].LayoutIndex;
        for i := 1 to MAX_AREA_COUNT do
        begin
          DisplayStages[ActiveDisplayStage].Areas[i].x1 := DisplayStages[ActiveDisplayStage - 1].Areas[i].x1;
          DisplayStages[ActiveDisplayStage].Areas[i].x2 := DisplayStages[ActiveDisplayStage - 1].Areas[i].x2;
          DisplayStages[ActiveDisplayStage].Areas[i].y1 := DisplayStages[ActiveDisplayStage - 1].Areas[i].y1;
          DisplayStages[ActiveDisplayStage].Areas[i].y2 := DisplayStages[ActiveDisplayStage - 1].Areas[i].y2;
          DisplayStages[ActiveDisplayStage].Areas[i].SizeChangingMode := DisplayStages[ActiveDisplayStage - 1].Areas[i].SizeChangingMode;
        end;
        SetupLayout(DisplayStages[ActiveDisplayStage].Areas, LayoutBtn1, LayoutBtn2, LayoutBtn3, LayoutBtn4, LayoutGroup);
        LayoutChanged;
        LayoutFormResult := mrOk;
      end
    end;
  until (LayoutFormResult = mrOk) or (LayoutFormResult = mrCancel);
  {$endif}
end;

procedure TMainForm.SetupApplicationCursors;
var
  Cur: HCURSOR;
  //CursorLoaded: Boolean;
begin
  Cur := LoadCursor(0, IDC_HAND);
  if Cur <> 0 then
    Screen.Cursors[crHandPoint] := Cur;

  {
  CursorLoaded := False;
  try
    Cur := Procs.LoadAnimatedCursorFromResource(HInstance, 'HOURGLASS_CUR', 'ANICURSOR');
    CursorLoaded := True;
  except
  end;
  if CursorLoaded and (Cur <> HCURSOR(nil)) then
    Screen.Cursors[ANI_HOUR_GLASS] := Cur
  else
    Screen.Cursors[ANI_HOUR_GLASS] := Screen.Cursors[crHourGlass];
  }
end;

procedure TMainForm.StagePanelPopupPopup(Sender: TObject);
begin
  StagePanelPopup.Tag := 1;
  try
    if StagePanelPopup.PopupComponent is TsStagePanel then
      StagePanelClick(StagePanelPopup.PopupComponent);
  finally
    StagePanelPopup.Tag := 0;
  end;
  
  //Now the StagePanel that user righ clicked on it is selected
  TemporaryDisableStageMenuItem.Checked := DisplayStages[ActiveDisplayStage].TemporaryDisabled;
end;

procedure TMainForm.SelectLayoutMenuItemClick(Sender: TObject);
begin
  SelectLayoutBtn.Click;
end;

procedure TMainForm.N2Click(Sender: TObject);
begin
  DeleteCurrentStageBtn.Click;
end;

procedure TMainForm.N6Click(Sender: TObject);
begin
  NewStage(True, ActiveDisplayStage, False);
  OnNewStagePanelAdded;
end;

procedure TMainForm.N7Click(Sender: TObject);
begin
  NewStage(True, ActiveDisplayStage - 1, False);
  OnNewStagePanelAdded;
end;

function TMainForm.DisplaySettingsEqual(const DS1, DS2: TLEDDisplaySettings;
  CompareAllSettings: Boolean): Boolean;
begin
  //If CompareAllSettings is False, this function checks only the settings that requires to start a new show.
  //Otherwise, compares all settings.
  Result := (DS1.Width                    = DS2.Width) and
            (DS1.Height                   = DS2.Height) and
            (DS1.ColorCount               = DS2.ColorCount) and
            (DS1.CanShowDateTime          = DS2.CanShowDateTime) and
            (DS1.CanShowTemperature       = DS2.CanShowTemperature) and
            (DS1.CanShowScrollingText     = DS2.CanShowScrollingText) and
            (DS1.CanShowPicture           = DS2.CanShowPicture) and
            (DS1.CanShowAnimation         = DS2.CanShowAnimation) and
            (DS1.CanShowTextEffects       = DS2.CanShowTextEffects) and
            (DS1.CanShowPageEffects       = DS2.CanShowPageEffects) and
            (DS1.CanChangePageLayout      = DS2.CanChangePageLayout) and
            (DS1.CanSetTimeSpan           = DS2.CanSetTimeSpan) and
            (DS1.CanShowSWFFiles          = DS2.CanShowSWFFiles);

  if CompareAllSettings then
    Result := Result and
              (DS1.Memory         = DS2.Memory) and
              (DS1.Color1         = DS2.Color1) and
              (DS1.Color2         = DS2.Color2) and
              (DS1.CanSetAlarms   = DS2.CanSetAlarms) and
              (DS1.AlarmCount     = DS2.AlarmCount) and
              (DS1.AlarmSystem    = DS2.AlarmSystem);
end;

function TMainForm.DisplaySettingsEqual(const DS1: TLEDDisplaySettings;
  const DS2FormFile: TLEDDisplaySettingsForFile;
  CompareAllSettings: Boolean): Boolean;
var
  DS2: TLEDDisplaySettings;
begin
  CopyLEDDisplaySettings(DS2FormFile, DS2);
  Result := DisplaySettingsEqual(DS1, DS2, CompareAllSettings);
end;

procedure TMainForm.ChangeLEDDisplaySettingsBtnClick(Sender: TObject);
var
  DisplaySizeChanged: Boolean;
  WDC: Boolean;
  OldLEDDisplaySettings: TLEDDisplaySettings;
  DisplaySettingsChanged: Boolean;
begin
  //************************************
  if not License.CheckLicenseStatusFull then
    Halt;
  //************************************
  ChangeDisplaySettingsForm.Settings := GlobalOptions.LEDDisplaySettings;

  ChangeDisplaySettingsForm.Prepare;

  if ChangeDisplaySettingsForm.ShowModal = mrOk then
  begin
    DisplaySizeChanged := not DisplaySettingsEqual(GlobalOptions.LEDDisplaySettings, ChangeDisplaySettingsForm.Settings, False);  //Check only the settings that requires to start a new show

    if DisplaySizeChanged then
    begin
      if WideMessageDlgSound(Dyn_Texts[5] {'By changing your LED display ssettings, all stages will be cleared. Area you sure you want to continute?'}, mtWarning, [mbYes, mbNo], 0) = mrNo then
        Exit;
    end;

    OldLEDDisplaySettings := GlobalOptions.LEDDisplaySettings;
    GlobalOptions.LEDDisplaySettings := ChangeDisplaySettingsForm.Settings;

    if DisplaySizeChanged then
    begin
      WDC := WorkingDesignChanged;
      NewShowBtn.Click;
      if WDC and WorkingDesignChanged then
      begin
        GlobalOptions.LEDDisplaySettings := OldLEDDisplaySettings;
      end;
    end;

    DisplaySettingsChanged := not DisplaySettingsEqual(GlobalOptions.LEDDisplaySettings, OldLEDDisplaySettings, True);

    if DisplaySettingsChanged then
      OnLEDDisplaySettingsChanged;

    UpdateLEDDisplayInfo;
  end;

  if (License._LED_DISPLAY_MAX_ROW_COUNT_ > 0) and
    (GlobalOptions.LEDDisplaySettings.Height > _LED_DISPLAY_MAX_ROW_COUNT_) then
    Halt;
end;

procedure TMainForm.ReadProgramSettings;
var
  SomeValuesExist: Boolean;

  function ReadRegistrySettings: Boolean;
    function ReadRegRecord(var FontSettings: TFontSettings; const RegPath: String): Boolean; overload;
    var
      Reg: TRegistry;
    begin
      Result := False;
      Reg := TRegistry.Create(KEY_READ);
      try

      Reg.RootKey := HKEY_CURRENT_USER;
      with FontSettings do
      begin
        if not Reg.OpenKeyReadOnly(REG_USER_SETTINGS_PATH + RegPath) then
          Exit;
        SomeValuesExist := True;
        /////////////////////////////
        if not( Reg.ValueExists('Name') ) then
          Exit;
        Name := Reg.ReadString('Name');
        Size := Reg.ReadInteger('Size');
        Height := Reg.ReadInteger('Height');
        Pitch := TFontPitch(Reg.ReadInteger('Pitch'));
        Color := Reg.ReadInteger('Color');
        Style := [];
        if Reg.ReadBool('Bold') then
          Style := Style + [fsBold];
        if Reg.ReadBool('Italic') then
          Style := Style + [fsItalic];
        if Reg.ReadBool('Underlined') then
          Style := Style + [fsUnderline];
        if Reg.ReadBool('StrikedOut') then
          Style := Style + [fsStrikeOut];
        Charset := Reg.ReadInteger('Charset');
        /////////////////////////////
      end;
      Result := True;

      finally
      Reg.Free;
      end;
    end;
  var
    Reg: TRegistry;
    TntReg: TTntRegistry;
  begin
    Result := False;
    Reg := TRegistry.Create(KEY_READ);
    TntReg := TTntRegistry.Create(KEY_READ);

    Reg.RootKey := HKEY_CURRENT_USER;
    TntReg.RootKey := HKEY_CURRENT_USER;

    SomeValuesExist := False;

    try

      with GlobalOptions do
      begin
        with LEDDisplaySettings do
        begin
          if not TntReg.OpenKeyReadOnly(REG_USER_SETTINGS_PATH + '\LED Display Settings') then
            Exit;
          SomeValuesExist := True;
          /////////////////////////////
          if not TntReg.ValueExists('Width') or not TntReg.ValueExists('Height') or
             not TntReg.ValueExists('Memory') or not TntReg.ValueExists('Color Count') or
             not TntReg.ValueExists('Color 1') or not TntReg.ValueExists('Color 2') or
             not TntReg.ValueExists('Date Time') or not TntReg.ValueExists('Temperature') or
             not TntReg.ValueExists('Scrolling Text') or not TntReg.ValueExists('Picture') or
             not TntReg.ValueExists('SWF') or not TntReg.ValueExists('Animation') or
             not TntReg.ValueExists('Text Effects') or not TntReg.ValueExists('Page Effects') or
             not TntReg.ValueExists('Page Layout') or not TntReg.ValueExists('Alarm') or
             not TntReg.ValueExists('Time Span') or not TntReg.ValueExists('Alarm Count') or
             not TntReg.ValueExists('Alarm System') then
          begin
            TntReg.CloseKey;
            Exit;
          end;
          Width := TntReg.ReadInteger('Width');
          if Width > _LED_DISPLAY_MAX_COL_COUNT_ then
            Width := _LED_DISPLAY_MAX_COL_COUNT_;
          Height := TntReg.ReadInteger('Height');
          if Height > _LED_DISPLAY_MAX_ROW_COUNT_ then
            Height := _LED_DISPLAY_MAX_ROW_COUNT_;
          Memory := TntReg.ReadInteger('Memory');
          ColorCount := TntReg.ReadInteger('Color Count');
          if (ColorCount < 1) or (ColorCount > 2) then
            ColorCount := 1;
          Color1 := TntReg.ReadString('Color 1');
          Color2 := TntReg.ReadString('Color 2');
          CanShowDateTime := TntReg.ReadBool('Date Time');
          CanShowTemperature := TntReg.ReadBool('Temperature');
          CanShowScrollingText := TntReg.ReadBool('Scrolling Text');
          CanShowPicture := TntReg.ReadBool('Picture');
          CanShowAnimation := TntReg.ReadBool('Animation');
          CanShowTextEffects := TntReg.ReadBool('Text Effects');
          CanShowPageEffects := TntReg.ReadBool('Page Effects');
          CanChangePageLayout := TntReg.ReadBool('Page Layout');
          CanSetAlarms := TntReg.ReadBool('Alarm');
          AlarmCount := TntReg.ReadInteger('Alarm Count');
          AlarmSystem := TAlarmSystem(TntReg.ReadInteger('Alarm System'));
          CanSetTimeSpan := TntReg.ReadBool('Time Span');
          CanShowSWFFiles := TntReg.ReadBool('SWF');
          /////////////////////////////
          TntReg.CloseKey;
          if not ValidateLEDDisplaySettings(LEDDisplaySettings) then
            Exit;

          if not Reg.OpenKeyReadOnly(REG_USER_SETTINGS_PATH + '\Main Window') then
            Exit;
          /////////////////////////////
          if not Reg.ValueExists('State') then
          begin
            Reg.CloseKey;
            Exit;
          end;
          MainFormState := TWindowState(Reg.ReadInteger('State'));
          /////////////////////////////
          Reg.CloseKey;

          if not Reg.OpenKeyReadOnly(REG_USER_SETTINGS_PATH + '\Appearance') then
            Exit;
          /////////////////////////////
          HueOffset := Reg.ReadInteger('Color');
          SkinNumber := Reg.ReadInteger('Appearance');
          DontUseHighGUI := Reg.ReadBool('Do Not Use HighGUI');
          /////////////////////////////
          Reg.CloseKey;

          if not Reg.OpenKeyReadOnly(REG_USER_SETTINGS_PATH + '\Connection') then
            Exit;
          /////////////////////////////
          if not Reg.ValueExists('LED Displays') or not Reg.ValueExists('COM Port 1') or
             not Reg.ValueExists('COM Port 2') then
          begin
            Reg.CloseKey;
            Exit;
          end;
          NumOfLEDDisplays := Reg.ReadInteger('LED Displays');
          ComPort1 := TPortNumber(Reg.ReadInteger('COM Port 1'));
          ComPort2 := TPortNumber(Reg.ReadInteger('COM Port 2'));

          //Check connection settings to be valid and correct them to valid values if invalid 
          if (NumOfLEDDisplays <= 0) or
             (NumOfLEDDisplays > MAX_NUM_OF_LED_DISPLAYS) then
            NumOfLEDDisplays := 1;
          if not(ComPort1 in [Low(TPortNumber)..High(TPortNumber)]) then
            ComPort1 := pnCOM1;
          if not(ComPort2 in [Low(TPortNumber)..High(TPortNumber)]) then
            ComPort2 := pnCOM2;
          /////////////////////////////
          Reg.CloseKey;

          if not Reg.OpenKeyReadOnly(REG_USER_SETTINGS_PATH + '\Globals') then
            Exit;
          /////////////////////////////
          if not Reg.ValueExists('Music ON') or not Reg.ValueExists('Music') or
             not Reg.ValueExists('RUFL Count') or not Reg.ValueExists('Select Page Effect On New Stage') or
             not Reg.ValueExists('Select Page Layout On New Stage') or not Reg.ValueExists('Default SWF Sensitivity') then
          begin
            Reg.CloseKey;
            Exit;
          end;
          MusicON := Reg.ReadBool('Music ON');
          SelectedMusicIndex := Reg.ReadInteger('Music');

          RUFLCount := Reg.ReadInteger('RUFL Count');

          SelectPageEffectOnNewStage := Reg.ReadBool('Select Page Effect On New Stage');
          SelectPageLayoutOnNewStage := Reg.ReadBool('Select Page Layout On New Stage');

          DefaultSWFSensitivity := Reg.ReadInteger('Default SWF Sensitivity');
          if (DefaultSWFSensitivity < 0) or (DefaultSWFSensitivity > 255) then
            DefaultSWFSensitivity := DEFAULT_SWF_SENSITIVITY;
          /////////////////////////////
          Reg.CloseKey;

          if not Reg.OpenKeyReadOnly(REG_USER_SETTINGS_PATH + '\Preview') then
            Exit;
          /////////////////////////////
          if not Reg.ValueExists('Refresh Time Preview') or not Reg.ValueExists('Auto Text Preview') then
          begin
            Reg.CloseKey;
            Exit;
          end;
          AutomaticallyRefreshTimePreview := Reg.ReadBool('Refresh Time Preview');

          AutomaticallyRefreshTextPreview := Reg.ReadBool('Auto Text Preview');
          /////////////////////////////
          Reg.CloseKey;

          if not Reg.OpenKeyReadOnly(REG_USER_SETTINGS_PATH + '\Text') then
            Exit;
          /////////////////////////////
          if not Reg.ValueExists('Active Font Section') then
          begin
            Reg.CloseKey;
            Exit;
          end;
          SystemFontsSectionActivePageIndex := Reg.ReadInteger('Active Font Section');
          /////////////////////////////
          Reg.CloseKey;

          if not TntReg.OpenKeyReadOnly(REG_USER_SETTINGS_PATH + '\Text') then
            Exit;
          /////////////////////////////
          if not TntReg.ValueExists('Farsi Font') or not TntReg.ValueExists('English Font') then
          begin
            TntReg.CloseKey;
            Exit;
          end;
          FarsiFontName := TntReg.ReadString('Farsi Font');
          EnglishFontName := TntReg.ReadString('English Font');
          /////////////////////////////
          TntReg.CloseKey;

          if not TntReg.OpenKeyReadOnly(REG_USER_SETTINGS_PATH + '\Sounds') then
            Exit;
          /////////////////////////////
          if not TntReg.ValueExists('Data Transmission Finished Sound') then
          begin
            TntReg.CloseKey;
            Exit;
          end;
          SoundOptions.LEDDisplayDataChangeFinishedSoundFileName := TntReg.ReadString('Data Transmission Finished Sound');
          /////////////////////////////
          TntReg.CloseKey;
        end;

        if not ReadRegRecord(FavFont, '\Text\Font 1') then
          Exit;
        if not ReadRegRecord(AllFont, '\Text\Font 2') then
          Exit;
      end;

      Result := True;
    finally
      Reg.Free;
      TntReg.Free;
    end;
  end;

  procedure ReadFavoriteFontsList(List: TTntStrings);
  var
    Reg: TTntRegistry;
    FList: TTntStringList;
    i: Integer;
    S: WideString;
  begin
    Reg := TTntRegistry.Create(KEY_READ);
    FList := TTntStringList.Create;

    try
      Reg.RootKey := HKEY_CURRENT_USER;
      if Reg.OpenKeyReadOnly(REG_USER_SETTINGS_PATH + '\Text\Favorite Fonts') then
      begin
        Reg.GetValueNames(FList);
        FList.Sort;  //Sort the list so that the list is ordered correctly.
        for i := 0 to FList.Count - 1 do
          if Reg.GetDataType(FList.Strings[i]) = rdString then
          begin
            S := Reg.ReadString(FList.Strings[i]);
            //Blank and duplicated items are not allowed
            if (Length(Trim(S)) > 0) and
               (List.IndexOf(S) < 0) then
              List.Add(S);
          end;
        Reg.CloseKey;
      end;
    finally
      FList.Free;
      Reg.Free;
    end;
    if List.Count = 0 then
      for i := 1 to Length(DEFAULT_FAVORITE_FONTS) do
        List.Add(DEFAULT_FAVORITE_FONTS[i]);
  end;

  function RegAccessError: Boolean;
  var
    Reg: TRegistry;
  begin
    Result := False;  //No registry access error
    Reg := TRegistry.Create;
    try
      if Reg.KeyExists(REG_USER_SETTINGS_PATH) then
        Result := not Reg.OpenKey(REG_USER_SETTINGS_PATH, False);
      Reg.CloseKey;
      Reg.Free;
    except
      Result := True;  //Registry access error
      Reg.Free;
    end;
  end;

var
  RegRead: Boolean;
begin
  //Read Favorite Fonts list
  try
    FavoriteFontsCombo.Clear;
    ReadFavoriteFontsList(FavoriteFontsCombo.Items);
  except
  end;

  try
    RUFLReadEntries;
  except
  end;

  SomeValuesExist := False;
  try
    RegRead := ReadRegistrySettings;
  except
    RegRead := False;
  end;

  if not RegRead then
  begin
    if SomeValuesExist then
      //-- Show always in English --
      //WideMessageDlgSoundTop(Dyn_Texts[6] {'Program registry settings are corrupted. Default settings loaded.'}, mtError, [mbOK], 0)
    else
    begin
      //-- Show always in English --
      if RegAccessError then
        ;//WideMessageDlgSoundTop(Dyn_Texts[7] {'Unable to read the program registry settings. Default settings loaded.'}, mtError, [mbOK], 0);
    end;
    LoadDefaultConfig(GlobalOptions);
    ApplyStartupConfig;
    Exit;
  end;

  ApplyStartupConfig;
end;

procedure TMainForm.WriteProgramSettings;

  function WriteRegistrySettings: Boolean;
    function WriteRegRecord(const FontSettings: TFontSettings; const RegPath: String): Boolean; overload;
    var
      Reg: TRegistry;
    begin
      Result := False;
      Reg := TRegistry.Create;
      try

      Reg.RootKey := HKEY_CURRENT_USER;
      with FontSettings do
      begin
        if not Reg.OpenKey(REG_USER_SETTINGS_PATH + RegPath, True) then
          Exit;
        /////////////////////////////
        Reg.WriteString('Name', Name);
        Reg.WriteInteger('Size', Size);
        Reg.WriteInteger('Height', Height);
        Reg.WriteInteger('Pitch', Integer(Pitch));
        Reg.WriteInteger('Color', Color);

        Reg.WriteBool('Bold', fsBold in Style);
        Reg.WriteBool('Italic', fsItalic in Style);
        Reg.WriteBool('Underlined', fsUnderline in Style);
        Reg.WriteBool('StrikedOut', fsStrikeOut in Style);

        Reg.WriteInteger('Charset', Charset);
        /////////////////////////////
      end;
      Result := True;

      finally
      Reg.Free;
      end;
    end;
  var
    Reg: TRegistry;
    TntReg: TTntRegistry;
  begin
    Result := False;
    Reg := TRegistry.Create(KEY_ALL_ACCESS);
    TntReg := TTntRegistry.Create(KEY_ALL_ACCESS);

    Reg.RootKey := HKEY_CURRENT_USER;
    TntReg.RootKey := HKEY_CURRENT_USER;

    try
      with GlobalOptions do
      begin
        with LEDDisplaySettings do
        begin
          if not TntReg.OpenKey(REG_USER_SETTINGS_PATH + '\LED Display Settings', True) then
            Exit;
          /////////////////////////////
          TntReg.WriteInteger('Width', Width);
          TntReg.WriteInteger('Height', Height);
          TntReg.WriteInteger('Memory', Memory);
          TntReg.WriteInteger('Color Count', ColorCount);
          TntReg.WriteString('Color 1', Color1);
          TntReg.WriteString('Color 2', Color2);
          TntReg.WriteBool('Date Time', CanShowDateTime);
          TntReg.WriteBool('Temperature', CanShowTemperature);
          TntReg.WriteBool('Scrolling Text', CanShowScrollingText);
          TntReg.WriteBool('Picture', CanShowPicture);
          TntReg.WriteBool('Animation', CanShowAnimation);
          TntReg.WriteBool('Text Effects', CanShowTextEffects);
          TntReg.WriteBool('Page Effects', CanShowPageEffects);
          TntReg.WriteBool('Page Layout', CanChangePageLayout);
          TntReg.WriteBool('Alarm', CanSetAlarms);
          TntReg.WriteInteger('Alarm Count', AlarmCount);
          TntReg.WriteInteger('Alarm System', Integer(AlarmSystem));
          TntReg.WriteBool('Time Span', CanSetTimeSpan);
          TntReg.WriteBool('SWF', CanShowSWFFiles);
          /////////////////////////////
          TntReg.CloseKey;

          if not Reg.OpenKey(REG_USER_SETTINGS_PATH + '\Main Window', True) then
            Exit;
          /////////////////////////////
          Reg.WriteInteger('State', Integer(MainFormState));
          /////////////////////////////
          Reg.CloseKey;

          if not Reg.OpenKey(REG_USER_SETTINGS_PATH + '\Appearance', True) then
            Exit;
          /////////////////////////////
          Reg.WriteInteger('Color', HueOffset);
          Reg.WriteInteger('Appearance', SkinNumber);
          Reg.WriteBool('Do Not Use HighGUI', DontUseHighGUI);
          /////////////////////////////
          Reg.CloseKey;

          if not Reg.OpenKey(REG_USER_SETTINGS_PATH + '\Connection', True) then
            Exit;
          /////////////////////////////
          Reg.WriteInteger('LED Displays', NumOfLEDDisplays);
          Reg.WriteInteger('COM Port 1', Integer(ComPort1));
          Reg.WriteInteger('COM Port 2', Integer(ComPort2));
          /////////////////////////////
          Reg.CloseKey;

          if not Reg.OpenKey(REG_USER_SETTINGS_PATH + '\Globals', True) then
            Exit;
          /////////////////////////////
          Reg.WriteBool('Music ON', MusicON);
          Reg.WriteInteger('Music', SelectedMusicIndex);

          Reg.WriteInteger('RUFL Count', RUFLCount);

          Reg.WriteBool('Select Page Effect On New Stage', SelectPageEffectOnNewStage);
          Reg.WriteBool('Select Page Layout On New Stage', SelectPageLayoutOnNewStage);
          Reg.WriteInteger('Default SWF Sensitivity', DefaultSWFSensitivity);
          /////////////////////////////
          Reg.CloseKey;

          if not Reg.OpenKey(REG_USER_SETTINGS_PATH + '\Preview', True) then
            Exit;
          /////////////////////////////
          Reg.WriteBool('Refresh Time Preview', AutomaticallyRefreshTimePreview);

          Reg.WriteBool('Auto Text Preview', AutomaticallyRefreshTextPreview);
          /////////////////////////////
          Reg.CloseKey;

          if not TntReg.OpenKey(REG_USER_SETTINGS_PATH + '\Sounds', True) then
            Exit;
          /////////////////////////////
          TntReg.WriteString('Data Transmission Finished Sound', SoundOptions.LEDDisplayDataChangeFinishedSoundFileName);
          /////////////////////////////
          TntReg.CloseKey;

          if not Reg.OpenKey(REG_USER_SETTINGS_PATH + '\Text', True) then
            Exit;
          /////////////////////////////
          Reg.WriteInteger('Active Font Section', SystemFontsSectionActivePageIndex);
          /////////////////////////////
          Reg.CloseKey;

          if not TntReg.OpenKey(REG_USER_SETTINGS_PATH + '\Text', True) then
            Exit;
          /////////////////////////////
          TntReg.WriteString('Farsi Font', FarsiFontName);
          TntReg.WriteString('English Font', EnglishFontName);
          /////////////////////////////
          TntReg.CloseKey;
        end;

        if not WriteRegRecord(FavFont, '\Text\Font 1') then
          Exit;
        if not WriteRegRecord(AllFont, '\Text\Font 2') then
          Exit;
      end;

      Result := True;
    finally
      Reg.Free;
      TntReg.Free;
    end;
  end;

  procedure WriteFavoriteFontsList(List: TTntStrings);
  var
    Reg: TTntRegistry;
    FList: TTntStringList;
    i: Integer;
  begin
    Reg := TTntRegistry.Create;
    FList := TTntStringList.Create;

    try
      Reg.RootKey := HKEY_CURRENT_USER;
      if Reg.OpenKey(REG_USER_SETTINGS_PATH + '\Text\Favorite Fonts', True) then
      begin
        Reg.GetValueNames(FList);
        for i := 0 to FList.Count - 1 do
          Reg.DeleteValue(FList.Strings[i]);
        for i := 0 to List.Count - 1 do
          Reg.WriteString(IntToStr(i), List.Strings[i]);
        Reg.CloseKey;
      end;
    finally
      FList.Free;
      Reg.Free;
    end;
  end;

var
  RegWritten: Boolean;
  i: Integer;
begin
  //Collect all program settings into GlobalOptions
  with GlobalOptions do
  begin
    if RuntimeGlobalOptions.UsingTemporaryLEDDisplaySettings then
    begin
      GlobalOptions.LEDDisplaySettings := RuntimeGlobalOptions.OriginalLEDDisplaySettings;
      NewShowBtn.Click;
    end;

    //Music settings
    MusicON := MusicBtn.Down;
    for i := 0 to MusicPopup.Items.Count - 1 do
      if MusicPopup.Items[i].Checked then
      begin
        SelectedMusicIndex := MusicPopup.Items[i].Tag;
        Break;
      end;

    GetFontSettings(FavoriteFontSamplePanel.Font, FavFont);
    GetFontSettings(FontSamplePanel.Font, AllFont);

    SystemFontsSectionActivePageIndex := SystemFontsSection.ActivePageIndex;
    if (SystemFontsSectionActivePageIndex < 0) or
       (SystemFontsSectionActivePageIndex > (SystemFontsSection.PageCount - 1)) then
      SystemFontsSectionActivePageIndex := 0;

    if FarsiLCDFontsCombo.ItemIndex >= 0 then
      FarsiFontName := FarsiLCDFontsCombo.Items[FarsiLCDFontsCombo.ItemIndex]
    else
      FarsiFontName := '';

    if EnglishLCDFontsCombo.ItemIndex >= 0 then
      EnglishFontName := EnglishLCDFontsCombo.Items[EnglishLCDFontsCombo.ItemIndex]
    else
      EnglishFontName := '';

    AutomaticallyRefreshTextPreview := AutoPreviewCheck.Checked;

    //Favorite Fonts list
    try
      WriteFavoriteFontsList(FavoriteFontsCombo.Items);
    except
    end;
  end;

  try
    RUFLAdd(RUFLLastOpenedFile);
    RUFLWriteEntries;
  except
  end;

  RegWritten := False;
  repeat
    try
      WriteRegistrySettings;
      RegWritten := True;
    except
    end;
    if not RegWritten then
      RegWritten := WideMessageDlgSoundTop(Dyn_Texts[8] {'Unable to save the program settings to the registry.'}, mtError, [mbRetry, mbCancel], 0) = mrCancel;
  until RegWritten;
end;

procedure TMainForm.LoadDefaultConfig(var AGlobalOptions: TGlobalOptions);

  procedure LoadDefaultUserMappedChars;
    procedure AppendCharToList(MapGrid: TAdvStringGrid;
      const UserMappedChar: TUserMappedChar);
    var
      Row: Integer;
    begin
      for Row := 1 to MapGrid.RowCount - 2 do
        if MapGrid.Cells[0, Row] = UserMappedChar.Character then
          Exit;
      MapGrid.RowCount := MapGrid.RowCount + 1;
      MapGrid.Cells[0, MapGrid.RowCount - 2] := UserMappedChar.Character;
      MapGrid.Cells[1, MapGrid.RowCount - 2] := UserMappedChar.MappedFName;
    end;

  var
    MapGrid: TAdvStringGrid;
    TempParent: TForm;
    i: Integer;
  begin
    //****************************
    //Don't write anything if license information is not valid
    if not License5.CheckLicenseStatusFull then
      Exit;
    //****************************

    //This procedure appends the predefined characters to the list, not
    // replacing the old list (if any).
    TempParent := TForm.Create(nil);
    TempParent.Visible := False;
    MapGrid := TAdvStringGrid.Create(TempParent);
    MapGrid.Parent := TempParent;
    MapGrid.Visible := False;  //--> Prevent potential software bugs

    try
      LCDProcs.ReadUserMappedChars(MapGrid);

      for i := 1 to Length(DEFAULT_USER_MAPPED_CHARS) do
        AppendCharToList(MapGrid, DEFAULT_USER_MAPPED_CHARS[i]);

      LCDProcs.WriteUserMappedChars(MapGrid);
    finally
      MapGrid.Free;
      TempParent.Free;
    end;
  end;

begin
  try
    //User-Mapped Characters
    LoadDefaultUserMappedChars;
  except
  end;

  with AGlobalOptions do
  begin
    with LEDDisplaySettings do
    begin
      Width := 64;
      Height := 16;
      Memory := 8;  //8KB is minimum - 4KB cannot be used because it is equal to LED_DISPLAY_MEM_START_OFFSET
      ColorCount := 1;
      Color1 := '';//ChangeDisplaySettingsForm.ColorCombo1.Items.Strings[0];  //Red  --> Empty string will force to update it from the combos in the ChangeDisplaySettingsForm in the ApplyStartupOnShowConfig procedure
      Color2 := '';//ChangeDisplaySettingsForm.ColorCombo2.Items.Strings[1];  //Green
      CanShowDateTime := True;
      CanShowTemperature := True;
      CanShowScrollingText := True;
      CanShowPicture := True;
      CanShowAnimation := True;
      CanShowTextEffects := True;
      CanShowPageEffects := True;
      CanChangePageLayout := True;
      CanSetAlarms := True;
      CanSetTimeSpan := True;
      CanShowSWFFiles := True;
      AlarmCount := DEFAULT_LED_DISPLAY_ALARM_COUNT;
      AlarmSystem := DEFAULT_LED_DISPLAY_ALARM_SYSTEM;

      NumOfLEDDisplays := 1;  //If changed, also change the default settings in the ProgramOptionsForm.
      ComPort1 := pnCOM1;  //If changed, also change the default settings in the ProgramOptionsForm.
      ComPort2 := pnCOM2;  //If changed, also change the default settings in the ProgramOptionsForm.

      MainFormState := wsNormal;

      HueOffset := sSkinManager1.HueOffset;  //If changed to a specific value, also change the default settings in the ProgramOptionsForm.
      SkinNumber := 1;  //If changed, also change the default settings in the ProgramOptionsForm.
      DontUseHighGUI := False;  //If changed, also change the default settings in the ProgramOptionsForm.

      MusicON := True;
      SelectedMusicIndex := 0;

      GetFontSettings(FavoriteFontSamplePanel.Font, FavFont);
      GetFontSettings(FontSamplePanel.Font, AllFont);

      SystemFontsSectionActivePageIndex := 0;  //Favorite Fonts

      //For Farsi font, don't select the thick font by default
      if FarsiLCDFontsCombo.Items.Count >= 1 then
        FarsiFontName := FarsiLCDFontsCombo.Items.Strings[1]
      else
        FarsiFontName := ''; 
      EnglishFontName := '';

      RUFLCount := 10;  //Keep ten files in the history

      SelectPageEffectOnNewStage := True;  //If changed, also change the default settings in the ProgramOptionsForm (Default button click).
      SelectPageLayoutOnNewStage := False;  //If changed, also change the default settings in the ProgramOptionsForm (Default button click).

      DefaultSWFSensitivity := DEFAULT_SWF_SENSITIVITY;

      AutomaticallyRefreshTimePreview := True;  //If changed, also change the default settings in the ProgramOptionsForm (Default button click).

      AutomaticallyRefreshTextPreview := True;
    end;
  end;
end;

procedure TMainForm.ApplyStartupConfig;
var
  i: Integer;
begin
  //////////////////////
  LoadingConfig := True;
  //////////////////////

  UpdateLEDDisplayInfo;
  OnLEDDisplaySettingsChanged;

  with GlobalOptions do
  begin
    sSkinManager1.HueOffset := HueOffset;
    SetSkin(SkinNumber);
    if DontUseHighGUI then
      HighGUITimer.Tag := 0  //Means Disabled
    else
      HighGUITimer.Tag := 1;  //Means Enabled

    if MusicFilesList.Count > 0 then
    begin
      if (SelectedMusicIndex < MusicFilesList.Count) and
         (SelectedMusicIndex >= 0) then
        MediaPlayer1.FileName := MusicFilesList.Strings[SelectedMusicIndex]
      else
      begin
        GlobalOptions.SelectedMusicIndex := 0;
        MediaPlayer1.FileName := MusicFilesList.Strings[0];
      end;

      for i := 0 to MusicPopup.Items.Count - 1 do
        if MusicPopup.Items[i].Tag = SelectedMusicIndex then
        begin
          MusicPopup.Items[i].Checked := True;
          Break;
        end;

      try
        MediaPlayer1.Wait := False;
        MediaPlayer1.Notify := False;
        MediaPlayer1.Open;
      except
      end;
    end;

    MusicBtn.Down := MusicON and MusicBtn.Enabled;
    SelectMusicBtn.Down := MusicBtn.Down;
    if MusicON and MusicBtn.Enabled then
    begin
      try
        MediaPlayer1.Play;
        MusicPopup.Items[SelectedMusicIndex].Checked := True;
      except
      end;
    end;

    SetFontSettings(FavoriteFontSamplePanel.Font, FavFont);
    SetFontSettings(FontSamplePanel.Font, AllFont);
    PrepareFontSectionControls;

    SystemFontsSection.ActivePageIndex := SystemFontsSectionActivePageIndex;

    if FarsiLCDFontsCombo.Items.IndexOf(FarsiFontName) >= 0 then
      FarsiLCDFontsCombo.ItemIndex := FarsiLCDFontsCombo.Items.IndexOf(FarsiFontName)
    else
      FarsiLCDFontsCombo.ItemIndex := 0;

    if EnglishLCDFontsCombo.Items.IndexOf(EnglishFontName) >= 0 then
      EnglishLCDFontsCombo.ItemIndex := EnglishLCDFontsCombo.Items.IndexOf(EnglishFontName)
    else
      EnglishLCDFontsCombo.ItemIndex := 0;

    TimePreviewTimer.Enabled := AutomaticallyRefreshTimePreview;

    WindowState := MainFormState;

    AutoPreviewCheck.Checked := AutomaticallyRefreshTextPreview;
    if Assigned(AutoPreviewCheck.OnClick) then
      AutoPreviewCheck.OnClick(AutoPreviewCheck);
  end;

  ///////////////////////
  LoadingConfig := False;
  ///////////////////////

  //Recently used file list
  RUFLBuildMenuItems;
end;

procedure TMainForm.MenuPanelResize(Sender: TObject);
var
  MenuBarLeft: Integer;
begin
  LEDDisplayInfoGroup.Left := MenuPanel.Width - LEDDisplayInfoGroup.Width - 10;
  MenuBarLeft := Trunc(MenuPanel.Width / 2 - MenuBarPanel.Width / 2);
  if (MenuBarLeft + MenuBarPanel.Width) >= LEDDisplayInfoGroup.Left then
    MenuBarLeft := MenuBarLeft - (MenuBarLeft + MenuBarPanel.Width - LEDDisplayInfoGroup.Left) - 10;
  MenuBarPanel.Left := MenuBarLeft;
end;

procedure TMainForm.UpdateLEDDisplayInfo;
begin
  with GlobalOptions.LEDDisplaySettings do
  begin
    DisplaySizeLabel.Caption := IntToStr(Height) + 'x' + IntToStr(Width);
    MemorySizeLabel.Caption := IntToStr(Memory) + ' KB';
  end;
end;

procedure TMainForm.TntFormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  WriteProgramSettings;

  try
    WriteInstallDirRegistryEntry(True);
  except
  end;
end;

procedure TMainForm.SelectTextEntranceEffectBtnClick(Sender: TObject);
begin
  if not Assigned(SelectNormalEffectForm) then
    Exit;
  SelectNormalEffectForm.SelectedEffect := TextEntranceEffectImage.Tag;
  SelectNormalEffectForm.AnimSpeed := DisplayStages[ActiveDisplayStage].Areas[ActiveAreaIndex].AnimSpeed;
  if SelectNormalEffectForm.ShowModal = mrOk then
  begin
    TextEntranceEffectImage.Tag := SelectNormalEffectForm.SelectedEffect;
    DisplayStages[ActiveDisplayStage].Areas[ActiveAreaIndex].AnimSpeed := SelectNormalEffectForm.AnimSpeed;
    DisplayNormalEffect(TextEntranceEffectImage, TextEntranceEffectImage.Tag, SelectNormalEffectForm.AnimSpeed);
  end;
  if TextEntranceEffectImage.Tag <= 0 then
    TextEntranceEffectCheck.Checked := False;
end;

procedure TMainForm.DisplayNormalEffect(Image: TImage; EffectID: Integer;
  AnimSpeed: Integer);
var
  rs: TResourceStream;
  GIFImage: TGIFImage;
begin
  if (EffectID <= 0) or (EffectID > MAX_NORMAL_EFFECT_ID) then
  begin
    ClearImage(Image);
    Exit;
  end;
  Image.Show;

  GIFImage := TGIFImage.Create;
  rs := TResourceStream.Create(HInstance, 'EFFECT_' + IntToStr(EffectID) + '_GIF', 'GIF');
  GIFImage.LoadFromStream(rs);
  Image.Picture.Graphic := GIFImage;
  (Image.Picture.Graphic as TGIFImage).AnimationSpeed := AnimSpeedToGIFAnimationSpeed(AnimSpeed);
  rs.Free;
  GIFImage.Free;
end;

procedure TMainForm.ClearImage(Image: TImage);
begin
  Image.Stretch := False;
  Image.Picture.Bitmap.Width := 0;
  Image.Picture.Bitmap.Height := 0;

  Image.Hide;
end;

procedure TMainForm.TextEntranceEffectCheckClick(Sender: TObject);
begin
  SelectTextEntranceEffectBtn.Enabled := TextEntranceEffectCheck.Checked;
  TextEntranceEffectImage.Show;
  if TextEntranceEffectCheck.Checked then
  begin
    if (TextEntranceEffectImage.Tag <= 0) and not LoadingContent then
      SelectTextEntranceEffectBtn.Click
    else
      DisplayNormalEffect(TextEntranceEffectImage, TextEntranceEffectImage.Tag, DisplayStages[ActiveDisplayStage].Areas[ActiveAreaIndex].AnimSpeed);
  end
  else
    ClearImage(TextEntranceEffectImage);
end;

procedure TMainForm.PictureEntranceEffectCheckClick(Sender: TObject);
begin
  SelectPictureEntranceEffectBtn.Enabled := PictureEntranceEffectCheck.Checked;
  PictureEntranceEffectImage.Show;
  if PictureEntranceEffectCheck.Checked then
  begin
    if (PictureEntranceEffectImage.Tag <= 0) and not LoadingContent then
      SelectPictureEntranceEffectBtn.Click
    else
      DisplayNormalEffect(PictureEntranceEffectImage, PictureEntranceEffectImage.Tag, DisplayStages[ActiveDisplayStage].Areas[ActiveAreaIndex].AnimSpeed);
  end
  else
    ClearImage(PictureEntranceEffectImage);
end;

procedure TMainForm.SelectPictureEntranceEffectBtnClick(Sender: TObject);
begin
  if not Assigned(SelectNormalEffectForm) then
    Exit;
  SelectNormalEffectForm.SelectedEffect := PictureEntranceEffectImage.Tag;
  SelectNormalEffectForm.AnimSpeed := DisplayStages[ActiveDisplayStage].Areas[ActiveAreaIndex].AnimSpeed;
  if SelectNormalEffectForm.ShowModal = mrOk then
  begin
    PictureEntranceEffectImage.Tag := SelectNormalEffectForm.SelectedEffect;
    DisplayStages[ActiveDisplayStage].Areas[ActiveAreaIndex].AnimSpeed := SelectNormalEffectForm.AnimSpeed;
    DisplayNormalEffect(PictureEntranceEffectImage, PictureEntranceEffectImage.Tag, SelectNormalEffectForm.AnimSpeed);
  end;
  if PictureEntranceEffectImage.Tag <= 0 then
    PictureEntranceEffectCheck.Checked := False;
end;

procedure TMainForm.SelectPageEffectBtnClick(Sender: TObject);
begin
  SelectPageEffectForm.SelectedEffect := DisplayStages[ActiveDisplayStage].EntranceEffectID;
  SelectPageEffectForm.Prepare;
  if SelectPageEffectForm.ShowModal = mrOk then
  begin
    PageEffectImage.Tag := SelectPageEffectForm.SelectedEffect;
    DisplayStages[ActiveDisplayStage].EntranceEffectID := SelectPageEffectForm.SelectedEffect;
    DisplayPageEffect(PageEffectImage, PageEffectImage.Tag);
  end;
end;

procedure TMainForm.DisplayPageEffect(Image: TImage; EffectID: Integer);
var
  rs: TResourceStream;
  GIFImage: TGIFImage;
begin

  NoPageEffectLabel.Visible := EffectID <= 0;
  if (EffectID <= 0) or (EffectID > MAX_PAGE_EFFECT_ID) then
  begin
    ClearImage(Image);
    Exit;
  end;

  Image.Show;

  GIFImage := TGIFImage.Create;
  rs := TResourceStream.Create(HInstance, 'PAGE_EFFECT_' + IntToStr(EffectID) + '_GIF', 'GIF');
  GIFImage.LoadFromStream(rs);
  Image.Picture.Graphic := GIFImage;
  rs.Free;
  GIFImage.Free;
  Image.Stretch := True;
end;

procedure TMainForm.SelectPageEffectMenuItemClick(Sender: TObject);
begin
  SelectPageEffectBtn.Click;
end;

procedure TMainForm.GenerateLCDFontPreviewImage(PreviewImage: TImage;
  Language: TLanguage);
begin

end;

procedure TMainForm.MenuCorrectTimerTimer(Sender: TObject);
var
  i: Integer;
begin
  MenuCorrectTimer.Enabled := False;
  for i := Low(ContentControls) to High(ContentControls) do
    (ContentControls[i].Button as TsSpeedButton).Down := i = Ord(DisplayStages[ActiveDisplayStage].Areas[ActiveAreaIndex].ContentType);
end;

function TMainForm.IsUnusedArea(const Area: TArea): Boolean;
begin
  Result := (Area.x1 = Area.x2) or (Area.y1 = Area.y2);
end;

function TMainForm.IsUnusedArea(const Area: TAreaForFile): Boolean;
begin
  Result := (Area.x1 = Area.x2) or (Area.y1 = Area.y2);
end;

procedure TMainForm.RefreshStagePanels;

  function GetContentDescription(Content: TContentType): WideString;
  begin
    Result := '';
    case Content of
      ctTime:
        Result := Dyn_Texts[44];  //'Time';
      ctDate:
        Result := Dyn_Texts[45];  //'Date;
      ctScrollingText:
        Result := Dyn_Texts[46];  //'Text';
      ctSWF:
        Result := Dyn_Texts[134];  //'SWF Animation'
      ctAnimation:
        Result := Dyn_Texts[47];  //'Animation';
      ctPicture:
        Result := Dyn_Texts[48];  //'Picture';
      ctTemperature:
        Result := Dyn_Texts[49];  //'Temperature';
      ctEmpty:
        Result := Dyn_Texts[50];  //'Empty';
    end;
  end;

var
  i, j: Integer;
  S: WideString;
  ToStr: WideString;
  TimeSpanCharL, TimeSpanCharR: Char;
begin
  ToStr := '-';//Dyn_Texts[86];  //{to}
  for i := 0 to High(DisplayStages) do
  begin
    S := '';
    for j := 1 to 4 do
      if not IsUnusedArea(DisplayStages[i].Areas[j]) then
      begin
        if S = '' then
          S := S + GetContentDescription(DisplayStages[i].Areas[j].ContentType)
        else
          S := S + #13 + GetContentDescription(DisplayStages[i].Areas[j].ContentType);
      end;
    with DisplayStages[i] do
      if TimeSpanDefined(HourFrom, MinuteFrom, HourTo, MinuteTo) then
      begin
        if DisplayInSpecificDate then
        begin
          //When date is specified, only show display date
          S := S + #13 + WideFormat('%s/%s/%s', [Procs.IntToStrMinLen(Year, 4),
                                                 Procs.IntToStrMinLen(Month, 2),
                                                 Procs.IntToStrMinLen(Day, 2)]);
        end
        else
        begin
          if OnlyDoNotShowDuringTimeSpan then
          begin
            TimeSpanCharL := ']';
            TimeSpanCharR  := '[';
          end
          else
          begin
            TimeSpanCharL := '[';
            TimeSpanCharR  := ']';
          end;
          S := S + #13 + WideFormat('%s%s:%s %s %s:%s%s', [TimeSpanCharL,
                                                         Procs.IntToStrMinLen(HourTo, 2), Procs.IntToStrMinLen(MinuteTo, 2),
                                                         ToStr,
                                                         Procs.IntToStrMinLen(HourFrom, 2), Procs.IntToStrMinLen(MinuteFrom, 2),
                                                         TimeSpanCharR]);
        end;
      end;
    DisplayStages[i].StagePanel.StageImage.Caption := S;
  end;
end;

procedure TMainForm.RefreshStagePanelsAppearance;
var
  i: Integer;
begin
  for i := 0 to High(DisplayStages) do
    with DisplayStages[i] do
    begin
      if StagePanel.Selected then
      begin
        if TemporaryDisabled then
          StagePanel.SkinData.SkinSection := RuntimeGlobalOptions.SelectedStagePanelDisabledSkin
        else
          StagePanel.SkinData.SkinSection := RuntimeGlobalOptions.SelectedStagePanelNormalSkin;
      end
      else
      begin
        if TemporaryDisabled then
          StagePanel.SkinData.SkinSection := RuntimeGlobalOptions.UnselectedStagePanelDisabledSkin
        else
          StagePanel.SkinData.SkinSection := RuntimeGlobalOptions.UnselectedStagePanelNormalSkin;
      end;
    end;
end;

procedure TMainForm.DateContentPanelResize(Sender: TObject);
begin
  DateFormat0Radio.Left := Trunc((DateTypeGroup.Width - DateFormat0Radio.Width - DateFormat1Radio.Width) / 2);
  DateFormat2Radio.Left := DateFormat0Radio.Left - (DateFormat2Radio.Width - DateFormat0Radio.Width);
  DateFormat5Radio.Left := DateFormat0Radio.Left - (DateFormat5Radio.Width - DateFormat0Radio.Width);

  DateLanguageGroup.Width := Trunc(DateContentPanel.Width / 2 - 13);
  DateFormatGroup.Width := DateLanguageGroup.Width;

  DateLanguageGroup.Left := Trunc(DateContentPanel.Width / 2 + 5);
end;

procedure TMainForm.TimeContentPanelResize(Sender: TObject);
begin
  TimeLanguageGroup.Width := Trunc(TimeContentPanel.Width / 2 - 13);
  TimeFormatGroup.Width := TimeLanguageGroup.Width;

  TimeLanguageGroup.Left := Trunc(TimeContentPanel.Width / 2 + 5);
end;

procedure TMainForm.TemperatureContentPanelResize(Sender: TObject);
begin
  TemperatureLanguageGroup.Width := Trunc(TemperatureContentPanel.Width / 2 - 13);
  TemperatureUnitGroup.Width := TemperatureLanguageGroup.Width;

  TemperatureLanguageGroup.Left := Trunc(TemperatureContentPanel.Width / 2 + 5);
end;

procedure TMainForm.AnimationContentPanelResize(Sender: TObject);
begin
  AnimationDisplaySettingsGroup.Width := Trunc(AnimationContentPanel.Width / 2 - 13);
  AnimationTimeGroup.Width := AnimationDisplaySettingsGroup.Width;

  AnimationDisplaySettingsGroup.Left := Trunc(AnimationContentPanel.Width / 2 + 5);
end;

procedure TMainForm.DisplayStageMenuBtnClick(Sender: TObject);
begin
  StagePanelPopup.PopupComponent := DisplayStages[ActiveDisplayStage].StagePanel;
  with DisplayStageMenuBtn.Parent.ClientToScreen(Point(DisplayStageMenuBtn.Left + DisplayStageMenuBtn.Width, DisplayStageMenuBtn.Top + DisplayStageMenuBtn.Height)) do
    StagePanelPopup.Popup(x, y);
end;

procedure TMainForm.UpdateEnvironmentForAreaSelection(AreaIndex: Integer);
begin
  case AreaIndex of
    1:  LayoutBtn1.Down := True;
    2:  LayoutBtn2.Down := True;
    3:  LayoutBtn3.Down := True;
    4:  LayoutBtn4.Down := True;
  end;
end;

procedure TMainForm.sSpeedButton1Click(Sender: TObject);
begin
  SelectPageEffectBtn.Click;
end;

procedure TMainForm.AnimationTimingStyle1RadioClick(Sender: TObject);
begin
  PrepareContentControls(ctAnimation);
end;

procedure TMainForm.FixedPictureRadioClick(Sender: TObject);
begin
  PrepareContentControls(ctPicture);
end;

procedure TMainForm.PrepareContentControls(ContentType: TContentType);
begin
  case ContentType of
    ctTime:
      begin
        //Nothing to do
      end;
    ctDate:
      begin
        //Nothing to do
      end;
    ctScrollingText:
      begin
        //InputTextFarsiRadio.Enabled := LCDFontsSourceRadio.Checked;
        //InputTextEnglishRadio.Enabled := LCDFontsSourceRadio.Checked;
        //InputTextMixedRadio.Enabled := LCDFontsSourceRadio.Checked;

        if FixedTextRadio.Checked and not LoadingContent then
        begin
          TextTimingStyle2Radio.Checked := True;
          RepeatTextAfterDoneCheck.Checked := True;
        end;

        TextTimingStyle1Radio.Enabled := ScrollingTextRadio.Checked;
        TextRepetitionTimesSpin.Enabled := ScrollingTextRadio.Checked;
        TextLabel1.Enabled := ScrollingTextRadio.Enabled;

        if ScrollingTextRadio.Checked and not LoadingContent then
        begin
          TextTimingStyle1Radio.Checked := True;
          RepeatTextAfterDoneCheck.Checked := False;
        end;
      end;
    ctSWF:
      begin
        //SWFRepetitionTimesSpin.Enabled := SWFTimingStyle1Radio.Checked;
        //SWFLabel1.Enabled := SWFTimingStyle1Radio.Checked;
        //SWFTotalDisplayTimeSpin.Enabled := SWFTimingStyle2Radio.Checked;
        //SWFLabel2.Enabled := SWFTimingStyle2Radio.Checked;
        //SWFLabel3.Enabled := SWFTimingStyle2Radio.Checked;
      end;
    ctAnimation:
      begin
        //AnimationRepetitionTimesSpin.Enabled := AnimationTimingStyle1Radio.Checked;
        //AnimLabel1.Enabled := AnimationTimingStyle1Radio.Checked;
        //AnimationTotalDisplayTimeSpin.Enabled := AnimationTimingStyle2Radio.Checked;
        //AnimLabel2.Enabled := AnimationTimingStyle2Radio.Checked;
        //AnimLabel3.Enabled := AnimationTimingStyle2Radio.Checked;
      end;
    ctPicture:
      begin
        //PictureLabel1.Enabled := ScrollingPictureRadio.Checked;
        //PictureDirectionRightRadio.Enabled := ScrollingPictureRadio.Checked;
        //PictureDirectionLeftRadio.Enabled := ScrollingPictureRadio.Checked;
        //PictureLabel2.Enabled := ScrollingPictureRadio.Checked;
        //PictureSpeedCombo.Enabled := ScrollingPictureRadio.Checked;
        if FixedPictureRadio.Checked and not LoadingContent then
        begin
          PictureTimingStyle2Radio.Checked := True;
          RepeatPictureAfterDoneCheck.Checked := True;
        end;
        PictureTimingStyle1Radio.Enabled := ScrollingPictureRadio.Checked;
        PictureRepetitionTimesSpin.Enabled := ScrollingPictureRadio.Checked;
        PictureLabel3.Enabled := ScrollingPictureRadio.Checked;

        if ScrollingPictureRadio.Checked and not LoadingContent then
        begin
          PictureTimingStyle1Radio.Checked := True;
          RepeatPictureAfterDoneCheck.Checked := True;
        end;
      end;
    ctTemperature:
      begin
        //Nothing to do
      end;
    ctEmpty:
      begin
        //Nothing to do
      end;
  end;
end;

procedure TMainForm.SetStageDefaults(var Stage: TStage);
begin
  with Stage do
  begin
    LayoutIndex := 1;
    CustomLayout := False;
    EntranceEffectID := 0;  //No effect
    ExitEffectID := 0;  //No effect
    EffectSpeed := 128;  //Middle speed
    //Time Span
    HourFrom := 0;
    MinuteFrom := 0;
    HourTo := 0;
    MinuteTo := 0;
    OnlyDoNotShowDuringTimeSpan := False;
    DisplayInSpecificDate := False;
    Year := Procs.TodaySolarDateTime.Year;
    Month := Procs.TodaySolarDateTime.Month;
    Day := Procs.TodaySolarDateTime.Day;

    LastSelectedAreaIndex := 1;  //First area of any stage is the default area to see at the first time the stage is selected
  end;
end;

procedure TMainForm.EffectsSpeedTrackbarChange(Sender: TObject);
//var
//  i: Integer;
begin
  with DisplayStages[ActiveDisplayStage] do
  begin
    EffectSpeed := 255 - EffectsSpeedTrackbar.Position;
    //for i := 1 to MAX_AREA_COUNT do
    //  Areas[i].AnimSpeed := EffectSpeed;
  end;
end;

procedure TMainForm.ScrollingTextRadioClick(Sender: TObject);
begin
  PrepareContentControls(ctScrollingText);
end;

procedure TMainForm.PrepareAreaSizeSection(AreaIndex: Integer);

const
  AREA_MIN_WIDTH = 4;
  AREA_MIN_HEIGHT = 2;

  function CalcMinOccupiedSpace(Index: Integer): Integer;
  var
    i: Integer;
  begin
    Result := 0;
    with DisplayStages[ActiveDisplayStage] do
    begin
      if Areas[Index].SizeChangingMode = scHorizontal then
      begin

        if Areas[Index].x2 = (GlobalOptions.LEDDisplaySettings.Width - 1) then
        begin
          for i := 1 to Index - 2 do
            if not IsUnusedArea(Areas[i]) and (Areas[i].SizeChangingMode = scHorizontal) then
              Result := Result + (Areas[i].x2 - Areas[i].x1 + 1);
          if Index > 1 then
            Result := Result + AREA_MIN_WIDTH;
        end
        else
        begin
          for i := 1 to Index - 1 do
            if not IsUnusedArea(Areas[i]) and (Areas[i].SizeChangingMode = scHorizontal) then
              Result := Result + (Areas[i].x2 - Areas[i].x1 + 1);
          for i := Index + 2 to MAX_AREA_COUNT do
            if not IsUnusedArea(Areas[i]) and (Areas[i].SizeChangingMode = scHorizontal) then
              Result := Result + (Areas[i].x2 - Areas[i].x1 + 1);
          if Index < MAX_AREA_COUNT then
            Result := Result + AREA_MIN_WIDTH;
        end;

      end
      else
      begin

        if Areas[Index].y2 = (GlobalOptions.LEDDisplaySettings.Height - 1) then
        begin
          for i := 1 to Index - 2 do
            if not IsUnusedArea(Areas[i]) and (Areas[i].SizeChangingMode = scVertical) then
              Result := Result + (Areas[i].y2 - Areas[i].y1 + 1);
          if Index > 1 then
            Result := Result + AREA_MIN_HEIGHT;
        end
        else
        begin
          for i := 1 to Index - 1 do
            if not IsUnusedArea(Areas[i]) and (Areas[i].SizeChangingMode = scVertical) then
              Result := Result + (Areas[i].y2 - Areas[i].y1 + 1);
          if Index < MAX_AREA_COUNT then
            Result := Result + AREA_MIN_HEIGHT;
        end;

      end;
    end;
  end;

var
  MinOccupiedSpace: Integer;
  i: Integer;
  AreaCount: Integer;
begin
  with DisplayStages[ActiveDisplayStage] do
  begin
    AreaWidthLabel.Visible := Areas[AreaIndex].SizeChangingMode = scHorizontal;
    AreaHeightLabel.Visible := Areas[AreaIndex].SizeChangingMode = scVertical;

    AreaCount := 0;
    for i := 1 to MAX_AREA_COUNT do
      if not IsUnusedArea(Areas[i]) then
        Inc(AreaCount);
    AreaWidthLabel.Enabled := (AreaCount > 1) and not CustomLayout;
    AreaHeightLabel.Enabled := (AreaCount > 1) and not CustomLayout;
    AreaSizeSpin.Enabled := (AreaCount > 1) and not CustomLayout;;
    if not AreaSizeSpin.Enabled then
    begin
      AreaSizeSpin.OnChange := nil;
      if Areas[AreaIndex].SizeChangingMode = scHorizontal then
        AreaSizeSpin.Value := Areas[AreaIndex].x2 - Areas[AreaIndex].x1 + 1
      else
        AreaSizeSpin.Value := Areas[AreaIndex].y2 - Areas[AreaIndex].y1 + 1;
      AreaSizeSpin.OnChange := AreaSizeSpinChange;
      Exit;
    end;

    MinOccupiedSpace := CalcMinOccupiedSpace(AreaIndex);
    if Areas[AreaIndex].SizeChangingMode = scHorizontal then
    begin
      AreaSizeSpin.MaxValue := GlobalOptions.LEDDisplaySettings.Width - MinOccupiedSpace;
      AreaSizeSpin.MinValue := AREA_MIN_WIDTH;
    end
    else
    begin
      AreaSizeSpin.MaxValue := GlobalOptions.LEDDisplaySettings.Height - MinOccupiedSpace;
      AreaSizeSpin.MinValue := AREA_MIN_HEIGHT;
    end;
    AreaSizeSpin.Value := GetAreaSizeToChange(DisplayStages[ActiveDisplayStage].Areas[AreaIndex]);
  end;
end;

function TMainForm.GetAreaSizeToChange(const Area: TArea): Integer;
begin
  with Area do
  begin
    if SizeChangingMode = scHorizontal then
      Result := x2 - x1 + 1
    else
      Result := y2 - y1 + 1;
  end;
end;

procedure TMainForm.SetAreaSizeToChange(AreaIndex: Integer;
  NewSize: Integer);
var
  SizeDiff: Integer;
  i: Integer;
begin
  with DisplayStages[ActiveDisplayStage] do
  begin
    if Areas[AreaIndex].SizeChangingMode = scHorizontal then  //scHorizontal
    begin

      SizeDiff := NewSize - (Areas[AreaIndex].x2 - Areas[AreaIndex].x1 + 1);
      if Areas[AreaIndex].x2 = (GlobalOptions.LEDDisplaySettings.Width - 1) then
      begin
        Areas[AreaIndex].x1 := Areas[AreaIndex].x1 - SizeDiff;
        if (AreaIndex > 1) and not IsUnusedArea(Areas[AreaIndex - 1]) then
        begin
          if Areas[AreaIndex - 1].SizeChangingMode = scVertical then
          begin
            for i := 1 to AreaIndex - 1 do
              Areas[i].x2 := Areas[i].x2 - SizeDiff;
          end
          else
            Areas[AreaIndex - 1].x2 := Areas[AreaIndex - 1].x2 - SizeDiff;
        end;
      end
      else
      begin
        Areas[AreaIndex].x2 := Areas[AreaIndex].x2 + SizeDiff;
        if (AreaIndex < MAX_AREA_COUNT) and not IsUnusedArea(Areas[AreaIndex + 1]) then
        begin
          if Areas[AreaIndex + 1].SizeChangingMode = scVertical then
          begin
            for i := AreaIndex + 1 to MAX_AREA_COUNT do
              Areas[i].x1 := Areas[i].x1 + SizeDiff;
          end
          else
            Areas[AreaIndex + 1].x1 := Areas[AreaIndex + 1].x1 + SizeDiff;
        end;
      end;

    end
    else  //scVertical
    begin

      SizeDiff := NewSize - (Areas[AreaIndex].y2 - Areas[AreaIndex].y1 + 1);
      if Areas[AreaIndex].y2 = (GlobalOptions.LEDDisplaySettings.Height - 1) then
      begin
        Areas[AreaIndex].y1 := Areas[AreaIndex].y1 - SizeDiff;
        if (AreaIndex > 1) and not IsUnusedArea(Areas[AreaIndex - 1]) then
        begin
          if Areas[AreaIndex - 1].SizeChangingMode = scHorizontal then
          begin
            for i := 1 to AreaIndex - 1 do
              Areas[i].y2 := Areas[i].y2 - SizeDiff;
          end
          else
            Areas[AreaIndex - 1].y2 := Areas[AreaIndex - 1].y2 - SizeDiff;
        end;
      end
      else
      begin
        Areas[AreaIndex].y2 := Areas[AreaIndex].y2 + SizeDiff;
        if (AreaIndex < MAX_AREA_COUNT) and not IsUnusedArea(Areas[AreaIndex + 1]) then
        begin
          if Areas[AreaIndex + 1].SizeChangingMode = scHorizontal then
          begin
            for i := AreaIndex + 1 to MAX_AREA_COUNT do
              Areas[i].y1 := Areas[i].y1 + SizeDiff;
          end
          else
            Areas[AreaIndex + 1].y1 := Areas[AreaIndex + 1].y1 + SizeDiff;
        end;
      end;

    end;
  end;

  SetupLayout(DisplayStages[ActiveDisplayStage].Areas, LayoutBtn1, LayoutBtn2, LayoutBtn3, LayoutBtn4, LayoutGroup);
  //LayoutChanged;
end;

procedure TMainForm.AreaSizeSpinChange(Sender: TObject);
begin
  SetAreaSizeToChange(ActiveAreaIndex, AreaSizeSpin.Value);
end;

procedure TMainForm.ActiveAreaSizeChanged;
begin
  with DisplayStages[ActiveDisplayStage].Areas[ActiveAreaIndex] do
  begin
    case ContentType of
      ctTime:
        begin
        end;
      ctDate:
        begin
        end;
      ctScrollingText:
        begin
          InputText.OnDelayedChange(InputText);
        end;
      ctAnimation:
        begin
        end;
      ctPicture:
        begin
          UpdatePicturePicturePreview;
        end;
      ctTemperature:
        begin
        end;
      ctEmpty:
        begin
        end;
    end;
  end;
end;

procedure TMainForm.EmptyContentBtnClick(Sender: TObject);
begin
  //************************************
  if not License3.CheckLicenseStatus then
    Halt;
  if not LicenseTimer.Enabled then
    LicenseTimer.Enabled := True;
  //************************************

  SelectContent(ctEmpty, True);
  UpdateEmptyPicturePreview;
end;

procedure TMainForm.NewShowBtnClick(Sender: TObject);
var
  Response: Integer;
  OldWorkingDesignFileName: WideString;
begin
  if WorkingDesignChanged then
  begin
    Response := WideMessageDlgSoundTop(Dyn_Texts[9] {'All the stages will be cleared. Save changes to the current presentation?'}, mtWarning, [mbYes, mbNo, mbCancel], 0);
    if Response = mrCancel then
      Exit
    else if Response = mrYes then
    begin
      SaveBtn.Click;
      if WorkingDesignChanged then
        Exit;
    end;
  end;

  if RuntimeGlobalOptions.UsingTemporaryLEDDisplaySettings then
  begin
    GlobalOptions.LEDDisplaySettings := RuntimeGlobalOptions.OriginalLEDDisplaySettings;
    RuntimeGlobalOptions.UsingTemporaryLEDDisplaySettings := False;

    OnLEDDisplaySettingsChanged;
    UpdateLEDDisplayInfo;
    TemporaryLEDDisplaySettingsMode(False);
  end;

  OldWorkingDesignFileName := WorkingDesignFileName;
  DesignChangeFlag := False;
  WorkingDesignIsReadOnly := False;
  UntitledDesignFile := True;
  Inc(WorkingDesignUntitledCount);
  UpdateMainFormCaption;
  WorkingDesignFileName := '';
  StartNewShow;
  InitiateNewWorkingDesign;
  WorkingOnNewDesignStarted(OldWorkingDesignFileName, '');

  (*
  if WideMessageDlgSound(Dyn_Texts[9] {'All the stages will be cleared. Are you sure?'}, mtWarning, [mbYes, mbNo], 0) = mrYes then
  begin
    StartNewShow;
  end;
  *)
end;

procedure TMainForm.FreeUpDisplayStage(var Stage: TStage);
var
  i: Integer;
begin
  for i := 1 to MAX_AREA_COUNT do
  begin
    //Picture Content
    if Assigned(Stage.Areas[i].PictureBitmap) then
      Stage.Areas[i].PictureBitmap.Free;
    //SWF Content
    if Assigned(Stage.Areas[i].SWFData) then
      Stage.Areas[i].SWFData.Free;
  end;
end;

procedure TMainForm.SetDateTimeBtnClick(Sender: TObject);
begin
  TntXPMenu1.Active := not TntXPMenu1.Active;
  TntXPMenu1.Active := not TntXPMenu1.Active;

  //Show menu or run direct
  if GlobalOptions.NumOfLEDDisplays = 1 then
  begin
    //Run direct
    SetDateTimeMenuItem1.Click;
  end
  else
    //Show menu
    SpecialProcs.PopupMenuAtControl(SetDateTimeBtn, SetDateTimePopup);
end;

procedure TMainForm.InputTextMixedRadioClick(Sender: TObject);
begin
  InputText.BiDiMode := SetCorrectKeyboardLayout;

  //Force to change the language
  try
    InputText.SetFocus;
  except
  end;

  try
    InputTextMixedRadio.SetFocus;
  except
  end;
  Application.ProcessMessages;

  TextDirectionRightRadio.Checked := InputTextFarsiRadio.Checked or InputTextMixedRadio.Checked;
  InputText.OnDelayedChange(InputText);
  try
    InputText.SetFocus;
  except
  end;
end;

procedure TMainForm.ProgramOptionsBtnClick(Sender: TObject);
begin
  if ProgramOptionsForm.ShowModal = mrOk then
  begin
    if GlobalOptions.DontUseHighGUI then
      HighGUITimer.Tag := 0
    else
      HighGUITimer.Tag := 1;
    HighGUITimer.Enabled := not GlobalOptions.DontUseHighGUI;

    TimePreviewTimer.Enabled := GlobalOptions.AutomaticallyRefreshTimePreview;
    if TimePreviewPanel.Visible then
      UpdateTimePicturePreview
  end;
end;

procedure TMainForm.TntFormShow(Sender: TObject);
begin
  //Correct image transparency bug (occurs when skin changes)
  TitleImage.Picture.Bitmap.Width := 0;
  TitleImage.Picture.Bitmap.Height := 0;
  ContentTextImage.Picture.Bitmap.Width := 0;
  ContentTextImage.Picture.Bitmap.Height := 0;
  GetContentBitmap(DisplayStages[ActiveDisplayStage].Areas[ActiveAreaIndex].ContentType, TitleImage.Picture.Bitmap, ContentTextImage.Picture.Bitmap);

  RegistrationPanel.BringToFront;

  ApplyStartupOnShowConfig;

  ApplyAfterShowConfigTimer.Enabled := True;

  //*****************************************
  //Set the OnShow event handler to nil to prevent triggering this event during
  // the application execution by mistake, because we don't want this event to
  // be triggered again at all.
  MainForm.OnShow := nil;
  //*****************************************
end;

procedure TMainForm.PrepareRegistrationPanelView;
var
  GIFImage: TGIFImage;
  rs: TResourceStream;
const
  GIFResourceName ='BUTTON_BORDER_GIF';
begin
  //There is no need to clear the Picture of these image controls, because
  //  after registration, these images will not load in the next application runs.
  SelectModelGroup.Visible := True;
  ActivationCodeGroup.Visible := False;
  SelectModelGroup.BringToFront;
  try
    //Load GIF Image from the resources
    GIFImage := TGIFImage.Create;
    rs := TResourceStream.Create(HInstance, GIFResourceName, 'GIF');
    GIFImage.LoadFromStream(rs);
    //EnglishBtnBorderImage.Picture.Graphic := GIFImage;
    //FarsiBtnBorderImage.Picture.Graphic := GIFImage;
    rs.Free;
    GIFImage.Free;
  except
  end;
end;

procedure TMainForm.ApplyLicenseStatus(Enabled: Boolean);
begin
  if (LicenseWasValid and not Enabled) or
     (not LicenseWasValid and Enabled) then
    Halt;

  if ModelOKBtnClicked and
    (not ActivationCodeGroup.Visible or
     SelectModelGroup.Visible) then
    Halt;


  RuntimeGlobalOptions.HighGUIDeactivatedByLicense := not Enabled;

  RightPanel.Enabled := Enabled;
  TimeContentPanel.Enabled := Enabled;
  DateContentPanel.Enabled := Enabled;
  ScrollingTextContentPanel.Enabled := Enabled;
  AnimationContentPanel.Enabled := Enabled;
  PictureContentPanel.Enabled := Enabled;
  TemperatureContentPanel.Enabled := Enabled;
  EmptyContentPanel.Enabled := Enabled;
  StagesPanel.Enabled := Enabled;
  PreviewPanel.Enabled := Enabled;
  MenuPanel.Enabled := Enabled;
  TitlePanel.Enabled := Enabled;


  if Enabled then
  begin
    //MainForm.BorderIcons := [biSystemMenu, biMinimize, biMaximize];

    //if StandardSystemMenu1.OnlyDelphiMenu then
    //  StandardSystemMenu1.OnlyDelphiMenu := False;
  end
  else
  begin
    //MainForm.BorderIcons := [biSystemMenu, biMinimize];

    //StandardSystemMenu1.OnlyDelphiMenu := True;
  end;

  RegistrationPanel.Visible := not Enabled;

  if not RegistrationPanel.Visible and
     HaltIfInvalidState and
     not Enabled {Enabled is a parameter} then
    Halt;
end;

procedure TMainForm.Far6Click(Sender: TObject);
begin
  Halt;
end;

procedure TMainForm.Far5Click(Sender: TObject);
var
  RegResult: Boolean;
begin
  RegResult := False;
  case (Random(6) + 1) {The number is in the range 1 to 6} of
    1: RegResult := License.RegisterSoftware(ACWord1.Text + ACWord2.Text + ACWord3.Text + ACWord4.Text + ACWord5.Text + ACWord6.Text);
    2: RegResult := License2.RegisterSoftware(ACWord1.Text + ACWord2.Text + ACWord3.Text + ACWord4.Text + ACWord5.Text + ACWord6.Text);
    3: RegResult := License3.RegisterSoftware(ACWord1.Text + ACWord2.Text + ACWord3.Text + ACWord4.Text + ACWord5.Text + ACWord6.Text);
    4: RegResult := License4.RegisterSoftware(ACWord1.Text + ACWord2.Text + ACWord3.Text + ACWord4.Text + ACWord5.Text + ACWord6.Text);
    5: RegResult := License5.RegisterSoftware(ACWord1.Text + ACWord2.Text + ACWord3.Text + ACWord4.Text + ACWord5.Text + ACWord6.Text);
    6: RegResult := License6.RegisterSoftware(ACWord1.Text + ACWord2.Text + ACWord3.Text + ACWord4.Text + ACWord5.Text + ACWord6.Text);
  end;

  if RegResult then
  begin
    LicenseWasValid := License6.CheckLicenseStatusFull;

    //WideMessageDlgSoundTop(WideFormat(Dyn_Texts[10] {'Thank you for the registration.%sPlease restart the application to apply license information.'}, [#13]), mtCustom,
    //  [MBok], 0);
    WideMessageDlgSoundTop(WideFormat(Dyn_Texts[68] {'Thank you for the registration. Please restart the application to apply license information.'}, []), mtCustom,
      [MBok], 0);

    Application.CreateForm(TCreateSupportFileForm, CreateSupportFileForm);
    try
      CreateSupportFileForm.ShowModal;
    finally
      CreateSupportFileForm.Free;
    end;

    Halt;

  {
    RegistrationPanel.Visible := False;
    ApplyLicenseStatus(True);}
  end;
end;

procedure TMainForm.Far7Click(Sender: TObject);
begin
  with THowToBuyForm.Create(nil) do
  begin
    try
      ShowModal;
    finally
      Free;
    end;
  end;
end;

procedure TMainForm.RegistrationPanelMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  ApplyLicenseStatus(License6.CheckLicenseStatus);
end;

function TMainForm.ReplaceInvalidUnicodeChars(const Str: WideString): WideString;
{
  If you change this function, you must also change the same function (
    ReplaceInvalidUnicodeChars) in the MainUnit of the CharacterDesigner
    project. Also update the ReplaceInvalidUnicodeChars procedure in the
    CharMap.dll project.
}
const
  NUM_OF_CHARS = 2;

type
  TReplaceInvalidUnicodeChar = record
    UnicodeCharCode: Integer;
    LanguageNameCondition: String;
  end;

const
{
  Notes:
        1. In WIN98 the $ 6A9 unicode character (ARABI CLETTER KEHEH) is not displayed correctly, but the $0643 unicode character (ARABIC LETTER KAF) is displayed correctly. Always replace KEHEH with KAF.
        2. The $064A (ARABIC LETTER YEH) has 2 dots under it, but the standard farsi YEH does not have it. So if the active language is Farsi, replace the ARABIC LETTER YEH with the unicode character $06CC (ARABIC LETTER FARSI YEH).
}
  OldCharCodes: array[1..NUM_OF_CHARS] of TReplaceInvalidUnicodeChar = (
    (UnicodeCharCode: $06A9 {ARABIC LETTER KEHEH}; LanguageNameCondition: ''),
    (UnicodeCharCode: $064A {ARABIC LETTER YEH}; LanguageNameCondition: 'Farsi')
  );
  NewCharCodes: array[1..NUM_OF_CHARS] of Integer = (
    $0643 {ARABIC LETTER KAF},
    $06CC {ARABIC LETTER FARSI YEH}
  );
var
  i: Integer;
  //ReplaceChar: Boolean;
begin
  //Don't check the Win32Platform variable
  Result := Str;
  for i := 1 to Length(OldCharCodes) do
  begin
    Result := Tnt_WideStringReplace(Result, WideChar(OldCharCodes[i].UnicodeCharCode), WideChar(NewCharCodes[i]), [rfReplaceAll, rfIgnoreCase]);
  end;
end;

procedure TMainForm.SetDynamicTexts(LangInstance: THandle);

  procedure SetDefaultDynamicTexts;
  begin
    Dyn_Texts[1] := 'Size of the display memory exceeded by %s bytes.';
    Dyn_Texts[2] := 'Occured an error while reading configuration. Default configuration loaded.';
    Dyn_Texts[3] := 'You can have maximum number of 255 stages.';

    Dyn_Texts[4] := 'Exit?';

    Dyn_Texts[5] := 'By changing your LED display ssettings, all stages will be cleared. Area you sure you want to continute?';

    Dyn_Texts[6] := 'Program registry settings are corrupted. Default settings loaded';

    Dyn_Texts[7] := 'Unable to read the program registry settings. Default settings loaded';

    Dyn_Texts[8] := 'Unable to save the program settings to the registry.';

    Dyn_Texts[9] := 'All the stages will be cleared. Save changes to the current presentation?';

    Dyn_Texts[10] := 'Thank you for the registration.%sPlease restart the application to apply license information';

    Dyn_Texts[11] := 'The selected font size is greater than the display area size. The text is clipped.';

    Dyn_Texts[12] := 'LFG was not found in the installation folder. Reinstalling the application may fix this problem.';

    Dyn_Texts[13] := 'Unable to create the file %s in the specified location.';

    Dyn_Texts[14] := '%s already exists.%sDo you want to replace it?';

    Dyn_Texts[15] := 'The file is read-only:%s';

    Dyn_Texts[16] := 'Unable to open the design file ''%s''.';

    Dyn_Texts[17] := 'No LED display detected.';

    Dyn_Texts[18] := 'Operation completed successfully.';

    Dyn_Texts[19] := 'The port is automatically closed.';
    Dyn_Texts[20] := 'Could not setup the serial port device.';
    Dyn_Texts[21] := 'Could not flush the serial port buffer.';
    Dyn_Texts[22] := 'Invalid serial port number specified or the port is in use by another application.';
    Dyn_Texts[23] := 'Serial port device was abruptly closed.';
    Dyn_Texts[24] := 'A Communication error (frame, overrun or parity error) occurred.';
    Dyn_Texts[25] := 'Unable to send data completely to the serial port device.';
    Dyn_Texts[26] := 'Unable to read data from the serial port device.';
    Dyn_Texts[27] := 'Could not open the serial port.';
    Dyn_Texts[28] := 'Error in port operation.';
    Dyn_Texts[29] := 'Error in port operation. Buffer size cannot be changed.';
    Dyn_Texts[30] := 'No response for the port is set or enabled.';
    Dyn_Texts[31] := 'A wait for response operation is already in progress.';
    Dyn_Texts[32] := 'Wait for response operation aborted.';

    Dyn_Texts[33] := 'No picture is available on the clipboard.';

    Dyn_Texts[34] := 'Unable to get data from the clipboard.';

    Dyn_Texts[35] := 'Unable to load the picture.';

    Dyn_Texts[36] := 'OK';
    Dyn_Texts[37] := 'Cancel';
    Dyn_Texts[38] := 'Yes';
    Dyn_Texts[39] := 'No';
    Dyn_Texts[40] := 'Abort';
    Dyn_Texts[41] := 'Retry';
    Dyn_Texts[42] := 'Help';

    Dyn_Texts[43] := 'LED Display Control Software';

    Dyn_Texts[44] := 'Time';
    Dyn_Texts[45] := 'Date';
    Dyn_Texts[46] := 'Text';
    Dyn_Texts[47] := 'Animation';
    Dyn_Texts[48] := 'Picture';
    Dyn_Texts[49] := 'Temperature';
    Dyn_Texts[50] := 'Empty';

    Dyn_Texts[51] := 'The alarm settings is invalid for alarm number %s.';
    Dyn_Texts[52] := 'No alarm is defined. Please define some valid alarms.';
    Dyn_Texts[53] := 'Error while reading alarm settings from file %s.';
    Dyn_Texts[54] := 'Unable to save alarm settings to the file %s';
    //Dyn_Texts[55] := '';  -- Free to use
    Dyn_Texts[56] := 'Occurred an error while saving alarm settings to the file %s.';

    Dyn_Texts[57] := 'Operation cancelled incomplete.';
    Dyn_Texts[58] := 'Alarms could not be set correctly.';

    Dyn_Texts[59] := 'Please select a layout to remove it.';
    Dyn_Texts[60] := 'At least one display area must exist on the screen.';
    Dyn_Texts[61] := 'You can have maximum of %s separate display areas on the screen.';
    Dyn_Texts[62] := 'Areas intersect. This my cause display problems. Continue anyway?';

    Dyn_Texts[63] := 'Save changes to the current presentation?';
    Dyn_Texts[64] := 'Unable to open the presentation file ''%s''.';
    Dyn_Texts[65] := 'Do you want to save the changes to the current presentation?';
    Dyn_Texts[66] := 'Unable to save the presentation to the file:%s';

    Dyn_Texts[67] := 'The presentation file %sdoesn''t exist.';
    Dyn_Texts[68] := 'Thank you for the registration. Please restart the application to apply license information.';

    Dyn_Texts[69] := 'Size of the design file of the text is larger than the display area. The text is clipped.';

    Dyn_Texts[70] := 'Help file:%s was not found.';

    Dyn_Texts[71] := 'and';  //Used for AreaColorCombo.Items.String[2]

    Dyn_Texts[72] := 'File of the selected picture cannot be found.';
    Dyn_Texts[73] := 'Invalid picture file.';

    Dyn_Texts[74] := 'File of the selected animation cannot be found.';
    Dyn_Texts[75] := 'Invalid GIF animation file.';

    Dyn_Texts[76] := 'The LED Display is processing the received data and cannot be used for now. Please wait a few seconds.';

    Dyn_Texts[77] := 'Time and date of the LED Display set to the current time and date.';

    Dyn_Texts[78] := 'Please enter a valid value for the number of columns.';
    Dyn_Texts[79] := 'Please enter a valid value for the number of rows.';

    Dyn_Texts[80] := 'The file%sis either corrupted or for older versions or newer versions of LED Display Control and cannot be opened in this version.';

    Dyn_Texts[81] := 'The firmware version of the target device does not match.';
    Dyn_Texts[82] := 'The LED Display did not respond correctly. Please try again.';

    Dyn_Texts[83] := 'Settings do not match. Use temporary settings?';

    Dyn_Texts[84] := 'Has';
    Dyn_Texts[85] := 'Do not have';

    Dyn_Texts[86] := 'to';

    Dyn_Texts[87] := 'Connection with the LED Display established and the operation completed successfully.';
    Dyn_Texts[88] := 'Invalid data received from the LED Display. Please try again later.';

    Dyn_Texts[89] := 'Other files...';

    Dyn_Texts[90] := 'Time: ';
    Dyn_Texts[91] := 'Date: ';
    Dyn_Texts[92] := 'Scrolling Text: ';
    Dyn_Texts[93] := 'Animation: ';
    Dyn_Texts[94] := 'Picture: ';
    Dyn_Texts[95] := 'Temperature: ';
    Dyn_Texts[96] := 'Empty:';

    Dyn_Texts[97] := 'Converting picture...';

    Dyn_Texts[98] := 'The file%sis corrupted and cannot be opened.';

    Dyn_Texts[99] := 'Preparing data to send';

    Dyn_Texts[100] := 'Are you sure to sort animation line?';

    Dyn_Texts[101] := 'There is no stage with a time span defined.';

    Dyn_Texts[102] := 'Operation cancelled by the user. The LED Display data may be incorrect.';
    Dyn_Texts[103] := 'Operation cancelled.';

    Dyn_Texts[104] := 'You have selected the same connection port for your LED Displays. Are you sure?';

    Dyn_Texts[105] := 'No response from the LED Display connected to the port. Please try again later.';

    Dyn_Texts[106] := 'No alarm is set for the LED Display connected to the port.';

    Dyn_Texts[107] := '12-Month Alarm System';

    Dyn_Texts[108] := 'No alarm is set for the month %s on the LED Display.';

    Dyn_Texts[109] := 'Get LED Display Alarm Setting';
    Dyn_Texts[110] := 'Get LED Display Alarm Setting For the Month %s';
    Dyn_Texts[111] := 'Set LED Display Alarms';
    Dyn_Texts[112] := 'Set LED Display Alarms For the Month %s';
    Dyn_Texts[113] := 'Clear LED Display All Alarms';
    Dyn_Texts[114] := 'Clear LED Display All Alarms For the Month %s';

    Dyn_Texts[115] := 'Setting the LED Display time and date';

    Dyn_Texts[116] := 'The device connected to the port is the portable memory and it has not date/time features. To set LED Display date and time using computer, you should connect it directly to the computer.';

    Dyn_Texts[117] := 'The size of the sms picture you have selected is greater than the current display area. Do you want to scale it to fit into the area?';

    Dyn_Texts[118] := 'The selected file is invalid.';
    Dyn_Texts[119] := 'The program is unable to open the file:%sMaybe it is being used by another application.';

    Dyn_Texts[120] := 'Error in operation. Please try again. If problem persists, restart the application.';

    Dyn_Texts[121] := '%s Rows x %s Columns';

    Dyn_Texts[122] := 'To show presentation on the LED Display, at least one display stage must exist. Please make some display stages active and try again.';

    Dyn_Texts[123] := 'Areas intersect. This my cause display problems. Please change layout and size of the display areas and then press OK.';

    Dyn_Texts[124] := 'The file%sis corrupted and cannot be opened. Do you want to open it anyway?';

    Dyn_Texts[125] := 'The LED Display size for this file is greater than the size of the LED Display supported with your version of LED Display Control and cannot be used.';

    Dyn_Texts[126] := 'This version of the LED Display Control Software does not contain LED Font Generator LE for designing advanced text and pictures.';

    Dyn_Texts[127] := 'Copy your animation files to this folder and restart the application to use them.';

    Dyn_Texts[128] := 'Number of alarms of the LED Display is greater thanthe number of alarms you have set in the LED Display settings form. Not all alarms have been shown. Please correct the LED Display settings.';
    Dyn_Texts[129] := 'The number of alarms in the file is greater than the number of alarms you have set for the LED Display settings form. Extra alarms have not been loaded from the file.';

    Dyn_Texts[130] := 'This is LED Display portable memory connected to the port and only its memory size is received. To view the LED Display settings, please connect the LED Display itself to the port.';

    Dyn_Texts[131] := 'You have not defined any animation for the stage %s.';
    Dyn_Texts[132] := 'The animation file %s does not exist.';
    Dyn_Texts[133] := 'No picture is defined for the stage %s.';

    Dyn_Texts[134] := 'SWF Animation';

    Dyn_Texts[135] := 'You have not defined any SWF animation for the stage %s.';

    Dyn_Texts[136] := 'SWF Animation: ';

    Dyn_Texts[137] := 'This is LED Display portable memory connected to the port. You must connect the LED Display itself to the computer to complete this operation.';

    Dyn_Texts[138] := 'Setting LED Display Off Time';

    Dyn_Texts[139] := 'Error occurred during the operation. Please try again.';

    Dyn_Texts[140] := 'Support file successfully create in:%s';

    Dyn_Texts[141] := 'The input time span is invalid. Start time must be before than the end time.';

    Dyn_Texts[142] := 'Please select a model to continue.';

    Dyn_Texts[143] := 'No swf file has been selected. Please select an swf file first.';
    Dyn_Texts[144] := 'There was an error while converting the swf animation. This file is not in a correct format to display on the LED Display.%s';
  end;

  function GetStaticText(ResID: Integer): WideString;
  var
    ResStringRec: TResStringRec;
  begin
    ResStringRec.Identifier := ResID + STATIC_LANG_RESID_START_NUM;
    ResStringRec.Module := @LangInstance;
    Result := MainForm.ReplaceInvalidUnicodeChars(WideLoadResString(@ResStringRec));
  end;

var
  i: Integer;
  S: WideString;
  ResStringRec: TResStringRec;
begin
  SetDefaultDynamicTexts;
  if LangInstance = 0 then
    Exit;

  ResStringRec.Module := @LangInstance;
  for i := 1 to DYNAMIC_TEXTS_COUNT do
  begin
    ResStringRec.Identifier := i + DYNAMIC_LANG_RESID_START_NUM;
    S := MainForm.ReplaceInvalidUnicodeChars(WideLoadResString(@ResStringRec));
    if Length(S) > 0 then
      Dyn_Texts[i] := S;
  end;

  //if Length(GetStaticText(0)) > 0 then
  //  MainForm.Caption := GetStaticText(0);
  if Length(GetStaticText(1)) > 0 then
    DIALOGS_TITLE := GetStaticText(1);

  SetMessageDlgCaptions;
end;

procedure TMainForm.SetMessageDlgCaptions;
begin
  //Change message dialog button captions
  TntDialogs.ButtonCaptions[mbYes] := Dyn_Texts[38];  //SMsgDlgYes;
  TntDialogs.ButtonCaptions[mbNo] := Dyn_Texts[39];  //SMsgDlgNo;
  TntDialogs.ButtonCaptions[mbOK] := Dyn_Texts[36];  //SMsgDlgOK;
  TntDialogs.ButtonCaptions[mbCancel] := Dyn_Texts[37];  //SMsgDlgCancel;
  TntDialogs.ButtonCaptions[mbAbort] := Dyn_Texts[40];  //SMsgDlgAbort;
  TntDialogs.ButtonCaptions[mbRetry] := Dyn_Texts[41];  //SMsgDlgRetry;
  TntDialogs.ButtonCaptions[mbIgnore] := '&Ignore';  //SMsgDlgIgnore;
  TntDialogs.ButtonCaptions[mbAll] := '&All';  //SMsgDlgAll;
  TntDialogs.ButtonCaptions[mbNoToAll] := 'N&o to All';  //SMsgDlgNoToAll;
  TntDialogs.ButtonCaptions[mbYesToAll] := 'Yes to &All';  //SMsgDlgYesToAll;
  TntDialogs.ButtonCaptions[mbHelp] := Dyn_Texts[42];  //SMsgDlgHelp;

  sTntDialogs.ButtonCaptions[mbYes] := Dyn_Texts[38];  //SMsgDlgYes;
  sTntDialogs.ButtonCaptions[mbNo] := Dyn_Texts[39];  //SMsgDlgNo;
  sTntDialogs.ButtonCaptions[mbOK] := Dyn_Texts[36];  //SMsgDlgOK;
  sTntDialogs.ButtonCaptions[mbCancel] := Dyn_Texts[37];  //SMsgDlgCancel;
  sTntDialogs.ButtonCaptions[mbAbort] := Dyn_Texts[40];  //SMsgDlgAbort;
  sTntDialogs.ButtonCaptions[mbRetry] := Dyn_Texts[41];  //SMsgDlgRetry;
  sTntDialogs.ButtonCaptions[mbIgnore] := '&Ignore';  //SMsgDlgIgnore;
  sTntDialogs.ButtonCaptions[mbAll] := '&All';  //SMsgDlgAll;
  sTntDialogs.ButtonCaptions[mbNoToAll] := 'N&o to All';  //SMsgDlgNoToAll;
  sTntDialogs.ButtonCaptions[mbYesToAll] := 'Yes to &All';  //SMsgDlgYesToAll;
  sTntDialogs.ButtonCaptions[mbHelp] := Dyn_Texts[42];  //SMsgDlgHelp;
end;

procedure TMainForm.LoadLanguageResources;
begin
  SetDynamicTexts(HInstance);
end;

procedure TMainForm.LoadApplicationResources;
begin
  LoadGIFFromResource('PROGRESS_GIF', ProgressImage.Picture)
end;

procedure TMainForm.HideProgress;
begin
  ProgressGroup.Tag := ProgressGroup.Tag - 1;
  if ProgressGroup.Tag <= 0 then
  begin
    MainForm.Enabled := True;
    ProgressGroup.Hide;
    ProgressGroup.Repaint;
  end;
end;

procedure TMainForm.ShowProgress;
begin
  MainForm.Enabled := False;
  if ProgressGroup.Tag = 0 then
    ProgressTimer.Enabled := True;
  ProgressGroup.Tag := ProgressGroup.Tag + 1;
end;

procedure TMainForm.ProgressTimerTimer(Sender: TObject);
begin
  ProgressTimer.Enabled := False;
  if ProgressGroup.Tag > 0 then
    ProgressGroup.Show;
end;

procedure TMainForm.FontSizeWarningBtn1Click(Sender: TObject);
begin
  WideMessageDlgSound(Dyn_Texts[11] {'The selected font size is greater than the display area size. The text is clipped.'}, mtWarning, [mbOK], 0);
end;

procedure TMainForm.ShowFontSizeWarning(Show: Boolean);
begin
  if Show then
  begin
    //if FontSizeWarningBtn1.Visible = True then
    //  Exit;
    FontSizeWarningTimer.Enabled := False;

    FontSizeWarningBtn1.Visible := False;
    LFGFileSizeWarningBtn1.Visible := False;

    FontSizeWarningBtn1.Tag := 0;
    LFGFileSizeWarningBtn1.Tag := 0;

    FontSizeWarningTimer.Enabled := True;
  end
  else
  begin
    FontSizeWarningTimer.Enabled := False;
    //if SimpleTextTabBtn.Down then  --> Prevent potential software bugs
      FontSizeWarningBtn1.Visible := False;
    //else //if AdvancedTextTabBtn.Down then
      LFGFileSizeWarningBtn1.Visible := False;
  end;
end;

procedure TMainForm.FontSizeWarningTimerTimer(Sender: TObject);
begin
  if SimpleTextTabBtn.Down then
  begin
    FontSizeWarningBtn1.Visible := not FontSizeWarningBtn1.Visible;
    if FontSizeWarningBtn1.Visible then
      FontSizeWarningBtn1.Tag := FontSizeWarningBtn1.Tag + 1;
    if FontSizeWarningBtn1.Tag = (FONT_SIZE_WARNING_BLINK_COUNT + 1) then
    begin
      FontSizeWarningTimer.Enabled := False;
      FontSizeWarningBtn1.Visible := True;
    end;
  end
  else //if AdvancedTextTabBtn.Down then
  begin
    LFGFileSizeWarningBtn1.Visible := not LFGFileSizeWarningBtn1.Visible;
    if LFGFileSizeWarningBtn1.Visible then
      LFGFileSizeWarningBtn1.Tag := LFGFileSizeWarningBtn1.Tag + 1;
    if LFGFileSizeWarningBtn1.Tag = (FONT_SIZE_WARNING_BLINK_COUNT + 1) then
    begin
      FontSizeWarningTimer.Enabled := False;
      LFGFileSizeWarningBtn1.Visible := True;
    end;
  end;
end;

procedure TMainForm.StartNewShow;
var
  i: Integer;
begin
  for i := 0 to High(DisplayStages) do
  begin
    DisplayStages[i].StagePanel.Free;
    FreeUpDisplayStage(DisplayStages[i]);
  end;
  SetLength_DisplayStages(DisplayStages, 0);

  //Initialize animation line
  SelectStage(NewStage(False), True, False);
  SelectStagePanel(DisplayStages[ActiveDisplayStage], True);
  LayoutChanged;
end;

procedure TMainForm.ForwardCurrentStageBtnClick(Sender: TObject);
begin
  if ActiveDisplayStage < High(DisplayStages) then
  begin
    SaveAreaSettings(ActiveAreaIndex);
    ExchangeStages(ActiveDisplayStage, ActiveDisplayStage + 1);
    SelectStage(ActiveDisplayStage + 1, True, False);
    //SelectStagePanel(DisplayStages[ActiveDisplayStage].StagePanel, True);
    SelectStagePanel(DisplayStages[ActiveDisplayStage], False);
  end;
end;

procedure TMainForm.BackwardCurrentStageBtnClick(Sender: TObject);
begin
  if ActiveDisplayStage > 0 then
  begin
    SaveAreaSettings(ActiveAreaIndex);
    ExchangeStages(ActiveDisplayStage, ActiveDisplayStage - 1);
    SelectStage(ActiveDisplayStage - 1, True, False);
    //SelectStagePanel(DisplayStages[ActiveDisplayStage].StagePanel, True);
    SelectStagePanel(DisplayStages[ActiveDisplayStage], False);
  end;
end;

procedure TMainForm.ExchangeStages(Stage1Index, Stage2Index: Integer);
var
  Stage: TStage;
  i: Integer;
begin
  //At least one stage must exist
  if Length(DisplayStages) = 1 then
    Exit;

  Stage := DisplayStages[Stage1Index];

  DisplayStages[Stage1Index] := DisplayStages[Stage2Index];
  DisplayStages[Stage1Index].StagePanel.Tag := Stage1Index;

  DisplayStages[Stage2Index] := Stage;
  DisplayStages[Stage2Index].StagePanel.Tag := Stage2Index;

  for i := 0 to High(DisplayStages) do
    PositionStagePanel(i);
end;

procedure TMainForm.ChangeKeyboardLanguage(Language: TLanguage);
begin
  case Language of
    laFarsi:  Application.BiDiKeyboard := '00000429';
    laEnglish:  Application.BiDiKeyboard := '00000409';
    else
      Application.BiDiKeyboard := '00000409';
  end;
end;

procedure TMainForm.GotoLFGBtnClick(Sender: TObject);
begin
  RunLFG4LDC('', True);
end;

procedure TMainForm.SimpleTextTabBtnMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  GeneratePreview: Boolean;
begin
  GeneratePreview := AdvancedTextTabBtn.Down;

  AdvancedTextTabBtn.Down := False;
  SimpleTextTabBtn.Down := True;
  SimpleTextGroupBox.BringToFront;
  SimpleTextTabBtn.BringToFront;
  AdvancedTextTabBtn.BringToFront;

  SetCorrectKeyboardLayout;
  try
    InputText.SetFocus;
  except
  end;
  if GeneratePreview then
    InputText.OnDelayedChange(InputText);

  //Because MainForm becomes disabled when generating text preview takes tool long time, the button will not receive the WM_LBUTTONUP message
  SendMessage(SimpleTextTabBtn.Handle, WM_LBUTTONUP, 0, 0);
end;

procedure TMainForm.AdvancedTextTabBtnMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  AdvancedTextTabBtn.Down := True;
  SimpleTextTabBtn.Down := False;
  AdvancedTextGroupBox.BringToFront;
  SimpleTextTabBtn.BringToFront;
  AdvancedTextTabBtn.BringToFront;

  ShowAdvancedTextPreview(ScrollingTextDesignFilePathEdit.Text);

  SendMessage(AdvancedTextTabBtn.Handle, WM_LBUTTONUP, 0, 0);
end;

procedure TMainForm.SelectScrollingTextDesignFileBtnClick(Sender: TObject);
begin
  if (LFGFileOpenDialog.Tag = 0) or  //Is this the first time the dialog is being opened?
     (LFGFileOpenDialog.InitialDir = GlobalOptions.MY_PICTURE_DESIGNS_FOLDER_FULL_PATH) then
  begin
    LFGFileOpenDialog.Tag := 1;
    LFGFileOpenDialog.InitialDir := GlobalOptions.MY_TEXT_DESIGNS_FOLDER_FULL_PATH;
  end;

  if LFGFileOpenDialog.Execute then
  begin
    ScrollingTextDesignFilePathEdit.Text := LFGFileOpenDialog.FileName;
    ScrollingTextDesignFilePathLabel.Caption := MinimizeName(LFGFileOpenDialog.FileName, ScrollingTextDesignFilePathLabel.Canvas, ScrollingTextDesignFilePathLabel.Width);
    EditScrollingTextDesignFileBtn.Enabled := True;
  end;

  ShowAdvancedTextPreview(ScrollingTextDesignFilePathEdit.Text);
end;

procedure TMainForm.SimpleTextTabBtnClick(Sender: TObject);
begin
  SimpleTextTabBtn.OnMouseDown(SimpleTextTabBtn, mbLeft, [], 0, 0);
end;

procedure TMainForm.AdvancedTextTabBtnClick(Sender: TObject);
begin
  AdvancedTextTabBtn.OnMouseDown(AdvancedTextTabBtn, mbLeft, [], 0, 0);
end;

procedure TMainForm.OpenFileWithLFG4LDC(const FileName: String);
begin
  RunLFG4LDC('', True);
end;

procedure TMainForm.RunLFG4LDC(const CmdLineParameters: String;
  ShowErrorMessage: Boolean);
  function GetInstalledLFGExeFileFullPath(LFGVersionStr: String): String;
  var
    Reg: TRegistry;
  begin
    Result := '';
    Reg := TRegistry.Create(KEY_READ);
    try
      Reg.RootKey := HKEY_CURRENT_USER;
      if Reg.KeyExists('Software\LED Font Generator\' + LFGVersionStr + '\Globals') then
      begin
        if Reg.OpenKeyReadOnly('Software\LED Font Generator\' + LFGVersionStr + '\Globals') then
        begin
          if Reg.ValueExists('InstallDir') then
            Result := Reg.ReadString('InstallDir') + 'LFG.exe';

          Reg.CloseKey;
        end;
      end;
      Reg.Free;
    except
      Reg.Free;
      Exit;
    end;
  end;

begin
  if License._INTERNAL_LFG_INLCUDED_ and FileExists(ApplicationPath + LFG_FULL_FILE_NAME) then
    WinExec(PAnsiChar(ApplicationPath + LFG_FULL_FILE_NAME + ' "' + CmdLineParameters + '"'), SW_SHOWNORMAL)
  else if WideFileExists(GetInstalledLFGExeFileFullPath('2.0')) then  //This version of LDC is only compatible with LFG version 2.0 (latest release before release of LDC)
    WinExec(PAnsiChar(GetInstalledLFGExeFileFullPath('2.0') + ' "' + CmdLineParameters + '"'), SW_SHOWNORMAL)
  else
  begin
    if ShowErrorMessage then
    begin
      if License._INTERNAL_LFG_INLCUDED_ then
        WideMessageDlgSound(Dyn_Texts[12] {'LFG was not found in the installation folder. Reinstalling the application may fix this problem.'}, mtError, [mbOK], 0)
      else
        WideMessageDlgSound(Dyn_Texts[126] {'This version of the LED Display Control Software does not contain LED Font Generator LE for designing advanced text and pictures.'}, mtError, [mbOK], 0);
    end;
  end
end;

procedure TMainForm.EditScrollingTextDesignFileBtnClick(Sender: TObject);
begin
  RunLFG4LDC(ScrollingTextDesignFilePathEdit.Text, True);

  ShowAdvancedTextPreview(ScrollingTextDesignFilePathEdit.Text);
end;

procedure TMainForm.CreateScrollingTextDesignFileBtnClick(Sender: TObject);
var
  FName: WideString;
  RetrySave, SaveError: Boolean;
begin
  if LFGFileSaveDialog.Tag = 0 then  //Is this the first time the dialog is being opened?
  begin
    LFGFileSaveDialog.Tag := 1;
    if WideDirectoryExists(GlobalOptions.MY_TEXT_DESIGNS_FOLDER_FULL_PATH) then
      LFGFileSaveDialog.FileName := GlobalOptions.MY_TEXT_DESIGNS_FOLDER_FULL_PATH + '\' + NEW_LFG_TEXT_FILE_NAME;
  end
  else
    LFGFileSaveDialog.FileName := NEW_LFG_TEXT_FILE_NAME;

  RetrySave := True;
  while RetrySave do
  begin
    if LFGFileSaveDialog.Execute then
    begin
      FName := Procs.ApplyFileNameExtension(LFGFileSaveDialog.FileName,
                 ExtractFileExt(Procs.ExtractFilterString(LFGFileSaveDialog.Filter, LFGFileSaveDialog.FilterIndex)),
                 True);  //Force file extension
      if InformForReadOnlySelectedFile(FName) then
        Continue;

      SaveError := False;
      if WideFileExists(FName) then
        SaveError := not WideDeleteFile(FName);

      if not SaveError then
        with DisplayStages[ActiveDisplayStage].Areas[ActiveAreaIndex] do
          SaveError := not CreateEmptyLFGDesignFile(FName, x2 - x1 + 1, y2 - y1 + 1);

      if SaveError then
        if not(WideMessageDlgSoundTop(WideFormat(Dyn_Texts[13] {'Unable to create the file %s in the specified location.'}, [#13 + FName + #13]), mtError, [mbCancel, mbRetry], 0) = mrRetry) then
          Exit;
      if SaveError then
        Continue;

      //with TFileStream.Create(FName, fmCreate) do
      //  Free;

      ScrollingTextDesignFilePathEdit.Text := FName;
      ScrollingTextDesignFilePathLabel.Caption := MinimizeName(FName, ScrollingTextDesignFilePathLabel.Canvas, ScrollingTextDesignFilePathLabel.Width);
      EditScrollingTextDesignFileBtn.Enabled := True;

      RunLFG4LDC(FName, True);

      RetrySave := False;
    end
    else
      RetrySave := False;
  end;

  ShowAdvancedTextPreview(ScrollingTextDesignFilePathEdit.Text);
end;

procedure TMainForm.ScrollingTextDesignFilePathLabelMouseEnter(
  Sender: TObject);
begin
  if EditScrollingTextDesignFileBtn.Enabled then
  begin
    ScrollingTextDesignFilePathLabel.Cursor := crHandPoint;
    ScrollingTextDesignFilePathLabel.Font.Color := clBlue;
  end
  else
    ScrollingTextDesignFilePathLabel.Cursor := crDefault;
end;

procedure TMainForm.ScrollingTextDesignFilePathLabelMouseLeave(
  Sender: TObject);
begin
  ScrollingTextDesignFilePathLabel.Font.Color := clBlack;
end;

procedure TMainForm.ScrollingTextDesignFilePathLabelClick(Sender: TObject);
begin
  if EditScrollingTextDesignFileBtn.Enabled then
    EditScrollingTextDesignFileBtn.Click;
end;

procedure TMainForm.LFGFileSaveDialogCanClose(Sender: TObject;
  var CanClose: Boolean);
begin
  CanClose := PromptForFileReplace(LFGFileSaveDialog.FileName,
                ExtractFileExt(Procs.ExtractFilterString(LFGFileSaveDialog.Filter,
                LFGFileSaveDialog.FilterIndex)),
                True);  //Force file extension
end;

function TMainForm.PromptForFileReplace(const FileName,
  Extension: WideString; ForceExtension: Boolean): Boolean;
var
  FName: WideString;
begin
  {Returns: True: File does not exist or user confirmed to replace the file
            False: File does not exist or the user cancelled file replacing}
  Result := True;
  FName := Procs.ApplyFileNameExtension(FileName, Extension, ForceExtension);
  if WideFileExists(FName) then
    Result := WideMessageDlgSoundTop(Wideformat(Dyn_Texts[14] {'%s already exists.%sDo you want to replace it?'},
                                     [FName, #13]), mtWarning, [mbYes, mbNo], 0) = mrYes;
end;

function TMainForm.InformForReadOnlySelectedFile(
  const FName: WideString): Boolean;
begin
  //Return value: True: FName is read-only
  //              False: FName is not read-only
  Result := WideFileExists(FName) and Procs.WideIsReadOnlyFile(FName);
  if Result then
    WideMessageDlgSoundTop(WideFormat(Dyn_Texts[15] {'The file is read-only:%s'}, [#13 + FName]), mtWarning, [mbOK], 0);
end;

procedure TMainForm.SimplePictureTabBtnClick(Sender: TObject);
begin
  SimplePictureTabBtn.OnMouseDown(SimplePictureTabBtn, mbLeft, [], 0, 0);
end;

procedure TMainForm.AdvancedPictureTabBtnClick(Sender: TObject);
begin
  AdvancedPictureTabBtn.OnMouseDown(AdvancedPictureTabBtn, mbLeft, [], 0, 0);
end;

procedure TMainForm.SimplePictureTabBtnMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if AdvancedPictureTabBtn.Down then
  begin
    ClearImage(PicturePreviewImage);
    PictureWidthLabel.Caption := '0';
    PictureHeightLabel.Caption := '0';
  end;

  AdvancedPictureTabBtn.Down := False;
  SimplePictureTabBtn.Down := True;
  SimplePictureGroupBox.BringToFront;
  SimplePictureTabBtn.BringToFront;
  AdvancedPictureTabBtn.BringToFront;

//  DisplayStages[ActiveDisplayStage].Areas[ActiveAreaIndex].PictureAvailable := False;
  SendMessage(SimplePictureTabBtn.Handle, WM_LBUTTONUP, 0, 0);

  if Assigned(DefaultPicturesCombo.OnChange) then
    DefaultPicturesCombo.OnChange(DefaultPicturesCombo);  //This will never make any errors because all the conditions to use default pictures is checked in the OnChange event handler of DefaultPicturesCombo.

  UpdatePicturePicturePreview;
end;

procedure TMainForm.AdvancedPictureTabBtnMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  AdvancedPictureTabBtn.Down := True;
  SimplePictureTabBtn.Down := False;
  AdvancedPictureGroupBox.BringToFront;
  SimplePictureTabBtn.BringToFront;
  AdvancedPictureTabBtn.BringToFront;

  ShowAdvancedPicturePreview(PictureDesignFilePathEdit.Text);

  SendMessage(AdvancedPictureTabBtn.Handle, WM_LBUTTONUP, 0, 0);
end;

procedure TMainForm.SelectPictureDesignFileBtnClick(Sender: TObject);
begin
  if (LFGFileOpenDialog.Tag = 0) or  //Is this the first time the dialog is being opened?
     (LFGFileOpenDialog.InitialDir = GlobalOptions.MY_TEXT_DESIGNS_FOLDER_FULL_PATH) then
  begin
    LFGFileOpenDialog.Tag := 1;
    LFGFileOpenDialog.InitialDir := GlobalOptions.MY_PICTURE_DESIGNS_FOLDER_FULL_PATH;
  end;

  if LFGFileOpenDialog.Execute then
  begin
    PictureDesignFilePathEdit.Text := LFGFileOpenDialog.FileName;
    PictureDesignFilePathLabel.Caption := MinimizeName(LFGFileOpenDialog.FileName, PictureDesignFilePathLabel.Canvas, PictureDesignFilePathLabel.Width);
    EditPictureDesignFileBtn.Enabled := True;
  end;

  ShowAdvancedPicturePreview(PictureDesignFilePathEdit.Text);
end;

procedure TMainForm.EditPictureDesignFileBtnClick(Sender: TObject);
begin
  RunLFG4LDC(PictureDesignFilePathEdit.Text, True);

  ShowAdvancedPicturePreview(PictureDesignFilePathEdit.Text);
end;

procedure TMainForm.CreatePictureDesignFileBtnClick(Sender: TObject);
var
  FName: WideString;
  RetrySave, SaveError: Boolean;
begin
  if LFGFileSaveDialog.Tag = 0 then  //Is this the first time the dialog is being opened?
  begin
    LFGFileSaveDialog.Tag := 1;
    if WideDirectoryExists(GlobalOptions.MY_PICTURE_DESIGNS_FOLDER_FULL_PATH) then
      LFGFileSaveDialog.FileName := GlobalOptions.MY_PICTURE_DESIGNS_FOLDER_FULL_PATH + '\' + NEW_LFG_PICTURE_FILE_NAME;
  end
  else
    LFGFileSaveDialog.FileName := NEW_LFG_PICTURE_FILE_NAME;

  RetrySave := True;
  while RetrySave do
  begin
    if LFGFileSaveDialog.Execute then
    begin
      FName := Procs.ApplyFileNameExtension(LFGFileSaveDialog.FileName,
                 ExtractFileExt(Procs.ExtractFilterString(LFGFileSaveDialog.Filter, LFGFileSaveDialog.FilterIndex)),
                 True);  //Force file extension
      if InformForReadOnlySelectedFile(FName) then
        Continue;

      SaveError := False;
      if WideFileExists(FName) then
        SaveError := not WideDeleteFile(FName);

      if not SaveError then
        with DisplayStages[ActiveDisplayStage].Areas[ActiveAreaIndex] do
          SaveError := not CreateEmptyLFGDesignFile(FName, x2 - x1 + 1, y2 - y1 + 1);

      if SaveError then
        if not(WideMessageDlgSoundTop(WideFormat(Dyn_Texts[13] {'Unable to create the file %s in the specified location.'}, [#13 + FName + #13]), mtError, [mbCancel, mbRetry], 0) = mrRetry) then
          Exit;
      if SaveError then
        Continue;

      //with TFileStream.Create(FName, fmCreate) do
      //  Free;

      PictureDesignFilePathEdit.Text := FName;
      PictureDesignFilePathLabel.Caption := MinimizeName(FName, PictureDesignFilePathLabel.Canvas, PictureDesignFilePathLabel.Width);
      EditPictureDesignFileBtn.Enabled := True;

      RunLFG4LDC(FName, True);

      RetrySave := False;
    end
    else
      RetrySave := False;
  end;

  ShowAdvancedPicturePreview(PictureDesignFilePathEdit.Text);
end;

procedure TMainForm.PictureDesignFilePathLabelMouseEnter(Sender: TObject);
begin
  if EditPictureDesignFileBtn.Enabled then
  begin
    PictureDesignFilePathLabel.Cursor := crHandPoint;
    PictureDesignFilePathLabel.Font.Color := clBlue;
  end
  else
    PictureDesignFilePathLabel.Cursor := crDefault;
end;

procedure TMainForm.PictureDesignFilePathLabelMouseLeave(Sender: TObject);
begin
  PictureDesignFilePathLabel.Font.Color := clBlack;
end;

procedure TMainForm.PictureDesignFilePathLabelClick(Sender: TObject);
begin
  if EditPictureDesignFileBtn.Enabled then
    EditPictureDesignFileBtn.Click;
end;

function TMainForm.OpenLFGFile(const LFGFileName: String;
  DesGrid: TAdvStringGrid): Boolean;
begin
  Result := False;
  try
    LoadLFGDesignFromFile(DesGrid, LFGFileName);
  except
    WideMessageDlgSoundTop(WideFormat(Dyn_Texts[16] {'Unable to open the design file ''%s''.'}, [LFGFileName]), mtError, [mbOK], 0);
    Exit;
  end;
  Result := True;
end;

function TMainForm.LoadLFGDesignFromFile(ALCDGrid: TAdvStringGrid;
  const FName: String): Boolean;
var
  Row, Col: Integer;
begin
  Result := True;
  ALCDGrid.ColCount := 1;
  ALCDGrid.RowCount := 1;
  //ALCDGrid.RowHeights[ALCDGrid.RowCount - 1] := 0;  --> No need
  try
    ALCDGrid.LoadFromCSV(FName);
  finally
    //Don't allow zero-lengthed LCD
    if (ALCDGrid.ColCount = 0) or
       ( (ALCDGrid.ColCount = 1) and (Procs.FileSize(FName) = 0) ) then
      ALCDGrid.ColCount := GlobalOptions.NewLFGFileDefaultWidth;
    if ALCDGrid.RowCount <= 1 then
      ALCDGrid.RowCount := GlobalOptions.NewLFGFileDefaultHeight;// + 1;

    ALCDGrid.DefaultRowHeight := ALCDGrid.DefaultRowHeight;

    //ALCDGrid.RowHeights[ALCDGrid.RowCount - 1] := 0;  --> No need
    ALCDGrid.RemoveRows(ALCDGrid.RowCount - 1, 1);

    ColorizeLCDGrid(ALCDGrid, LCDFilledColor, LCDClearedColor);
    for Row := 0 to ALCDGrid.RowCount - 1 do
      for Col := 0 to ALCDGrid.ColCount - 1 do
        ALCDGrid.Cells[Col, Row] := '';
  end;
end;

procedure TMainForm.ColorizeLCDGrid(ALCDGrid: TAdvStringGrid; FilledColor,
  ClearedColor: TColor; ClearText: Boolean = True);
var
  Col, Row: Integer;
begin
  for Row := 0 to ALCDGrid.RowCount - 1 do
    for Col := 0 to ALCDGrid.ColCount - 1 do
    begin
      if ALCDGrid.Cells[Col, Row] = '1' then
        SetCellColor(ALCDGrid, Col, Row, True)
      else
        SetCellColor(ALCDGrid, Col, Row, False);
      if ClearText then
        ALCDGrid.Cells[Col, Row] := '';
    end;
end;

procedure TMainForm.ShowAdvancedTextPreview(const LFGFileName: String);
begin
  if FileExists(LFGFileName) then
  begin
    if OpenLFGFile(LFGFileName, TextToLCDGrid) then
      TextToLCDGrid.Tag := 1
    else
      TextToLCDGrid.Tag := 0;
  end
  else
    TextToLCDGrid.Tag := 0;
  UpdateTextPicturePreview;
end;

function TMainForm.SetCorrectKeyboardLayout: TBiDiMode;
begin
  //Currently applied only to ctScrollingText content type
  if InputTextFarsiRadio.Checked or InputTextMixedRadio.Checked then
  begin
    ChangeKeyboardLanguage(laFarsi);
    Result := bdRightToLeft;
  end
  else
  begin
    ChangeKeyboardLanguage(laEnglish);
    Result := bdLeftToRight;
  end;
end;

procedure TMainForm.RefreshAdvancedTextPreviewBtnClick(Sender: TObject);
begin
  if (DisplayStages[ActiveDisplayStage].Areas[ActiveAreaIndex].ContentType = ctScrollingText) and
     AdvancedTextTabBtn.Down then
    ShowAdvancedTextPreview(ScrollingTextDesignFilePathEdit.Text);
end;

procedure TMainForm.ShowAdvancedPicturePreview(const LFGFileName: String);
var
  PictureAvailable: Boolean;
begin
  ClearImage(PicturePreviewImage);
  if FileExists(LFGFileName) then
  begin
    if OpenLFGFile(LFGFileName, TextToLCDGrid) then
    begin
      LCDToBitmap(TextToLCDGrid, PicturePreviewImage.Picture.Bitmap, False);
      PictureAvailable := True;
    end
    else
      PictureAvailable := False;
  end
  else
    PictureAvailable := False;

  DisplayStages[ActiveDisplayStage].Areas[ActiveAreaIndex].PictureAvailable := PictureAvailable;

  if PictureAvailable then
    PicturePreviewImage.Show;

  PicturePreviewImage.Stretch := True;

  PictureWidthLabel.Caption := IntToStr(PicturePreviewImage.Picture.Bitmap.Width);
  PictureHeightLabel.Caption := IntToStr(PicturePreviewImage.Picture.Bitmap.Height);

  UpdatePicturePicturePreview;
end;

procedure TMainForm.RefreshAdvancedPicturePreviewBtnClick(Sender: TObject);
begin
  if (DisplayStages[ActiveDisplayStage].Areas[ActiveAreaIndex].ContentType = ctPicture) and
     AdvancedPictureTabBtn.Down then
  ShowAdvancedPicturePreview(PictureDesignFilePathEdit.Text);
end;

procedure TMainForm.ApplicationEvents1Activate(Sender: TObject);
begin
  MainForm.Invalidate;
  if not GlobalOptions.DontUseHighGUI then
  begin
    HighGUITimer.Tag := 1;  //Means Enabled
    HighGUITimer.Enabled := True;
  end;

  if (DisplayStages[ActiveDisplayStage].Areas[ActiveAreaIndex].ContentType = ctScrollingText) and
     SimpleTextTabBtn.Down then
    ShowFontSizeWarning(FontSizeWarningBtn1.Visible or FontSizeWarningTimer.Enabled);

  RefreshAdvancedTextPreviewBtn.Click;
  RefreshAdvancedPicturePreviewBtn.Click;

  MainForm.Repaint;
end;

procedure TMainForm.PictureContentPanelResize(Sender: TObject);
var
  Diff: Integer;
begin
  PictureDesignFilePathLabel.Caption := MinimizeName(PictureDesignFilePathEdit.Text, PictureDesignFilePathLabel.Canvas, PictureDesignFilePathLabel.Width);

  SelectDefaultPictureBtn.Left := Trunc(SimplePictureGroupBox.Width / 2 - SelectDefaultPictureBtn.Width / 2);

  Diff := ImportSMSPicBtn.Left - (ImportPictureBtn.Left + ImportPictureBtn.Width);
  ImportPictureBtn.Left := Trunc(SimplePictureGroupBox.Width / 2 - (ImportSMSPicBtn.Left + ImportSMSPicBtn.Width - ImportPictureBtn.Left) / 2);
  ImportSMSPicBtn.Left := ImportPictureBtn.Left + ImportPictureBtn.Width + Diff;
end;

procedure TMainForm.ScrollingTextContentPanelResize(Sender: TObject);
begin
  ScrollingTextDesignFilePathLabel.Caption := MinimizeName(ScrollingTextDesignFilePathEdit.Text, ScrollingTextDesignFilePathLabel.Canvas, ScrollingTextDesignFilePathLabel.Width);
end;

function TMainForm.GetSkinNumber: Integer;
var
  i: Integer;
begin
  Result := 0;
  for i := 1 to SKIN_COUNT do
    if sSkinManager1.SkinName = SkinNames[i] then
    begin
      Result := i;
      Break;
    end;
end;

procedure TMainForm.SetSkin(SkinNumber: Integer);
begin
  if (SkinNumber < 1) or (SkinNumber > SKIN_COUNT) then
    Exit;
  sSkinManager1.SkinName := SkinNames[SkinNumber];
end;

procedure TMainForm.BuildMusicMenu;
var
  FSR: TSearchRecW;
  i: Integer;
  MusicMenuItem: TTntMenuItem;
begin
  MusicFilesList := TTntStringList.Create;
  MusicFilesList.Sorted := True;

  //Get music list
  if WideFindFirst(ApplicationPath + MUSIC_FOLDER_NAME + '\*.*', faAnyFile, FSR) = 0 then
  begin
    repeat
      if ((FSR.Attr and faSysFile)=0) and
         ((FSR.Attr and faSymLink)=0) and
         ((FSR.Attr and faVolumeID)=0) then
      begin
        if ((FSR.Attr and faDirectory) = 0) and
           (FSR.Name[1] <> '.') then
        begin
          if (WideLowerCase(WideExtractFileExt(FSR.Name)) = '.mp3') or (WideLowerCase(WideExtractFileExt(FSR.Name)) = '.wav') then
            if WideFileExists(ApplicationPath + MUSIC_FOLDER_NAME + '\' + FSR.Name) then
              MusicFilesList.Append(ApplicationPath + MUSIC_FOLDER_NAME + '\' + FSR.Name);
        end;
      end;
    until WideFindNext(FSR) <> 0;
  end;
  WideFindClose(FSR);

  MusicBtn.Enabled := MusicFilesList.Count > 0;
  SelectMusicBtn.Enabled := MusicFilesList.Count > 0;

  for i := 0 to MusicFilesList.Count - 1 do
  begin
    MusicMenuItem := TTntMenuItem.Create(Self);
    MusicMenuItem.Caption := Copy(WideExtractFileName(MusicFilesList.Strings[i]), 1, Length(WideExtractFileName(MusicFilesList.Strings[i])) - Length(WideExtractFileExt(MusicFilesList.Strings[i])));
    MusicMenuItem.ImageIndex := 0;
    MusicMenuItem.Tag := i;
    MusicMenuItem.OnClick := MusicMenuItemClick;
    MusicMenuItem.RadioItem := True;
    MusicPopup.Items.Add(MusicMenuItem);
  end;
end;

procedure TMainForm.MusicMenuItemClick(Sender: TObject);
begin
  try
    MediaPlayer1.Notify := False;
    MediaPlayer1.Stop;
  except
  end;

  try
    MediaPlayer1.Notify := False;
    MediaPlayer1.Close;
  except
  end;

  MediaPlayer1.FileName := MusicFilesList.Strings[(Sender as TComponent).Tag];
  try
    MediaPlayer1.Wait := False;
    MediaPlayer1.Notify := False;
    MediaPlayer1.Open;
    MediaPlayer1.Play;
    (Sender as TTntMenuItem).Checked := True;

    if not MusicBtn.Down then
    begin
      MusicBtn.Down := True;
      SelectMusicBtn.Down := True;
    end;
  except
  end;
end;

procedure TMainForm.SelectMusicBtnClick(Sender: TObject);
begin
  TntXPMenu1.Active := not TntXPMenu1.Active;
  TntXPMenu1.Active := not TntXPMenu1.Active;

  SelectMusicBtn.Down := MusicBtn.Down;
  SpecialProcs.PopupMenuAtControl(SelectMusicBtn, MusicPopup);
end;

procedure TMainForm.MusicBtnClick(Sender: TObject);
begin
  SelectMusicBtn.Down := MusicBtn.Down;
  if MusicBtn.Down then
  begin
    try
      //MediaPlayer1.Notify := False;
      MediaPlayer1.Resume;
    except
    end;
  end
  else
  begin
    try
      //MediaPlayer1.Notify := False;  --> No need
      MediaPlayer1.Pause;
    except
    end;
  end;
end;

procedure TMainForm.WriteInstallDirRegistryEntry(WriteValues: Boolean);
const
  FirstRunRegEntry = 'FirstRun';
  InstallDirRegEntry = 'InstallDir';
var
  Reg: TRegistry;
  NewUser, FirstRun: Boolean;
begin
  if not License3.CheckLicenseStatus then
    Exit;

  NewUser := False;
  FirstRun := False;

  Reg := TRegistry.Create;//(KEY_READ);
  try
    Reg.RootKey := HKEY_CURRENT_USER;
    NewUser := not Reg.KeyExists(REG_USER_SETTINGS_PATH + '\Globals');
    if NewUser then
    begin
      //This user is a new user on this computer. Write InstallDir.
      NewUser := True;
//      Reg.Access := KEY_WRITE;
      if WriteValues then
      begin
        Reg.OpenKey('\' + REG_USER_SETTINGS_PATH + '\Globals', True);  //Absolute registry path
        Reg.WriteString(InstallDirRegEntry, ApplicationPath);
      end;
      Reg.CloseKey;
    end
    else
    begin

      if Reg.OpenKeyReadOnly(REG_USER_SETTINGS_PATH + '\Globals') then
      begin

        if Reg.ValueExists(FirstRunRegEntry) then
        begin
        //FirstRun exists. Check it and write InstallDir if FirstRun is True.
          if Reg.ReadBool(FirstRunRegEntry) then
          begin
            Reg.CloseKey;
            Reg.Access := KEY_WRITE;
            if Reg.OpenKey(REG_USER_SETTINGS_PATH + '\Globals', False) then
            begin
              if WriteValues then
              begin
                Reg.WriteBool(FirstRunRegEntry, False);
                Reg.WriteString(InstallDirRegEntry, ApplicationPath);
              end;
              Reg.CloseKey;
              FirstRun := True;
            end;
          end;
        end

        else if not Reg.ValueExists(InstallDirRegEntry) then
        begin
          //Nor FirstRun neither InstallDir exists. Write InstallDir.
          Reg.CloseKey;
          Reg.Access := KEY_WRITE;
          if Reg.OpenKey(REG_USER_SETTINGS_PATH + '\Globals', False) then
          begin
            if WriteValues then
              Reg.WriteString(InstallDirRegEntry, ApplicationPath);
            Reg.CloseKey;
          end;
        end

        else
          Reg.CloseKey;

      end;
    end;

    Reg.Free;

  except
    Reg.Free;
  end;

  RuntimeGlobalOptions.FirstUserRun := NewUser or FirstRun;
end;

procedure TMainForm.ApplyStartupAfterShowConfig;
begin
  Application.ShowHint := True;  //I don't know why it is automatically set to False!

  if RuntimeGlobalOptions.FirstUserRun then
  begin
    RuntimeGlobalOptions.FirstUserRun := False;

    ChangeLEDDisplaySettingsBtn.Click;
  end;
end;

procedure TMainForm.ApplyAfterShowConfigTimerTimer(Sender: TObject);
begin
  if fsShowing in Self.FormState then
    Exit;
  ApplyAfterShowConfigTimer.Enabled := False;
  ApplyStartupAfterShowConfig;
  HighGUITimer.Enabled := True;
end;

procedure TMainForm.ApplyStartupOnShowConfig;
begin
  if (GlobalOptions.LEDDisplaySettings.Color1 = '') and
     (GlobalOptions.LEDDisplaySettings.Color2 = '') then
  begin
    GlobalOptions.LEDDisplaySettings.Color1 := ChangeDisplaySettingsForm.ColorCombo1.Items.Strings[0];
    GlobalOptions.LEDDisplaySettings.Color2 := ChangeDisplaySettingsForm.ColorCombo2.Items.Strings[1];
  end;
  AllFontsCombo.OnChange(AllFontsCombo);
  FavoriteFontsCombo.OnChange(FavoriteFontsCombo);
end;

procedure TMainForm.SetLEDDisplayDateTime(LEDDisplayNumber: Integer);
var
  DateTimeData: TDataArray;
  dt: TDateTime;
  OperationOK: Boolean;
  y, m, d: Word;
  i: Integer;
  LEDDisplayConfiguration: TLEDDisplayConfiguration;
begin
  //************************************
  if not License4.CheckLicenseStatusFull then
    Halt;
  //************************************

  //----------------------------------------------------
  //Check if it is portable memory connected to the port
  if not ProgrammerForm.GetConfiguration(LEDDisplayConfiguration, LEDDisplayNumber) then
    Exit;
  if LEDDisplayConfiguration.PortableMemory then  //If it is portable memory, don't do anything - just show message and return.
  begin
    WideShowMessageSoundTop(Dyn_Texts[116] {'The device connected to the port is the portable memory and it has not date/time features. To set LED Display date and time using computer, you should connect it directly to the computer.'});
    Exit;
  end;
  //----------------------------------------------------

  //Now continue for setting date and time

  if not CommunicationWithLEDDisplayAllowed(True) then
    Exit;

  SetLength(DateTimeData, 3);

  Screen.Cursor := crHourGlass;
  OperationOK := False;

  /////////////////////////////////////////////////////////////////////////////
  if GlobalOptions.LEDDisplaySettings.Height > _LED_DISPLAY_MAX_ROW_COUNT_ then
    Halt;
  /////////////////////////////////////////////////////////////////////////////
  
  MainForm.Enabled := False;
  ProgressForm.Progress.MinValue := 0;
  ProgressForm.Progress.MaxValue := 4;  //4 steps (2 steps for setting time, 2 steps for setting date)
  ProgressForm.Progress.Progress := 0;
  ProgressForm.Caption := Dyn_Texts[115];  //'Setting the LED Display time and date'
  ProgressForm.Show;

  Application.ProcessMessages;

  try

  //Set time
  for i := 1 to NUMBER_OF_TIMES_TO_SET_TIME_AND_DATE do
  begin
    dt := Time;
    dt := IncSecond(dt, TIME_SETTING_COMPENSATION_VALUE);  //Add TIME_SETTING_COMPENSATION_VALUE seconds to compensate communication delay with LED Display
    DateTimeData[0] := HourOf(dt);  //Hour
    DateTimeData[1] := MinuteOf(dt);  //Minute
    DateTimeData[2] := SecondOf(dt);  //Second
    OperationOK := ProgrammerForm.SendData($01, DateTimeData, LEDDisplayNumber);  //Set Time Command Code = $01

    if not OperationOK then
      Exit;

    ProgressForm.Progress.Progress := ProgressForm.Progress.Progress + 1;
    Application.ProcessMessages;

    Procs.SleepNoBlock(USART_TIMEOUT_2);
  end;

  //Set date
  for i := 1 to NUMBER_OF_TIMES_TO_SET_TIME_AND_DATE do
  begin
    //Check date value to be valid for the LED Display (year between 1380 and 1499 in solar date system)
    dt := Date;
    y := YearOf(dt);
    m := MonthOf(dt);
    d := DayOf(dt);
    Procs.ChristianToSolar(y, m, d);
    if y < 1380 then  //Solar date must be greater than or equal to 1380
      y := 1380
    else if y > 1499 then  //Solar date must be less than or equal to 1499
      y := 1499;
    Procs.SolarToChristian(y, m, d);  //Convert back to christian date system

    //now generate date data
    SetLength(DateTimeData, 3);
    if y >= 2000 then
      DateTimeData[0] := y - 2000  //Year
    else
      DateTimeData[0] := 2000 - y;  //Year

    DateTimeData[1] := m;  //Month
    DateTimeData[2] := d;  //Day

    //and now, set the date of the LED Display
    OperationOK := OperationOK and
                   ProgrammerForm.SendData($02, DateTimeData, LEDDisplayNumber);  //Set Time Command Code = $02

    if OperationOK then
    begin
      ProgressForm.Progress.Progress := ProgressForm.Progress.Progress + 1;
      Application.ProcessMessages;
    end;
  end;

  finally

    Application.ProcessMessages;
    if ProgressForm.Progress.Progress = ProgressForm.Progress.MaxValue then  //If the progressbar is completely filled, wait some milliseconds for the user to see the filled progressbar
      Procs.SleepNoBlock(300);  //Allow the user to see that the progressbar is completely filled 100% (only when the progressbar is completely filled)

    Screen.Cursor := crDefault;
    SetLength(DateTimeData, 0);

    ProgressForm.Hide;
    MainForm.Enabled := True;

    Application.ProcessMessages;

    if OperationOK then
    begin
      LastChangeDisplayTickCount := GetTickCount;
      WideShowMessageSoundTop(Dyn_Texts[77] {'Time and date of the LED Display set to the current time and date.'});
    end;
  end;
end;

procedure TMainForm.ChangeLEDDisplayData(LEDDisplayNumber: Integer;
  OnlySaveToFile: Boolean; OnlyOpenFromFile: Boolean);
var
  fs: TFileStream;
  //Dummy: array[1..1] of Byte;
  //i: Integer;
  ProgramLEDDisplay: Boolean;
begin
  //************************************
  if not License2.CheckLicenseStatusFull then
    Halt;
  //************************************

  if not CommunicationWithLEDDisplayAllowed(True) then
    Exit;

  SaveAreaSettings(ActiveAreaIndex);
  if not GenerateAllData(Data) then
    Exit;
  if Length(Data) > (GlobalOptions.LEDDisplaySettings.Memory * 1024 - LED_DISPLAY_MEM_START_OFFSET) then
  begin
    WideShowMessageSoundTop(WideFormat(Dyn_Texts[1] {'Size of the display memory exceeded by %s bytes.'}, [IntToStr(Length(Data) - (GlobalOptions.LEDDisplaySettings.Memory * 1024 - LED_DISPLAY_MEM_START_OFFSET))]));
    SetLength(Data, 0);  //Free memory
    Exit;
  end;

  ProgramLEDDisplay := not(OnlySaveToFile or OnlyOpenFromFile);

  if OnlySaveToFile then
  begin
    if SaveDialog1.Execute then
    begin
      fs := TFileStream.Create(SaveDialog1.FileName, fmCreate);
      fs.WriteBuffer(Pointer(Data)^, Length(Data));

      //Dummy[1] := 255;
      //for i := Length(Data) + 1 to GlobalOptions.LEDDisplaySettings.Memory * 1024 do
      //  fs.WriteBuffer(Dummy, 1);

      fs.Free;
      ShowMessageBiDiSound('Data saved successfully.', bdLeftToRight);
    end;
  end;

  if OnlyOpenFromFile then
  begin
    ProgramLEDDisplay := OpenDialog1.Execute;
    if ProgramLEDDisplay then
    begin
      try
        fs := TFileStream.Create(OpenDialog1.FileName, fmOpenRead);
        SetLength(Data, fs.Size);
        fs.ReadBuffer(Pointer(Data)^, fs.Size);
        fs.Free;
        if Length(Data) = 0 then
        begin
          ShowMessageBiDiSoundTop('The specified file contains no data.', bdLeftToRight);
          ProgramLEDDisplay := False;
        end;
      except
        ShowMessageBiDiSound('Error loading the specified file.', bdLeftToRight);
        ProgramLEDDisplay := False;
      end;
      ProgramLEDDisplay := ProgramLEDDisplay and (MessageDlgBiDiSoundTop('Data loaded successfully from the file.' + #13 + 'Press OK to send it to the LED Display.' + #13 + 'Press Cancel to cancel.', mtConfirmation, mbOKCancel, 0, bdLeftToRight) = mrOk);
    end;
  end;

  if ProgramLEDDisplay then
  begin
    ProgrammerForm.LEDDisplayNumber := LEDDisplayNumber;
    ProgrammerForm.ShowModal;
  end;

  SetLength(Data, 0);  //Free memory
end;

procedure TMainForm.ChangeLEDDisplayDataMenuItem1Click(Sender: TObject);
begin
  ChangeLEDDisplayData(1, False, False);
end;

procedure TMainForm.ChangeLEDDisplayDataMenuItem2Click(Sender: TObject);
begin
  ChangeLEDDisplayData(2, False, False);
end;

procedure TMainForm.SetDateTimeMenuItem1Click(Sender: TObject);
begin
  SetLEDDisplayDateTime(1);
end;

procedure TMainForm.SetDateTimeMenuItem2Click(Sender: TObject);
begin
  SetLEDDisplayDateTime(2);
end;

function TMainForm.GetCOMPort(LEDDisplayNumber: Integer): TPortNumber;
begin
  Result := GlobalOptions.ComPort1;  //Load failsafe value
  case LEDDisplayNumber of
    1: Result := GlobalOptions.ComPort1;
    2: Result := GlobalOptions.ComPort2;
  end;
end;

procedure TMainForm.AddToFavoriteFontsBtnClick(Sender: TObject);
begin
  if FavoriteFontsCombo.Items.IndexOf(AllFontsCombo.Items.Strings[AllFontsCombo.ItemIndex]) < 0 then
  begin
    FavoriteFontsCombo.ItemIndex := FavoriteFontsCombo.Items.Add(AllFontsCombo.Items.Strings[AllFontsCombo.ItemIndex]);
    AddToFavoriteFontsBtn.Enabled := False;
    FavoriteFontsCombo.OnChange(FavoriteFontsCombo);  //Force an OnChange event
    RemoveFromFavoriteFontsBtn.Enabled := True;
    FavoriteFontsTabSheet.Tag := 1;
  end;
end;

procedure TMainForm.RemoveFromFavoriteFontsBtnClick(Sender: TObject);
var
  DelIndex: Integer;
begin
  if FavoriteFontsCombo.ItemIndex >= 0 then
  begin
    DelIndex := FavoriteFontsCombo.ItemIndex;
    FavoriteFontsCombo.Items.Delete(FavoriteFontsCombo.ItemIndex);
    if FavoriteFontsCombo.Items.Count > 0 then
    begin
      if DelIndex >= FavoriteFontsCombo.Items.Count then
        DelIndex := FavoriteFontsCombo.Items.Count - 1;
      FavoriteFontsCombo.ItemIndex := DelIndex;
      FavoriteFontsCombo.OnChange(FavoriteFontsCombo);  //Force an OnChange event
    end;
    RemoveFromFavoriteFontsBtn.Enabled := FavoriteFontsCombo.ItemIndex >= 0;
    AddToFavoriteFontsBtn.Enabled := not(FavoriteFontsCombo.Items.IndexOf(AllFontsCombo.Items.Strings[AllFontsCombo.ItemIndex]) >= 0);
  end;
  if FavoriteFontsCombo.Items.Count = 0 then
  begin
    FavoriteFontSamplePanel.Caption := '';
    //UpdateHxW(FavoriteFontSamplePanel.Font, FavHxWPanel, FavoriteFontSamplePanel.Caption);
  end;
  FavoriteFontsCombo.Refresh;
  //PrepareInsertTextButtons(SystemFontsSection.ActivePage);
end;

procedure TMainForm.DisableOtherContents(ContentType: TContentType);
var
  ct: TContentType;
begin
  for ct := Low(TContentType) to High(TContentType) do
    if ct <> ContentType then
      ContentControls[Ord(ct)].OptionsPage.Enabled := False;
end;

procedure TMainForm.SelectStagePanel(const Stage: TStage;
  ScrollToShow: Boolean);
begin
  Stage.StagePanel.Selected := True;
  
  RefreshStagePanelsAppearance;

  if ScrollToShow then
  begin
    if Stage.StagePanel.Left < 0 then
      AnimationLineScrollBox.HorzScrollBar.Position := Stage.StagePanel.Left
//    else if (Stage.StagePanel.Left + Stage.StagePanel.Width) > (AnimationLineScrollBox.HorzScrollBar.Position + AnimationLineScrollBox.Width) then
    else if (Stage.StagePanel.Left - AnimationLineScrollBox.HorzScrollBar.Position - AnimationLineScrollBox.Width) < 0 then
      AnimationLineScrollBox.HorzScrollBar.Position := Length(DisplayStages) * (Stage.StagePanel.Width + 10);//AnimationLineScrollBox.ClientWidth + Stage.StagePanel.Width; //Stage.StagePanel.Left + Stage.StagePanel.Width;
  end;
end;

procedure TMainForm.SetAlarmsBtnClick(Sender: TObject);
begin
  if not SetAlarmsBtn.Enabled then  //Prevent potential software bugd (--> Refer to compatibility mode settings)
    Exit;
  if not GlobalOptions.LEDDisplaySettings.CanSetAlarms then
    Exit;
  if GlobalOptions.LEDDisplaySettings.AlarmCount <= 0 then
    Exit;
  if not(GlobalOptions.LEDDisplaySettings.AlarmSystem in [Low(TAlarmSystem)..High(TAlarmSystem)]) then
    Exit;

  AlarmSettingsForm.ShowModal;
end;

procedure TMainForm.GeneralEditPopupMenuPopup(Sender: TObject);
begin
  GEPastePopupMenuItem.Enabled := Clipboard.HasFormat(CF_TEXT);
  if GeneralEditPopupMenu.PopupComponent is TCustomEdit then
  begin
    GECutPopupMenuItem.Enabled := (GeneralEditPopupMenu.PopupComponent as TCustomEdit).SelLength > 0;
    GECopyPopupMenuItem.Enabled := (GeneralEditPopupMenu.PopupComponent as TCustomEdit).SelLength > 0;
    if GeneralEditPopupMenu.PopupComponent is TEdit then
    begin
      GEPastePopupMenuItem.Enabled := GEPastePopupMenuItem.Enabled and not (GeneralEditPopupMenu.PopupComponent as TEdit).ReadOnly;
      GECutPopupMenuItem.Enabled := GECutPopupMenuItem.Enabled and not (GeneralEditPopupMenu.PopupComponent as TEdit).ReadOnly;
    end
    else if GeneralEditPopupMenu.PopupComponent is TMemo then
    begin
      GEPastePopupMenuItem.Enabled := GEPastePopupMenuItem.Enabled and not (GeneralEditPopupMenu.PopupComponent as TMemo).ReadOnly;
      GECutPopupMenuItem.Enabled := GECutPopupMenuItem.Enabled and not (GeneralEditPopupMenu.PopupComponent as TMemo).ReadOnly;
    end
    else if GeneralEditPopupMenu.PopupComponent is TTntMemo then
    begin
      GEPastePopupMenuItem.Enabled := GEPastePopupMenuItem.Enabled and not (GeneralEditPopupMenu.PopupComponent as TTntMemo).ReadOnly;
      GECutPopupMenuItem.Enabled := GECutPopupMenuItem.Enabled and not (GeneralEditPopupMenu.PopupComponent as TTntMemo).ReadOnly;
    end
    else if GeneralEditPopupMenu.PopupComponent is TTntEdit then
    begin
      GEPastePopupMenuItem.Enabled := GEPastePopupMenuItem.Enabled and not (GeneralEditPopupMenu.PopupComponent as TTntEdit).ReadOnly;
      GECutPopupMenuItem.Enabled := GECutPopupMenuItem.Enabled and not (GeneralEditPopupMenu.PopupComponent as TTntEdit).ReadOnly;
    end;
  end
  else if GeneralEditPopupMenu.PopupComponent is TCustomCombo then
  begin
    GECutPopupMenuItem.Enabled := (GeneralEditPopupMenu.PopupComponent as TCustomCombo).SelLength > 0;
    GECopyPopupMenuItem.Enabled := (GeneralEditPopupMenu.PopupComponent as TCustomCombo).SelLength > 0;
  end;
end;

procedure TMainForm.GECutPopupMenuItemClick(Sender: TObject);
begin
  if GeneralEditPopupMenu.PopupComponent is TWinControl then
    SendMessage((GeneralEditPopupMenu.PopupComponent as TWinControl).Handle, WM_CUT, 0, 0);
end;

procedure TMainForm.GECopyPopupMenuItemClick(Sender: TObject);
begin
  if GeneralEditPopupMenu.PopupComponent is TWinControl then
    SendMessage((GeneralEditPopupMenu.PopupComponent as TWinControl).Handle, WM_COPY, 0, 0);
end;

procedure TMainForm.GEPastePopupMenuItemClick(Sender: TObject);
begin
  if GeneralEditPopupMenu.PopupComponent is TWinControl then
    SendMessage((GeneralEditPopupMenu.PopupComponent as TWinControl).Handle, WM_PASTE, 0, 0);
end;

procedure TMainForm.CopyLEDDisplaySettings(const FromDS: TLEDDisplaySettings; var ToDSForFile: TLEDDisplaySettingsForFile);
begin
  ToDSForFile.Height                      := FromDS.Height;
  ToDSForFile.Width                       := FromDS.Width;
  ToDSForFile.Memory                      := FromDS.Memory;
  ToDSForFile.ColorCount                  := FromDS.ColorCount;
  //Color1 and Color2 are not available in TLEDDisplaySettingsForFile

  ToDSForFile.CanShowDateTime             := FromDS.CanShowDateTime;
  ToDSForFile.CanShowTemperature          := FromDS.CanShowTemperature;
  ToDSForFile.CanShowScrollingText        := FromDS.CanShowScrollingText;
  ToDSForFile.CanShowPicture              := FromDS.CanShowPicture;
  ToDSForFile.CanShowAnimation            := FromDS.CanShowAnimation;
  ToDSForFile.CanShowTextEffects          := FromDS.CanShowTextEffects;
  ToDSForFile.CanShowPageEffects          := FromDS.CanShowPageEffects;
  ToDSForFile.CanChangePageLayout         := FromDS.CanChangePageLayout;
  ToDSForFile.CanSetAlarms                := FromDS.CanSetAlarms;
  ToDSForFile.CanSetTimeSpan              := FromDS.CanSetTimeSpan;
  ToDSForFile.CanShowSWFFiles             := FromDS.CanShowSWFFiles;

  ToDSForFile.AlarmCount                  := FromDS.AlarmCount;
  ToDSForFile.AlarmSystem                 := FromDS.AlarmSystem;
end;

procedure TMainForm.CopyLEDDisplaySettings(const FromDSForFile: TLEDDisplaySettingsForFile; var ToDS: TLEDDisplaySettings);
begin
  ToDS.Height                      := FromDSForFile.Height;
  ToDS.Width                       := FromDSForFile.Width;
  ToDS.Memory                      := FromDSForFile.Memory;
  ToDS.ColorCount                  := FromDSForFile.ColorCount;
  //Color1 and Color2 are not available in TLEDDisplaySettingsForFile

  ToDS.CanShowDateTime             := FromDSForFile.CanShowDateTime;
  ToDS.CanShowTemperature          := FromDSForFile.CanShowTemperature;
  ToDS.CanShowScrollingText        := FromDSForFile.CanShowScrollingText;
  ToDS.CanShowPicture              := FromDSForFile.CanShowPicture;
  ToDS.CanShowAnimation            := FromDSForFile.CanShowAnimation;
  ToDS.CanShowTextEffects          := FromDSForFile.CanShowTextEffects;
  ToDS.CanShowPageEffects          := FromDSForFile.CanShowPageEffects;
  ToDS.CanChangePageLayout         := FromDSForFile.CanChangePageLayout;
  ToDS.CanSetAlarms                := FromDSForFile.CanSetAlarms;
  ToDS.CanSetTimeSpan              := FromDSForFile.CanSetTimeSpan;
  ToDS.CanShowSWFFiles             := FromDSForFile.CanShowSWFFiles;

  ToDS.AlarmCount                  := FromDSForFile.AlarmCount;
  ToDS.AlarmSystem                 := FromDSForFile.AlarmSystem;
end;

function TMainForm.OpenShowFromFile(const FName: WideString): Boolean;
  procedure LoadAndApplyFileInfo(var Stages: TStagesForFileArray;
    Strs: TTntStrings; const BitmapsFName: String);
  var
    i, j: Integer;
    TempFName: String;
    MainF, TempF: File of Byte;
    IntTemp: Integer;
    b: Byte;
    TempSize: LongWord;
  begin
    StartNewShow;

    TempFName := Procs.GenerateTemporaryFileName(Procs.GetTempFilesPath, TEMPORARY_FILES_PREFIX);

    AssignFile(MainF, BitmapsFName);
    AssignFile(TempF, TempFName);
    Reset(MainF);

    for i := 0 to High(Stages) do
    begin
      DisplayStages[i].TemporaryDisabled := Stages[i].TemporaryDisabled;
      DisplayStages[i].LayoutIndex := Stages[i].LayoutIndex;
      DisplayStages[i].CustomLayout := Stages[i].CustomLayout;
      DisplayStages[i].EntranceEffectID := Stages[i].EntranceEffectID;
      DisplayStages[i].ExitEffectID := Stages[i].ExitEffectID;
      DisplayStages[i].EffectSpeed := Stages[i].EffectSpeed;
      //Time Spam
      DisplayStages[i].HourFrom := Stages[i].HourFrom;
      DisplayStages[i].MinuteFrom := Stages[i].MinuteFrom;
      DisplayStages[i].HourTo := Stages[i].HourTo;
      DisplayStages[i].MinuteTo := Stages[i].MinuteTo;
      DisplayStages[i].OnlyDoNotShowDuringTimeSpan := Stages[i].OnlyDoNotShowDuringTimeSpan;
      DisplayStages[i].DisplayInSpecificDate := Stages[i].DisplayInSpecificDate;
      DisplayStages[i].Year := Stages[i].Year;
      DisplayStages[i].Month := Stages[i].Month;
      DisplayStages[i].Day := Stages[i].Day;

      for j := 1 to MAX_AREA_COUNT do
      begin
        DisplayStages[i].Areas[j].ScrollingText := Strs.Strings[i * 24 + (j - 1) * 6 + 0];
        DisplayStages[i].Areas[j].ScrollingTextFontSettings.FarsiLCDFontName := Strs.Strings[i * 24 + (j - 1) * 6 + 1];
        DisplayStages[i].Areas[j].ScrollingTextFontSettings.EnglishLCDFontName := Strs.Strings[i * 24 + (j - 1) * 6 + 2];
        DisplayStages[i].Areas[j].ScrollingTextLFGFileName := Strs.Strings[i * 24 + (j - 1) * 6 + 3];
        DisplayStages[i].Areas[j].PictureLFGFileName := Strs.Strings[i * 24 + (j - 1) * 6 + 4];
        DisplayStages[i].Areas[j].AnimationName := Strs.Strings[i * 24 + (j - 1) * 6 + 5];


        DisplayStages[i].Areas[j].x1 := Stages[i].Areas[j].x1;
        DisplayStages[i].Areas[j].y1 := Stages[i].Areas[j].y1;
        DisplayStages[i].Areas[j].x2 := Stages[i].Areas[j].x2;
        DisplayStages[i].Areas[j].y2 := Stages[i].Areas[j].y2;
        DisplayStages[i].Areas[j].SizeChangingMode := Stages[i].Areas[j].SizeChangingMode;
        DisplayStages[i].Areas[j].DelayTime := Stages[i].Areas[j].DelayTime;
        DisplayStages[i].Areas[j].ContinuesToNextStage := Stages[i].Areas[j].ContinuesToNextStage;
        DisplayStages[i].Areas[j].AdvanceStageWhenDone := Stages[i].Areas[j].AdvanceStageWhenDone;
        DisplayStages[i].Areas[j].ForceAdvanceStageWhenDone := Stages[i].Areas[j].ForceAdvanceStageWhenDone;
        DisplayStages[i].Areas[j].CompleteBeforeNextStage := Stages[i].Areas[j].CompleteBeforeNextStage;
        DisplayStages[i].Areas[j].RepeatAfterDone := Stages[i].Areas[j].RepeatAfterDone;
        DisplayStages[i].Areas[j].Color := Stages[i].Areas[j].Color;

        DisplayStages[i].Areas[j].ScrollingTextFontSettings.FontType := Stages[i].Areas[j].ScrollingTextFontSettings.FontType;
        DisplayStages[i].Areas[j].ScrollingTextFontSettings.SystemFontSettings := Stages[i].Areas[j].ScrollingTextFontSettings.SystemFontSettings;

        DisplayStages[i].Areas[j].PictureAvailable := Stages[i].Areas[j].PictureAvailable;
        //DisplayStages[i].Areas[j].PictureBitmap := Stages[i].Areas[j].PictureBitmap;
        //DisplayStages[i].Areas[j].SWFData := Stages[i].Areas[j].SWFData;
        DisplayStages[i].Areas[j].AnimSpeed := Stages[i].Areas[j].AnimSpeed;

        DisplayStages[i].Areas[j].TopBorder := Stages[i].Areas[j].TopBorder;
        DisplayStages[i].Areas[j].BottomBorder := Stages[i].Areas[j].BottomBorder;
        DisplayStages[i].Areas[j].LeftBorder := Stages[i].Areas[j].LeftBorder;
        DisplayStages[i].Areas[j].RightBorder := Stages[i].Areas[j].RightBorder;
        DisplayStages[i].Areas[j].BorderWidthHorizontal := Stages[i].Areas[j].BorderWidthHorizontal;
        DisplayStages[i].Areas[j].BorderWidthVertical := Stages[i].Areas[j].BorderWidthVertical;
        DisplayStages[i].Areas[j].BordersFilled := Stages[i].Areas[j].BordersFilled;

        DisplayStages[i].Areas[j].ContentType := Stages[i].Areas[j].ContentType;

        if (Stages[i].Areas[j].ContentType <> ctPicture) and
           (Stages[i].Areas[j].ContentType <> ctSWF) then
        begin
          //Advance 4 bytes (4 bytes for the size of the bitmap which here must be 0)
          Read(MainF, b);
          Read(MainF, b);
          Read(MainF, b);
          Read(MainF, b);
        end;
        
        case Stages[i].Areas[j].ContentType of
          ctTime:
            begin
              DisplayStages[i].Areas[j].TimeLanguage := Stages[i].Areas[j].TimeLanguage;
              DisplayStages[i].Areas[j].ClockFormat := Stages[i].Areas[j].ClockFormat;
              DisplayStages[i].Areas[j].ClockType := Stages[i].Areas[j].ClockType;
              DisplayStages[i].Areas[j].ClockTotalDisplayTime := Stages[i].Areas[j].ClockTotalDisplayTime;
              DisplayStages[i].Areas[j].PutClockAtCenter := Stages[i].Areas[j].PutClockAtCenter;
              DisplayStages[i].Areas[j].ClockDotsBlink := Stages[i].Areas[j].ClockDotsBlink;
            end;
          ctDate:
            begin
              DisplayStages[i].Areas[j].DateLanguage := Stages[i].Areas[j].DateLanguage;
              DisplayStages[i].Areas[j].DateFormat := Stages[i].Areas[j].DateFormat;
              DisplayStages[i].Areas[j].DateType := Stages[i].Areas[j].DateType;
              DisplayStages[i].Areas[j].DateTotalDisplayTime := Stages[i].Areas[j].DateTotalDisplayTime;
              DisplayStages[i].Areas[j].PutDateAtCenter := Stages[i].Areas[j].PutDateAtCenter;
            end;
          ctScrollingText:
            begin
              DisplayStages[i].Areas[j].FixedText := Stages[i].Areas[j].FixedText;
              DisplayStages[i].Areas[j].TextLanguage := Stages[i].Areas[j].TextLanguage;
              DisplayStages[i].Areas[j].TextDirection := Stages[i].Areas[j].TextDirection;
              DisplayStages[i].Areas[j].TextScrollType := Stages[i].Areas[j].TextScrollType;
              DisplayStages[i].Areas[j].TextScrollSpeed := Stages[i].Areas[j].TextScrollSpeed;
              DisplayStages[i].Areas[j].InvertScrollingText := Stages[i].Areas[j].InvertScrollingText;
              DisplayStages[i].Areas[j].TextEntranceAnimID := Stages[i].Areas[j].TextEntranceAnimID;
              DisplayStages[i].Areas[j].TextTimingStyle := Stages[i].Areas[j].TextTimingStyle;
              DisplayStages[i].Areas[j].TextRepetitionTimes := Stages[i].Areas[j].TextRepetitionTimes;
              DisplayStages[i].Areas[j].TextTotalDisplayTime := Stages[i].Areas[j].TextTotalDisplayTime;
              DisplayStages[i].Areas[j].ScrollingTextType := Stages[i].Areas[j].ScrollingTextType;
              DisplayStages[i].Areas[j].SystemFontFromFavoriteFonts := Stages[i].Areas[j].SystemFontFromFavoriteFonts;
            end;
          ctSWF:
            begin
              DisplayStages[i].Areas[j].SWFPlaySpeed := Stages[i].Areas[j].SWFPlaySpeed;
              DisplayStages[i].Areas[j].SWFTimingStyle := Stages[i].Areas[j].SWFTimingStyle;
              DisplayStages[i].Areas[j].SWFRepetitionTimes := Stages[i].Areas[j].SWFRepetitionTimes;
              DisplayStages[i].Areas[j].SWFTotalDisplayTime := Stages[i].Areas[j].SWFTotalDisplayTime;
              DisplayStages[i].Areas[j].InvertSWF := Stages[i].Areas[j].InvertSWF;
              DisplayStages[i].Areas[j].PutSWFAtCenter := Stages[i].Areas[j].PutSWFAtCenter;
              DisplayStages[i].Areas[j].UseSWFTimings := Stages[i].Areas[j].UseSWFTimings;
              DisplayStages[i].Areas[j].SWFSensitivity := Stages[i].Areas[j].SWFSensitivity;
              //SWFData
              //Read size of swf data (in bytes)
              TempSize := 0;
              Read(MainF, b); TempSize := TempSize or (LongWord(b) shl 0);  //lowest byte
              Read(MainF, b); TempSize := TempSize or (LongWord(b) shl 8);
              Read(MainF, b); TempSize := TempSize or (LongWord(b) shl 16);
              Read(MainF, b); TempSize := TempSize or (LongWord(b) shl 24);  //highest byte
              //Save swf data to a separate file
              Rewrite(TempF);
              for IntTemp := 1 to TempSize do
              begin
                Read(MainF, b);
                Write(TempF, b);
              end;
              CloseFile(TempF);

              DisplayStages[i].Areas[j].SWFData.LoadFromFile(TempFName);  //SWFData is already created as a TMemoryStream object and is not nil
            end;
          ctAnimation:
            begin
              DisplayStages[i].Areas[j].AnimationIndex := Stages[i].Areas[j].AnimationIndex;  //AnimationIndex is not used anymore
              DisplayStages[i].Areas[j].AnimationPlaySpeed := Stages[i].Areas[j].AnimationPlaySpeed;
              DisplayStages[i].Areas[j].AnimationTimingStyle := Stages[i].Areas[j].AnimationTimingStyle;
              DisplayStages[i].Areas[j].AnimationRepetitionTimes := Stages[i].Areas[j].AnimationRepetitionTimes;
              DisplayStages[i].Areas[j].AnimationTotalDisplayTime := Stages[i].Areas[j].AnimationTotalDisplayTime;
              DisplayStages[i].Areas[j].InvertAnimation := Stages[i].Areas[j].InvertAnimation;
              DisplayStages[i].Areas[j].PutAnimationAtCenter := Stages[i].Areas[j].PutAnimationAtCenter;
              DisplayStages[i].Areas[j].UseGIFTimings := Stages[i].Areas[j].UseGIFTimings;
            end;
          ctPicture:
            begin
              //Read size of the bitmap (in bytes)
              TempSize := 0;
              Read(MainF, b); TempSize := TempSize or (LongWord(b) shl 0);  //lowest byte
              Read(MainF, b); TempSize := TempSize or (LongWord(b) shl 8);
              Read(MainF, b); TempSize := TempSize or (LongWord(b) shl 16);
              Read(MainF, b); TempSize := TempSize or (LongWord(b) shl 24);  //highest byte

              //Save bitmap data to a separate file
              if Stages[i].Areas[j].PictureAvailable then
              begin
                Rewrite(TempF);
                for IntTemp := 1 to TempSize do
                begin
                  Read(MainF, b);
                  Write(TempF, b);
                end;
                CloseFile(TempF);

                DisplayStages[i].Areas[j].PictureBitmap.LoadFromFile(TempFName);  //PictureBitmat is already created as a TBitmap object and is not nil
              end;

              DisplayStages[i].Areas[j].ScrollingPicture := Stages[i].Areas[j].ScrollingPicture;
              DisplayStages[i].Areas[j].PictureTimingStyle := Stages[i].Areas[j].PictureTimingStyle;
              DisplayStages[i].Areas[j].PictureRepetitionTimes := Stages[i].Areas[j].PictureRepetitionTimes;
              DisplayStages[i].Areas[j].PictureTotalDisplayTime := Stages[i].Areas[j].PictureTotalDisplayTime;
              DisplayStages[i].Areas[j].InvertPicture := Stages[i].Areas[j].InvertPicture;
              DisplayStages[i].Areas[j].PictureEntranceAnimID := Stages[i].Areas[j].PictureEntranceAnimID;
              DisplayStages[i].Areas[j].PictureTextDirection := Stages[i].Areas[j].PictureTextDirection;
              DisplayStages[i].Areas[j].PictureTextScrollType := Stages[i].Areas[j].PictureTextScrollType;
              DisplayStages[i].Areas[j].PictureTextScrollSpeed := Stages[i].Areas[j].PictureTextScrollSpeed;
              DisplayStages[i].Areas[j].PictureSource := Stages[i].Areas[j].PictureSource;
            end;
          ctTemperature:
            begin
              DisplayStages[i].Areas[j].TemperatureLanguage := Stages[i].Areas[j].TemperatureLanguage;
              DisplayStages[i].Areas[j].TemperatureUnit := Stages[i].Areas[j].TemperatureUnit;
              DisplayStages[i].Areas[j].TemperatureTotalDisplayTime := Stages[i].Areas[j].TemperatureTotalDisplayTime;
              DisplayStages[i].Areas[j].PutTemperatureAtCenter := Stages[i].Areas[j].PutTemperatureAtCenter;
            end;
          ctEmpty:
            begin
              DisplayStages[i].Areas[j].EmptyAreaFilled := Stages[i].Areas[j].EmptyAreaFilled;
              DisplayStages[i].Areas[j].EmptyAreaTotalDisplayTime := Stages[i].Areas[j].EmptyAreaTotalDisplayTime;
            end;
        end;
      end;

      if i < High(Stages) then
        NewStage(False, -2, False);
    end;

    CloseFile(MainF);
    DeleteFile(TempFName);

    SelectStage(0, True, False);
  end;

const
  INFO_LINES_PREFIX = '     ';
var
  i: Integer;
  F: file of TStageForFile;
  F2, F3, F4: file of Byte;
  Strs: TTntStringList;
  Stages: TStagesForFileArray;
  TempFName1, TempFName2: String;
  NonUnicodeTempFName: String;
  b: Byte;
  S: String;
  FileSignature: String;

  SettingsMatch: Boolean;
  OldLEDDisplaySettings1, OldLEDDisplaySettings2: TLEDDisplaySettings;
  OldUsingTemporaryLEDDisplaySettings: Boolean;
  LEDDisplaySettingsChanged1, LEDDisplaySettingsChanged2: Boolean;

  HasStr: WideString;
  DoesNotHaveStr: WideString;

  BitmapsNonUnicodeTempFileName: String;
  StageIndex, AreaIndex: Integer;

  TempSize: LongWord;
  IntTemp: Integer;

  procedure TransferNBytesFromF2ToF4(NumOfBytes: Integer);
  var
    i: Integer;
    ByteTemp: Byte;
  begin
    for i := 1 to NumOfBytes do
    begin
      Read(F2, ByteTemp);
      Write(F4, ByteTemp);
    end;
  end;

begin
  Result := False;

  try

  LEDDisplaySettingsChanged1 := False;
  LEDDisplaySettingsChanged2 := False;
  OldUsingTemporaryLEDDisplaySettings := RuntimeGlobalOptions.UsingTemporaryLEDDisplaySettings;
  OldLEDDisplaySettings1 := GlobalOptions.LEDDisplaySettings;
  OldLEDDisplaySettings2 := RuntimeGlobalOptions.OriginalLEDDisplaySettings;

  NonUnicodeTempFName := Procs.GenerateTemporaryFileName(Procs.GetTempFilesPath, TEMPORARY_FILES_PREFIX);
  TempFName1 := Procs.GenerateTemporaryFileName(Procs.GetTempFilesPath, TEMPORARY_FILES_PREFIX);
  TempFName2 := Procs.GenerateTemporaryFileName(Procs.GetTempFilesPath, TEMPORARY_FILES_PREFIX);
  BitmapsNonUnicodeTempFileName := Procs.GenerateTemporaryFileName(Procs.GetTempFilesPath, TEMPORARY_FILES_PREFIX);

  Procs.WideFileCopy(FName, NonUnicodeTempFName);

  AssignFile(F2, NonUnicodeTempFName);
  AssignFile(F3, TempFName1);
  Reset(F2);
  Rewrite(F3);
  S := LDC_FILE_SIGNATURE;
  FileSignature := '';

  i := 0;
  while not eof(F2) and (i < Length(S)) do
  begin
    Read(F2, b);
    FileSignature := FileSignature + Chr(b);
    Inc(i);
  end;
  while not eof(F2) do
  begin
    Read(F2, b);
    Write(F3, b);
  end;
  CloseFile(F2);
  CloseFile(F3);

  if FileSignature <> LDC_FILE_SIGNATURE then
  begin
    try
      DeleteFile(TempFName1);
      DeleteFile(TempFName2);
      DeleteFile(NonUnicodeTempFName);
      DeleteFile(BitmapsNonUnicodeTempFileName);
    except
    end;
    WideMessageDlgSoundTop(WideFormat(Dyn_Texts[80] {'The file%sis either corrupted or for newer versions of LED Display Control and cannot be opened in this version.'}, [#13 + FName + #13]), mtInformation, [mbOK], 0);
    Exit;
  end;

  Strs := TTntStringList.Create;
  Strs.Sorted := False;
  SetLength(Stages, 1);

  AssignFile(F, TempFName1);
  Reset(F);
  Read(F, Stages[0]);

  if (Stages[0].StageCount > 255) or (Stages[0].StageCount = 0) then
  begin
    CloseFile(F);
    Strs.Free;
    try
      DeleteFile(TempFName1);
      DeleteFile(TempFName2);
      DeleteFile(NonUnicodeTempFName);
      DeleteFile(BitmapsNonUnicodeTempFileName);
    except
    end;
    WideMessageDlgSoundTop(WideFormat(Dyn_Texts[98] {'The file%sis corrupted and cannot be opened.'}, [#13 + FName + #13]), mtError, [mbOK], 0);
    Exit;
  end;

  SetLength(Stages, Stages[0].StageCount);

  for i := 1 to High(Stages) do  //First stage is already read
  begin
    Read(F, Stages[i]);
  end;
  CloseFile(F);

  AssignFile(F2, TempFName1);
  AssignFile(F3, TempFName2);
  Reset(F2);
  Rewrite(F3);
  Seek(F2, Length(Stages) * SizeOf(TStageForFile));
  while not eof(F2) do
  begin
    Read(F2, b);
    Write(F3, b);
  end;
  CloseFile(F2);
  CloseFile(F3);

  //Now TempFName2 contains bitmaps and strs data
  AssignFile(F2, TempFName2);
  AssignFile(F3, TempFName1);  //TempFName1 will contain strs data
  AssignFile(F4, BitmapsNonUnicodeTempFileName);  //BitmapsNonUnicodeTempFileName will contain bitmaps data
  Reset(F2);
  Rewrite(F3);
  Rewrite(F4);

  //Save bitmaps data and swf data
  for StageIndex := 0 to High(Stages) do
  begin
    for AreaIndex := 1 to MAX_AREA_COUNT do
    begin
      if (Stages[StageIndex].Areas[AreaIndex].ContentType <> ctPicture) and
         (Stages[StageIndex].Areas[AreaIndex].ContentType <> ctSWF) then
      begin
        //Advance 4 bytes (4 bytes for the size of the bitmap or swf data which here must be 0)
        TransferNBytesFromF2ToF4(4);
      end
      else
      begin
        //Read size of the data (bitmap or swf) (in bytes)
        TempSize := 0;
        Read(F2, b); TempSize := TempSize or (LongWord(b) shl 0);  //lowest byte
        Write(F4, b);
        Read(F2, b); TempSize := TempSize or (LongWord(b) shl 8);
        Write(F4, b);
        Read(F2, b); TempSize := TempSize or (LongWord(b) shl 16);
        Write(F4, b);
        Read(F2, b); TempSize := TempSize or (LongWord(b) shl 24);  //highest byte
        Write(F4, b);
      end;
      
      case Stages[StageIndex].Areas[AreaIndex].ContentType of
        ctTime: ;
        ctDate: ;
        ctScrollingText: ;
        ctSWF:
          begin
            //Read and skip TempSize bytes as swf data
            TransferNBytesFromF2ToF4(TempSize);
          end;
        ctAnimation: ;
        ctPicture:
          begin
            //Read and skip TempSize bytes as bitmap data
            TransferNBytesFromF2ToF4(TempSize);
          end;
        ctTemperature: ;
        ctEmpty: ;
      end;
    end;
  end;
  CloseFile(F4);  //Bitmaps data done and saved to BitmapsNonUnicodeTempFileName successfully
  //Now save strs data
  while not eof(F2) do
  begin
    Read(F2, b);
    Write(F3, b);
  end;
  CloseFile(F3);  //Strs data done and saved to TempFName1 successfully
  CloseFile(F2);

  Strs.LoadFromFile(TempFName1);

  DeleteFile(TempFName1);
  DeleteFile(TempFName2);
  DeleteFile(NonUnicodeTempFName);
  //BitmapsNonUnicodeTempFileName is needed in the next stages in this function and must not be deleted

  if Stages[0].LEDDisplaySettings.Height > _LED_DISPLAY_MAX_ROW_COUNT_ then
  begin
    WideMessageDlgSoundTop(Dyn_Texts[125] {'The LED Display size for this file is greater than the size of the LED Display supported with your version of LED Display Control and cannot be used.'}, mtError, [mbOK], 0);
    SetLength(Stages, 0);
    Strs.Free;
    DeleteFile(BitmapsNonUnicodeTempFileName);
    Exit;
  end;

  if not ValidateStagesData(Stages) or not ValidateLEDDisplaySettings(Stages[0].LEDDisplaySettings) then
  begin
    if WideMessageDlgSoundTop(WideFormat(Dyn_Texts[124] {'The file%sis corrupted and cannot be opened. Do you want to open it anyway?'}, [#13 + FName + #13]), mtError, [mbYes, mbNo], 0) = mrNo then
    begin
      SetLength(Stages, 0);
      Strs.Free;
      DeleteFile(BitmapsNonUnicodeTempFileName);
      Exit;
    end;
  end;

  {$HINTS OFF}  //Do not produce compiler hint 'Value assigned never used'
  SettingsMatch := True;  //Prevent potential software bugs
  {$HINTS ON}  //Enable compiler hints generation
  if RuntimeGlobalOptions.UsingTemporaryLEDDisplaySettings then
  begin
    SettingsMatch := DisplaySettingsEqual(RuntimeGlobalOptions.OriginalLEDDisplaySettings, Stages[0].LEDDisplaySettings, False);
  end
  else
  begin
    SettingsMatch := DisplaySettingsEqual(GlobalOptions.LEDDisplaySettings, Stages[0].LEDDisplaySettings, False)
  end;

  if not SettingsMatch then
  begin
    //Select appropriate message strings from the resource strings
    HasStr := Dyn_Texts[84];  //Has
    DoesNotHaveStr := Dyn_Texts[85];  //Does not have

    if WideMessageDlgSoundTop(WideFormat(Dyn_Texts[83] {'Settings do not match. Use temporary settings?'},
                              [#13 + INFO_LINES_PREFIX,
                               IntToStr(Stages[0].LEDDisplaySettings.Height) + #13 + INFO_LINES_PREFIX,
                               IntToStr(Stages[0].LEDDisplaySettings.Width) + #13 + INFO_LINES_PREFIX,
                               IntToStr(IfThen(Stages[0].LEDDisplaySettings.ColorCount = 2, 3, Stages[0].LEDDisplaySettings.ColorCount)) + #13 + INFO_LINES_PREFIX,
                               Procs.IfThenW(Stages[0].LEDDisplaySettings.CanShowDateTime, HasStr, DoesNotHaveStr) + #13 + INFO_LINES_PREFIX,
                               Procs.IfThenW(Stages[0].LEDDisplaySettings.CanShowTemperature, HasStr, DoesNotHaveStr) + #13 + INFO_LINES_PREFIX,
                               Procs.IfThenW(Stages[0].LEDDisplaySettings.CanShowScrollingText, HasStr, DoesNotHaveStr) + #13 + INFO_LINES_PREFIX,
                               Procs.IfThenW(Stages[0].LEDDisplaySettings.CanShowPicture, HasStr, DoesNotHaveStr) + #13 + INFO_LINES_PREFIX,
                               Procs.IfThenW(Stages[0].LEDDisplaySettings.CanShowAnimation, HasStr, DoesNotHaveStr) + #13 + INFO_LINES_PREFIX,
                               Procs.IfThenW(Stages[0].LEDDisplaySettings.CanShowTextEffects, HasStr, DoesNotHaveStr) + #13 + INFO_LINES_PREFIX,
                               Procs.IfThenW(Stages[0].LEDDisplaySettings.CanShowPageEffects, HasStr, DoesNotHaveStr) + #13 + INFO_LINES_PREFIX,
                               Procs.IfThenW(Stages[0].LEDDisplaySettings.CanChangePageLayout, HasStr, DoesNotHaveStr) + #13 + INFO_LINES_PREFIX,
                               Procs.IfThenW(Stages[0].LEDDisplaySettings.CanSetTimeSpan, HasStr, DoesNotHaveStr) + #13 + INFO_LINES_PREFIX,
                               Procs.IfThenW(Stages[0].LEDDisplaySettings.CanSetAlarms, HasStr, DoesNotHaveStr) + #13 + INFO_LINES_PREFIX,
                               IntToStr(IfThen(Stages[0].LEDDisplaySettings.CanSetAlarms, Stages[0].LEDDisplaySettings.AlarmCount, 0)) +
                                 Procs.IfThenW(Stages[0].LEDDisplaySettings.CanSetAlarms and (Stages[0].LEDDisplaySettings.AlarmSystem = as12MonthAlarmSystem), WideString(' - ') + Dyn_Texts[107] {'12-Month Alarm System'}, '') + #13,
                               #13#13]), mtConfirmation, [mbYes, mbNo], 0) = mrNo then
    begin
      SetLength(Stages, 0);
      Strs.Free;
      DeleteFile(BitmapsNonUnicodeTempFileName);
      Exit;
    end;
    if not RuntimeGlobalOptions.UsingTemporaryLEDDisplaySettings then
    begin
      RuntimeGlobalOptions.OriginalLEDDisplaySettings := GlobalOptions.LEDDisplaySettings;
      RuntimeGlobalOptions.UsingTemporaryLEDDisplaySettings := True;
    end;

    CopyLEDDisplaySettings(Stages[0].LEDDisplaySettings, GlobalOptions.LEDDisplaySettings);

    LEDDisplaySettingsChanged1 := True;

    OnLEDDisplaySettingsChanged;
    UpdateLEDDisplayInfo;
  end
  else
  begin
    if RuntimeGlobalOptions.UsingTemporaryLEDDisplaySettings then
    begin
      GlobalOptions.LEDDisplaySettings := RuntimeGlobalOptions.OriginalLEDDisplaySettings;
      RuntimeGlobalOptions.UsingTemporaryLEDDisplaySettings := False;

      LEDDisplaySettingsChanged2 := True;

      OnLEDDisplaySettingsChanged;
      UpdateLEDDisplayInfo;
    end;
  end;
  TemporaryLEDDisplaySettingsMode(RuntimeGlobalOptions.UsingTemporaryLEDDisplaySettings);

  LoadAndApplyFileInfo(Stages, Strs, BitmapsNonUnicodeTempFileName);

  SetLength(Stages, 0);
  Strs.Free;
  DeleteFile(BitmapsNonUnicodeTempFileName);  //BitmapsNonUnicodeTempFileName is not needed anymore

  except
    if LEDDisplaySettingsChanged1 then
    begin
      RuntimeGlobalOptions.UsingTemporaryLEDDisplaySettings := OldUsingTemporaryLEDDisplaySettings;
      GlobalOptions.LEDDisplaySettings := OldLEDDisplaySettings1;
      OnLEDDisplaySettingsChanged;
      UpdateLEDDisplayInfo;
    end
    else if LEDDisplaySettingsChanged2 then
    begin
      RuntimeGlobalOptions.UsingTemporaryLEDDisplaySettings := True;
      GlobalOptions.LEDDisplaySettings := OldLEDDisplaySettings1;
      RuntimeGlobalOptions.OriginalLEDDisplaySettings := OldLEDDisplaySettings2;
      OnLEDDisplaySettingsChanged;
      UpdateLEDDisplayInfo;
    end;
    TemporaryLEDDisplaySettingsMode(RuntimeGlobalOptions.UsingTemporaryLEDDisplaySettings);

    WideMessageDlgSoundTop(WideFormat(Dyn_Texts[64] {'Unable to open the presentation file ''%s''.'}, [FName]), mtError, [mbOK], 0);
    Exit;
  end;
  Result := True;
end;

function TMainForm.SaveShowToFile(const FName: WideString): Boolean;
  procedure CollectFileInfo(var Stages: TStagesForFileArray;
    Strs: TTntStrings; var BitmapsFName: String);
  var
    i, j: Integer;
    k: Integer;
    BMPTempFName: String;
    TempFName: String;
    MainF, TempF: File of Byte;
    IntTemp: Integer;
    b: Byte;
    TempSize: LongWord;
  begin
    SetLength(Stages, Length(DisplayStages));
    Strs.Clear;

    BMPTempFName := Procs.GenerateTemporaryFileName(Procs.GetTempFilesPath, TEMPORARY_FILES_PREFIX);
    TempFName := Procs.GenerateTemporaryFileName(Procs.GetTempFilesPath, TEMPORARY_FILES_PREFIX);

    BitmapsFName := BMPTempFName;  //procedure result (filename of the file storing bitmaps data)
    AssignFile(MainF, BMPTempFName);
    Rewrite(MainF);
    
    AssignFile(TempF, TempFName);

    for i := 0 to High(Stages) do
    begin
      //----------------------------------------------------
      //----------------------------------------------------
      //Set reserved bytes to 0
      for k := 1 to DISPLAY_SETTINGS_RESERVED_BYTES_COUNT do
        Stages[i].LEDDisplaySettings.ReservedBytes[k] := 0;
      for k := 1 to STAGE_RESERVED_BYTES_COUNT do
        Stages[i].ReservedBytes[k] := 0;
      //----------------------------------------------------
      //----------------------------------------------------

      CopyLEDDisplaySettings(GlobalOptions.LEDDisplaySettings, Stages[i].LEDDisplaySettings);

      Stages[i].StageCount := Length(Stages);

      Stages[i].TemporaryDisabled := DisplayStages[i].TemporaryDisabled;
      Stages[i].LayoutIndex := DisplayStages[i].LayoutIndex;
      Stages[i].CustomLayout := DisplayStages[i].CustomLayout;
      Stages[i].EntranceEffectID := DisplayStages[i].EntranceEffectID;
      Stages[i].ExitEffectID := DisplayStages[i].ExitEffectID;
      Stages[i].EffectSpeed := DisplayStages[i].EffectSpeed;
      //Time Span
      Stages[i].HourFrom := DisplayStages[i].HourFrom;
      Stages[i].MinuteFrom := DisplayStages[i].MinuteFrom;
      Stages[i].HourTo := DisplayStages[i].HourTo;
      Stages[i].MinuteTo := DisplayStages[i].MinuteTo;
      Stages[i].OnlyDoNotShowDuringTimeSpan := DisplayStages[i].OnlyDoNotShowDuringTimeSpan;
      Stages[i].DisplayInSpecificDate := DisplayStages[i].DisplayInSpecificDate;
      Stages[i].Year := DisplayStages[i].Year;
      Stages[i].Month := DisplayStages[i].Month;
      Stages[i].Day := DisplayStages[i].Day;

      for j := 1 to MAX_AREA_COUNT do
      begin
        //----------------------------------------------------
        //----------------------------------------------------
        //Set reserved bytes to 0
        for k := 1 to AREA_RESERVED_BYTES_COUNT do
          Stages[i].Areas[j].ReservedBytes[k] := 0;
        //----------------------------------------------------
        //----------------------------------------------------

        Strs.Append(DisplayStages[i].Areas[j].ScrollingText);
        Strs.Append(DisplayStages[i].Areas[j].ScrollingTextFontSettings.FarsiLCDFontName);
        Strs.Append(DisplayStages[i].Areas[j].ScrollingTextFontSettings.EnglishLCDFontName);
        Strs.Append(DisplayStages[i].Areas[j].ScrollingTextLFGFileName);
        Strs.Append(DisplayStages[i].Areas[j].PictureLFGFileName);
        Strs.Append(DisplayStages[i].Areas[j].AnimationName);

        Stages[i].Areas[j].x1 := DisplayStages[i].Areas[j].x1;
        Stages[i].Areas[j].y1 := DisplayStages[i].Areas[j].y1;
        Stages[i].Areas[j].x2 := DisplayStages[i].Areas[j].x2;
        Stages[i].Areas[j].y2 := DisplayStages[i].Areas[j].y2;
        Stages[i].Areas[j].SizeChangingMode := DisplayStages[i].Areas[j].SizeChangingMode;
        Stages[i].Areas[j].DelayTime := DisplayStages[i].Areas[j].DelayTime;
        Stages[i].Areas[j].ContinuesToNextStage := DisplayStages[i].Areas[j].ContinuesToNextStage;
        Stages[i].Areas[j].AdvanceStageWhenDone := DisplayStages[i].Areas[j].AdvanceStageWhenDone;
        Stages[i].Areas[j].ForceAdvanceStageWhenDone := DisplayStages[i].Areas[j].ForceAdvanceStageWhenDone;
        Stages[i].Areas[j].CompleteBeforeNextStage := DisplayStages[i].Areas[j].CompleteBeforeNextStage;
        Stages[i].Areas[j].RepeatAfterDone := DisplayStages[i].Areas[j].RepeatAfterDone;
        Stages[i].Areas[j].Color := DisplayStages[i].Areas[j].Color;

        Stages[i].Areas[j].ScrollingTextFontSettings.FontType := DisplayStages[i].Areas[j].ScrollingTextFontSettings.FontType;
        Stages[i].Areas[j].ScrollingTextFontSettings.SystemFontSettings := DisplayStages[i].Areas[j].ScrollingTextFontSettings.SystemFontSettings;

        Stages[i].Areas[j].PictureAvailable := DisplayStages[i].Areas[j].PictureAvailable;
        Stages[i].Areas[j].PictureBitmap := DisplayStages[i].Areas[j].PictureBitmap;
        Stages[i].Areas[j].SWFData := DisplayStages[i].Areas[j].SWFData;
        Stages[i].Areas[j].AnimSpeed := DisplayStages[i].Areas[j].AnimSpeed;

        Stages[i].Areas[j].TopBorder := DisplayStages[i].Areas[j].TopBorder;
        Stages[i].Areas[j].BottomBorder := DisplayStages[i].Areas[j].BottomBorder;
        Stages[i].Areas[j].LeftBorder := DisplayStages[i].Areas[j].LeftBorder;
        Stages[i].Areas[j].RightBorder := DisplayStages[i].Areas[j].RightBorder;
        Stages[i].Areas[j].BorderWidthHorizontal := DisplayStages[i].Areas[j].BorderWidthHorizontal;
        Stages[i].Areas[j].BorderWidthVertical := DisplayStages[i].Areas[j].BorderWidthVertical;
        Stages[i].Areas[j].BordersFilled := DisplayStages[i].Areas[j].BordersFilled;

        Stages[i].Areas[j].ContentType := DisplayStages[i].Areas[j].ContentType;

        if (Stages[i].Areas[j].ContentType <> ctPicture) and
           (Stages[i].Areas[j].ContentType <> ctSWF) then
        begin
          Rewrite(TempF);
          CloseFile(TempF);
        end;

        case DisplayStages[i].Areas[j].ContentType of
          ctTime:
            begin
              Stages[i].Areas[j].TimeLanguage := DisplayStages[i].Areas[j].TimeLanguage;
              Stages[i].Areas[j].ClockFormat := DisplayStages[i].Areas[j].ClockFormat;
              Stages[i].Areas[j].ClockType := DisplayStages[i].Areas[j].ClockType;
              Stages[i].Areas[j].ClockTotalDisplayTime := DisplayStages[i].Areas[j].ClockTotalDisplayTime;
              Stages[i].Areas[j].PutClockAtCenter := DisplayStages[i].Areas[j].PutClockAtCenter;
              Stages[i].Areas[j].ClockDotsBlink := DisplayStages[i].Areas[j].ClockDotsBlink;
            end;
          ctDate:
            begin
              Stages[i].Areas[j].DateLanguage := DisplayStages[i].Areas[j].DateLanguage;
              Stages[i].Areas[j].DateFormat := DisplayStages[i].Areas[j].DateFormat;
              Stages[i].Areas[j].DateType := DisplayStages[i].Areas[j].DateType;
              Stages[i].Areas[j].DateTotalDisplayTime := DisplayStages[i].Areas[j].DateTotalDisplayTime;
              Stages[i].Areas[j].PutDateAtCenter := DisplayStages[i].Areas[j].PutDateAtCenter;
            end;
          ctScrollingText:
            begin
              Stages[i].Areas[j].FixedText := DisplayStages[i].Areas[j].FixedText;
              Stages[i].Areas[j].TextLanguage := DisplayStages[i].Areas[j].TextLanguage;
              Stages[i].Areas[j].TextDirection := DisplayStages[i].Areas[j].TextDirection;
              Stages[i].Areas[j].TextScrollType := DisplayStages[i].Areas[j].TextScrollType;
              Stages[i].Areas[j].TextScrollSpeed := DisplayStages[i].Areas[j].TextScrollSpeed;
              Stages[i].Areas[j].InvertScrollingText := DisplayStages[i].Areas[j].InvertScrollingText;
              Stages[i].Areas[j].TextEntranceAnimID := DisplayStages[i].Areas[j].TextEntranceAnimID;
              Stages[i].Areas[j].TextTimingStyle := DisplayStages[i].Areas[j].TextTimingStyle;
              Stages[i].Areas[j].TextRepetitionTimes := DisplayStages[i].Areas[j].TextRepetitionTimes;
              Stages[i].Areas[j].TextTotalDisplayTime := DisplayStages[i].Areas[j].TextTotalDisplayTime;
              Stages[i].Areas[j].ScrollingTextType := DisplayStages[i].Areas[j].ScrollingTextType;
              Stages[i].Areas[j].SystemFontFromFavoriteFonts := DisplayStages[i].Areas[j].SystemFontFromFavoriteFonts;
            end;
          ctSWF:
            begin
              Stages[i].Areas[j].SWFPlaySpeed := DisplayStages[i].Areas[j].SWFPlaySpeed;
              Stages[i].Areas[j].SWFTimingStyle := DisplayStages[i].Areas[j].SWFTimingStyle;
              Stages[i].Areas[j].SWFRepetitionTimes := DisplayStages[i].Areas[j].SWFRepetitionTimes;
              Stages[i].Areas[j].SWFTotalDisplayTime := DisplayStages[i].Areas[j].SWFTotalDisplayTime;
              Stages[i].Areas[j].InvertSWF := DisplayStages[i].Areas[j].InvertSWF;
              Stages[i].Areas[j].PutSWFAtCenter := DisplayStages[i].Areas[j].PutSWFAtCenter;
              Stages[i].Areas[j].UseSWFTimings := DisplayStages[i].Areas[j].UseSWFTimings;
              Stages[i].Areas[j].SWFSensitivity := DisplayStages[i].Areas[j].SWFSensitivity;
              //SWFData
              Stages[i].Areas[j].SWFData.SaveToFile(TempFName);  //save swf data to file
            end;
          ctAnimation:
            begin
              Stages[i].Areas[j].AnimationIndex := DisplayStages[i].Areas[j].AnimationIndex;  //AnimationIndex is not used anymore
              Stages[i].Areas[j].AnimationPlaySpeed := DisplayStages[i].Areas[j].AnimationPlaySpeed;
              Stages[i].Areas[j].AnimationTimingStyle := DisplayStages[i].Areas[j].AnimationTimingStyle;
              Stages[i].Areas[j].AnimationRepetitionTimes := DisplayStages[i].Areas[j].AnimationRepetitionTimes;
              Stages[i].Areas[j].AnimationTotalDisplayTime := DisplayStages[i].Areas[j].AnimationTotalDisplayTime;
              Stages[i].Areas[j].InvertAnimation := DisplayStages[i].Areas[j].InvertAnimation;
              Stages[i].Areas[j].PutAnimationAtCenter := DisplayStages[i].Areas[j].PutAnimationAtCenter;
              Stages[i].Areas[j].UseGIFTimings := DisplayStages[i].Areas[j].UseGIFTimings;
            end;
          ctPicture:
            begin
              Stages[i].Areas[j].ScrollingPicture := DisplayStages[i].Areas[j].ScrollingPicture;
              Stages[i].Areas[j].PictureTimingStyle := DisplayStages[i].Areas[j].PictureTimingStyle;
              Stages[i].Areas[j].PictureRepetitionTimes := DisplayStages[i].Areas[j].PictureRepetitionTimes;
              Stages[i].Areas[j].PictureTotalDisplayTime := DisplayStages[i].Areas[j].PictureTotalDisplayTime;
              Stages[i].Areas[j].InvertPicture := DisplayStages[i].Areas[j].InvertPicture;
              Stages[i].Areas[j].PictureEntranceAnimID := DisplayStages[i].Areas[j].PictureEntranceAnimID;
              Stages[i].Areas[j].PictureTextDirection := DisplayStages[i].Areas[j].PictureTextDirection;
              Stages[i].Areas[j].PictureTextScrollType := DisplayStages[i].Areas[j].PictureTextScrollType;
              Stages[i].Areas[j].PictureTextScrollSpeed := DisplayStages[i].Areas[j].PictureTextScrollSpeed;
              Stages[i].Areas[j].PictureSource := DisplayStages[i].Areas[j].PictureSource;

              Stages[i].Areas[j].PictureBitmap.SaveToFile(TempFName);  //save picture to file
            end;
          ctTemperature:
            begin
              Stages[i].Areas[j].TemperatureLanguage := DisplayStages[i].Areas[j].TemperatureLanguage;
              Stages[i].Areas[j].TemperatureUnit := DisplayStages[i].Areas[j].TemperatureUnit;
              Stages[i].Areas[j].TemperatureTotalDisplayTime := DisplayStages[i].Areas[j].TemperatureTotalDisplayTime;
              Stages[i].Areas[j].PutTemperatureAtCenter := DisplayStages[i].Areas[j].PutTemperatureAtCenter;
            end;
          ctEmpty:
            begin
              Stages[i].Areas[j].EmptyAreaFilled := DisplayStages[i].Areas[j].EmptyAreaFilled;
              Stages[i].Areas[j].EmptyAreaTotalDisplayTime := DisplayStages[i].Areas[j].EmptyAreaTotalDisplayTime;
            end;
        end;

        Reset(TempF);
        TempSize := FileSize(TempF);
        b := TempSize; Write(MainF, b);  //lowest byte
        b := TempSize shr 8; Write(MainF, b);
        b := TempSize shr 16; Write(MainF, b);
        b := TempSize shr 24; Write(MainF, b);  //highest byte

        for IntTemp := 1 to TempSize do
        begin
          Read(TempF, b);
          Write(MainF, b);
        end;

        CloseFile(TempF);
      end;
    end;  //Main for loop

    CloseFile(MainF);

    DeleteFile(TempFName);
    //DeleteFile(BMPTempFName);  --> Don't delete this file, because it is used by the caller
  end;

var
  i: Integer;
  F: file of TStageForFile;
  F2, F3: file of Byte;
  Strs: TTntStringList;
  Stages: TStagesForFileArray;
  TempFName: String;
  b: Byte;
  S: String;
  NonUnicodeTempFName: String;
  BitmapsNonUnicodeTempFileName: String;
begin
  //************************************
  if not License2.CheckLicenseStatusFull then
    Halt;
  //************************************

  SaveAreaSettings(ActiveAreaIndex);

  NonUnicodeTempFName := Procs.GenerateTemporaryFileName(Procs.GetTempFilesPath, TEMPORARY_FILES_PREFIX);
  TempFName := Procs.GenerateTemporaryFileName(Procs.GetTempFilesPath, TEMPORARY_FILES_PREFIX);

  Strs := TTntStringList.Create;
  Strs.Sorted := False;

  SetLength(Stages, 0);
  CollectFileInfo(Stages, Strs, BitmapsNonUnicodeTempFileName);
  AssignFile(F, TempFName);
  Rewrite(F);
  for i := 0 to High(Stages) do
  begin
    Write(F, Stages[i]);
  end;
  CloseFile(F);
  SetLength(Stages, 0);

  //Insert File Signature
  S := LDC_FILE_SIGNATURE;
  AssignFile(F2, NonUnicodeTempFName);
  AssignFile(F3, TempFName);
  Rewrite(F2);
  Reset(F3);
  for i := 1 to Length(S) do
    Write(F2, Byte(S[i]));
  while not eof(F3) do
  begin
    Read(F3, b);
    Write(F2, b);
  end;
  CloseFile(F2);
  CloseFile(F3);

  //Store bitmaps ans SWF data
  AssignFile(F2, NonUnicodeTempFName);
  AssignFile(F3, BitmapsNonUnicodeTempFileName);
  Reset(F2);
  Reset(F3);
  Seek(F2, FileSize(F2));
  while not eof(F2) do
    Read(F2, b);
  while not eof(F3) do
  begin
    Read(F3, b);
    Write(F2, b);
  end;
  CloseFile(F2);
  CloseFile(F3);

  //Store strings
  Strs.SaveToFile(TempFName);
  AssignFile(F2, NonUnicodeTempFName);
  AssignFile(F3, TempFName);
  Reset(F2);
  Reset(F3);
  Seek(F2, FileSize(F2));
  while not eof(F2) do
    Read(F2, b);
  while not eof(F3) do
  begin
    Read(F3, b);
    Write(F2, b);
  end;
  CloseFile(F2);
  CloseFile(F3);

  Procs.WideFileCopy(NonUnicodeTempFName, FName);

  DeleteFile(NonUnicodeTempFName);
  DeleteFile(TempFName);
  DeleteFile(BitmapsNonUnicodeTempFileName);
  Strs.Free;
end;

procedure TMainForm.SaveBtnClick(Sender: TObject);
var
  RetrySave: Boolean;
begin
  if UntitledDesignFile or WorkingDesignIsReadOnly then
    SaveAsMenuItem.Click
  else if WorkingDesignChanged then
  begin
    if InformForReadOnlySelectedFile(WorkingDesignFileName) then
      SaveAsMenuItem.Click
    else
    begin
      RetrySave := False;
      repeat
        try
          SaveShowToFile(WorkingDesignFileName);
          DesignChangeFlag := False;
          InitiateNewWorkingDesign;
        except
          RetrySave := WideMessageDlgSoundTop(WideFormat(Dyn_Texts[66] {'Unable to save the presentation to the file:%s'}, [#13 + WorkingDesignFileName]), mtError, [mbCancel, mbRetry], 0) = mrRetry;
        end;
      until not RetrySave;
    end;
  end;
end;

procedure TMainForm.OpenBtnClick(Sender: TObject);
begin
  if OpenShowDialog.Execute then
  begin
    if CanProceedToOpenDesign(OpenShowDialog.FileName) then
    begin
      OpenPresentationFile(OpenShowDialog.FileName);
    end;
  end;
end;

procedure TMainForm.SaveShowDialogCanClose(Sender: TObject;
  var CanClose: Boolean);
begin
  CanClose := PromptForFileReplace(SaveShowDialog.FileName,
                ExtractFileExt(Procs.ExtractFilterString(SaveShowDialog.Filter,
                SaveShowDialog.FilterIndex)),
                True);  //Force file extension
end;

function TMainForm.WorkingDesignChanged: Boolean;
  function CompareStages(const S1, S2: array of TStage): Boolean;
  var
    i, j: Integer;
  begin
    Result := True;
    for i := 0 to High(S1) do
    begin
      if S1[i].TemporaryDisabled            <> S2[i].TemporaryDisabled then Exit;
      if S1[i].LayoutIndex                  <> S2[i].LayoutIndex then Exit;
      if S1[i].CustomLayout                 <> S2[i].CustomLayout then Exit;
      if S1[i].EntranceEffectID             <> S2[i].EntranceEffectID then Exit;
      if S1[i].ExitEffectID                 <> S2[i].ExitEffectID then Exit;
      if S1[i].EffectSpeed                  <> S2[i].EffectSpeed then Exit;
      //Time Span
      if S1[i].HourFrom                     <> S2[i].HourFrom then Exit;
      if S1[i].MinuteFrom                   <> S2[i].MinuteFrom then Exit;
      if S1[i].HourTo                       <> S2[i].HourTo then Exit;
      if S1[i].MinuteTo                     <> S2[i].MinuteTo then Exit;
      if S1[i].OnlyDoNotShowDuringTimeSpan  <> S2[i].OnlyDoNotShowDuringTimeSpan then Exit;
      if S1[i].DisplayInSpecificDate        <> S2[i].DisplayInSpecificDate then Exit;
      if S1[i].Year                         <> S2[i].Year then Exit;
      if S1[i].Month                        <> S2[i].Month then Exit;
      if S1[i].Day                          <> S2[i].Day then Exit;

      for j := 1 to MAX_AREA_COUNT do
      begin
        if IsUnusedArea(S1[i].Areas[j]) <> IsUnusedArea(S2[i].Areas[j]) then Exit;

        if IsUnusedArea(S1[i].Areas[j]) and IsUnusedArea(S2[i].Areas[j]) then Continue;  //Don't compare theese areas if they have no valid data (unused areas)

        if S1[i].Areas[j].ScrollingText <>  S2[i].Areas[j].ScrollingText then Exit;
        if S1[i].Areas[j].ScrollingTextFontSettings.FarsiLCDFontName <> S2[i].Areas[j].ScrollingTextFontSettings.FarsiLCDFontName then Exit;
        if S1[i].Areas[j].ScrollingTextFontSettings.EnglishLCDFontName <> S2[i].Areas[j].ScrollingTextFontSettings.EnglishLCDFontName then Exit;
        if S1[i].Areas[j].ScrollingTextLFGFileName <> S2[i].Areas[j].ScrollingTextLFGFileName then Exit;
        if S1[i].Areas[j].PictureLFGFileName <> S2[i].Areas[j].PictureLFGFileName then Exit;

        if S1[i].Areas[j].x1 <> S2[i].Areas[j].x1 then Exit;
        if S1[i].Areas[j].y1 <> S2[i].Areas[j].y1 then Exit;
        if S1[i].Areas[j].x2 <> S2[i].Areas[j].x2 then Exit;
        if S1[i].Areas[j].y2 <> S2[i].Areas[j].y2 then Exit;
        if S1[i].Areas[j].SizeChangingMode <> S2[i].Areas[j].SizeChangingMode then Exit;
        if S1[i].Areas[j].DelayTime <> S2[i].Areas[j].DelayTime then Exit;
        if S1[i].Areas[j].ContinuesToNextStage <> S2[i].Areas[j].ContinuesToNextStage then Exit;
        if S1[i].Areas[j].AdvanceStageWhenDone <> S2[i].Areas[j].AdvanceStageWhenDone then Exit;
        if S1[i].Areas[j].ForceAdvanceStageWhenDone <> S2[i].Areas[j].ForceAdvanceStageWhenDone then Exit;
        if S1[i].Areas[j].CompleteBeforeNextStage <> S2[i].Areas[j].CompleteBeforeNextStage then Exit;
        if S1[i].Areas[j].RepeatAfterDone <> S2[i].Areas[j].RepeatAfterDone then Exit;
        if S1[i].Areas[j].Color <> S2[i].Areas[j].Color then Exit;

        if S1[i].Areas[j].ScrollingTextFontSettings.FontType <> S2[i].Areas[j].ScrollingTextFontSettings.FontType then Exit;

        if S1[i].Areas[j].ScrollingTextFontSettings.SystemFontSettings.Name <> S2[i].Areas[j].ScrollingTextFontSettings.SystemFontSettings.Name then Exit;
        if S1[i].Areas[j].ScrollingTextFontSettings.SystemFontSettings.Size <> S2[i].Areas[j].ScrollingTextFontSettings.SystemFontSettings.Size then Exit;
        if S1[i].Areas[j].ScrollingTextFontSettings.SystemFontSettings.Height <> S2[i].Areas[j].ScrollingTextFontSettings.SystemFontSettings.Height then Exit;
        if S1[i].Areas[j].ScrollingTextFontSettings.SystemFontSettings.Pitch <> S2[i].Areas[j].ScrollingTextFontSettings.SystemFontSettings.Pitch then Exit;
        if S1[i].Areas[j].ScrollingTextFontSettings.SystemFontSettings.Color <> S2[i].Areas[j].ScrollingTextFontSettings.SystemFontSettings.Color then Exit;
        if S1[i].Areas[j].ScrollingTextFontSettings.SystemFontSettings.Style <> S2[i].Areas[j].ScrollingTextFontSettings.SystemFontSettings.Style then Exit;
        if S1[i].Areas[j].ScrollingTextFontSettings.SystemFontSettings.Charset <> S2[i].Areas[j].ScrollingTextFontSettings.SystemFontSettings.Charset then Exit;

        if S1[i].Areas[j].PictureAvailable <> S2[i].Areas[j].PictureAvailable then Exit;
        if S1[i].Areas[j].PictureBitmap <> S2[i].Areas[j].PictureBitmap then Exit;
        if S1[i].Areas[j].AnimSpeed <> S2[i].Areas[j].AnimSpeed then Exit;

        if S1[i].Areas[j].TopBorder <> S2[i].Areas[j].TopBorder then Exit;
        if S1[i].Areas[j].BottomBorder <> S2[i].Areas[j].BottomBorder then Exit;
        if S1[i].Areas[j].LeftBorder <> S2[i].Areas[j].LeftBorder then Exit;
        if S1[i].Areas[j].RightBorder <> S2[i].Areas[j].RightBorder then Exit;
        if S1[i].Areas[j].BorderWidthHorizontal <> S2[i].Areas[j].BorderWidthHorizontal then Exit;
        if S1[i].Areas[j].BorderWidthVertical <> S2[i].Areas[j].BorderWidthVertical then Exit;
        if S1[i].Areas[j].BordersFilled <> S2[i].Areas[j].BordersFilled then Exit;

        if S1[i].Areas[j].ContentType <> S2[i].Areas[j].ContentType then Exit;
        case S2[i].Areas[j].ContentType of
          ctTime:
            begin
              if S1[i].Areas[j].TimeLanguage <> S2[i].Areas[j].TimeLanguage then Exit;
              if S1[i].Areas[j].ClockFormat <> S2[i].Areas[j].ClockFormat then Exit;
              if S1[i].Areas[j].ClockType <> S2[i].Areas[j].ClockType then Exit;
              if S1[i].Areas[j].ClockTotalDisplayTime <> S2[i].Areas[j].ClockTotalDisplayTime then Exit;
              if S1[i].Areas[j].PutClockAtCenter <> S2[i].Areas[j].PutClockAtCenter then Exit;
              if S1[i].Areas[j].ClockDotsBlink <> S2[i].Areas[j].ClockDotsBlink then Exit;
            end;
          ctDate:
            begin
              if S1[i].Areas[j].DateLanguage <> S2[i].Areas[j].DateLanguage then Exit;
              if S1[i].Areas[j].DateFormat <> S2[i].Areas[j].DateFormat then Exit;
              if S1[i].Areas[j].DateType <> S2[i].Areas[j].DateType then Exit;
              if S1[i].Areas[j].DateTotalDisplayTime <> S2[i].Areas[j].DateTotalDisplayTime then Exit;
              if S1[i].Areas[j].PutDateAtCenter <> S2[i].Areas[j].PutDateAtCenter then Exit;
            end;
          ctScrollingText:
            begin
              if S1[i].Areas[j].FixedText <> S2[i].Areas[j].FixedText then Exit;
              if S1[i].Areas[j].TextLanguage <> S2[i].Areas[j].TextLanguage then Exit;
              if S1[i].Areas[j].TextDirection <> S2[i].Areas[j].TextDirection then Exit;
              if S1[i].Areas[j].TextScrollType <> S2[i].Areas[j].TextScrollType then Exit;
              if S1[i].Areas[j].TextScrollSpeed <> S2[i].Areas[j].TextScrollSpeed then Exit;
              if S1[i].Areas[j].InvertScrollingText <> S2[i].Areas[j].InvertScrollingText then Exit;
              if S1[i].Areas[j].TextEntranceAnimID <> S2[i].Areas[j].TextEntranceAnimID then Exit;
              if S1[i].Areas[j].TextTimingStyle <> S2[i].Areas[j].TextTimingStyle then Exit;
              if S1[i].Areas[j].TextRepetitionTimes <> S2[i].Areas[j].TextRepetitionTimes then Exit;
              if S1[i].Areas[j].TextTotalDisplayTime <> S2[i].Areas[j].TextTotalDisplayTime then Exit;
              if S1[i].Areas[j].ScrollingTextType <> S2[i].Areas[j].ScrollingTextType then Exit;
            end;
          ctSWF:
            begin
              if S1[i].Areas[j].SWFPlaySpeed <> S2[i].Areas[j].SWFPlaySpeed then Exit;
              if S1[i].Areas[j].SWFTimingStyle <> S2[i].Areas[j].SWFTimingStyle then Exit;
              if S1[i].Areas[j].SWFRepetitionTimes <> S2[i].Areas[j].SWFRepetitionTimes then Exit;
              if S1[i].Areas[j].SWFTotalDisplayTime <> S2[i].Areas[j].SWFTotalDisplayTime then Exit;
              if S1[i].Areas[j].InvertSWF <> S2[i].Areas[j].InvertSWF then Exit;
              if S1[i].Areas[j].PutSWFAtCenter <> S2[i].Areas[j].PutSWFAtCenter then Exit;
              if S1[i].Areas[j].UseSWFTimings <> S2[i].Areas[j].UseSWFTimings then Exit;
              if S1[i].Areas[j].SWFSensitivity <> S2[i].Areas[j].SWFSensitivity then Exit;
              //Also compare swf data
              if not Procs.CompareMemoryStreams(S1[i].Areas[j].SWFData, S2[i].Areas[j].SWFData) then Exit;
            end;
          ctAnimation:
            begin
              //if S1[i].Areas[j].AnimationIndex <> S2[i].Areas[j].AnimationIndex then Exit;  --> AnimationIndex is not used anymore
              if S1[i].Areas[j].AnimationName <> S2[i].Areas[j].AnimationName then Exit;
              if S1[i].Areas[j].AnimationPlaySpeed <> S2[i].Areas[j].AnimationPlaySpeed then Exit;
              if S1[i].Areas[j].AnimationTimingStyle <> S2[i].Areas[j].AnimationTimingStyle then Exit;
              if S1[i].Areas[j].AnimationRepetitionTimes <> S2[i].Areas[j].AnimationRepetitionTimes then Exit;
              if S1[i].Areas[j].AnimationTotalDisplayTime <> S2[i].Areas[j].AnimationTotalDisplayTime then Exit;
              if S1[i].Areas[j].InvertAnimation <> S2[i].Areas[j].InvertAnimation then Exit;
              if S1[i].Areas[j].PutAnimationAtCenter <> S2[i].Areas[j].PutAnimationAtCenter then Exit;
              if S1[i].Areas[j].UseGIFTimings <> S2[i].Areas[j].UseGIFTimings then Exit;
            end;
          ctPicture:
            begin
              if S1[i].Areas[j].ScrollingPicture <> S2[i].Areas[j].ScrollingPicture then Exit;
              if S1[i].Areas[j].PictureTimingStyle <> S2[i].Areas[j].PictureTimingStyle then Exit;
              if S1[i].Areas[j].PictureRepetitionTimes <> S2[i].Areas[j].PictureRepetitionTimes then Exit;
              if S1[i].Areas[j].PictureTotalDisplayTime <> S2[i].Areas[j].PictureTotalDisplayTime then Exit;
              if S1[i].Areas[j].InvertPicture <> S2[i].Areas[j].InvertPicture then Exit;
              if S1[i].Areas[j].PictureEntranceAnimID <> S2[i].Areas[j].PictureEntranceAnimID then Exit;
              if S1[i].Areas[j].PictureTextDirection <> S2[i].Areas[j].PictureTextDirection then Exit;
              if S1[i].Areas[j].PictureTextScrollType <> S2[i].Areas[j].PictureTextScrollType then Exit;
              if S1[i].Areas[j].PictureTextScrollSpeed <> S2[i].Areas[j].PictureTextScrollSpeed then Exit;
              if S1[i].Areas[j].PictureSource <> S2[i].Areas[j].PictureSource then Exit;
            end;
          ctTemperature:
            begin
              if S1[i].Areas[j].TemperatureLanguage <> S2[i].Areas[j].TemperatureLanguage then Exit;
              if S1[i].Areas[j].TemperatureUnit <> S2[i].Areas[j].TemperatureUnit then Exit;
              if S1[i].Areas[j].TemperatureTotalDisplayTime <> S2[i].Areas[j].TemperatureTotalDisplayTime then Exit;
              if S1[i].Areas[j].PutTemperatureAtCenter <> S2[i].Areas[j].PutTemperatureAtCenter then Exit;
            end;
          ctEmpty:
            begin
              if S1[i].Areas[j].EmptyAreaFilled <> S2[i].Areas[j].EmptyAreaFilled then Exit;
              if S1[i].Areas[j].EmptyAreaTotalDisplayTime <> S2[i].Areas[j].EmptyAreaTotalDisplayTime then Exit;
            end;
        end;
      end;
    end;
    Result := False;
  end;

begin
  if ForceDesignNotChanged then
  begin
    Result := False;
    Exit;
  end;
  SaveAreaSettings(ActiveAreaIndex);
  Result := DesignChangeFlag or (Length(DisplayStages) <> Length(OldDisplayStages));
  if Result then
    Exit;
  if CompareStages(OldDisplayStages, DisplayStages) then
  begin
    Result := True;
    Exit;
  end;
end;

procedure TMainForm.UpdateMainFormCaption;
begin
  if UntitledDesignFile then
  begin
    Caption := APPLICATION_STATIC_CAPTION + ' - ' + UNTITLED_DOCUMENT_NAME + IntToStr(WorkingDesignUntitledCount) + '.LDC';
    Application.Title := UNTITLED_DOCUMENT_NAME + IntToStr(WorkingDesignUntitledCount) + '.LDC - ' + APPLICATION_STATIC_CAPTION
  end
  else
  begin
    Caption := APPLICATION_STATIC_CAPTION + ' - ' + WideExtractFileName(WorkingDesignFileName) +
               IfThen(WorkingDesignIsReadOnly, ' (Read-Only)', '');
    Application.Title := WideExtractFileName(WorkingDesignFileName) +
               IfThen(WorkingDesignIsReadOnly, ' (Read-Only)', '') +
               ' - ' + APPLICATION_STATIC_CAPTION;
  end;
  OnCaptionChanged;
end;

procedure TMainForm.OnCaptionChanged;
begin
  //Nothing to do
  //Application.Title is also updated in the UpdateMainFormCaption procedure
end;

function TMainForm.CanProceedToOpenDesign(const DesignFileName: WideString): Boolean;
var
  Response: Integer;
begin
  Result := False;

  if WorkingDesignChanged then
  begin
    Response := WideMessageDlgSoundTop(Dyn_Texts[65] {'Do you want to save the changes to the current presentation?'},
        mtWarning, [mbYes, mbNo, mbCancel], 0);
    Application.ProcessMessages;

    if Response=mrCancel then
      Exit
    else if Response=mrYes then
    begin
      SaveBtn.Click;
      if WorkingDesignChanged then
        Exit;
    end;
  end;

  Result := True;
end;

procedure TMainForm.SaveDropDownBtnClick(Sender: TObject);
begin
  TntXPMenu1.Active := not TntXPMenu1.Active;
  TntXPMenu1.Active := not TntXPMenu1.Active;

  SpecialProcs.PopupMenuAtControl(SaveDropDownBtn, SaveOptionsPopup);
end;

procedure TMainForm.SaveMenuItemClick(Sender: TObject);
begin
  SaveBtn.Click;
end;

procedure TMainForm.SaveAsMenuItemClick(Sender: TObject);
var
  FName: WideString;
  RetrySave, SaveError: Boolean;
  OldWorkingDesignFileName: WideString;
begin
  OldWorkingDesignFileName := WorkingDesignFileName;
  SaveShowDialog.InitialDir := '';
  if UntitledDesignFile then
    SaveShowDialog.FileName := UNTITLED_DOCUMENT_NAME + IntToStr(WorkingDesignUntitledCount)
  else if WideDirectoryExists(WideExtractFilePath(WorkingDesignFileName)) then
  begin
    SaveShowDialog.InitialDir := WideExtractFilePath(WorkingDesignFileName);
    SaveShowDialog.FileName := WideExtractFileName(WorkingDesignFileName);
  end;
  RetrySave := True;
  while RetrySave do
  begin
    if SaveShowDialog.Execute then
    begin
      FName := Procs.ApplyFileNameExtension(SaveShowDialog.FileName,
                 WideExtractFileExt(Procs.ExtractFilterString(SaveShowDialog.Filter, SaveShowDialog.FilterIndex)),
                 True);  //Force file extension
      if InformForReadOnlySelectedFile(FName) then
        Continue;
      SaveError := False;
      try
        SaveShowToFile(FName);
      except
        SaveError := True;
        if not(WideMessageDlgSoundTop(WideFormat(Dyn_Texts[66] {'Unable to save the presentation to the file:%s'}, [#13 + FName]), mtError, [mbCancel, mbRetry], 0) = mrRetry) then
          Exit;
      end;
      if SaveError then
        Continue;
      DesignChangeFlag := False;
      InitiateNewWorkingDesign;
      WorkingDesignFileName := FName;
      WorkingDesignIsReadOnly := False;
      UntitledDesignFile := False;
      UpdateMainFormCaption;
      WorkingOnNewDesignStarted(OldWorkingDesignFileName, WorkingDesignFileName);
      RetrySave := False;
    end
    else
      RetrySave := False;
  end;
end;

procedure TMainForm.InitiateNewWorkingDesign;
  procedure CopyStages(var S1: array of TStage; const S2: array of TStage);
  var
    i, j: Integer;
  begin
    for i := 0 to High(S1) do
    begin
      S1[i].TemporaryDisabled := S2[i].TemporaryDisabled;
      S1[i].LayoutIndex := S2[i].LayoutIndex;
      S1[i].CustomLayout := S2[i].CustomLayout;
      S1[i].EntranceEffectID := S2[i].EntranceEffectID;
      S1[i].ExitEffectID := S2[i].ExitEffectID;
      S1[i].EffectSpeed := S2[i].EffectSpeed;
      //Time Span
      S1[i].HourFrom := S2[i].HourFrom;
      S1[i].MinuteFrom := S2[i].MinuteFrom;
      S1[i].HourTo := S2[i].HourTo;
      S1[i].MinuteTo := S2[i].MinuteTo;
      S1[i].OnlyDoNotShowDuringTimeSpan := S2[i].OnlyDoNotShowDuringTimeSpan;
      S1[i].DisplayInSpecificDate := S2[i].DisplayInSpecificDate;
      S1[i].Year := S2[i].Year;
      S1[i].Month := S2[i].Month;
      S1[i].Day := S2[i].Day;

      for j := 1 to MAX_AREA_COUNT do
      begin
        S1[i].Areas[j].ScrollingText :=  S2[i].Areas[j].ScrollingText;
        S1[i].Areas[j].ScrollingTextFontSettings.FarsiLCDFontName := S2[i].Areas[j].ScrollingTextFontSettings.FarsiLCDFontName;
        S1[i].Areas[j].ScrollingTextFontSettings.EnglishLCDFontName := S2[i].Areas[j].ScrollingTextFontSettings.EnglishLCDFontName;
        S1[i].Areas[j].ScrollingTextLFGFileName := S2[i].Areas[j].ScrollingTextLFGFileName;
        S1[i].Areas[j].PictureLFGFileName := S2[i].Areas[j].PictureLFGFileName;

        S1[i].Areas[j].x1 := S2[i].Areas[j].x1;
        S1[i].Areas[j].y1 := S2[i].Areas[j].y1;
        S1[i].Areas[j].x2 := S2[i].Areas[j].x2;
        S1[i].Areas[j].y2 := S2[i].Areas[j].y2;
        S1[i].Areas[j].SizeChangingMode := S2[i].Areas[j].SizeChangingMode;
        S1[i].Areas[j].DelayTime := S2[i].Areas[j].DelayTime;
        S1[i].Areas[j].ContinuesToNextStage := S2[i].Areas[j].ContinuesToNextStage;
        S1[i].Areas[j].AdvanceStageWhenDone := S2[i].Areas[j].AdvanceStageWhenDone;
        S1[i].Areas[j].ForceAdvanceStageWhenDone := S2[i].Areas[j].ForceAdvanceStageWhenDone;
        S1[i].Areas[j].CompleteBeforeNextStage := S2[i].Areas[j].CompleteBeforeNextStage;
        S1[i].Areas[j].RepeatAfterDone := S2[i].Areas[j].RepeatAfterDone;
        S1[i].Areas[j].Color := S2[i].Areas[j].Color;

        S1[i].Areas[j].ScrollingTextFontSettings.FontType := S2[i].Areas[j].ScrollingTextFontSettings.FontType;
        S1[i].Areas[j].ScrollingTextFontSettings.SystemFontSettings := S2[i].Areas[j].ScrollingTextFontSettings.SystemFontSettings;

        S1[i].Areas[j].PictureAvailable := S2[i].Areas[j].PictureAvailable;
        S1[i].Areas[j].PictureBitmap := S2[i].Areas[j].PictureBitmap;
        S1[i].Areas[j].AnimSpeed := S2[i].Areas[j].AnimSpeed;

        S1[i].Areas[j].TopBorder := S2[i].Areas[j].TopBorder;
        S1[i].Areas[j].BottomBorder := S2[i].Areas[j].BottomBorder;
        S1[i].Areas[j].LeftBorder := S2[i].Areas[j].LeftBorder;
        S1[i].Areas[j].RightBorder := S2[i].Areas[j].RightBorder;
        S1[i].Areas[j].BorderWidthHorizontal := S2[i].Areas[j].BorderWidthHorizontal;
        S1[i].Areas[j].BorderWidthVertical := S2[i].Areas[j].BorderWidthVertical;
        S1[i].Areas[j].BordersFilled := S2[i].Areas[j].BordersFilled;

        S1[i].Areas[j].ContentType := S2[i].Areas[j].ContentType;
        case S2[i].Areas[j].ContentType of
          ctTime:
            begin
              S1[i].Areas[j].TimeLanguage := S2[i].Areas[j].TimeLanguage;
              S1[i].Areas[j].ClockFormat := S2[i].Areas[j].ClockFormat;
              S1[i].Areas[j].ClockType := S2[i].Areas[j].ClockType;
              S1[i].Areas[j].ClockTotalDisplayTime := S2[i].Areas[j].ClockTotalDisplayTime;
              S1[i].Areas[j].PutClockAtCenter := S2[i].Areas[j].PutClockAtCenter;
              S1[i].Areas[j].ClockDotsBlink := S2[i].Areas[j].ClockDotsBlink;
            end;
          ctDate:
            begin
              S1[i].Areas[j].DateLanguage := S2[i].Areas[j].DateLanguage;
              S1[i].Areas[j].DateFormat := S2[i].Areas[j].DateFormat;
              S1[i].Areas[j].DateType := S2[i].Areas[j].DateType;
              S1[i].Areas[j].DateTotalDisplayTime := S2[i].Areas[j].DateTotalDisplayTime;
              S1[i].Areas[j].PutDateAtCenter := S2[i].Areas[j].PutDateAtCenter;
            end;
          ctScrollingText:
            begin
              S1[i].Areas[j].FixedText := S2[i].Areas[j].FixedText;
              S1[i].Areas[j].TextLanguage := S2[i].Areas[j].TextLanguage;
              S1[i].Areas[j].TextDirection := S2[i].Areas[j].TextDirection;
              S1[i].Areas[j].TextScrollType := S2[i].Areas[j].TextScrollType;
              S1[i].Areas[j].TextScrollSpeed := S2[i].Areas[j].TextScrollSpeed;
              S1[i].Areas[j].InvertScrollingText := S2[i].Areas[j].InvertScrollingText;
              S1[i].Areas[j].TextEntranceAnimID := S2[i].Areas[j].TextEntranceAnimID;
              S1[i].Areas[j].TextTimingStyle := S2[i].Areas[j].TextTimingStyle;
              S1[i].Areas[j].TextRepetitionTimes := S2[i].Areas[j].TextRepetitionTimes;
              S1[i].Areas[j].TextTotalDisplayTime := S2[i].Areas[j].TextTotalDisplayTime;
              S1[i].Areas[j].ScrollingTextType := S2[i].Areas[j].ScrollingTextType;
              S1[i].Areas[j].SystemFontFromFavoriteFonts := S2[i].Areas[j].SystemFontFromFavoriteFonts;
            end;
          ctSWF:
            begin
              S1[i].Areas[j].SWFPlaySpeed := S2[i].Areas[j].SWFPlaySpeed;
              S1[i].Areas[j].SWFTimingStyle := S2[i].Areas[j].SWFTimingStyle;
              S1[i].Areas[j].SWFRepetitionTimes := S2[i].Areas[j].SWFRepetitionTimes;
              S1[i].Areas[j].SWFTotalDisplayTime := S2[i].Areas[j].SWFTotalDisplayTime;
              S1[i].Areas[j].InvertSWF := S2[i].Areas[j].InvertSWF;
              S1[i].Areas[j].PutSWFAtCenter := S2[i].Areas[j].PutSWFAtCenter;
              S1[i].Areas[j].UseSWFTimings := S2[i].Areas[j].UseSWFTimings;
              S1[i].Areas[j].SWFSensitivity := S2[i].Areas[j].SWFSensitivity;
              //Also do for SWFData
              S1[i].Areas[j].SWFData.LoadFromStream(S2[i].Areas[j].SWFData);
            end;
          ctAnimation:
            begin
              //S1[i].Areas[j].AnimationIndex := S2[i].Areas[j].AnimationIndex;  //AnimationIndex is not used anymore
              S1[i].Areas[j].AnimationName := S2[i].Areas[j].AnimationName;
              S1[i].Areas[j].AnimationPlaySpeed := S2[i].Areas[j].AnimationPlaySpeed;
              S1[i].Areas[j].AnimationTimingStyle := S2[i].Areas[j].AnimationTimingStyle;
              S1[i].Areas[j].AnimationRepetitionTimes := S2[i].Areas[j].AnimationRepetitionTimes;
              S1[i].Areas[j].AnimationTotalDisplayTime := S2[i].Areas[j].AnimationTotalDisplayTime;
              S1[i].Areas[j].InvertAnimation := S2[i].Areas[j].InvertAnimation;
              S1[i].Areas[j].PutAnimationAtCenter := S2[i].Areas[j].PutAnimationAtCenter;
              S1[i].Areas[j].UseGIFTimings := S2[i].Areas[j].UseGIFTimings;
            end;
          ctPicture:
            begin
              S1[i].Areas[j].ScrollingPicture := S2[i].Areas[j].ScrollingPicture;
              S1[i].Areas[j].PictureTimingStyle := S2[i].Areas[j].PictureTimingStyle;
              S1[i].Areas[j].PictureRepetitionTimes := S2[i].Areas[j].PictureRepetitionTimes;
              S1[i].Areas[j].PictureTotalDisplayTime := S2[i].Areas[j].PictureTotalDisplayTime;
              S1[i].Areas[j].InvertPicture := S2[i].Areas[j].InvertPicture;
              S1[i].Areas[j].PictureEntranceAnimID := S2[i].Areas[j].PictureEntranceAnimID;
              S1[i].Areas[j].PictureTextDirection := S2[i].Areas[j].PictureTextDirection;
              S1[i].Areas[j].PictureTextScrollType := S2[i].Areas[j].PictureTextScrollType;
              S1[i].Areas[j].PictureTextScrollSpeed := S2[i].Areas[j].PictureTextScrollSpeed;
              S1[i].Areas[j].PictureSource := S2[i].Areas[j].PictureSource;
            end;
          ctTemperature:
            begin
              S1[i].Areas[j].TemperatureLanguage := S2[i].Areas[j].TemperatureLanguage;
              S1[i].Areas[j].TemperatureUnit := S2[i].Areas[j].TemperatureUnit;
              S1[i].Areas[j].TemperatureTotalDisplayTime := S2[i].Areas[j].TemperatureTotalDisplayTime;
              S1[i].Areas[j].PutTemperatureAtCenter := S2[i].Areas[j].PutTemperatureAtCenter;
            end;
          ctEmpty:
            begin
              S1[i].Areas[j].EmptyAreaFilled := S2[i].Areas[j].EmptyAreaFilled;
              S1[i].Areas[j].EmptyAreaTotalDisplayTime := S2[i].Areas[j].EmptyAreaTotalDisplayTime;
            end;
        end;
      end;
    end;
  end;

begin
  SetLength_DisplayStages(OldDisplayStages, Length(DisplayStages));

  CopyStages(OldDisplayStages, DisplayStages);
end;

procedure TMainForm.OpenDropDownBtnClick(Sender: TObject);
begin
  //**Although it seems that these two lines have no effect, but they are necessary - DO NOT REMOVE THEM
  TntXPMenu1.Active := not TntXPMenu1.Active;
  TntXPMenu1.Active := not TntXPMenu1.Active;

  SpecialProcs.PopupMenuAtControlBiDi(OpenDropDownBtn, RUFLPopup, bdRightToLeft);
end;

procedure TMainForm.LoadRuntimeDefaultConfig(
  var ARuntimeGlobalOptions: TRuntimeGlobalOptions);
begin

  //Recently used file list
  RUFL := TTntStringList.Create;  //Always create RUFL regardless of GlobalOptions.RUFLCount to prevent potential software bugs
  RUFL.Clear;
  RUFL.Sorted := False;
  RUFLLastOpenedFile := '';
end;

procedure TMainForm.RUFLAdd(const FullFileName: WideString);
begin
  if Length(Trim(FullFileName)) = 0 then
  begin
    RUFLBuildMenuItems;
    Exit;
  end;

  if GlobalOptions.RUFLCount <= 0 then
  begin
    RUFL.Clear;
    Exit;
  end;
  
  if RUFL.IndexOf(FullFileName) >= 0 then
    //The item already is in RUFL. Bring it to the top of the list.
    RUFL.Move(RUFL.IndexOf(FullFileName), 0)
  else
  begin
    //Insert the new item at the top of the RUFL.
    RUFL.InsertObject(0, FullFileName, nil);
    if RUFL.Count > GlobalOptions.RUFLCount then
      RUFLRemove(RUFL.Strings[RUFL.Count - 1]);
  end;
  RUFLBuildMenuItems;
end;

procedure TMainForm.DisableAllMenuChanges(Disabled: Boolean);

  procedure DisableAllItems(MenuItem: TTntMenuItem; Disabled: Boolean);
  var
    i: Integer;
  begin
    (MenuItem as TTntMenuItem).IgnoreAllMenuChanges := Disabled;
    for i := 0 to MenuItem.Count - 1 do
      DisableAllItems(MenuItem.Items[i] as TTntMenuItem, Disabled);
  end;

//var
  //i: Integer;
begin
  //for i := 0 to MainMenu.Items.Count - 1 do
  //  DisableAllItems(MainMenu.Items[i] as TTntMenuItem, Disabled);
end;

procedure TMainForm.RUFLRemove(const FullFileName: WideString;
  RebuildMenuItems: Boolean);
begin
  if Length(Trim(FullFileName)) = 0 then
  begin
    RUFLBuildMenuItems;
    Exit;
  end;

  if RUFL.IndexOf(FullFileName) >= 0 then
  begin
    try
      DisableAllMenuChanges(True);
      //Remove menu item if assigned
      if Assigned(RUFL.Objects[RUFL.IndexOf(FullFileName)]) and
        (RUFL.Objects[RUFL.IndexOf(FullFileName)] is TTntMenuItem) then
        (RUFL.Objects[RUFL.IndexOf(FullFileName)] as TTntMenuItem).Free;
    finally
      DisableAllMenuChanges(False);
    end;
    RUFL.Delete(RUFL.IndexOf(FullFileName));
    if RebuildMenuItems then
      RUFLBuildMenuItems;
  end;
end;

procedure TMainForm.RUFLReadEntries;

  function IsRUFLEntry(const EntryName: String): Boolean;
  var
    Index: Integer;
  begin
    Result := Procs.StrToInteger(EntryName, Index) and
      (Index >= 0);
  end;

var
  Reg: TTntRegistry;
  FList: TTntStringList;
  S: WideString;
  i: Integer;
begin
  Reg := TTntRegistry.Create;
  FList := TTntStringList.Create;
  try
    RUFL.Clear;
    Reg.RootKey := HKEY_CURRENT_USER;
    if Reg.OpenKeyReadOnly(REG_USER_SETTINGS_PATH + RUFLRegPath) then
    begin
      Reg.GetValueNames(FList);
      FList.Sort;  //Sort the list so that the list is ordered correctly.
      for i := 0 to FList.Count - 1 do
        if IsRUFLEntry(FList.Strings[i]) and
           (Reg.GetDataType(FList.Strings[i]) = rdString) then
        begin
          S := Reg.ReadString(FList.Strings[i]);
          //Blank and duplicated items are not allowed
          if (Length(Trim(S)) > 0) and
             (RUFL.IndexOf(S) < 0) then
            RUFL.Append(S);
        end;
    end;
    FList.Free;
    Reg.Free;
  except
    FList.Free;
    Reg.Free;
  end;
end;

procedure TMainForm.RUFLWriteEntries;
var
  Reg: TTntRegistry;
  FList: TTntStringList;
  i: Integer;
begin
  Reg := TTntRegistry.Create;
  FList := TTntStringList.Create;
  try
    Reg.RootKey := HKEY_CURRENT_USER;
    if Reg.OpenKey(REG_USER_SETTINGS_PATH + RUFLRegPath, True) then
    begin
      Reg.GetValueNames(FList);
      for i := 0 to FList.Count - 1 do
        Reg.DeleteValue(FList.Strings[i]);
      if GlobalOptions.RUFLCount > 0 then
        for i := 0 to RUFL.Count - 1 do
          Reg.WriteString(IntToStr(i), RUFL.Strings[i]);
    end;
    FList.Free;
    Reg.Free;
  except
    FList.Free;
    Reg.Free;
  end;
end;

procedure TMainForm.WorkingOnNewDesignStarted(const OldFullFName,
  NewFullFName: WideString);
begin
  if OldFullFName <> NewFullFName then
  begin
    RUFLAdd(RUFLLastOpenedFile);
    RUFLLastOpenedFile := NewFullFName;
  end;
  if RUFL.IndexOf(NewFullFName) >= 0 then
    RUFLRemove(NewFullFName);
end;

procedure TMainForm.RUFLBuildMenuItems;

  function RUFLFNameToMenuItemCaption(const FName: WideString): WideString;
  begin
    Result := FName;//MinimizeName(FName, Canvas, 300);  --> Unicode version of MinimizeName does not exists and is so complicated to write.
  end;

var
  RUFLMenuItem: TTntMenuItem;
  SaveAutoDetect: Boolean;
  i: Integer;
  OldSplitterVisible: Boolean;
  SplitterIndex: Integer;
  SplitterName: String;
begin
  if Assigned(RUFLMenuSplitter) then  //--> Prevent potential software bugs
    OldSplitterVisible := RUFLMenuSplitter.Visible
  else
    OldSplitterVisible := False;
try
  DisableAllMenuChanges(True);
  if RUFL.Count > 0 then
  begin
    for i := 0 to RUFL.Count - 1 do
      if Assigned(RUFL.Objects[i]) and
        (RUFL.Objects[i] is TTntMenuItem) then
      begin
        (RUFL.Objects[i] as TTntMenuItem).Free;  //Delete from the file menu and free its memory
        RUFL.Objects[i] := nil;  //Prevent potential software bugs
      end;
  end;

  if RUFL.Count > GlobalOptions.RUFLCount then
    for i := 1 to RUFL.Count - GlobalOptions.RUFLCount do
      RUFL.Delete(RUFL.Count - 1);

  //Don;t rebuild the menu items if the application is shutting down, because it may cause unpredictable problems
  if asTerminating in ApplicationState then
    Exit;
  ////////////////////

  //TntXPMenu1.Active := False;  -->  Causes critical problems
  //Save current AutoDetect property value
  SaveAutoDetect := TntXPMenu1.AutoDetect;
  //TntXPMenu1.AutoDetect := False;
  TntXPMenu1.AutoDetect := True;

  RUFLMenuSplitter.Visible := RUFL.Count > 0;
  OpenDropDownBtn.Enabled := RUFL.Count > 0;
  if RUFL.Count > 0 then
  begin
    for i := 0 to RUFL.Count - 1 do
    begin
      RUFLMenuItem := TTntMenuItem.Create(Self);
      RUFLMenuItem.Caption := RUFLFNameToMenuItemCaption(RUFL.Strings[i]);
      RUFLMenuItem.Tag := i;
      RUFLMenuItem.OnClick := RUFLMenuItemClicked;
      RUFLPopup.Items.Insert(RUFLPopup.Items.IndexOf(RUFLMenuSplitter), RUFLMenuItem);
      RUFL.Objects[i] := RUFLMenuItem;
    end;
  end;

  if not Assigned(RUFLMenuSplitter) or
     (RUFLMenuSplitter.Visible <> OldSplitterVisible) then
  begin
    //Recreate the menu item to apply its visible property change, because
    //  all menu changes is disabled
    RUFLMenuItem := TTntMenuItem.Create(Self);
    if Assigned(RUFLMenuSplitter) then
    begin
      RUFLMenuItem.Caption := RUFLMenuSplitter.Caption;
      RUFLMenuItem.Hint := RUFLMenuSplitter.Hint;
      RUFLMenuItem.Visible := RUFLMenuSplitter.Visible;
      SplitterName := RUFLMenuSplitter.Name;;
      SplitterIndex := RUFLPopup.Items.IndexOf(RUFLMenuSplitter);
      RUFLMenuSplitter.Free;
      RUFLMenuSplitter := nil;  //--> Prevent potential software bugs
      RUFLMenuItem.Name := SplitterName;
    end
    else
    begin  //--> Prevent potential software bugs
      RUFLMenuItem.Caption := '-';
      RUFLMenuItem.Visible := True;
      SplitterName := 'RUFLMenuSplitter';
      SplitterIndex := RUFLPopup.Items.IndexOf(RUFLMenuLastItem) - 1;
    end;
    RUFLMenuSplitter := RUFLMenuItem;
    RUFLPopup.Items.Insert(SplitterIndex, RUFLMenuItem);
  end;

  //Restore AutoDetect property value
  TntXPMenu1.AutoDetect := SaveAutoDetect;
  //TntXPMenu1.Active := True;  -->  Causes critical problems
finally
  DisableAllMenuChanges(False);
end;
end;

procedure TMainForm.RUFLMenuItemClicked(Sender: TObject);
var
  DesignFileName: WideString;
begin
  DesignFileName := RUFL.Strings[(Sender as TTntMenuItem).Tag];
  if WideFileExists(DesignFileName) then
  begin
    if CanProceedToOpenDesign(DesignFileName) then
      OpenPresentationFile(DesignFileName);  //Not necessary to check the function result
  end
  else
  begin
    WideShowMessageSoundTop(WideFormat(Dyn_Texts[67] {'The presentation file %sdoesn''t exist.'}, [Chr(13) + DesignFileName + Chr(13)]));
    RUFLRemove(DesignFileName);
  end;
end;

function TMainForm.OpenPresentationFile(const FName: WideString): Boolean;
var
  OldWorkingDesignFileName: WideString;
begin
  OldWorkingDesignFileName := WorkingDesignFileName;

  Result := False;
  try
    if Procs.WideFileSize(FName) > 0 then
    begin
      if not OpenShowFromFile(FName) then
        Exit;
    end
    else
      StartNewShow;
  except
    Exit;
  end;

  Result := True;
  DesignChangeFlag := False;
  InitiateNewWorkingDesign;
  WorkingDesignFileName := FName;
  WorkingDesignIsReadOnly := Procs.WideIsReadOnlyFile(WorkingDesignFileName);
  UntitledDesignFile := False;
  UpdateMainFormCaption;
  WorkingOnNewDesignStarted(OldWorkingDesignFileName, WorkingDesignFileName);
end;

procedure TMainForm.OpenShowDialogShow(Sender: TObject);
//var
//  S: String;
begin
  {S := 'MM';
  SendMessage(GetParent(OpenShowDialog.Handle), CDM_SETCONTROLTEXT, IDOK,
    LongInt(PChar(S)));}
end;

procedure TMainForm.ProcessCommandLine;
begin
  if ParamCount = 1 then
  begin
    if FileExists(WideParamStr(1)) then
    begin
      WorkingDesignFileName := '';  //This is already set to '' in NewDesignMenuItem.Click at application startup
      if CanProceedToOpenDesign(WideParamStr(1)) then
        if OpenPresentationFile(WideParamStr(1)) then
          WorkingDesignUntitledCount := 0;
    end
    else
    begin
      WideMessageDlgSoundTop(Wideformat(Dyn_Texts[67] {'The presentation file %sdoesn''t exist.'}, [#13 + WideParamStr(1) + #13]) , mtError, [mbOK],0);
      Application.ProcessMessages;
    end;
  end;

  LicenseTimer.Enabled := License.CheckLicenseStatusFull;
end;

procedure TMainForm.LicenseTimerTimer(Sender: TObject);
begin
  //************************************
  if not License4.CheckLicenseStatus then
    Halt;
  //************************************
end;

function TMainForm.CreateEmptyLFGDesignFile(const FName: String; Width,
  Height: Integer): Boolean;
var
  Line1, Line2: String;
  i: Integer;
  S: TStringList;
begin
  Result := True;

  Line1 := '';
  Line2 := '';
  for i := 1 to Width do
  begin
    Line1 := Line1 + '0,';
    Line2 := Line2 + '=,';
  end;
  if Length(Line1) > 0 then
  begin
    Line1 := Copy(Line1, 1, Length(Line1) - 1);  //Remove additional comma
    Line2 := Copy(Line2, 1, Length(Line2) - 1);  //Remove additional comma
  end;

  S := TStringList.Create;
  S.Sorted := False;
  for i := 1 to Height do
    S.Append(Line1);
  S.Append(Line2);

  try
    S.SaveToFile(FName);
  except
    Result := False;
  end;
  S.Free;
end;

procedure TMainForm.LFGFileSizeWarningBtn1Click(Sender: TObject);
begin
  WideMessageDlgSound(Dyn_Texts[69] {'Size of the design file of the text is larger than the display area. The text is clipped.'}, mtWarning, [mbOK], 0);
end;

procedure TMainForm.HelpBtnClick(Sender: TObject);
begin
  //************************************
  if not License2.CheckLicenseStatusFull then
    Halt;
  if not LicenseTimer.Enabled then
    LicenseTimer.Enabled := True;
  //************************************

  SpecialProcs.PopupMenuAtControl(HelpBtn, HelpPopup);
end;

procedure TMainForm.LoadAreaSpecificSettings(const Area: TArea);
begin
  AreaDelaySpin.Value := Area.DelayTime;
  if Area.Color < AreaColorCombo.Items.Count then
    AreaColorCombo.ItemIndex := Area.Color
  else
    AreaColorCombo.ItemIndex := 0;

  //Load area border settings
  TopBorderLabel.Transparent := not Area.TopBorder;
  BottomBorderLabel.Transparent := not Area.BottomBorder;
  LeftBorderLabel.Transparent := not Area.LeftBorder;
  RightBorderLabel.Transparent := not Area.RightBorder;
  AreaBorderWidthSpin.Value := Area.BorderWidthHorizontal;
  //Area.BorderWidthVertical is always equal to Area.BorderWidthHorizontal in this version
  //Area.BordersFilled is loaded into the BorderStyleFormUnit form when necessary
end;

procedure TMainForm.OnLEDDisplaySettingsChanged;
var
  OldIndex: Integer;
begin
  OldIndex := AreaColorCombo.ItemIndex;

  AreaColorCombo.Items.Strings[0] := GlobalOptions.LEDDisplaySettings.Color1;
  AreaColorCombo.Items.Strings[1] := GlobalOptions.LEDDisplaySettings.Color2;
  AreaColorCombo.Items.Strings[2] := AreaColorCombo.Items.Strings[0] + WideString(' ') + Dyn_Texts[71] + WideString(' ') + AreaColorCombo.Items.Strings[1];

  AreaColorCombo.ItemIndex := OldIndex;

  AreaColorGroup.Visible := GlobalOptions.LEDDisplaySettings.ColorCount > 1;

  //Memory limit
  LED_DISPLAY_MEM_START_OFFSET := 4096;  //4KB used for fonts  -  in bytes
  if GlobalOptions.LEDDisplaySettings.CanSetAlarms then  //No need to check GlobalOptions.LEDDisplaySettings.AlarmCount value and allow the user to set any desired value
  begin
    if GlobalOptions.LEDDisplaySettings.AlarmSystem = as1MonthAlarmSystem then
    begin
      LED_DISPLAY_MEM_START_OFFSET := LED_DISPLAY_MEM_START_OFFSET + GlobalOptions.LEDDisplaySettings.AlarmCount * BYTES_PER_ALARM;  //BYTES_PER_ALARM = sizeof(TLDCAlarm) on the microcontroller program
    end
    else if GlobalOptions.LEDDisplaySettings.AlarmSystem = as12MonthAlarmSystem then
    begin
      LED_DISPLAY_MEM_START_OFFSET := LED_DISPLAY_MEM_START_OFFSET + 12 {12 Months} * GlobalOptions.LEDDisplaySettings.AlarmCount * BYTES_PER_ALARM;
    end;
  end;

  PrepareRightPanel;
end;

procedure TMainForm.ACWord1Enter(Sender: TObject);
begin
  (Sender as TEdit).SelLength := 0;
  if ISPrevSNEdit then
    (Sender as TEdit).SelStart := Length((Sender as TEdit).Text);
end;

procedure TMainForm.ACWord1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);

  procedure FocusNext;
  begin
    ISPrevSNEdit := False;
    SendMessage(Handle, WM_NEXTDLGCTL, 0, 0);
  end;

  procedure FocusPrev;
  begin
    ISPrevSNEdit := True;
    SendMessage(Handle, WM_NEXTDLGCTL, 1, 0);
  end;

begin
  if Shift <> [] then
    Exit;

  if ( (Key = VK_LEFT) or (Key = VK_UP) ) and ((Sender as TEdit).SelStart = 0) and
    (Sender <> ACWord1) then
    FocusPrev
  else if ( (Key = VK_RIGHT) or (Key = VK_DOWN) ) and ((Sender as TEdit).SelStart = Length((Sender as TEdit).Text)) and
    (Sender <> ACWord6) then
    FocusNext
  else if ( ((Sender as TEdit).SelStart = ((Sender as TEdit).MaxLength - 1) ) or  ((Sender as TEdit).SelStart = (Sender as TEdit).MaxLength) ) and
    (Sender <> ACWord6) and
    ( Procs.IsVKCodeALphaNumberic(Key) or (Key = VK_RIGHT) ) then
    FocusNext
  else if (Key = VK_BACK) and ((Sender as TEdit).SelStart = 0) and
    (Sender <> ACWord1) then
    FocusPrev;
end;

procedure TMainForm.ACWord1KeyPress(Sender: TObject; var Key: Char);
var
  CurPos: Integer;
  S: String;
begin
  if Ord(Key) = VK_RETURN then
    Key := Chr(0)
  else if (Ord(Key) >= 97) and
          (Ord(Key) <= 122) then
    Key := Chr(Ord(Key) - 32);  //Convert char to uppercase
  if (Length((Sender as TEdit).Text) = (Sender as TEdit).MaxLength) and
    (Ord(Key) >= 32) and (Ord(Key) <= 127) and
    ((Sender as TEdit).SelLength = 0) then
  begin
    CurPos := (Sender as TEdit).SelStart + 1;
    S := (Sender as TEdit).Text;
    S[CurPos] := Key;
    (Sender as TEdit).Text := S;
    (Sender as TEdit).SelStart := CurPos;
    Key := Chr(0);  //Prevent beep
  end;
end;

procedure TMainForm.ACWord1Paste(Sender: TObject);

  procedure FocusNext;
  begin
    ISPrevSNEdit := False;
    SendMessage(Handle, WM_NEXTDLGCTL, 0, 0);
  end;

begin
{ NOT IMPLEMENTED YET
  if ((Sender as TEdit).SelStart = (Sender as TEdit).MaxLength) and
    (Sender <> ACWord6) then
    FocusNext
}
end;

procedure TMainForm.MediaPlayer1Notify(Sender: TObject);
begin
  try
    if MediaPlayer1.NotifyValue = nvSuccessful then
      MediaPlayer1.Play;
  except
  end;
end;

procedure TMainForm.EditBorderStyleSpeedBtnClick(Sender: TObject);
var
  P: TPoint;
begin
  BorderStyleForm.TopBorder := not TopBorderLabel.Transparent;
  BorderStyleForm.BottomBorder := not BottomBorderLabel.Transparent;
  BorderStyleForm.LeftBorder := not LeftBorderLabel.Transparent;
  BorderStyleForm.RightBorder := not RightBorderLabel.Transparent;
  BorderStyleForm.AreaBorderWidth := AreaBorderWidthSpin.Value;
  BorderStyleForm.BordersFilled := DisplayStages[ActiveDisplayStage].Areas[ActiveAreaIndex].BordersFilled;

  P := AreaBorderGroup.Parent.ClientToScreen(Point(AreaBorderGroup.Left, AreaBorderGroup.Top + AreaBorderGroup.Height));
  BorderStyleForm.Top := P.Y;
  BorderStyleForm.Left := P.X;
  BorderStyleForm.Show;
end;

procedure TMainForm.TopBorderLabelClick(Sender: TObject);
begin
  (Sender as TsLabel).Transparent := not (Sender as TsLabel).Transparent;
end;

procedure TMainForm.CreateAndSetApplicationDefaultFolders;
begin
  GlobalOptions.MY_LED_DESIGNS_FOLDER_FULL_PATH := Procs.GetSpecialFolderPath(CSIDL_PERSONAL) + '\' + MY_LED_DESIGNS_FOLDER_NAME;
  GlobalOptions.MY_TEXT_DESIGNS_FOLDER_FULL_PATH := GlobalOptions.MY_LED_DESIGNS_FOLDER_FULL_PATH + '\' + MY_TEXT_DESIGNS_FOLDER_NAME;
  GlobalOptions.MY_PICTURE_DESIGNS_FOLDER_FULL_PATH := GlobalOptions.MY_LED_DESIGNS_FOLDER_FULL_PATH + '\' + MY_PICTURE_DESIGNS_FOLDER_NAME;

  //My LED Designs Directory
  if not WideDirectoryExists(GlobalOptions.MY_LED_DESIGNS_FOLDER_FULL_PATH) then
  begin
    if not WideCreateDir(GlobalOptions.MY_LED_DESIGNS_FOLDER_FULL_PATH) then
      GlobalOptions.MY_LED_DESIGNS_FOLDER_FULL_PATH := Procs.GetSpecialFolderPath(CSIDL_PERSONAL);
  end;
  if WideDirectoryExists(GlobalOptions.MY_LED_DESIGNS_FOLDER_FULL_PATH) then
  begin
    if not FileExists(GlobalOptions.MY_LED_DESIGNS_FOLDER_FULL_PATH + '\Desktop.ini') then
    begin
      try
        Procs.SetFolderIcon(GlobalOptions.MY_LED_DESIGNS_FOLDER_FULL_PATH, 'LED Display Control Designs', ApplicationPath + 'FolderIcon.ico', 0, True);
      except
      end;
    end;
  end;
  //Text Designs Directory
  if not WideDirectoryExists(GlobalOptions.MY_TEXT_DESIGNS_FOLDER_FULL_PATH) then
  begin
    if not WideCreateDir(GlobalOptions.MY_TEXT_DESIGNS_FOLDER_FULL_PATH) then
      GlobalOptions.MY_TEXT_DESIGNS_FOLDER_FULL_PATH := GlobalOptions.MY_LED_DESIGNS_FOLDER_FULL_PATH;
  end;
  //Picture Designs Directory
  if not WideDirectoryExists(GlobalOptions.MY_PICTURE_DESIGNS_FOLDER_FULL_PATH) then
  begin
    if not WideCreateDir(GlobalOptions.MY_PICTURE_DESIGNS_FOLDER_FULL_PATH) then
      GlobalOptions.MY_PICTURE_DESIGNS_FOLDER_FULL_PATH := GlobalOptions.MY_LED_DESIGNS_FOLDER_FULL_PATH;
  end;
end;

procedure TMainForm.GetDefaultPicturesList(
  var PictureList: TDefaultPictures);
var
  sl: TTntStringList;
  i, j: Integer;
  FSR: TSearchRecW;
  OtherPicturesList: TTntStringList;
  NewPic: Boolean;
  MainPicturesCount: Integer;
begin
  sl := TTntStringList.Create;
  if FileExists(ApplicationPath + PICTURES_FOLDER_NAME + '\' + PICTURES_FILE_NAME) then
    sl.LoadFromFile(ApplicationPath + PICTURES_FOLDER_NAME + '\' + PICTURES_FILE_NAME);
  SetLength(DefaultPictures, sl.Count div 2);  //2 lines for each entry (first line is the description, second line is the filename)
  for i := 0 to High(DefaultPictures) do
  begin
    DefaultPictures[i].Description := sl.Strings[i * 2];
    DefaultPictures[i].FileName := ApplicationPath + PICTURES_FOLDER_NAME + '\' + sl.Strings[i * 2 + 1];
  end;
  sl.Free;

  //Get list of other files not listed in the GIF_ANIMATIONS_FILE_NAME
  OtherPicturesList := TTntStringList.Create;
  if WideFindFirst(ApplicationPath + PICTURES_FOLDER_NAME + '\*.bmp', faAnyFile, FSR) = 0 then
  begin
    repeat
      if ((FSR.Attr and faSysFile)=0) and
         ((FSR.Attr and faSymLink)=0) and
         ((FSR.Attr and faVolumeID)=0) then
      begin
        if ((FSR.Attr and faDirectory) = 0) and
           (FSR.Name[1] <> '.') then
        begin
          if WideFileExists(ApplicationPath + PICTURES_FOLDER_NAME + '\' + FSR.Name) then
            OtherPicturesList.Append(ApplicationPath + PICTURES_FOLDER_NAME + '\' + FSR.Name);
        end;
      end;
    until WideFindNext(FSR)<>0;
  end;
  WideFindClose(FSR);

  //Add other animations to the AnimList
  OtherPicturesList.Sorted := True;
  MainPicturesCount := Length(PictureList);
  for i := 0 to OtherPicturesList.Count - 1 do
  begin
    NewPic := True;
    for j := 0 to MainPicturesCount - 1 do
      if PictureList[j].FileName = OtherPicturesList.Strings[i] then
      begin
        NewPic := False;
        Break;
      end;
    if NewPic then
    begin
      SetLength(PictureList, Length(PictureList) + 1);
      PictureList[High(PictureList)].FileName := OtherPicturesList.Strings[i];
      PictureList[High(PictureList)].Description := Copy(WideExtractFileName(OtherPicturesList.Strings[i]), 1, Length(WideExtractFileName(OtherPicturesList.Strings[i])) - Length(WideExtractFileExt(OtherPicturesList.Strings[i])));
    end;
  end;
  OtherPicturesList.Free;
end;

procedure TMainForm.UseDefaultPicturesRadioClick(Sender: TObject);
begin
  DefaultPicturesCombo.Enabled := UseDefaultPicturesRadio.Checked;
  //InvertDefaultPictureCheck.Enabled := UseDefaultPicturesRadio.Checked;
  //ImportPictureBtn.Enabled := ImportNewPictureRadio.Checked;

  if DefaultPicturesCombo.Enabled then
    DefaultPicturesCombo.OnChange(DefaultPicturesCombo);
end;

procedure TMainForm.DefaultPicturesComboChange(Sender: TObject);

  procedure RestoreOldItemIndex;
  begin
    if (DefaultPicturesCombo.Tag <> DefaultPicturesCombo.ItemIndex) and
       (DefaultPicturesCombo.Tag < DefaultPicturesCombo.Items.Count) then
    begin
      DefaultPicturesCombo.ItemIndex := DefaultPicturesCombo.Tag;  //Restore old ItemIndex
      DefaultPicturesCombo.OnChange(DefaultPicturesCombo);
    end;
  end;

var
  FName: WideString;
begin
  Exit;  //--> Not used in this version - changed to a form

  if UseDefaultPicturesRadio.Checked and
     (DefaultPicturesCombo.Items.Count > 0) and
     (DefaultPicturesCombo.ItemIndex >= 0) then
  begin
    FName := DefaultPictures[DefaultPicturesCombo.ItemIndex].FileName;
    if not WideFileExists(FName) then
    begin
      WideMessageDlgSound(Dyn_Texts[72] {'File of the selected picture cannot be found.'}, mtError, [mbOK], 0);
      RestoreOldItemIndex;
      Exit;
    end;

    try
      WideLoadBitmapImageFormFile(FName, PicturePreviewImage.Picture.Bitmap);
      //PicturePreviewImage.Picture.Bitmap.LoadFromFile(FName);
    except
      WideMessageDlgSound(Dyn_Texts[73] {'Invalid picture file.'}, mtError, [mbOK], 0);
      PicturePreviewImage.Hide;
      RestoreOldItemIndex;
      Exit;
    end;

    PicturePreviewImage.Show;  //It may be hidden

    PicturePreviewImage.Stretch := True;

    PictureWidthLabel.Caption := IntToStr(PicturePreviewImage.Picture.Bitmap.Width);
    PictureHeightLabel.Caption := IntToStr(PicturePreviewImage.Picture.Bitmap.Height);
    DisplayStages[ActiveDisplayStage].Areas[ActiveAreaIndex].PictureAvailable := True;

    DefaultPicturesCombo.Tag := DefaultPicturesCombo.ItemIndex;  //Store ItemIndex

    DesignChangeFlag := True;

    UpdatePicturePicturePreview;
  end;
end;

function TMainForm.CommunicationWithLEDDisplayAllowed(ShowErrMessage: Boolean): Boolean;
begin
  Result := (GetTickCount - LastChangeDisplayTickCount) >= LED_DISPLAY_CHANGE_WAIT;
  if not Result and ShowErrMessage then
    WideShowMessageSoundTop(Dyn_Texts[76] {'The LED Display is processing the received data and cannot be used for now. Please wait a few seconds.'});
end;

procedure TMainForm.ApplicationEvents1ShortCut(var Msg: TWMKey;
  var Handled: Boolean);
var
  ShiftState: TShiftState;
begin
  ShiftState := KeyDataToShiftState(Msg.KeyData);
  Handled := False;
  (*SHORTCUTS:
  Ctrl+N: New Show: On MainForm
  Ctrl+O: Open: On MainForm
  Ctrl+S: Save: On MainForm
  Ctrl+Shift+S: Save As: On MainForm
  Ctrl+Q: Add New Stage: On MainForm

  F1:  Help: On MainForm
  F6:  Open LED Font Generator: On MainForm
  F7:  Program Options: On MainForm
  F8:  Set Alarms: On MainForm
  F9:  Set LED Display Date and Time: On MainForm
  F10: Change LED Display Data: On MainForm
  F11: LED Display Settings: On MainForm
  F12: Change Display Stage Layout: On MainForm
  Ctrl+F12: Select Page Effect: On MainForm
  *)

  //----------------------------------------
  //Ctrl+N, Ctrl+O, Ctrl+S, Ctrl+Q, Ctrl+F12
  if ShiftState = [ssCtrl] then
  begin
    Handled := True;
    case Msg.CharCode of
      Ord('N'):  if MainForm.Active then NewShowBtn.Click;
      Ord('O'):  if MainForm.Active then OpenBtn.Click;
      Ord('S'):  if MainForm.Active then SaveBtn.Click;
      Ord('Q'):  if MainForm.Active then AddNewStageBtn.Click;
      VK_F12:    if MainForm.Active then SelectPageEffectBtn.Click;
      else
        Handled := False;
    end;
  end;

  //----------------------------------------
  //Ctrl+Shift+S
  if ShiftState = [ssCtrl, ssShift] then
  begin
    Handled := True;
    case Msg.CharCode of
      Ord('S'):  if MainForm.Active then SaveAsMenuItem.Click;
      else
        Handled := False;
    end;
  end;

  //----------------------------------------
  //F6, F7, F8, F9, F10, F11, F12
  if ShiftState = [] then
  begin
    Handled := True;
    case Msg.CharCode of
      VK_F1:   if MainForm.Active then HelpBtn.Click;
      VK_F6:   if MainForm.Active then GotoLFGBtn.Click;
      VK_F7:   if MainForm.Active then ProgramOptionsBtn.Click;
      VK_F8:   if MainForm.Active then SetAlarmsBtn.Click;
      VK_F9:   if MainForm.Active then SetDateTimeBtn.Click;
      VK_F10:  if MainForm.Active then ChangeLEDDisplayDataBtn.Click;
      VK_F11:  if MainForm.Active then ChangeLEDDisplaySettingsBtn.Click;
      VK_F12:  if MainForm.Active then SelectLayoutBtn.Click;
      else
        Handled := False;
    end;
  end;

  //Hidden shortcut: Ctrl+Shift+F4 (Save Data to File instead of sending via serial port)
  if (Msg.CharCode = VK_F4) and (ShiftState = [ssShift, ssCtrl]) then
    if MainForm.Active then ChangeLEDDisplayData(1, True, False);
  //Hidden shortcut: Ctrl+Shift+F3 (Open Data from a File and send to the LED Display via serial port)
  if (Msg.CharCode = VK_F3) and (ShiftState = [ssShift, ssCtrl]) then
    if MainForm.Active then ChangeLEDDisplayData(1, False, True);
end;

procedure TMainForm.TemporaryLEDDisplaySettingsMode(ModeOn: Boolean);
begin
  //Don't disable anything and allow to even send data to the LED Display.
  {
  ChangeLEDDisplayDataBtn.Enabled := not ModeOn;
  if ModeOn then
    SetAlarmsBtn.Enabled := False
  else
    SetAlarmsBtn.Enabled := GlobalOptions.LEDDisplaySettings.CanSetAlarms and
                            (GlobalOptions.LEDDisplaySettings.AlarmCount > 0) and  //Prevent potential software bugs by also checking the value of AlarmCount and AlarmSystem
                            (GlobalOptions.LEDDisplaySettings.AlarmSystem in [Low(TAlarmSystem)..High(TAlarmSystem)]);
  }
end;

procedure TMainForm.HighGUIInitialize;
begin
  SetLength(HighGUIItems, 40);

  //TimeContentPanel
  HighGUIItems[0] := TimeLanguageGroup;
  HighGUIItems[1] := TimeFormatGroup;
  HighGUIItems[2] := TimeTypeGroup;
  HighGUIItems[3] := TimeTimeGroupBox;
  //DateContentPanel
  HighGUIItems[4] := DateLanguageGroup;
  HighGUIItems[5] := DateFormatGroup;
  HighGUIItems[6] := DateTypeGroup;
  HighGUIItems[7] := DateTimeGroupBox;
  //ScrollingTextContentPanel
  HighGUIItems[8] := SimpleTextGroupBox;
  HighGUIItems[9] := AdvancedTextGroupBox;
  HighGUIItems[10] := TextTypeGroupBox;
  HighGUIItems[11] := TextFontGroupBox;
  HighGUIItems[12] := TextTimeGroupBox;
  HighGUIItems[13] := TextMovementGroupBox;
  HighGUIItems[14] := TextEffectsGroupBox;
  //AnimationContentPanel
  HighGUIItems[15] := AnimationListGroupBox;
  HighGUIItems[16] := AnimationPreviewGroup;
  HighGUIItems[17] := AnimationDisplaySettingsGroup;
  HighGUIItems[18] := AnimationTimeGroup;
  //PictureContentPanel
  HighGUIItems[19] := SimplePictureGroupBox;
  HighGUIItems[20] := AdvancedPictureGroupBox;
  HighGUIItems[21] := PictureTypeGroupBox;
  HighGUIItems[22] := PicturePreviewGroupBox;
  HighGUIItems[23] := PictureTimeGroupBox;
  HighGUIItems[24] := PictureMovementGroupBox;
  HighGUIItems[25] := PictureEffectsGroupBox;
  //TemperatureContentPanel
  HighGUIItems[26] := TemperatureLanguageGroup;
  HighGUIItems[27] := TemperatureUnitGroup;
  HighGUIItems[28] := TemperatureDisplayGroupBox;
  HighGUIItems[29] := TemperatureTimeGroupBox;
  //EmptyContentPanel
  HighGUIItems[30] := EmptyDisplayGroupBox;
  HighGUIItems[31] := EmptyTimeGroupBox;
  //TitlePanel
  HighGUIItems[32] := AreaDelayGroup;
  HighGUIItems[33] := AreaColorGroup;
  HighGUIItems[34] := AreaBorderGroup;
  HighGUIItems[35] := AreaPreviewGroup;
  //SWFContentPanel
  HighGUIItems[36] := SWFDisplaySettingsGroup;
  HighGUIItems[37] := SWFTimeGroupBox;
  HighGUIItems[38] := SWFPreviewGroupBox;
  HighGUIItems[39] := SWFSWFSettingsGroup;
end;

procedure TMainForm.HighGUIUpdateState(SelfForm: TCustomForm;
  HighGUITimer: TTimer; HighGUIItems: THighGUIItems);
  function PointIsInRect(P: TPoint; R: TRect): Boolean;
  begin
    Result := False;
    if (P.X < R.Left) or (P.X > R.Right) then Exit;
    if (P.Y < R.Top) or (P.Y > R.Bottom) then Exit;
    Result := True;
  end;

var
  MP, P: TPoint;
  R: TRect;
  i: Integer;
  sGroupBox: TsGroupBox;
begin
  if not SelfForm.Active or not SelfForm.Enabled or
     (HighGUITimer.Tag = 0) or
     GlobalOptions.DontUseHighGUI then
  begin
    for i := 0 to High(HighGUIItems) do
      HighGUISetInactive(HighGUIItems[i]);
    Exit;
  end;
  MP := Mouse.CursorPos;
  for i := 0 to High(HighGUIItems) do
  begin
    if HighGUIItems[i] is TsGroupBox then
    begin
      sGroupBox := HighGUIItems[i] as TsGroupBox;
      P := sGroupBox.Parent.ClientToScreen(Point(sGroupBox.Left, sGroupBox.Top));
      R.TopLeft := P;
      R.Right := R.Left + sGroupBox.Width - 1;
      R.Bottom := R.Top + sGroupBox.Height - 1;
      if PointIsInRect(MP, R) and sGroupBox.Visible and sGroupBox.Enabled then
        HighGUISetActive(sGroupBox)
      else
        HighGUISetInactive(sGroupBox);
    end;
  end;
end;

procedure TMainForm.HighGUISetActive(Component: TComponent);
begin
  if Component is TsGroupBox then
  begin
    with Component as TsGroupBox do
    begin
      SkinData.SkinSection := HighGUISkinInfo.HighGUIGroupBoxSkinSection;
      CaptionSkin := HighGUISkinInfo.HighGUIGroupBoxCaptionSkin;
    end;
  end;
end;

procedure TMainForm.HighGUISetInactive(Component: TComponent);
begin
  if Component is TsGroupBox then
  begin
    with Component as TsGroupBox do
    begin
      SkinData.SkinSection := 'GROUPBOX';
      CaptionSkin := '';
    end;
  end;
end;

procedure TMainForm.HighGUITimerTimer(Sender: TObject);
begin
  //////////////////////////////////////////////////////////////
  //License: Don't use HighGUI when RegistrationPanel is visible
  if RuntimeGlobalOptions.HighGUIDeactivatedByLicense then
    Exit;
  //////////////////////////////////////////////////////////////

  HighGUITimer.Enabled := False;
  if HighGUITimer.Tag = 0 then
    Exit;
  try
    HighGUIUpdateState(Self, HighGUITimer, HighGUIItems);
  finally
    HighGUITimer.Enabled := HighGUITimer.Tag = 1;
  end;
end;

procedure TMainForm.HighGUIOnSkinChanged;
begin
  HighGUISkinInfo.HighGUIGroupBoxSkinSection := HighGUISkinsInfo[GetSkinNumber].HighGUIGroupBoxSkinSection;
  HighGUISkinInfo.HighGUIGroupBoxCaptionSkin := HighGUISkinsInfo[GetSkinNumber].HighGUIGroupBoxCaptionSkin;
end;

procedure TMainForm.sSkinManager1AfterChange(Sender: TObject);
begin
  HighGUIOnSkinChanged;
end;

procedure TMainForm.ApplySkinExceptions;
var
  MenuPanelSkin, LayoutButtonSkin: String;
  ChangeLEDDisplaySettingsBtnSkin: String;
  SelectLayoutBtnSkin, SelectPageEffectBtnSkin: String;
  PopupFormsMainPanelSkin: String;
  WaitFormMainPanelSkin: String;

  UnselectedStagePanelNormalSkin: String;
  UnselectedStagePanelDisabledSkin: String;
  SelectedStagePanelNormalSkin: String;
  SelectedStagePanelDisabledSkin: String;

  FontSamplePanelSkin: String;
begin
  MenuPanelSkin := 'PROGRESSH';
  LayoutButtonSkin := 'PROGRESSH';
  ChangeLEDDisplaySettingsBtnSkin := 'SCROLLBTNRIGHT';
  SelectLayoutBtnSkin := 'SPEEDBUTTON';
  SelectPageEffectBtnSkin := 'SPEEDBUTTON';
  PopupFormsMainPanelSkin := 'PROGRESSH';
  WaitFormMainPanelSkin := 'DIALOG';

  UnselectedStagePanelNormalSkin := 'PANEL';
  UnselectedStagePanelDisabledSkin := 'TOOLBUTTON';
  SelectedStagePanelNormalSkin := 'ALPHACOMBOBOX';
  SelectedStagePanelDisabledSkin := 'COMBOBOX';

  FontSamplePanelSkin := 'TOOLBUTTON';

  if sSkinManager1.SkinName = 'WLM (internal)' then
  begin
    PopupFormsMainPanelSkin := 'SCROLLSLIDERH';

    UnselectedStagePanelNormalSkin := 'PANEL';
    UnselectedStagePanelDisabledSkin := 'ALPHACOMBOBOX';
    SelectedStagePanelNormalSkin := 'BAR';
    SelectedStagePanelDisabledSkin := 'STATUSBAR';
  end
  else if sSkinManager1.SkinName = 'LongHorn (internal)' then
  begin
    SelectLayoutBtnSkin := 'GROUPBOX';
    SelectPageEffectBtnSkin := SelectLayoutBtnSkin;
    WaitFormMainPanelSkin := 'SCROLLBTNLEFT';

    UnselectedStagePanelNormalSkin := 'BUTTON_BIG';
    //UnselectedStagePanelDisabledSkin := 'ALPHACOMBOBOX';
    SelectedStagePanelNormalSkin := 'GAUGE';
    SelectedStagePanelDisabledSkin := 'COMBOBOX';

    FontSamplePanelSkin := 'MENULINE';
  end
  else if sSkinManager1.SkinName = 'Neutral (internal)' then
  begin
    MenuPanelSkin := 'FORMTITLE';
    LayoutButtonSkin := 'PROGRESSH';
    PopupFormsMainPanelSkin := 'TOOLBAR';
    WaitFormMainPanelSkin := 'SCROLLBTNLEFT';

    UnselectedStagePanelNormalSkin := 'PANEL';
    UnselectedStagePanelDisabledSkin := 'TOOLBUTTON';
    SelectedStagePanelNormalSkin := 'COMBOBOX';
    SelectedStagePanelDisabledSkin := 'ALPHACOMBOBOX';

    FontSamplePanelSkin := 'MENUITEM';
  end
  else if sSkinManager1.SkinName = 'Neutral3 (internal)' then
  begin
    MenuPanelSkin := 'SPLITTER';
    LayoutButtonSkin := 'MENUITEM';
    PopupFormsMainPanelSkin := 'MAINMENU';

    UnselectedStagePanelNormalSkin := 'PANEL';
    UnselectedStagePanelDisabledSkin := 'MENUITEM';
    SelectedStagePanelNormalSkin := 'COMBOBOX';
    SelectedStagePanelDisabledSkin := 'ALPHACOMBOBOX';

    FontSamplePanelSkin := 'MENULINE';
  end
  else if sSkinManager1.SkinName = 'Neutral4 (internal)' then
  begin
    MenuPanelSkin := 'BARTITLE';
    ChangeLEDDisplaySettingsBtnSkin := 'SPEEDBUTTON';
    LayoutButtonSkin := 'MENUITEM';
    PopupFormsMainPanelSkin := 'MAINMENU';
    WaitFormMainPanelSkin := 'TOOLBAR';

    UnselectedStagePanelNormalSkin := 'PANEL';
    UnselectedStagePanelDisabledSkin := 'TOOLBUTTON';
    SelectedStagePanelNormalSkin := 'COMBOBOX';
    SelectedStagePanelDisabledSkin := 'MAINMENU';

    FontSamplePanelSkin := 'SPLITTER';
  end
  else if sSkinManager1.SkinName = 'TheFrog (internal)' then
  begin
    MenuPanelSkin := 'DIALOG';
    //ChangeLEDDisplaySettingsBtnSkin := 'SPEEDBUTTON';
    LayoutButtonSkin := 'MENUITEM';
    PopupFormsMainPanelSkin := 'MAINMENU';

    UnselectedStagePanelNormalSkin := 'PANEL';
    UnselectedStagePanelDisabledSkin := 'TOOLBUTTON';
    SelectedStagePanelNormalSkin := 'COMBOBOX';
    SelectedStagePanelDisabledSkin := 'TABBOTTOM';
  end
  else if sSkinManager1.SkinName = 'Wood (internal)' then
  begin
    MenuPanelSkin := 'ALPHAEDIT';
    ChangeLEDDisplaySettingsBtnSkin := 'SPEEDBUTTON';
    LayoutButtonSkin := 'MENUITEM';
    PopupFormsMainPanelSkin := 'TOOLBAR';
    WaitFormMainPanelSkin := 'MAINMENU';

    UnselectedStagePanelNormalSkin := 'PANEL';
    UnselectedStagePanelDisabledSkin := 'MENUITEM';
    SelectedStagePanelNormalSkin := 'SPLITTER';
    SelectedStagePanelDisabledSkin := 'SPEEDBUTTON';

    FontSamplePanelSkin := 'EDIT';
  end;

  //Now apply settings
  MenuPanel.SkinData.SkinSection := MenuPanelSkin;
  ChangeLEDDisplaySettingsBtn.SkinData.SkinSection := ChangeLEDDisplaySettingsBtnSkin;

  RuntimeGlobalOptions.LayoutButtonSkin := LayoutButtonSkin;
  LayoutBtn1.SkinData.SkinSection := RuntimeGlobalOptions.LayoutButtonSkin;
  LayoutBtn2.SkinData.SkinSection := RuntimeGlobalOptions.LayoutButtonSkin;
  LayoutBtn3.SkinData.SkinSection := RuntimeGlobalOptions.LayoutButtonSkin;
  LayoutBtn4.SkinData.SkinSection := RuntimeGlobalOptions.LayoutButtonSkin;

  SelectLayoutBtn.SkinData.SkinSection := SelectLayoutBtnSkin;
  SelectPageEffectBtn.SkinData.SkinSection := SelectPageEffectBtnSkin;

  RuntimeGlobalOptions.PopupFormsMainPanelSkin := PopupFormsMainPanelSkin;
  RuntimeGlobalOptions.WaitFormMainPanelSkin := WaitFormMainPanelSkin;

  RuntimeGlobalOptions.UnselectedStagePanelNormalSkin := UnselectedStagePanelNormalSkin;
  RuntimeGlobalOptions.UnselectedStagePanelDisabledSkin := UnselectedStagePanelDisabledSkin;
  RuntimeGlobalOptions.SelectedStagePanelNormalSkin := SelectedStagePanelNormalSkin;
  RuntimeGlobalOptions.SelectedStagePanelDisabledSkin := SelectedStagePanelDisabledSkin;

  FontSamplePanel.SkinData.SkinSection := FontSamplePanelSkin;
  FavoriteFontSamplePanel.SkinData.SkinSection := FontSamplePanelSkin;
end;

procedure TMainForm.ApplicationEvents1Deactivate(Sender: TObject);
begin
  try  //Prevent potential software bugs
    if ScheduleStageForm.Visible then
      ScheduleStageForM.Close;
  except
  end;
  HighGUITimer.Tag := 0;  //Means Disabled
  HighGUIUpdateState(Self, HighGUITimer, HighGUIItems);
end;

procedure TMainForm.sSkinManager1BeforeChange(Sender: TObject);
begin
  ApplySkinExceptions;
end;

procedure TMainForm.PreviewPanelResize(Sender: TObject);
begin
  ProgressGroup.Left := Trunc(ContentPreviewPanel.Width / 2 - ProgressGroup.Width / 2);
  with TextPreviewPanel do
  begin
    Width := ContentPreviewPanel.Width - 44;
    Height := ContentPreviewPanel.Height - 30;
    Left := Trunc((ContentPreviewPanel.Width - Width) / 2);
    Top := Trunc((ContentPreviewPanel.Height - Height) / 2) + 4;
  end;
  PicturePreviewPanel.BoundsRect := TextPreviewPanel.BoundsRect;
  TimePreviewPanel.BoundsRect := TextPreviewPanel.BoundsRect;
  DatePreviewPanel.BoundsRect := TextPreviewPanel.BoundsRect;
  TemperaturePreviewPanel.BoundsRect := TextPreviewPanel.BoundsRect;
  EmptyPreviewPanel.BoundsRect := TextPreviewPanel.BoundsRect;
end;

procedure TMainForm.PrepareRightPanel;
  procedure SetContentBtnPosition(ContentBtn: TsSpeedButton;
    var NextBtnTop: Integer);
  begin
    ContentBtn.Top := NextBtnTop;
    if ContentBtn.Visible then
      NextBtnTop := NextBtnTop + ContentBtn.Height;
  end;

  procedure PrepareMenuBarPanel(AlarmButtonVisible: Boolean);
  var
    MenuBarWidth: Integer;
  begin
    //Only SetAlarmsBtn can be removed from the MenuBarPanel in this version
    MenuBarWidth := MenuBarPanel.Width;
    if AlarmButtonVisible and not SetAlarmsBtn.Visible then
      MenuBarWidth := MenuBarWidth + SetAlarmsBtn.Width
    else if not AlarmButtonVisible and SetAlarmsBtn.Visible then
      MenuBarWidth := MenuBarWidth - SetAlarmsBtn.Width;

    SetAlarmsBtn.Visible := AlarmButtonVisible;
    if MenuBarWidth <> MenuBarPanel.Width then
    begin
      if SetAlarmsBtn.Visible then
      begin
        SetDateTimeBtn.Left := SetAlarmsBtn.Left + SetAlarmsBtn.Width - 1;
      end
      else
      begin
        SetDateTimeBtn.Left := SetAlarmsBtn.Left;
      end;

      ChangeLEDDisplayDataBtn.Left := SetDateTimeBtn.Left + SetDateTimeBtn.Width - 1;
      NewShowBtn.Left  := ChangeLEDDisplayDataBtn.Left + ChangeLEDDisplayDataBtn.Width - 1;
      SaveBtn.Left := NewShowBtn.Left + NewShowBtn.Width - 1;
      OpenBtn.Left := SaveBtn.Left;
      SaveDropDownBtn.Left := SaveBtn.Left + SaveBtn.Width - 1;
      OpenDropDownBtn.Left := SaveDropDownBtn.Left;

      MenuBarPanel.Width := MenuBarWidth;
      if Assigned(MenuPanel.OnResize) then
        MenuPanel.OnResize(MenuPanel);
    end;
  end;

var
  NextBtnTop: Integer;
begin
  with GlobalOptions.LEDDisplaySettings do
  begin
    TimeContentBtn.Visible := CanShowDateTime;
    DateContentBtn.Visible := CanShowDateTime;
    TemperatureContentBtn.Visible := CanShowTemperature;
    ScrollingTextContentBtn.Visible := CanShowScrollingText;
    AnimationContentBtn.Visible := CanShowAnimation;
    PictureContentBtn.Visible := CanShowPicture;
    SWFContentBtn.Visible := CanShowSWFFiles;

    //TextEffectsGroupBox.Enabled := CanShowTextEffects;  --> Allow to use inverted display if no effects is enabled
    TextEntranceEffectCheck.Enabled := CanShowTextEffects;

    //PictureEffectsGroupBox.Enabled := CanShowTextEffects;  --> Allow to use inverted display if no effects is enabled
    PictureEntranceEffectCheck.Enabled := CanShowTextEffects;

    PageEffectsPanel.Visible := CanShowPageEffects;
    SelectPageEffectBtn.Enabled := CanShowPageEffects;
    SelectPageEffectMenuItem.Visible := CanShowPageEffects;
    StageEffectsLabel1.Visible := CanShowPageEffects;
    StageEffectsLabel2.Visible := CanShowPageEffects;
    StageEffectsLabel3.Visible := CanShowPageEffects;
    EffectsSpeedTrackbar.Visible := CanShowPageEffects;


    LayoutPanel.Visible := CanChangePageLayout;
    SelectLayoutBtn.Enabled := CanChangePageLayout;
    SelectLayoutMenuItem.Visible := SelectLayoutBtn.Enabled;
    NextLayoutBtn.Enabled := SelectLayoutBtn.Enabled;
    PreviousLayoutBtn.Enabled := SelectLayoutBtn.Enabled;
    LayoutBtn1.Enabled := SelectLayoutBtn.Enabled;
    LayoutBtn2.Enabled := SelectLayoutBtn.Enabled;
    LayoutBtn3.Enabled := SelectLayoutBtn.Enabled;
    LayoutBtn4.Enabled := SelectLayoutBtn.Enabled;

    {$if Defined(_ALARM_TYPE_ONLY_1_MONTH) or Defined(_ALARM_TYPE_12_MONTHS) or Defined(_ALARM_TYPE_ALL_TYPES_)}
    PrepareMenuBarPanel(CanSetAlarms and (AlarmCount > 0));  //Prevent potential software bugs by also checking the value of AlarmCount
    //This does not depend on the value of AlarmSystem
    {$else}
    PrepareMenuBarPanel(False);  //No alarm is shown
    SetAlarmsBtn.Enabled := False;
    {$ifend}

    ScheduleStageBtn.Visible := CanSetTimeSpan;
    //AnimationLineSummaryBtn.Left := IfThen(ScheduleStageBtn.Visible, 174, ScheduleStageBtn.Left);
    ScheduleStageMenuItem.Visible := CanSetTimeSpan;
    SortAnimationLineByTimeMenuItem.Visible := CanSetTimeSpan;

    if Assigned(PreviewPanel.OnResize) then
      PreviewPanel.OnResize(PreviewPanel);
  end;

  NextBtnTop := ContentControls[Integer(ctTime)].OriginalPositionInRightPanel.Y;

  SetContentBtnPosition(TimeContentBtn, NextBtnTop);
  SetContentBtnPosition(DateContentBtn, NextBtnTop);
  SetContentBtnPosition(ScrollingTextContentBtn, NextBtnTop);
  SetContentBtnPosition(SWFContentBtn, NextBtnTop);
  SetContentBtnPosition(AnimationContentBtn, NextBtnTop);
  SetContentBtnPosition(PictureContentBtn, NextBtnTop);
  SetContentBtnPosition(TemperatureContentBtn, NextBtnTop);
  SetContentBtnPosition(EmptyContentBtn, NextBtnTop);

  if AreaColorGroup.Visible then
  begin
    AreaPreviewGroup.Left := 396;
  end
  else
  begin
    AreaPreviewGroup.Left := AreaColorGroup.Left;
  end;
end;

procedure TMainForm.ScheduleStageBtnClick(Sender: TObject);
var
  P: TPoint;
begin
  P := StageOptionsPanel.Parent.ClientToScreen(Point(ScheduleStageBtn.Left, ScheduleStageBtn.Top));
  if (P.Y - ScheduleStageForm.Height) >= 0 then
    ScheduleStageForm.Top := P.Y - ScheduleStageForm.Height
  else
    ScheduleStageForm.Top := p.Y + ScheduleStageBtn.Height;
  if (P.X - ScheduleStageForm.Width) < Screen.Width then
    ScheduleStageForm.Left := P.X
  else
    ScheduleStageForm.Left := P.X - ScheduleStageForm.Width;

  with ScheduleStageForm do
  begin
    HourFrom := DisplayStages[ActiveDisplayStage].HourFrom;
    MinuteFrom := DisplayStages[ActiveDisplayStage].MinuteFrom;
    HourTo := DisplayStages[ActiveDisplayStage].HourTo;
    MinuteTo := DisplayStages[ActiveDisplayStage].MinuteTo;
    OnlyDonNotShowDuringTimeSpan := DisplayStages[ActiveDisplayStage].OnlyDoNotShowDuringTimeSpan;
    DisplayInSpecificDate := DisplayStages[ActiveDisplayStage].DisplayInSpecificDate;
    Year := DisplayStages[ActiveDisplayStage].Year;
    Month := DisplayStages[ActiveDisplayStage].Month;
    Day := DisplayStages[ActiveDisplayStage].Day;
  end;
  ScheduleStageForm.Show;

  {
  if ScheduleStageForm.ShowModal = mrOk then
  begin
    //Store new settings
    with ScheduleStageForm do
    begin
      DisplayStages[ActiveDisplayStage].HourFrom := HourFrom;
      DisplayStages[ActiveDisplayStage].MinuteFrom := MinuteFrom;
      DisplayStages[ActiveDisplayStage].HourTo := HourTo;
      DisplayStages[ActiveDisplayStage].MinuteTo := MinuteTo;
    end;
  end;

  RefreshStagePanels;
  }
end;

procedure TMainForm.ScheduleStageMenuItemClick(Sender: TObject);
begin
  ScheduleStageBtn.Click;
end;

function TMainForm.TimeSpanDefined(HourFrom, MinuteFrom, HourTo,
  MinuteTo: Integer): Boolean;
begin
  Result := (HourFrom <> HourTo) or
            (MinuteFrom <> MinuteTo);
end;

procedure TMainForm.InputTextEnter(Sender: TObject);
begin
  //This event should change the keyboard language appropriately
  //NOT IMPLEMENTED YET CORRECTLY
  {
  InputText.BiDiMode := SetCorrectKeyboardLayout;

  //Force to change the language
  InputText.SetFocus;
  SendMessage(InputText.Handle, WM_SETFOCUS, 0, 0);
  try
    //AreaDelaySpin.SetFocus;
  except
  end;
  Application.ProcessMessages;

  InputText.SetFocus;
  }
end;

procedure TMainForm.Image10Click(Sender: TObject);
begin
  TextDirectionLeftRadio.SetFocus;  //This also sets TextDirectionLeftRadio.Checked to True
  TextDirectionLeftRadio.Checked := True;
end;

procedure TMainForm.Image9Click(Sender: TObject);
begin
  TextDirectionRightRadio.SetFocus;  //This also sets TextDirectionRightRadio.Checked to True
  TextDirectionRightRadio.Checked := True;
end;

procedure TMainForm.PictureEntranceEffectImageClick(Sender: TObject);
begin
  SelectPictureEntranceEffectBtn.Click;
end;

procedure TMainForm.TextEntranceEffectImageClick(Sender: TObject);
begin
  SelectTextEntranceEffectBtn.Click;
end;

function TMainForm.AnimSpeedToGIFAnimationSpeed(
  AnimSpeed: Integer): Integer;
begin
  Result := Trunc((255 - AnimSpeed) * 100 / 128 * 1.6);  //128 is the normal speed
end;

procedure TMainForm.SystemFontsSectionChange(Sender: TObject);
begin
  if Assigned(InputText.OnDelayedChange) then
    InputText.OnDelayedChange(InputText);
end;

procedure TMainForm.WideLoadGIFImageFromFile(GIFFileName: WideString;
  GIFImage: TGIFImage);
var
  fs: TTntFileStream;
begin
  fs := TTntFileStream.Create(GIFFileName, fmOpenRead);
  try
    GIFImage.LoadFromStream(fs);
  finally
    fs.Free;
  end;
end;

procedure TMainForm.WideLoadBitmapImageFormFile(
  BitmapImageFileName: WideString; Bitmap: TBitmap);
var
  fs: TTntFileStream;
begin
  fs := TTntFileStream.Create(BitmapImageFileName, fmOpenRead);
  try
    Bitmap.LoadFromStream(fs);
  finally
    fs.Free;
  end;
end;

procedure TMainForm.PlaySound(SoundItem: TSoundItem);
var
  SoundItemFileName: WideString;
begin
  SoundItemFileName := '';
  case SoundItem of
    siLEDDisplayDataChangeFinished:
      if Length(GlobalOptions.SoundOptions.LEDDisplayDataChangeFinishedSoundFileName) > 0 then  //If sound is set
        SoundItemFileName := GlobalOptions.SoundOptions.LEDDisplayDataChangeFinishedSoundFileName;
  end;

  if FileExists(SoundItemFileName) then
  begin
    try
      SoundItemMediaPlayer.FileName := SoundItemFileName;
      SoundItemMediaPlayer.Open;
      SoundItemMediaPlayer.Play;
    except
    end;
  end;
end;

procedure TMainForm.SoundItemMediaPlayerNotify(Sender: TObject);
begin
  try
    if SoundItemMediaPlayer.NotifyValue = nvSuccessful then
      SoundItemMediaPlayer.Close;
  except
  end;
end;

procedure TMainForm.OnNewStagePanelAdded;
begin
  if GlobalOptions.SelectPageEffectOnNewStage then
    SelectPageEffectBtn.Click;
  if GlobalOptions.SelectPageLayoutOnNewStage then
    SelectLayoutBtn.Click;
end;

procedure TMainForm.AnimationLineSummaryBtnClick(Sender: TObject);
begin
  SaveAreaSettings(ActiveAreaIndex);  //Update settings of the current area in the memory
  AnimationLineSummaryForm.ShowModal;
end;

function TMainForm.NewCheckFromRef(Ref: TsCheckBox; P: TWinControl; Owner: TComponent;
  const NameValue: String): TsCheckBox;
begin
  Result := TsCheckBox.Create(Owner);
  with Result do
  begin
    Parent := P;
    AutoSize := Ref.AutoSize;
    Alignment := Ref.Alignment;
    Caption := Ref.Caption;
    Left := Ref.Left;
    Top := Ref.Top;
    Width := Ref.Width;
    Height := Ref.Height;
    Name := NameValue;
    BiDiMode := Ref.BiDiMode;
    ParentBiDiMode := Ref.ParentBiDiMode;
    TabStop := Ref.TabStop;
  end;
end;

function TMainForm.NewComboFromRef(Ref: TsComboBox; P: TWinControl; Owner: TComponent;
  const NameValue: String): TsComboBox;
begin
  Result := TsComboBox.Create(Owner);
  with Result do
  begin
    Parent := P;
    Items.Assign(Ref.Items);
    ItemIndex := Ref.ItemIndex;
    Style := Ref.Style;
    Width := Ref.Width;
    Height := Ref.Height;
    Top := Ref.Top;
    Left := Ref.Left;
    BiDiMode := Ref.BiDiMode;
    ParentBiDiMode := Ref.ParentBiDiMode;
    Name := NameValue;
    PopupMenu := Ref.PopupMenu;
    TabStop := Ref.TabStop;
  end;
end;

function TMainForm.NewGroupBoxFromRef(Ref: TsGroupBox;
  P: TWinControl; Owner: TComponent): TsGroupBox;
begin
  Result := TsGroupBox.Create(Owner);
  with Result do
  begin
    Parent := P;
    Anchors := Ref.Anchors;
    Width := Ref.Width;
    Height := Ref.Height;
    Caption := Ref.Caption;
    CaptionSkin := Ref.CaptionSkin;
    CaptionLayout := Ref.CaptionLayout;
    Top := Ref.Top;
    Left := Ref.Left;
    BiDiMode := Ref.BiDiMode;
    ParentBiDiMode := Ref.ParentBiDiMode;
    Visible := Ref.Visible;
  end;
end;

function TMainForm.NewLabelFromRef(Ref: TsLabel; P: TWinControl; Owner: TComponent): TsLabel;
begin
  Result := TsLabel.Create(Owner);
  Result.Parent := P;
  Result.Anchors := Ref.Anchors;
  Result.AutoSize := Ref.AutoSize;
  Result.UseSkinColor := Ref.UseSkinColor;
  Result.Transparent := Ref.Transparent;
  Result.Color := Ref.Color;
  Result.Caption := Ref.Caption;
  Result.Left := Ref.Left;
  Result.Top := Ref.Top;
  Result.BiDiMode := Ref.BiDiMode;
  Result.ParentBiDiMode := Ref.ParentBiDiMode;
  Result.Font.Assign(Ref.Font);
  Result.Visible := Ref.Visible;
end;

function TMainForm.NewSpinFromRef(Ref: TsSpinEdit; P: TWinControl; Owner: TComponent;
  const NameValue: String): TsSpinEdit;
begin
  Result := TsSpinEdit.Create(Owner);
  with Result do
  begin
    Parent := P;
    Left := Ref.Left;
    Top := Ref.Top;
    Height := Ref.Height;
    Width := Ref.Width;
    MaxValue := Ref.MaxValue;
    MinValue := Ref.MinValue;
    Value := Ref.Value;
    Name := NameValue;
    BiDiMode := Ref.BiDiMode;
    ParentBiDiMode := Ref.ParentBiDiMode;
    PopupMenu := Ref.PopupMenu;
    Visible := Ref.Visible;
    TabStop := Ref.TabStop;
    Enabled := Ref.Enabled;
  end;
end;

function TMainForm.NewRadioBoxFromRef(Ref: TsRadioButton; P: TWinControl;
  Owner: TComponent; const NameValue: String): TsRadioButton;
begin
  Result := TsRadioButton.Create(Owner);
  with Result do
  begin
    Parent := P;
    AutoSize := Ref.AutoSize;
    Alignment := Ref.Alignment;
    Caption := Ref.Caption;
    Left := Ref.Left;
    Top := Ref.Top;
    Width := Ref.Width;
    Height := Ref.Height;
    Name := NameValue;
    BiDiMode := Ref.BiDiMode;
    ParentBiDiMode := Ref.ParentBiDiMode;
    Visible := Ref.Visible;
    Checked := Ref.Checked;
    TabStop := Ref.TabStop;
  end;
end;

function TMainForm.GetAreaContentDescription(
  const Area: TArea): WideString;
begin
  Result := '';
  if IsUnusedArea(Area) then
    Exit;
  case Area.ContentType of
    ctTime:
      begin
        Result := Dyn_Texts[90];
      end;
    ctDate:
      begin
        Result := Dyn_Texts[91];
      end;
    ctScrollingText:
      begin
        Result := Dyn_Texts[92];
        Result := Result + ': ' + Area.ScrollingText;
      end;
    ctSWF:
      begin
        Result := Dyn_Texts[136];
      end;
    ctAnimation:
      begin
        Result := Dyn_Texts[93];
      end;
    ctPicture:
      begin
        Result := Dyn_Texts[94];
      end;
    ctTemperature:
      begin
        Result := Dyn_Texts[95];
      end;
    ctEmpty:
      begin
        Result := Dyn_Texts[96];
      end;
  end;
end;

function TMainForm.ValidateStagesData(
  const Stages: TStagesForFileArray): Boolean;
var
  i, j: Integer;
begin
  //Return True if data is valid.
  //Otherwise, returns False.

  Result := False;

  for i := 0 to High(Stages) do
  begin
    with Stages[i] do
    begin
      if (EffectSpeed < 0) or (EffectSpeed > 255) then Exit;

      if (HourFrom < 0) or (HourFrom > 23) then Exit;
      if (MinuteFrom < 0) or (MinuteFrom > 59) then Exit;
      if (HourTo < 0) or (HourTo > 23) then Exit;
      if (MinuteTo < 0) or (MinuteTo > 59) then Exit;
      if (Year < 0) or (Year > 10000) then Exit;
      if (Month < 0) or (Month > 12) then Exit;  //allow to be even 0
      if (Day < 0) or (Day > 31) then Exit;  //allow to be even 0
    end;

    for j := 1 to MAX_AREA_COUNT do
      if not IsUnusedArea(Stages[i].Areas[j]) then
      with Stages[i].Areas[j] do
      begin
        if (x1 > x2) or (y1 > y2) or (x1 < 0) or (x2 < 0) or (y1 < 0) or (y2 < 0) then Exit;
        if not(SizeChangingMode in [Low(TAreaSizeChanging)..High(TAreaSizeChanging)]) then Exit;
        if Color < 0 then Exit;
        if (AnimSpeed > 255) or (AnimSpeed < 0) then Exit;
        if (BorderWidthHorizontal < 0) or (BorderWidthHorizontal > (x2 - x1)) then Exit;  //(x2 - x1) because there may be only one border not two borders in two sides of the area. Also borders must not fill all surface of the area.
        if (BorderWidthVertical < 0) or (BorderWidthVertical > (y2 - y1)) then Exit;  //(y2 - y1) because there may be only one border not two borders in two sides of the area. Also borders must not fill all surface of the area.

        case ContentType of
          ctTime:
            begin
              if not(TimeLanguage in [Low(TLanguage)..High(TLanguage)]) then Exit;
              if not(ClockFormat in [0, 1]) then Exit;
              if not(ClockType in [0, 1]) then Exit;
              if ClockTotalDisplayTime < 0 then Exit;
            end;
          ctDate:
            begin
              if not(DateLanguage in [Low(TLanguage)..High(TLanguage)]) then Exit;
              if not(DateFormat in [0, 1, 2, 3, 4, 5]) then Exit;
              if not(DateType in [0, 1]) then Exit;
              if DateTotalDisplayTime < 0 then Exit;
            end;
          ctScrollingText:
            begin
              if not(TextLanguage in [Low(TLanguage)..High(TLanguage)]) then Exit;
              if not(TextDirection in [0, 1]) then Exit;
              //if not(TextScrollType in [0, 1]) then Exit;  --> TextScrollType is converted to an effect
              if not(TextScrollSpeed in [0, 1, 2, 3, 4]) then Exit;
              if not(TextTimingStyle in [Low(TTimingStyle)..High(TTimingStyle)]) then Exit;
              if TextRepetitionTimes < 0 then Exit;
              if TextTotalDisplayTime < 0 then Exit;
              if not(ScrollingTextType in [Low(TTextType)..High(TTextType)]) then Exit;
            end;
          ctSWF:
            begin
              if (SWFSensitivity < 0) or (SWFSensitivity > 255) then Exit;
              if SWFPlaySpeed < 0 then Exit;
              if not(SWFTimingStyle in [Low(TTimingStyle)..High(TTimingStyle)]) then Exit;
              if SWFRepetitionTimes < 0 then Exit;
              if SWFTotalDisplayTime < 0 then Exit;
            end;
          ctAnimation:
            begin
              if AnimationPlaySpeed < 0 then Exit;
              if not(AnimationTimingStyle in [Low(TTimingStyle)..High(TTimingStyle)]) then Exit;
              if AnimationRepetitionTimes < 0 then Exit;
              if AnimationTotalDisplayTime < 0 then Exit;
            end;
          ctPicture:
            begin
              if not(PictureTimingStyle in [Low(TTimingStyle)..High(TTimingStyle)]) then Exit;
              if PictureRepetitionTimes < 0 then Exit;
              if PictureTotalDisplayTime < 0 then Exit;
              if not(PictureTextDirection in [0, 1]) then Exit;
              //if not(PictureTextScrollType in [0, 1]) then Exit;  --> PictureTextScrollType is converted to an effect
              if not(PictureTextScrollSpeed in [0, 1, 2, 3, 4]) then Exit;
              if not(PictureSource in [Low(TPictureSource)..High(TPictureSource)]) then Exit;
            end;
          ctTemperature:
            begin
              if not(TemperatureLanguage in [Low(TLanguage)..High(TLanguage)]) then Exit;
              if not(TemperatureUnit in [0, 1]) then Exit;
              if TemperatureTotalDisplayTime < 0 then Exit;
            end;
          ctEmpty:
            begin
              if EmptyAreaTotalDisplayTime < 0 then Exit;
            end;
        end;  //case

      end;
  end;

  Result := True;
end;

procedure TMainForm.HideLastWaitState;
begin
  ShowWaitStateTimer.Enabled := False;
  MainForm.Enabled := True;
  if Assigned(WaitForm) then
    WaitForm.Close;
end;

procedure TMainForm.ShowWaitState(WateState: TWaitState;
  NoWaitTimeMilliseconds: Cardinal);
begin
  if not Assigned(WaitForm) then
    Exit;

  ShowWaitStateTimer.Enabled := False;

  case WateState of
    wsGeneratingData:
      begin
        WaitForm.MessageLabel.Caption := Dyn_Texts[99];  //'Preparing data to send'
        MainForm.Enabled := False;
        ShowWaitStateTimer.Interval := NoWaitTimeMilliseconds;
        ShowWaitStateTimer.Enabled := True;  //--> Will call WaitForm.Show;
      end;
  end;
end;

procedure TMainForm.Image12Click(Sender: TObject);
begin
  PictureDirectionLeftRadio.SetFocus;  //This also sets PictureDirectionLeftRadio.Checked to True
  PictureDirectionLeftRadio.Checked := True;
end;

procedure TMainForm.Image11Click(Sender: TObject);
begin
  PictureDirectionRightRadio.SetFocus;  //This also sets PictureDirectionRightRadio.Checked to True
  PictureDirectionRightRadio.Checked := True;
end;

procedure TMainForm.UpdateDatePicturePreview;
var
  TempArea: TArea;
begin
  if LoadingContent or ResetingContentPages then Exit;

  //Collect date content settings only
  with TempArea do
  begin
    if DateDigitsFarsiRadio.Checked then
      DateLanguage := laFarsi
    else
      DateLanguage := laEnglish;

    if DateSolarRadio.Checked then
      DateType := 0
    else
      DateType := 1;

    if DateFormat1Radio.Checked then
      DateFormat := 1
    else if DateFormat3Radio.Checked then
      DateFormat := 3
    else if DateFormat0Radio.Checked then
      DateFormat := 0
    else if DateFormat2Radio.Checked then
      DateFormat := 2
    else if DateFormat4Radio.Checked then
      DateFormat := 4
    else if DateFormat5Radio.Checked then  //Prevent potential software bugs
      DateFormat := 5; 
  end;

  DatePreview(TempArea, DatePreviewImage.Picture.Bitmap);
  DatePreview(TempArea, DatePreviewImage.Picture.Bitmap);  //Update preview image again to prevent drawing problems that sometimes occur
end;

procedure TMainForm.UpdateTimePicturePreview;
var
  TempArea: TArea;
begin
  if LoadingContent or ResetingContentPages then Exit;

  //Collect time content settings only
  with TempArea do
  begin
    if ClockDigitsFarsiRadio.Checked then
      TimeLanguage := laFarsi
    else
      TimeLanguage := laEnglish;

    if Clock24HourRadio.Checked then
      ClockType := 0
    else
      ClockType := 1;

    if ClockHHMMSSFormatRadio.Checked then
      ClockFormat := 0
    else
      ClockFormat := 1;

    ClockDotsBlink := ClockDotsBlinkCheck.Checked;
  end;

  TimePreview(TempArea, TimePreviewImage.Picture.Bitmap);
  TimePreview(TempArea, TimePreviewImage.Picture.Bitmap);  //Update preview image again to prevent drawing problems that sometimes occur
end;

procedure TMainForm.ClockDigitsFarsiRadioClick(Sender: TObject);
begin
  UpdateTimePicturePreview;
end;

procedure TMainForm.DateDigitsFarsiRadioClick(Sender: TObject);
begin
  UpdateDatePicturePreview;
end;

procedure TMainForm.TimePreviewTimerTimer(Sender: TObject);
begin
  if TimePreviewPanel.Visible and GlobalOptions.AutomaticallyRefreshTimePreview then  //Prevent potential software bugs
    UpdateTimePicturePreview;
end;

procedure TMainForm.UpdateTemperaturePicturePreview;
var
  TempArea: TArea;
begin
  if LoadingContent or ResetingContentPages then Exit;

  //Collect temperature content settings only
  with TempArea do
  begin
    if TempLangFarsiRadio.Checked then
      TemperatureLanguage := laFarsi
    else
      TemperatureLanguage := laEnglish;

    if TempUnitCentigradeRadio.Checked then
      TemperatureUnit := 0   //0 = Centigrade
    else
      TemperatureUnit := 1;  //1 = Fahrenheit

    TemperaturePreview(TempArea, TemperaturePreviewImage.Picture.Bitmap);
    TemperaturePreview(TempArea, TemperaturePreviewImage.Picture.Bitmap);
  end;
end;

procedure TMainForm.UpdateEmptyPicturePreview;
var
  TempArea: TArea;
begin
  if LoadingContent or ResetingContentPages then Exit;

  //Collect empty content settings only
  with TempArea do
  begin
    EmptyAreaFilled := EmptyAreaFilledRadio.Checked;
  end;

  EmptyPreview(TempArea, EmptyPreviewImage.Picture.Bitmap);
  EmptyPreview(TempArea, EmptyPreviewImage.Picture.Bitmap);
end;

procedure TMainForm.TempLangFarsiRadioClick(Sender: TObject);
begin
  UpdateTemperaturePicturePreview;
end;

procedure TMainForm.EmptyAreaFilledRadioClick(Sender: TObject);
begin
  UpdateEmptyPicturePreview;
end;

procedure TMainForm.Image5Click(Sender: TObject);
begin
  TempLangFarsiRadio.SetFocus;
  TempLangFarsiRadio.Checked := True;
end;

procedure TMainForm.Image6Click(Sender: TObject);
begin
  TempLangEnglishRadio.SetFocus;
  TempLangEnglishRadio.Checked := True;
end;

procedure TMainForm.Image2Click(Sender: TObject);
begin
  DateDigitsFarsiRadio.SetFocus;
  DateDigitsFarsiRadio.Checked := True;
end;

procedure TMainForm.Image4Click(Sender: TObject);
begin
  DateDigitsEnglishRadio.SetFocus;
  DateDigitsEnglishRadio.Checked := True;
end;

procedure TMainForm.Image1Click(Sender: TObject);
begin
  ClockDigitsFarsiRadio.SetFocus;
  ClockDigitsFarsiRadio.Checked := True;
end;

procedure TMainForm.Image3Click(Sender: TObject);
begin
  ClockDigitsEnglishRadio.SetFocus;
  ClockDigitsEnglishRadio.Checked := True;
end;

procedure TMainForm.Image7Click(Sender: TObject);
begin
  InputTextFarsiRadio.SetFocus;
  InputTextFarsiRadio.Checked := True;
end;

procedure TMainForm.Image8Click(Sender: TObject);
begin
  InputTextEnglishRadio.SetFocus;
  InputTextEnglishRadio.Checked := True;
end;

procedure TMainForm.TemporaryDisableStageMenuItemClick(Sender: TObject);
begin
  //The StagePanel that user right clicked on it is already selected
  DisplayStages[ActiveDisplayStage].TemporaryDisabled := not DisplayStages[ActiveDisplayStage].TemporaryDisabled;
  RefreshStagePanelsAppearance;
end;

procedure TMainForm.SortAnimationLineByTime(Confirm, ShowMessage: Boolean);
var
  i, j: Integer;
  MinIndex: Integer;
  TempDisplayStage: TStage;
  dt1, dt2: TDateTime;
  Found: Boolean;
begin
  //Sorts ascending
  SaveAreaSettings(ActiveAreaIndex);

  //Check if any stage with a time span defined exists
  Found := False;
  for i := 0 to High(DisplayStages) do
    if TimeSpanDefined(DisplayStages[i].HourFrom, DisplayStages[i].MinuteFrom, DisplayStages[i].HourTo, DisplayStages[i].MinuteTo) then
    begin
      Found := True;
      Break;
    end;

  if not Found then  //If no Stage has a time span defined, don't do anything and return
  begin
    if ShowMessage then
      WideMessageDlgSoundTop(Dyn_Texts[101] {'There is no stage with a time span defined.'}, mtInformation, [mbOK], 0);
    Exit;
  end;

  if Confirm then
    if WideMessageDlgSoundTop(Dyn_Texts[100] {'Are you sure to sort animation line?'}, mtConfirmation, [mbYes, mbNo], 0) <> mrYes then
      Exit;

  for i := 0 to High(DisplayStages) - 1 do  //Minus 1 to not to include last item in the array because it does not require to be sorted!
  begin
    MinIndex := i;
    for j := i to High(DisplayStages) do  //Start from i not (i + 1) because stages that has no time span defined are first
    begin
      if not TimeSpanDefined(DisplayStages[j].HourFrom, DisplayStages[j].MinuteFrom,
                             DisplayStages[j].HourTo, DisplayStages[j].MinuteTo) then
      begin
        MinIndex := j;
        Break;
      end
      else
      begin
        dt1 := EncodeTime(DisplayStages[i].HourFrom, DisplayStages[i].MinuteFrom, 0, 0);
        dt2 := EncodeTime(DisplayStages[j].HourFrom, DisplayStages[j].MinuteFrom, 0, 0);
        if CompareTime(dt2, dt1) < 0 then
          MinIndex := j;
      end;
    end;
    if i <> MinIndex then
    begin
      TempDisplayStage := DisplayStages[MinIndex];
      DisplayStages[MinIndex] := DisplayStages[i];
      DisplayStages[i] := TempDisplayStage;
    end;
  end;

  for i := 0 to High(DisplayStages) do
    DisplayStages[i].StagePanel.Tag := i;
    
  SelectStage(0, True, False);
  //SelectStagePanel(DisplayStages[ActiveDisplayStage].StagePanel, True);
  SelectStagePanel(DisplayStages[ActiveDisplayStage], True);

  for i := 0 to High(DisplayStages) do
    PositionStagePanel(i);
end;

procedure TMainForm.SortAnimationLineByTimeMenuItemClick(Sender: TObject);
begin
  SortAnimationLineByTime(True, True);
end;

procedure TMainForm.N9Click(Sender: TObject);
begin
  if not FileExists(ApplicationPath + HELP_PATH + '\' + QUICK_HELP_FILE_NAME) then
    WideShowMessageSound(WideFormat(Dyn_Texts[70] {'Help file:%s was not found.'}, [#13 + ApplicationPath + HELP_PATH + '\' + QUICK_HELP_FILE_NAME + #13]))
  else
    Procs.OpenUrlInDefaultBrowser(ApplicationPath + HELP_PATH + '\' + QUICK_HELP_FILE_NAME);
end;

procedure TMainForm.N10Click(Sender: TObject);
begin
  if not FileExists(ApplicationPath + HELP_PATH + '\' + COMPLETE_HELP_FILE_NAME) then
    WideShowMessageSound(WideFormat(Dyn_Texts[70] {'Help file:%s was not found.'}, [#13 + ApplicationPath + HELP_PATH + '\' + COMPLETE_HELP_FILE_NAME + #13]))
  else
    Procs.OpenUrlInDefaultBrowser(ApplicationPath + HELP_PATH + '\' + COMPLETE_HELP_FILE_NAME);
end;

procedure TMainForm.AnimationLineTimerTimer(Sender: TObject);
begin
  AnimationLineWhiteImage.Visible := not AnimationLineWhiteImage.Visible;
  AnimationLineRedImage.Visible := not AnimationLineRedImage.Visible;
  Application.ProcessMessages;
end;

procedure TMainForm.OnDataExchangeStarted;
begin
  AnimationLineWhiteImage.Visible := True;
  AnimationLineRedImage.Visible := False;
  AnimationLineTimer.Enabled := True;
end;

procedure TMainForm.OnDataExchangeFinished;
begin
  AnimationLineTimer.Enabled := False;
  AnimationLineWhiteImage.Visible := True;
end;

function TMainForm.ValidateLEDDisplaySettings(
  LEDDisplaySettings: TLEDDisplaySettings): Boolean;
begin
  //IMPORTANT NOTE: --> If this function is changed, also update ValidateLEDDisplaySettings
  Result := False;

  if (License._LED_DISPLAY_MAX_ROW_COUNT_ > 0) and
    (GlobalOptions.LEDDisplaySettings.Height > _LED_DISPLAY_MAX_ROW_COUNT_) then
    Exit;

  with LEDDisplaySettings do
  begin
    if (Height < MINIMUM_ROW_COUNT) or (Height > MAXIMUM_ROW_COUNT) then Exit;
    if (Width < MINIMUM_COL_COUNT) or (Width > MAXIMUM_COL_COUNT) then Exit;
    if (Height mod ROW_COUNT_MULTIPLE_OF) <> 0 then Exit;
    if (Width mod COL_COUNT_MULTIPLE_OF) <> 0 then Exit;
    if (Memory < LED_DISPLAY_MINIMUM_MEMORY) {or (Memory > LED_DISPLAY_MAXIMUM_MEMORY)  -->  DO NOT LIMIT MEMORY TO A VALUE DUE TO SOFTWARE EXTENSIONS AND COMPATIBILITY} then Exit;
    if (ColorCount <= 0) or (ColorCount > 2) then Exit;
    //Boolean-typed settings cannot be validated
    if CanSetAlarms then
    begin
      if (AlarmCount < 1) or (AlarmCount > MAX_LED_DISPLAY_ALARM_COUNT) then Exit;  //at least one alarm must exist when alarm capabilities is active
      if not(AlarmSystem in [Low(TAlarmSystem)..High(TAlarmSystem)]) then Exit;
    end;
  end;

  //All settings valid
  Result := True;
end;

function TMainForm.ValidateLEDDisplaySettings(
  LEDDisplaySettings: TLEDDisplaySettingsForFile): Boolean;
var
  LDS: TLEDDisplaySettings;
begin
  //Only collect settings that are checked in the fucntion ValidateLEDDisplaySettings(LEDDisplaySettings: TLEDDisplaySettings)
  LDS.Height := LEDDisplaySettings.Height;
  LDS.Width := LEDDisplaySettings.Width;
  LDS.Memory := LEDDisplaySettings.Memory;
  LDS.ColorCount := LEDDisplaySettings.ColorCount;
  //Collect other settings to prevent potential software bugs
  //LDS.Color1                    := LEDDisplaySettings.Color1;
  //LDS.Color2                    := LEDDisplaySettings.Color2;
  LDS.CanShowDateTime           := LEDDisplaySettings.CanShowDateTime;
  LDS.CanShowTemperature        := LEDDisplaySettings.CanShowTemperature;
  LDS.CanShowScrollingText      := LEDDisplaySettings.CanShowScrollingText;
  LDS.CanShowPicture            := LEDDisplaySettings.CanShowPicture;
  LDS.CanShowAnimation          := LEDDisplaySettings.CanShowAnimation;
  LDS.CanShowTextEffects        := LEDDisplaySettings.CanShowTextEffects;
  LDS.CanShowPageEffects        := LEDDisplaySettings.CanShowPageEffects;
  LDS.CanChangePageLayout       := LEDDisplaySettings.CanChangePageLayout;
  LDS.CanSetAlarms              := LEDDisplaySettings.CanSetAlarms;
  LDS.CanSetTimeSpan            := LEDDisplaySettings.CanSetTimeSpan;
  LDS.CanShowSWFFiles           := LEDDisplaySettings.CanShowSWFFiles;

  LDS.AlarmCount                := LEDDisplaySettings.AlarmCount;
  LDS.AlarmSystem               := LEDDisplaySettings.AlarmSystem;

  Result := ValidateLEDDisplaySettings(LDS);
end;

function TMainForm.CalculateCRC32(Data: array of Byte): LongWord;

  procedure CalcCRC32(DataByte: Byte; var CRC32: LongWord);
  var
    BitPos: Integer;
  begin
    CRC32 := CRC32 xor DataByte;
    for BitPos := 0 to 7 do
    begin
      if (CRC32 and $00000001) > 0 then
        CRC32 := (CRC32 shr 1) xor $EDB88320
      else
        CRC32 := (CRC32 shr 1);
    end;
  end;

var
  i: Integer;
  CRC32: LongWord;
begin
  //Calculate CRC32
  CRC32 := $FFFFFFFF;

  for i := 0 to High(Data) do
    CalcCRC32(Data[i], CRC32);

  CRC32 := not CRC32;

  Result := CRC32;
end;

function TMainForm.LoadGIFFromResource(const ResName: String;
  Picture: TPicture): Boolean;
var
  GIFImage: TGIFImage;
  rs: TResourceStream;
begin
  Result := False;
  GIFImage := TGIFImage.Create;
  try
    rs := TResourceStream.Create(HInstance, ResName, 'GIF');
    GIFImage.LoadFromStream(rs);
    Picture.Graphic := GIFImage;
    GIFImage.Free;
    rs.Free;
    Result := True;
  except
  end;
end;

procedure TMainForm.ShowWaitStateTimerTimer(Sender: TObject);
begin
  ShowWaitStateTimer.Enabled := False;
  WaitForm.Show;  
end;

procedure TMainForm.EditBorderStyleSpeedBtn2Click(Sender: TObject);
begin
  if Assigned(BorderStyleImage) then
    BorderStyleImage.OnClick(BorderStyleImage);

  /////////////////////////////////////////////////////////////////////////////
  if GlobalOptions.LEDDisplaySettings.Height > _LED_DISPLAY_MAX_ROW_COUNT_ then
    Halt;
  /////////////////////////////////////////////////////////////////////////////
end;

procedure TMainForm.TextTotalDisplayTimeSpinChange(Sender: TObject);
begin
  if LoadingContent then
    Exit;
  try
    TextTimingStyle2Radio.Checked := True;
  except
  end;
end;

procedure TMainForm.TextRepetitionTimesSpinChange(Sender: TObject);
begin
  if LoadingContent then
    Exit;
  try
    TextTimingStyle1Radio.Checked := True;
  except
  end;
end;

procedure TMainForm.PictureTotalDisplayTimeSpinChange(Sender: TObject);
begin
  if LoadingContent then
    Exit;
  try
    PictureTimingStyle2Radio.Checked := True;
  except
  end;
end;

procedure TMainForm.PictureRepetitionTimesSpinChange(Sender: TObject);
begin
  if LoadingContent then
    Exit;
  try
    PictureTimingStyle1Radio.Checked := True;
  except
  end;
end;

procedure TMainForm.AnimationTotalDisplayTimeSpinChange(Sender: TObject);
begin
  if LoadingContent then
    Exit;
  try
    AnimationTimingStyle2Radio.Checked := True;
  except
  end;
end;

procedure TMainForm.AnimationRepetitionTimesSpinChange(Sender: TObject);
begin
  if LoadingContent then
    Exit;
  try
    AnimationTimingStyle1Radio.Checked := True;
  except
  end;
end;

procedure TMainForm.WindowSize(var msg: TWMSize);
begin
  inherited;

  if LoadingConfig then
    Exit;

  //Only WindowState is needed in this program
  if msg.SizeType = SIZE_MAXIMIZED then
  begin
    with GlobalOptions do
    begin
      MainFormState := wsMaximized;
      //MainFormLeft := OldWindowRect.Left;
      //MainFormTop := OldWindowRect.Top;
      //MainFormWidth := OldWindowRect.Width;
      //MainFormHeight := OldWindowRect.Height;
    end;
  end
  else if msg.SizeType = SIZE_RESTORED then
  begin
    with GlobalOptions do
    begin
      MainFormState := wsNormal;
      //MainFormLeft := Left;
      //MainFormTop := Top;
      //MainFormWidth := Width;
      //MainFormHeight := Height;
    end;
  end;
  msg.Result := 0;
end;

procedure TMainForm.NormalizeBitmapForeground(Bitmap: TBitmap);
//This functions changes any color in the bitamp which is not equal to
//  LCDClearedColor to LCDFilledColor, allowing conversion of pictures
//  and GIF animations not having clBlue as the foreground color.
var
  Row, Col: Integer;
begin
  for Col := 0 to Bitmap.Width - 1 do
  begin
    for Row := 0 to Bitmap.Height - 1 do
      if Bitmap.Canvas.Pixels[Col, Row] <> LCDClearedColor then
        Bitmap.Canvas.Pixels[Col, Row] := LCDFilledColor;
  end;
end;

procedure TMainForm.ImportSMSPicBtnClick(Sender: TObject);
var
  AreaHeight: Integer;
  b: TBitmap;
begin
  if OpenSMSPictureDialog.Tag = 0 then
  begin
    if WideDirectoryExists(ApplicationPath + SMS_PICTURES_FOLDER_NAME) then
    begin
      OpenSMSPictureDialog.InitialDir := ApplicationPath + SMS_PICTURES_FOLDER_NAME;
      OpenSMSPictureDialog.Tag := 1;  //this means that don't change default folder next time
    end;
  end;

  if OpenSMSPictureDialog.Execute then
  begin
    if not ImportNewPictureRadio.Checked then
      ImportNewPictureRadio.Checked := True;

    b := TBitmap.Create;

    try
      if LoadOTAFromFile(OpenSMSPictureDialog.FileName, b, clBlue, clWhite) then
      begin
        with DisplayStages[ActiveDisplayStage].Areas[ActiveAreaIndex] do
          AreaHeight := y2 - y1 + 1;

        Procs.TrimBitmapUnusedBorders(b);

        if AreaHeight < b.Height then
          if WideMessageDlgSoundTop(Dyn_Texts[117] {'The size of the sms picture you have selected is greater than the current display area. Do you want to scale it to fit into the area?'}, mtConfirmation, [mbYes, mbNo], 0) = mrYes then
            ScaleBitmapToAreaHeight(b, AreaHeight);

        PicturePreviewImage.Show;  //It may be hidden

        PicturePreviewImage.Picture.Graphic := b;

        PicturePreviewImage.Stretch := True;

        PictureWidthLabel.Caption := IntToStr(PicturePreviewImage.Picture.Bitmap.Width);
        PictureHeightLabel.Caption := IntToStr(PicturePreviewImage.Picture.Bitmap.Height);
        DisplayStages[ActiveDisplayStage].Areas[ActiveAreaIndex].PictureAvailable := True;

        DesignChangeFlag := True;

        UpdatePicturePicturePreview;
      end
      else
      begin
        WideShowMessageSoundTop(Dyn_Texts[118] {'The selected file is invalid.'});
      end;
    except
      WideShowMessageSoundTop(WideFormat(Dyn_Texts[119] {'The program is unable to open the file:%sMaybe it is being used by another application.'}, [OpenSMSPictureDialog.FileName]));
    end;

    b.Free;
  end;

end;

procedure TMainForm.ScaleBitmapToAreaHeight(Bitmap: TBitmap;
  AreaHeight: Integer);
var
  ScaledBitmap: TBitmap;
  ScaleFactor: Cardinal;
begin
  ScaledBitmap := TBitmap.Create;
  try
    if (AreaHeight < Bitmap.Height) and (Bitmap.Height <= 100) then
    begin
      //Scale bitmap to fit in the area space
      for ScaleFactor := 100 downto 1 do
      begin
        Procs.ScaleBitmap(Bitmap, ScaledBitmap, ScaleFactor);
        if ScaledBitmap.Height <= AreaHeight then
          Break;
      end;
      Bitmap.Assign(ScaledBitmap);
    end;
  finally
    ScaledBitmap.Free;
  end;
end;

procedure TMainForm.RAROnListFileEventHandler(Sender: TObject;
  const FileInformation: TRARFileItem);
begin
  RARFileList.Append(FileInformation.FileNameW);
end;

procedure TMainForm.RAROnPasswordRequiredEventHandlerprocedure(
  Sender: TObject; const HeaderPassword: boolean;
  const FileName: AnsiString; out NewPassword: AnsiString;
  out Cancel: boolean);
begin
  NewPassword := DATA_FILES_RAR_PASSWORD;
end;

procedure TMainForm.SetupApplicationDataFiles;
//This function sextracts files of folders that contain unicode file names (i.e. Farsi filenames),
//  because it was not possible to transfer them to the target machine using the setup because the
//  does not support unicode (or at least Farsi and Arabic) file management.
var
  Rar: TRAR;

  function NoFileExists(const FolderName: WideString): Boolean;
  var
    FSR: TSearchRecW;
    Found: Boolean;
  begin
    Result := False;

    try
      Found := False;
      if WideFindFirst(FolderName + '\*.*', faAnyFile, FSR) = 0 then
      begin
        repeat
          if ((FSR.Attr and faSysFile)=0) and
             ((FSR.Attr and faSymLink)=0) and
             ((FSR.Attr and faVolumeID)=0) then
          begin
            if FSR.Name[1] <> '.' then
            begin
              if RARFileList.IndexOf(FSR.Name) >= 0 then
              begin
                Found := True;
                Break;
              end;
            end;
          end;
        until WideFindNext(FSR) <> 0;
      end;
      WideFindClose(FSR);

      Result := not Found;
    except
      Result := False;
    end;
  end;

begin
  //If rar dll does not exis, do nothing and exit
  if not WideFileExists(ApplicationPath + UNRAR_DLL_NAME) then
    Exit;

  RARFileList := nil;
  Rar := nil;

  try
    RARFileList := TTntStringList.Create;
    Rar := TRAR.Create(Self);

    Rar.DllName := ApplicationPath + UNRAR_DLL_NAME;
    Rar.LoadDLL;
    Rar.OnListFile := RAROnListFileEventHandler;
    Rar.OnPasswordRequired := RAROnPasswordRequiredEventHandlerprocedure;

    //Data1: Animations folder
    if WideFileExists(ApplicationPath + DATA_FOLDER_NAME + '\' + ANIMATIONS_DATA_FILE_NAME) then
    begin
      RARFileList.Clear;
      Rar.OpenFile(ApplicationPath + DATA_FOLDER_NAME + '\' + ANIMATIONS_DATA_FILE_NAME);
      if NoFileExists(GIF_ANIMATIONS_FOLDER_NAME) then
        Rar.Extract(ApplicationPath + GIF_ANIMATIONS_FOLDER_NAME, True, nil);
    end;

    //Data1: Pictures and Symbols folder
    if WideFileExists(ApplicationPath + DATA_FOLDER_NAME + '\' + PICTURES_DATA_FILE_NAME) then
    begin
      RARFileList.Clear;
      Rar.OpenFile(ApplicationPath + DATA_FOLDER_NAME + '\' + PICTURES_DATA_FILE_NAME);
      if NoFileExists(PICTURES_FOLDER_NAME) then
        Rar.Extract(ApplicationPath + PICTURES_FOLDER_NAME, True, nil);
    end;

    //Data1: SMS Pictures folder
    if WideFileExists(ApplicationPath + DATA_FOLDER_NAME + '\' + SMS_PICTURES_DATA_FILE_NAME) then
    begin
      RARFileList.Clear;
      Rar.OpenFile(ApplicationPath + DATA_FOLDER_NAME + '\' + SMS_PICTURES_DATA_FILE_NAME);
      if NoFileExists(SMS_PICTURES_FOLDER_NAME) then
        Rar.Extract(ApplicationPath + SMS_PICTURES_FOLDER_NAME, True, nil);
    end;

    Rar.UnloadDLL;
    Rar.Free;

    RARFileList.Free;
  except
    if Assigned(RARFileList) then
      RARFileList.Free;
    if Assigned(Rar) then
      RARFileList.Free;
  end;
end;

procedure TMainForm.SelectDefaultPictureBtnClick(Sender: TObject);
var
  FName: WideString;
  AreaWidth, AreaHeight: Integer;
begin
  with DisplayStages[ActiveDisplayStage].Areas[ActiveAreaIndex] do
  begin
    AreaWidth := x2 - x1 + 1;
    AreaHeight := y2 - y1 + 1;
  end;

  DefaultPicturesForm.ActiveAreaWidth := AreaWidth;
  DefaultPicturesForm.ActiveAreaHeight := AreaHeight;
  if DefaultPicturesForm.ShowModal = mrOk then
  begin
    PicturePreviewImage.Picture.Bitmap.Assign(DefaultPicturesForm.PicturePreviewImage.Picture.Bitmap);

    PicturePreviewImage.Show;  //It may be hidden

    PicturePreviewImage.Stretch := True;
    
    PictureWidthLabel.Caption := IntToStr(PicturePreviewImage.Picture.Bitmap.Width);
    PictureHeightLabel.Caption := IntToStr(PicturePreviewImage.Picture.Bitmap.Height);

    DisplayStages[ActiveDisplayStage].Areas[ActiveAreaIndex].PictureAvailable := True;

    //DefaultPicturesCombo.Tag := DefaultPicturesCombo.ItemIndex;  //Store ItemIndex

    DesignChangeFlag := True;

    UpdatePicturePicturePreview;
    {
    if (DefaultPicturesForm.SelectedPictureIndex >= 0) and
       (DefaultPicturesForm.SelectedPictureIndex <= High(DefaultPictures)) then
    begin
      FName := DefaultPictures[DefaultPicturesForm.SelectedPictureIndex].FileName;
      if WideFileExists(FName) then  //Prevent potential software bugs
      begin
        WideLoadBitmapImageFormFile(FName, PicturePreviewImage.Picture.Bitmap);

        PictureWidthLabel.Caption := IntToStr(PicturePreviewImage.Picture.Bitmap.Width);
        PictureHeightLabel.Caption := IntToStr(PicturePreviewImage.Picture.Bitmap.Height);

        DisplayStages[ActiveDisplayStage].Areas[ActiveAreaIndex].PictureAvailable := True;

        //DefaultPicturesCombo.Tag := DefaultPicturesCombo.ItemIndex;  //Store ItemIndex

        DesignChangeFlag := True;

        UpdatePicturePicturePreview;
      end;
    end;
    }
  end;
end;

procedure TMainForm.ApplicationEvents1Exception(Sender: TObject;
  E: Exception);
begin
  ApplicationEvents1.CancelDispatch;
end;

procedure TMainForm.SetAreaUnused(var Area: TArea);
begin
  Area.x1 := 0;
  Area.x2 := 0;
  Area.y1 := 0;
  Area.y2 := 0;
end;

function TMainForm.CountStageUsedAreas(Stage: TStage): Integer;
var
  i: Integer;
begin
  Result := 0;
  for i := 1 to MAX_AREA_COUNT do
    if not IsUnusedArea(Stage.Areas[i]) then
      Inc(Result);
end;

procedure TMainForm.N8Click(Sender: TObject);
var
  OldActiveStage: Integer;
begin
  OldActiveStage := ActiveDisplayStage;
  NewStage(True, ActiveDisplayStage, True, True);
  //OnNewStagePanelAdded;
end;

procedure TMainForm.CopyStage(SourceStageIndex, DesStageIndex: Integer);
var
  i: Integer;
  DesNew, DesOriginal: TStage;
begin
  DesNew := DisplayStages[SourceStageIndex];
  DesOriginal := DisplayStages[DesStageIndex];

  DesNew.StagePanel := DesOriginal.StagePanel;
  for i := 1 to MAX_AREA_COUNT do
    with DesNew.Areas[i] do
    begin
      //Picture Content
      PictureBitmap := DesOriginal.Areas[i].PictureBitmap;
      if Assigned(DisplayStages[SourceStageIndex].Areas[i].PictureBitmap) and
         (DisplayStages[SourceStageIndex].Areas[i].ContentType = ctPicture) then
        PictureBitmap.Assign(DisplayStages[SourceStageIndex].Areas[i].PictureBitmap);
      //SWF Content
      SWFData.LoadFromStream(DisplayStages[SourceStageIndex].Areas[i].SWFData);
    end;

  DisplayStages[DesStageIndex] := DesNew;
end;

procedure TMainForm.FullBorderBtnClick(Sender: TObject);
begin
  TopBorderLabel.Transparent := False;
  BottomBorderLabel.Transparent := False;
  LeftBorderLabel.Transparent := False;
  RightBorderLabel.Transparent := False;
end;

procedure TMainForm.NoBorderBtnClick(Sender: TObject);
begin
  TopBorderLabel.Transparent := True;
  BottomBorderLabel.Transparent := True;
  LeftBorderLabel.Transparent := True;
  RightBorderLabel.Transparent := True;
end;

procedure TMainForm.DatePreviewTimerTimer(Sender: TObject);
begin
  if datepreviewPanel.Visible then  //Prevent potential software bugs
    UpdateDatePicturePreview;
end;

procedure TMainForm.PutLCDAtCenter(ALCD: TAdvStringGrid;
  AreaWidth: Integer);
var
  AddToLeftCount, AddToRightCount: Integer;
  i, Row: Integer;
begin
  if AreaWidth <= ALCD.ColCount then
    Exit;

  AddToLeftCount := Trunc((AreaWidth - ALCD.ColCount) / 2);
  AddToRightCount := AreaWidth - (AddToLeftCount + ALCD.ColCount);

  //Add new columns and colorize them
  for i := 1 to AddToLeftCount do
  begin
    ALCD.InsertCols(0, 1);
    //Colorize the new column
    for Row := 0 to ALCD.RowCount - 1 do
      ALCD.Colors[0, Row] := LCDClearedColor;
  end;

  for i := 1 to AddToRightCount do
  begin
    ALCD.InsertCols(ALCD.ColCount, 1);
    //Colorize the new column
    for Row := 0 to ALCD.RowCount - 1 do
      ALCD.Colors[ALCD.ColCount - 1, Row] := LCDClearedColor;
  end;
end;

procedure TMainForm.PutLCDBitmapAtCenter(ALCDBitmap: TBitmap;
  AreaWidth: Integer);
var
  TempTextToLCDGrid: TAdvStringGrid;
begin
  if AreaWidth <= ALCDBitmap.Width then
    Exit;

  TempTextToLCDGrid := TAdvStringGrid.Create(nil);
  //TempTextToLCDGrid.DefaultRowHeight := 3;
  //TempTextToLCDGrid.DefaultColWidth := 3;
  TempTextToLCDGrid.Visible := False;
  TempTextToLCDGrid.Parent := MainForm;

  BitmapToLCD(ALCDBitmap, TempTextToLCDGrid, 0, False);
  PutLCDAtCenter(TempTextToLCDGrid, AreaWidth);
  LCDToBitmap(TempTextToLCDGrid, ALCDBitmap, False);

  TempTextToLCDGrid.Free;
end;

procedure TMainForm.CheckAlSerialPortObjectsToBeClosed;
begin
  try
    if ProgrammerForm.KDSerialPort1.IsOpened then
      ProgrammerForm.KDSerialPort1.Close;
  except
  end;
  try
    if AlarmProgressForm.KDSerialPort1.IsOpened then
      AlarmProgressForm.KDSerialPort1.Close;
  except
  end;
  try
    if LEDDisplayDataResetForm.KDSerialPort1.IsOpened then
      LEDDisplayDataResetForm.KDSerialPort1.Close;
  except
  end;
end;

procedure TMainForm.PageEffectImageClick(Sender: TObject);
begin
  if SelectPageEffectBtn.Enabled then
    SelectPageEffectBtn.Click;
end;

procedure TMainForm.NoPageEffectLabelClick(Sender: TObject);
begin
  if SelectPageEffectBtn.Enabled then
    SelectPageEffectBtn.Click;
end;

procedure TMainForm.AddNewAnimationBtnClick(Sender: TObject);
begin
  if not WideDirectoryExists(ApplicationPath + GIF_ANIMATIONS_FOLDER_NAME) then
  begin
    try
      WideCreateDir(ApplicationPath + GIF_ANIMATIONS_FOLDER_NAME);
    except
    end;
  end;
  WideMessageDlgSoundTop(Dyn_Texts[127] {'Copy your animation files to this folder and restart the application to use them.'}, mtInformation, [mbOK], 0);
  Procs.OpenUrlInDefaultBrowser(ApplicationPath + GIF_ANIMATIONS_FOLDER_NAME);
end;

procedure TMainForm.AnimationLineWhiteImageContextPopup(Sender: TObject;
  MousePos: TPoint; var Handled: Boolean);
begin
  StagePanelPopup.PopupComponent := DisplayStages[ActiveDisplayStage].StagePanel;
end;

procedure TMainForm.sPanel5ContextPopup(Sender: TObject; MousePos: TPoint;
  var Handled: Boolean);
begin
  StagePanelPopup.PopupComponent := DisplayStages[ActiveDisplayStage].StagePanel;
end;

procedure TMainForm.AnimationLineScrollBoxContextPopup(Sender: TObject;
  MousePos: TPoint; var Handled: Boolean);
begin
  StagePanelPopup.PopupComponent := DisplayStages[ActiveDisplayStage].StagePanel;
end;

procedure TMainForm.ShowPreviewBtnClick(Sender: TObject);
begin
  RuntimeGlobalOptions.ShowTextPreview := True;
  if Assigned(InputText.OnDelayedChange) then
    InputText.OnDelayedChange(InputText);
  RuntimeGlobalOptions.ShowTextPreview := AutoPreviewCheck.Checked;
end;

procedure TMainForm.AutoPreviewCheckClick(Sender: TObject);
begin
  RuntimeGlobalOptions.ShowTextPreview := AutoPreviewCheck.Checked;
  ShowPreviewBtn.Enabled := not AutoPreviewCheck.Checked;
  if AutoPreviewCheck.Checked and not LoadingConfig then
    ShowPreviewBtn.Click;
end;

procedure TMainForm.OpenSWFFileBtnClick(Sender: TObject);
var
  AreaHeight: Integer;
  SWFInfo: TSWFInfo;
begin
  if OpenSWFDialog.Execute then
  begin
    DisplayStages[ActiveDisplayStage].Areas[ActiveAreaIndex].SWFData.LoadFromFile(OpenSWFDialog.FileName);
    FlashPlayer.LoadMovieFromStream(0, DisplayStages[ActiveDisplayStage].Areas[ActiveAreaIndex].SWFData);
    FlashPlayer.Transparent := False;
    FlashPlayer.Transparent := True;
    GetSWFInfo(DisplayStages[ActiveDisplayStage].Areas[ActiveAreaIndex].SWFData, SWFInfo);

    //Show SWF info
    //Width and Height of SWF animations depends on the Width and Height of the display area when generating data, so only show the number of frames
    //SWFWidthLabel.Caption := IntToStr(SWFInfo.Width);
    //SWFHeightLabel.Caption := IntToStr(SWFInfo.Height);
    SWFFrameCountLabel.Caption := IntToStr(SWFInfo.FrameCount);
    SWFSizeLabel.Caption := WideFormat('%dx%d', [SWFInfo.Height, SWFInfo.Width]);

    DisplayStages[ActiveDisplayStage].Areas[ActiveAreaIndex].StaticInfo.SWFFrameCount := SWFInfo.FrameCount;
    DisplayStages[ActiveDisplayStage].Areas[ActiveAreaIndex].StaticInfo.SWFFrameHeight := SWFInfo.Height;
    DisplayStages[ActiveDisplayStage].Areas[ActiveAreaIndex].StaticInfo.SWFFrameWidth := SWFInfo.Width;
    DisplayStages[ActiveDisplayStage].Areas[ActiveAreaIndex].StaticInfo.SWFInfoValid := True;

    (*
    b := TBitmap.Create;

    try
      if LoadOTAFromFile(OpenSMSPictureDialog.FileName, b, clBlue, clWhite) then
      begin
        with DisplayStages[ActiveDisplayStage].Areas[ActiveAreaIndex] do
          AreaHeight := y2 - y1 + 1;

        Procs.TrimBitmapUnusedBorders(b);

        if AreaHeight < b.Height then
          if WideMessageDlgSoundTop(Dyn_Texts[117] {'The size of the sms picture you have selected is greater than the current display area. Do you want to scale it to fit into the area?'}, mtConfirmation, [mbYes, mbNo], 0) = mrYes then
            ScaleBitmapToAreaHeight(b, AreaHeight);

        PicturePreviewImage.Show;  //It may be hidden

        PicturePreviewImage.Picture.Graphic := b;

        PicturePreviewImage.Stretch := True;

        PictureWidthLabel.Caption := IntToStr(PicturePreviewImage.Picture.Bitmap.Width);
        PictureHeightLabel.Caption := IntToStr(PicturePreviewImage.Picture.Bitmap.Height);
        DisplayStages[ActiveDisplayStage].Areas[ActiveAreaIndex].PictureAvailable := True;

        DesignChangeFlag := True;

        UpdatePicturePicturePreview;
      end
      else
      begin
        WideShowMessageSoundTop(Dyn_Texts[118] {'The selected file is invalid.'});
      end;
    except
      WideShowMessageSoundTop(WideFormat(Dyn_Texts[119] {'The program is unable to open the file:%sMaybe it is being used by another application.'}, [OpenSMSPictureDialog.FileName]));
    end;

    b.Free;
    *)
  end;
end;

procedure TMainForm.SWFContentBtnClick(Sender: TObject);
begin
  SelectContent(ctSWF, True);

  //************************************
  if not License2.CheckLicenseStatus then
    Halt;
  if not LicenseTimer.Enabled then
    LicenseTimer.Enabled := True;
  //************************************
end;

procedure TMainForm.SWFContentPanelResize(Sender: TObject);
begin
  FlashPlayer.Transparent := False;
  FlashPlayer.Transparent := True;
end;

procedure TMainForm.GetSWFInfo(Stream: TStream; var SWFInfo: TSWFInfo);
var
  MMSWFHeaderReader: TMMSWFHeaderReader;
begin
  MMSWFHeaderReader := TMMSWFHeaderReader.Create(nil);
  MMSWFHeaderReader.LoadFromStream(Stream);
  SWFInfo.FrameCount := MMSWFHeaderReader.MMSWFHeader.FrameCount;
  SWFInfo.FrameRate := MMSWFHeaderReader.MMSWFHeader.FrameRate;
  if SWFInfo.FrameCount  > 0 then
  begin
    SWFInfo.Width := MMSWFHeaderReader.MMSWFHeader.Width;
    SWFInfo.Height := MMSWFHeaderReader.MMSWFHeader.Height;
  end
  else
  begin
    SWFInfo.Width := 0;
    SWFInfo.Height := 0;
  end;
end;

procedure TMainForm.GetContentBitmap(ContentType: TContentType;
  Image, TextImage: TBitmap);
begin
  //Get ContentImage
  if ContentType = ctSWF then  //ctSWF is saved as PNG
    PngImageList40x40.GetBitmap(0, Image)
  else
    ContentImages.GetBitmap(Integer(ContentType), Image);
  //Get ContentTextImage
  ContentTextImages.GetBitmap(Integer(ContentType), TextImage);
end;

procedure TMainForm.SetOffTimeBtnClick(Sender: TObject);
begin
  Application.CreateForm(TSetOffTimeForm, SetOffTimeForm);
  try
     SetOffTimeForm.ShowModal;
  finally
    SetOffTimeForm.Free;
  end;
end;

function TMainForm.CalculateFrameDelayMultiplier(
  SpeedIndex: Integer): Double;
begin
  case SpeedIndex of
    //0:  //Very slow  --> Very Slow speed has been removed
    //  Result := 255;
    0:  //Slow
      Result := 2.5;
    1:  //Medium
      Result := 0.8;
    2:  //Fast
      Result := 0.5;
    3:  //Very fast
      Result := 0.2;
  end;
end;

procedure TMainForm.ModelOKBtnClick(Sender: TObject);
var
  SelectedModel: TLicenseModel;
  Word1, Word2, Word3, Word4, Word5, Word6, Word7: String;
begin
  SelectedModel := lmNone;

  if ModelsListBox.ItemIndex < 0 then
  begin
    MessageDlgSoundTop(Dyn_Texts[142] {'Please select a model to continue.'}, mtInformation, [mbOK], 0);
    Exit;
  end;

  {$IFDEF FULL_BRIGHT}
  if ModelsListBox.ItemIndex = 0 then
    SelectedModel := lmBRModel1
  else if ModelsListBox.ItemIndex = 1 then
    SelectedModel := lmBRModel2
  else if ModelsListBox.ItemIndex = 2 then
    SelectedModel := lmBRModel3;
  {$ENDIF}
  {$IFDEF NORMAL_MODEL}
  if ModelsListBox.ItemIndex = 0 then
    SelectedModel := lmModel1
  else if ModelsListBox.ItemIndex = 1 then
    SelectedModel := lmModel1Alarm
  else if ModelsListBox.ItemIndex = 2 then
    SelectedModel := lmModel1AlarmLFG
  else if ModelsListBox.ItemIndex = 3 then
    SelectedModel := lmModel1LFG
  else if ModelsListBox.ItemIndex = 4 then
    SelectedModel := lmModel2
  else if ModelsListBox.ItemIndex = 5 then
    SelectedModel := lmModel2Alarm
  else if ModelsListBox.ItemIndex = 6 then
    SelectedModel := lmModel2AlarmLFG
  else if ModelsListBox.ItemIndex = 7 then
    SelectedModel := lmModel2LFG
  else if ModelsListBox.ItemIndex = 8 then
    SelectedModel := lmModel3
  else if ModelsListBox.ItemIndex = 9 then
    SelectedModel := lmModel3Alarm
  else if ModelsListBox.ItemIndex = 10 then
    SelectedModel := lmModel3AlarmLFG
  else if ModelsListBox.ItemIndex = 11 then
    SelectedModel := lmModel3LFG;
  {$ENDIF}


  if SelectedModel <> lmNone then
  begin
    License.SelectLicenseModel(SelectedModel);
    License2.SelectLicenseModel(SelectedModel);
    License3.SelectLicenseModel(SelectedModel);
    License4.SelectLicenseModel(SelectedModel);
    License5.SelectLicenseModel(SelectedModel);
    License6.SelectLicenseModel(SelectedModel);
  end
  else
    Halt;

  License.GenerateCUID(Word1, Word2, Word3, Word4, Word5, Word6, Word7);
  CUIDWord1.Text := Word1;
  CUIDWord2.Text := Word2;
  CUIDWord3.Text := Word3;
  CUIDWord4.Text := Word4;
  CUIDWord5.Text := Word5;
  CUIDWord6.Text := Word6;
  CUIDWord7.Text := Word7;

  ActivationCodeGroup.Visible := True;
  ActivationCodeGroup.BringToFront;
  SelectModelGroup.Visible := False;

  ModelOKBtnClicked := True;
end;

procedure TMainForm.SWFSensitivityTrackBarChange(Sender: TObject);
begin
  SWFSensitivityLabel.Caption := IntToStr(SWFSensitivityTrackBar.Position);
end;

procedure TMainForm.SWFPreviewBtnClick(Sender: TObject);
var
  ActiveArea: TArea;
  SWFInfo: TSWFInfo;
begin
  ActiveArea := DisplayStages[ActiveDisplayStage].Areas[ActiveAreaIndex];
  if ActiveArea.ContentType = ctSWF then
  begin
    if ActiveArea.SWFData.Size = 0 then
    begin
      WideMessageDlgSoundTop(Dyn_Texts[143] {'No swf file has been selected. Please select an swf file first.'}, mtInformation, [mbOK], 0);
      Exit;
    end;

    try
      try
        Application.CreateForm(TSWFPreviewForm, SWFPreviewForm);
        GetSWFInfo(ActiveArea.SWFData, SWFInfo);
        SWFPreviewForm.LoadSWFFromStream(ActiveArea.SWFData, SWFInfo, SWFSensitivityTrackBar.Position);
        SWFPreviewForm.ShowModal;
      finally
        SWFPreviewForm.Free;
      end;
    except
      On E: Exception do
      begin
        WideMessageDlgSoundTop(WideFormat(Dyn_Texts[144] {'There was an error while converting the swf animation. This file is not in a correct format to display on the LED Display.%s'}, [#13 + E.Message]), mtError, [mbOK], 0);
      end;
    end;
  end;
end;

end.
