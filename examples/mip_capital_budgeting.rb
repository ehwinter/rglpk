require 'rglpk'

#
# linear programming capital budgeting problem:
# 
# Maximize NPV of projects (x1..x5) by taking into account Budget and
# Resource constraints (c1, c2). Solution can only be 0 or 1
# 
# Maximize: 928 x1 + 908 x2 + 801 x3 + 543 x4 + 944 x5
# 
# Constraints:
# c1: 398 x1 + 151 x2 + 129 x3 + 275 x4 + 291 x5 <= 800
# c2: 111 x1 + 139 x2 + 56 x3 + 54 x4 + 123 x5 <= 200
# 
# Expected optimal mip result: X = [0,0,1,0,1]
# 
require 'rglpk'

p = Rglpk::Problem.new
p.name = "Project selection"
p.obj.dir = Rglpk::GLP_MAX

rows = p.add_rows(2)
rows[0].name = "Budget"
rows[0].set_bounds(Rglpk::GLP_DB, 0, 800)
rows[1].name = "Resources"
rows[1].set_bounds(Rglpk::GLP_DB, 0, 200)

cols = p.add_cols(5)
cols[0].name = "x1"
cols[0].kind = Rglpk::GLP_BV
cols[0].set_bounds(Rglpk::GLP_DB, 0, 1)
cols[1].name = "x2"
cols[1].kind = Rglpk::GLP_BV
cols[1].set_bounds(Rglpk::GLP_DB, 0, 1)
cols[2].name = "x3"
cols[2].kind = Rglpk::GLP_BV
cols[2].set_bounds(Rglpk::GLP_DB, 0, 1)
cols[3].name = "x4"
cols[3].kind = Rglpk::GLP_BV
cols[3].set_bounds(Rglpk::GLP_DB, 0, 1)
cols[4].name = "x5"
cols[4].kind = Rglpk::GLP_BV
cols[4].set_bounds(Rglpk::GLP_DB, 0, 1)

p.obj.coefs = [928, 908, 801, 543, 944]

p.set_matrix([398, 151, 129, 275, 291,111, 139, 56, 54, 123])

# p.simplex  not this, it is an intger programming.
p.mip(presolve: Rglpk::GLP_ON)  # ruby 1.9+
# z = p.obj.get
z = p.obj.mip   # aka glp_mip_obj_val
x1 = cols[0].mip_val 
x2 = cols[1].mip_val
x3 = cols[2].mip_val
x4 = cols[3].mip_val
x5 = cols[4].mip_val

printf("z = %g; x1 = %g; x2 = %g; x3 = %g; x4 = %g; x5 = %g\n", z, x1, x2, x3, x4, x5)

Glpk_wrapper.glp_print_mip(p.lp, "print_mip.txt")
#Glpk_wrapper.glp_print_sol(p.lp, "print_sol.txt")
p.write_lp("write_lp.txt")
