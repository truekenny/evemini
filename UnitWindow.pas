unit UnitWindow;

interface

uses
  AppTrackMenus,
  System.Classes,
  System.ImageList,
  System.IniFiles,
  System.Math,
  System.RegularExpressions,
  System.SysUtils,
  UnitGetBuild,
  UnitInlineMacros,
  UnitProcessLibrary,
  UnitString,
  Vcl.ActnPopup,
  Vcl.ComCtrls,
  Vcl.Controls,
  Vcl.Dialogs,
  Vcl.ExtCtrls,
  Vcl.Forms,
  Vcl.Graphics,
  Vcl.ImgList,
  Vcl.Menus,
  Vcl.PlatformDefaultStyleActnCtrls,
  Vcl.StdCtrls,
  Winapi.DwmApi,
  Winapi.Messages,
  Winapi.ShellApi,
  Winapi.Windows;

type
  TMenuItemRegion = class(TMenuItem)
  private
    FGameWidth: Integer;
    FGameHeight: Integer;
    FGameLeft: Integer;
    FGameTop: Integer;
  public
    property gameWidth: Integer read FGameWidth write FGameWidth;
    property gameHeight: Integer read FGameHeight write FGameHeight;
    property gameLeft: Integer read FGameLeft write FGameLeft;
    property gameTop: Integer read FGameTop write FGameTop;
  end;

  TFormWindow = class(TForm)
    Timer: TTimer;
    PopupMenu: AppTrackMenus.TPopupMenu;
    menuSelectTarget: TMenuItem;
    menuDefault: TMenuItem;
    N11: TMenuItem;
    N21: TMenuItem;
    menuAlwaysVisible: TMenuItem;
    menuSeparatorChecks: TMenuItem;
    menuClose: TMenuItem;
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
    menuWindowStick: TMenuItem;
    menuRegions: TMenuItem;
    menuSaveCurrentRegion: TMenuItem;
    menuSeparatorSaveCurrent: TMenuItem;
    menuSelectRegion: TMenuItem;
    menuSetWindowName: TMenuItem;
    menuSearchWindowAgain: TMenuItem;
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure TimerTimer(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormDblClick(Sender: TObject);
    procedure FormMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure PopupMenuPopup(Sender: TObject);
    procedure menuDefaultClick(Sender: TObject);
    procedure menuCloseClick(Sender: TObject);
    procedure menuSelectTargetRegionClick(Sender: TObject);
    procedure menuResizeWindow1x1Click(Sender: TObject);
    procedure menuWindowHalfOpacityClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure menuAllTargetSpaceClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure menuNewClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);

    procedure WMNCHitTest(var Message: TWMNCHitTest); message WM_NCHITTEST;
    procedure WMSizing(var Message: TMessage); message WM_SIZING;
    procedure WMMoving(var Message: TMessage); message WM_MOVING;
    procedure FormCreate(Sender: TObject);
    procedure menuSaveCurrentRegionClick(Sender: TObject);
    procedure menuSelectRegionClick(Sender: TObject);
    procedure menuSetWindowNameClick(Sender: TObject);
    procedure menuSearchWindowAgainClick(Sender: TObject);
  private
    { Private declarations }
    windowIndex: Integer;

    fWindowName: string;
    gameX: Integer;
    gameY: Integer;
    gameWidth: Integer;
    gameHeight: Integer;
    gameHandle: Cardinal;
    config: string;

    PH: HTHUMBNAIL;

    // ����� �������, MouseDown, MouseUp
    mouseDown: TPoint;

    // ����������� �����, WMMoving, MouseUp
    glueDeltaLeft: Integer;
    glueDeltaTop: Integer;

    getHandlerResult: Cardinal;

    function getHandle(): Cardinal;
    procedure fresh();
    procedure registerThumbnail();
    procedure borderThumbnail(withBorder: Boolean);
    procedure generateConfigFilename();
    function isWritable(filename: string): Boolean;
    procedure saveProportion();
    procedure setWindowName(str: string);

    procedure TrackMenuNotifyHandler(Sender: TMenu; Item: TMenuItem; var CanClose: Boolean);
  public
    { Public declarations }
    procedure initialize(_windowIndex: Integer; params: array of string; mutex: Cardinal);

    property windowName:string read fWindowName write setWindowName;
  protected
    procedure CreateParams(var Params: TCreateParams); override;
