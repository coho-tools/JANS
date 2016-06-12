function java_lpProject_dispatch(lp, x, y,tol)
% java_lpProject_dispatch(lp, x, y,tol)
%  Send a lp project problem to Java engine
%  Inputs:
%    lp is a linear program 
%      with 'A','b','bwd','fwd', 
%      'bwd' and 'fwd' could be empty
%    x and y are vectors of the same size
%
  n = size(lp.A,2);
  
  % send COHO LP to java process
  A = -lp.A; b = -lp.b; % Java side uses Ax >= b
  bwd = lp.bwd; fwd = lp.fwd;
  Aeq = zeros(0,n); beq = zeros(0,1);
  pos = zeros(n,1);
  
  java_writeComment('BEGIN lp_project'); % comment in matlab2java
  java_writeLabel; % comment in java2matlab
  java_writeMatrix(A,'A'); % Ax >= b 
  java_writeMatrix(b,'b');
  java_writeMatrix(Aeq,'Aeq'); % Aeq x = beq
  java_writeMatrix(beq,'beq');
  java_writeBoolMatrix(pos,'pos'); % x[pos] >= 0?
  if(~isempty(fwd))
  	% Jave engine doesn't need bwd. Do not send for small IO cost
  	java_writeMatrix(fwd,'fwd'); % fwdT 
  	java_writeLine('lp = lpGeneral(Aeq, beq, A, b, pos,fwd);'); 
  else
  	java_writeLine('lp = lpGeneral(Aeq, beq, A, b, pos);'); 
  end
  % projection directions
  java_writeMatrix(x,'xx');
  java_writeMatrix(y,'yy');
  % project
  java_writeLine(sprintf('lpProj = lp_project(lp, xx, yy, %f);',tol));
  java_writeLine(sprintf('println(lp_point(lpProj),%s);',java_format('read')));
  java_writeDummy;
  java_writeComment('END lp_project'); % comment in matlab2java
end
