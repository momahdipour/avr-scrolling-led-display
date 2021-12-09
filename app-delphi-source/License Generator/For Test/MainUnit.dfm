object MainForm: TMainForm
  Left = 508
  Top = 46
  BorderStyle = bsDialog
  Caption = 'LED Font Generator 2.0.3 Activation Code Generator'
  ClientHeight = 534
  ClientWidth = 408
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object PSWPanel: TPanel
    Left = 0
    Top = 0
    Width = 408
    Height = 534
    Align = alClient
    TabOrder = 1
    object PSWLabel: TLabel
      Left = 56
      Top = 92
      Width = 76
      Height = 13
      Caption = 'Enter password:'
    end
    object PSWEdit: TEdit
      Left = 136
      Top = 87
      Width = 185
      Height = 24
      Font.Charset = ARABIC_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      PasswordChar = '*'
      TabOrder = 0
      OnKeyPress = PSWEditKeyPress
    end
  end
  object MainPanel: TPanel
    Left = 0
    Top = 0
    Width = 408
    Height = 534
    Align = alClient
    TabOrder = 0
    Visible = False
    object Label1: TLabel
      Left = 20
      Top = 50
      Width = 61
      Height = 13
      Caption = 'Customer ID:'
    end
    object Label2: TLabel
      Left = 20
      Top = 126
      Width = 78
      Height = 13
      Caption = 'Activation Code:'
    end
    object Label3: TLabel
      Left = 159
      Top = 48
      Width = 4
      Height = 16
      Caption = '-'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label4: TLabel
      Left = 207
      Top = 48
      Width = 4
      Height = 16
      Caption = '-'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label5: TLabel
      Left = 255
      Top = 48
      Width = 4
      Height = 16
      Caption = '-'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label6: TLabel
      Left = 159
      Top = 126
      Width = 4
      Height = 16
      Caption = '-'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label7: TLabel
      Left = 207
      Top = 126
      Width = 4
      Height = 16
      Caption = '-'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label8: TLabel
      Left = 255
      Top = 126
      Width = 4
      Height = 16
      Caption = '-'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label9: TLabel
      Left = 351
      Top = 48
      Width = 4
      Height = 16
      Caption = '-'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label10: TLabel
      Left = 303
      Top = 48
      Width = 4
      Height = 16
      Caption = '-'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label11: TLabel
      Left = 351
      Top = 125
      Width = 4
      Height = 16
      Caption = '-'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label12: TLabel
      Left = 303
      Top = 125
      Width = 4
      Height = 16
      Caption = '-'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label13: TLabel
      Left = 16
      Top = 232
      Width = 36
      Height = 13
      Caption = 'CPUID:'
    end
    object Label14: TLabel
      Left = 16
      Top = 272
      Width = 46
      Height = 13
      Caption = 'BIOSInfo:'
    end
    object Label15: TLabel
      Left = 16
      Top = 312
      Width = 37
      Height = 13
      Caption = 'MBInfo:'
    end
    object Label16: TLabel
      Left = 16
      Top = 344
      Width = 45
      Height = 13
      Caption = 'HDSerial:'
    end
    object CUIDWord4: TEdit
      Left = 260
      Top = 46
      Width = 41
      Height = 19
      Ctl3D = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Dialog'
      Font.Style = []
      MaxLength = 4
      ParentCtl3D = False
      ParentFont = False
      TabOrder = 4
      OnKeyPress = CUIDWord1KeyPress
      OnKeyUp = CUIDWord1KeyUp
    end
    object CUIDWord3: TEdit
      Left = 212
      Top = 46
      Width = 41
      Height = 19
      Ctl3D = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Dialog'
      Font.Style = []
      MaxLength = 4
      ParentCtl3D = False
      ParentFont = False
      TabOrder = 3
      OnKeyPress = CUIDWord1KeyPress
      OnKeyUp = CUIDWord1KeyUp
    end
    object CUIDWord2: TEdit
      Left = 164
      Top = 46
      Width = 41
      Height = 19
      Ctl3D = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Dialog'
      Font.Style = []
      MaxLength = 4
      ParentCtl3D = False
      ParentFont = False
      TabOrder = 2
      OnKeyPress = CUIDWord1KeyPress
      OnKeyUp = CUIDWord1KeyUp
    end
    object CUIDWord1: TEdit
      Left = 116
      Top = 46
      Width = 41
      Height = 19
      Ctl3D = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Dialog'
      Font.Style = []
      MaxLength = 4
      ParentCtl3D = False
      ParentFont = False
      TabOrder = 1
      OnKeyPress = CUIDWord1KeyPress
      OnKeyUp = CUIDWord1KeyUp
    end
    object ACWord1: TEdit
      Left = 116
      Top = 123
      Width = 41
      Height = 19
      Color = clCream
      Ctl3D = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Dialog'
      Font.Style = []
      MaxLength = 4
      ParentCtl3D = False
      ParentFont = False
      ReadOnly = True
      TabOrder = 7
    end
    object ACWord2: TEdit
      Left = 164
      Top = 123
      Width = 41
      Height = 19
      Color = clCream
      Ctl3D = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Dialog'
      Font.Style = []
      MaxLength = 4
      ParentCtl3D = False
      ParentFont = False
      ReadOnly = True
      TabOrder = 8
    end
    object ACWord3: TEdit
      Left = 212
      Top = 123
      Width = 41
      Height = 19
      Color = clCream
      Ctl3D = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Dialog'
      Font.Style = []
      MaxLength = 4
      ParentCtl3D = False
      ParentFont = False
      ReadOnly = True
      TabOrder = 9
    end
    object ACWord4: TEdit
      Left = 260
      Top = 123
      Width = 41
      Height = 19
      Color = clCream
      Ctl3D = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Dialog'
      Font.Style = []
      MaxLength = 4
      ParentCtl3D = False
      ParentFont = False
      ReadOnly = True
      TabOrder = 10
    end
    object CUIDWord6: TEdit
      Left = 356
      Top = 46
      Width = 41
      Height = 19
      Ctl3D = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Dialog'
      Font.Style = []
      MaxLength = 4
      ParentCtl3D = False
      ParentFont = False
      TabOrder = 6
      OnKeyPress = CUIDWord1KeyPress
      OnKeyUp = CUIDWord1KeyUp
    end
    object CUIDWord5: TEdit
      Left = 308
      Top = 46
      Width = 41
      Height = 19
      Ctl3D = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Dialog'
      Font.Style = []
      MaxLength = 4
      ParentCtl3D = False
      ParentFont = False
      TabOrder = 5
      OnKeyPress = CUIDWord1KeyPress
      OnKeyUp = CUIDWord1KeyUp
    end
    object ACWord6: TEdit
      Left = 356
      Top = 123
      Width = 41
      Height = 19
      Ctl3D = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Dialog'
      Font.Style = []
      MaxLength = 4
      ParentCtl3D = False
      ParentFont = False
      TabOrder = 12
      OnKeyPress = CUIDWord1KeyPress
      OnKeyUp = CUIDWord1KeyUp
    end
    object ACWord5: TEdit
      Left = 308
      Top = 123
      Width = 41
      Height = 19
      Ctl3D = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Dialog'
      Font.Style = []
      MaxLength = 4
      ParentCtl3D = False
      ParentFont = False
      TabOrder = 11
      OnKeyPress = CUIDWord1KeyPress
      OnKeyUp = CUIDWord1KeyUp
    end
    object GenerateCUIDBtn: TBitBtn
      Left = 148
      Top = 11
      Width = 165
      Height = 25
      Caption = 'Generate CUID for this machine'
      TabOrder = 13
      Visible = False
      OnClick = GenerateCUIDBtnClick
    end
    object GenerateACBtn: TBitBtn
      Left = 164
      Top = 82
      Width = 139
      Height = 25
      Caption = 'Generate Activation Code'
      TabOrder = 14
      OnClick = GenerateACBtnClick
    end
    object CopyACToClipboardBtn: TBitBtn
      Left = 180
      Top = 155
      Width = 105
      Height = 25
      Caption = 'Copy to Clipboard'
      TabOrder = 15
      OnClick = CopyACToClipboardBtnClick
    end
    object Edit1: TEdit
      Left = 69
      Top = 228
      Width = 284
      Height = 21
      TabOrder = 16
      Text = 'Edit1'
    end
    object Edit2: TEdit
      Left = 69
      Top = 264
      Width = 284
      Height = 21
      TabOrder = 17
      Text = 'Edit2'
    end
    object Edit3: TEdit
      Left = 69
      Top = 296
      Width = 284
      Height = 21
      TabOrder = 18
      Text = 'Edit3'
    end
    object Edit4: TEdit
      Left = 69
      Top = 336
      Width = 284
      Height = 21
      TabOrder = 19
      Text = 'Edit4'
    end
    object Button1: TButton
      Left = 16
      Top = 392
      Width = 75
      Height = 25
      Caption = 'Generate'
      TabOrder = 0
      OnClick = Button1Click
    end
    object Button2: TButton
      Left = 112
      Top = 392
      Width = 81
      Height = 25
      Caption = 'Save'
      TabOrder = 20
    end
    object CheckBox1: TCheckBox
      Left = 16
      Top = 424
      Width = 97
      Height = 17
      Caption = 'Check enabled'
      TabOrder = 21
    end
  end
end