end;

var
  FormWindow: array of TFormWindow;

implementation

{$R *.dfm}

procedure TFormWindow.setWindowName(str: string);
begin
  fWindowName := str;

  if fWindowName = '' then begin
    Timer.Enabled := False;
    config := '';
    Caption := 'Evemini';
  end
  else begin
    Timer.Enabled := True;
    generateConfigFilename;
    Caption := 'Evemini - ' + fWindowName;
  end;
end;

procedure TFormWindow.TrackMenuNotifyHandler(Sender: TMenu; Item: TMenuItem; var CanClose: Boolean);
begin
  CanClose := not Item.AutoCheck;
end;

// Always On Top
procedure TFormWindow.CreateParams(var Params: TCreateParams);
begin
  inherited;
  Params.WndParent := 0;
end;

procedure TFormWindow.saveProportion();
begin
  if not menuWindowProportion.Checked then Exit;

  Width := Round(Height * gameWidth / gameHeight);
  borderThumbnail(gameHandle = GetForegroundWindow);
end;

// Save proportion on resize form
procedure TFormWindow.WMSizing(var Message: TMessage);
var
  Rect: ^TRect;
  aspectRatio: double;
begin
  if not menuWindowProportion.Checked then begin
    borderThumbnail(gameHandle = GetForegroundWindow);
    Exit;
  end;

  aspectRatio := gameWidth / gameHeight;
  Rect := Pointer(Message.LParam);

  case Message.wParam of
    WMSZ_LEFT, WMSZ_RIGHT, WMSZ_BOTTOMLEFT:
      Rect.Bottom := Rect.Top + Round((Rect.Right - Rect.Left)/aspectRatio);
    WMSZ_TOP, WMSZ_BOTTOM, WMSZ_TOPRIGHT, WMSZ_BOTTOMRIGHT:
      Rect.Right := Rect.Left + Round((Rect.Bottom - Rect.Top)*aspectRatio);
    WMSZ_TOPLEFT:
      Rect.Top := Rect.Bottom - Round((Rect.Right - Rect.Left)/aspectRatio);
  end;
  inherited;

  borderThumbnail(gameHandle = GetForegroundWindow);
end;

procedure TFormWindow.WMMoving(var Message: TMessage);
const
  DELTA = 10;
  BREAK_NEAR = -10000;
var
  Rect: ^TRect;

  nearCheckingBorderLeft,
  nearCheckingBorderTop,
  checkingBorder,
  index,
  middle: Integer;

  leftBorders,
  topBorders: array of Integer;
