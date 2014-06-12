/*
  linear programming capital budgeting problem:

  Maximize NPV of projects (x1..x5) by taking into account Budget and
  Resource constraints (c1, c2). Solution can only be 0 or 1

  Maximize: 928 x1 + 908 x2 + 801 x3 + 543 x4 + 944 x5

  Constraints:
  c1: 398 x1 + 151 x2 + 129 x3 + 275 x4 + 291 x5 <= 800
  c2: 111 x1 + 139 x2 + 56 x3 + 54 x4 + 123 x5 <= 200
  Result is binary (0 or 1): x1 x2 x3 x4 x5

  usage:
  glpsol -m mip_capital_budgeting.mod -o mip_capital_budgeting.sol > mip_capital_budgeting.stdout.txt


*/
set PROJECT;

param Budget {i in PROJECT};
param Resources {i in PROJECT};
param NPV     {i in PROJECT};

var x {i in PROJECT} >=0;

maximize z: sum{i in PROJECT} NPV[i]*x[i];

s.t. Bud : sum{i in PROJECT} Budget[i]*x[i] <= 800;
s.t. Res : sum{i in PROJECT} Resources[i]*x[i] <= 200;


data;
set PROJECT := p1 p2 p3 p4 p5;

param Budget:=
p1  398
p2	151
p3	129
p4	275
p5	291;

param Resources:=
p1	111
p2	139
p3	56
p4	54
p5	123;

param NPV:=
p1	928
p2	908
p3	801
p4	543
p5	944;

end;
