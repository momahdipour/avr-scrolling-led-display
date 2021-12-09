object AnimationLineSummaryForm: TAnimationLineSummaryForm
  Left = 313
  Top = 167
  Width = 670
  Height = 576
  BorderIcons = [biSystemMenu]
  Caption = #1582#1604#1575#1589#1607' '#1606#1605#1575#1740#1588
  Color = clBtnFace
  Constraints.MinHeight = 240
  Constraints.MinWidth = 240
  Font.Charset = ARABIC_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnDestroy = TntFormDestroy
  OnHide = TntFormHide
  OnResize = TntFormResize
  OnShow = TntFormShow
  DesignSize = (
    662
    542)
  PixelsPerInch = 96
  TextHeight = 13
  object OKBtn: TsBitBtn
    Left = 250
    Top = 509
    Width = 75
    Height = 25
    Cursor = crHandPoint
    Anchors = [akLeft, akBottom]
    Cancel = True
    Caption = #1578#1571#1740#1740#1583
    Default = True
    ModalResult = 1
    TabOrder = 0
    SkinData.SkinSection = 'BUTTON'
  end
  object ScrollBox1: TScrollBox
    Left = 6
    Top = 10
    Width = 649
    Height = 490
    VertScrollBar.Smooth = True
    VertScrollBar.Tracking = True
    Anchors = [akLeft, akTop, akRight, akBottom]
    BiDiMode = bdLeftToRight
    ParentBiDiMode = False
    TabOrder = 1
    DesignSize = (
      645
      486)
    object RefStageGroup: TsGroupBox
      Left = 6
      Top = 3
      Width = 635
      Height = 42
      Anchors = [akLeft, akTop, akRight]
      Caption = #1605#1585#1581#1604#1607
      TabOrder = 0
      Visible = False
      CaptionLayout = clTopRight
      SkinData.SkinSection = 'GROUPBOX'
      CaptionSkin = 'ALPHAEDIT'
      DesignSize = (
        635
        42)
      object RefAreaLabel: TsLabel
        Left = 594
        Top = 22
        Width = 31
        Height = 13
        Anchors = [akTop, akRight]
        BiDiMode = bdRightToLeft
        Caption = #1587#1575#1593#1578
        Color = clLime
        ParentBiDiMode = False
        ParentColor = False
        ParentFont = False
        Transparent = False
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        UseSkinColor = False
      end
    end
    object NoStagePanel: TsPanel
      Left = 12
      Top = 10
      Width = 620
      Height = 18
      Anchors = [akLeft, akTop, akRight]
      Caption = #1607#1740#1670' '#1605#1585#1581#1604#1607' '#1606#1605#1575#1740#1588#1740' '#1605#1608#1580#1608#1583' '#1606#1740#1587#1578
      TabOrder = 1
      SkinData.SkinSection = 'ALPHAEDIT'
    end
  end
  object sSkinProvider1: TsSkinProvider
    CaptionAlignment = taCenter
    SkinData.SkinSection = 'FORM'
    MakeSkinMenu = False
    ShowAppIcon = False
    TitleButtons = <>
    Left = 24
    Top = 8
  end
end
