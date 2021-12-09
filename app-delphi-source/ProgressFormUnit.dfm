object ProgressForm: TProgressForm
  Left = 601
  Top = 274
  BorderIcons = []
  BorderStyle = bsDialog
  ClientHeight = 110
  ClientWidth = 473
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Progress: TsGauge
    Left = 8
    Top = 40
    Width = 457
    Height = 25
    SkinData.SkinSection = 'GAUGE'
    ForeColor = clBlack
    Suffix = '%'
  end
  object sLabel1: TsLabel
    Left = 360
    Top = 8
    Width = 104
    Height = 13
    BiDiMode = bdRightToLeft
    Caption = #1583#1585' '#1581#1575#1604' '#1575#1606#1580#1575#1605' '#1593#1605#1604#1740#1575#1578'...'
    ParentBiDiMode = False
    ParentFont = False
    Font.Charset = ARABIC_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
  end
  object CancelBtn: TsSpeedButton
    Left = 208
    Top = 79
    Width = 57
    Height = 22
    Cursor = crHandPoint
    Caption = #1578#1608#1602#1601
    Visible = False
    SkinData.SkinSection = 'SPEEDBUTTON'
  end
  object sSkinProvider1: TsSkinProvider
    CaptionAlignment = taCenter
    SkinData.SkinSection = 'FORM'
    MakeSkinMenu = False
    TitleButtons = <>
    Left = 8
    Top = 8
  end
end
