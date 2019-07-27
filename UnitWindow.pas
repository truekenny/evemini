unit UnitWindow;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, DwmApi,
  Vcl.Menus, Vcl.PlatformDefaultStyleActnCtrls, Vcl.ActnPopup, System.ImageList,
  Vcl.ImgList, IniFiles, RegularExpressions, ShellApi, UnitProcessLibrary,
  Math, UnitGetBuild, UnitInlineMacros;

type
  TFormWindow = class(TForm)
    Timer: TTimer;
    PopupActionBar: TPopupActionBar;
    menuSelectTarget: TMenuItem;
    menuDefault: TMenuItem;
    N11: TMenuItem;
    N21: TMenuItem;
    menuAlwaysVisible: TMenuItem;
    menuSeparatorChecks: TMenuItem;
    menuQuit: TMenuItem;
    menuSelectTargetRegion: TMenuItem;
    menuSeparatorQuit: TMenuItem;
    menuWindowMovable: TMenuItem;
    menuWindowSizable: TMenuItem;
    menuResizeWindow1x1: TMenuItem;
    menuWindowHalfOpacity: TMenuItem;
    imageList: TImageList;
    menuWindowProportion: TMenuItem;
    menuAllTargetSpace: TMenuItem;
    menuInvertWheel: TMenuItem;
    labelBuild: TLabel;
    labelHelp: TLabel;
    menuNew: TMenuItem;
    menuSeparatorNew: TMenuItem;
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
    procedure menuQuitClick(Sender: TObject);
    procedure menuSelectTargetRegionClick(Sender: TObject);
    procedure menuResizeWindow1x1Click(Sender: TObject);
    procedure menuWindowHalfOpacityClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure WMSizing(var Message: TMessage); message WM_SIZING;
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure menuAllTargetSpaceClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure menuNewClick(Sender: TObject);
  private
    { Private declarations }
    windowIndex: Integer;

    windowName: string;
    gameX: Integer;
    gameY: Integer;
    gameWidth: Integer;
    gameHeight: Integer;
    gameHandle: Cardinal;
    config: string;

    PH: HTHUMBNAIL;

    mouseDown: TPoint;

    procedure explode(var a: array of string; Border, S: string);
    function getHandle(): Cardinal;
    procedure fresh();
    procedure registerThumbnail();
    procedure borderThumbnail(withBorder: Boolean);
    procedure generateConfigFilename();
    function isWritable(filename: string): Boolean;
    procedure saveProportion();
  public
    { Public declarations }
    procedure initialize(_windowIndex: Integer; params: array of string);
end;

var
  FormWindow: array of TFormWindow;

implementation

{$R *.dfm}

procedure TFormWindow.saveProportion();
begin
  if not menuWindowProportion.Checked then Exit;

  Width := Round(Height * gameWidth / gameHeight);
  borderThumbnail(gameHandle = GetForegroundWindow);
end;

// Save proportion on resize form
procedure TFormWindow.WMSizing(var Message: TMessage);
var
  aspectRatio: double;
begin
  if not menuWindowProportion.Checked then Exit;

  aspectRatio := gameWidth / gameHeight;

  case Message.wParam of
    WMSZ_LEFT, WMSZ_RIGHT, WMSZ_BOTTOMLEFT:
      with PRect(Message.LParam)^ do
        Bottom := Top + Round((Right-Left)/aspectRatio);
    WMSZ_TOP, WMSZ_BOTTOM, WMSZ_TOPRIGHT, WMSZ_BOTTOMRIGHT:
      with PRect(Message.LParam)^ do
        Right := Left + Round((Bottom-Top)*aspectRatio);
    WMSZ_TOPLEFT:
      with PRect(Message.LParam)^ do
        Top := Bottom - Round((Right-Left)/aspectRatio);
  end;
  inherited;

  borderThumbnail(gameHandle = GetForegroundWindow);
end;

function TFormWindow.isWritable(filename: string): Boolean;
var
  H: THandle;
begin
  H := CreateFile(PChar(filename), GENERIC_READ or GENERIC_WRITE, 0, nil,
    OPEN_ALWAYS, FILE_ATTRIBUTE_NORMAL, 0);
  Result := H <> INVALID_HANDLE_VALUE;
  if Result then CloseHandle(H);
end;

procedure TFormWindow.generateConfigFilename();
var
  RegEx: TRegEx;
