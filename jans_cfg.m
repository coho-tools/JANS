% function [val,status] = jans_cfg(op,varargin)
%   This file keeps a global structure to store info shared over JANS pkgs. 
%   It can be use to config JANS or store global data
%   It supports two operations: 
%     GET: 
%       S = jans_cfg('get');        % get the whole struct
%       value = jans_cfg('get',key) % get the value
%       {v1,v2,...} = jans_cfg('get',k1,k2,...) % get multiple values
%     SET:
%       S = jans_cfg('set',k1,v1,k2,v2,...);  
% 
%   JANS configs 
%     javaFormat: Format of numbers passed between Java and Matlab threads
%       values:  'hex', 'dec'
%       default: 'hex'
%     javaThreads: Number of java processes
%       value:    positive number
%       default:  1
%     threadPath: unique path for this thread for storing related info
%       value:    file path
%       default: cra_info('sys_path')
%       NOTE: this is read-only for users


function [val,status] = jans_cfg(op,varargin)
	% NOTE: Because of the Matlab 2013 version bug, I have to use global vars. 
  %       Please don't modify the value by other functions. 
	%       Persistent vars will be re-inited the first time when path changed.
  global JANS_CFG;
  if(isempty(JANS_CFG))
		JANS_CFG= jans_cfg_default;
		disp('init jans_cfg');
	end
  [val,status,update] = utils_struct(JANS_CFG,op,varargin{:});
  if(status==0&&update)
		jans_cfg_check(val);
		JANS_CFG = val; % save the update
	end
end % jans_cfg;

function cfg = jans_cfg_default
  % Matlab-Java IO format
	javaFormat = 'hex';

  % # of multiple threads and their path
  javaThreads = 2;
	threadPath = jans_info('sys_path'); % thread unique path

  cfg = struct( 'javaFormat', javaFormat, 'javaThreads', javaThreads, 'threadPath', threadPath); 
end % jans_cfg_default;


function jans_cfg_check(val) 
end % jans_cfg_check 
