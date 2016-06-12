function hulls = java_lpsProject(lps,xs,ys,tols)
% hulls = java_lpsProject(lps,xs,ys,tols)
% This method projects a set of lps onto planes. 
% It uses multiple Java threads for speedup performance. 

  N = length(lps);  hulls = cell(N,1);
  if(length(tols)==1)
    tols =repmat(tols,N,1);
  end
  if(~iscell(xs))
    xs = repmat({xs},N,1); 
  end
  if(~iscell(ys))
    ys = repmat({ys},N,1);
  end
  jNum = jans_cfg('get','javaThreads');

  % the input buffer can not hold too many requests 
  cap = jNum*500;
  %cap = jNum*10;
  sidx = [1:cap:N,N+1];

  for iter = 1:length(sidx)-1
    % dispatch requests
    for i= sidx(iter):sidx(iter+1)-1
      lp = lps{i}; 
      x = xs{i}; y = ys{i}; tol = tols(i);
      curr = mod(i,jNum); curr = curr+jNum*(curr==0);
      fprintf('dispatch %i-th job with TC = %i to the %i-th thread\n',i,jans_cfg('get','javaTC')+1,curr)
      java_useThread(curr); 
      java_lpProject_dispatch(lp,x,y,tol);
    end
    
    % get results
    for i= sidx(iter):sidx(iter+1)-1
      x = xs{i}; y = ys{i}; 
      curr = mod(i,jNum); curr = curr+jNum*(curr==0);
      fprintf('get %i-th result from the %i-th thread\n',i, curr)
      java_useThread(curr);
      hulls{i} = java_lpProject_get(x,y);
    end
  end
end
