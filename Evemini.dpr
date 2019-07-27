program Evemini;

uses
  Vcl.Forms,
  UnitWindow in 'UnitWindow.pas' {FormWindow},
  UnitEvemini in 'UnitEvemini.pas' {FormEvemini},
  UnitGetBuild in 'UnitGetBuild.pas',
  UnitInlineMacros in 'UnitInlineMacros.pas',
  UnitProcessLibrary in 'UnitProcessLibrary.pas';

{$R *.res}

var
  params: array of string;
  index: Integer;

begin
  SetLength(params, ParamCount);
  for index := 0 to ParamCount - 1 do
    params[index] := ParamStr(index + 1);


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
