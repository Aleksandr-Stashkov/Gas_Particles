unit UnitCluster;

interface

uses Math;

var
  r : real;     {������}
  sqrBlowV : real;  {�������� ������������}

  dt : real;    {���������� �������}
  maxV : real;  {������������ �������� ����� ����� �� ����}

  maxX, maxY : real; {������� ������}

type
  TPoint = record     {������� � ��������}
    X, Y : real;      {����������}
  end;

  TCluster = class     {�������}
    public
    Xc, Yc : real;     {����� ����}
    Vx, Vy : real;     {�������� ��������}
    PointCount : integer;       {���������� ���������}
    Point : array of TPoint;    {�������� ��������}
    Enabled : boolean;           {true, ���� ������� ���������}

    procedure Step;    {������� ��������}
    function IsBlowed(var other : TCluster) : boolean; {�������� �� ������������}
    procedure Connect(var other : TCluster);  {����������� ���������}
    procedure Clear;  {�������� ��������}
  end;

implementation

procedure TCluster.Step; {������� ��������}
var
    i, j : integer;
    d : real;    {����� ������� ��� ������������ �� �������}
    flagx, flagy : boolean;  {������������ ������������ �� �������}
    tmpxc, tmpyc : real;  {��� �������� ������ ����}

begin

{����� �� ���� ���}

  for i := 0 to PointCount-1 do
  begin
    Point[i].X := Point[i].X + Vx * dt;
    Point[i].Y := Point[i].Y + Vy * dt;
  end;

{������� ������������ �� ��������}

  flagy := False;
  flagx := False;

  for i := 0 to PointCount-1 do
  begin
    If Point[i].X < r then
    begin
      flagx := True;
      d := r - Point[i].X;
      For j := 0 to PointCount-1 do
      begin
        Point[j].X := Point[j].X + d;
      end;
    end;

    If Point[i].X > maxX - r then
    begin
      flagx := True;
      d := Point[i].X - maxX + r;
      For j := 0 to PointCount-1 do
      begin
        Point[j].X := Point[j].X - d;
      end;
    end;

    If Point[i].Y < r then
    begin
      flagy := True;
      d := r - Point[i].Y;
      For j := 0 to PointCount-1 do
      begin
        Point[j].Y := Point[j].Y + d;
      end;
    end;

    If Point[i].Y > maxY - r then
    begin
      flagy := True;
      d := Point[i].Y - maxY + r;
      For j := 0 to PointCount-1 do
      begin
        Point[j].Y := Point[j].Y - d;
      end;
    end;
  end;

  If (flagx = True) then
      Vx := -Vx;
  If (flagy = True) then
      Vy := -Vy;

{������� ������ ����}

    tmpxc := 0;
    tmpyc := 0;
    For i := 0 to PointCount - 1 do
    begin
      tmpxc := tmpxc + Point[i].X;
      tmpyc := tmpyc + Point[i].Y;
    end;
    xc := tmpxc / PointCount;
    yc := tmpyc / PointCount;
end;


function TCluster.IsBlowed(var other : TCluster) : boolean;   {�������� �� ������������}
var
  i, j : integer;
begin
  For i := 0 to PointCount-1 do
  begin
    For j := 0 to other.PointCount-1 do
    begin
      if (sqr(Vx - other.Vx) +
          sqr(Vy - other.Vy) <=
          sqrBlowV) then
      begin
        if (sqr(Point[i].X - other.Point[j].X) +
            sqr(Point[i].Y - other.Point[j].Y) <
            4*sqr(r)) then
        begin
          IsBlowed := true;
          exit;
        end;
      end;
    end;
  end;

  IsBlowed := False;
end;


procedure TCluster.Connect(var other : TCluster);
var
  i : integer;
  tmpxc, tmpyc : real; {��� �������� ������ ����}

begin

{������� ��������}

  Vx := ((Vx * PointCount)+ (other.Vx * other.PointCount)) / (PointCount + other.PointCount);
  Vy := ((Vy * PointCount)+ (other.Vy * other.PointCount)) / (PointCount + other.PointCount);

{���������� �����}

  SetLength(Point, PointCount + other.PointCount);
  for i := 0 to other.PointCount-1 do
  begin
    Point[PointCount + i].X := other.Point[i].X;
    Point[PointCount + i].Y := other.Point[i].Y;
  end;
  PointCount := PointCount +  other.PointCount;

{������� ������ ����}

  tmpxc := 0;
  tmpyc := 0;
  For i := 0 to PointCount - 1 do
  begin
    tmpxc := tmpxc + Point[i].X;
    tmpyc := tmpyc + Point[i].Y;
  end;
  xc := tmpxc / PointCount;
  yc := tmpyc / PointCount;
end;


procedure TCluster.Clear;
begin
  SetLength(Point, 0);
  PointCount := 0;
end;


end.
