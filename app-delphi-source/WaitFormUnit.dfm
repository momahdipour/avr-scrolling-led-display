object WaitForm: TWaitForm
  Left = 490
  Top = 367
  BorderIcons = []
  BorderStyle = bsNone
  Caption = #1604#1591#1601#1575#1611' '#1605#1606#1578#1592#1585' '#1576#1605#1575#1606#1740#1583
  ClientHeight = 81
  ClientWidth = 262
  Color = clBtnFace
  Font.Charset = ARABIC_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  OnCreate = TntFormCreate
  OnShow = TntFormShow
  PixelsPerInch = 96
  TextHeight = 13
  object MainPanel: TsPanel
    Left = 0
    Top = 0
    Width = 262
    Height = 81
    Align = alClient
    TabOrder = 0
    SkinData.SkinSection = 'DIALOG'
    object MessageImage: TImage
      Left = 77
      Top = 13
      Width = 107
      Height = 31
      Transparent = True
    end
    object MessageLabel: TsLabel
      Left = 10
      Top = 55
      Width = 241
      Height = 13
      Alignment = taCenter
      AutoSize = False
      BiDiMode = bdRightToLeft
      Caption = #1604#1591#1601#1575#1611' '#1605#1606#1578#1592#1585' '#1576#1605#1575#1606#1740#1583
      ParentBiDiMode = False
      ParentFont = False
      Font.Charset = ARABIC_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
    end
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
end
