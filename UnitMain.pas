unit UnitMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, DwmApi,
  Vcl.Menus, Vcl.PlatformDefaultStyleActnCtrls, Vcl.ActnPopup, System.ImageList,
  Vcl.ImgList, IniFiles, RegularExpressions, ShellApi, UnitProcessLibrary;

type
  TFormMain = class(TForm)
    Timer: TTimer;
    PopupActionBar: TPopupActionBar;
    menuSelectWindow: TMenuItem;
    menuDefault: TMenuItem;
    N11: TMenuItem;
    N21: TMenuItem;
    menuAlwaysVisible: TMenuItem;
    menuSeparatorChecks: TMenuItem;
    menuQuit: TMenuItem;
    menuSelectGameArea: TMenuItem;
    menuSeparatorQuit: TMenuItem;
    menuWindowMovable: TMenuItem;
    menuWindowSizable: TMenuItem;
    menuResizeWindow1x1: TMenuItem;
    menuWindowHalfOpacity: TMenuItem;
    imageList: TImageList;
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
    procedure menuReCheck(Sender: TObject);
    procedure menuQuitClick(Sender: TObject);
    procedure menuSelectGameAreaClick(Sender: TObject);
    procedure menuResizeWindow1x1Click(Sender: TObject);
    procedure menuWindowHalfOpacityClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    procedure explode(var a: array of string; Border, S: string);
    function getHandle(): Cardinal;
    procedure fresh();
    procedure registerThumbnail();
    procedure borderThumbnail(withBorder: Boolean);
    procedure generateConfigFilename();

  public
    { Public declarations }
  end;

var
  FormMain: TFormMain;
  windowName: string;
  gameX: Integer = 0;
  gameY: Integer = 0;
  gameWidth: Integer = 0;
  gameHeight: Integer = 0;
  gameHandle: Cardinal = 0;
  config: string;

  PH: HTHUMBNAIL;

implementation

{$R *.dfm}

procedure TFormMain.generateConfigFilename();
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
    Timer.Enabled := False;
    ShowMessage('Properties (border) fail');
    Close;
  end;
end;

procedure TFormMain.FormClose(Sender: TObject; var Action: TCloseAction);
var
  ini: TIniFile;
begin
  if config = '' then Exit;

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
  finally
    ini.Free;
  end;
end;

procedure TFormMain.FormCreate(Sender: TObject);
var
  index: Integer;
  param, key, value: string;
  pair: array of string;

  ini: TIniFile;
begin
  SetLength(pair, 2);

  for index := 1 to ParamCount do begin
    param := ParamStr(index);

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
    else if key = '--always-visible' then menuAlwaysVisible.Checked := StrToBool(value);
  end;

  if gameWidth = 0 then gameWidth := Width;
  if gameHeight = 0 then gameHeight := Height;

  if windowName = '' then
    Caption := 'Evemini'
  else
    Caption := 'Evemini - ' + windowName;
end;

procedure TFormMain.menuReCheck(Sender: TObject);
begin
    (Sender as TMenuItem).Checked := not (Sender as TMenuItem).Checked;
end;

procedure TFormMain.menuResizeWindow1x1Click(Sender: TObject);
begin
  Width := gameWidth;
  Height := gameHeight;
end;

procedure TFormMain.menuDefaultClick(Sender: TObject);
begin
  DwmUnregisterThumbnail(PH);
  gameHandle := (Sender as TMenuItem).Tag;
  windowName := (Sender as TMenuItem).Caption;
  Timer.Enabled := true;

  generateConfigFilename;
  registerThumbnail;
end;

procedure TFormMain.menuQuitClick(Sender: TObject);
begin
  Close();
end;

procedure TFormMain.menuSelectGameAreaClick(Sender: TObject);
var
  rect: TRect;
begin
  GetWindowRect(gameHandle, rect);

  gameX := Left - rect.Left;
  gameY := Top - rect.Top;

  gameWidth := Width;
  gameHeight := Height;
end;

procedure TFormMain.menuWindowHalfOpacityClick(Sender: TObject);
begin
  menuWindowHalfOpacity.Checked := not menuWindowHalfOpacity.Checked;
  AlphaBlend := menuWindowHalfOpacity.Checked;
end;

// Global
function EnumWindowsProc(hWindow: HWND): Bool; stdcall;
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

        menuItem := TMenuItem.Create(FormMain.menuSelectWindow);
        menuItem.Caption := StrPas(HoldString);
        menuItem.OnClick :=  FormMain.menuDefaultClick;
        menuItem.Tag := hWindow;


        iconCount := Formmain.imageList.Count;
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
          Formmain.imageList.AddIcon(Icon);
        finally
          Icon.Free;
        end;


        if iconCount <> Formmain.imageList.Count then
          menuItem.ImageIndex := Formmain.imageList.Count - 1;

        FormMain.menuSelectWindow.Add(menuItem);
    end;

  FreeMem(HoldString, 256);
  Result := True;
end;

procedure TFormMain.PopupActionBarPopup(Sender: TObject);
var
  index : Integer;
begin
  // Óäàëÿåì âñ¸
  for index := 1 to menuSelectWindow.Count - 1 do begin
    menuSelectWindow.Delete(1);
  end;

  //imageList.Clear;
  for index := 3 to imageList.Count - 1 do
    imageList.Delete(3);

  EnumWindows(@EnumWindowsProc, 0);
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
var
  _formPosition: TPoint;
begin
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

procedure TFormMain.FormMouseWheel(Sender: TObject; Shift: TShiftState;
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

  Left := Left + Round(direction * Width * DELTA);
  Top := Top + Round(direction * Height * DELTA);
  Width:= Width - Round(direction * 2 * Width * DELTA);
  Height := Height - Round(direction * 2 * Height * DELTA);
end;

// Resize bsNone
procedure TFormMain.WMNCHitTest(var Message: TWMNCHitTest);
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

procedure TFormMain.FormActivate(Sender: TObject);
begin
  // - AltTab
  SetWindowLong(Handle, GWL_EXSTYLE,
                GetWindowLong(Handle, GWL_EXSTYLE) or
                WS_EX_TOOLWINDOW and not WS_EX_APPWINDOW);


  // - TaskBar
  ShowWindow(Application.Handle, SW_HIDE);
end;

procedure TFormMain.FormShow(Sender: TObject);
begin
  // - AltTab
  SetWindowLong(Handle, GWL_EXSTYLE,
                GetWindowLong(Handle, GWL_EXSTYLE) or
                WS_EX_TOOLWINDOW and not WS_EX_APPWINDOW);

  // - TaskBar
  ShowWindow(Application.Handle, SW_HIDE);
end;

end.