begin
  if not menuWindowStick.Checked then Exit;

  Rect:= Pointer(Message.LParam);

  // ������� �������
  SetLength(leftBorders, 2);
  leftBorders[Length(leftBorders) - 2] := 0;
  leftBorders[Length(leftBorders) - 1] := Screen.Width - Width;

  // ������� �������
  SetLength(topBorders, 2);
  topBorders[Length(topBorders) - 2] := 0;
  topBorders[Length(topBorders) - 1] := Screen.Height - Height;

  // ������� ��������� �������� ��� Left � Top
  for index := 0 to Length(FormWindow) - 1 do begin
    if index = windowIndex then Continue;
    if FormWindow[index] = nil then Continue;
    if not FormWindow[index].Visible then Continue;

    SetLength(leftBorders, Length(leftBorders) + 4);
    leftBorders[Length(leftBorders) - 4] := FormWindow[index].Left - Width;
    leftBorders[Length(leftBorders) - 3] := FormWindow[index].Left + FormWindow[index].Width - Width;
    leftBorders[Length(leftBorders) - 2] := FormWindow[index].Left;
    leftBorders[Length(leftBorders) - 1] := FormWindow[index].Left + FormWindow[index].Width;

    SetLength(topBorders, Length(topBorders) + 4);
    topBorders[Length(topBorders) - 4] := FormWindow[index].Top - Height;
    topBorders[Length(topBorders) - 3] := FormWindow[index].Top + FormWindow[index].Height - Height;
    topBorders[Length(topBorders) - 2] := FormWindow[index].Top;
    topBorders[Length(topBorders) - 1] := FormWindow[index].Top + FormWindow[index].Height;
  end;


  nearCheckingBorderLeft := BREAK_NEAR;
  nearCheckingBorderTop := BREAK_NEAR;
  for index := 0 to Length(leftBorders) - 1 do begin
    // �������� ����� �������, ������������ ����� �������� Left
    checkingBorder := leftBorders[index];
    if (Rect.Left > checkingBorder - DELTA) and (Rect.Left < checkingBorder + DELTA) then begin
      // ��� �������� ���������� ��������
      if Abs(nearCheckingBorderLeft - Rect.Left) > Abs(checkingBorder - Rect.Left) then
        nearCheckingBorderLeft := checkingBorder;
    end;

    // �������� ������� �������, ������������ ����� �������� Top
    checkingBorder := topBorders[index];
    if (Rect.Top > checkingBorder - DELTA) and (Rect.Top < checkingBorder + DELTA) then begin
      // ��� �������� ���������� ��������
      if Abs(nearCheckingBorderTop - Rect.Top) > Abs(checkingBorder - Rect.Top) then
        nearCheckingBorderTop := checkingBorder;
    end;
  end;

  if nearCheckingBorderLeft <> BREAK_NEAR then begin
      glueDeltaLeft := glueDeltaLeft + Rect.Left - Left;

      middle := Rect.Width;
      Rect.Left := nearCheckingBorderLeft;
      Rect.Width := middle;
  end;

  if nearCheckingBorderTop <> BREAK_NEAR then begin
      glueDeltaTop := glueDeltaTop + Rect.Top - Top;

      middle := Rect.Height;
      Rect.Top := nearCheckingBorderTop;
      Rect.Height := middle;
  end;

  // �������� �� ����� �� ������ �� ������ ������ glue_DELTA �������
  if glueDeltaLeft >= DELTA then begin
    glueDeltaLeft := 0;

    middle := Rect.Width;
    Rect.Left := Rect.Left + DELTA;
    Rect.Width := middle;
  end;

  // �������� �� ����� �� ������ �� ����� ������ glue_DELTA �������
  if glueDeltaLeft <= -DELTA then begin
    glueDeltaLeft := 0;

    middle := Rect.Width;
    Rect.Left := Rect.Left - DELTA;
    Rect.Width := middle;
  end;

  // �������� �� ����� �� ������ �� ������ ������ glue_DELTA �������
  if glueDeltaTop >= DELTA then begin
    glueDeltaTop := 0;

    middle := Rect.Height;
    Rect.Top := Rect.Top + DELTA;
    Rect.Height := middle;
  end;

  // �������� �� ����� �� ������ �� ������� ������ glue_DELTA �������
  if glueDeltaTop <= -DELTA then begin
    glueDeltaTop := 0;

    middle := Rect.Height;
    Rect.Top := Rect.Top - DELTA;
    Rect.Height := middle;
  end;

  leftBorders := nil;
  topBorders := nil;
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
  // config := '123-123 - /?\:Test - ����-������';
  RegEx.Create('[^0-9a-zA-Z�-��-�\-\ ��]');
  config := RegEx.Replace(config, '');
  config := Trim(config);

  if config = '' then Exit;

  config := ExtractFilePath(ParamStr(0)) + config + '.ini';
end;

// Global
function SearchMaskEnumWindowsProc(hWindow: HWND; _windowIndex:Cardinal): Bool; stdcall;
var
  titleLength: Integer;
  titleChars: PChar;
  title, subWindowName: String;
  windowStyle: Longint;
  visibleWindow: LongInt;
