object AlarmSettingsForm: TAlarmSettingsForm
  Left = 398
  Top = 98
  Width = 659
  Height = 633
  BorderIcons = [biSystemMenu]
  Caption = #1586#1605#1575#1606#1576#1606#1583#1740' '#1608' '#1570#1604#1575#1585#1605
  Color = clBtnFace
  Constraints.MaxWidth = 659
  Constraints.MinHeight = 450
  Constraints.MinWidth = 659
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnClose = TntFormClose
  OnCreate = TntFormCreate
  OnDestroy = TntFormDestroy
  OnShow = TntFormShow
  DesignSize = (
    651
    599)
  PixelsPerInch = 96
  TextHeight = 13
  object sLabel57: TsLabel
    Left = 591
    Top = 8
    Width = 51
    Height = 13
    Caption = #1578#1593#1583#1575#1583' '#1570#1604#1575#1585#1605':'
    ParentFont = False
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
  end
  object AlarmMonthLabel: TsLabel
    Left = 510
    Top = 200
    Width = 96
    Height = 13
    Caption = #1578#1606#1592#1740#1605' '#1570#1604#1575#1585#1605' '#1576#1585#1575#1740' '#1605#1575#1607':'
    FocusControl = AlarmMonthCombo
    ParentFont = False
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
  end
  object AlarmMonthImage: TImage
    Left = 611
    Top = 190
    Width = 32
    Height = 32
    AutoSize = True
    Picture.Data = {
      07544269746D6170360C0000424D360C00000000000036000000280000002000
      0000200000000100180000000000000C0000120B0000120B0000000000000000
      0000FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
      FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFB99D7FB99D7FB99D7FB99D7FB99D
      7FB99D7FB99D7FB99D7FB99D7FB99D7FB99D7FB99D7FB99D7FB99D7FB99D7FB9
      9D7FFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
      FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFB99D7FFFFFFFFFFFFFC9B5AAFFFF
      FFFFFFFFC9B5AAE5D7D0E5D7D0C9B5AAE5D7D0E5D7D0C9B5AAF0E4DEF0E4DEB9
      9D7FFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF8484847B7B7BFF00FF
      FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFB99D7FFFFFFFFFFFFFC9B5AAFFFF
      FFFFFFFFC9B5AAE5D7D0E5D7D0C9B5AAE5D7D0E5D7D0C9B5AAF0E4DEF0E4DEB9
      9D7FFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF898989A7A7A77D7D7B
      FF00FFFF00FF0006B60004BA0000BA0000A9B99D7FC9B5AAC9B5AAC9B5AAC9B5
      AAC9B5AAC9B5AAC9B5AAC9B5AA4F71D94F71D94F71D94F71D9C9B5AAC9B5AAB9
      9D7FFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF9C9C93BEBEBCA4A39B
      6A6C810001B30000B5393AB0AD98ADFED6A9B99D7FFFFFFFFFFFFFC9B5AAFFFF
      FFFFFFFFC9B5AAFFFFFFFFFFFF4F71D9B5C5F7B5C5F74F71D9FFFFFFFFFFFFB9
      9D7FFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF424AA8A4A18A6D7394
      000FBE0716BDCDB5B1FFEEB0FFE8B9FFE5BFB99D7FFFFFFFFFFFFFC9B5AAFFFF
      FFFFFFFFC9B5AAFFFFFFFFFFFF4F71D9B5C5F7B5C5F74F71D9FFFFFFFFFFFFB9
      9D7FFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF000FBD0017CC2039CA0007CD
      212FC0FFE1B3FFE5B3FFE0B5FFDEB2FFDDB2B99D7FC9B5AAC9B5AAC9B5AAC9B5
      AAC9B5AAC9B5AAC9B5AAC9B5AA4F71D94F71D94F71D94F71D9C9B5AAC9B5AAB9
      9D7FFF00FFFF00FFFF00FFFF00FFFF00FF0013C5001DD40026E70019D91223C4
      FFE8B4FFE4B3FFDFB4FFDFB4FFDFB4FFDFB3B99D7FFFFFFFFFFFFFC9B5AAFFFF
      FFFFFFFFC9B5AAFFFFFFFFFFFFC9B5AAFFFFFFFFFFFFC9B5AAFFFFFFFFFFFFB9
      9D7FFF00FFFF00FFFF00FFFF00FF0017D8001CD2002EF30029EE0009CCDFC9BB
      FFE7B6FFE1B6FFE2B7FFE2B7FFE2B7FFE2B7B99D7FFFFFFFFFFFFFC9B5AAFFFF
      FFFFFFFFC9B5AAFFFFFFFFFFFFC9B5AAFFFFFFFFFFFFC9B5AAFFFFFFFFFFFFB9
      9D7FFF00FFFF00FFFF00FFFF00FF0017CD0031FB0033FF001EE35C62C7FFF1B8
      FFE3B9FFE4BAFFE4BAFFE4BAFFE4BAFFE4BAB99D7FC9B5AAC9B5AAC9B5AAC9B5
      AAC9B5AAC9B5AAC9B5AAC9B5AAC9B5AAC9B5AAC9B5AAC9B5AAC9B5AAC9B5AAB9
      9D7FFF00FFFF00FFFF00FF001CE50225E0063BFF053AFF000CD6E2CDBAFFEABB
      FFE5BCFFE6BDFFE7BDFFE7BEFFE7BEFFE6BDB99D7FE5D7D0E5D7D0C9B5AAE5D7
      D0E5D7D0C9B5AAFFFFFFFFFFFFC9B5AAFFFFFFFFFFFFC9B5AAFFFFFFFFFFFFB9
      9D7FFF00FFFF00FFFF00FF001BE20C3AF60E41FF0A38FA132ACEFFF1B5FFE8BE
      FFE8BFFFE8C0FFE9C1FFE9C1FFE9C1FFEFC4B99D7FE5D7D0E5D7D0C9B5AAE5D7
      D0E5D7D0C9B5AAFFFFFFFFFFFFC9B5AAFFFFFFFFFFFFC9B5AAFFFFFFFFFFFFB9
      9D7FFF00FFFF00FF001BD5194CFF194CFF174AFF0733F34E5AC3FFECB8FFEBC5
      FFEFCFFFEBC4FFEBC4FFECC4FFF2C8DACAAEEAAA8BE9A787E8A280E18E64E493
      6AE79369E68E61E68859E68451E67F4AE67943E5753CE17137DB6D35D56933CE
      6531FF00FFFF00FF0528DF2253FF2253FF1F50FF0632F06B71BBFFE8B8FFF1D3
      FFF4DEFFF0D0FFEEC7FFEEC9FFFAD1333231EAAA8BFFBF9DE8956AFFDFCEF299
      6CFFA87CFFA273FF9E6BFF9963FD935DF58C59EA8654F4D4C3D5784BCC7246CD
      6531FF00FFFF00FF0B2EE52A5AFF2A5AFF2858FF0834F17074B9F7E4B4FFF5D9
      FFF6DEFFF5D9FFF1CEFFF4CDFFF1CC15171AEAAA8BE8956AFFE0CFFFE6D9F299
      6CFFA87BFFA373FF9D6BFF9864FD925DF58C59EA8653F3CFBCF2D6C9CB7146CD
      6531FF00FFFF00FF0B30E73261FF3261FF3060FF113CF45B67BCEDDBADFFF5D9
      FFF6E3FFF6DCFFF6D8FFFFD8ACA99D232425EAAA8BE9A787E09069F3CFBCE08A
      5FE79369E68E61E68859E68451E67F4AE67943E5753CF1BCA1DB6D35D56933CE
      6531FF00FFFF00FF052BE43C6BFF3C6BFF3866FF224FF9354AC8E2D1A2F9EFD2
      FFFAE7FFF9E0FFFFE2CCC8B9292B2D2123258D8878B2AA923A3A3828292A3E3F
      41ACA9A2FFEAC1FFE5BCFFE4BBFFF3BD2556FF0005B9FF00FFFF00FFFF00FFFF
      00FFFF00FFFF00FF0023E44370FF4370FF416EFF3B69FF001FE0D5C595EBDFBE
      FFFDEDFFFEE8E7E4D45C5C5F343537918E7DFFFFE0FFFED7FDF0CA4645402728
      2A2F3135C6BAA5FFE8BFFFE8BDEFDCC60732EE0009BDFF00FFFF00FFFF00FFFF
      00FFFF00FFFF00FFFF00FF0023F8335EF74A76FF4C79FF002BF28D8DA4DBCEA9
      FBF6E1F7F6E889898B5F606186867EFFFFE7FFF7D4FFF4D0FFF7CFFFF7D05553
      4C353534F6E0B9FFE9BDFFEDBDA1A7DC0019CCFF00FFFF00FFFF00FFFF00FFFF
      00FFFF00FFFF00FFFF00FF0028FE133CED5381FF517EFF325EFB1E3AD2CFC394
      EAE2C1B9BAB989898A8E8C8AFFFFECFFFDE0FFF8D9FFF5D3FFF2CEFFF3CCFFF4
      CBF4E1BBFFEDC4FFE7BDFFF5B72851F4000AB4FF00FFFF00FFFF00FFFF00FFFF
      00FFFF00FFFF00FFFF00FFFF00FF0025E9284AE53155E94775FF0131FB7780AD
      AEA786313134A09F9FFFFFEDFFFFEAFFFBE2FFF9DDFFF6D8FFF4D3FFF1CDFFED
      C7FFEDC4FFE8C0FFEFBBADB0D70014D30006A6FF00FFFF00FFFF00FFFF00FFFF
      00FFFF00FFFF00FFFF00FFFF00FF0015C50120D70017CE0007B1081BC0001AE1
      A4A4A487846BC5C0A8FFFCE9FFFFEEFFFDE9FFFAE2FFF7DDFFF5DAFFF4D7FFEF
      D0FFECC3FFEEBEF1DFC60227E30018CD0000960000A5FF00FFFF00FFFF00FFFF
      00FFFF00FFFF00FFFF00FFFF00FF0829DD1E51FF1C4EFF174CFF0D32E8000CB6
      0007B7908E9DD2CBA2DBD5B3EFE9C8FCF6DDFFFAE1FFF8DFFFF5DCFFF3D6FFF1
      CBFFF4C0F2E1C91033E40016CF000DB10015C400039EFF00FFFF00FFFF00FFFF
      00FFFF00FFFF00FFFF00FF001FED143AE73364FF3060FF2D5CFF2657FF194EFF
      072CE50000AF4448A1B8B49BD7CDA1E4D8B0F1E4BCFCEDC3FFF3C5FFF7C3FFF8
      C2989DD5001DDC0012CB000CB2001ACC003BFF000AADFF00FFFF00FFFF00FFFF
      00FFFF00FFFF00FFFF00FFFF00FF1135E54B79FF4572FF406DFF3766FF2C5AFF
      1B4FFF0A3CFF000BBF0006BC314DD36B76BA8F92B49A9BB7858BC15161CC001D
      DA000ECF0012C70013C10C35EB0238FF0038FF0004A6FF00FFFF00FFFF00FFFF
      00FFFF00FFFF00FFFF00FFFF00FF001FE36085FC7196FF5F87FF4976FF3968FF
      2A59FF1648FF043AFF0012BE0014CC0018ED0C2BCD0017E90017DC000BC50011
      CB0016D31B3DE3305FFF1E4FFF093EFF0023E10007B2FF00FFFF00FFFF00FFFF
      00FFFF00FFFF00FFFF00FFFF00FFFF00FF0D30E6828BA16275B06086F94673FF
      3462FF1F50FF0B3FFF0025E50001B0FF00FF918A680B36E4002BF7153DF14867
      F26B8FFE4F7DFF3968FF2757FF0D3AF60007B5FF00FFFF00FFFF00FFFF00FFFF
      00FFFF00FFFF00FFFF00FFFF00FFFF00FF6F84ECCDC9BEA29F9758668C5884FF
      3F6DFF295AFF0C37F20008BBFF00FF92907FA2A0994F58840026F8A3B5FAD1DF
      FF93B0FF5F89FF406EFF1034E4000FBD3B47C3FF00FFFF00FFFF00FFFF00FFFF
      00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFFFFFFCBCBC7203BC11334E4
      1335E10420D40014D4FF00FFA7A590D3D3D2C4C4C49593872F44A9001EFF072E
      EB2446E91033E10016D43649DBDDE2F8FF00FFFF00FFFF00FFFF00FFFF00FFFF
      00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
      FF00FFFF00FFFF00FFFF00FFA1A19FB4B4B4AEAEAE90908FFF00FFFF00FFFF00
      FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
      00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
      FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
      FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
      00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
      FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
      FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
      00FF}
    Transparent = True
  end
  object ScrollBox1: TScrollBox
    Left = 5
    Top = 224
    Width = 638
    Height = 292
    Anchors = [akLeft, akTop, akBottom]
    BiDiMode = bdLeftToRight
    ParentBiDiMode = False
    TabOrder = 3
    object RefAlarmGroup: TsGroupBox
      Left = 5
      Top = 3
      Width = 609
      Height = 100
      Caption = '1'
      ParentBackground = False
      TabOrder = 0
      Visible = False
      CaptionLayout = clTopRight
      SkinData.SkinSection = 'GROUPBOX'
      CaptionSkin = 'ALPHAEDIT'
      object AlarmDateGroup: TsGroupBox
        Left = 418
        Top = 16
        Width = 185
        Height = 73
        Caption = #1578#1575#1585#1740#1582' '#1570#1604#1575#1585#1605
        ParentBackground = False
        TabOrder = 0
        CaptionLayout = clTopRight
        SkinData.SkinSection = 'GROUPBOX'
        object sLabel4: TsLabel
          Left = 19
          Top = 32
          Width = 13
          Height = 13
          Caption = #1585#1608#1586
          ParentFont = False
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
        end
        object sLabel5: TsLabel
          Left = 76
          Top = 32
          Width = 14
          Height = 13
          Caption = #1605#1575#1607
          ParentFont = False
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
        end
        object sLabel6: TsLabel
          Left = 141
          Top = 32
          Width = 21
          Height = 13
          Caption = #1587#1575#1604
          ParentFont = False
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
        end
        object c1: TsCheckBox
          Left = 72
          Top = 16
          Width = 105
          Height = 19
          Caption = #1607#1585' '#1585#1608#1586' '#1578#1705#1585#1575#1585' '#1588#1608#1583
          Alignment = taLeftJustify
          AutoSize = False
          TabOrder = 0
          SkinData.SkinSection = 'CHECKBOX'
          ImgChecked = 0
          ImgUnchecked = 0
        end
        object y1: TsSpinEdit
          Left = 128
          Top = 48
          Width = 50
          Height = 21
          BiDiMode = bdLeftToRight
          Color = clWhite
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentBiDiMode = False
          ParentFont = False
          PopupMenu = MainForm.GeneralEditPopupMenu
          TabOrder = 1
          Text = '1380'
          SkinData.SkinSection = 'EDIT'
          BoundLabel.Indent = 0
          BoundLabel.Font.Charset = DEFAULT_CHARSET
          BoundLabel.Font.Color = clWindowText
          BoundLabel.Font.Height = -11
          BoundLabel.Font.Name = 'MS Sans Serif'
          BoundLabel.Font.Style = []
          BoundLabel.Layout = sclLeft
          BoundLabel.MaxWidth = 0
          BoundLabel.UseSkinColor = True
          MaxValue = 1499
          MinValue = 1380
          Value = 1380
        end
        object d1: TsSpinEdit
          Left = 7
          Top = 48
          Width = 40
          Height = 21
          BiDiMode = bdLeftToRight
          Color = clWhite
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentBiDiMode = False
          ParentFont = False
          PopupMenu = MainForm.GeneralEditPopupMenu
          TabOrder = 2
          Text = '1'
          SkinData.SkinSection = 'EDIT'
          BoundLabel.Indent = 0
          BoundLabel.Font.Charset = DEFAULT_CHARSET
          BoundLabel.Font.Color = clWindowText
          BoundLabel.Font.Height = -11
          BoundLabel.Font.Name = 'MS Sans Serif'
          BoundLabel.Font.Style = []
          BoundLabel.Layout = sclLeft
          BoundLabel.MaxWidth = 0
          BoundLabel.UseSkinColor = True
          MaxValue = 31
          MinValue = 1
          Value = 1
        end
        object m1: TsComboBox
          Left = 51
          Top = 48
          Width = 73
          Height = 21
          SelStart = 7
          SelLength = 0
          Text = #1601#1585#1608#1585#1583#1740#1606
          Items.Strings = (
            #1601#1585#1608#1585#1583#1740#1606
            #1575#1585#1583#1740#1576#1607#1588#1578
            #1582#1585#1583#1575#1583
            #1578#1740#1585
            #1605#1585#1583#1575#1583
            #1588#1607#1585#1740#1608#1585
            #1605#1607#1585
            #1570#1576#1575#1606
            #1570#1584#1585
            #1583#1740
            #1576#1607#1605#1606
            #1575#1587#1601#1606#1583)
          Alignment = taLeftJustify
          BoundLabel.Indent = 0
          BoundLabel.Font.Charset = DEFAULT_CHARSET
          BoundLabel.Font.Color = clWindowText
          BoundLabel.Font.Height = -11
          BoundLabel.Font.Name = 'MS Sans Serif'
          BoundLabel.Font.Style = []
          BoundLabel.Layout = sclLeft
          BoundLabel.MaxWidth = 0
          BoundLabel.UseSkinColor = True
          SkinData.SkinSection = 'COMBOBOX'
          Style = csDropDownList
          BiDiMode = bdLeftToRight
          Color = clWhite
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ItemHeight = 13
          ItemIndex = 0
          ParentBiDiMode = False
          ParentFont = False
          TabOrder = 3
        end
      end
      object AlarmTimeGroup: TsGroupBox
        Left = 258
        Top = 16
        Width = 154
        Height = 73
        Caption = #1587#1575#1593#1578' '#1570#1604#1575#1585#1605
        ParentBackground = False
        TabOrder = 1
        CaptionLayout = clTopRight
        SkinData.SkinSection = 'GROUPBOX'
        DesignSize = (
          154
          73)
        object sLabel1: TsLabel
          Left = 11
          Top = 31
          Width = 31
          Height = 13
          Anchors = [akLeft, akBottom]
          Caption = #1587#1575#1593#1578
          ParentFont = False
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
        end
        object sLabel2: TsLabel
          Left = 62
          Top = 31
          Width = 26
          Height = 13
          Anchors = [akLeft, akBottom]
          Caption = #1583#1602#1740#1602#1607
          ParentFont = False
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
        end
        object sLabel3: TsLabel
          Left = 116
          Top = 31
          Width = 19
          Height = 13
          Anchors = [akLeft, akBottom]
          Caption = #1579#1575#1606#1740#1607
          ParentFont = False
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
        end
        object ClockDotsLabel2: TsLabel
          Left = 50
          Top = 50
          Width = 4
          Height = 13
          Caption = ':'
          ParentFont = False
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
        end
        object ClockDotsLabel1: TsLabel
          Left = 100
          Top = 50
          Width = 4
          Height = 13
          Caption = ':'
          ParentFont = False
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
        end
        object s1: TsSpinEdit
          Left = 107
          Top = 47
          Width = 40
          Height = 21
          Anchors = [akLeft, akBottom]
          BiDiMode = bdLeftToRight
          Color = clWhite
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentBiDiMode = False
          ParentFont = False
          PopupMenu = MainForm.GeneralEditPopupMenu
          TabOrder = 0
          Text = '0'
          SkinData.SkinSection = 'EDIT'
          BoundLabel.Indent = 0
          BoundLabel.Font.Charset = DEFAULT_CHARSET
          BoundLabel.Font.Color = clWindowText
          BoundLabel.Font.Height = -11
          BoundLabel.Font.Name = 'MS Sans Serif'
          BoundLabel.Font.Style = []
          BoundLabel.Layout = sclLeft
          BoundLabel.MaxWidth = 0
          BoundLabel.UseSkinColor = True
          MaxValue = 59
          MinValue = 0
          Value = 0
        end
        object min1: TsSpinEdit
          Left = 57
          Top = 47
          Width = 40
          Height = 21
          Anchors = [akLeft, akBottom]
          BiDiMode = bdLeftToRight
          Color = clWhite
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentBiDiMode = False
          ParentFont = False
          PopupMenu = MainForm.GeneralEditPopupMenu
          TabOrder = 1
          Text = '0'
          SkinData.SkinSection = 'EDIT'
          BoundLabel.Indent = 0
          BoundLabel.Font.Charset = DEFAULT_CHARSET
          BoundLabel.Font.Color = clWindowText
          BoundLabel.Font.Height = -11
          BoundLabel.Font.Name = 'MS Sans Serif'
          BoundLabel.Font.Style = []
          BoundLabel.Layout = sclLeft
          BoundLabel.MaxWidth = 0
          BoundLabel.UseSkinColor = True
          MaxValue = 59
          MinValue = 0
          Value = 0
        end
        object h1: TsSpinEdit
          Left = 7
          Top = 47
          Width = 40
          Height = 21
          Anchors = [akLeft, akBottom]
          BiDiMode = bdLeftToRight
          Color = clWhite
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentBiDiMode = False
          ParentFont = False
          PopupMenu = MainForm.GeneralEditPopupMenu
          TabOrder = 2
          Text = '0'
          SkinData.SkinSection = 'EDIT'
          BoundLabel.Indent = 0
          BoundLabel.Font.Charset = DEFAULT_CHARSET
          BoundLabel.Font.Color = clWindowText
          BoundLabel.Font.Height = -11
          BoundLabel.Font.Name = 'MS Sans Serif'
          BoundLabel.Font.Style = []
          BoundLabel.Layout = sclLeft
          BoundLabel.MaxWidth = 0
          BoundLabel.UseSkinColor = True
          MaxValue = 23
          MinValue = 0
          Value = 0
        end
      end
      object AlarmDurationGroup: TsGroupBox
        Left = 7
        Top = 16
        Width = 245
        Height = 73
        Caption = #1605#1583#1578' '#1601#1593#1575#1604' '#1576#1608#1583#1606' '#1570#1604#1575#1585#1605
        ParentBackground = False
        TabOrder = 2
        CaptionLayout = clTopRight
        SkinData.SkinSection = 'GROUPBOX'
        DesignSize = (
          245
          73)
        object sLabel7: TsLabel
          Left = 28
          Top = 45
          Width = 69
          Height = 13
          Caption = #1579#1575#1606#1740#1607' '#1601#1593#1575#1604' '#1576#1575#1588#1583
          ParentFont = False
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
        end
        object sLabel15: TsLabel
          Left = 21
          Top = 22
          Width = 76
          Height = 13
          Caption = #1583#1602#1740#1602#1607' '#1601#1593#1575#1604' '#1576#1575#1588#1583
          ParentFont = False
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
        end
        object sLabel17: TsLabel
          Left = -21
          Top = 77
          Width = 47
          Height = 13
          Caption = #1601#1593#1575#1604' '#1576#1575#1588#1583
          ParentFont = False
          Visible = False
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
        end
        object sLabel18: TsLabel
          Left = 107
          Top = 76
          Width = 4
          Height = 13
          Caption = ':'
          ParentFont = False
          Visible = False
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
        end
        object sLabel19: TsLabel
          Left = 66
          Top = 76
          Width = 4
          Height = 13
          Caption = ':'
          ParentFont = False
          Visible = False
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
        end
        object r1: TsRadioButton
          Left = 157
          Top = 21
          Width = 86
          Height = 19
          Alignment = taLeftJustify
          Anchors = [akTop, akRight]
          Caption = #1570#1604#1575#1585#1605' '#1576#1607' '#1605#1583#1578
          Checked = True
          TabOrder = 7
          TabStop = True
          AutoSize = False
          SkinData.SkinSection = 'RADIOBUTTON'
        end
        object t1: TsSpinEdit
          Left = 102
          Top = 43
          Width = 52
          Height = 21
          BiDiMode = bdLeftToRight
          Color = clWhite
          Enabled = False
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentBiDiMode = False
          ParentFont = False
          PopupMenu = MainForm.GeneralEditPopupMenu
          TabOrder = 0
          Text = '0'
          SkinData.SkinSection = 'EDIT'
          BoundLabel.Indent = 0
          BoundLabel.Font.Charset = DEFAULT_CHARSET
          BoundLabel.Font.Color = clWindowText
          BoundLabel.Font.Height = -11
          BoundLabel.Font.Name = 'MS Sans Serif'
          BoundLabel.Font.Style = []
          BoundLabel.Layout = sclLeft
          BoundLabel.MaxWidth = 0
          BoundLabel.UseSkinColor = True
          MaxValue = 65040
          MinValue = 0
          Value = 0
        end
        object t2: TsSpinEdit
          Left = 102
          Top = 19
          Width = 52
          Height = 21
          BiDiMode = bdLeftToRight
          Color = clWhite
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentBiDiMode = False
          ParentFont = False
          PopupMenu = MainForm.GeneralEditPopupMenu
          TabOrder = 1
          Text = '0'
          SkinData.SkinSection = 'EDIT'
          BoundLabel.Indent = 0
          BoundLabel.Font.Charset = DEFAULT_CHARSET
          BoundLabel.Font.Color = clWindowText
          BoundLabel.Font.Height = -11
          BoundLabel.Font.Name = 'MS Sans Serif'
          BoundLabel.Font.Style = []
          BoundLabel.Layout = sclLeft
          BoundLabel.MaxWidth = 0
          BoundLabel.UseSkinColor = True
          MaxValue = 1084
          MinValue = 0
          Value = 0
        end
        object t5: TsSpinEdit
          Left = 111
          Top = 73
          Width = 35
          Height = 21
          TabStop = False
          BiDiMode = bdLeftToRight
          Color = clWhite
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentBiDiMode = False
          ParentFont = False
          PopupMenu = MainForm.GeneralEditPopupMenu
          TabOrder = 2
          Text = '0'
          Visible = False
          SkinData.SkinSection = 'EDIT'
          BoundLabel.Indent = 0
          BoundLabel.Font.Charset = DEFAULT_CHARSET
          BoundLabel.Font.Color = clWindowText
          BoundLabel.Font.Height = -11
          BoundLabel.Font.Name = 'MS Sans Serif'
          BoundLabel.Font.Style = []
          BoundLabel.Layout = sclLeft
          BoundLabel.MaxWidth = 0
          BoundLabel.UseSkinColor = True
          MaxValue = 59
          MinValue = 0
          Value = 0
        end
        object t4: TsSpinEdit
          Left = 70
          Top = 73
          Width = 35
          Height = 21
          TabStop = False
          BiDiMode = bdLeftToRight
          Color = clWhite
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentBiDiMode = False
          ParentFont = False
          PopupMenu = MainForm.GeneralEditPopupMenu
          TabOrder = 3
          Text = '0'
          Visible = False
          SkinData.SkinSection = 'EDIT'
          BoundLabel.Indent = 0
          BoundLabel.Font.Charset = DEFAULT_CHARSET
          BoundLabel.Font.Color = clWindowText
          BoundLabel.Font.Height = -11
          BoundLabel.Font.Name = 'MS Sans Serif'
          BoundLabel.Font.Style = []
          BoundLabel.Layout = sclLeft
          BoundLabel.MaxWidth = 0
          BoundLabel.UseSkinColor = True
          MaxValue = 59
          MinValue = 0
          Value = 0
        end
        object t3: TsSpinEdit
          Left = 30
          Top = 73
          Width = 35
          Height = 21
          TabStop = False
          BiDiMode = bdLeftToRight
          Color = clWhite
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentBiDiMode = False
          ParentFont = False
          PopupMenu = MainForm.GeneralEditPopupMenu
          TabOrder = 4
          Text = '0'
          Visible = False
          SkinData.SkinSection = 'EDIT'
          BoundLabel.Indent = 0
          BoundLabel.Font.Charset = DEFAULT_CHARSET
          BoundLabel.Font.Color = clWindowText
          BoundLabel.Font.Height = -11
          BoundLabel.Font.Name = 'MS Sans Serif'
          BoundLabel.Font.Style = []
          BoundLabel.Layout = sclLeft
          BoundLabel.MaxWidth = 0
          BoundLabel.UseSkinColor = True
          MaxValue = 23
          MinValue = 0
          Value = 0
        end
        object r2: TsRadioButton
          Left = 157
          Top = 45
          Width = 86
          Height = 19
          Alignment = taLeftJustify
          Anchors = [akTop, akRight]
          Caption = #1570#1604#1575#1585#1605' '#1576#1607' '#1605#1583#1578
          TabOrder = 5
          AutoSize = False
          SkinData.SkinSection = 'RADIOBUTTON'
        end
        object r3: TsRadioButton
          Left = 150
          Top = 75
          Width = 93
          Height = 19
          Alignment = taLeftJustify
          Anchors = [akTop, akRight]
          Caption = #1570#1604#1575#1585#1605' '#1578#1575' '#1587#1575#1593#1578
          TabOrder = 6
          Visible = False
          AutoSize = False
          SkinData.SkinSection = 'RADIOBUTTON'
        end
      end
    end
  end
  object SetAlarmsBtn: TsBitBtn
    Left = 265
    Top = 527
    Width = 117
    Height = 63
    Cursor = crHandPoint
    Anchors = [akLeft, akBottom]
    Caption = #1578#1606#1592#1610#1605' '#1570#1604#1575#1585#1605' '#1578#1575#1576#1604#1608
    TabOrder = 6
    OnClick = SetAlarmsBtnClick
    Glyph.Data = {
      F6060000424DF606000000000000360000002800000018000000180000000100
      180000000000C006000000000000000000000000000000000000FF00FFFF00FF
      FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
      FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
      00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
      FF00FF4848484B4B4B4B4B4B4848484646464545455252525050503C3C3C3535
      35FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF9191918D8D8D89
      8987FF00FFFF00FFBCBCED5F5F64F7F7FAFBFBFEFCFCFEEBCDBEF4F4F4FDFDFD
      FCFCFCF7F7F7393939FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
      FFA09F91BCBBB69694820713B20000B5B6B2D9696868FCFAFAFBFAFCEFE4E3AC
      460EC09F93FBFBFBFBFBFBFCFCFC3D3D3DFF00FFFF00FFFF00FFFF00FFFF00FF
      FF00FFFF00FFFF00FF0212BB868997182AB5242DBEFAD8B2FFF7DC706F6DFFFD
      FBFFFEFBC98053A33D00AF5119D4D0D7F9F9FCFCFCFC3F3F3FFF00FFFF00FFFF
      00FFFF00FFFF00FFFF00FFFF00FF0014CF001ED90012DE2D39C4FFEDB2FFE4B3
      FFF0DB716F6DFDFBF7E9C0A7A84101A53F00AA4200B87A57E6E6F2F9F9FB4343
      43FF00FFFF00FFFF00FFFF00FFFF00FFFF00FF0016E00023E0002BF40017CEFF
      E5B6FFE4B6FFE2B7FFF1DD747371F9E9DFB15214AA4501D6A17FAF4503B34802
      BFA8A1EAEAF6464646FF00FFFF00FFFF00FFFF00FFFF00FFFF00FF001DD40136
      FF0022F08D89C1FFEDB9FFE4BBFFE5BBFFF3DF777471C1733DAC4600D38E5BFF
      FCF7D99B6EAF4800BB5B19C7C6D158585BFF00FFFF00FFFF00FFFF00FFFF00FF
      FF00FF072FEC0B40FF0016E3F8DFB5FFEABDFFE8BFFFE8C0FFF5E4995C32AD47
      00BB6423FBF0E7FFFBF5FDF4EABF6927B54D00B97345525257FF00FFFF00FFFF
      00FFFF00FFFF00FF001DE81644FA1749FF132ED5FFEFB4FFEFCDFFECC7FFECC4
      FFF9E7B25C1DB14D04846A5A777674767572767472876C56B65102BB5100875A
      43FF00FFFF00FFFF00FFFF00FFFF00FF0020EC2657FF2252FF2A3FCCFFE9B3FF
      F6DEFFF4DAFFEFCAFFFEE6BE8254E5C3AAB1B2B3DFDAD1FFF8E3FFF3DFFFF3E1
      E7B68ABA5300C25906672C00FF00FFFF00FFFF00FFFF00FF0021F03261FF2C5D
      FF203BD0F3DFABFFF9E4FFF7DDFFF8D7FFF8D99E928BB3B4B638393B535457EA
      DBBFFFECC1FFE3B9FFF7E1C7834EBE5800C05700FF00FFFF00FFFF00FFFF00FF
      0022F43865FE3C69FF052CE5E2D09DFFF6E0FFFBE5FFFFE56464643B3B3EB8B1
      97A29A851A1C2044464CD7CBB4FFE9BDFFEFBDC4CFF7C1671CC15B00D56400FF
      00FFFF00FFFF00FF0023FA305BF64977FF103CF7A19CA0F2E7C7FFFFF1A4A4A2
      434347C9C5ACFFFFDCFFFFD9C5BA9E17181E847E6FFFEDC1FFF6BB5C76EDDEC9
      C8C65E02D46600FF00FFFF00FFFF00FFFF00FF153FF15582FF4270FF324BC8DE
      D2A2D4D4C87E7F81BEBEB1FFFFE8FFF8D7FFF6D0FFF9D1DACCADFFF0C6FFECBD
      D1C9D00013D1EEEEFBF0AD70D26900FF00FFFF00FFFF00FFFF00FF001EE81832
      D12643DB0833F49194AC525142ADADA6FFFFF8FFFDE7FFF8DFFFF5D7FFF3D1FF
      F0C8FFECC1FFF8BB2D4DE40001A5FF00FFFF00FFEE7702FF00FFFF00FFFF00FF
      FF00FF0322D71242FE0C34EC0017C8000BBF96959BDED6ABF2EED1FFFCE6FFFB
      E5FFF9E1FFF5DAFFF4CAFFFCBE6377DE000FD1000AAF0001ABFF00FFFF00FFFF
      00FFFF00FFFF00FFFF00FF1138E53364FF2F60FF2558FF113EF80008C152539E
      C5BE9FE7DCABF9ECBBFFF4C1FFFBC0E1D6C9384FDA0009C8000DB70032FE000C
      BFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF0A31E35B87FF4E7BFF3D6BFF2C
      5BFF1448FF0017D7000AC52141D83E54CF4155CD122BD00006CE000BC8102FD9
      1042FF0037FF0006B3FF00FFFF00FFFF00FFFF00FFFF00FFFF00FF0023FF4867
      E36E83C55A83FE3C6AFF2254FF083FFF000DBE001AE0696B7E001FFC001EDB30
      52EB4A74FB3A6AFF1D51FF0018D2FF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
      FF00FFFF00FFADB7E4C1BCAC5D6C98507EFF2F5FFF072CE30000B8ADAA8FA09C
      8C092CCF718BFBB8CBFF759AFF315CF8011DD33944C5FF00FFFF00FFFF00FFFF
      00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF1030E3001DEC0018DF000BDA
      FF00FFCACAC5BEBEBD8C886EFF00FF001EF8001CEF000FE5A2AAE7FF00FFFF00
      FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
      00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
      FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
      FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
      00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF}
    Layout = blGlyphTop
    SkinData.SkinSection = 'BUTTON'
  end
  object CancelBtn: TsBitBtn
    Left = 526
    Top = 527
    Width = 117
    Height = 63
    Cursor = crHandPoint
    Anchors = [akLeft, akBottom]
    Cancel = True
    Caption = #1576#1587#1578#1606
    ModalResult = 2
    TabOrder = 8
    OnClick = CancelBtnClick
    Glyph.Data = {
      36030000424D3603000000000000360000002800000010000000100000000100
      18000000000000030000120B0000120B00000000000000000000FF00FFFF00FF
      FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
      FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
      00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
      FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
      FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
      00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF00501100743C
      00733F016F30076C30005E20005515005011003E01FF00FFFF00FFFF00FFFF00
      FFFF00FFFF00FFFF00FF00863712B97015B77229BE7E38C58823B97802AE6500
      9955009955FF00FFFF00FFFF00FFFF00FF1B68431B6843FF00FF1489423FCE8E
      3FC98C3BC88932C2822BC27F059D5E003C06003C06FF00FFFF00FFFF00FF1B6B
      421B68431B6843FF00FF0E78346DE4AE6BDDAA69DDA863D9A45AD8A00D843FFF
      00FFFF00FFFF00FFFF00FF1A7A4C1B6B421B6C491B6843FF00FF0063068DF0C1
      90F2C48EF0C286ECBD7BE7B669E0AA37B581066C4945B6891A7A4C1A7A4C1B70
      461B7046FF00FFFF00FF005C009BF0CAC8FFEBC2FFE6B0FED9A2F7D18DF0C27B
      EAB676E0AF45B6891A9A671A7A491A7A49FF00FFFF00FFFF00FF00590097EAC5
      A2F0CD4EA55DEBFFFFD2FFF0BBFFE0A2F6CE80E8B75EDCA322A46F1B6840FF00
      FFFF00FFFF00FFFF00FF0057001F954700640055B67455B6746FB776E4FFFBD1
      FFEFA4F7D128A8741A7949FF00FFFF00FFFF00FFFF00FFFF00FF005900009D58
      FF00FFFF00FFFF00FF0098521E852E248A360A771C007E42FF00FFFF00FFFF00
      FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
      00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
      FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
      FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
      00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF}
    Layout = blGlyphTop
    SkinData.SkinSection = 'BUTTON'
  end
  object NumOfAlarmsSpin: TsSpinEdit
    Left = 536
    Top = 6
    Width = 50
    Height = 21
    BiDiMode = bdLeftToRight
    Color = clWhite
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentBiDiMode = False
    ParentFont = False
    PopupMenu = MainForm.GeneralEditPopupMenu
    TabOrder = 0
    Text = '1'
    OnChange = NumOfAlarmsSpinChange
    SkinData.SkinSection = 'EDIT'
    BoundLabel.Indent = 0
    BoundLabel.Font.Charset = DEFAULT_CHARSET
    BoundLabel.Font.Color = clWindowText
    BoundLabel.Font.Height = -11
    BoundLabel.Font.Name = 'MS Sans Serif'
    BoundLabel.Font.Style = []
    BoundLabel.Layout = sclLeft
    BoundLabel.MaxWidth = 0
    BoundLabel.UseSkinColor = True
    MaxValue = 31
    MinValue = 1
    Value = 1
  end
  object QuickSetGroupBox: TsGroupBox
    Left = 5
    Top = 32
    Width = 638
    Height = 158
    Caption = #1578#1606#1592#1740#1605' '#1587#1585#1740#1593
    ParentBackground = False
    TabOrder = 1
    CaptionLayout = clTopRight
    SkinData.SkinSection = 'GROUPBOX'
    DesignSize = (
      638
      158)
    object QuickSetForOneMonthGroup: TsGroupBox
      Left = 8
      Top = 17
      Width = 623
      Height = 54
      Anchors = [akLeft, akTop, akRight]
      Caption = #1578#1606#1592#1740#1605' '#1587#1585#1740#1593' '#1576#1585#1575#1740' '#1585#1608#1586#1607#1575#1740' '#1605#1578#1608#1575#1604#1740' '#1740#1705' '#1605#1575#1607
      ParentBackground = False
      TabOrder = 0
      CaptionLayout = clTopRight
      SkinData.SkinSection = 'GROUPBOX'
      DesignSize = (
        623
        54)
      object sLabel58: TsLabel
        Left = 300
        Top = 26
        Width = 67
        Height = 13
        Anchors = [akTop, akRight]
        Caption = #1576#1575' '#1588#1585#1608#1593' '#1575#1586' '#1585#1608#1586':'
        ParentFont = False
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
      end
      object SolarMonthLabel: TsLabel
        Left = 454
        Top = 26
        Width = 18
        Height = 13
        Anchors = [akTop, akRight]
        Caption = #1605#1575#1607':'
        FocusControl = SolarMonthCombo
        ParentFont = False
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
      end
      object sLabel9: TsLabel
        Left = 223
        Top = 26
        Width = 26
        Height = 13
        Anchors = [akTop, akRight]
        Caption = #1578#1575' '#1585#1608#1586':'
        ParentFont = False
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
      end
      object sLabel14: TsLabel
        Left = 537
        Top = 26
        Width = 79
        Height = 13
        Anchors = [akTop, akRight]
        Caption = #1578#1606#1592#1740#1605' '#1576#1585#1575#1740' '#1587#1575#1604':'
        ParentFont = False
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
      end
      object FromDaySpin: TsSpinEdit
        Left = 255
        Top = 22
        Width = 40
        Height = 21
        Anchors = [akTop, akRight]
        BiDiMode = bdLeftToRight
        Color = clWhite
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentBiDiMode = False
        ParentFont = False
        PopupMenu = MainForm.GeneralEditPopupMenu
        TabOrder = 2
        Text = '1'
        SkinData.SkinSection = 'EDIT'
        BoundLabel.Indent = 0
        BoundLabel.Font.Charset = DEFAULT_CHARSET
        BoundLabel.Font.Color = clWindowText
        BoundLabel.Font.Height = -11
        BoundLabel.Font.Name = 'MS Sans Serif'
        BoundLabel.Font.Style = []
        BoundLabel.Layout = sclLeft
        BoundLabel.MaxWidth = 0
        BoundLabel.UseSkinColor = True
        MaxValue = 31
        MinValue = 1
        Value = 1
      end
      object SolarMonthCombo: TsComboBox
        Left = 373
        Top = 22
        Width = 73
        Height = 21
        SelStart = 7
        SelLength = 0
        Text = #1601#1585#1608#1585#1583#1740#1606
        Items.Strings = (
          #1601#1585#1608#1585#1583#1740#1606
          #1575#1585#1583#1740#1576#1607#1588#1578
          #1582#1585#1583#1575#1583
          #1578#1740#1585
          #1605#1585#1583#1575#1583
          #1588#1607#1585#1740#1608#1585
          #1605#1607#1585
          #1570#1576#1575#1606
          #1570#1584#1585
          #1583#1740
          #1576#1607#1605#1606
          #1575#1587#1601#1606#1583)
        Alignment = taLeftJustify
        BoundLabel.Indent = 0
        BoundLabel.Font.Charset = DEFAULT_CHARSET
        BoundLabel.Font.Color = clWindowText
        BoundLabel.Font.Height = -11
        BoundLabel.Font.Name = 'MS Sans Serif'
        BoundLabel.Font.Style = []
        BoundLabel.Layout = sclLeft
        BoundLabel.MaxWidth = 0
        BoundLabel.UseSkinColor = True
        SkinData.SkinSection = 'COMBOBOX'
        Style = csDropDownList
        Anchors = [akTop, akRight]
        BiDiMode = bdLeftToRight
        Color = clWhite
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ItemHeight = 13
        ItemIndex = 0
        ParentBiDiMode = False
        ParentFont = False
        TabOrder = 1
      end
      object SpeedSetAlarmsForMonthBtn: TsBitBtn
        Left = 8
        Top = 18
        Width = 75
        Height = 26
        Cursor = crHandPoint
        Caption = #1578#1606#1592#1740#1605
        TabOrder = 4
        OnClick = SpeedSetAlarmsForMonthBtnClick
        Glyph.Data = {
          36030000424D3603000000000000360000002800000010000000100000000100
          18000000000000030000120B0000120B00000000000000000000FF00FFFF00FF
          FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
          FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFC3
          6E66B75439B7502FC46445D89181FF00FFFF00FFFF00FFFF00FFE49A4AFF00FF
          FF00FFFF00FFFF00FFCF6900D77100D87200D46F00CA6400AF49009F3305FF00
          FFFF00FFFF00FFFF00FFE49A4AFFB243FFB243DD7907F49000FB9500F18B00EE
          8800DE7700C76200BA5200A43B00FF00FFFF00FFFF00FFFF00FFEA994FE88A18
          E68818FFA218FF9E08FC9700F99300DA7100C26111B93929FF00FFFF00FFFF00
          FFFF00FFFF00FFFF00FFEC994BF7A63CFFB243FFA82DFFA21AFF9E08DF7600D1
          8442FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFEF9A49F9AD4E
          FFB757FFAD40FEA92DE88814D83E57FF00FFFF00FFFF00FFFF00FFFA46B7FB3E
          A1F93695F83695FC3B95F19C46FAB45FFFBD6BFFB857F7A435D86A1EFF00FFFF
          00FFFF00FFE87597E68F2DF19E39F69F36F7A33EF8AE56F89D24F59F47FDC381
          FFC787FDB964F8A842DC700AFF00FFFF00FFFF00FFFF00FFE14453EE982CFDB7
          5DFFC076FFCA92F5A139F8A42EF7A135F49F36F79C2FF49F38EC9C3CEAA75AFF
          00FFFF00FFFF00FFE23F70EC9022FFB34EFFB95FFEBE71F19829FF00FFFF00FF
          FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFE42A92DE7D0CFDA424FFAC
          38FFB24CFFB95FED9121FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
          00FFD17C5AD77204FB9703FFA013FFA526FFAB38FEAF48EA8D1BFF00FFFF00FF
          FF00FFFF00FFFF00FFFF00FFD0247AC44A31D36C00F28C00FA9400FE9A02FFA4
          13EA8A13E18115E3810FFF00FFFF00FFFF00FFFF00FFAD482EBA5E1CC86303D8
          7100E98300EC8800F58E00F69000DF7902E23C70FF00FFD77203FF00FFFF00FF
          FF00FFFF00FFCB3077A83F0FBB5503CD6801D36E01D46F02CC6804C76315DF56
          73FF00FFFF00FFEA3681FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFC36E66B7
          5439B7502FC46445D89181FF00FFFF00FFFF00FFFF00FFFF00FF}
        Layout = blGlyphRight
        SkinData.SkinSection = 'BUTTON'
      end
      object ToDaySpin: TsSpinEdit
        Left = 176
        Top = 22
        Width = 40
        Height = 21
        Anchors = [akTop, akRight]
        BiDiMode = bdLeftToRight
        Color = clWhite
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentBiDiMode = False
        ParentFont = False
        PopupMenu = MainForm.GeneralEditPopupMenu
        TabOrder = 3
        Text = '31'
        SkinData.SkinSection = 'EDIT'
        BoundLabel.Indent = 0
        BoundLabel.Font.Charset = DEFAULT_CHARSET
        BoundLabel.Font.Color = clWindowText
        BoundLabel.Font.Height = -11
        BoundLabel.Font.Name = 'MS Sans Serif'
        BoundLabel.Font.Style = []
        BoundLabel.Layout = sclLeft
        BoundLabel.MaxWidth = 0
        BoundLabel.UseSkinColor = True
        MaxValue = 31
        MinValue = 1
        Value = 31
      end
      object SolarYearSpin: TsSpinEdit
        Left = 479
        Top = 22
        Width = 50
        Height = 21
        BiDiMode = bdLeftToRight
        Color = clWhite
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentBiDiMode = False
        ParentFont = False
        PopupMenu = MainForm.GeneralEditPopupMenu
        TabOrder = 0
        Text = '1380'
        SkinData.SkinSection = 'EDIT'
        BoundLabel.Indent = 0
        BoundLabel.Font.Charset = DEFAULT_CHARSET
        BoundLabel.Font.Color = clWindowText
        BoundLabel.Font.Height = -11
        BoundLabel.Font.Name = 'MS Sans Serif'
        BoundLabel.Font.Style = []
        BoundLabel.Layout = sclLeft
        BoundLabel.MaxWidth = 0
        BoundLabel.UseSkinColor = True
        MaxValue = 1499
        MinValue = 1380
        Value = 1380
      end
    end
    object ReadAlarmsFromFileGroup: TsGroupBox
      Left = 8
      Top = 76
      Width = 193
      Height = 71
      Caption = #1582#1608#1575#1606#1583#1606' '#1578#1606#1592#1740#1605#1575#1578' '#1570#1604#1575#1585#1605' '#1575#1586' '#1601#1575#1740#1604
      ParentBackground = False
      TabOrder = 3
      CaptionLayout = clTopRight
      SkinData.SkinSection = 'GROUPBOX'
      object SelectAlarmFileBtn: TsBitBtn
        Left = 26
        Top = 19
        Width = 141
        Height = 45
        Cursor = crHandPoint
        Caption = #1575#1606#1578#1582#1575#1576' '#1601#1575#1740#1604'...'
        TabOrder = 0
        OnClick = SelectAlarmFileBtnClick
        Glyph.Data = {
          F6060000424DF606000000000000360000002800000018000000180000000100
          180000000000C0060000120B0000120B00000000000000000000FF00FFFF00FF
          FF00FFFF00FFFF00FFFF00FFFF00FFFF00FF75848F66808F607987576E7B4E62
          6F4456613948522E3A43252E351B222914191E0E12160E1318FF00FFFF00FFFF
          00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF77879289A1AB
          6AB2D4008FCD008FCD008FCD048CC70888BE0F82B4157CA91B779F1F7296224B
          5C87A2ABFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF9191918D8D8D89
          89877A8A957EBED38AA4AE7EDCFF5FCFFF55CBFF4CC4FA41BCF537B3F02EAAEB
          24A0E5138CD42367805E696DFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
          FFA09F91BCBBB69694827D8E9879D2EC8BA4AD89C2CE71D8FF65D3FF5CCEFF51
          C9FE49C1FA3FB9F534B0EE29A8E91085CD224B5B98B2BAFF00FFFF00FFFF00FF
          FF00FFFF00FFFF00FF0212BB868997182AB580919C81D7EF7DC5E08CA6B080DD
          FE68D3FF67D4FF62D1FF58CDFF4EC7FC46BEF73BB6F231ACEC2569817A95A1FF
          00FFFF00FFFF00FFFF00FFFF00FF0014CF001ED90012DE2D39C483959F89DCF1
          8CE2FF8DA8B18CBAC774D8FF67D4FF67D4FF67D4FF5FD0FF54CDFF4BC5FC41BB
          F72EA2DB51677498B2BAFF00FFFF00FFFF00FF0016E00023E0002BF40017CEFF
          E5B6869AA392E1F298E8FD80C4DE8EA7B081DEFD84E0FF84E0FF84E0FF84E0FF
          81DFFF7BDDFF74D8FF6BD6FF56A9D18F9BA4FF00FFFF00FFFF00FF001DD40136
          FF0022F08D89C1FFEDB9889CA59AE6F39FEBFB98E8FE8BACB98BACB98AAAB788
          A6B386A3AF839FAA819AA67F95A17C919D7A8E99798B95778893FF00FFFF00FF
          FF00FF072FEC0B40FF0016E3F8DFB5FFEABD8BA0A8A0EAF6A6EEF99FEBFB98E8
          FE7ADAFF67D4FF67D4FF67D4FF67D4FF67D4FF67D4FF778893FF00FFFF00FFFF
          00FFFF00FFFF00FF001DE81644FA1749FF132ED5FFEFB4FFEFCD8EA2ABA7EEF6
          ABF0F7A6EEF99FEBFB98E8FD71D4FB899EA78699A382949F7E909A7A8C977788
          93FF00FFFF00FFFF00FFFF00FFFF00FF0020EC2657FF2252FF2A3FCCFFE9B3FF
          F6DE8FA4ACA0D2DAABF0F7ABF0F7A6EEF99FEBFB8DA1AAB5CBD0FFE6BCFFE2B7
          FFEDC08FA2EB0312C5FF00FFFF00FFFF00FFFF00FFFF00FF0021F03261FF2C5D
          FF203BD0F3DFABFFF9E4BDCED48FA4AC8FA4AC8FA4AC8FA4AC8FA4ACB5CBD0EA
          DBBFFFECC1FFE3B9FFEDBE90A0E9000EC8FF00FFFF00FFFF00FFFF00FFFF00FF
          0022F43865FE3C69FF052CE5E2D09DFFF6E0FFFBE5FFFFE5646464202023B8B1
          97A29A851A1C2044464CD7CBB4FFE9BDFFEFBD7089EC0004BEFF00FFFF00FFFF
          00FFFF00FFFF00FF0023FA305BF64977FF103CF7A19CA0F2E7C7FFFFF1A4A4A2
          434347C9C5ACFFFFDCFFFFD9C5BA9E17181E847E6FFFEDC1FFF6BB2145E60009
          C1FF00FFFF00FFFF00FFFF00FFFF00FFFF00FF153FF15582FF4270FF324BC8DE
          D2A2D4D4C87E7F81BEBEB1FFFFE8FFF8D7FFF6D0FFF9D1DACCADFFF0C6FFECBD
          D1C9D00013D1FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF001EE81832
          D12643DB0833F49194AC525142ADADA6FFFFF8FFFDE7FFF8DFFFF5D7FFF3D1FF
          F0C8FFECC1FFF8BB2D4DE40001A5FF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
          FF00FF0322D71242FE0C34EC0017C8000BBF96959BDED6ABF2EED1FFFCE6FFFB
          E5FFF9E1FFF5DAFFF4CAFFFCBE6377DE000FD1000AAF0001ABFF00FFFF00FFFF
          00FFFF00FFFF00FFFF00FF1138E53364FF2F60FF2558FF113EF80008C152539E
          C5BE9FE7DCABF9ECBBFFF4C1FFFBC0E1D6C9384FDA0009C8000DB70032FE000C
          BFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF0A31E35B87FF4E7BFF3D6BFF2C
          5BFF1448FF0017D7000AC52141D83E54CF4155CD122BD00006CE000BC8102FD9
          1042FF0037FF0006B3FF00FFFF00FFFF00FFFF00FFFF00FFFF00FF0023FF4867
          E36E83C55A83FE3C6AFF2254FF083FFF000DBE001AE0696B7E001FFC001EDB30
          52EB4A74FB3A6AFF1D51FF0018D2FF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
          FF00FFFF00FFADB7E4C1BCAC5D6C98507EFF2F5FFF072CE30000B8ADAA8FA09C
          8C092CCF718BFBB8CBFF759AFF315CF8011DD33944C5FF00FFFF00FFFF00FFFF
          00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF1030E3001DEC0018DF000BDA
          FF00FFCACAC5BEBEBD8C886EFF00FF001EF8001CEF000FE5A2AAE7FF00FFFF00
          FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
          00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
          FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
          FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
          00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF}
        Layout = blGlyphRight
        SkinData.SkinSection = 'BUTTON'
      end
    end
    object SetAllAlarmsTimeGroup: TsGroupBox
      Left = 405
      Top = 76
      Width = 226
      Height = 71
      Anchors = [akLeft, akTop, akRight]
      Caption = #1578#1606#1592#1740#1605' '#1587#1575#1593#1578' '#1607#1605#1607' '#1570#1604#1575#1585#1605' '#1607#1575
      ParentBackground = False
      TabOrder = 1
      CaptionLayout = clTopRight
      SkinData.SkinSection = 'GROUPBOX'
      DesignSize = (
        226
        71)
      object sLabel10: TsLabel
        Left = 186
        Top = 21
        Width = 19
        Height = 13
        Anchors = [akRight, akBottom]
        Caption = #1579#1575#1606#1740#1607
        ParentFont = False
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
      end
      object sLabel11: TsLabel
        Left = 139
        Top = 21
        Width = 26
        Height = 13
        Anchors = [akRight, akBottom]
        Caption = #1583#1602#1740#1602#1607
        ParentFont = False
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
      end
      object sLabel12: TsLabel
        Left = 91
        Top = 21
        Width = 31
        Height = 13
        Anchors = [akRight, akBottom]
        Caption = #1587#1575#1593#1578
        ParentFont = False
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
      end
      object sLabel13: TsLabel
        Left = 173
        Top = 46
        Width = 4
        Height = 13
        Caption = ':'
        ParentFont = False
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
      end
      object sLabel16: TsLabel
        Left = 128
        Top = 46
        Width = 4
        Height = 13
        Caption = ':'
        ParentFont = False
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
      end
      object SpeedSetAlarmsTimeBtn: TsBitBtn
        Left = 8
        Top = 19
        Width = 65
        Height = 45
        Cursor = crHandPoint
        Caption = #1578#1606#1592#1740#1605
        TabOrder = 3
        OnClick = SpeedSetAlarmsTimeBtnClick
        Glyph.Data = {
          36030000424D3603000000000000360000002800000010000000100000000100
          18000000000000030000120B0000120B00000000000000000000FF00FFFF00FF
          FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
          FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFC3
          6E66B75439B7502FC46445D89181FF00FFFF00FFFF00FFFF00FFE49A4AFF00FF
          FF00FFFF00FFFF00FFCF6900D77100D87200D46F00CA6400AF49009F3305FF00
          FFFF00FFFF00FFFF00FFE49A4AFFB243FFB243DD7907F49000FB9500F18B00EE
          8800DE7700C76200BA5200A43B00FF00FFFF00FFFF00FFFF00FFEA994FE88A18
          E68818FFA218FF9E08FC9700F99300DA7100C26111B93929FF00FFFF00FFFF00
          FFFF00FFFF00FFFF00FFEC994BF7A63CFFB243FFA82DFFA21AFF9E08DF7600D1
          8442FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFEF9A49F9AD4E
          FFB757FFAD40FEA92DE88814D83E57FF00FFFF00FFFF00FFFF00FFFA46B7FB3E
          A1F93695F83695FC3B95F19C46FAB45FFFBD6BFFB857F7A435D86A1EFF00FFFF
          00FFFF00FFE87597E68F2DF19E39F69F36F7A33EF8AE56F89D24F59F47FDC381
          FFC787FDB964F8A842DC700AFF00FFFF00FFFF00FFFF00FFE14453EE982CFDB7
          5DFFC076FFCA92F5A139F8A42EF7A135F49F36F79C2FF49F38EC9C3CEAA75AFF
          00FFFF00FFFF00FFE23F70EC9022FFB34EFFB95FFEBE71F19829FF00FFFF00FF
          FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFE42A92DE7D0CFDA424FFAC
          38FFB24CFFB95FED9121FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
          00FFD17C5AD77204FB9703FFA013FFA526FFAB38FEAF48EA8D1BFF00FFFF00FF
          FF00FFFF00FFFF00FFFF00FFD0247AC44A31D36C00F28C00FA9400FE9A02FFA4
          13EA8A13E18115E3810FFF00FFFF00FFFF00FFFF00FFAD482EBA5E1CC86303D8
          7100E98300EC8800F58E00F69000DF7902E23C70FF00FFD77203FF00FFFF00FF
          FF00FFFF00FFCB3077A83F0FBB5503CD6801D36E01D46F02CC6804C76315DF56
          73FF00FFFF00FFEA3681FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFC36E66B7
          5439B7502FC46445D89181FF00FFFF00FFFF00FFFF00FFFF00FF}
        Layout = blGlyphRight
        SkinData.SkinSection = 'BUTTON'
      end
      object SpeedSecondSpin: TsSpinEdit
        Left = 178
        Top = 43
        Width = 40
        Height = 21
        Anchors = [akRight, akBottom]
        BiDiMode = bdLeftToRight
        Color = clWhite
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentBiDiMode = False
        ParentFont = False
        PopupMenu = MainForm.GeneralEditPopupMenu
        TabOrder = 2
        Text = '0'
        SkinData.SkinSection = 'EDIT'
        BoundLabel.Indent = 0
        BoundLabel.Font.Charset = DEFAULT_CHARSET
        BoundLabel.Font.Color = clWindowText
        BoundLabel.Font.Height = -11
        BoundLabel.Font.Name = 'MS Sans Serif'
        BoundLabel.Font.Style = []
        BoundLabel.Layout = sclLeft
        BoundLabel.MaxWidth = 0
        BoundLabel.UseSkinColor = True
        MaxValue = 59
        MinValue = 0
        Value = 0
      end
      object SpeedMinuteSpin: TsSpinEdit
        Left = 133
        Top = 43
        Width = 40
        Height = 21
        Anchors = [akRight, akBottom]
        BiDiMode = bdLeftToRight
        Color = clWhite
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentBiDiMode = False
        ParentFont = False
        PopupMenu = MainForm.GeneralEditPopupMenu
        TabOrder = 1
        Text = '0'
        SkinData.SkinSection = 'EDIT'
        BoundLabel.Indent = 0
        BoundLabel.Font.Charset = DEFAULT_CHARSET
        BoundLabel.Font.Color = clWindowText
        BoundLabel.Font.Height = -11
        BoundLabel.Font.Name = 'MS Sans Serif'
        BoundLabel.Font.Style = []
        BoundLabel.Layout = sclLeft
        BoundLabel.MaxWidth = 0
        BoundLabel.UseSkinColor = True
        MaxValue = 59
        MinValue = 0
        Value = 0
      end
      object SpeedHourSpin: TsSpinEdit
        Left = 88
        Top = 43
        Width = 40
        Height = 21
        Anchors = [akRight, akBottom]
        BiDiMode = bdLeftToRight
        Color = clWhite
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentBiDiMode = False
        ParentFont = False
        PopupMenu = MainForm.GeneralEditPopupMenu
        TabOrder = 0
        Text = '0'
        SkinData.SkinSection = 'EDIT'
        BoundLabel.Indent = 0
        BoundLabel.Font.Charset = DEFAULT_CHARSET
        BoundLabel.Font.Color = clWindowText
        BoundLabel.Font.Height = -11
        BoundLabel.Font.Name = 'MS Sans Serif'
        BoundLabel.Font.Style = []
        BoundLabel.Layout = sclLeft
        BoundLabel.MaxWidth = 0
        BoundLabel.UseSkinColor = True
        MaxValue = 23
        MinValue = 0
        Value = 0
      end
    end
    object SetAllAlarmsDurationGroup: TsGroupBox
      Left = 204
      Top = 76
      Width = 198
      Height = 71
      Anchors = [akLeft, akTop, akRight]
      Caption = #1578#1606#1592#1740#1605' '#1605#1583#1578' '#1601#1593#1575#1604' '#1576#1608#1583#1606' '#1607#1605#1607' '#1570#1604#1575#1585#1605' '#1607#1575
      ParentBackground = False
      TabOrder = 2
      CaptionLayout = clTopRight
      SkinData.SkinSection = 'GROUPBOX'
      DesignSize = (
        198
        71)
      object sLabel22: TsLabel
        Left = 142
        Top = 21
        Width = 45
        Height = 13
        Anchors = [akRight, akBottom]
        Caption = #1605#1583#1578' '#1570#1604#1575#1585#1605
        ParentFont = False
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
      end
      object sLabel8: TsLabel
        Left = 113
        Top = 46
        Width = 19
        Height = 13
        Anchors = [akRight, akBottom]
        Caption = #1579#1575#1606#1740#1607
        ParentFont = False
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
      end
      object SpeedSetAlarmsDurationBtn: TsBitBtn
        Left = 8
        Top = 19
        Width = 65
        Height = 45
        Cursor = crHandPoint
        Caption = #1578#1606#1592#1740#1605
        TabOrder = 1
        OnClick = SpeedSetAlarmsDurationBtnClick
        Glyph.Data = {
          36030000424D3603000000000000360000002800000010000000100000000100
          18000000000000030000120B0000120B00000000000000000000FF00FFFF00FF
          FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
          FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFC3
          6E66B75439B7502FC46445D89181FF00FFFF00FFFF00FFFF00FFE49A4AFF00FF
          FF00FFFF00FFFF00FFCF6900D77100D87200D46F00CA6400AF49009F3305FF00
          FFFF00FFFF00FFFF00FFE49A4AFFB243FFB243DD7907F49000FB9500F18B00EE
          8800DE7700C76200BA5200A43B00FF00FFFF00FFFF00FFFF00FFEA994FE88A18
          E68818FFA218FF9E08FC9700F99300DA7100C26111B93929FF00FFFF00FFFF00
          FFFF00FFFF00FFFF00FFEC994BF7A63CFFB243FFA82DFFA21AFF9E08DF7600D1
          8442FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFEF9A49F9AD4E
          FFB757FFAD40FEA92DE88814D83E57FF00FFFF00FFFF00FFFF00FFFA46B7FB3E
          A1F93695F83695FC3B95F19C46FAB45FFFBD6BFFB857F7A435D86A1EFF00FFFF
          00FFFF00FFE87597E68F2DF19E39F69F36F7A33EF8AE56F89D24F59F47FDC381
          FFC787FDB964F8A842DC700AFF00FFFF00FFFF00FFFF00FFE14453EE982CFDB7
          5DFFC076FFCA92F5A139F8A42EF7A135F49F36F79C2FF49F38EC9C3CEAA75AFF
          00FFFF00FFFF00FFE23F70EC9022FFB34EFFB95FFEBE71F19829FF00FFFF00FF
          FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFE42A92DE7D0CFDA424FFAC
          38FFB24CFFB95FED9121FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
          00FFD17C5AD77204FB9703FFA013FFA526FFAB38FEAF48EA8D1BFF00FFFF00FF
          FF00FFFF00FFFF00FFFF00FFD0247AC44A31D36C00F28C00FA9400FE9A02FFA4
          13EA8A13E18115E3810FFF00FFFF00FFFF00FFFF00FFAD482EBA5E1CC86303D8
          7100E98300EC8800F58E00F69000DF7902E23C70FF00FFD77203FF00FFFF00FF
          FF00FFFF00FFCB3077A83F0FBB5503CD6801D36E01D46F02CC6804C76315DF56
          73FF00FFFF00FFEA3681FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFC36E66B7
          5439B7502FC46445D89181FF00FFFF00FFFF00FFFF00FFFF00FF}
        Layout = blGlyphRight
        SkinData.SkinSection = 'BUTTON'
      end
      object SpeedDurationSpin: TsSpinEdit
        Left = 138
        Top = 43
        Width = 52
        Height = 21
        Anchors = [akRight, akBottom]
        BiDiMode = bdLeftToRight
        Color = clWhite
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentBiDiMode = False
        ParentFont = False
        PopupMenu = MainForm.GeneralEditPopupMenu
        TabOrder = 0
        Text = '0'
        SkinData.SkinSection = 'EDIT'
        BoundLabel.Indent = 0
        BoundLabel.Font.Charset = DEFAULT_CHARSET
        BoundLabel.Font.Color = clWindowText
        BoundLabel.Font.Height = -11
        BoundLabel.Font.Name = 'MS Sans Serif'
        BoundLabel.Font.Style = []
        BoundLabel.Layout = sclLeft
        BoundLabel.MaxWidth = 0
        BoundLabel.UseSkinColor = True
        MaxValue = 65000
        MinValue = 0
        Value = 0
      end
    end
  end
  object SaveAlarmDataToFileBtn: TsBitBtn
    Left = 5
    Top = 527
    Width = 117
    Height = 63
    Cursor = crHandPoint
    Anchors = [akLeft, akBottom]
    Caption = #1584#1582#1740#1585#1607' '#1578#1606#1592#1740#1605#1575#1578' '#1570#1604#1575#1585#1605' '#1583#1585' '#1601#1575#1740#1604'...'
    TabOrder = 4
    OnClick = SaveAlarmDataToFileBtnClick
    Glyph.Data = {
      F6060000424DF606000000000000360000002800000018000000180000000100
      180000000000C0060000120B0000120B00000000000000000000FF00FFFF00FF
      FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFE3B7
      9BEAC67FEBC889CE8768C87656C87656C87656C87656DBA686EAC9AAEAC798DF
      AC75FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
      FF00FFFF00FFEEC466FCE77BFDEB93E1AE92EDCFBBB93D03B93D03B93D03E0AA
      87FFFFEDFEF5BDEEC466FF00FFFF00FFFF00FFFF00FFFF00FF9191918D8D8D89
      8987FF00FFFF00FF0001B90000B9ECB750FAD45EFBDC7EF2C89BF7E0C3DE7207
      DE7207DE7207F0C18AFFFFEDFDEDB3EAB14DFF00FFFF00FFFF00FFFF00FFFF00
      FFA09F91BCBBB69694820713B20000B5625BAEC0A4AAE9A740F6C14BF7CE6FF8
      D49AFAE1B6EF9E25EF9E25EF9E25F8D49AFFFFEDFBE5ACE6A23EFF00FFFF00FF
      FF00FFFF00FFFF00FF0212BB868997182AB5242DBEFAD8B2FFEDB4FFE8BBE697
      2FF2AF37F3B84DF7D18DF7D18DF7D18DF7D18DF7D18DF7D18DF8D38EF4BC56E6
      972FFF00FFFF00FFFF00FFFF00FF0014CF001ED90012DE2D39C4FFEDB2FFE4B3
      FFDFB3FFDEB2E48B22EFA02CFFFFF2FFFFF2FFFFEDFFFFEDFFFFEDFFFFE6FFFF
      E6FFFFE6F0A534E1841EFF00FFFF00FFFF00FF0016E00023E0002BF40017CEFF
      E5B6FFE4B6FFE2B7FFE2B7FFE2B7DF7A11EB8E19FFFFF2FFFFF2FFFFF2FFFFF2
      FFFFEDFFFFEDFFFFEDFFFFE6EC9323DD750EFF00FFFF00FFFF00FF001DD40136
      FF0022F08D89C1FFEDB9FFE4BBFFE5BBFFE5BBFFE5BBD5680ADF7A11FFFFF9FF
      FFF2FFFFF2FFFFF2FFFFEDFFFFEDFFFFEDFFFFEDE17F1BD46407FF00FFFF00FF
      FF00FF072FEC0B40FF0016E3F8DFB5FFEABDFFE8BFFFE8C0FFE8C0FFEEC5C954
      08D06311FFFFF9FFFFF9FFFFF2FFFFF2FFFFF2FFFFEDFFFFEDFFFFEDD26A1BC7
      5106FF00FFFF00FF001DE81644FA1749FF132ED5FFEFB4FFEFCDFFECC7FFECC4
      FFF2C9D9CAABBB4208C14C0DFDEDB3FCEAB0FDEDB3FCEAB0FCEAB0FCEAB0FCEA
      AAFCEAAAC45515B93D03FF00FFFF00FF0020EC2657FF2252FF2A3FCCFFE9B3FF
      F6DEFFF4DAFFEFCAFFFDD44F4D45BA4D2DC66A47D5680AD76F10D5680AD76F10
      D76F10D5680ADD750ED5680AC36342BB5234FF00FFFF00FF0021F03261FF2C5D
      FF203BD0F3DFABFFF9E4FFF7DDFFF8D7FFF7D4343435AF3C26A11A03A11D08A1
      1D08A11D08A11D07A11A03A11D08A11D08A11D08A11A03AF3C26FF00FFFF00FF
      0022F43865FE3C69FF052CE5E2D09DFFF6E0FFFBE5FFFFE5646464202023B8B1
      97A29A851A1C2044464CD7CBB4FFE9BDFFEFBD7089EC0004BEFF00FFFF00FFFF
      00FFFF00FFFF00FF0023FA305BF64977FF103CF7A19CA0F2E7C7FFFFF1A4A4A2
      434347C9C5ACFFFFDCFFFFD9C5BA9E17181E847E6FFFEDC1FFF6BB2145E60009
      C1FF00FFFF00FFFF00FFFF00FFFF00FFFF00FF153FF15582FF4270FF324BC8DE
      D2A2D4D4C87E7F81BEBEB1FFFFE8FFF8D7FFF6D0FFF9D1DACCADFFF0C6FFECBD
      D1C9D00013D1FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF001EE81832
      D12643DB0833F49194AC525142ADADA6FFFFF8FFFDE7FFF8DFFFF5D7FFF3D1FF
      F0C8FFECC1FFF8BB2D4DE40001A5FF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
      FF00FF0322D71242FE0C34EC0017C8000BBF96959BDED6ABF2EED1FFFCE6FFFB
      E5FFF9E1FFF5DAFFF4CAFFFCBE6377DE000FD1000AAF0001ABFF00FFFF00FFFF
      00FFFF00FFFF00FFFF00FF1138E53364FF2F60FF2558FF113EF80008C152539E
      C5BE9FE7DCABF9ECBBFFF4C1FFFBC0E1D6C9384FDA0009C8000DB70032FE000C
      BFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF0A31E35B87FF4E7BFF3D6BFF2C
      5BFF1448FF0017D7000AC52141D83E54CF4155CD122BD00006CE000BC8102FD9
      1042FF0037FF0006B3FF00FFFF00FFFF00FFFF00FFFF00FFFF00FF0023FF4867
      E36E83C55A83FE3C6AFF2254FF083FFF000DBE001AE0696B7E001FFC001EDB30
      52EB4A74FB3A6AFF1D51FF0018D2FF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
      FF00FFFF00FFADB7E4C1BCAC5D6C98507EFF2F5FFF072CE30000B8ADAA8FA09C
      8C092CCF718BFBB8CBFF759AFF315CF8011DD33944C5FF00FFFF00FFFF00FFFF
      00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF1030E3001DEC0018DF000BDA
      FF00FFCACAC5BEBEBD8C886EFF00FF001EF8001CEF000FE5A2AAE7FF00FFFF00
      FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
      00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
      FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
      FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
      00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF}
    Layout = blGlyphTop
    SkinData.SkinSection = 'BUTTON'
  end
  object ClearAllAlarmsBtn: TsBitBtn
    Left = 135
    Top = 527
    Width = 117
    Height = 63
    Cursor = crHandPoint
    Anchors = [akLeft, akBottom]
    Caption = #1662#1575#1705' '#1705#1585#1583#1606' '#1578#1605#1575#1605' '#1570#1604#1575#1585#1605#8204#1607#1575#1740' '#1578#1575#1576#1604#1608
    TabOrder = 5
    OnClick = ClearAllAlarmsBtnClick
    Glyph.Data = {
      F6060000424DF606000000000000360000002800000018000000180000000100
      180000000000C0060000120B0000120B00000000000000000000FF00FFFF00FF
      FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
      FF781EFFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
      00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
      FF00FFFF00FF831CFF0C28E1301EDBFF00FFFF00FFFF00FFFF00FFFF00FFFF00
      FFFF00FF6A1DF6FF00FFFF00FFFF00FFFF00FFFF00FFFF00FF9191918D8D8D89
      8987FF00FFFF00FF0001B90000B90510CB1637F60922D15718E1FF00FF949490
      898989FF00FFFF00FFFF00FF0F1BC2FF00FFFF00FFFF00FFFF00FFFF00FFFF00
      FFA09F91BCBBB69694820713B20000B5625BAEC0A4AADBBFB34559EC193AFD09
      20CE0F1097A2A0A789897FFF00FFFF00FF2E23E74E19E1FF00FFFF00FFFF00FF
      FF00FFFF00FFFF00FF0212BB868997182AB5242DBEFAD8B2FFEDB4FFE8BBFFE7
      BEFFEBC2425CF32041F40F2ADA0007AE36358FFF00FF731FFF0D21D1FF00FFFF
      00FFFF00FFFF00FFFF00FFFF00FF0014CF001ED90012DE2D39C4FFEDB2FFE4B3
      FFDFB3FFDEB2FFDEB2FFDDB0FFE0B83953F51B3DFE1D3EEE010EB55626FF0E2C
      E99D16FFFF00FFFF00FFFF00FFFF00FFFF00FF0016E00023E0002BF40017CEFF
      E5B6FFE4B6FFE2B7FFE2B7FFE2B7FFE1B6FFE0B4FFDFB3FFDEB03C55F41336FF
      1031F60E31F3342DFFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF001DD40136
      FF0022F08D89C1FFEDB9FFE4BBFFE5BBFFE5BBFFE5BBFFE4BAFFE3BAFFE2B7FF
      E0B4FFDEB13855FD2D4DFE1336F9FF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
      FF00FF072FEC0B40FF0016E3F8DFB5FFEABDFFE8BFFFE8C0FFE8C0FFEEC5FFEC
      C3FFEBC2FFE7BCFFE2B83F55F14662FE3250FD2F4EFE0C24E4FF00FFFF00FFFF
      00FFFF00FFFF00FF001DE81644FA1749FF132ED5FFEFB4FFEFCDFFECC7FFECC4
      FFF2C9D9CAAB3A3B406365689296DB2849FD3453FE6571E5FFF0C53C5DFC3B59
      FE761FFFFF00FFFF00FFFF00FFFF00FF0020EC2657FF2252FF2A3FCCFFE9B3FF
      F6DEFFF4DAFFEFCAFFFDD44F4D45C4C4C5223CCD3453FE3B59FE5A6BEBFFE2B7
      FFEDC08FA2EB1833ED3752FE7E1DFFFF00FFFF00FFFF00FF0021F03261FF2C5D
      FF203BD0F3DFABFFF9E4FFF7DDFFF8D7FFF7D4343435344EDE4662FE4662FC83
      8CDEFFECC1FFE3B9FFEDBE90A0E9000EC8FF00FF455DFE6E20FFFF00FFFF00FF
      0022F43865FE3C69FF052CE5E2D09DFFF6E0FFFBE5FFFFE56464642020234B66
      FE445FFC17246744464CD7CBB4FFE9BDFFEFBD7089EC0004BEFF00FFFF00FF99
      17FFFF00FFFF00FF0023FA305BF64977FF103CF7A19CA0F2E7C7FFFFF1A4A4A2
      434347C9C5AC506AF6FFFFD9C5BA9E17181E847E6FFFEDC1FFF6BB2145E60009
      C1FF00FFFF00FFFF00FFFF00FFFF00FFFF00FF153FF15582FF4270FF324BC8DE
      D2A2D4D4C87E7F81BEBEB1FFFFE8FFF8D7FFF6D0FFF9D1DACCADFFF0C6FFECBD
      D1C9D00013D1FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF001EE81832
      D12643DB0833F49194AC525142ADADA6FFFFF8FFFDE7FFF8DFFFF5D7FFF3D1FF
      F0C8FFECC1FFF8BB2D4DE40001A5FF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
      FF00FF0322D71242FE0C34EC0017C8000BBF96959BDED6ABF2EED1FFFCE6FFFB
      E5FFF9E1FFF5DAFFF4CAFFFCBE6377DE000FD1000AAF0001ABFF00FFFF00FFFF
      00FFFF00FFFF00FFFF00FF1138E53364FF2F60FF2558FF113EF80008C152539E
      C5BE9FE7DCABF9ECBBFFF4C1FFFBC0E1D6C9384FDA0009C8000DB70032FE000C
      BFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF0A31E35B87FF4E7BFF3D6BFF2C
      5BFF1448FF0017D7000AC52141D83E54CF4155CD122BD00006CE000BC8102FD9
      1042FF0037FF0006B3FF00FFFF00FFFF00FFFF00FFFF00FFFF00FF0023FF4867
      E36E83C55A83FE3C6AFF2254FF083FFF000DBE001AE0696B7E001FFC001EDB30
      52EB4A74FB3A6AFF1D51FF0018D2FF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
      FF00FFFF00FFADB7E4C1BCAC5D6C98507EFF2F5FFF072CE30000B8ADAA8FA09C
      8C092CCF718BFBB8CBFF759AFF315CF8011DD33944C5FF00FFFF00FFFF00FFFF
      00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF1030E3001DEC0018DF000BDA
      FF00FFCACAC5BEBEBD8C886EFF00FF001EF8001CEF000FE5A2AAE7FF00FFFF00
      FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
      00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
      FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
      FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
      00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF}
    Layout = blGlyphTop
    SkinData.SkinSection = 'BUTTON'
  end
  object GetAlarmBtn: TsBitBtn
    Left = 395
    Top = 527
    Width = 117
    Height = 63
    Cursor = crHandPoint
    Anchors = [akLeft, akBottom]
    Caption = #1583#1585#1740#1575#1601#1578' '#1578#1606#1592#1740#1605#1575#1578' '#1570#1604#1575#1585#1605'   '#1578#1575#1576#1604#1608
    TabOrder = 7
    OnClick = GetAlarmBtnClick
    Glyph.Data = {
      F6060000424DF606000000000000360000002800000018000000180000000100
      180000000000C0060000120B0000120B00000000000000000000FF00FFFF00FF
      FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
      FFFF00FFFF00FFFF00FFFF00FFFF00FF1243350F3A2EFF00FFFF00FFFF00FFFF
      00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
      FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF14433546A081419A7B0F39
      2BFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF9191918D8D8D89
      8987FF00FFFF00FF0001B90000B90000B50000AE0000ABFF00FF0F3E2F44A382
      1E936821946A3F9D7C0B3225FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
      FFA09F91BCBBB69694820713B20000B5625BAEC0A4AADBBFB3A39AC63F54D80B
      3B2E3FA17E249C6F22996D23996D279C713B9C79083225FF00FFFF00FFFF00FF
      FF00FFFF00FFFF00FF0212BB868997182AB5242DBEFAD8B2FFEDB4FFE8BBFFE7
      BEFFEBC20F42313BA8802DA77827A17228A27329A17427A0722EA67840A5800E
      382AFF00FFFF00FFFF00FFFF00FF0014CF001ED90012DE2D39C4FFEDB2FFE4B3
      FFDFB3FFDEB2FFDEB2FFDDB01885631A8B6423996D2FAB7A2EAA782FAA7930AB
      7B4DA784489E7F2B8A6BFF00FFFF00FFFF00FF0016E00023E0002BF40017CEFF
      E5B6FFE4B6FFE2B7FFE2B7FFE2B7FFE1B6FFE0B4FFDFB3FFDEB01E7F5C35B682
      31B07D31B07E3CB8863B8369FF00FFFF00FFFF00FFFF00FFFF00FF001DD40136
      FF0022F08D89C1FFEDB9FFE4BBFFE5BBFFE5BBFFE5BBFFE4BAFFE3BAFFE2B7FF
      E0B428876442BD8A3FB7853CB68446BE8D448B71FF00FFFF00FFFF00FFFF00FF
      FF00FF072FEC0B40FF0016E3F8DFB5FFEABDFFE8BFFFE8C0FFE8C0FFEEC5FFEC
      C3FFEBC2FFE7BCFFE2B8368C6C5AC89957C1945AC29663CB9F509079FF00FFFF
      00FFFF00FFFF00FF001DE81644FA1749FF132ED5FFEFB4FFEFCDFFECC7FFECC4
      FFF2C9D9CAAB3A3B40636568F6E2BFFFE8BC4394756ED0A672CCA57CCFAB84D7
      B45C9782FF00FFFF00FFFF00FFFF00FF0020EC2657FF2252FF2A3FCCFFE9B3FF
      F6DEFFF4DAFFEFCAFFFDD44F4D45C4C4C54B4D4FBCB29EFFF0C4519D7F81D8B2
      8FD8B897DABDA1E2C466A08AFF00FFFF00FFFF00FFFF00FF0021F03261FF2C5D
      FF203BD0F3DFABFFF9E4FFF7DDFFF8D7FFF7D4343435898B8D38393B535457EA
      DBBF5AA58699E1C1ADE3CBACE3CBB7ECD370A892FF00FFFF00FFFF00FFFF00FF
      0022F43865FE3C69FF052CE5E2D09DFFF6E0FFFBE5FFFFE5646464202023B8B1
      97A29A851A1C2044464C66AC90BEF0D9C5EDDAC3ECD9CDF5E27CB09BFF00FFFF
      00FFFF00FFFF00FF0023FA305BF64977FF103CF7A19CA0F2E7C7FFFFF1A4A4A2
      434347C9C5ACFFFFDCFFFFD9C5BA9E17181E66AF91C2EDD9BAE6D3B9E6D3C0EC
      D971AE95FF00FFFF00FFFF00FFFF00FFFF00FF153FF15582FF4270FF324BC8DE
      D2A2D4D4C87E7F81BEBEB1FFFFE8FFF8D7FFF6D0FFF9D1DACCADFFF0C6FFECBD
      D1C9D00013D1FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF001EE81832
      D12643DB0833F49194AC525142ADADA6FFFFF8FFFDE7FFF8DFFFF5D7FFF3D1FF
      F0C8FFECC1FFF8BB2D4DE40001A5FF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
      FF00FF0322D71242FE0C34EC0017C8000BBF96959BDED6ABF2EED1FFFCE6FFFB
      E5FFF9E1FFF5DAFFF4CAFFFCBE6377DE000FD1000AAF0001ABFF00FFFF00FFFF
      00FFFF00FFFF00FFFF00FF1138E53364FF2F60FF2558FF113EF80008C152539E
      C5BE9FE7DCABF9ECBBFFF4C1FFFBC0E1D6C9384FDA0009C8000DB70032FE000C
      BFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF0A31E35B87FF4E7BFF3D6BFF2C
      5BFF1448FF0017D7000AC52141D83E54CF4155CD122BD00006CE000BC8102FD9
      1042FF0037FF0006B3FF00FFFF00FFFF00FFFF00FFFF00FFFF00FF0023FF4867
      E36E83C55A83FE3C6AFF2254FF083FFF000DBE001AE0696B7E001FFC001EDB30
      52EB4A74FB3A6AFF1D51FF0018D2FF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
      FF00FFFF00FFADB7E4C1BCAC5D6C98507EFF2F5FFF072CE30000B8ADAA8FA09C
      8C092CCF718BFBB8CBFF759AFF315CF8011DD33944C5FF00FFFF00FFFF00FFFF
      00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF1030E3001DEC0018DF000BDA
      FF00FFCACAC5BEBEBD8C886EFF00FF001EF8001CEF000FE5A2AAE7FF00FFFF00
      FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
      00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
      FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
      FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
      00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF}
    Layout = blGlyphTop
    SkinData.SkinSection = 'BUTTON'
  end
  object AlarmMonthCombo: TsComboBox
    Left = 432
    Top = 197
    Width = 73
    Height = 21
    SelStart = 7
    SelLength = 0
    Text = #1601#1585#1608#1585#1583#1740#1606
    Items.Strings = (
      #1601#1585#1608#1585#1583#1740#1606
      #1575#1585#1583#1740#1576#1607#1588#1578
      #1582#1585#1583#1575#1583
      #1578#1740#1585
      #1605#1585#1583#1575#1583
      #1588#1607#1585#1740#1608#1585
      #1605#1607#1585
      #1570#1576#1575#1606
      #1570#1584#1585
      #1583#1740
      #1576#1607#1605#1606
      #1575#1587#1601#1606#1583)
    Alignment = taLeftJustify
    BoundLabel.Indent = 0
    BoundLabel.Font.Charset = DEFAULT_CHARSET
    BoundLabel.Font.Color = clWindowText
    BoundLabel.Font.Height = -11
    BoundLabel.Font.Name = 'MS Sans Serif'
    BoundLabel.Font.Style = []
    BoundLabel.Layout = sclLeft
    BoundLabel.MaxWidth = 0
    BoundLabel.UseSkinColor = True
    SkinData.SkinSection = 'COMBOBOX'
    Style = csDropDownList
    Anchors = [akTop, akRight]
    BiDiMode = bdLeftToRight
    Color = clWhite
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ItemHeight = 13
    ItemIndex = 0
    ParentBiDiMode = False
    ParentFont = False
    TabOrder = 2
    OnChange = AlarmMonthComboChange
  end
  object sSkinProvider1: TsSkinProvider
    CaptionAlignment = taCenter
    SkinData.SkinSection = 'FORM'
    MakeSkinMenu = False
    ShowAppIcon = False
    TitleButtons = <>
    Left = 126
    Top = 8
  end
  object SetAlarmDataPopup: TTntPopupMenu
    BiDiMode = bdRightToLeft
    OwnerDraw = True
    ParentBiDiMode = False
    Left = 161
    Top = 8
    object SetAlarmsDataMenuItem1: TTntMenuItem
      Caption = #1578#1606#1592#1740#1605' '#1570#1604#1575#1585#1605' '#1578#1575#1576#1604#1608#1740' '#1588#1605#1575#1585#1607' 1'
      OnClick = SetAlarmsDataMenuItem1Click
      IgnoreAllMenuChanges = False
    end
    object SetAlarmsDataMenuItem2: TTntMenuItem
      Caption = #1578#1606#1592#1740#1605' '#1570#1604#1575#1585#1605' '#1578#1575#1576#1604#1608#1740' '#1588#1605#1575#1585#1607' 2'
      OnClick = SetAlarmsDataMenuItem2Click
      IgnoreAllMenuChanges = False
    end
  end
  object TntXPMenu1: TTntXPMenu
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clMenuText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    Color = clBtnFace
    IconBackColor = clBtnFace
    MenuBarColor = clBtnFace
    SelectColor = clHighlight
    SelectBorderColor = clHighlight
    SelectFontColor = clMenuText
    DisabledColor = clInactiveCaption
    SeparatorColor = clBtnFace
    CheckedColor = clHighlight
    IconWidth = 24
    DrawSelect = True
    UseSystemColors = True
    OverrideOwnerDraw = False
    Gradient = False
    FlatMenu = False
    AutoDetect = True
    Active = True
    Left = 195
    Top = 8
  end
  object OpenAlarmFileDialog: TTntOpenDialog
    Filter = 'Alarm Files (*.LDCAlarm)|*.LDCAlarm'
    Options = [ofHideReadOnly, ofPathMustExist, ofFileMustExist, ofEnableSizing]
    Title = 'Select Alarm File'
    Left = 24
    Top = 8
  end
  object SaveAlarmDialog: TTntSaveDialog
    Filter = 'Alarm Files (*.LDCAlarm)|*.LDCAlarm'
    Title = 'Save Alarms'
    OnCanClose = SaveAlarmDialogCanClose
    Left = 58
    Top = 8
  end
  object ClearAlarmDataPopup: TTntPopupMenu
    BiDiMode = bdRightToLeft
    OwnerDraw = True
    ParentBiDiMode = False
    Left = 229
    Top = 8
    object ClearAlarmsDataMenuItem1: TTntMenuItem
      Caption = #1662#1575#1705' '#1705#1585#1583#1606' '#1570#1604#1575#1585#1605' '#1607#1575#1740' '#1578#1575#1576#1604#1608#1740' '#1588#1605#1575#1585#1607' 1'
      OnClick = ClearAlarmsDataMenuItem1Click
      IgnoreAllMenuChanges = False
    end
    object ClearAlarmsDataMenuItem2: TTntMenuItem
      Caption = #1662#1575#1705' '#1705#1585#1583#1606' '#1570#1604#1575#1585#1605' '#1607#1575#1740' '#1578#1575#1576#1604#1608#1740' '#1588#1605#1575#1585#1607' 2'
      OnClick = ClearAlarmsDataMenuItem2Click
      IgnoreAllMenuChanges = False
    end
  end
  object HighGUITimer: TTimer
    Tag = 1
    Enabled = False
    Interval = 50
    OnTimer = HighGUITimerTimer
    Left = 92
    Top = 8
  end
  object GetAlarmsPopup: TTntPopupMenu
    BiDiMode = bdRightToLeft
    OwnerDraw = True
    ParentBiDiMode = False
    Left = 264
    Top = 8
    object GetAlarmMenuItem1: TTntMenuItem
      Caption = #1583#1585#1740#1575#1601#1578' '#1570#1604#1575#1585#1605' '#1607#1575#1740' '#1578#1575#1576#1604#1608#1740' '#1588#1605#1575#1585#1607' 1'
      OnClick = GetAlarmMenuItem1Click
      IgnoreAllMenuChanges = False
    end
    object GetAlarmMenuItem2: TTntMenuItem
      Caption = #1583#1585#1740#1575#1601#1578' '#1570#1604#1575#1585#1605' '#1607#1575#1740' '#1578#1575#1576#1604#1608#1740' '#1588#1605#1575#1585#1607' 2'
      OnClick = GetAlarmMenuItem2Click
      IgnoreAllMenuChanges = False
    end
  end
end
