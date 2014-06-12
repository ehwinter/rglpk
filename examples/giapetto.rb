require 'rglpk'
#
# Giapetto’s problem
#
# This finds the optimal solution for maximizing Giapetto’s profit
#
# /* Decision variables */
# var x1 >=0; /* soldier */
# var x2 >=0; /* train */
# 
# /* Objective function (profit)*/
# maximize z: 3*x1 + 2*x2;
# 
# /*Constraints*/
# s.t. Finishing: 2*x1 + x2 <= 100;
# s.t. Carpentry: x1 + x2 <= 80;
# s.t. Demand: x1 <= 40;

def giapetto
  p = Rglpk::Problem.new
  p.name = "Giapetto"
  p.obj.dir = Rglpk::GLP_MAX # maximization problem (profit)
  
  rows = p.add_rows(3)
  rows[0].name = "Finishing"
  rows[0].set_bounds(Rglpk::GLP_UP, 0, 100)
  rows[1].name = "Carpentry"
  rows[1].set_bounds(Rglpk::GLP_UP, 0, 80)
  rows[2].name = "Demand"
  rows[2].set_bounds(Rglpk::GLP_UP, 0, 40)
  
  cols = p.add_cols(2)
  cols[0].name = "x1 Soldiers"
  cols[0].set_bounds(Rglpk::GLP_LO, 0.0, 0.0)
  cols[1].name = "x2 Trains"
  cols[1].set_bounds(Rglpk::GLP_LO, 0.0, 0.0)
  
  p.obj.coefs = [3,2]
  
  p.set_matrix([
                2, 1,
                1,1,
                1,0
               ])
  
  p.simplex
  p
end

# for pretty printing Problem's results. 
def results(problem)

  result = problem.name
  result << "\n====================================="
  result << "\nConstraints"
  result << "\n-------------------------------------\n"

  problem.rows.each_with_index do |row,i|
      result << sprintf("%g - Constraint %d %s", row.get_prim, i+1, row.name)
      #retrieve row primal value
      case row.bounds[0]
        when Rglpk::GLP_UP
          result << sprintf(" bounds: <= %g\n", row.bounds[2])
        when Rglpk::GLP_LO
          result << sprintf(" bounds: >= %g\n", row.bounds[1])
        when Rglpk::GLP_DB
          result << sprintf(" bounds: %g <= %g\n", row.bounds[1], row.bounds[2])
        when Rglpk::GLP_FR
           result << sprintf(" unbounded (free variable)\n")         
      end
  end
  result << "\nObjective"
  result << "\n-------------------------------------\n"
  result << sprintf("%g z - Objective result\n", problem.obj.get)

  result << "\nDecision Variables"
  result << "\n-------------------------------------\n"
  problem.cols.each_with_index do |column,i|
    result << sprintf("%g x%d - Decision variable %s\n", column.get_prim, i+1, column.name)
  end
  result << "\n"
end

p=giapetto #solve it
puts results(p) #output results
