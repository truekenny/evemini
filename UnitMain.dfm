object FormMain: TFormMain
  Left = 0
  Top = 0
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
  Position = poDesktopCenter
  OnActivate = FormActivate
  OnCreate = FormCreate
  OnDblClick = FormDblClick
  OnMouseDown = FormMouseDown
  OnMouseWheel = FormMouseWheel
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Timer: TTimer
    Interval = 50
    OnTimer = TimerTimer
    Left = 8
    Top = 8
  end
  object PopupActionBar: TPopupActionBar
    OnPopup = PopupActionBarPopup
    Left = 88
    Top = 24
    object menuSelectWindow: TMenuItem
      Caption = 'Select Window'
      object menuDefault: TMenuItem
        Caption = 'None'
        Enabled = False
        OnClick = menuDefaultClick
      end
      object N11: TMenuItem
        Caption = '1'
      end
      object N21: TMenuItem
        Caption = '2'
      end
    end
  end
end
