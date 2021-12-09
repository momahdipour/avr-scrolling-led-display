object SelectNormalEffectForm: TSelectNormalEffectForm
  Left = 680
  Top = 141
  BorderStyle = bsDialog
  Caption = #1575#1606#1578#1582#1575#1576' '#1575#1601#1705#1578' '#1570#1594#1575#1586#1610#1606
  ClientHeight = 600
  ClientWidth = 565
  Color = clBtnFace
  Font.Charset = ARABIC_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnClose = TntFormClose
  OnCreate = TntFormCreate
  OnShow = TntFormShow
  DesignSize = (
    565
    600)
  PixelsPerInch = 96
  TextHeight = 13
  object FinalSelectionPanel: TsPanel
    Left = 1
    Top = 87
    Width = 275
    Height = 76
    TabOrder = 19
    SkinData.SkinSection = 'PROGRESSH'
  end
  object SelectionPanel: TsPanel
    Left = 1
    Top = -2
    Width = 275
    Height = 76
    TabOrder = 17
    Visible = False
    SkinData.SkinSection = 'PROGRESSH'
  end
  object CancelBtn: TsBitBtn
    Left = 200
    Top = 566
    Width = 75
    Height = 25
    Cursor = crHandPoint
    Anchors = [akLeft, akBottom]
    Cancel = True
    Caption = #1604#1594#1608
    ModalResult = 2
    TabOrder = 18
    SkinData.SkinSection = 'BUTTON'
  end
  object VerticalPanel: TsPanel
    Left = 277
    Top = 13
    Width = 10
    Height = 493
    TabOrder = 0
    SkinData.SkinSection = 'PANEL'
  end
  object sGroupBox1: TsGroupBox
    Left = 11
    Top = 8
    Width = 255
    Height = 55
    Caption = '1'
    TabOrder = 1
    CaptionLayout = clTopCenter
    SkinData.SkinSection = 'GROUPBOX'
    object Effect1Image: TImage
      Left = 2
      Top = 15
      Width = 251
      Height = 38
      Cursor = crHandPoint
      Align = alClient
      Stretch = True
      OnClick = Effect1ImageClick
      OnDblClick = Effect1ImageDblClick
      OnMouseMove = Effect1ImageMouseMove
    end
  end
  object sGroupBox3: TsGroupBox
    Left = 11
    Top = 70
    Width = 255
    Height = 55
    Caption = '3'
    TabOrder = 2
    CaptionLayout = clTopCenter
    SkinData.SkinSection = 'GROUPBOX'
    object Effect2Image: TImage
      Left = 2
      Top = 15
      Width = 251
      Height = 38
      Cursor = crHandPoint
      Align = alClient
      Stretch = True
      OnClick = Effect1ImageClick
      OnDblClick = Effect1ImageDblClick
      OnMouseMove = Effect1ImageMouseMove
    end
  end
  object sGroupBox4: TsGroupBox
    Left = 11
    Top = 133
    Width = 255
    Height = 55
    Caption = '5'
    TabOrder = 3
    CaptionLayout = clTopCenter
    SkinData.SkinSection = 'GROUPBOX'
    object Effect3Image: TImage
      Left = 2
      Top = 15
      Width = 251
      Height = 38
      Cursor = crHandPoint
      Align = alClient
      Stretch = True
      OnClick = Effect1ImageClick
      OnDblClick = Effect1ImageDblClick
      OnMouseMove = Effect1ImageMouseMove
    end
  end
  object sGroupBox5: TsGroupBox
    Left = 11
    Top = 196
    Width = 255
    Height = 55
    Caption = '7'
    TabOrder = 4
    CaptionLayout = clTopCenter
    SkinData.SkinSection = 'GROUPBOX'
    object Effect4Image: TImage
      Left = 2
      Top = 15
      Width = 251
      Height = 38
      Cursor = crHandPoint
      Align = alClient
      Stretch = True
      OnClick = Effect1ImageClick
      OnDblClick = Effect1ImageDblClick
      OnMouseMove = Effect1ImageMouseMove
    end
  end
  object sGroupBox6: TsGroupBox
    Left = 11
    Top = 259
    Width = 255
    Height = 55
    Caption = '9'
    TabOrder = 5
    CaptionLayout = clTopCenter
    SkinData.SkinSection = 'GROUPBOX'
    object Effect5Image: TImage
      Left = 2
      Top = 15
      Width = 251
      Height = 38
      Cursor = crHandPoint
      Align = alClient
      Stretch = True
      OnClick = Effect1ImageClick
      OnDblClick = Effect1ImageDblClick
      OnMouseMove = Effect1ImageMouseMove
    end
  end
  object sGroupBox7: TsGroupBox
    Left = 11
    Top = 322
    Width = 255
    Height = 55
    Caption = '11'
    TabOrder = 6
    CaptionLayout = clTopCenter
    SkinData.SkinSection = 'GROUPBOX'
    object Effect6Image: TImage
      Left = 2
      Top = 15
      Width = 251
      Height = 38
      Cursor = crHandPoint
      Align = alClient
      Stretch = True
      OnClick = Effect1ImageClick
      OnDblClick = Effect1ImageDblClick
      OnMouseMove = Effect1ImageMouseMove
    end
  end
  object sGroupBox8: TsGroupBox
    Left = 11
    Top = 385
    Width = 255
    Height = 55
    Caption = '13'
    TabOrder = 7
    CaptionLayout = clTopCenter
    SkinData.SkinSection = 'GROUPBOX'
    object Effect7Image: TImage
      Left = 2
      Top = 15
      Width = 251
      Height = 38
      Cursor = crHandPoint
      Align = alClient
      Stretch = True
      OnClick = Effect1ImageClick
      OnDblClick = Effect1ImageDblClick
      OnMouseMove = Effect1ImageMouseMove
    end
  end
  object sGroupBox2: TsGroupBox
    Left = 299
    Top = 8
    Width = 255
    Height = 55
    Caption = '2'
    TabOrder = 8
    CaptionLayout = clTopCenter
    SkinData.SkinSection = 'GROUPBOX'
    object Effect9Image: TImage
      Left = 2
      Top = 15
      Width = 251
      Height = 38
      Cursor = crHandPoint
      Align = alClient
      Stretch = True
      OnClick = Effect1ImageClick
      OnDblClick = Effect1ImageDblClick
      OnMouseMove = Effect1ImageMouseMove
    end
  end
  object sGroupBox9: TsGroupBox
    Left = 299
    Top = 70
    Width = 255
    Height = 55
    Caption = '4'
    TabOrder = 9
    CaptionLayout = clTopCenter
    SkinData.SkinSection = 'GROUPBOX'
    object Effect10Image: TImage
      Left = 2
      Top = 15
      Width = 251
      Height = 38
      Cursor = crHandPoint
      Align = alClient
      Stretch = True
      OnClick = Effect1ImageClick
      OnDblClick = Effect1ImageDblClick
      OnMouseMove = Effect1ImageMouseMove
    end
  end
  object sGroupBox10: TsGroupBox
    Left = 299
    Top = 133
    Width = 255
    Height = 55
    Caption = '6'
    TabOrder = 10
    CaptionLayout = clTopCenter
    SkinData.SkinSection = 'GROUPBOX'
    object Effect11Image: TImage
      Left = 2
      Top = 15
      Width = 251
      Height = 38
      Cursor = crHandPoint
      Align = alClient
      Stretch = True
      OnClick = Effect1ImageClick
      OnDblClick = Effect1ImageDblClick
      OnMouseMove = Effect1ImageMouseMove
    end
  end
  object sGroupBox11: TsGroupBox
    Left = 299
    Top = 196
    Width = 255
    Height = 55
    Caption = '8'
    TabOrder = 11
    CaptionLayout = clTopCenter
    SkinData.SkinSection = 'GROUPBOX'
    object Effect12Image: TImage
      Left = 2
      Top = 15
      Width = 251
      Height = 38
      Cursor = crHandPoint
      Align = alClient
      Stretch = True
      OnClick = Effect1ImageClick
      OnDblClick = Effect1ImageDblClick
      OnMouseMove = Effect1ImageMouseMove
    end
  end
  object sGroupBox12: TsGroupBox
    Left = 299
    Top = 259
    Width = 255
    Height = 55
    Caption = '10'
    TabOrder = 12
    CaptionLayout = clTopCenter
    SkinData.SkinSection = 'GROUPBOX'
    object Effect13Image: TImage
      Left = 2
      Top = 15
      Width = 251
      Height = 38
      Cursor = crHandPoint
      Align = alClient
      Stretch = True
      OnClick = Effect1ImageClick
      OnDblClick = Effect1ImageDblClick
      OnMouseMove = Effect1ImageMouseMove
    end
  end
  object sGroupBox13: TsGroupBox
    Left = 299
    Top = 322
    Width = 255
    Height = 55
    Caption = '12'
    TabOrder = 13
    CaptionLayout = clTopCenter
    SkinData.SkinSection = 'GROUPBOX'
    object Effect14Image: TImage
      Left = 2
      Top = 15
      Width = 251
      Height = 38
      Cursor = crHandPoint
      Align = alClient
      Stretch = True
      OnClick = Effect1ImageClick
      OnDblClick = Effect1ImageDblClick
      OnMouseMove = Effect1ImageMouseMove
    end
  end
  object sGroupBox14: TsGroupBox
    Left = 299
    Top = 385
    Width = 255
    Height = 55
    Caption = '14'
    TabOrder = 14
    CaptionLayout = clTopCenter
    SkinData.SkinSection = 'GROUPBOX'
    object Effect15Image: TImage
      Left = 2
      Top = 15
      Width = 251
      Height = 38
      Cursor = crHandPoint
      Align = alClient
      Stretch = True
      OnClick = Effect1ImageClick
      OnDblClick = Effect1ImageDblClick
      OnMouseMove = Effect1ImageMouseMove
    end
  end
  object sGroupBox15: TsGroupBox
    Left = 11
    Top = 448
    Width = 255
    Height = 55
    Caption = '15'
    TabOrder = 15
    CaptionLayout = clTopCenter
    SkinData.SkinSection = 'GROUPBOX'
    object Effect8Image: TImage
      Left = 2
      Top = 15
      Width = 251
      Height = 38
      Cursor = crHandPoint
      Align = alClient
      Stretch = True
      OnClick = Effect1ImageClick
      OnDblClick = Effect1ImageDblClick
      OnMouseMove = Effect1ImageMouseMove
    end
  end
  object sGroupBox16: TsGroupBox
    Left = 297
    Top = 448
    Width = 255
    Height = 55
    Caption = '16'
    TabOrder = 16
    CaptionLayout = clTopCenter
    SkinData.SkinSection = 'GROUPBOX'
    object Effect16Image: TImage
      Left = 2
      Top = 15
      Width = 251
      Height = 38
      Cursor = crHandPoint
      Align = alClient
      Stretch = True
      OnClick = Effect1ImageClick
      OnDblClick = Effect1ImageDblClick
      OnMouseMove = Effect1ImageMouseMove
    end
  end
  object OKBtn: TsBitBtn
    Left = 280
    Top = 566
    Width = 85
    Height = 25
    Cursor = crHandPoint
    Anchors = [akRight, akBottom]
    BiDiMode = bdLeftToRight
    Caption = #1578#1571#1740#1740#1583
    Default = True
    ModalResult = 1
    ParentBiDiMode = False
    TabOrder = 20
    SkinData.SkinSection = 'BUTTON'
  end
  object TextMovementGroupBox: TsGroupBox
    Left = 8
    Top = 509
    Width = 545
    Height = 50
    Caption = #1587#1585#1593#1578' '#1575#1580#1585#1575#1740' '#1575#1601#1705#1578
    ParentBackground = False
    TabOrder = 21
    CaptionLayout = clTopRight
    SkinData.SkinSection = 'GROUPBOX'
    DesignSize = (
      545
      50)
    object sLabel14: TsLabel
      Left = 387
      Top = 21
      Width = 149
      Height = 13
      Anchors = [akTop, akRight]
      Caption = #1587#1585#1593#1578' '#1575#1580#1585#1575#1740' '#1575#1601#1705#1578' '#1576#1585' '#1585#1608#1740' '#1578#1575#1576#1604#1608':'
      ParentFont = False
      Font.Charset = ARABIC_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
    end
    object sLabel16: TsLabel
      Left = 317
      Top = 21
      Width = 54
      Height = 13
      Anchors = [akTop, akRight]
      Caption = #1582#1740#1604#1740' '#1587#1585#1740#1593
      ParentFont = False
      Font.Charset = ARABIC_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
    end
    object sLabel15: TsLabel
      Left = 13
      Top = 21
      Width = 46
      Height = 13
      Anchors = [akTop, akRight]
      Caption = #1582#1740#1604#1740' '#1570#1585#1575#1605
      ParentFont = False
      Font.Charset = ARABIC_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
    end
    object NormalEffectsSpeedTrackbar: TsTrackBar
      Left = 64
      Top = 17
      Width = 247
      Height = 29
      Cursor = crHandPoint
      Anchors = [akTop, akRight]
      LineSize = 20
      Max = 254
      Min = 5
      PageSize = 8
      Frequency = 16
      Position = 128
      TabOrder = 0
      OnChange = NormalEffectsSpeedTrackbarChange
      SkinData.SkinSection = 'TRACKBAR'
    end
  end
  object sSkinProvider1: TsSkinProvider
    CaptionAlignment = taCenter
    SkinData.SkinSection = 'FORM'
    MakeSkinMenu = False
    ShowAppIcon = False
    TitleButtons = <>
    Left = 43
    Top = 56
  end
  object HighGUITimer: TTimer
    Tag = 1
    Enabled = False
    Interval = 50
    OnTimer = HighGUITimerTimer
    Left = 5
    Top = 2
  end
end
