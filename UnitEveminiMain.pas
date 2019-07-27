unit UnitEveminiMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, UnitEvemini;

type
  TFormEveminiMain = class(TForm)
    TimerCheckForms: TTimer;
    procedure TimerCheckFormsTimer(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormEveminiMain: TFormEveminiMain;

implementation

{$R *.dfm}

procedure TFormEveminiMain.TimerCheckFormsTimer(Sender: TObject);
var
  index: Integer;
begin
  for index := 0 to Length(FormEvemini) - 1 do begin
    if FormEvemini[index] <> nil then Exit;
  end;

  Close();
end;

end.
