object FormWindow: TFormWindow
  Left = 0
  Top = 0
  AlphaBlendValue = 170
  Caption = 'Window'
  ClientHeight = 211
  ClientWidth = 384
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  PopupMenu = PopupActionBar
  OnActivate = FormActivate
  OnClose = FormClose
  OnDblClick = FormDblClick
  OnKeyDown = FormKeyDown
  OnMouseDown = FormMouseDown
  OnMouseUp = FormMouseUp
  OnMouseWheel = FormMouseWheel
  OnResize = FormResize
  OnShow = FormShow
  DesignSize = (
    384
    211)
  PixelsPerInch = 96
  TextHeight = 13
  object labelBuild: TLabel
    Left = 341
    Top = 187
    Width = 35
    Height = 12
    Alignment = taRightJustify
    Anchors = [akRight, akBottom]
    Caption = '1.0.0.0'
    Font.Charset = OEM_CHARSET
    Font.Color = clSilver
    Font.Height = -16
    Font.Name = 'Terminal'
    Font.Style = []
    ParentFont = False
    OnDblClick = FormDblClick
    OnMouseDown = FormMouseDown
    OnMouseUp = FormMouseUp
    ExplicitLeft = 335
    ExplicitTop = 224
  end
  object labelHelp: TLabel
    Left = 8
    Top = 8
    Width = 140
    Height = 12
    Caption = 'Right-click here to start...'
    Font.Charset = OEM_CHARSET
    Font.Color = clSilver
    Font.Height = -16
    Font.Name = 'Terminal'
    Font.Style = []
    ParentFont = False
    OnDblClick = FormDblClick
    OnMouseDown = FormMouseDown
    OnMouseUp = FormMouseUp
  end
  object Timer: TTimer
    Enabled = False
    Interval = 50
    OnTimer = TimerTimer
    Left = 88
    Top = 128
  end
  object PopupActionBar: TPopupActionBar
    Images = imageList
    OnPopup = PopupActionBarPopup
    Left = 88
    Top = 80
    object menuSelectTarget: TMenuItem
      Caption = 'Select Target'
      ImageIndex = 0
      object menuDefault: TMenuItem
        Caption = 'None'
        Enabled = False
        Visible = False
        OnClick = menuDefaultClick
      end
      object N11: TMenuItem
        Caption = '1'
      end
      object N21: TMenuItem
        Caption = '2'
      end
    end
    object menuSelectTargetRegion: TMenuItem
      Caption = 'Select Target Region'
      ImageIndex = 1
      OnClick = menuSelectTargetRegionClick
    end
    object menuResizeWindow1x1: TMenuItem
      Caption = 'Resize Window 1x1'
      ImageIndex = 2
      OnClick = menuResizeWindow1x1Click
    end
    object menuAllTargetSpace: TMenuItem
      Caption = 'All Target Space'
      ImageIndex = 3
      OnClick = menuAllTargetSpaceClick
    end
    object menuSeparatorNew: TMenuItem
      Caption = '-'
    end
    object menuNew: TMenuItem
      Caption = 'New...'
      ImageIndex = 4
      OnClick = menuNewClick
    end
    object menuSeparatorChecks: TMenuItem
      Caption = '-'
    end
    object menuAlwaysVisible: TMenuItem
      AutoCheck = True
      Caption = 'Always Visible'
    end
    object menuWindowMovable: TMenuItem
      AutoCheck = True
      Caption = 'Window Movable'
      Checked = True
    end
    object menuWindowSizable: TMenuItem
      AutoCheck = True
      Caption = 'Window Sizable'
      Checked = True
    end
    object menuWindowProportion: TMenuItem
      AutoCheck = True
      Caption = 'Window Proportion'
      Checked = True
    end
    object menuWindowStick: TMenuItem
      AutoCheck = True
      Caption = 'Window Stick'
      Checked = True
    end
    object menuWindowHalfOpacity: TMenuItem
      Caption = 'Window Half Opacity'
      OnClick = menuWindowHalfOpacityClick
    end
    object menuInvertWheel: TMenuItem
      AutoCheck = True
      Caption = 'Invert Wheel'
    end
    object menuSeparatorQuit: TMenuItem
      Caption = '-'
    end
    object menuClose: TMenuItem
      Caption = 'Close'
      OnClick = menuCloseClick
    end
  end
  object imageList: TImageList
    ColorDepth = cd32Bit
    Left = 88
    Top = 32
    Bitmap = {
      494C010105000800040010001000FFFFFFFF2110FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000002000000001002000000000000020
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000003020108B3020108B3020108B3020108B0000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000003020108BF5DCBEFFF5DCBEFF3020108B0000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000003020108BF5DCBEFFF5DCBEFF3020108B0000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000003020108BF5DCBEFFF5DCBEFF3020108B0000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000003323138EF5DCBEFFF5DCBEFF3020108B0000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000002F1F10892F1F
      10892F1F10892F1F10892F1F10893323138EF5DCBEFFF5DCBEFF3020108B3020
      108B3020108B3020108B3021108B3020108B0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000003020108BF5DC
      BEFFF2D9BBFEF0D7BAFDEED4B8FCEED4B8FCF5DCBEFFF5DCBEFFEED4B8FCF0D7
      BAFDF2D9BBFEF5DCBEFFF5DCBEFF3020108B0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000003020108BEFD6
      B9FDF2D9BBFEF2D9BBFEF2D9BBFEF2D9BBFEF5DCBEFFF5DCBEFFF5DCBEFFF5DC
      BEFFF5DCBEFFF5DCBEFFF2D9BBFE3020108B0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000002E1F0F882E1F
      0F882E1F0F882E1F0F882F20108935251490F5DCBEFFF5DCBEFF3222128D3121
      118C3020108B3020108B3020108B3020108B0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000035251490F5DCBEFFF5DCBEFF3222128D0000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000003020108BF5DCBEFFF5DCBEFF3020108B0000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000003020108BF5DCBEFFF5DCBEFF3020108B0000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000003020108BF5DCBEFFF5DCBEFF3020108B0000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000003020108B3020108B3020108B3020108B0000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000120000002B0000002D0000
      002D0000002D0000002D0000002D000000250000000500000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000271E127BE2CAABFFE2C9AAFFE2C9
      AAFFE2C9AAFFE2C9AAFFE2C9AAFFC4A47CF70000000B00000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000000B0000
      000B0000000B0000000B0000000B000000043528178BFEFEFCFFFDFCF8FFFDFC
      F8FFFDFCF8FFFDFCF8FFFDFCF8FFE2C9AAFF000000150000000B0000000B0000
      000B0000000B0000000B0000000B000000040000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000000B0000
      000B0000000B0000000B0000000B000000040000000000000000000000000000
      000000000000000000000000000000000000000000000000000F020709300715
      1A520104052500000000000000000000000000000000000000003020108B3020
      108B3020108B3020108B3020108B3020108B3020108B3020108B372613A13726
      13A1372613A1372613A1372614A0080503443528178BFCFAF4FFF9F5EAFFF9F5
      EAFFF9F5EAFFF9F5EAFFF9F4E9FFE2CAAAFF382512A2372613A1372613A13726
      13A1372613A1372613A1372614A00805034400000000000000003020108B3020
      108B3020108B3020108B3020108B3020108B3020108B3020108B372613A13726
      13A1372613A1372613A1372614A0080503440000000000000000000000000E0B
      043F2C240D6F493B168E6C5821AD0F100C4B3CB1D9EC46CFFFFF46CFFFFF46CF
      FFFF11333F7F00000000000000000000000000000000000000003020108BF5DC
      BEFFF5DCBEFFF5DCBEFFF7DFC2FFFEEDD9FFFEEDD9FFFDEBD6FFFDEBD6FFFDEB
      D6FFE9CFAEFFFDEDD8FFFEEFDBFF3021118B3528178BFAF6EDFFF5EEDDFFF5EE
      DDFFF5EEDDFFF5EEDDFFF5EDDCFFE0C6A6FFFEEDD9FFFDEBD6FFFDEBD6FFFDEB
      D6FFE9CFAEFFFDEDD8FFFEEFDBFF3021118B00000000000000003020108BF5DC
      BEFFF5DCBEFFF5DCBEFFF7DFC2FFFEEDD9FFFEEDD9FFFDEBD6FFFDEBD6FFFDEB
      D6FFFDEBD6FFFDEDD8FFFEEFDBFF3021118B000000000000000000000000B393
      36DFEBC047FFEBC047FFEBC047FF191B126046CFFFFF46CFFFFF46CFFFFF46CF
      FFFF1234408000000000000000000000000000000000000000003020108BF5DC
      BEFFF5DCBEFFF5DCBEFFF7DFC2FFFCE9D4FFFCE9D4FFFAE6CFFFFAE6CFFFFAE6
      CFFFE9CCAAFFFBE8D2FFFDEBD6FF3021108B3528178BF7F2E6FFF0E7D0FFF0E7
      D0FFF0E7D0FFF0E7D0FFF0E6CEFFE0C6A5FFFCE9D4FFFAE6CFFFFAE6CFFFFAE6
      CFFFE9CCAAFFFBE8D2FFFDEBD6FF3021108B00000000000000003020108BF5DC
      BEFFF5DCBEFFF5DCBEFFF7DFC2FFFCE9D4FFFCE9D4FFFAE6CFFFFAE6CFFFFAE6
      CFFFFAE6CFFFFBE8D2FFFDEBD6FF3021108B000000000000000000000000B493
      36DFEBC047FFEBC047FFEBC047FF191B126046CFFFFF46CFFFFF46CFFFFF46CF
      FFFF1234408000000000000000000000000000000000000000003020108BF5DC
      BEFFF5DCBEFFF5DCBEFFF7DFC2FFFDEBD6FFFDEBD6FFFAE6CFFFFAE6CFFFFAE6
      CFFFE9CCAAFFFBE8D2FFFDEBD6FF3021108B3528178BF5EEDEFFECE0C2FFECE0
      C2FFECE0C2FFECE0C2FFEBDFBFFFE0C6A7FFFDEBD6FFFAE6CFFFFAE6CFFFFAE6
      CFFFE9CCAAFFFBE8D2FFFDEBD6FF3021108B00000000000000003020108BF5DC
      BEFFF5DCBEFFF5DCBEFFF7DFC2FFFDEBD6FFFDEBD6FFFAE6CFFFFAE6CFFFFAE6
      CFFFFAE6CFFFFBE8D2FFFDEBD6FF3021108B0000000000000000000000004639
      158B5B4A1B9F5B4A1B9F5B4A1B9F090A073C1B50629F1B50629F1B50629F1B50
      629F0614195000000000000000000000000000000000000000003020108BF5DC
      BEFFF5DCBEFFF5DCBEFFF7DFC2FFFCE9D4FFFCE9D4FFFCE9D4FFFAE6CEFFFAE6
      CEFFE9CCA9FFFBE8D1FFFDEAD5FF3021108B34271789F9F5EBFFF3ECD8FFF3EC
      D9FFF3ECD9FFF3ECD9FFF3ECD8FFD4AB74FFD4A76DFFFCE9D4FFFAE6CEFFFAE6
      CEFFE9CCA9FFFBE8D1FFFDEAD5FF3021108B00000000000000003020108BF5DC
      BEFFF5DCBEFFF5DCBEFFF7DFC2FFFCE9D4FFFCE9D4FFFCE9D4FFFAE6CEFFFAE6
      CEFFFAE6CEFFFBE8D1FFFDEAD5FF3021108B0000000000000000000000001F2E
      6CA7293D8EBF293D8EBF293D8EBF060B1148367858BF367858BF367858BF3678
      58BF0D1E166000000000000000000000000000000000000000003020108BF5DC
      BEFFF5DCBEFFF5DCBEFFF7DFC2FFFAE4CCFFFAE4CCFFFAE4CCFFFAE4CCFFF7E1
      C7FFE7C8A5FFF8E2C9FFFBE8D1FF3021108B0A08053D4937209C795931CED9B3
      84FFD7B07EFFD7B07EFFC5965AFFEBBE7AFFE7B56AFFD1A469FFFAE4CCFFF7E1
      C7FFE7C8A5FFF8E2C9FFFBE8D1FF3021108B00000000000000003020108BF5DC
      BEFFF5DCBEFFF5DCBEFFF7DFC2FFFAE4CCFFFAE4CCFFFAE4CCFFFAE4CCFFF7E1
      C7FFF7E1C7FFF8E2C9FFFBE8D1FF3021108B0000000000000000000000003951
      C1DF4A6CFEFF4A6CFEFF4A6CFEFF0B141F6060D69FFF60D69FFF60D69FFF60D6
      9FFF1835288000000000000000000000000000000000000000003020108BF5DC
      BEFFF5DCBEFFF5DCBEFFF7DFC2FFF7DFC2FFF7DFC2FFF9E2C6FFF9E2C6FFF9E2
      C6FFD6AF80FFF6DDC0FFFAE5CCFF3021108B00000000000000003020108BFAE6
      CDFFF5DCBEFFF5DCBEFFF7DFC2FFD2A871FFE1B26CFFDEAC5FFFCFA165FFF9E2
      C6FFD6AF80FFF6DDC0FFFAE5CCFF3021108B00000000000000003020108BF5DC
      BEFFF5DCBEFFF5DCBEFFF7DFC2FFF7DFC2FFF7DFC2FFF9E2C6FFF9E2C6FFF9E2
      C6FFF9E2C6FFF6DDC0FFFAE5CCFF3021108B0000000000000000000000003951
      C1DF4A6CFEFF4A6CFEFF4A6CFEFF0B141F6060D69FFF60D69FFF60D69FFF60D6
      9FFF1835288000000000000000000000000000000000000000003021108BF1D6
      B3FFF1D6B3FFF1D6B3FFF1D6B3FFF3D9B7FFF3D9B7FFF3D9B7FFF9E2C6FFF9E2
      C6FFC69451FFF3D9B8FFF8E3C7FF3021108B00000000000000003021108BF8E3
      C7FFF1D6B3FFF1D6B3FFF1D6B3FFF3D9B7FFD0A56EFFD9A962FFD6A254FFC38E
      46FFC69451FFF3D9B8FFF8E3C7FF3021108B00000000000000003021108BF1D6
      B3FFF1D6B3FFF1D6B3FFF1D6B3FFF3D9B7FFF3D9B7FFF3D9B7FFF9E2C6FFF9E2
      C6FFF9E2C6FFF3D9B8FFF8E3C7FF3021108B0000000000000000000000000A0F
      23601925579625367EB43249ADD30A111A5960D69FFF60D69FFF60D69FFF60D6
      9FFF1735277F00000000000000000000000000000000000000003021108BEDD0
      AAFFEDD0AAFFEDD0AAFFEDD0AAFFEDD0AAFFEFD3AEFFEFD3AEFFEFD3AEFFF9E2
      C6FFCA9E63FFEFD3AEFFF6DFC3FF3021108B00000000000000003021108BF6DF
      C3FFEDD0AAFFEDD0AAFFEDD0AAFFEDD0AAFFEFD3AEFFCEA36BFFD2A35DFFCC96
      48FFCA9E63FFEFD3AEFFF6DFC3FF3021108B00000000000000003021108BEDD0
      AAFFEDD0AAFFEDD0AAFFEDD0AAFFEDD0AAFFEFD3AEFFEFD3AEFFEFD3AEFFF9E2
      C6FFF9E2C6FFEFD3AEFFF6DFC3FF3021108B0000000000000000000000000000
      0000000000000000000000000000000000000000000E0205042A07100C470E20
      17630206042B00000000000000000000000000000000000000003021108BEBCC
      A1FFEBCCA1FFEBCCA1FFEBCCA1FFEBCCA1FFECCDA3FFECCDA3FFECCDA3FFECCD
      A3FFCEA875FFECCDA3FFF4DDBEFF3021108B00000000000000003021108BF4DD
      BEFFEBCCA1FFEBCCA1FFEBCCA1FFEBCCA1FFECCDA3FFD0A875FFDFC195FFD7B1
      7AFFCEA875FFECCDA3FFF4DDBEFF3021108B00000000000000003021108BEBCC
      A1FFEBCCA1FFEBCCA1FFEBCCA1FFEBCCA1FFECCDA3FFECCDA3FFECCDA3FFECCD
      A3FFECCDA3FFECCDA3FFF4DDBEFF3021108B0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000003021108BDBB4
      80FFDBB480FFDBB480FFDBB480FFDBB480FFDBB481FFCFA269FFCFA268FFCFA2
      68FFD3A971FFE7C698FFF2DAB9FF3021108B00000000000000003021108BF3DB
      BAFFDBB480FFDBB480FFDBB480FFDBB480FFDBB481FFCFA269FFCFA268FFCFA2
      68FFD3A971FFE7C698FFF2DAB9FF3021108B00000000000000003021108BEBCC
      A1FFEBCCA1FFEBCCA1FFEBCCA1FFEBCCA1FFECCDA3FFECCDA3FFECCDA3FFECCD
      A3FFECCDA3FFE7C698FFF2DAB9FF3021108B0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000002F20108AE3BE
      8BFFE3BE8BFFE3BE8BFFE3BE8BFFE3BE8BFFE3BE8BFFE3BE8BFFE3BE8BFFE3BE
      8BFFE3BE8BFFE3BE8BFFF0D7B4FF2F20108A00000000000000002F20108AF0D7
      B4FFE3BE8BFFE3BE8BFFE3BE8BFFE3BE8BFFE3BE8BFFE3BE8BFFE3BE8BFFE3BE
      8BFFE3BE8BFFE3BE8BFFF0D7B4FF2F20108A00000000000000002F20108AE3BE
      8BFFE3BE8BFFE3BE8BFFE3BE8BFFE3BE8BFFE3BE8BFFE3BE8BFFE3BE8BFFE3BE
      8BFFE3BE8BFFE3BE8BFFF0D7B4FF2F20108A0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000021170C70D9B7
      91FFD9B690FFD9B690FFD9B690FFD9B690FFD9B690FFD9B690FFD9B690FFD9B6
      90FFD9B690FFD9B690FFD9B791FF21170C70000000000000000021170C70D9B7
      91FFD9B690FFD9B690FFD9B690FFD9B690FFD9B690FFD9B690FFD9B690FFD9B6
      90FFD9B690FFD9B690FFD9B791FF21170C70000000000000000021170C70D9B7
      91FFD9B690FFD9B690FFD9B690FFD9B690FFD9B690FFD9B690FFD9B690FFD9B6
      90FFD9B690FFD9B690FFD9B791FF21170C70424D3E000000000000003E000000
      2800000040000000200000000100010000000000000100000000000000000000
      000000000000000000000000FFFFFF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000}
  end
end
