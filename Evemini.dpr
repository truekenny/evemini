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

  SetLength(FormEvemini, Length(FormEvemini) + 1);
  Application.CreateForm(TFormEvemini, FormEvemini[Length(FormEvemini) - 1]);
  FormEvemini[Length(FormEvemini) - 1].initialize(Length(FormEvemini) - 1);

  Application.Run;
end.