begin
  config := windowName;
  // config := '123-123 - /?\:Test - Òåñò-ßÿ¨¸Éé';
  RegEx.Create('[^0-9a-zA-Zà-ÿÀ-ß\-\ ¸¨]');
  config := RegEx.Replace(config, '');
  config := Trim(config);

  if config = '' then Exit;

  config := ExtractFilePath(ParamStr(0)) + config + '.ini';
end;

function TFormWindow.getHandle(): Cardinal;
begin
  Result := FindWindow(nil, PChar(windowName));
end;

procedure TFormWindow.TimerTimer(Sender: TObject);
begin
  fresh;
end;

procedure TFormWindow.explode(var a: array of string; Border, S: string);
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

procedure TFormWindow.fresh;
var
  _handle: Cardinal;
begin
  if not Timer.Enabled then Exit;

  if (gameHandle <> 0) and IsWindow(gameHandle) then begin
    // already active
    borderThumbnail(gameHandle = GetForegroundWindow);

  end else begin
    // not active
    gameHandle := 0;
    _handle := getHandle();

    if _handle = 0 then begin
      // cant activate
      if not menuAlwaysVisible.Checked then Visible := false;
      Color := clBtnFace;

    end else begin
      // window found, can activate
      Visible := true;
      gameHandle := _handle;

      registerThumbnail;

    end;
  end;
end;

procedure TFormWindow.registerThumbnail();
var
  Props: DWM_THUMBNAIL_PROPERTIES;
  ProgmanHandle: THandle;
begin
  ProgmanHandle := gameHandle;
  if ProgmanHandle>0 then
    begin
      if Succeeded(DwmRegisterThumbnail(Handle,ProgmanHandle,@PH))then
         begin
           Props.dwFlags := DWM_TNP_SOURCECLIENTAREAONLY or DWM_TNP_VISIBLE or
                            DWM_TNP_OPACITY;

           Props.fSourceClientAreaOnly := false;
           Props.fVisible := true;
           Props.opacity := 255;

           if Succeeded(DwmUpdateThumbnailProperties(PH,Props))then begin
             Color := clLime;
           end else begin
              Timer.Enabled := False;
              ShowMessage('Properties fail');
              Close;
           end;
         end
      else
        begin
          Timer.Enabled := False;
          ShowMessage('General fail');
          Close;
        end;
    end;
end;

procedure TFormWindow.borderThumbnail(withBorder: Boolean);
var
  Props: DWM_THUMBNAIL_PROPERTIES;
  borderWidth: Integer;
  gameBorderWidth: Integer;
  gameBorderHeight: Integer;
begin
  if gameHandle = 0 then Exit;

  Props.dwFlags := DWM_TNP_RECTDESTINATION or DWM_TNP_RECTSOURCE;

  if withBorder and (WindowState <> wsMaximized)
  then borderWidth := 3
  else borderWidth := 0;

  gameBorderWidth := Round(borderWidth * gameWidth / Width);
  gameBorderHeight := Round(borderWidth * gameHeight / Height);

  Props.rcDestination := Rect(borderWidth, borderWidth, Width - borderWidth, Height-borderWidth);
  Props.rcSource := Rect(
    Point(gameX + gameBorderWidth ,gameY + gameBorderHeight),
    Point(gameX + gameWidth - gameBorderWidth, gameY + gameHeight - gameBorderHeight)
  );

  if not Succeeded(DwmUpdateThumbnailProperties(PH,Props))then begin
    Timer.Enabled := False;
    ShowMessage('Properties (border) fail');
    Close;
  end;
end;

procedure TFormWindow.FormClose(Sender: TObject; var Action: TCloseAction);
var
  ini: TIniFile;
begin
  Timer.Enabled := False;
  FormWindow[windowIndex] := nil;

  if config = '' then Exit;

  if not isWritable(config) then Exit;

  ini := TIniFile.Create(config);
  try
    ini.WriteString('game', 'name', windowName);
    ini.WriteInteger('game', 'left', gameX);
    ini.WriteInteger('game', 'top', gameY);
    ini.WriteInteger('game', 'width', gameWidth);
    ini.WriteInteger('game', 'height', gameHeight);

    ini.WriteInteger('form', 'left', Left);
    ini.WriteInteger('form', 'top', Top);
    ini.WriteInteger('form', 'width', Width);
    ini.WriteInteger('form', 'height', Height);

    ini.WriteBool('check', 'window-movable', menuWindowMovable.Checked);
    ini.WriteBool('check', 'window-sizable', menuWindowSizable.Checked);
    ini.WriteBool('check', 'always-visible', menuAlwaysVisible.Checked);
    ini.WriteBool('check', 'window-proportion', menuWindowProportion.Checked);
    ini.WriteBool('check', 'invert-wheel', menuInvertWheel.Checked);
  finally
    ini.Free;
  end;