begin
  Result := True;

  GetMem(titleChars, 256);

  windowStyle := GetWindowLong(hWindow, GWL_STYLE);
  visibleWindow := windowStyle and Longint(WS_VISIBLE);

  titleLength := GetWindowText(hWindow, titleChars, 255);
  title := titleChars;
  subWindowName := Copy(FormWindow[_windowIndex].windowName, 2);

  if (titleLength > 0)
    and (Pos('Evemini', title) = 0)
    and (visibleWindow > 0)
    and (Pos(subWindowName ,title) <> 0)
    then begin
      Result := False;
      FormWindow[_windowIndex].getHandlerResult := hWindow;
    end;

  FreeMem(titleChars, 256);
end;


function TFormWindow.getHandle(): Cardinal;
begin
  if (Length(windowName) > 0) and (windowName[1] = '*') then begin
    getHandlerResult := 0;

    EnumWindows(@SearchMaskEnumWindowsProc, windowIndex);

    Result := getHandlerResult;
  end
  else
    Result := FindWindow(nil, PChar(windowName));
end;

procedure TFormWindow.TimerTimer(Sender: TObject);
begin
  fresh;
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
      Visible := menuAlwaysVisible.Checked;

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
begin
  if gameHandle <> 0 then
    begin
      if Succeeded(DwmRegisterThumbnail(Handle, gameHandle, @PH))then
         begin
           Props.dwFlags := DWM_TNP_SOURCECLIENTAREAONLY or DWM_TNP_VISIBLE or
                            DWM_TNP_OPACITY;

           Props.fSourceClientAreaOnly := false;
           Props.fVisible := true;
           Props.opacity := 255;

           if Succeeded(DwmUpdateThumbnailProperties(PH, Props))then begin
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

procedure TFormWindow.menuSaveCurrentRegionClick(Sender: TObject);
const
  NO_DATA = '';
var
  config: string;
  ini: TIniFile;
  count: Integer;
  name: string;
begin
  name := InputBox(Application.Title, 'Region name', NO_DATA);
  if name = NO_DATA then Exit;

  config := ExtractFilePath(ParamStr(0)) + 'regions.ini';
  ini := TIniFile.Create(config);
  try
    count := ini.ReadInteger('options', 'count', 0) + 1;

    ini.WriteInteger('options', 'count', count);
    ini.WriteString('region_' + IntToStr(count), 'name', name);
    ini.WriteInteger('region_' + IntToStr(count), 'gameWidth', gameWidth);
    ini.WriteInteger('region_' + IntToStr(count), 'gameHeight', gameHeight);
    ini.WriteInteger('region_' + IntToStr(count), 'gameLeft', gameX);
    ini.WriteInteger('region_' + IntToStr(count), 'gameTop', gameY);
  finally
    ini.Free;
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
  DwmUnregisterThumbnail(PH);
  Action := caFree;

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
    ini.WriteBool('check', 'window-stick', menuWindowStick.Checked);
  finally
    ini.Free;
  end;

end;

procedure TFormWindow.FormCreate(Sender: TObject);
begin
  PopupMenu.TrackMenu := True;
  PopupMenu.OnTrackMenuNotify := TrackMenuNotifyHandler;
end;

procedure TFormWindow.initialize(_windowIndex: Integer; params: array of string; mutex: Cardinal);
var
  index: Integer;
  param, key, value, _config: string;
  pair: array of string;

  ini: TIniFile;
  _windowName: string;
begin
  BorderStyle := bsNone;

  Visible := true;
  windowIndex := _windowIndex;

  FormResize(nil);
  labelBuild.Caption := GetBuildInfoAsString;

  SetLength(pair, 2);

  for index := 0 to Length(params) - 1 do begin
    param := params[index];

    if FileExists(param) then begin
      _config := param;

      ini := TIniFile.Create(_config);
      try
        _windowName := ini.ReadString('game', 'name', windowName);

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
        menuWindowStick.Checked := ini.ReadBool('check', 'window-stick', menuWindowStick.Checked);
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
      _windowName := 'EVE - ' + value;
    end
    else if key = '--window-name' then begin
      _windowName := value;
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
    else if key = '--window-stick' then menuWindowStick.Checked := StrToBool(value)
    else if key = '--invert-wheel' then menuInvertWheel.Checked := StrToBool(value)
    else if key = '--always-visible' then menuAlwaysVisible.Checked := StrToBool(value);
  end;

  if gameWidth = 0 then gameWidth := Width;
  if gameHeight = 0 then gameHeight := Height;


  windowName := _windowName;
  // ���� ��������� ������, ���� �� ��� ������
  if _config <> '' then config := _config;

  if mutex <>0 then
    ReleaseMutex(mutex);
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

  GetWindowRect(gameHandle, rect);
  gameX := 0;
  gameY := 0;
  gameWidth := rect.Width;
  gameHeight := rect.Height;

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
  FormWindow[Length(FormWindow) - 1].initialize(Length(FormWindow) - 1, params, 0);

  params := nil;
