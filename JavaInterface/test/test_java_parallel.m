function test_javaif
  disp('****Testing JavaInterface package with paralllel threads.****'); 
	disp('**Test Java linear programming solver.**');
  jans_cfg('set','javaThreads',10);
  jans_open()
	test_lp
  jans_close()
end

function test_lp
	disp('1. Try to solve LPs');
	A = [eye(2);-eye(2)]; b = [ones(2,1);zeros(2,1)];
	lp.A = A; lp.b = b; lp.bwd = []; lp.fwd = []; 
  lps = repmat({lp},10,1); f = [1;1];
	[vs,xs,ss,opts] = java_lpsSolve(f,lps); 
  if(~all(ss==0))
		  error('The result from Java LP solver is incorrect'); 
  end
  
  disp('2. Try to solver projection problem');	
	A = [eye(2);-eye(2)]; b = [ones(2,1);zeros(2,1)];
	lp.A = A; lp.b = b; lp.bwd = []; lp.fwd = []; 
  lps = repmat({lp},10,1); x = [1;0]; y = [0;1];
	hulls = java_lpsProject(lps, x, y,1e-3);
  for i=1:length(hulls)
    hull = hulls{i};
	  if(~all(all(hull==[0,1,1,0;0,0,1,1]))) 
		  error('The result from Java projection solver is incorrect'); 
	  end
  end
end
	
	
