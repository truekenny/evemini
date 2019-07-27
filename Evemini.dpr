program Evemini;

uses
  Vcl.Forms,
  UnitEveminiMain in 'UnitEveminiMain.pas' {FormEveminiMain},
  UnitEvemini in 'UnitEvemini.pas' {FormEvemini},
  UnitProcessLibrary in 'UnitProcessLibrary.pas',
  UnitInlineMacros in 'UnitInlineMacros.pas',
  UnitGetBuild in 'UnitGetBuild.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := False;
  Application.ShowMainForm := false;

  // Default form
  Application.CreateForm(TFormEveminiMain, FormEveminiMain);

  // First window
  SetLength(FormEvemini, Length(FormEvemini) + 1);
  Application.CreateForm(TFormEvemini, FormEvemini[0]);
  FormEvemini[0].initialize(0);

  Application.Run;
end.
