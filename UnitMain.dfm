object FormMain: TFormMain
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = 'FormMain'
  ClientHeight = 450
  ClientWidth = 868
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  OnCreate = FormCreate
  OnMouseDown = FormMouseDown
  PixelsPerInch = 96
  TextHeight = 13
  object Timer: TTimer
    Interval = 150
    OnTimer = TimerTimer
    Left = 8
    Top = 8
  end
  object XPManifest: TXPManifest
    Left = 48
    Top = 8
  end
end
