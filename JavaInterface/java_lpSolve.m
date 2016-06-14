function [v,x,status,optBasis] = java_lpSolve(f, lp) 
% [v,x,status,optBasis] = java_linp(f, lp) 
% This function implements linear programming solver for coho LP.
%
% Paramaeters: 
%   f: a vector for the optimization direction
%   lp is:  linear program to be solved 
%     COHO LP
%       min(f*x), s.t.
%         A*x<=b
%       where A is a Coho matrix
%       A,b are required
%     Advanced COHO LP
%       min(f*x), s.t.
%         A*bwd*x<=b
%       bwd and fwd=inv(bwd) must be provided.  
%
% Returns: 
%   v: optinal value
%   x: optinal point
%   status:
%     0: 	optimal
%     1:	unbounded
%     2:	infeasible
%     3:	infeasible or unbounded
%     v: optimal value if status=1, -Inf if status=2; 0 otherwise
%     x: optimal point if status =1, zeros(nx1) matrix otherwise;
%   optBasis: optimal basis
%   NOTE: v,x,optBasis is valid only if status==0 

% Java side accept lp in the form of 
%   min(f*x), s.t.
%     Aeq*bwd*x=beq
%     A*bwd*x>=b
%     x_i >=0 if pos[i], free otherwise 
%   Aeq/beq, A/b, pos are required, bwd/fwd are optional
%   For Coho LP: 1) Aeq/beq must be empty, 2) pos must be all false, 3) A are Coho matrix
%   For Coho Dual LP: 1) A/b must be empty, 2) post must be all true, 3) A' are Coho matrix
%     

java_lpSolve_dispatch(f,lp);
[v,x,status,optBasis] = java_lpSolve_get(); 
if(status~=0)
  dim = size(lp.A,2);
  v = 0; x = zeros(dim,1); optBasis=zeros(dim,1);
end