end;

procedure TFormWindow.initialize(_windowIndex: Integer; params: array of string);
var
  index: Integer;
  param, key, value: string;
  pair: array of string;

  ini: TIniFile;
begin
  Visible := true;
  windowIndex := _windowIndex;

  FormResize(nil);
  labelBuild.Caption := GetBuildInfoAsString;

  SetLength(pair, 2);

  for index := 0 to Length(params) - 1 do begin
    param := params[index];

    if FileExists(param) then begin
      config := param;

      ini := TIniFile.Create(param);
      try
        windowName := ini.ReadString('game', 'name', windowName);
        Timer.Enabled := True;

        gameX := ini.ReadInteger('game', 'left', gameX);
        gameY := ini.ReadInteger('game', 'top', gameY);
        gameWidth := ini.ReadInteger('game', 'width', gameWidth);
        gameHeight := ini.ReadInteger('game', 'height', gameHeight);

        Left := ini.ReadInteger('form', 'left', Left);
        Top := ini.ReadInteger('form', 'top', Top);
        Width := ini.ReadInteger('form', 'width', Width);
        Height := ini.ReadInteger('form', 'height', Height);

        menuWindowMovable.Checked := ini.ReadBool('check', 'window-movable', menuWindowMovable.Checked);
        menuWindowSizable.Checked := ini.ReadBool('check', 'window-sizable', menuWindowSizable.Checked);
        menuAlwaysVisible.Checked := ini.ReadBool('check', 'always-visible', menuAlwaysVisible.Checked);
        menuWindowProportion.Checked := ini.ReadBool('check', 'window-proportion', menuWindowProportion.Checked);
        menuInvertWheel.Checked := ini.ReadBool('check', 'invert-wheel', menuInvertWheel.Checked);
      finally
        ini.Free;
      end;

      continue;
    end;


    explode(pair, '=', param);

    key := pair[0];
    value := pair[1];


    // --name="Elle Tan" --form-x=1868 --form-y=882 --form-width=687 --form-height=160 --game-x=10 --game-y=10 --always-visible=true

    if key = '--capsuleer-name' then begin
      windowName := 'EVE - ' + value;
      Timer.Enabled := True;
      generateConfigFilename;
    end
    else if key = '--window-name' then begin
      windowName := value;
      Timer.Enabled := True;
      generateConfigFilename;
    end
    else if key = '--form-left' then Left := StrToInt(value)
    else if key = '--form-top' then Top := StrToInt(value)
    else if key = '--form-width' then Width := StrToInt(value)
    else if key = '--form-height' then Height := StrToInt(value)

    else if key = '--game-left' then gameX := StrToInt(value)
    else if key = '--game-top' then gameY := StrToInt(value)
    else if key = '--game-width' then gameWidth := StrToInt(value)
    else if key = '--game-height' then gameHeight := StrToInt(value)

    else if key = '--timer' then Timer.Interval := StrToInt(value)

    else if key = '--window-movable' then menuWindowMovable.Checked := StrToBool(value)
    else if key = '--window-sizable' then menuWindowSizable.Checked := StrToBool(value)
    else if key = '--window-proportion' then menuWindowProportion.Checked := StrToBool(value)
    else if key = '--invert-wheel' then menuInvertWheel.Checked := StrToBool(value)
    else if key = '--always-visible' then menuAlwaysVisible.Checked := StrToBool(value);
  end;

  if gameWidth = 0 then gameWidth := Width;
  if gameHeight = 0 then gameHeight := Height;

  if windowName = '' then
    Caption := 'Evemini'
  else
    Caption := 'Evemini - ' + windowName;
end;

procedure TFormWindow.menuResizeWindow1x1Click(Sender: TObject);
begin
  Width := gameWidth;
  Height := gameHeight;
end;

procedure TFormWindow.menuAllTargetSpaceClick(Sender: TObject);
var
  rect: TRect;
