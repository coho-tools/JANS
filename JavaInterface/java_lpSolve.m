function [v,x,status,optBasis] = java_lpSolve(f, lp) 
% [v,x,status,optBasis] = java_linp(f, lp) 
% This function implements linear programming solver for coho LP.
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
%   optBasis: optimal basis if status =1, zeros(nx1) matrix otherwise.

% Java side accept lp in the form of 
%   min(f*x), s.t.
%     Aeq*bwd*x=beq
%     A*bwd*x>=b
%     x_i >=0 if pos[i], free otherwise 
%   Aeq/beq, A/b, pos are required, bwd/fwd are optional
%   For Coho LP: 1) Aeq/beq must be empty, 2) pos must be all false, 3) A are Coho matrix
%   For Coho Dual LP: 1) A/b must be empty, 2) post must be all true, 3) A' are Coho matrix
%     
if(nargin < 2)
    error('java_linp: not enough arguments');
end

% COHO LP only, not dual
A = -lp.A; b = -lp.b; % Java side uses Ax >= b
dim = size(A,2);
Aeq = zeros(0,dim); beq = zeros(0,1);
pos = zeros(dim,1);
if(isfield(lp,'bwd'))
  bwd = lp.bwd; fwd = lp.fwd;
else
  bwd = []; fwd = [];
end

% default value 
v = 0; x = zeros(dim,1); optBasis = zeros(dim,1);

% write the problem to Java
java_writeComment('BEGIN lp_opt'); % comment in matlab2java
java_writeLabel; % comment in java2matlab
java_writeMatrix(A,'A'); % Ax >= b 
java_writeMatrix(b,'b');
java_writeMatrix(Aeq,'Aeq'); % Aeq x = beq
java_writeMatrix(beq,'beq');
java_writeBoolMatrix(pos,'pos'); % x[pos] >= 0?
if(~isempty(bwd))
	% if no bwd is given, coho will use fwd alone to compute the costs. this speeds up IO
	%java_writeMatrix(bwd,'bwd'); % bwdT
	java_writeMatrix(fwd,'fwd'); % fwdT 
	%java_writeLine('lp = lpGeneral(Aeq, beq, A, b, pos,bwd,fwd);'); 
	java_writeLine('lp = lpGeneral(Aeq, beq, A, b, pos,bwd);'); 
else
	java_writeLine('lp = lpGeneral(Aeq, beq, A, b, pos);'); 
end
java_writeMatrix(f,'f'); % obj
java_writeLine('lpSoln = lp_opt(lp, f);');
java_writeLine('println(lp_status(lpSoln));');
java_writeDummy; % force java to compute 

% read the result from java
status = java_readNum;
if(status>3 || status <0)
	error('java_linp: unknow status in java side, debug it');
end;

if(status==0)
	fmt = java_format('read');
	java_writeLine( sprintf('println(lp_cost(lpSoln),%s);', fmt) );
	java_writeLine( sprintf('println(lp_point(lpSoln),%s);',fmt) );
	java_writeLine( sprintf('println(lp_basis(lpSoln),%s);',fmt) );
	java_writeDummy; 
	v = java_readNum;
	x = java_readMatrix;
	optBasis = java_readMatrix;
	optBasis = optBasis+1; % the index in java is from 0.
end

java_writeComment('END lp_opt');
