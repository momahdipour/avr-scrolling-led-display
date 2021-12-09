object ImportGraphicsForm: TImportGraphicsForm
  Left = 207
  Top = 155
  Width = 612
  Height = 398
  BiDiMode = bdLeftToRight
  BorderIcons = [biSystemMenu, biMaximize]
  Caption = #1608#1575#1585#1583' '#1606#1605#1608#1583#1606' '#1578#1589#1608#1610#1585
  Color = clBtnFace
  Constraints.MinHeight = 390
  Constraints.MinWidth = 506
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsStayOnTop
  KeyPreview = True
  OldCreateOrder = False
  ParentBiDiMode = False
  Position = poDesktopCenter
  OnActivate = FormActivate
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnDeactivate = FormDeactivate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object BottomPanel: TPanel
    Left = 0
    Top = 331
    Width = 604
    Height = 33
    Align = alBottom
    BiDiMode = bdLeftToRight
    ParentBiDiMode = False
    TabOrder = 1
    DesignSize = (
      604
      33)
    object Bevel4: TBevel
      Left = 178
      Top = 6
      Width = 151
      Height = 23
      Anchors = [akTop, akRight]
      Shape = bsFrame
    end
    object InsertAsLCDBtn: TsBitBtn
      Left = 463
      Top = 4
      Width = 128
      Height = 25
      Cursor = crHandPoint
      Anchors = [akTop, akRight]
      BiDiMode = bdLeftToRight
      Caption = #1578#1571#1740#1740#1583
      Default = True
      Enabled = False
      ModalResult = 1
      ParentBiDiMode = False
      TabOrder = 1
      OnClick = InsertAsLCDBtnClick
      SkinData.SkinSection = 'BUTTON'
    end
    object InsertAtCursorBtn: TsBitBtn
      Left = 332
      Top = 4
      Width = 128
      Height = 25
      Cursor = crHandPoint
      Anchors = [akTop, akRight]
      BiDiMode = bdLeftToRight
      Cancel = True
      Caption = #1604#1594#1608
      ModalResult = 2
      ParentBiDiMode = False
      TabOrder = 2
      SkinData.SkinSection = 'BUTTON'
    end
    object OnlySelectionCheck: TsCheckBox
      Left = 189
      Top = 8
      Width = 130
      Height = 19
      Hint = 'Imports only the area selected on the preview.'
      Caption = #1601#1602#1591' '#1606#1575#1581#1740#1607' '#1575#1606#1578#1582#1575#1576' '#1588#1583#1607
      Alignment = taLeftJustify
      Anchors = [akTop, akRight]
      AutoSize = False
      BiDiMode = bdRightToLeft
      ParentBiDiMode = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      OnClick = OnlySelectionCheckClick
      SkinData.SkinSection = 'CHECKBOX'
      ImgChecked = 0
      ImgUnchecked = 0
    end
  end
  object TopPanel: TPanel
    Left = 0
    Top = 0
    Width = 604
    Height = 331
    Align = alClient
    BiDiMode = bdLeftToRight
    ParentBiDiMode = False
    TabOrder = 0
    object SectionSplitter: TSplitter
      Left = 317
      Top = 1
      Height = 329
      Beveled = True
      OnCanResize = SectionSplitterCanResize
      OnMoved = SectionSplitterMoved
    end
    object SourceSection: TsGroupBox
      Left = 1
      Top = 1
      Width = 316
      Height = 329
      Align = alLeft
      BiDiMode = bdLeftToRight
      Caption = #1578#1589#1608#1740#1585' '#1608#1585#1608#1583#1740
      ParentBiDiMode = False
      TabOrder = 0
      CaptionLayout = clTopRight
      SkinData.SkinSection = 'GROUPBOX'
      object ScrollBox1: TScrollBox
        Left = 2
        Top = 92
        Width = 312
        Height = 235
        HorzScrollBar.Tracking = True
        VertScrollBar.Tracking = True
        Align = alClient
        BiDiMode = bdLeftToRight
        BorderStyle = bsNone
        ParentBiDiMode = False
        TabOrder = 1
        object PreviewImage: TImage
          Left = 1
          Top = 1
          Width = 1
          Height = 1
          AutoSize = True
          OnMouseDown = PreviewImageMouseDown
        end
      end
      object Panel1: TPanel
        Left = 2
        Top = 15
        Width = 312
        Height = 77
        Align = alTop
        BiDiMode = bdLeftToRight
        ParentBiDiMode = False
        TabOrder = 0
        DesignSize = (
          312
          77)
        object ScalePictureLabel: TsLabel
          Left = 221
          Top = 48
          Width = 87
          Height = 13
          Anchors = [akTop, akRight]
          AutoSize = False
          Caption = #1605#1602#1740#1575#1587' '#1578#1594#1740#1740#1585' '#1575#1606#1583#1575#1586#1607':'#8207
          ParentFont = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
        end
        object ScalePictureTrackbar: TsDelayedTrackBar
          Left = 45
          Top = 44
          Width = 175
          Height = 27
          Anchors = [akLeft, akTop, akRight]
          Max = 500
          Min = 1
          Frequency = 50
          Position = 50
          TabOrder = 4
          ThumbLength = 20
          OnChange = ScalePictureTrackbarChange
          SkinData.SkinSection = 'TRACKBAR'
          ChangeDelay = 500
          OnDelayedChange = ScalePictureTrackbarDelayedChange
        end
        object ForegroundColorGroup: TsGroupBox
          Left = 140
          Top = 2
          Width = 169
          Height = 39
          Anchors = [akLeft, akTop, akRight]
          BiDiMode = bdLeftToRight
          Caption = #1585#1606#1711' '#1662#1740#1588' '#1586#1605#1740#1606#1607' '#1578#1589#1608#1740#1585
          ParentBiDiMode = False
          TabOrder = 2
          CaptionLayout = clTopRight
          SkinData.SkinSection = 'GROUPBOX'
          DesignSize = (
            169
            39)
          object ForegroundColorLabel: TsLabel
            Left = 4
            Top = 15
            Width = 55
            Height = 18
            Cursor = crHandPoint
            Anchors = [akLeft, akTop, akRight]
            AutoSize = False
            BiDiMode = bdLeftToRight
            Color = clWhite
            ParentBiDiMode = False
            ParentColor = False
            Transparent = False
            OnClick = ForegroundColorLabelClick
            UseSkinColor = False
          end
          object ToleranceBtn: TPopupSpinEdit
            Left = 63
            Top = 14
            Width = 102
            Height = 21
            Cursor = crHandPoint
            Anchors = [akTop, akRight]
            BiDiMode = bdRightToLeft
            Caption = #1578#1608#1604#1585#1575#1606#1587': 0 '
            ParentBiDiMode = False
            TabOrder = 0
            Glyph.Data = {
              36030000424D3603000000000000360000002800000010000000100000000100
              18000000000000030000120B0000120B00000000000000000000FF00FFFF00FF
              FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
              FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
              00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
              FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
              FFFF00FFFF00FFFF00FFFF00FFFF00FFF3F1EF63493563493563493563493563
              4935634935634935634935634935F3F1EFFF00FFFF00FFFF00FFFF00FFFF00FF
              B8A494F4E3DAE4CFC2DDC5B7D9BEACD8BCA9D7BAA7D7B9A5D6B7A3D6B6A26349
              35FF00FFFF00FFFF00FFFF00FFFF00FFB8A494F6E8E0F4E3DAF3DFD4F1DBCFF0
              D7C9EED3C4EDD0BFECCDBBD6B7A3634935FF00FFFF00FFFF00FFFF00FFFF00FF
              B8A494F8ECE5F6E8E0F4E3DAF3DFD4634935F0D7C9EED3C4EDD0BFD7B9A56349
              35FF00FFFF00FFFF00FFFF00FFFF00FFB9A595F9F0EBF8ECE5F6E8E063493563
              4935634935F0D7C9EED3C4D7BAA7634935FF00FFFF00FFFF00FFFF00FFFF00FF
              BCA697FBF4F0F9F0EB634935634935F4E3DA634935634935F0D7C9D8BCA96349
              35FF00FFFF00FFFF00FFFF00FFFF00FFBEA89AFCF7F5FBF4F0634935F8ECE5F6
              E8E0F4E3DA634935F1DBCFD9BEAC634935FF00FFFF00FFFF00FFFF00FFFF00FF
              C0AB9CFDFAF9FCF7F5FBF4F0F9F0EBF8ECE5F6E8E0F4E3DAF3DFD4D9C0AF6349
              35FF00FFFF00FFFF00FFFF00FFFF00FFC3AC9DFEFDFCFDFAF9FCF7F5FBF4F0F9
              F0EBF8ECE5F6E8E0F4E3DAE1CDC0634935FF00FFFF00FFFF00FFFF00FFFF00FF
              C4AE9EFFFFFFFEFDFCFDFAF9FCF7F5FBF4F0F9F0EBF8ECE5F6E8E0F4E3DA6349
              35FF00FFFF00FFFF00FFFF00FFFF00FFFBF9F7C3AD9EC2AC9DC0AB9CBEA899BB
              A798BAA496B8A394B8A394B8A394F3F1EFFF00FFFF00FFFF00FFFF00FFFF00FF
              FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
              FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
              00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF}
            Prefix = #1578#1608#1604#1585#1575#1606#1587': '
            Suffix = ' '
            AutoCaption = True
            Title = #1605#1740#1586#1575#1606' '#1578#1608#1604#1585#1575#1606#1587' '#1585#1606#1711' '#1607#1606#1711#1575#1605' '#1578#1576#1583#1740#1604':'
            Min = 0
            Max = 255
            Position = 0
            Frequency = 20
            LineSize = 1
            ThumbLength = 20
            TickMarks = tmBottomRight
            ChangeDelay = 500
            OnDelayedChange = ToleranceBtnDelayedChange
          end
        end
        object ImportPictureBtn: TsBitBtn
          Left = 34
          Top = 10
          Width = 103
          Height = 27
          Cursor = crHandPoint
          BiDiMode = bdLeftToRight
          Caption = #1608#1575#1585#1583' '#1606#1605#1608#1583#1606' '#1578#1589#1608#1740#1585'...'#8207
          ParentBiDiMode = False
          TabOrder = 0
          OnClick = ImportPictureBtnClick
          SkinData.SkinSection = 'BUTTON'
        end
        object ScalePictureNumEdit: TAdvancedNumEdit
          Left = 4
          Top = 44
          Width = 36
          Height = 21
          BiDiMode = bdLeftToRight
          ParentBiDiMode = False
          PopupMenu = MainForm.GeneralEditPopupMenu
          TabOrder = 3
          Text = '50%'
          Suffix = '%'
          Min = 1
          Max = 500
          Value = 50
          MaskActive = True
          OnMaskedChange = ScalePictureNumEditMaskedChange
        end
        object ImportFromClipboardBtn: TsBitBtn
          Left = 4
          Top = 10
          Width = 28
          Height = 27
          Cursor = crHandPoint
          Hint = 'Import from Clipboard'
          BiDiMode = bdLeftToRight
          ParentBiDiMode = False
          ParentShowHint = False
          ShowHint = True
          TabOrder = 1
          OnClick = ImportFromClipboardBtnClick
          Glyph.Data = {
            36060000424D3606000000000000360000002800000020000000100000000100
            18000000000000060000C30E0000C30E00000000000000000000FF00FFFF00FF
            FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
            FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
            00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
            FF00FFFF00FFFF00FFFF00FF816855262F38262F38262F38262F38262F38262F
            38262F38262F38262F38FF00FFFF00FFFF00FFFF00FFFF00FFFF00FF81685526
            2F38262F38262F38262F38262F38262F38262F38262F38262F38BCCCD2647E8E
            4F5E6F45526137414D262F3889715EE8DCD3B7A293B7A293B7A293B7A293B7A2
            93B7A293B7A293262F38FF00FF647E8E4F5E6F45526137414D262F3889715EFF
            00FFB7A293B7A293B7A293B7A293B7A293B7A293B7A293262F38717F8B22B6EC
            008FCD008FCD008FCD008FCD917966EFE6E1E8DBD3E0D0C6DAC6BCD4BFB2CFB9
            ABCCB6A8B7A293262F38717F8BFF00FFFF00FFFF00FFFF00FFFF00FF917966FF
            00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFB7A293262F3875849068C8EA
            10B5F008ACEB03A4E30096D49A826FF7F1EFC3AE9EC3AE9EBDA898B7A293D4BF
            B2B7A293B7A293262F38758490FF00FFFF00FFFF00FFFF00FFFF00FF9A826FFF
            00FFC3AE9EC3AE9EBDA898B7A293FF00FFB7A293B7A293262F3879899474D0ED
            28BDF111B5F007ABEA009DDCA28A78FDFBFAF7F2EEEFE6E1E8DBD3E0D0C6705A
            4A6152465048423F3D3E798994FF00FFFF00FFFF00FFFF00FFFF00FFA28A78FF
            00FFFF00FFFF00FFFF00FFFF00FF705A4A6152465048423F3D3E7E8E9A83D9F0
            46C9F22DBFF216B7F100A0E2A99280FFFFFFC3AE9EC3AE9EBDA899E8DCD37A60
            4DD4C5BA615247FF00FF7E8E9AFF00FFFF00FFFF00FFFF00FFFF00FFA99280FF
            00FFC3AE9EC3AE9EBDA899FF00FF7A604DFF00FF615247FF00FF82949E91E2F3
            66D5F44CCBF332C2F215AFE9B09988FFFFFFFFFFFFFCFBF9F7F1EFEFE7E18168
            567A604DFF00FFFF00FF82949EFF00FFFF00FFFF00FFFF00FFFF00FFB09988FF
            00FFFF00FFFF00FFFF00FFFF00FF8168567A604DFF00FFFF00FF8699A29FEAF6
            83E1F66BD8F553CEF40EB3F0B6A08EB09988A99280A28A789A82709179678971
            5EFF00FFFF00FFFF00FF8699A2FF00FFFF00FFFF00FFFF00FFFF00FFB6A08EB0
            9988A99280A28A789A827091796789715EFF00FFFF00FFFF00FF8A9EA6A9F0F8
            99EAF888E3F56DD1EA13A1D413A1D412A0D30D97CF0791CA008FCD008FCD3039
            44FF00FFFF00FFFF00FF8A9EA6FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
            00FFFF00FFFF00FFFF00FFFF00FF303944FF00FFFF00FFFF00FF8DA1AAAAF1F9
            A7F0F95E7D8A58737F566D7A5269774F66734C6170445A68236F90008FCD3E4A
            58FF00FFFF00FFFF00FF8DA1AAFF00FFFF00FF5E7D8A58737F566D7A5269774F
            66734C6170445A68FF00FFFF00FF3E4A58FF00FFFF00FFFF00FF8FA4ACAAF1F9
            A8F1F95D86968CC6CF93E4F07AD5E762C6DE4F9AB23E5A671C7DA5008FCD4B59
            69FF00FFFF00FFFF00FF8FA4ACFF00FFFF00FF5D8696FF00FFFF00FFFF00FFFF
            00FFFF00FF3E5A67FF00FFFF00FF4B5969FF00FFFF00FFFF00FF8FA4ACABF0F7
            AAF1F9A6EFF77397A2A1ECF5667D8A78C5D64C6C7C3461785FC3E822B6EC4E5E
            6FFF00FFFF00FFFF00FF8FA4ACFF00FFFF00FFFF00FF7397A2FF00FF667D8AFF
            00FF4C6C7C346178FF00FFFF00FF4E5E6FFF00FFFF00FFFF00FFB7CACF8FA4AC
            8FA4AC8FA4AC5B8D9FA5E8EF9BE8F48CD5E246667673858F7A8A95758591BDCE
            D3FF00FFFF00FFFF00FFFF00FF8FA4AC8FA4AC8FA4AC5B8D9FFF00FFFF00FFFF
            00FF46667673858F7A8A95758591FF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
            FF00FFFF00FFFF00FF86B3C382ADBD799FB0BCCED3FF00FFFF00FFFF00FFFF00
            FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF86B3C382ADBD79
            9FB0FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
            FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
            FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
            00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF}
          NumGlyphs = 2
          SkinData.SkinSection = 'BUTTON'
        end
      end
    end
    object PreviewSection: TsGroupBox
      Left = 320
      Top = 1
      Width = 283
      Height = 329
      Align = alClient
      Caption = #1662#1610#1588' '#1606#1605#1575#1610#1588
      TabOrder = 1
      CaptionLayout = clTopRight
      SkinData.SkinSection = 'GROUPBOX'
      object Panel6: TPanel
        Left = 2
        Top = 15
        Width = 279
        Height = 75
        Align = alTop
        BevelOuter = bvNone
        BiDiMode = bdLeftToRight
        ParentBiDiMode = False
        TabOrder = 0
        DesignSize = (
          279
          75)
        object PreviewZoomLabel: TsLabel
          Left = 231
          Top = 6
          Width = 45
          Height = 13
          Anchors = [akTop, akRight]
          AutoSize = False
          Caption = #1576#1586#1585#1711#1606#1605#1575#1610#1610':'
          ParentFont = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
        end
        object PreviewGridZoomTrackbar: TsTrackBar
          Left = 87
          Top = 1
          Width = 142
          Height = 27
          Anchors = [akLeft, akTop, akRight]
          Max = 200
          Min = 1
          Frequency = 10
          Position = 10
          TabOrder = 2
          ThumbLength = 18
          OnChange = PreviewGridZoomTrackbarChange
          SkinData.SkinSection = 'TRACKBAR'
        end
        object PreviewOptionsGroup: TsGroupBox
          Left = 3
          Top = 28
          Width = 272
          Height = 41
          Anchors = [akLeft, akTop, akRight]
          Caption = #1711#1586#1610#1606#1607' '#1607#1575
          TabOrder = 1
          CaptionLayout = clTopRight
          SkinData.SkinSection = 'GROUPBOX'
          DesignSize = (
            272
            41)
          object InvertLCDCheck: TsCheckBox
            Left = 97
            Top = 16
            Width = 166
            Height = 19
            Caption = #1605#1593#1705#1608#1587' '#1705#1585#1583#1606' '#1582#1575#1606#1607' '#1607#1575#1740' '#1589#1601#1581#1607
            Alignment = taLeftJustify
            Anchors = [akTop, akRight]
            AutoSize = False
            TabOrder = 0
            OnClick = InvertLCDCheckClick
            SkinData.SkinSection = 'CHECKBOX'
            ImgChecked = 0
            ImgUnchecked = 0
          end
        end
        object PreviewGridLinesCheck: TsCheckBox
          Left = 2
          Top = 4
          Width = 86
          Height = 19
          Caption = #1582#1591#1608#1591' '#1589#1601#1581#1607
          Alignment = taLeftJustify
          AutoSize = False
          Checked = True
          State = cbChecked
          TabOrder = 0
          OnClick = PreviewGridLinesCheckClick
          SkinData.SkinSection = 'CHECKBOX'
          ImgChecked = 0
          ImgUnchecked = 0
        end
      end
      object PreviewStatusBar: TStatusBar
        Left = 2
        Top = 308
        Width = 279
        Height = 19
        BiDiMode = bdLeftToRight
        Panels = <>
        ParentBiDiMode = False
        SimplePanel = True
      end
      object PreviewGrid: TMMAdvancedGrid
        Left = 2
        Top = 90
        Width = 279
        Height = 218
        Cursor = crDefault
        TabStop = False
        Align = alClient
        BiDiMode = bdLeftToRight
        ColCount = 30
        Ctl3D = True
        DefaultColWidth = 10
        DefaultRowHeight = 10
        DefaultDrawing = False
        FixedCols = 0
        RowCount = 30
        FixedRows = 0
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        GridLineWidth = 1
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goThumbTracking]
        ParentBiDiMode = False
        ParentCtl3D = False
        ParentFont = False
        ScrollBars = ssBoth
        TabOrder = 1
        OnSelectCell = PreviewGridSelectCell
        GridLineColor = clSilver
        ActiveCellShow = False
        ActiveCellFont.Charset = DEFAULT_CHARSET
        ActiveCellFont.Color = clWindowText
        ActiveCellFont.Height = -11
        ActiveCellFont.Name = 'Tahoma'
        ActiveCellFont.Style = [fsBold]
        ActiveCellColor = clGray
        Bands.PrimaryColor = clInfoBk
        Bands.PrimaryLength = 1
        Bands.SecondaryColor = clWindow
        Bands.SecondaryLength = 1
        Bands.Print = False
        AutoNumAlign = False
        AutoSize = False
        VAlignment = vtaTop
        EnhTextSize = False
        EnhRowColMove = True
        SizeWithForm = False
        Multilinecells = False
        OnSelectionChanged = PreviewGridSelectionChanged
        DragDropSettings.OleAcceptFiles = True
        DragDropSettings.OleAcceptText = True
        SortSettings.AutoColumnMerge = False
        SortSettings.Column = 0
        SortSettings.Show = False
        SortSettings.IndexShow = False
        SortSettings.IndexColor = clYellow
        SortSettings.Full = True
        SortSettings.SingleColumn = False
        SortSettings.IgnoreBlanks = False
        SortSettings.BlankPos = blFirst
        SortSettings.AutoFormat = True
        SortSettings.Direction = sdAscending
        SortSettings.InitSortDirection = sdAscending
        SortSettings.FixedCols = False
        SortSettings.NormalCellsOnly = False
        SortSettings.Row = 0
        SortSettings.UndoSort = False
        FloatingFooter.Color = clBtnFace
        FloatingFooter.Column = 0
        FloatingFooter.FooterStyle = fsFixedLastRow
        FloatingFooter.Visible = False
        ControlLook.Color = clBlack
        ControlLook.CheckSize = 15
        ControlLook.RadioSize = 10
        ControlLook.ControlStyle = csWinXP
        ControlLook.DropDownAlwaysVisible = False
        ControlLook.FlatButton = False
        ControlLook.NoDisabledCheckRadioLook = False
        ControlLook.ProgressMarginX = 2
        ControlLook.ProgressMarginY = 2
        ControlLook.ProgressXP = False
        EnableBlink = False
        EnableHTML = True
        EnableWheel = True
        Flat = False
        Look = glXP
        HintColor = clInfoBk
        SelectionColor = 15387318
        SelectionTextColor = clBlack
        SelectionRectangle = True
        SelectionResizer = True
        SelectionRTFKeep = False
        HintShowCells = False
        HintShowLargeText = False
        HintShowSizing = False
        PrintSettings.FooterSize = 0
        PrintSettings.HeaderSize = 0
        PrintSettings.Time = ppNone
        PrintSettings.Date = ppNone
        PrintSettings.DateFormat = 'dd/mm/yyyy'
        PrintSettings.PageNr = ppNone
        PrintSettings.Title = ppNone
        PrintSettings.Font.Charset = DEFAULT_CHARSET
        PrintSettings.Font.Color = clWindowText
        PrintSettings.Font.Height = -11
        PrintSettings.Font.Name = 'MS Sans Serif'
        PrintSettings.Font.Style = []
        PrintSettings.FixedFont.Charset = DEFAULT_CHARSET
        PrintSettings.FixedFont.Color = clWindowText
        PrintSettings.FixedFont.Height = -11
        PrintSettings.FixedFont.Name = 'MS Sans Serif'
        PrintSettings.FixedFont.Style = []
        PrintSettings.HeaderFont.Charset = DEFAULT_CHARSET
        PrintSettings.HeaderFont.Color = clWindowText
        PrintSettings.HeaderFont.Height = -11
        PrintSettings.HeaderFont.Name = 'MS Sans Serif'
        PrintSettings.HeaderFont.Style = []
        PrintSettings.FooterFont.Charset = DEFAULT_CHARSET
        PrintSettings.FooterFont.Color = clWindowText
        PrintSettings.FooterFont.Height = -11
        PrintSettings.FooterFont.Name = 'MS Sans Serif'
        PrintSettings.FooterFont.Style = []
        PrintSettings.Borders = pbSingle
        PrintSettings.BorderStyle = psSolid
        PrintSettings.Centered = True
        PrintSettings.RepeatFixedRows = False
        PrintSettings.RepeatFixedCols = False
        PrintSettings.LeftSize = 0
        PrintSettings.RightSize = 0
        PrintSettings.ColumnSpacing = 0
        PrintSettings.RowSpacing = 0
        PrintSettings.TitleSpacing = 0
        PrintSettings.Orientation = poPortrait
        PrintSettings.PageNumberOffset = 0
        PrintSettings.MaxPagesOffset = 0
        PrintSettings.FixedWidth = 0
        PrintSettings.FixedHeight = 0
        PrintSettings.UseFixedHeight = False
        PrintSettings.UseFixedWidth = False
        PrintSettings.FitToPage = fpNever
        PrintSettings.PageNumSep = '/'
        PrintSettings.NoAutoSize = False
        PrintSettings.NoAutoSizeRow = False
        PrintSettings.PrintGraphics = False
        PrintSettings.UseDisplayFont = True
        HTMLSettings.Width = 100
        HTMLSettings.XHTML = False
        Navigation.AdvanceDirection = adLeftRight
        Navigation.InsertPosition = pInsertBefore
        Navigation.HomeEndKey = heFirstLastColumn
        Navigation.TabToNextAtEnd = False
        Navigation.TabAdvanceDirection = adLeftRight
        ColumnSize.Location = clRegistry
        CellNode.Color = clSilver
        CellNode.ExpandOne = False
        CellNode.NodeColor = clBlack
        CellNode.NodeIndent = 12
        CellNode.ShowTree = True
        CellNode.TreeColor = clSilver
        MaxEditLength = 0
        Grouping.HeaderColor = clNone
        Grouping.HeaderColorTo = clNone
        Grouping.HeaderTextColor = clNone
        Grouping.MergeHeader = False
        Grouping.MergeSummary = False
        Grouping.Summary = False
        Grouping.SummaryColor = clNone
        Grouping.SummaryColorTo = clNone
        Grouping.SummaryTextColor = clNone
        IntelliPan = ipNone
        IntelliZoom = False
        URLColor = clBlue
        URLShow = False
        URLFull = False
        URLEdit = False
        ScrollType = ssNormal
        ScrollColor = clNone
        ScrollWidth = 17
        ScrollSynch = False
        ScrollProportional = False
        ScrollHints = shNone
        OemConvert = False
        FixedFooters = 0
        FixedRightCols = 0
        FixedColWidth = 10
        FixedRowHeight = 10
        FixedFont.Charset = DEFAULT_CHARSET
        FixedFont.Color = clWindowText
        FixedFont.Height = -11
        FixedFont.Name = 'Tahoma'
        FixedFont.Style = [fsBold]
        FixedAsButtons = False
        FloatFormat = '%.2f'
        IntegralHeight = False
        WordWrap = True
        Lookup = False
        LookupCaseSensitive = False
        LookupHistory = False
        ShowSelection = False
        HideFocusRect = True
        BackGround.Top = 0
        BackGround.Left = 0
        BackGround.Display = bdTile
        BackGround.Cells = bcNormal
        Filter = <>
      end
    end
  end
  object ColorDialog1: TColorDialog
    Options = [cdSolidColor]
    Left = 211
    Top = 109
  end
  object OpenPictureDialog1: TTntOpenPictureDialog
    Title = 'Import Picture'
    Left = 243
    Top = 109
  end
  object sSkinProvider1: TsSkinProvider
    CaptionAlignment = taCenter
    SkinData.SkinSection = 'FORM'
    MakeSkinMenu = False
    ShowAppIcon = False
    TitleButtons = <>
    Left = 176
    Top = 104
  end
  object HighGUITimer: TTimer
    Tag = 1
    Enabled = False
    Interval = 50
    OnTimer = HighGUITimerTimer
    Left = 5
    Top = 2
  end
end
