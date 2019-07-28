unit UnitEvemini;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, UnitWindow, UnitString, ShellApi,
  Vcl.Menus, IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient, IdHTTP,
  IdIOHandler, IdIOHandlerSocket, IdIOHandlerStack, IdSSL, IdSSLOpenSSL;

const
  WM_ICONTRAY = WM_USER + 1;


type
  TFormEvemini = class(TForm)
    TimerCheckForms: TTimer;
    popupMenu: TPopupMenu;
    New1: TMenuItem;
    Quit1: TMenuItem;
    menuWindows: TMenuItem;
    menuDefault: TMenuItem;
    menuCheckforUpdate: TMenuItem;
    IdHTTP: TIdHTTP;
    IdSSLIOHandlerSocketOpenSSL: TIdSSLIOHandlerSocketOpenSSL;
    procedure TimerCheckFormsTimer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Quit1Click(Sender: TObject);
    procedure New1Click(Sender: TObject);
    procedure popupMenuPopup(Sender: TObject);
    procedure menuDefaultClick(Sender: TObject);
    procedure menuCheckforUpdateClick(Sender: TObject);
  private
    { Private declarations }
    TrayIconData: TNotifyIconData;

    procedure WMCopyData(var Msg: TWMCopyData); message WM_COPYDATA;
  public
    { Public declarations }
    procedure TrayMessage(var Msg: TMessage); message WM_ICONTRAY;
  end;

var
  FormEvemini: TFormEvemini;

implementation

{$R *.dfm}

procedure TFormEvemini.WMCopyData(var Msg: TWMCopyData);
var
  getParams: string;
  params: array of string;
begin
  getParams := PChar(Msg.CopyDataStruct.lpData);

  SetLength(params, 30);
  explode(params, ';', getParams);

  SetLength(FormWindow, Length(FormWindow) + 1);
  Application.CreateForm(TFormWindow, FormWindow[Length(FormWindow) - 1]);
  FormWindow[Length(FormWindow) - 1].initialize(Length(FormWindow) - 1, params, 0);

  params := nil;
end;

procedure TFormEvemini.FormCreate(Sender: TObject);
begin
  with TrayIconData do
    begin
      cbSize :=  TNotifyIconData.SizeOf; // SizeOf(TrayIconData);
      Wnd := Handle;
      uID := 0;
      uFlags := NIF_MESSAGE + NIF_ICON + NIF_TIP;
      uCallbackMessage := WM_ICONTRAY;
      hIcon := Application.Icon.Handle;
      StrPCopy(szTip, Application.Title);
    end;

  Shell_NotifyIcon(NIM_ADD, @TrayIconData);
end;

procedure TFormEvemini.FormDestroy(Sender: TObject);
begin
  Shell_NotifyIcon(NIM_DELETE, @TrayIconData);
end;

procedure TFormEvemini.menuCheckforUpdateClick(Sender: TObject);
var
  releaseJson: string;
begin
  releaseJson := IdHTTP.Get('https://api.github.com/repos/truekenny/evemini/releases/latest');

  if releaseJson = '' then Exit;
end;

procedure TFormEvemini.menuDefaultClick(Sender: TObject);
var
  index: Integer;
begin
  index := (Sender as TMenuItem).Tag;
  FormWindow[index].menuAlwaysVisible.Checked := True;
end;

procedure TFormEvemini.New1Click(Sender: TObject);
var
  params: array of string;
begin
  SetLength(params, 0);

  SetLength(FormWindow, Length(FormWindow) + 1);
  Application.CreateForm(TFormWindow, FormWindow[Length(FormWindow) - 1]);
  FormWindow[Length(FormWindow) - 1].initialize(Length(FormWindow) - 1, params, 0);

  params := nil;
end;

procedure TFormEvemini.popupMenuPopup(Sender: TObject);
var
  index: Integer;
  menuItem : TMenuItem;
begin
  menuWindows.Clear;

  for index := 0 to Length(FormWindow) - 1 do begin
    if FormWindow[index] = nil then Continue;

    menuItem := TMenuItem.Create(menuWindows);
    menuItem.Caption := FormWindow[index]._windowName;
    menuItem.Tag := index;

    if menuItem.Caption = '' then menuItem.Caption := '# new window';
    menuItem.Caption := menuItem.Caption + ' #' + IntToStr(index);

    menuItem.OnClick :=  menuDefaultClick;
    menuWindows.Add(menuItem);
  end;
end;

procedure TFormEvemini.Quit1Click(Sender: TObject);
begin
  Close();
end;

procedure TFormEvemini.TimerCheckFormsTimer(Sender: TObject);
var
  index: Integer;
begin
  for index := 0 to Length(FormWindow) - 1 do begin
    if FormWindow[index] <> nil then Exit;
  end;

  Close();
end;

procedure TFormEvemini.TrayMessage(var Msg: TMessage);
begin
  case Msg.lParam of
    WM_LBUTTONDOWN:
    begin
      //
    end;
    WM_RBUTTONDOWN:
    begin
      SetForegroundWindow(Handle);
      popupMenu.Popup(Mouse.CursorPos.X, Mouse.CursorPos.Y);
      SetForegroundWindow(popupMenu.Handle);
    end;
  end;
end;


end.
