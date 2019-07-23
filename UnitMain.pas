unit UnitMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, DwmApi;

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
    procedure registerThumbnail();
    procedure borderThumbnail(withBorder: Boolean);

  public
    { Public declarations }
  end;

var
  FormMain: TFormMain;
  capsuleerName: string;
  gameX: Integer = 0;
  gameY: Integer = 0;
  gameWidth: Integer = 0;
  gameHeight: Integer = 0;
  gameHandle: Cardinal = 0;
  PH: HTHUMBNAIL;

implementation

{$R *.dfm}

function TFormMain.getHandle(): Cardinal;
begin
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
  _handle, _handleForeground: Cardinal;
begin
  _handle := getHandle();

  if _handle = 0 then begin

    gameHandle := 0;
    Visible := false;
    Exit;
  end
  else
    Visible := true;


  if (gameHandle = 0) and (_handle <> 0) then begin
    gameHandle := _handle;

    registerThumbnail;
  end;

  if _handle <> 0 then begin
    _handleForeground := GetForegroundWindow;

    borderThumbnail(_handle = _handleForeground);
  end;
end;

procedure TFormMain.registerThumbnail();
var
  Props: DWM_THUMBNAIL_PROPERTIES;
  ProgmanHandle: THandle;
begin
  ProgmanHandle := gameHandle;
  if ProgmanHandle>0 then
    begin
      if Succeeded(DwmRegisterThumbnail(Handle,ProgmanHandle,@PH))then
         begin
           Props.dwFlags:=DWM_TNP_SOURCECLIENTAREAONLY or DWM_TNP_VISIBLE or
                          DWM_TNP_OPACITY;

           Props.fSourceClientAreaOnly := true;
           Props.fVisible := true;
           Props.opacity := 255;

           if Succeeded(DwmUpdateThumbnailProperties(PH,Props))then begin
             Color := clLime;
           end else begin
              ShowMessage('DwmUpdateThumbnailProperties fail');
           end;
         end
      else
        begin
           ShowMessage('DwmRegisterThumbnail fail');
        end;
    end;
end;

procedure TFormMain.borderThumbnail(withBorder: Boolean);
var
  Props: DWM_THUMBNAIL_PROPERTIES;
  borderWidth: Integer;
begin
   Props.dwFlags := DWM_TNP_RECTDESTINATION or DWM_TNP_RECTSOURCE;

  if withBorder then borderWidth := 3 else borderWidth := 0;

   Props.rcDestination := Rect(borderWidth, borderWidth, Width - borderWidth, Height-borderWidth);
   Props.rcSource := Rect(
    Point(gameX + borderWidth ,gameY + borderWidth),
    Point(gameX + gameWidth - borderWidth, gameY + gameHeight - borderWidth)
    );
   if not Succeeded(DwmUpdateThumbnailProperties(PH,Props))then begin
      ShowMessage('DwmUpdateThumbnailProperties (border) fail');
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

    if key = '--name' then capsuleerName := value
    else if key = '--form-x' then Left := StrToInt(value)
    else if key = '--form-y' then Top := StrToInt(value)
    else if key = '--form-width' then Width := StrToInt(value)
    else if key = '--form-height' then Height := StrToInt(value)
    else if key = '--game-x' then gameX := StrToInt(value)
    else if key = '--game-y' then gameY := StrToInt(value)
    else if key = '--game-width' then gameWidth := StrToInt(value)
    else if key = '--game-height' then gameHeight := StrToInt(value)
    else if key = '--timer' then Timer.Interval := StrToInt(value);
  end;

  if gameWidth = 0 then gameWidth := Width;
  if gameHeight = 0 then gameHeight := Height;

  //capsuleerName := '123';
end;

procedure TFormMain.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then begin
    SetForegroundWindow(getHandle);
  end
  else if Button = mbMiddle then Close();
end;

end.
