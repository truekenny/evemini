program Evemini;

uses
  Vcl.Forms,
  UnitMain in 'UnitMain.pas' {FormMain};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := false;
  Application.CreateForm(TFormMain, FormMain);
  Application.Run;
end.
