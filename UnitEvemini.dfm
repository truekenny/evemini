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
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object TimerCheckForms: TTimer
    Interval = 100
    OnTimer = TimerCheckFormsTimer
    Left = 8
    Top = 128
  end
  object popupMenu: TPopupMenu
    Images = FormWindow.imageList
    OnPopup = popupMenuPopup
    Left = 48
    Top = 128
    object menuWindows: TMenuItem
      Caption = 'Windows'
      object menuDefault: TMenuItem
        Caption = 'default'
        Visible = False
        OnClick = menuDefaultClick
      end
    end
    object New1: TMenuItem
      Caption = 'New...'
      ImageIndex = 4
      OnClick = New1Click
    end
    object menuCheckforUpdate: TMenuItem
      Caption = 'Check for Update'
      OnClick = menuCheckforUpdateClick
    end
    object Quit1: TMenuItem
      Caption = 'Quit'
      OnClick = Quit1Click
    end
  end
  object IdHTTP: TIdHTTP
    IOHandler = IdSSLIOHandlerSocketOpenSSL
    AllowCookies = True
    ProxyParams.BasicAuthentication = False
    ProxyParams.ProxyPort = 0
    Request.ContentLength = -1
    Request.ContentRangeEnd = -1
    Request.ContentRangeStart = -1
    Request.ContentRangeInstanceLength = -1
    Request.Accept = 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8'
    Request.BasicAuthentication = False
    Request.UserAgent = 
      'Mozilla/5.0 (Windows NT 6.1; WOW64; rv:12.0) Gecko/20100101 Fire' +
      'fox/12.0'
    Request.Ranges.Units = 'bytes'
    Request.Ranges = <>
    HTTPOptions = [hoForceEncodeParams]
    Left = 88
    Top = 128
  end
  object IdSSLIOHandlerSocketOpenSSL: TIdSSLIOHandlerSocketOpenSSL
    MaxLineAction = maException
    Port = 0
    DefaultPort = 0
    SSLOptions.Method = sslvTLSv1_2
    SSLOptions.SSLVersions = [sslvTLSv1_2]
    SSLOptions.Mode = sslmUnassigned
    SSLOptions.VerifyMode = []
    SSLOptions.VerifyDepth = 0
    Left = 128
    Top = 128
  end
end
