object MainForm: TMainForm
  Left = 406
  Top = 199
  BorderStyle = bsDialog
  Caption = 'LED Display Control Software 1.0 Activation Code Generator'
  ClientHeight = 349
  ClientWidth = 434
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 13
  object PSWPanel: TPanel
    Left = 0
    Top = 0
    Width = 434
    Height = 349
    Align = alClient
    TabOrder = 1
    object PSWLabel: TLabel
      Left = 56
      Top = 92
      Width = 79
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
    Width = 434
    Height = 349
    Align = alClient
    TabOrder = 0
    object Label1: TLabel
      Left = 20
      Top = 202
      Width = 64
      Height = 13
      Caption = 'Customer ID:'
    end
    object Label2: TLabel
      Left = 20
      Top = 278
      Width = 80
      Height = 13
      Caption = 'Activation Code:'
    end
    object Label3: TLabel
      Left = 159
      Top = 200
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
      Top = 200
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
      Top = 200
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
      Top = 278
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
      Top = 278
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
      Top = 278
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
    object GenerateCUIDBtn: TSpeedButton
      Left = 148
      Top = 163
      Width = 165
      Height = 25
      Caption = 'Generate CUID for this machine'
      OnClick = GenerateCUIDBtnClick
    end
    object GenerateACBtn: TSpeedButton
      Left = 164
      Top = 234
      Width = 139
      Height = 25
      Caption = 'Generate Activation Code'
      OnClick = GenerateACBtnClick
    end
    object CopyACToClipboardBtn: TSpeedButton
      Left = 180
      Top = 307
      Width = 105
      Height = 25
      Caption = 'Copy to Clipboard'
      OnClick = CopyACToClipboardBtnClick
    end
    object Label9: TLabel
      Left = 351
      Top = 200
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
      Top = 200
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
      Top = 277
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
      Top = 277
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
    object CUIDWord4: TEdit
      Left = 260
      Top = 198
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
    object CUIDWord3: TEdit
      Left = 212
      Top = 198
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
    object CUIDWord2: TEdit
      Left = 164
      Top = 198
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
    object CUIDWord1: TEdit
      Left = 116
      Top = 198
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
      TabOrder = 0
      OnKeyPress = CUIDWord1KeyPress
      OnKeyUp = CUIDWord1KeyUp
    end
    object ACWord1: TEdit
      Left = 116
      Top = 275
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
      TabOrder = 6
    end
    object ACWord2: TEdit
      Left = 164
      Top = 275
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
    object ACWord3: TEdit
      Left = 212
      Top = 275
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
    object ACWord4: TEdit
      Left = 260
      Top = 275
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
    object CUIDWord6: TEdit
      Left = 356
      Top = 198
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
    object CUIDWord5: TEdit
      Left = 308
      Top = 198
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
    object ACWord6: TEdit
      Left = 356
      Top = 275
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
      TabOrder = 11
      OnKeyPress = CUIDWord1KeyPress
      OnKeyUp = CUIDWord1KeyUp
    end
    object ACWord5: TEdit
      Left = 308
      Top = 275
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
      OnKeyPress = CUIDWord1KeyPress
      OnKeyUp = CUIDWord1KeyUp
    end
    object ColorDisplayRadio: TTntCheckBox
      Left = 304
      Top = 8
      Width = 116
      Height = 17
      Alignment = taLeftJustify
      BiDiMode = bdRightToLeft
      Caption = #1578#1575#1576#1604#1608#1740' '#1585#1606#1711#1740' 16 '#1585#1583#1740#1601#1607
      ParentBiDiMode = False
      TabOrder = 12
      OnClick = ColorDisplayRadioClick
    end
    object AlarmCheck: TTntCheckBox
      Left = 301
      Top = 124
      Width = 116
      Height = 17
      Alignment = taLeftJustify
      BiDiMode = bdRightToLeft
      Caption = #1583#1575#1585#1575#1740' '#1575#1605#1705#1575#1606#1575#1578' '#1570#1604#1575#1585#1605
      ParentBiDiMode = False
      TabOrder = 13
    end
    object LFGCheck: TTntCheckBox
      Left = 288
      Top = 142
      Width = 130
      Height = 17
      Alignment = taLeftJustify
      BiDiMode = bdRightToLeft
      Caption = 'LED Font Generator LE'
      ParentBiDiMode = False
      TabOrder = 14
    end
    object ModelSelectGroup: TTntGroupBox
      Left = 16
      Top = 24
      Width = 402
      Height = 95
      Caption = #1575#1606#1578#1582#1575#1576' '#1605#1583#1604
      TabOrder = 15
      object Model1Label: TTntLabel
        Left = 288
        Top = 18
        Width = 36
        Height = 13
        Caption = '16x128'
      end
      object Model2Label: TTntLabel
        Left = 288
        Top = 42
        Width = 36
        Height = 13
        Caption = '24x128'
      end
      object Model3Label: TTntLabel
        Left = 288
        Top = 66
        Width = 36
        Height = 13
        Caption = '32x128'
      end
      object Model1Radio: TTntRadioButton
        Left = 328
        Top = 16
        Width = 49
        Height = 17
        Alignment = taLeftJustify
        BiDiMode = bdRightToLeft
        Caption = #1605#1583#1604' 1'
        Checked = True
        ParentBiDiMode = False
        TabOrder = 0
        TabStop = True
      end
      object Model2Radio: TTntRadioButton
        Left = 328
        Top = 40
        Width = 49
        Height = 17
        Alignment = taLeftJustify
        BiDiMode = bdRightToLeft
        Caption = #1605#1583#1604' 2'
        ParentBiDiMode = False
        TabOrder = 1
      end
      object Model3Radio: TTntRadioButton
        Left = 328
        Top = 64
        Width = 49
        Height = 17
        Alignment = taLeftJustify
        BiDiMode = bdRightToLeft
        Caption = #1605#1583#1604' 3'
        ParentBiDiMode = False
        TabOrder = 2
      end
    end
  end
end
