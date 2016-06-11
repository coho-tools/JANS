function [javaIn, javaOut] = java_open(debug)
% JAVA = java_open
%
% creates global file handles for pipes to and from the java CG engine
%
% the pipe to the engine is called javaIn (write to this pipe)
% the pipe from the engine is called javaOut (read from this pipe)
%
if(nargin<1||isempty(debug))
	debug = 0;
end
if( (jans_cfg('has','javaIn') && ~isempty(jans_cfg('get','javaIn'))) || ... 
	  (jans_cfg('has','javaOut') && ~isempty(jans_cfg('get','javaOut'))) )
	java_close; % close old one first;
end

jNum = jans_cfg('get','javaThreads'); 

fork_bin = jans_info('fork_bin');
java_classpath = jans_info('java_classpath'); 
% sys_path= jans_info('sys_path');

% create a dir 
threadPath = jans_cfg('get','threadPath');

fprintf('Creating Java Threads: ')
javaIn = zeros(jNum,1); javaOut = zeros(jNum,1);
for i=1:jNum
  fprintf('  %i',i)
  m2j = [threadPath,'/matlab2java_',num2str(i)];
  j2m = [threadPath,'/java2matlab_',num2str(i)];
  m2jlog = [threadPath,'/m2j_',num2str(i),'.log']; 
  j2mlog = [threadPath,'/j2m_',num2str(i),'.log'];
  
  % create fifo
  cmd = ['mkfifo -m 0600 ',m2j];
  status = unix(cmd);
  if(status)
  	error(['Failed to run command',cmd]);
  end
  cmd = ['mkfifo -m 0600 ',j2m]; 
  status = unix(cmd);
  if(status) 
  	error(['Failed to run command',cmd]); 
  end 
  
  % run java
  if(debug) 
  	shcmd = sprintf('java -cp %s coho.interp.MyParser -l %s -o %s < %s > %s',...  
  					java_classpath,m2jlog,j2mlog,m2j,j2m); 
  else 
  	shcmd = sprintf('java -cp %s coho.interp.MyParser < %s > %s',...
  					java_classpath,m2j,j2m);
  end
  % csh will make matlab exit directly, therefore, we force to use bash 
  cmd = [fork_bin,' -c "', shcmd, '"'];
  status = unix(cmd);
  if(status)
  	error(['Failed to run command ',cmd]);
  end
  
  javaIn(i) = fopen(m2j, 'w'); javaOut(i) = fopen(j2m, 'r');
  if(javaIn(i) < 0) 
  	error('failed to open javaIn'); 
  end
  if(javaOut(i) < 0) 
  	error('failed to open javaOut'); 
  end
end
fprintf('\n')

jans_cfg('set','javaIn',javaIn,'javaOut',javaOut,'javaTC',0, 'javaCrashed', 0,'currThread',1); 
