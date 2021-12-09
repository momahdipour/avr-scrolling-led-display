object AlarmProgressForm: TAlarmProgressForm
  Left = 354
  Top = 139
  BorderIcons = []
  BorderStyle = bsDialog
  Caption = #1570#1604#1575#1585#1605
  ClientHeight = 110
  ClientWidth = 473
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poDesktopCenter
  OnDestroy = TntFormDestroy
  OnKeyDown = TntFormKeyDown
  PixelsPerInch = 96
  TextHeight = 13
  object AlarmProgress: TsGauge
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
    Caption = #1583#1585' '#1581#1575#1604' '#1575#1606#1580#1575#1605' '#1593#1605#1604#1740#1575#1578'...'
    ParentFont = False
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
  end
  object CancelOperationBtn: TsSpeedButton
    Left = 208
    Top = 79
    Width = 57
    Height = 22
    Cursor = crHandPoint
    Caption = #1578#1608#1602#1601
    OnClick = CancelOperationBtnClick
    SkinData.SkinSection = 'SPEEDBUTTON'
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
end
