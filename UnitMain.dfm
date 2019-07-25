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
      OnClick = menuSelectGameAreaClick
    end
    object menuResizeWindow1x1: TMenuItem
      Caption = 'Resize Window 1x1'
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
  end
end
