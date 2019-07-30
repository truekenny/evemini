program Evemini;

uses
  Vcl.Forms,
  Winapi.Windows,

  AppTrackMenus in 'AppTrackMenus.pas',
  UnitGetBuild in 'UnitGetBuild.pas',
  UnitEvemini in 'UnitEvemini.pas' {FormEvemini},
  UnitInlineMacros in 'UnitInlineMacros.pas',
  UnitProcessLibrary in 'UnitProcessLibrary.pas',
  UnitString in 'UnitString.pas',
  UnitWindow in 'UnitWindow.pas' {FormWindow};

const
  WM_COPYDATA = 74;

{$R *.res}

var
  params: array of string;
  index: Integer;

  targetHwnd: Cardinal;
  sendParams: string;
  aCopyData: TCopyDataStruct;

  mutex: Cardinal;

begin
  mutex := CreateMutex(nil, false, 'evemini');
  WaitForSingleObject(mutex, 5000);

  SetLength(params, ParamCount);
  for index := 0 to ParamCount - 1 do begin
    params[index] := ParamStr(index + 1);
    sendParams := sendParams + ParamStr(index + 1) + ';';
  end;


  targetHwnd := FindWindow('TFormEvemini', nil);
  if targetHwnd <> 0 then begin
    with aCopyData do
       begin
         dwData := 0;
         cbData := SizeOf(Char) * Length(sendParams) + 1;
         lpData := PChar(sendParams);
       end;

    SendMessage(targetHwnd, WM_COPYDATA, Application.Handle, Longint(@aCopyData));


    ReleaseMutex(mutex);
    exit;
  end;


  Application.Initialize;
  Application.MainFormOnTaskbar := False;
  Application.ShowMainForm := false;

  // Default form
  Application.CreateForm(TFormEvemini, FormEvemini);
  // First Window
  SetLength(FormWindow, Length(FormWindow) + 1);
  Application.CreateForm(TFormWindow, FormWindow[Length(FormWindow) - 1]);
  FormWindow[Length(FormWindow) - 1].initialize(Length(FormWindow) - 1, params, mutex);

  params := nil;

  Application.Run;
end.
