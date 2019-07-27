program Evemini;

uses
  Vcl.Forms, Windows, System.SysUtils,
  UnitWindow in 'UnitWindow.pas' {FormWindow},
  UnitEvemini in 'UnitEvemini.pas' {FormEvemini},
  UnitGetBuild in 'UnitGetBuild.pas',
  UnitInlineMacros in 'UnitInlineMacros.pas',
  UnitProcessLibrary in 'UnitProcessLibrary.pas';

{$R *.res}

const
  WM_COPYDATA = 74;

var
  params: array of string;
  index: Integer;

  targetHwnd: Cardinal;
  sendParams: string;
  aCopyData: TCopyDataStruct;

begin
  SetLength(params, ParamCount);
  for index := 0 to ParamCount - 1 do begin
    params[index] := ParamStr(index + 1);
    sendParams := sendParams + ';' + ParamStr(index + 1);
  end;


  targetHwnd := FindWindow('TFormEvemini', nil);
  if targetHwnd <> 0 then begin
    with aCopyData do
       begin
         dwData := 0;
         cbData := StrLen(PChar(sendParams)) + 1;
         lpData := PChar(sendParams);
       end;

    SendMessage(targetHwnd, WM_COPYDATA, Application.Handle, Longint(@aCopyData));
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
  FormWindow[Length(FormWindow) - 1].initialize(Length(FormWindow) - 1, params);

  params := nil;

  Application.Run;
end.