begin
  GetWindowRect(gameHandle, rect);
  gameX := 0;
  gameY := 0;
  gameWidth := rect.Width;
  gameHeight := rect.Height;

  saveProportion();
end;

procedure TFormWindow.menuDefaultClick(Sender: TObject);
var
  rect: TRect;
begin
  DwmUnregisterThumbnail(PH);
  gameHandle := (Sender as TMenuItem).Tag;
  windowName := (Sender as TMenuItem).Caption;
  Caption := 'Evemini - ' + windowName;
  Timer.Enabled := true;

  GetWindowRect(gameHandle, rect);
  gameX := 0;
  gameY := 0;
  gameWidth := rect.Width;
  gameHeight := rect.Height;

  generateConfigFilename;
  registerThumbnail;

  saveProportion();
end;

procedure TFormWindow.menuNewClick(Sender: TObject);
var
  params: array of string;
begin
  SetLength(params, 0);

  SetLength(FormWindow, Length(FormWindow) + 1);
  Application.CreateForm(TFormWindow, FormWindow[Length(FormWindow) - 1]);
  FormWindow[Length(FormWindow) - 1].initialize(Length(FormWindow) - 1, params);

  params := nil;
end;

procedure TFormWindow.menuQuitClick(Sender: TObject);
begin
  Close();
end;

procedure TFormWindow.menuSelectTargetRegionClick(Sender: TObject);
var
  rect: TRect;
begin
  GetWindowRect(gameHandle, rect);

  gameX := Left - rect.Left;
  gameY := Top - rect.Top;

  gameWidth := Width;
  gameHeight := Height;
end;

procedure TFormWindow.menuWindowHalfOpacityClick(Sender: TObject);
begin
  menuWindowHalfOpacity.Checked := not menuWindowHalfOpacity.Checked;
  AlphaBlend := menuWindowHalfOpacity.Checked;
end;

// Global
function EnumWindowsProc(hWindow: HWND; _windowIndex:Cardinal): Bool; stdcall;
var
  HoldString: PChar;
  WindowStyle: Longint;
  IsAChild: Word;

  menuItem : TMenuItem;

  HIco: HICON;
  Icon: TIcon;
  iconCount: Integer;

  pid: Cardinal;
  filename: string;
  indexIcon: Word;
begin
  indexIcon := 0;
  GetMem(HoldString, 256);

  WindowStyle := GetWindowLong(hWindow, GWL_STYLE);
  WindowStyle := WindowStyle and Longint(WS_VISIBLE);
  IsAChild := GetWindowWord(hWindow, GWL_HWNDPARENT);

  if (GetWindowText(hWindow, HoldString, 255) > 0)
    and (WindowStyle > 0)
    and (IsAChild = Word(nil))
    then begin
        // ShowMessage(StrPas(HoldString) +'='+ IntToStr(hWindow));

        menuItem := TMenuItem.Create(FormWindow[_windowIndex].menuSelectTarget);
        menuItem.Caption := StrPas(HoldString);
        menuItem.OnClick :=  FormWindow[_windowIndex].menuDefaultClick;
        menuItem.Tag := hWindow;


        iconCount := FormWindow[_windowIndex].imageList.Count;
        // Big icon from window
        HIco := SendMessage(hWindow, WM_GETICON, ICON_BIG, 0);

        // Small icon from window
        if HIco = 0 then
          HIco := SendMessage(hWindow, WM_GETICON, ICON_SMALL2, 0);

        // Icon from exe-file
        if HIco = 0 then begin
          pid := GetPIDByHWnd(hWindow);
          if pid <> 0 then begin
            filename := GetPathFromPID(pid);
            if filename <> '' then begin
              HIco := ExtractAssociatedIcon(Application.Handle, PChar(filename), indexIcon);
            end;
          end;
        end;

        Icon := TIcon.Create;
        try
          Icon.ReleaseHandle;
          Icon.Handle := HIco;
          FormWindow[_windowIndex].imageList.AddIcon(Icon);
        finally
          Icon.Free;
        end;


        if iconCount <> FormWindow[_windowIndex].imageList.Count then
          menuItem.ImageIndex := FormWindow[_windowIndex].imageList.Count - 1;

        FormWindow[_windowIndex].menuSelectTarget.Add(menuItem);
    end;

  FreeMem(HoldString, 256);
  Result := True;
