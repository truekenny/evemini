object FormMain: TFormMain
  Left = 0
  Top = 0
  AlphaBlendValue = 170
  BorderStyle = bsNone
  Caption = 'FormMain'
  ClientHeight = 178
  ClientWidth = 303
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
  OnCreate = FormCreate
  OnDblClick = FormDblClick
  OnMouseDown = FormMouseDown
  OnMouseWheel = FormMouseWheel
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Timer: TTimer
    Enabled = False
    Interval = 50
    OnTimer = TimerTimer
    Left = 8
    Top = 8
  end
  object PopupActionBar: TPopupActionBar
    Images = imageList
    OnPopup = PopupActionBarPopup
    Left = 56
    Top = 8
    object menuSelectWindow: TMenuItem
      Caption = 'Select Window'
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
    object menuSelectGameArea: TMenuItem
      Caption = 'Select Game Area'
      ImageIndex = 1
      OnClick = menuSelectGameAreaClick
    end
    object menuResizeWindow1x1: TMenuItem
      Caption = 'Resize Window 1x1'
      ImageIndex = 2
      OnClick = menuResizeWindow1x1Click
    end
    object menuSeparatorChecks: TMenuItem
      Caption = '-'
    end
    object menuAlwaysVisible: TMenuItem
      Caption = 'Always Visible'
      OnClick = menuReCheck
    end
    object menuWindowMovable: TMenuItem
      Caption = 'Window Movable'
      Checked = True
      OnClick = menuReCheck
    end
    object menuWindowSizable: TMenuItem
      Caption = 'Window Sizable'
      Checked = True
      OnClick = menuReCheck
    end
    object menuWindowHalfOpacity: TMenuItem
      Caption = 'Window Half Opacity'
      OnClick = menuWindowHalfOpacityClick
    end
    object menuSeparatorQuit: TMenuItem
      Caption = '-'
    end
    object menuQuit: TMenuItem
      Caption = 'Quit'
      OnClick = menuQuitClick
    end
  end
  object imageList: TImageList
    ColorDepth = cd32Bit
    Left = 104
    Top = 8
    Bitmap = {
      494C0101030008002C0010001000FFFFFFFF2110FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000001000000001002000000000000010
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
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000F020709300715
      1A520104052500000000000000000000000000000000000000003020108B3020
      108B3020108B3020108B3020108B3020108B3020108B3020108B372613A13726
      13A1372613A1372613A1372614A0080503443528178BFCFAF4FFF9F5EAFFF9F5
      EAFFF9F5EAFFF9F5EAFFF9F4E9FFE2CAAAFF382512A2372613A1372613A13726
      13A1372613A1372613A1372614A0080503440000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000E0B
      043F2C240D6F493B168E6C5821AD0F100C4B3CB1D9EC46CFFFFF46CFFFFF46CF
      FFFF11333F7F00000000000000000000000000000000000000003020108BF5DC
      BEFFF5DCBEFFF5DCBEFFF7DFC2FFFEEDD9FFFEEDD9FFFDEBD6FFFDEBD6FFFDEB
      D6FFE9CFAEFFFDEDD8FFFEEFDBFF3021118B3528178BFAF6EDFFF5EEDDFFF5EE
      DDFFF5EEDDFFF5EEDDFFF5EDDCFFE0C6A6FFFEEDD9FFFDEBD6FFFDEBD6FFFDEB
      D6FFE9CFAEFFFDEDD8FFFEEFDBFF3021118B0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000B393
      36DFEBC047FFEBC047FFEBC047FF191B126046CFFFFF46CFFFFF46CFFFFF46CF
      FFFF1234408000000000000000000000000000000000000000003020108BF5DC
      BEFFF5DCBEFFF5DCBEFFF7DFC2FFFCE9D4FFFCE9D4FFFAE6CFFFFAE6CFFFFAE6
      CFFFE9CCAAFFFBE8D2FFFDEBD6FF3021108B3528178BF7F2E6FFF0E7D0FFF0E7
      D0FFF0E7D0FFF0E7D0FFF0E6CEFFE0C6A5FFFCE9D4FFFAE6CFFFFAE6CFFFFAE6
      CFFFE9CCAAFFFBE8D2FFFDEBD6FF3021108B0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000B493
      36DFEBC047FFEBC047FFEBC047FF191B126046CFFFFF46CFFFFF46CFFFFF46CF
      FFFF1234408000000000000000000000000000000000000000003020108BF5DC
      BEFFF5DCBEFFF5DCBEFFF7DFC2FFFDEBD6FFFDEBD6FFFAE6CFFFFAE6CFFFFAE6
      CFFFE9CCAAFFFBE8D2FFFDEBD6FF3021108B3528178BF5EEDEFFECE0C2FFECE0
      C2FFECE0C2FFECE0C2FFEBDFBFFFE0C6A7FFFDEBD6FFFAE6CFFFFAE6CFFFFAE6
      CFFFE9CCAAFFFBE8D2FFFDEBD6FF3021108B0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000004639
      158B5B4A1B9F5B4A1B9F5B4A1B9F090A073C1B50629F1B50629F1B50629F1B50
      629F0614195000000000000000000000000000000000000000003020108BF5DC
      BEFFF5DCBEFFF5DCBEFFF7DFC2FFFCE9D4FFFCE9D4FFFCE9D4FFFAE6CEFFFAE6
      CEFFE9CCA9FFFBE8D1FFFDEAD5FF3021108B34271789F9F5EBFFF3ECD8FFF3EC
      D9FFF3ECD9FFF3ECD9FFF3ECD8FFD4AB74FFD4A76DFFFCE9D4FFFAE6CEFFFAE6
      CEFFE9CCA9FFFBE8D1FFFDEAD5FF3021108B0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000001F2E
      6CA7293D8EBF293D8EBF293D8EBF060B1148367858BF367858BF367858BF3678
      58BF0D1E166000000000000000000000000000000000000000003020108BF5DC
      BEFFF5DCBEFFF5DCBEFFF7DFC2FFFAE4CCFFFAE4CCFFFAE4CCFFFAE4CCFFF7E1
      C7FFE7C8A5FFF8E2C9FFFBE8D1FF3021108B0A08053D4937209C795931CED9B3
      84FFD7B07EFFD7B07EFFC5965AFFEBBE7AFFE7B56AFFD1A469FFFAE4CCFFF7E1
      C7FFE7C8A5FFF8E2C9FFFBE8D1FF3021108B0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000003951
      C1DF4A6CFEFF4A6CFEFF4A6CFEFF0B141F6060D69FFF60D69FFF60D69FFF60D6
      9FFF1835288000000000000000000000000000000000000000003020108BF5DC
      BEFFF5DCBEFFF5DCBEFFF7DFC2FFF7DFC2FFF7DFC2FFF9E2C6FFF9E2C6FFF9E2
      C6FFD6AF80FFF6DDC0FFFAE5CCFF3021108B00000000000000003020108BFAE6
      CDFFF5DCBEFFF5DCBEFFF7DFC2FFD2A871FFE1B26CFFDEAC5FFFCFA165FFF9E2
      C6FFD6AF80FFF6DDC0FFFAE5CCFF3021108B0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000003951
      C1DF4A6CFEFF4A6CFEFF4A6CFEFF0B141F6060D69FFF60D69FFF60D69FFF60D6
      9FFF1835288000000000000000000000000000000000000000003021108BF1D6
      B3FFF1D6B3FFF1D6B3FFF1D6B3FFF3D9B7FFF3D9B7FFF3D9B7FFF9E2C6FFF9E2
      C6FFC69451FFF3D9B8FFF8E3C7FF3021108B00000000000000003021108BF8E3
      C7FFF1D6B3FFF1D6B3FFF1D6B3FFF3D9B7FFD0A56EFFD9A962FFD6A254FFC38E
      46FFC69451FFF3D9B8FFF8E3C7FF3021108B0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000A0F
      23601925579625367EB43249ADD30A111A5960D69FFF60D69FFF60D69FFF60D6
      9FFF1735277F00000000000000000000000000000000000000003021108BEDD0
      AAFFEDD0AAFFEDD0AAFFEDD0AAFFEDD0AAFFEFD3AEFFEFD3AEFFEFD3AEFFF9E2
      C6FFCA9E63FFEFD3AEFFF6DFC3FF3021108B00000000000000003021108BF6DF
      C3FFEDD0AAFFEDD0AAFFEDD0AAFFEDD0AAFFEFD3AEFFCEA36BFFD2A35DFFCC96
      48FFCA9E63FFEFD3AEFFF6DFC3FF3021108B0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000E0205042A07100C470E20
      17630206042B00000000000000000000000000000000000000003021108BEBCC
      A1FFEBCCA1FFEBCCA1FFEBCCA1FFEBCCA1FFECCDA3FFECCDA3FFECCDA3FFECCD
      A3FFCEA875FFECCDA3FFF4DDBEFF3021108B00000000000000003021108BF4DD
      BEFFEBCCA1FFEBCCA1FFEBCCA1FFEBCCA1FFECCDA3FFD0A875FFDFC195FFD7B1
      7AFFCEA875FFECCDA3FFF4DDBEFF3021108B0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000003021108BDBB4
      80FFDBB480FFDBB480FFDBB480FFDBB480FFDBB481FFCFA269FFCFA268FFCFA2
      68FFD3A971FFE7C698FFF2DAB9FF3021108B00000000000000003021108BF3DB
      BAFFDBB480FFDBB480FFDBB480FFDBB480FFDBB481FFCFA269FFCFA268FFCFA2
      68FFD3A971FFE7C698FFF2DAB9FF3021108B0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000002F20108AE3BE
      8BFFE3BE8BFFE3BE8BFFE3BE8BFFE3BE8BFFE3BE8BFFE3BE8BFFE3BE8BFFE3BE
      8BFFE3BE8BFFE3BE8BFFF0D7B4FF2F20108A00000000000000002F20108AF0D7
      B4FFE3BE8BFFE3BE8BFFE3BE8BFFE3BE8BFFE3BE8BFFE3BE8BFFE3BE8BFFE3BE
      8BFFE3BE8BFFE3BE8BFFF0D7B4FF2F20108A0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000021170C70D9B7
      91FFD9B690FFD9B690FFD9B690FFD9B690FFD9B690FFD9B690FFD9B690FFD9B6
      90FFD9B690FFD9B690FFD9B791FF21170C70000000000000000021170C70D9B7
      91FFD9B690FFD9B690FFD9B690FFD9B690FFD9B690FFD9B690FFD9B690FFD9B6
      90FFD9B690FFD9B690FFD9B791FF21170C700000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000100000000100010000000000800000000000000000000000
      000000000000000000000000FFFFFF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000}
  end
end
