unit UnitMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TFormMain = class(TForm)
    Timer: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure TimerTimer(Sender: TObject);
  private
    { Private declarations }
    procedure explode(var a: array of string; Border, S: string);
    function getHandle(): Cardinal;
    procedure fresh();
  public
    { Public declarations }
  end;

var
  FormMain: TFormMain;
  capsuleerName: string;
  gameX, gameY: Integer;


implementation

{$R *.dfm}

function TFormMain.getHandle(): Cardinal;
begin
//  Result := FindWindow('triuiScreen', PChar('EVE - ' + capsuleerName));
  Result := FindWindow(nil, PChar('EVE - ' + capsuleerName));
end;

procedure TFormMain.TimerTimer(Sender: TObject);
begin
  fresh;
end;

procedure TFormMain.explode(var a: array of string; Border, S: string);
var
  S2: string;
  i: Integer;
begin
  i  := 0;
  S2 := S + Border;
  repeat
    a[i] := Copy(S2, 0,Pos(Border, S2) - 1);
    Delete(S2, 1,Length(a[i] + Border));
    Inc(i);
  until S2 = '';
end;

procedure TFormMain.fresh;
var
  Desktop: HDC;
  _handle: Cardinal;
begin
  _handle := getHandle();

  Desktop := GetWindowDC(_handle);

  try
    BitBlt(FormMain.Canvas.Handle, 0, 0, FormMain.Width, FormMain.Height, Desktop, gameX, gameY, SRCCOPY);
  finally
    ReleaseDC(0, Desktop);
  end;
end;

procedure TFormMain.FormCreate(Sender: TObject);
var
  index: Integer;
  param, key, value: string;
  pair: array of string;
begin
  SetLength(pair, 2);

  for index := 1 to ParamCount do begin
    param := ParamStr(index);
    explode(pair, '=', param);

    key := pair[0];
    value := pair[1];

    // --name="Lass Suicide" --form-x=200 --form-y=100 --form-width=400 --form-height=200 --game-x=300 --game-y=400

    if key = '--name' then capsuleerName := value
    else if key = '--form-x' then FormMain.Left := StrToInt(value)
    else if key = '--form-y' then FormMain.Top := StrToInt(value)
    else if key = '--form-width' then FormMain.Width := StrToInt(value)
    else if key = '--form-height' then FormMain.Height := StrToInt(value)
    else if key = '--game-x' then gameX := StrToInt(value)
    else if key = '--game-y' then gameY := StrToInt(value);
  end;

  // capsuleerName := '123';
end;

procedure TFormMain.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then SetForegroundWindow(getHandle)
  else if Button = mbMiddle then Close();
end;

end.
