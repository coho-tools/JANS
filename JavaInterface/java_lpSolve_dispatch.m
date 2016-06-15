function java_lpSolve_dispatch(f, lp) 
% java_lpSolve_dispath(f, lp) 
% lp is COHO LP only, not dual

  A = -lp.A; b = -lp.b; % Java side uses Ax >= b
  bwd = lp.bwd; fwd = lp.fwd;
  dim = size(A,2);
  Aeq = zeros(0,dim); beq = zeros(0,1);
  pos = zeros(dim,1);
  
  % write the problem to Java
  java_writeComment('BEGIN lp_opt'); % comment in matlab2java
  java_writeLabel; % comment in java2matlab
  java_writeMatrix(A,'A'); % Ax >= b 
  java_writeMatrix(b,'b');
  java_writeMatrix(Aeq,'Aeq'); % Aeq x = beq
  java_writeMatrix(beq,'beq');
  java_writeBoolMatrix(pos,'pos'); % x[pos] >= 0?
  if(~isempty(bwd))
  	% Jave engine doesn't need bwd. Do not send for small IO cost
  	java_writeMatrix(fwd,'fwd'); % fwdT 
  	java_writeLine('lp = lpGeneral(Aeq, beq, A, b, pos,fwd);'); 
  else
  	java_writeLine('lp = lpGeneral(Aeq, beq, A, b, pos);'); 
  end
  java_writeMatrix(f,'f'); % obj
  java_writeLine('lpSoln = lp_opt(lp, f);');
  java_writeLine('println(lp_status(lpSoln));');
  fmt = java_format('read');
  java_writeLine( sprintf('println(lp_cost(lpSoln),%s);', fmt) );
  java_writeLine( sprintf('println(lp_point(lpSoln),%s);',fmt) );
  java_writeLine( sprintf('println(lp_basis(lpSoln),%s);',fmt) );
  java_writeDummy; % force java to compute 
  java_writeComment('END lp_opt');
end
