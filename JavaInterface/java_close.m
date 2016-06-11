function java_close
% function java_close
% tells the java CG engine to exit and closes the java pipes
% assumes that the global file handles have been set by java_open()
%
javaIn = jans_cfg('get','javaIn');
javaOut = jans_cfg('get','javaOut'); 
javaCrashed = jans_cfg('get','javaCrashed');
jNum = jans_cfg('get','javaThreads');

if(javaCrashed)
	disp('Warning: Java thread crashed. Please kill the process manually!');
end
if(isempty(javaIn) && isempty(javaOut))
  return
end

if(length(javaIn)~=jNum || length(javaOut)~=jNum ) 
  error('The number of JavaIn(JavaOut) does not match');
end

fprintf('Closing Java Threads: ')
for i=1:jNum
  fprintf(' %i ',i)
  java_useThread(i);
  if(javaOut(i)>3)
	  java_writeLine('exit();');
  end
  if(javaIn(i)>2) 
	  fclose(javaIn(i));
  end
  if(javaOut(i)>3)
	  fclose(javaOut(i));
  end
  threadPath = jans_cfg('get','threadPath');
  cmd = sprintf('unlink %s/matlab2java_%i',threadPath,i);
  unix(cmd);
  cmd = sprintf('unlink %s/java2matlab_%i',threadPath,i);
  unix(cmd);
end
fprintf('\n')


% we keep tmpDir and TC now, will be reset when java_open 
jans_cfg('set','javaIn',[],'javaOut',[]);
