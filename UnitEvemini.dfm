object FormEvemini: TFormEvemini
  Left = 0
  Top = 0
  Caption = 'FormEvemini'
  ClientHeight = 187
  ClientWidth = 276
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object TimerCheckForms: TTimer
    Interval = 100
    OnTimer = TimerCheckFormsTimer
    Left = 16
    Top = 16
  end
end