unit UnitBox;

interface
  uses UnitCluster, DateUtils, SysUtils;

var
  check : boolean; {�������� checkT}

type
  TBox = class       {������ � ����������}
    Clusters : array of TCluster; {������ ���������}
    ClustersCount : integer;      {���������� ���������}

    procedure Init(_ClustersCount : integer;
                   _r,_maxX,_maxY,e,eb : real); {���� ������}
    procedure Step;   {���� ���}
    function WorkUntilClusters(maxTacts : integer) : integer;
    procedure Clear;  {�������� ���� ������}
  end;

implementation

procedure TBox.Init(_ClustersCount : integer; _r,_maxX,_maxY,e,eb : real);    {���� ������}
var
  i : integer;
begin

{������������ ����� ����������}

  ClustersCount := _ClustersCount;
  r := _r;
  maxX := _maxX;
  maxY := _maxY;
  sqrBlowV := 2*eb;
  dt := 0.1;
  maxV := 0;

{������������ ���� ���������� ��������}

  Randomize;
  SetLength(Clusters,ClustersCount);
  for i := 0 to ClustersCount - 1 do
  begin
    Clusters[i] := TCluster.Create;
    Clusters[i].Enabled := true;

    Clusters[i].Vx := random(4*round(sqrt(e))) - 2*sqrt(e);
    Clusters[i].Vy := random(4*round(sqrt(e))) - 2*sqrt(e);
    If Clusters[i].Vx = 0 then
      Clusters[i].Vx := 1;
    If Clusters[i].Vy = 0 then
      Clusters[i].Vy := 1;

    Clusters[i].PointCount := 1;
    SetLength(Clusters[i].Point, 1);
    Clusters[i].Point[0].x := random(round(maxX - 2*r)) + r;
    Clusters[i].Point[0].y := random(round(maxY - 2*r)) + r;
    Clusters[i].Xc := Clusters[i].Point[0].X;
    Clusters[i].Yc := Clusters[i].Point[0].Y;

{������� ������������ �������� ����� ����}

    if abs(Clusters[i].Vx) > maxV then
      maxV := abs(Clusters[i].Vx);
    if abs(Clusters[i].Vy) > maxV then
      maxV := abs(Clusters[i].Vy);
  end;
end;

procedure TBox.Step;
var
  i, j : integer;
  offset : integer; {���������� ��������}
  flag : boolean;  {����������� ������������}
  _maxV : real;   {������������ �������� �� ������ ����}

begin
{�������� ���������� �������}

  If check = True then
  begin
    _maxV := 0;
    for i := 0 to ClustersCount-1 do
    begin
      if abs(Clusters[i].Vx) > _maxV then
        _maxV := abs(Clusters[i].Vx);
      if abs(Clusters[i].Vy) > _maxV then
        _maxV := abs(Clusters[i].Vy);
    end;
    dt := maxV / _maxV;
  end;

{��� ���������}

  for i := 0 to ClustersCount-1 do
  begin
    Clusters[i].Step;
  end;

{������������ ���������}

  for i := 0 to ClustersCount-1 do
  begin
    flag := false;
    for j := i+1 to ClustersCount-1 do
    begin
      if Clusters[i].IsBlowed(Clusters[j]) then
      begin
        Clusters[i].Connect(Clusters[j]);
        Clusters[j].Enabled := false;
        flag := true;
      end;
    end;

{����� � �������� �������� ���������}

    if flag = True then
    begin
      offset := 0;
      for j := i+1 to ClustersCount-1 do
      begin
        if Clusters[j].Enabled = False then
        begin
          inc(offset);
          Clusters[j].Clear;
        end else begin
          Clusters[j - offset] := Clusters[j];
        end;
      end;
      ClustersCount := ClustersCount - offset;
      SetLength(Clusters, ClustersCount);
    end;
  end;
end;


function TBox.WorkUntilClusters(maxTacts : integer): integer;
var
  t1, t2 : integer; {�����}
  i : integer;
begin
  WorkUntilClusters := -1;
  t1 := MilliSecondOfTheDay(getTime);
  For i := 0 to maxTacts do
  begin
    Step;
    If clustersCount <= 20 then
    begin
      break;
    end;
  end;
  t2 := MilliSecondOfTheDay(getTime);
  WorkUntilClusters := t2 - t1;
end;


procedure TBox.Clear;
var
  i : integer;
begin
  for i := 0 to ClustersCount-1 do
  begin
    Clusters[i].Clear;
  end;

  SetLength(Clusters, 0);
  ClustersCount := 0;
end;
end.
