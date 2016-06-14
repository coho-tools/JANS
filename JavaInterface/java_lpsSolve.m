function [vs,xs,ss,opts] = java_lpsSolve(fs,lps) 
% [vs,xs,ss,opts] = java_lpsSolve(lps,xs,ys,tols)
% This method Solve a series of LPs; 
% It uses multiple Java threads for speedup performance. 
  N = length(lps);
  if(~iscell(fs))
    fs = repmat({fs},N,1);
  end
  vs = zeros(N,1); xs = cell(N,1); ss = zeros(N,1); opts = cell(N,1);

  jNum = jans_cfg('get','javaThreads');

  % the input buffer can not hold too many requests 
  cap = jNum*64;
  sidx = [1:cap:N,N+1];

  for iter = 1:length(sidx)-1
    % dispatch requests
    for i= sidx(iter):sidx(iter+1)-1
      lp = lps{i}; 
      f = fs{i}; 
      curr = mod(i,jNum); curr = curr+jNum*(curr==0);
      fprintf('dispatch %i-th LP job with TC = %i to the %i-th thread\n',i,jans_cfg('get','javaTC')+1,curr)
      java_useThread(curr); 
      java_lpSolve_dispatch(f,lp); 
    end
    
    % get results
    for i= sidx(iter):sidx(iter+1)-1
      curr = mod(i,jNum); curr = curr+jNum*(curr==0);
      fprintf('get %i-th LP result from the %i-th thread\n',i, curr)
      java_useThread(curr);
      [vs(i,1),xs{i,1},ss(i,1),opts{i,1}] = java_lpSolve_get();
    end
  end
end
