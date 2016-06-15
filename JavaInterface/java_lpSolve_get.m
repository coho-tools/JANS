function [v,x,status,optBasis] = java_lpSolve_get(f) 
% [v,x,status,optBasis] = java_lpSolve_get(f) 
% read the result from java

status = java_readNum;
assert(status>=0&&status<=3);
v = java_readNum;
x = java_readMatrix;
optBasis = java_readMatrix;
optBasis = optBasis+1; % the index in java is from 0.