end;

procedure TFormWindow.menuCloseClick(Sender: TObject);
begin
  Close();
end;

procedure TFormWindow.menuSearchWindowAgainClick(Sender: TObject);
var
  _gameHandler: Cardinal;
begin
  _gameHandler := getHandle;

  if _gameHandler <> 0 then begin
    DwmUnregisterThumbnail(PH);
    gameHandle := (Sender as TMenuItem).Tag;
    registerThumbnail;
  end;

end;

procedure TFormWindow.menuSelectRegionClick(Sender: TObject);
begin
  gameWidth := (Sender as TMenuItemRegion).gameWidth;
  gameHeight := (Sender as TMenuItemRegion).gameHeight;
  gameX :=  (Sender as TMenuItemRegion).gameLeft;
  gameY :=  (Sender as TMenuItemRegion).gameTop;

  Width := gameWidth;
  Height := gameHeight;

  // borderThumbnail(gameHandle = GetForegroundWindow);
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

procedure TFormWindow.menuSetWindowNameClick(Sender: TObject);
begin
  windowName := InputBox(Application.Title, 'Window Name', windowName);
end;

procedure TFormWindow.menuWindowHalfOpacityClick(Sender: TObject);
begin
  AlphaBlend := menuWindowHalfOpacity.Checked;
end;

// Global
function EnumWindowsProc(hWindow: HWND; _windowIndex:Cardinal): Bool; stdcall;
var
  titleLength: Integer;
  titleChars: PChar;
  title: String;
  windowStyle: Longint;
  visibleWindow: LongInt;

  menuItem : TMenuItem;

  HIco: HICON;
  Icon: TIcon;
  iconCount: Integer;

  pid: Cardinal;
  filename: string;
  indexIcon: Word;
begin
  indexIcon := 0;
  GetMem(titleChars, 256);

  windowStyle := GetWindowLong(hWindow, GWL_STYLE);
  visibleWindow := windowStyle and Longint(WS_VISIBLE);

  titleLength := GetWindowText(hWindow, titleChars, 255);
  title := titleChars;

  if (titleLength > 0)
    and (Pos('Evemini', title) = 0)
    and (visibleWindow > 0)
    then begin
        menuItem := TMenuItem.Create(FormWindow[_windowIndex].menuSelectTarget);
        menuItem.Caption := title;
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

  FreeMem(titleChars, 256);
  Result := True;
end;

procedure TFormWindow.PopupMenuPopup(Sender: TObject);
const
  NO_DATA = -1;
var
  index : Integer;

  config: string;
  ini: TIniFile;
  count, countInserted: Integer;
  _gameWidth, _gameHeight, _gameLeft, _gameTop: Integer;
  menuItem: TMenuItemRegion;
