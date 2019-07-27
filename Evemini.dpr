program Evemini;

uses
  Vcl.Forms,
  UnitEvemini in 'UnitEvemini.pas' {FormEvemini},
  UnitProcessLibrary in 'UnitProcessLibrary.pas',
  UnitGetBuild in 'UnitGetBuild.pas',
  UnitInlineMacros in 'UnitInlineMacros.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := False;

  SetLength(FormEvemini, 1);

  Application.CreateForm(TFormEvemini, FormEvemini[0]);
  FormEvemini[0].initialize;
  Application.Run;
end.
