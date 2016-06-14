function [v,x,status,optBasis] = java_lpSolve_get(f) 
% [v,x,status,optBasis] = java_lpSolve_get(f) 
% read the result from java

% default value 
status = java_readNum;
if(status>3 || status <0)
  error('java_linp: unknow status in java side, debug it');
end;

% Result only valid for status==0
if(status==0)
  fmt = java_format('read');
  java_writeLine( sprintf('println(lp_cost(lpSoln),%s);', fmt) );
  java_writeLine( sprintf('println(lp_point(lpSoln),%s);',fmt) );
  java_writeLine( sprintf('println(lp_basis(lpSoln),%s);',fmt) );
  java_writeDummy; % force java to compute 
  java_writeComment('END lp_opt');
  v = java_readNum;
  x = java_readMatrix;
  optBasis = java_readMatrix;
  optBasis = optBasis+1; % the index in java is from 0.
else
  dim = length(f);
  v = 0; x = zeros(dim,1); optBasis=zeros(dim,1);
end
