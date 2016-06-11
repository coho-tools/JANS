% JANS_CLOSE: Release all JANS resources 
%   jans_close;
function jans_close
	disp('Close Java process');
	java_close;
	%jans_rmpath; % do not remove path
	disp('JANS resources have been released!');
end %function jans_close

function jans_rmpath
	jans_home = jans_info('jans_home'); 
	jans_dirs = jans_info('jans_dirs'); 
  disp('Remove JANS directories from Matlab search path');
  for i=1:length(jans_dirs)
    dirname = [jans_home,'/',jans_dirs{i}];
    %disp(sprintf('  > %s',dirname));
    rmpath(dirname); 
  end
  % rmpath(jans_home);  % leave the jans_home to call jans_open
end %function jans_rmpath
