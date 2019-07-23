program Evemini;

uses
  Vcl.Forms,
  UnitMain in 'UnitMain.pas' {FormMain};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := False;
  Application.CreateForm(TFormMain, FormMain);
  Application.Run;
end.
