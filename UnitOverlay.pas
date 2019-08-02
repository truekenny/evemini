unit UnitOverlay;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs;

type
  TFormOverlay = class(TForm)
    procedure FormActivateOrShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure Show(rect: TRect); overload;
    procedure DrawRect(first, second: TPoint);
  end;

var
  FormOverlay: TFormOverlay;

implementation

{$R *.dfm}

procedure TFormOverlay.DrawRect(first, second: TPoint);
begin
  Canvas.Rectangle(-1, -1, Width + 1, Height + 1);
  Canvas.Rectangle(first.X, first.Y, second.X, second.Y);
end;

procedure TFormOverlay.Show(rect: TRect);
begin
  Left := rect.Left;
  Top := rect.Top;
  Width := rect.Width;
  Height := rect.Height;

  inherited Show;
end;

procedure TFormOverlay.FormActivateOrShow(Sender: TObject);
begin
  // Always On Top
  SetWindowPos(Handle, HWND_TOPMOST, 0, 0, 0, 0, SWP_NOMOVE or SWP_NOSIZE);

  // - AltTab
  SetWindowLong(Handle, GWL_EXSTYLE,
                GetWindowLong(Handle, GWL_EXSTYLE) or
                WS_EX_TOOLWINDOW and not WS_EX_APPWINDOW);

  // - TaskBar
  ShowWindow(Application.Handle, SW_HIDE);
end;

procedure TFormOverlay.FormCreate(Sender: TObject);
begin
  DoubleBuffered := True;

  Canvas.Brush.Color := clBlack;
  Canvas.Pen.Color := clLime;
end;

end.
