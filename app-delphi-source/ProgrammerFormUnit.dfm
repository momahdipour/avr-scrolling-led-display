object ProgrammerForm: TProgrammerForm
  Left = 352
  Top = 298
  BorderIcons = []
  BorderStyle = bsDialog
  Caption = #1606#1605#1575#1740#1588' '#1576#1585' '#1585#1608#1740' '#1578#1575#1576#1604#1608
  ClientHeight = 110
  ClientWidth = 473
  Color = clBtnFace
  Font.Charset = ARABIC_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnDestroy = TntFormDestroy
  OnShow = TntFormShow
  PixelsPerInch = 96
  TextHeight = 13
  object SendProgress: TsGauge
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
    OnClick = CancelBtnClick
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
  object KDSerialPort1: KDSerialPort
    Version = '3.5 (Build 61)'
    BufferIn.Size = 4000
    BufferIn.Enabled = False
    ManualSettings.Port = pnCOM1
    ManualSettings.BaudRate = br115200
    ManualSettings.DataBits = db8Bits
    ManualSettings.StopBits = sb1Bits
    ManualSettings.Parity = ptNone
    ManualSettings.HardwareFlow = hfRTSCTS
    ManualSettings.SoftwareFlow = sfNone
    MaxReceiveSize = 4096
    MaxSendSize = 4096
    MonitorReceiveData = False
    TimerEnabled = False
    TimerInterval = 0
    OnReceiveData = KDSerialPort1ReceiveData
    Left = 8
    Top = 40
  end
  object StartTimer: TTimer
    Enabled = False
    Interval = 500
    OnTimer = StartTimerTimer
    Left = 40
    Top = 8
  end
end