end;

procedure TFormWindow.PopupActionBarPopup(Sender: TObject);
var
  index : Integer;
begin
  // Óäàëÿåì âñ¸
  for index := 1 to menuSelectTarget.Count - 1 do begin
    menuSelectTarget.Delete(1);
  end;

  //imageList.Clear;
  for index := 5 to imageList.Count - 1 do
    imageList.Delete(5);

  EnumWindows(@EnumWindowsProc, windowIndex);
end;

procedure TFormWindow.FormDblClick(Sender: TObject);
begin
  if WindowState = wsMaximized then begin
    WindowState := wsNormal;
  end else begin
    WindowState := wsMaximized;
  end;
end;

procedure TFormWindow.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  _formPosition: TPoint;
begin
  mouseDown := Point(X, Y);
 if ssAlt in Shift then Exit;

  _formPosition := Point(Left, Top);
  // Move form
  if (Button = mbLeft) and (menuWindowMovable.Checked) then begin
    ReleaseCapture;
    SendMessage(Handle, WM_SYSCOMMAND, 61458, 0);
  end;

  if Button = mbLeft then begin
    // Form do not change position
    if(_formPosition = Point(Left, Top)) then begin
      SetForegroundWindow(gameHandle);
    end;
  end
  else if Button = mbMiddle then Close();
end;

procedure TFormWindow.FormMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  x1, x2, y1, y2, gameXend, gameYend, _gameX, _gameY, _gameWidth, _gameHeight: double;
begin
  if not (ssAlt in Shift) then Exit;

  gameXend := gameX + gameWidth;
  gameYend := gameY + gameHeight;

  x1 := Min(mouseDown.X, X);
  x2 := Max(mouseDown.X, X);
  y1 := Min(mouseDown.Y, Y);
  y2 := Max(mouseDown.Y, Y);

  _gameX := (x1 * gameXend - x1 * gameX + Width * gameX) / Width;
  _gameY := (y1 * gameYend - y1 * gameY + Height * gameY) / Height;

  _gameWidth := (x2 * gameXend - x2 * gameX + Width * gameX) / Width - _gameX;
  _gameHeight := (y2 * gameYend - y2 * gameY + Height * gameY) / Height - _gameY;

  gameX := round(_gameX);
  gameY := round(_gameY);

  gameWidth := round(_gameWidth);
  gameHeight := round(_gameHeight);

  saveProportion();
end;

procedure TFormWindow.FormMouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
const
  DELTA = 0.05;
var
  direction: Integer;
begin
  if not menuWindowSizable.Checked then Exit;

  // - scroll down
  // + scroll up
  direction := Round(WheelDelta / Abs(WheelDelta));

  if menuInvertWheel.Checked then direction := -direction;

  Left := Left + Round(direction * Width * DELTA);
  Top := Top + Round(direction * Height * DELTA);
  Width:= Width - Round(direction * 2 * Width * DELTA);
  Height := Height - Round(direction * 2 * Height * DELTA);

  saveProportion();
end;

procedure TFormWindow.FormResize(Sender: TObject);
var
  _visible: Boolean;
begin
  _visible := (Width > 100) and (Height > 100);

  labelBuild.Visible := _visible;
  labelHelp.Visible := _visible;
end;

// Resize bsNone
procedure TFormWindow.WMNCHitTest(var Message: TWMNCHitTest);
const
  EDGEDETECT = 7; // adjust
var
  deltaRect: TRect;
begin
  inherited;

  if not menuWindowSizable.Checked then Exit;

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

procedure TFormWindow.FormActivate(Sender: TObject);
begin
  // - AltTab
  SetWindowLong(Handle, GWL_EXSTYLE,
                GetWindowLong(Handle, GWL_EXSTYLE) or
                WS_EX_TOOLWINDOW and not WS_EX_APPWINDOW);


  // - TaskBar
  ShowWindow(Application.Handle, SW_HIDE);
end;

procedure TFormWindow.FormShow(Sender: TObject);
begin
  // - AltTab
  SetWindowLong(Handle, GWL_EXSTYLE,
                GetWindowLong(Handle, GWL_EXSTYLE) or
                WS_EX_TOOLWINDOW and not WS_EX_APPWINDOW);

  // - TaskBar
  ShowWindow(Application.Handle, SW_HIDE);
end;

end.
