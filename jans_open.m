 %JANS_OPEN: Initialization JANS 
 %  jans_open;
function jans_open(debug)
	if(nargin<1||isempty(debug))
		debug = 0;
	end

	disp('Starting JANS ......'); 

	% error and warnings
	if(debug)
		dbstop if error;
	else
		warning off all;
	end
	

	% Add path
	jans_addpath;

	% Create a unique sys dir
	disp('Create system directory for JANS'); 
  cmd = ['mkdir -p ',jans_info('sys_path')];
  unix(cmd);
  cmd = sprintf('mktemp -d %s/%s_XXX',jans_info('sys_path'),datestr(now,'yy-mm-dd')); 
  [status,threadPath] = unix(cmd);
  if(status)
	  error('Can not create a unique  directory for JANS'); 
  end
  threadPath = threadPath(1:end-1); % remove \n
	jans_cfg('set','threadPath',threadPath);
  fprintf('  A unique dir %s has been create for this JANS thread.',threadPath);	

	% Open Java
	disp('Link Matlab and Java threads');
	java_open(debug);

	disp('JANS initialization complete!');
end %function jans_open


function jans_addpath
	jans_home = jans_info('jans_home'); 
	jans_dirs = jans_info('jans_dirs'); 
  disp('Add JANS directories into Matlab search path');
  %disp('Add the following directories into Matlab search path');
  for i=1:length(jans_dirs)
    dirname = [jans_home,'/',jans_dirs{i}];
    %disp(sprintf('  > %s',dirname));
    addpath(dirname); 
  end
  addpath(jans_home); 
end %function jans_addpath
