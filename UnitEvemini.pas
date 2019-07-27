unit UnitEvemini;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, UnitWindow;

type
  TFormEvemini = class(TForm)
    TimerCheckForms: TTimer;
    procedure TimerCheckFormsTimer(Sender: TObject);
  private
    { Private declarations }
    procedure WMCopyData(var Msg: TWMCopyData); message WM_COPYDATA;
  public
    { Public declarations }
  end;

var
  FormEvemini: TFormEvemini;

implementation

{$R *.dfm}

procedure TFormEvemini.WMCopyData(var Msg: TWMCopyData);
var
  getParams: string;

begin
  getParams := PChar(Msg.CopyDataStruct.lpData);



end;

procedure TFormEvemini.TimerCheckFormsTimer(Sender: TObject);
var
  index: Integer;
begin
  for index := 0 to Length(FormWindow) - 1 do begin
    if FormWindow[index] <> nil then Exit;
  end;

  Close();
end;

end.
