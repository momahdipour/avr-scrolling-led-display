object SelectPageEffectForm: TSelectPageEffectForm
  Left = 137
  Top = 188
  BorderStyle = bsDialog
  Caption = #1575#1606#1578#1582#1575#1576' '#1575#1601#1705#1578' '#1589#1601#1581#1607
  ClientHeight = 491
  ClientWidth = 565
  Color = clBtnFace
  Font.Charset = ARABIC_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poDesktopCenter
  OnKeyDown = TntFormKeyDown
  OnShow = TntFormShow
  DesignSize = (
    565
    491)
  PixelsPerInch = 96
  TextHeight = 13
  object NoEffectBtn: TsBitBtn
    Left = 325
    Top = 458
    Width = 75
    Height = 25
    Cursor = crHandPoint
    Anchors = [akLeft, akBottom]
    Caption = #1576#1583#1608#1606' '#1575#1601#1705#1578
    TabOrder = 13
    OnClick = NoEffectBtnClick
    SkinData.SkinSection = 'BUTTON'
  end
  object SelectionPanel: TsPanel
    Left = 1
    Top = -1
    Width = 275
    Height = 107
    TabOrder = 0
    SkinData.SkinSection = 'PROGRESSH'
  end
  object sGroupBox1: TsGroupBox
    Left = 11
    Top = 8
    Width = 255
    Height = 88
    Caption = '1'
    TabOrder = 1
    CaptionLayout = clTopCenter
    SkinData.SkinSection = 'GROUPBOX'
    object Effect1Image: TImage
      Left = 2
      Top = 15
      Width = 251
      Height = 71
      Cursor = crHandPoint
      Align = alClient
      Stretch = True
      OnClick = Effect1ImageClick
      OnMouseMove = Effect1ImageMouseMove
    end
  end
  object CancelBtn: TsBitBtn
    Left = 165
    Top = 458
    Width = 75
    Height = 25
    Cursor = crHandPoint
    Anchors = [akLeft, akBottom]
    Cancel = True
    Caption = #1604#1594#1608
    ModalResult = 2
    TabOrder = 14
    SkinData.SkinSection = 'BUTTON'
  end
  object sPanel1: TsPanel
    Left = 11
    Top = 104
    Width = 544
    Height = 9
    TabOrder = 3
    SkinData.SkinSection = 'PANEL'
  end
  object sGroupBox2: TsGroupBox
    Left = 11
    Top = 120
    Width = 255
    Height = 88
    Caption = '3'
    TabOrder = 4
    CaptionLayout = clTopCenter
    SkinData.SkinSection = 'GROUPBOX'
    object Effect3Image: TImage
      Left = 2
      Top = 15
      Width = 251
      Height = 71
      Cursor = crHandPoint
      Align = alClient
      Stretch = True
      OnClick = Effect1ImageClick
      OnMouseMove = Effect1ImageMouseMove
    end
  end
  object sGroupBox3: TsGroupBox
    Left = 11
    Top = 232
    Width = 255
    Height = 88
    Caption = '5'
    TabOrder = 5
    CaptionLayout = clTopCenter
    SkinData.SkinSection = 'GROUPBOX'
    object Effect5Image: TImage
      Left = 2
      Top = 15
      Width = 251
      Height = 71
      Cursor = crHandPoint
      Align = alClient
      Stretch = True
      OnClick = Effect1ImageClick
      OnMouseMove = Effect1ImageMouseMove
    end
  end
  object sGroupBox4: TsGroupBox
    Left = 11
    Top = 345
    Width = 255
    Height = 88
    Caption = '7'
    TabOrder = 6
    CaptionLayout = clTopCenter
    SkinData.SkinSection = 'GROUPBOX'
    object Effect7Image: TImage
      Left = 2
      Top = 15
      Width = 251
      Height = 71
      Cursor = crHandPoint
      Align = alClient
      Stretch = True
      OnClick = Effect1ImageClick
      OnMouseMove = Effect1ImageMouseMove
    end
  end
  object sPanel2: TsPanel
    Left = 11
    Top = 216
    Width = 544
    Height = 9
    TabOrder = 7
    SkinData.SkinSection = 'PANEL'
  end
  object sPanel3: TsPanel
    Left = 11
    Top = 328
    Width = 544
    Height = 9
    TabOrder = 8
    SkinData.SkinSection = 'PANEL'
  end
  object sGroupBox5: TsGroupBox
    Left = 299
    Top = 8
    Width = 255
    Height = 88
    Caption = '2'
    TabOrder = 9
    CaptionLayout = clTopCenter
    SkinData.SkinSection = 'GROUPBOX'
    object Effect2Image: TImage
      Left = 2
      Top = 15
      Width = 251
      Height = 71
      Cursor = crHandPoint
      Align = alClient
      Stretch = True
      OnClick = Effect1ImageClick
      OnMouseMove = Effect1ImageMouseMove
    end
  end
  object sGroupBox6: TsGroupBox
    Left = 299
    Top = 120
    Width = 255
    Height = 88
    Caption = '4'
    TabOrder = 10
    CaptionLayout = clTopCenter
    SkinData.SkinSection = 'GROUPBOX'
    object Effect4Image: TImage
      Left = 2
      Top = 15
      Width = 251
      Height = 71
      Cursor = crHandPoint
      Align = alClient
      Stretch = True
      OnClick = Effect1ImageClick
      OnMouseMove = Effect1ImageMouseMove
    end
  end
  object sGroupBox7: TsGroupBox
    Left = 299
    Top = 232
    Width = 255
    Height = 88
    Caption = '6'
    TabOrder = 11
    CaptionLayout = clTopCenter
    SkinData.SkinSection = 'GROUPBOX'
    object Effect6Image: TImage
      Left = 2
      Top = 15
      Width = 251
      Height = 71
      Cursor = crHandPoint
      Align = alClient
      Stretch = True
      OnClick = Effect1ImageClick
      OnMouseMove = Effect1ImageMouseMove
    end
  end
  object sGroupBox8: TsGroupBox
    Left = 299
    Top = 345
    Width = 255
    Height = 88
    Caption = '8'
    TabOrder = 12
    CaptionLayout = clTopCenter
    SkinData.SkinSection = 'GROUPBOX'
    object Effect8Image: TImage
      Left = 2
      Top = 15
      Width = 251
      Height = 71
      Cursor = crHandPoint
      Align = alClient
      Stretch = True
      OnClick = Effect1ImageClick
      OnMouseMove = Effect1ImageMouseMove
    end
  end
  object VerticalPanel: TsPanel
    Left = 277
    Top = 13
    Width = 10
    Height = 420
    TabOrder = 2
    SkinData.SkinSection = 'PANEL'
  end
  object sSkinProvider1: TsSkinProvider
    CaptionAlignment = taCenter
    SkinData.SkinSection = 'FORM'
    MakeSkinMenu = False
    ShowAppIcon = False
    TitleButtons = <>
    Left = 16
    Top = 16
  end
end
