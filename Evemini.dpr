program Evemini;

uses
  Vcl.Forms,
  UnitEvemini in 'UnitEvemini.pas' {FormEvemini},
  UnitProcessLibrary in 'UnitProcessLibrary.pas',
  UnitGetBuild in 'UnitGetBuild.pas',
  UnitInlineMacros in 'UnitInlineMacros.pas',
  UnitEveminiMain in 'UnitEveminiMain.pas' {FormEveminiMain};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := False;
  Application.ShowMainForm := false;


  Application.CreateForm(TFormEveminiMain, FormEveminiMain);


  SetLength(FormEvemini, Length(FormEvemini) + 1);
  Application.CreateForm(TFormEvemini, FormEvemini[0]);
  FormEvemini[0].initialize(0);

  SetLength(FormEvemini, Length(FormEvemini) + 1);
  Application.CreateForm(TFormEvemini, FormEvemini[1]);
  FormEvemini[1].initialize(1);

  Application.Run;
end.
