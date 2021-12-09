object LayoutForm: TLayoutForm
  Left = 453
  Top = 211
  Width = 706
  Height = 481
  BorderIcons = [biSystemMenu]
  Caption = #1575#1606#1578#1582#1575#1576' '#1670#1610#1583#1605#1575#1606' '#1589#1601#1581#1607
  Color = clBtnFace
  Font.Charset = ARABIC_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = TntFormCreate
  OnResize = TntFormResize
  OnShow = TntFormShow
  DesignSize = (
    698
    447)
  PixelsPerInch = 96
  TextHeight = 13
  object SelectionPanel: TsPanel
    Left = 8
    Top = 2
    Width = 214
    Height = 123
    TabOrder = 6
    SkinData.SkinSection = 'DIALOG'
  end
  object CancelBtn: TsBitBtn
    Left = 193
    Top = 413
    Width = 75
    Height = 25
    Cursor = crHandPoint
    Anchors = [akLeft, akBottom]
    Cancel = True
    Caption = #1604#1594#1608
    ModalResult = 2
    TabOrder = 0
    SkinData.SkinSection = 'BUTTON'
  end
  object LayoutGroup: TsGroupBox
    Left = 12
    Top = 10
    Width = 203
    Height = 106
    ParentBackground = False
    TabOrder = 3
    Visible = False
    OnClick = LayoutGroupClick
    OnMouseMove = LayoutGroupMouseMove
    SkinData.SkinSection = 'GROUPBOX'
    object LayoutBtn1: TsSpeedButton
      Tag = 1
      Left = 56
      Top = 37
      Width = 43
      Height = 45
      Cursor = crHandPoint
      GroupIndex = 1
      Down = True
      Flat = True
      SkinData.SkinSection = 'PROGRESSH'
    end
    object LayoutBtn2: TsSpeedButton
      Tag = 2
      Left = 53
      Top = 8
      Width = 43
      Height = 9
      Cursor = crHandPoint
      GroupIndex = 2
      Down = True
      Flat = True
      SkinData.SkinSection = 'PROGRESSH'
    end
    object LayoutBtn3: TsSpeedButton
      Tag = 3
      Left = 1
      Top = 84
      Width = 200
      Height = 21
      Cursor = crHandPoint
      GroupIndex = 3
      Down = True
      Flat = True
      SkinData.SkinSection = 'PROGRESSH'
    end
    object LayoutBtn4: TsSpeedButton
      Tag = 4
      Left = 190
      Top = 72
      Width = 43
      Height = 35
      Cursor = crHandPoint
      GroupIndex = 4
      Down = True
      Flat = True
      SkinData.SkinSection = 'PROGRESSH'
    end
  end
  object VerticalPanel: TsPanel
    Left = 226
    Top = 11
    Width = 10
    Height = 391
    Anchors = [akLeft, akTop, akBottom]
    TabOrder = 4
    SkinData.SkinSection = 'PANEL'
  end
  object sGroupBox1: TsGroupBox
    Left = 247
    Top = 10
    Width = 203
    Height = 106
    ParentBackground = False
    TabOrder = 5
    Visible = False
    SkinData.SkinSection = 'GROUPBOX'
    object sSpeedButton1: TsSpeedButton
      Tag = 1
      Left = 8
      Top = 5
      Width = 43
      Height = 41
      Cursor = crHandPoint
      GroupIndex = 1
      Down = True
      Flat = True
      SkinData.SkinSection = 'PROGRESSH'
    end
    object sSpeedButton2: TsSpeedButton
      Tag = 2
      Left = 53
      Top = 8
      Width = 43
      Height = 41
      Cursor = crHandPoint
      GroupIndex = 2
      Down = True
      Flat = True
      SkinData.SkinSection = 'PROGRESSH'
    end
    object sSpeedButton3: TsSpeedButton
      Tag = 3
      Left = 1
      Top = 48
      Width = 88
      Height = 33
      Cursor = crHandPoint
      GroupIndex = 3
      Down = True
      Flat = True
      SkinData.SkinSection = 'PROGRESSH'
    end
    object sSpeedButton4: TsSpeedButton
      Tag = 4
      Left = 70
      Top = 32
      Width = 43
      Height = 35
      Cursor = crHandPoint
      GroupIndex = 4
      Down = True
      Flat = True
      SkinData.SkinSection = 'PROGRESSH'
    end
  end
  object CreateCustomLayoutBtn: TsBitBtn
    Left = 485
    Top = 405
    Width = 163
    Height = 37
    Cursor = crHandPoint
    Anchors = [akLeft, akBottom]
    Caption = #1575#1740#1580#1575#1583' '#1670#1740#1583#1605#1575#1606' '#1583#1604#1582#1608#1575#1607'...'
    ModalResult = 2
    TabOrder = 1
    SkinData.SkinSection = 'BUTTON'
  end
  object SameAsPrviousStageLayoutBtn: TsBitBtn
    Left = 50
    Top = 405
    Width = 163
    Height = 37
    Cursor = crHandPoint
    Anchors = [akLeft, akBottom]
    Caption = #1670#1740#1583#1605#1575#1606' '#1605#1585#1581#1604#1607' '#1606#1605#1575#1740#1588#1740' '#1602#1576#1604#1740
    ModalResult = 2
    TabOrder = 2
    SkinData.SkinSection = 'BUTTON'
  end
  object sPanel1: TsPanel
    Left = 458
    Top = 11
    Width = 10
    Height = 391
    Anchors = [akLeft, akTop, akBottom]
    TabOrder = 7
    SkinData.SkinSection = 'PANEL'
  end
  object sSkinProvider1: TsSkinProvider
    CaptionAlignment = taCenter
    SkinData.SkinSection = 'FORM'
    MakeSkinMenu = False
    ShowAppIcon = False
    TitleButtons = <>
    Top = 176
  end
end