begin
  // ������� ��� ����
  for index := 1 to menuSelectTarget.Count - 1 do
    menuSelectTarget.Delete(1);

  // ������� �������� ����
  for index := 5 to imageList.Count - 1 do
    imageList.Delete(5);

  // ��������� ����� ����
  EnumWindows(@EnumWindowsProc, windowIndex);



  // ������� �������
  for index := 1 to menuRegions.Count - 3 do
    menuRegions.Delete(1);

  // ��������� �������
  countInserted := 0;
  config := ExtractFilePath(ParamStr(0)) + 'regions.ini';
  ini := TIniFile.Create(config);
  try
    count := ini.ReadInteger('options', 'count', 0);

    for index := 1 to count do begin
      _gameWidth := ini.ReadInteger('region_' + IntToStr(index), 'gameWidth', NO_DATA);
      _gameHeight := ini.ReadInteger('region_' + IntToStr(index), 'gameHeight', NO_DATA);
      _gameLeft := ini.ReadInteger('region_' + IntToStr(index), 'gameLeft', NO_DATA);
      _gameTop := ini.ReadInteger('region_' + IntToStr(index), 'gameTop', NO_DATA);

      if (_gameWidth = NO_DATA) or (_gameHeight = NO_DATA)
      or (_gameLeft = NO_DATA) or (_gameTop = NO_DATA) then Continue;

      Inc(countInserted);

      menuItem := TMenuItemRegion.Create(menuRegions);
      menuItem.gameWidth := _gameWidth;
      menuItem.gameHeight := _gameHeight;
      menuItem.gameLeft := _gameLeft;
      menuItem.gameTop := _gameTop;
      menuItem.Caption := ini.ReadString('region_' + IntToStr(index), 'name', 'NO_DATA');
      menuItem.OnClick :=  menuSelectRegionClick;
      menuRegions.Insert(countInserted, menuItem);
    end;
  finally
    ini.Free;
  end;

end;

procedure TFormWindow.FormDblClick(Sender: TObject);
begin
  if WindowState = wsMaximized then begin
    WindowState := wsNormal;
  end else begin
    WindowState := wsMaximized;
  end;

  borderThumbnail(gameHandle = GetForegroundWindow);
end;

procedure TFormWindow.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if not (ssAlt in Shift) then Exit;

  if not menuWindowSizable.Checked then Exit;

  case Key of
    Ord('1'): begin
      Width := Round(gameWidth / 2);
      Height := Round(gameHeight / 2);
    end;
    Ord('2'): begin
      Width := gameWidth;
      Height := gameHeight;
    end;
    Ord('3'): begin
      Width := gameWidth * 2;
      Height := gameHeight * 2;
    end;
    Ord('4'): begin
      Width := gameWidth * 3;
      Height := gameHeight * 3;
    end;
  end;

  saveProportion;

  borderThumbnail(gameHandle = GetForegroundWindow);

  if (Left < 0) or (Left > Screen.Width) then Left := 0;
  if (Top < 0) or (Top > Screen.Height) then Top := 0;
end;

procedure TFormWindow.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  _formPosition: TPoint;
begin
  glueDeltaLeft := 0;
  glueDeltaTop := 0;

  mouseDown := Point(X, Y);
 if ssAlt in Shift then Exit;

  _formPosition := Point(Left, Top);
  // Move form
  if (Button = mbLeft) and (menuWindowMovable.Checked) then begin
    ReleaseCapture;
    SendMessage(Handle, WM_SYSCOMMAND, 61458, 0);
  end;

  if Button = mbLeft then begin
    if(_formPosition = Point(Left, Top)) then begin
      // Form do not change position
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

  if (Abs(x1 - x2) < 20) or (Abs(y1 - y2) < 20) then Exit;

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
  // Always On Top
  SetWindowPos(Handle, HWND_TOPMOST, 0, 0, 0, 0, SWP_NOMOVE or SWP_NOSIZE);

  // - AltTab
  SetWindowLong(Handle, GWL_EXSTYLE,
                GetWindowLong(Handle, GWL_EXSTYLE) or
                WS_EX_TOOLWINDOW and not WS_EX_APPWINDOW);


  // - TaskBar
  ShowWindow(Application.Handle, SW_HIDE);
end;

procedure TFormWindow.FormShow(Sender: TObject);
begin
  // Always On Top
  SetWindowPos(Handle, HWND_TOPMOST, 0, 0, 0, 0, SWP_NOMOVE or SWP_NOSIZE);

  // - AltTab
  SetWindowLong(Handle, GWL_EXSTYLE,
                GetWindowLong(Handle, GWL_EXSTYLE) or
                WS_EX_TOOLWINDOW and not WS_EX_APPWINDOW);

  // - TaskBar
  ShowWindow(Application.Handle, SW_HIDE);
end;

end.
