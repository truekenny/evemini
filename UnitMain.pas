unit UnitMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, DwmApi,
  Vcl.Menus, Vcl.PlatformDefaultStyleActnCtrls, Vcl.ActnPopup;

type
  TFormMain = class(TForm)
    Timer: TTimer;
    PopupActionBar: TPopupActionBar;
    menuSelectWindow: TMenuItem;
    menuDefault: TMenuItem;
    N11: TMenuItem;
    N21: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure TimerTimer(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormDblClick(Sender: TObject);
    procedure FormMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure WMNCHitTest(var Message: TWMNCHitTest); message WM_NCHITTEST;
    procedure PopupActionBarPopup(Sender: TObject);
    procedure menuDefaultClick(Sender: TObject);
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

  THoldhWnd = class(TObject)
  private
  public
    hWindow: hWnd;
  end;

var
  FormMain: TFormMain;
  windowName: string;
  gameX: Integer = 0;
  gameY: Integer = 0;
  gameWidth: Integer = 0;
  gameHeight: Integer = 0;
  gameHandle: Cardinal = 0;
  alwaysVisible: Boolean = False;
  PH: HTHUMBNAIL;
  readyToWork: Boolean = False;

implementation

{$R *.dfm}

function TFormMain.getHandle(): Cardinal;
begin
  Result := FindWindow(nil, PChar(windowName));
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
  _handle: Cardinal;
begin
  if not readyToWork then Exit;

  if (gameHandle <> 0) and IsWindow(gameHandle) then begin
    // already active
    borderThumbnail(gameHandle = GetForegroundWindow);

  end else begin
    // not active
    gameHandle := 0;
    _handle := getHandle();

    if _handle = 0 then begin
      // cant activate
      if not alwaysVisible then Visible := false;
      Color := clBtnFace;

    end else begin
      // window found, can activate
      Visible := true;
      gameHandle := _handle;

      registerThumbnail;

    end;
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
              ShowMessage('Properties fail');
           end;
         end
      else
        begin
           ShowMessage('General fail');
        end;
    end;
end;

procedure TFormMain.borderThumbnail(withBorder: Boolean);
var
  Props: DWM_THUMBNAIL_PROPERTIES;
  borderWidth: Integer;
begin
   Props.dwFlags := DWM_TNP_RECTDESTINATION or DWM_TNP_RECTSOURCE;

  if withBorder and (WindowState <> wsMaximized)
  then borderWidth := 3
  else borderWidth := 0;

   Props.rcDestination := Rect(borderWidth, borderWidth, Width - borderWidth, Height-borderWidth);
   Props.rcSource := Rect(
    Point(gameX + borderWidth ,gameY + borderWidth),
    Point(gameX + gameWidth - borderWidth, gameY + gameHeight - borderWidth)
    );
   if not Succeeded(DwmUpdateThumbnailProperties(PH,Props))then begin
      ShowMessage('Properties (border) fail');
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

    // --name="Elle Tan" --form-x=1868 --form-y=882 --form-width=687 --form-height=160 --game-x=10 --game-y=10 --always-visible=true

    if key = '--name' then begin
      windowName := 'EVE - ' + value;
      readyToWork := True;
    end
    else if key = '--form-x' then Left := StrToInt(value)
    else if key = '--form-y' then Top := StrToInt(value)
    else if key = '--form-width' then Width := StrToInt(value)
    else if key = '--form-height' then Height := StrToInt(value)
    else if key = '--game-x' then gameX := StrToInt(value)
    else if key = '--game-y' then gameY := StrToInt(value)
    else if key = '--game-width' then gameWidth := StrToInt(value)
    else if key = '--game-height' then gameHeight := StrToInt(value)
    else if key = '--timer' then Timer.Interval := StrToInt(value)
    else if key = '--always-visible' then alwaysVisible := StrToBool(value);
  end;

  if gameWidth = 0 then gameWidth := Width;
  if gameHeight = 0 then gameHeight := Height;

  // TODO: Delete
  if True then begin
    windowName := 'Calculator';
    readyToWork := true;
  end;

  if windowName = '' then
    Caption := 'Evemini'
  else
    Caption := 'Evemini - ' + windowName;
end;

procedure TFormMain.menuDefaultClick(Sender: TObject);
begin
  //
  ShowMessage(IntToStr((Sender as TMenuItem).Tag));
end;

function EnumWindowsProc(hWindow: HWND): Bool; stdcall;
var
  HoldString: PChar;
  WindowStyle: Longint;
  IsAChild: Word;
  HoldhWnd: THoldhWnd;

  menuItem : TMenuItem;
begin
  GetMem(HoldString, 256);

  HoldhWnd := THoldhWnd.Create;
  HoldhWnd.hWindow := hWindow;

  WindowStyle := GetWindowLong(hWindow, GWL_STYLE);
  WindowStyle := WindowStyle and Longint(WS_VISIBLE);
  IsAChild := GetWindowWord(hWindow, GWL_HWNDPARENT);

  if (GetWindowText(hWindow, HoldString, 255) > 0)
    and (WindowStyle > 0)
    and (IsAChild = Word(nil))
    then begin
        // ShowMessage(StrPas(HoldString) +'='+ IntToStr(hWindow));

        menuItem := TMenuItem.Create(FormMain.menuSelectWindow);
        menuItem.Caption := StrPas(HoldString);
        menuItem.OnClick :=  FormMain.menuDefaultClick;
        menuItem.Tag := hWindow;
        FormMain.menuSelectWindow.Add(menuItem);
    end;

  FreeMem(HoldString, 256);
  HoldhWnd := nil;
  Result := True;
end;

procedure TFormMain.PopupActionBarPopup(Sender: TObject);
var
  index : Integer;

  // TODO: Delete
  menuItem : TMenuItem;
begin
  // ������� ��
  for index := 1 to menuSelectWindow.Count - 1 do begin
    menuSelectWindow.Delete(1);
  end;

  menuItem := TMenuItem.Create(menuSelectWindow);
  menuItem.Caption := '1';
  menuItem.OnClick := menuDefaultClick;
  menuItem.Tag := 1;
  menuSelectWindow.Add(menuItem);

  menuItem := TMenuItem.Create(menuSelectWindow);
  menuItem.Caption := '2';
  menuItem.OnClick := menuDefaultClick;
  menuItem.Tag := 2;
  menuSelectWindow.Add(menuItem);


  EnumWindows(@EnumWindowsProc,0);
end;

procedure TFormMain.FormDblClick(Sender: TObject);
begin
  if WindowState = wsMaximized then begin
    WindowState := wsNormal;
  end else begin
    WindowState := wsMaximized;
  end;
end;

procedure TFormMain.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  // Move form
  if Button = mbLeft then begin
    ReleaseCapture;
    SendMessage(Handle, WM_SYSCOMMAND, 61458, 0) ;
  end;

  if Button = mbLeft then begin
    SetForegroundWindow(getHandle);
  end
  else if Button = mbMiddle then Close();
end;

procedure TFormMain.FormMouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
var
  delta: Integer;
begin
  // - scroll down
  // + scroll up
  delta := Round(WheelDelta / 10);

  Left := Left + delta;
  Top := Top + delta;
  Width:= Width - delta * 2;
  Height := Height - delta * 2;
end;

// Resize bsNone
procedure TFormMain.WMNCHitTest(var Message: TWMNCHitTest);
const
  EDGEDETECT = 7; // adjust
var
  deltaRect: TRect;
begin
  inherited;
  if BorderStyle = bsNone then
    with Message, deltaRect do
    begin
      Left := XPos - BoundsRect.Left;
      Right := BoundsRect.Right - XPos;
      Top := YPos - BoundsRect.Top;
      Bottom := BoundsRect.Bottom - YPos;
      if (Top < EDGEDETECT) and (Left < EDGEDETECT) then
        Result := HTTOPLEFT
      else if (Top < EDGEDETECT) and (Right < EDGEDETECT) then
        Result := HTTOPRIGHT
      else if (Bottom < EDGEDETECT) and (Left < EDGEDETECT) then
        Result := HTBOTTOMLEFT
      else if (Bottom < EDGEDETECT) and (Right < EDGEDETECT) then
        Result := HTBOTTOMRIGHT
      else if (Top < EDGEDETECT) then
        Result := HTTOP
      else if (Left < EDGEDETECT) then
        Result := HTLEFT
      else if (Bottom < EDGEDETECT) then
        Result := HTBOTTOM
      else if (Right < EDGEDETECT) then
        Result := HTRIGHT
    end;
end;

procedure TFormMain.FormActivate(Sender: TObject);
begin
  SetWindowLong(Handle, GWL_EXSTYLE,
                GetWindowLong(Handle, GWL_EXSTYLE) or
                WS_EX_TOOLWINDOW and not WS_EX_APPWINDOW);

  ShowWindow(Application.Handle, SW_HIDE);
end;

procedure TFormMain.FormShow(Sender: TObject);
begin
  SetWindowLong(Handle, GWL_EXSTYLE,
                GetWindowLong(Handle, GWL_EXSTYLE) or
                WS_EX_TOOLWINDOW and not WS_EX_APPWINDOW);

  ShowWindow(Application.Handle, SW_HIDE);
end;

end.
