unit UnitInlineMacros;

interface

uses
  System.Types;

function Point(AX, AY: Integer): TPoint;

implementation

function Point(AX, AY: Integer): TPoint;
begin
  Result.X := AX;
  Result.Y := AY;
end;

end.
