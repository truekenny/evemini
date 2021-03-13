unit UnitEvemini;

interface

uses
  IdBaseComponent,
  IdComponent,
  IdHTTP,
  IdIOHandler,
  IdIOHandlerSocket,
  IdIOHandlerStack,
  IdSSL,
  IdSSLOpenSSL,
  IdTCPClient,
  IdTCPConnection,
  System.Classes,
  System.JSON,
  System.SysUtils,
  UnitString,
  UnitWindow,
  Vcl.Controls,
  Vcl.Dialogs,
  Vcl.ExtCtrls,
  Vcl.Forms,
  Vcl.Menus,
  Winapi.Messages,
  Winapi.ShellAPI,
  Winapi.Windows,
  UnitGetBuild;

const
  WM_ICONTRAY = WM_USER + 1;
  CURRENT_RELEASE = 'Release #7';

type
  TFormEvemini = class(TForm)
    TimerCheckForms: TTimer;
    popupMenu: TPopupMenu;
    New1: TMenuItem;
    menuQuit: TMenuItem;
    menuWindows: TMenuItem;
    menuDefault: TMenuItem;
    menuCheckforUpdate: TMenuItem;
    IdHTTP: TIdHTTP;
    IdSSLIOHandlerSocketOpenSSL: TIdSSLIOHandlerSocketOpenSSL;
    TrayIcon: TTrayIcon;
    menuSeparatorQuit: TMenuItem;
    menuSeparatorVersion: TMenuItem;
    menuVersion: TMenuItem;
    menuRefreshAlwaysOnTop: TMenuItem;
    procedure TimerCheckFormsTimer(Sender: TObject);
    procedure menuQuitClick(Sender: TObject);
    procedure New1Click(Sender: TObject);
    procedure popupMenuPopup(Sender: TObject);
    procedure menuDefaultClick(Sender: TObject);
    procedure menuCheckforUpdateClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure menuRefreshAlwaysOnTopClick(Sender: TObject);
  private
    { Private declarations }

    procedure WMCopyData(var Msg: TWMCopyData); message WM_COPYDATA;
  public
    { Public declarations }
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
  menuVersion.Caption := 'Version: ' + GetBuildInfoAsString;
end;

procedure TFormEvemini.menuCheckforUpdateClick(Sender: TObject);
var
  releaseJson: string;
  JSON: TJSONObject;

  name: string;
begin
  releaseJson := IdHTTP.Get('https://api.github.com/repos/truekenny/evemini/releases/latest');

  if releaseJson = '' then Exit;

  JSON := TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes(releaseJson),0) as TJSONObject;
  name := JSON.Values['name'].Value;

  if name = CURRENT_RELEASE then begin
    ShowMessage('Application are up to date.');
    Exit;
  end;

  if MessageBox(Handle, PChar('Open releases site page?'),
    PChar('New realese '+ name), MB_YESNO + MB_ICONINFORMATION) = IDYES then
    ShellExecute(0, 'open', 'https://github.com/truekenny/evemini/releases', nil, nil, SW_SHOWNORMAL);
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
    menuItem.Caption := FormWindow[index].windowName;
    menuItem.Tag := index;

    if menuItem.Caption = '' then menuItem.Caption := '# new window';
    menuItem.Caption := menuItem.Caption + ' #' + IntToStr(index);

    menuItem.OnClick :=  menuDefaultClick;
    menuWindows.Add(menuItem);
  end;
end;

procedure TFormEvemini.menuQuitClick(Sender: TObject);
var
  index: Integer;
begin
  for index := 0 to Length(FormWindow) - 1 do begin
    if FormWindow[index] <> nil then FormWindow[index].Close;
  end;

  Close();
end;

procedure TFormEvemini.menuRefreshAlwaysOnTopClick(Sender: TObject);
var
  index: Integer;
begin
  for index := 0 to Length(FormWindow) - 1 do begin
    if FormWindow[index] <> nil then FormWindow[index].FormActivateOrShow(Sender);
  end;
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

end.
