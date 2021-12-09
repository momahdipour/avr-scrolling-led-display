object ProgramOptionsForm: TProgramOptionsForm
  Left = 448
  Top = 152
  BorderStyle = bsDialog
  Caption = #1578#1606#1592#1740#1605#1575#1578' '#1576#1585#1606#1575#1605#1607
  ClientHeight = 431
  ClientWidth = 399
  Color = clBtnFace
  Font.Charset = ARABIC_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnClose = TntFormClose
  OnCloseQuery = TntFormCloseQuery
  OnCreate = FormCreate
  OnShow = FormShow
  DesignSize = (
    399
    431)
  PixelsPerInch = 96
  TextHeight = 13
  object ConnectionGroup: TsGroupBox
    Left = 8
    Top = 8
    Width = 383
    Height = 101
    Anchors = [akLeft, akTop, akRight]
    Caption = #1578#1606#1592#1740#1605#1575#1578' '#1575#1578#1589#1575#1604
    TabOrder = 0
    CaptionLayout = clTopRight
    SkinData.SkinSection = 'GROUPBOX'
    DesignSize = (
      383
      101)
    object PortLabel1: TsLabel
      Left = 245
      Top = 48
      Width = 126
      Height = 13
      Anchors = [akTop, akRight]
      Caption = #1662#1608#1585#1578' '#1575#1578#1589#1575#1604' '#1578#1575#1576#1604#1608#1740' '#1588#1605#1575#1585#1607' 1:'
      ParentFont = False
      Font.Charset = ARABIC_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
    end
    object sLabel4: TsLabel
      Left = 272
      Top = 24
      Width = 99
      Height = 13
      Anchors = [akTop, akRight]
      Caption = #1578#1593#1583#1575#1583' '#1578#1575#1576#1604#1608#1607#1575#1740' '#1605#1578#1589#1604':'
      ParentFont = False
      Font.Charset = ARABIC_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
    end
    object PortLabel2: TsLabel
      Left = 245
      Top = 72
      Width = 126
      Height = 13
      Anchors = [akTop, akRight]
      Caption = #1662#1608#1585#1578' '#1575#1578#1589#1575#1604' '#1578#1575#1576#1604#1608#1740' '#1588#1605#1575#1585#1607' 2:'
      ParentFont = False
      Font.Charset = ARABIC_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
    end
    object PortCombo1: TsComboBox
      Left = 166
      Top = 44
      Width = 65
      Height = 21
      SelStart = 4
      SelLength = 0
      Text = 'COM1'
      Items.Strings = (
        'COM1'
        'COM2'
        'COM3'
        'COM4'
        'COM5'
        'COM6'
        'COM7'
        'COM8'
        'COM9'
        'COM10'
        'COM11'
        'COM12'
        'COM13'
        'COM14'
        'COM15'
        'COM16')
      Alignment = taLeftJustify
      BoundLabel.Indent = 0
      BoundLabel.Font.Charset = DEFAULT_CHARSET
      BoundLabel.Font.Color = clWindowText
      BoundLabel.Font.Height = -11
      BoundLabel.Font.Name = 'MS Sans Serif'
      BoundLabel.Font.Style = []
      BoundLabel.Layout = sclLeft
      BoundLabel.MaxWidth = 0
      BoundLabel.UseSkinColor = True
      SkinData.SkinSection = 'COMBOBOX'
      Style = csDropDownList
      Anchors = [akTop, akRight]
      BiDiMode = bdLeftToRight
      Color = clWhite
      Font.Charset = ARABIC_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ItemHeight = 13
      ItemIndex = 0
      ParentBiDiMode = False
      ParentFont = False
      TabOrder = 1
    end
    object PortCombo2: TsComboBox
      Left = 166
      Top = 69
      Width = 65
      Height = 21
      SelStart = 4
      SelLength = 0
      Text = 'COM2'
      Items.Strings = (
        'COM1'
        'COM2'
        'COM3'
        'COM4'
        'COM5'
        'COM6'
        'COM7'
        'COM8'
        'COM9'
        'COM10'
        'COM11'
        'COM12'
        'COM13'
        'COM14'
        'COM15'
        'COM16')
      Alignment = taLeftJustify
      BoundLabel.Indent = 0
      BoundLabel.Font.Charset = DEFAULT_CHARSET
      BoundLabel.Font.Color = clWindowText
      BoundLabel.Font.Height = -11
      BoundLabel.Font.Name = 'MS Sans Serif'
      BoundLabel.Font.Style = []
      BoundLabel.Layout = sclLeft
      BoundLabel.MaxWidth = 0
      BoundLabel.UseSkinColor = True
      SkinData.SkinSection = 'COMBOBOX'
      Style = csDropDownList
      Anchors = [akTop, akRight]
      BiDiMode = bdLeftToRight
      Color = clWhite
      Font.Charset = ARABIC_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ItemHeight = 13
      ItemIndex = 1
      ParentBiDiMode = False
      ParentFont = False
      TabOrder = 2
    end
    object NumOfLEDDisplaysCombo: TsComboBox
      Left = 166
      Top = 19
      Width = 65
      Height = 21
      SelStart = 1
      SelLength = 0
      Text = '1'
      Items.Strings = (
        '1'
        '2')
      Alignment = taLeftJustify
      BoundLabel.Indent = 0
      BoundLabel.Font.Charset = DEFAULT_CHARSET
      BoundLabel.Font.Color = clWindowText
      BoundLabel.Font.Height = -11
      BoundLabel.Font.Name = 'MS Sans Serif'
      BoundLabel.Font.Style = []
      BoundLabel.Layout = sclLeft
      BoundLabel.MaxWidth = 0
      BoundLabel.UseSkinColor = True
      SkinData.SkinSection = 'COMBOBOX'
      Style = csDropDownList
      Anchors = [akTop, akRight]
      BiDiMode = bdLeftToRight
      Color = clWhite
      Font.Charset = ARABIC_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ItemHeight = 13
      ItemIndex = 0
      ParentBiDiMode = False
      ParentFont = False
      TabOrder = 0
      OnChange = NumOfLEDDisplaysComboChange
    end
  end
  object OKBtn: TsBitBtn
    Left = 208
    Top = 398
    Width = 85
    Height = 25
    Cursor = crHandPoint
    Anchors = [akLeft, akBottom]
    Caption = #1578#1571#1740#1740#1583
    Default = True
    ModalResult = 1
    TabOrder = 4
    OnClick = OKBtnClick
    SkinData.SkinSection = 'BUTTON'
  end
  object CancelBtn: TsBitBtn
    Left = 118
    Top = 398
    Width = 85
    Height = 25
    Cursor = crHandPoint
    Anchors = [akLeft, akBottom]
    Cancel = True
    Caption = #1604#1594#1608
    ModalResult = 2
    TabOrder = 5
    OnClick = CancelBtnClick
    SkinData.SkinSection = 'BUTTON'
  end
  object AppearanceGroup: TsGroupBox
    Left = 8
    Top = 116
    Width = 383
    Height = 105
    Anchors = [akLeft, akTop, akRight]
    Caption = #1578#1606#1592#1610#1605#1575#1578' '#1606#1605#1575#1610#1588#1740
    TabOrder = 1
    CaptionLayout = clTopRight
    SkinData.SkinSection = 'GROUPBOX'
    DesignSize = (
      383
      105)
    object sLabel2: TsLabel
      Left = 319
      Top = 58
      Width = 52
      Height = 13
      Anchors = [akTop, akRight]
      Caption = #1578#1594#1740#1740#1585' '#1592#1575#1607#1585':'
      ParentFont = False
      Font.Charset = ARABIC_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
    end
    object sLabel3: TsLabel
      Left = 324
      Top = 24
      Width = 47
      Height = 13
      Anchors = [akTop, akRight]
      Caption = #1578#1594#1740#1740#1585' '#1585#1606#1711':'
      ParentFont = False
      Font.Charset = ARABIC_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
    end
    object HueOffsetTrackBar: TsDelayedTrackBar
      Left = 2
      Top = 21
      Width = 306
      Height = 33
      Cursor = crHandPoint
      Anchors = [akLeft, akTop, akRight]
      Max = 255
      PageSize = 1
      Position = 1
      TabOrder = 0
      TickStyle = tsNone
      SkinData.SkinSection = 'TRACKBAR'
      ChangeDelay = 500
      OnDelayedChange = HueOffsetTrackBarDelayedChange
    end
    object SkinTrackBar: TsDelayedTrackBar
      Left = 2
      Top = 54
      Width = 306
      Height = 33
      Cursor = crHandPoint
      Anchors = [akLeft, akTop, akRight]
      Max = 1
      Min = 1
      Frequency = 10
      Position = 1
      TabOrder = 1
      TickStyle = tsNone
      SkinData.SkinSection = 'TRACKBAR'
      ChangeDelay = 500
      OnDelayedChange = SkinTrackBarDelayedChange
    end
    object DontUseHighGUICheck: TsCheckBox
      Left = 144
      Top = 80
      Width = 230
      Height = 19
      Caption = #1593#1583#1605' '#1575#1587#1578#1601#1575#1583#1607' '#1575#1586' '#1580#1604#1608#1607' '#1607#1575#1740' '#1662#1740#1588#1585#1601#1578#1607' '#1606#1605#1575#1740#1588#1740
      Alignment = taLeftJustify
      Anchors = [akTop, akRight]
      AutoSize = False
      TabOrder = 2
      SkinData.SkinSection = 'CHECKBOX'
      ImgChecked = 0
      ImgUnchecked = 0
    end
  end
  object OtherSettingsGroup: TsGroupBox
    Left = 8
    Top = 287
    Width = 383
    Height = 100
    Anchors = [akLeft, akTop, akRight, akBottom]
    Caption = #1578#1606#1592#1740#1605#1575#1578' '#1583#1740#1711#1585
    TabOrder = 3
    CaptionLayout = clTopRight
    SkinData.SkinSection = 'GROUPBOX'
    DesignSize = (
      383
      100)
    object SelectPageEffectOnNewStageCheck: TsCheckBox
      Left = 16
      Top = 20
      Width = 360
      Height = 21
      Caption = #1606#1605#1575#1740#1588' '#1662#1606#1580#1585#1607' '#1575#1606#1578#1582#1575#1576' '#1575#1601#1705#1578' '#1589#1601#1581#1607' '#1607#1606#1711#1575#1605' '#1575#1590#1575#1601#1607' '#1705#1585#1583#1606' '#1605#1585#1581#1604#1607' '#1606#1605#1575#1740#1588#1740' '#1580#1583#1740#1583
      Alignment = taLeftJustify
      Anchors = [akTop, akRight]
      AutoSize = False
      Checked = True
      State = cbChecked
      TabOrder = 0
      SkinData.SkinSection = 'CHECKBOX'
      ImgChecked = 0
      ImgUnchecked = 0
    end
    object SelectPageLayoutOnNewStageCheck: TsCheckBox
      Left = 8
      Top = 48
      Width = 368
      Height = 19
      Caption = 
        #1606#1605#1575#1740#1588' '#1662#1606#1580#1585#1607' '#1575#1606#1578#1582#1575#1576' '#1670#1740#1583#1605#1575#1606' '#1589#1601#1581#1607' '#1607#1606#1711#1575#1605' '#1575#1590#1575#1601#1607' '#1705#1585#1583#1606' '#1605#1585#1581#1604#1607' '#1606#1605#1575#1740#1588#1740' '#1580#1583#1740 +
        #1583
      Alignment = taLeftJustify
      Anchors = [akTop, akRight]
      AutoSize = False
      TabOrder = 1
      SkinData.SkinSection = 'CHECKBOX'
      ImgChecked = 0
      ImgUnchecked = 0
    end
    object AutomaticallyRefreshTimePreviewCheck: TsCheckBox
      Left = 23
      Top = 72
      Width = 353
      Height = 19
      Caption = #1662#1740#1588' '#1606#1605#1575#1740#1588' '#1587#1575#1593#1578' '#1583#1585' '#1607#1585' '#1604#1581#1592#1607' '#1576#1591#1608#1585' '#1582#1608#1583#1705#1575#1585' '#1587#1575#1593#1578' '#1580#1575#1585#1740' '#1585#1575' '#1606#1605#1575#1740#1588' '#1583#1607#1583
      Alignment = taLeftJustify
      Anchors = [akTop, akRight]
      AutoSize = False
      Checked = True
      State = cbChecked
      TabOrder = 2
      SkinData.SkinSection = 'CHECKBOX'
      ImgChecked = 0
      ImgUnchecked = 0
    end
  end
  object DefaultAppearanceBtn: TsBitBtn
    Left = 8
    Top = 398
    Width = 100
    Height = 25
    Cursor = crHandPoint
    Anchors = [akLeft, akBottom]
    Caption = #1578#1606#1592#1740#1605#1575#1578' '#1662#1740#1588' '#1601#1585#1590
    TabOrder = 6
    OnClick = DefaultAppearanceBtnClick
    SkinData.SkinSection = 'BUTTON'
  end
  object SoundsGroup: TsGroupBox
    Left = 8
    Top = 228
    Width = 383
    Height = 52
    Anchors = [akLeft, akTop, akRight]
    Caption = #1578#1606#1592#1740#1605#1575#1578' '#1589#1583#1575
    TabOrder = 2
    CaptionLayout = clTopRight
    SkinData.SkinSection = 'GROUPBOX'
    DesignSize = (
      383
      52)
    object PlaySoundBtn: TsSpeedButton
      Left = 132
      Top = 20
      Width = 23
      Height = 21
      Cursor = crHandPoint
      Glyph.Data = {
        36030000424D3603000000000000360000002800000010000000100000000100
        18000000000000030000120B0000120B00000000000000000000FF00FFFF00FF
        FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
        FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
        00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
        FF00FFFF00FFFF00FFDEEAE0FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
        FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF096314DEEAE0FF
        00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
        FF00FFFF00FFFF00FF11681B04600FDEEAE0FF00FFFF00FFFF00FFFF00FFFF00
        FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF1A6F2420732C04
        600FDEEAE0FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
        FF00FFFF00FFFF00FF23752E2F833D20732C04600FDEEAE0FF00FFFF00FFFF00
        FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF2E7C3750A25A2F
        833D20732C04600FDEEAE0FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
        FF00FFFF00FFFF00FF3883415DB06850A25A2F833D20732C0B6618DEEAE0FF00
        FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF438A4C6BBF766B
        BF7650A25A2F7639D6EDD9FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
        FF00FFFF00FFFF00FF4B90536BBF76A3DAB02F7639D6EDD9FF00FFFF00FFFF00
        FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF52945AA3DAB02F
        7639D6EDD9FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
        FF00FFFF00FFFF00FF5898602F7639D6EDD9FF00FFFF00FFFF00FFFF00FFFF00
        FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF589860D6EDD9FF
        00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
        FF00FFFF00FFFF00FFD6EDD9FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
        FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
        00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF}
      OnClick = PlaySoundBtnClick
      SkinData.SkinSection = 'SPEEDBUTTON'
    end
    object PlaySoundOnDataChangeFinishedCheck: TsCheckBox
      Left = 184
      Top = 20
      Width = 192
      Height = 21
      Caption = #1662#1582#1588' '#1570#1607#1606#1711' '#1575#1578#1605#1575#1605' '#1578#1594#1740#1740#1585' '#1605#1581#1578#1608#1575#1740' '#1578#1575#1576#1604#1608
      Alignment = taLeftJustify
      Anchors = [akTop, akRight]
      AutoSize = False
      Checked = True
      State = cbChecked
      TabOrder = 0
      OnClick = PlaySoundOnDataChangeFinishedCheckClick
      SkinData.SkinSection = 'CHECKBOX'
      ImgChecked = 0
      ImgUnchecked = 0
    end
    object SoundsCombo: TsComboBox
      Left = 9
      Top = 20
      Width = 124
      Height = 21
      SelStart = 109708236
      SelLength = 2008582791
      Alignment = taRightJustify
      BoundLabel.Indent = 0
      BoundLabel.Font.Charset = DEFAULT_CHARSET
      BoundLabel.Font.Color = clWindowText
      BoundLabel.Font.Height = -11
      BoundLabel.Font.Name = 'MS Sans Serif'
      BoundLabel.Font.Style = []
      BoundLabel.Layout = sclLeft
      BoundLabel.MaxWidth = 0
      BoundLabel.UseSkinColor = True
      SkinData.SkinSection = 'COMBOBOX'
      Style = csDropDownList
      BiDiMode = bdLeftToRight
      Color = clWhite
      Font.Charset = ARABIC_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ItemHeight = 13
      ItemIndex = -1
      ParentBiDiMode = False
      ParentFont = False
      TabOrder = 1
      OnChange = SoundsComboChange
    end
  end
  object MediaPlayer1: TMediaPlayer
    Left = 43
    Top = 8
    Width = 29
    Height = 30
    VisibleButtons = [btPlay]
    Visible = False
    TabOrder = 7
    TabStop = False
  end
  object sSkinProvider1: TsSkinProvider
    CaptionAlignment = taCenter
    SkinData.SkinSection = 'FORM'
    MakeSkinMenu = False
    ShowAppIcon = False
    TitleButtons = <>
    Left = 8
    Top = 8
  end
  object OpenSoundDialog: TTntOpenDialog
    Filter = 'Sound File (*.wav, *.mp3)|*.wav;*.mp3'
    Options = [ofHideReadOnly, ofPathMustExist, ofFileMustExist, ofEnableSizing]
    Left = 8
    Top = 40
  end
  object HighGUITimer: TTimer
    Tag = 1
    Enabled = False
    Interval = 50
    OnTimer = HighGUITimerTimer
    Left = 77
    Top = 10
  end
end
