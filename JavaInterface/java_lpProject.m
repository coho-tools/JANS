function hull = java_lpProject(lp, x, y,tol)
% hull = java_lpProject(lp, x, y,tol)
%  Project the LP onto the plane defined by x-y
%
%  Inputs:
%    lp is a linear program
%      with 'A','b','bwd','fwd', 
%      'bwd' and 'fwd' could be empty
%    x and y are vectors of the same size
%
%  Outputs:
%    hull: a matrix
%      The columns hull are the vertices of a counterclockwise tour of the projection of the lp. 
%		 	 Return [] if the lp is not feasible.

java_lpProject_dispatch(lp,x,y,tol); 
hull = java_lpProject_get(x,y); 

