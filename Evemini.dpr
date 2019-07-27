program Evemini;

uses
  Vcl.Forms,
  UnitEvemini in 'UnitEvemini.pas' {FormEvemini},
  UnitProcessLibrary in 'UnitProcessLibrary.pas',
  UnitGetBuild in 'UnitGetBuild.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := False;
  Application.CreateForm(TFormEvemini, FormEvemini);
  Application.Run;
end.
