#/bin/sh
echo ""
echo "Installing COHO Java Numerical Engine ......" 
echo ""

echo "====Step0: Set environment variable JANS_HOME====" 
JANS_HOME=`pwd`
export JANS_HOME
echo $JANS_HOME
echo "" 

echo "====Step1: Compile JAVA codes====" 
cd $JANS_HOME/Java
sh build_java.sh
echo "" 

echo "====Step2: Check the Java thread works correctly====" 
cd $JANS_HOME/Java/test 
sh test_java.sh
echo "" 

echo "====Step3: Comple C codes====" 
cd $JANS_HOME/JavaInterface/Fork
echo "Compile C files ..."
make
cd $JANS_HOME/JavaInterface
mex fasthex2num.c
mex to_matrix.cpp
echo "" 

echo "====Step4: Check the pipe between Java and Matlab thread works correctly====" 
cd $JANS_HOME/JavaInterface/Fork/
sh test_javaif.sh
echo "" 


echo "====Step5: Generating JANS configuration file ====" 
cd $JANS_HOME
echo "
% function val = jans_info(field)
%   This function returns read-only information for JANS, including: 
%     jans_home:  root path of CAR software 
%     jans_dirs:  all JANS dirs to be added in Matlab
%     user:       current user
%     java_classpath, fork_bin: use for create pipe between Matlab & Java
%     version:   JANS version
%     license:   JANS license
%  Ex: 
%     info = jans_info;  // return the structure
%     version = jans_info('version'); // has the value
function val = jans_info(field)
  % NOTE: I use global vars because of the Matlab bug. 
	%       (When the code is in linked dir, persistent vars are re-inited 
	%        when firstly changing to a new directory). 
  %       Please don't modify the value by other functions. 
  global JANS_INFO;
  if(isempty(JANS_INFO)) 
    JANS_INFO = jans_info_init; % evaluate once
  end
  if(nargin<1||isempty(field))
    val = JANS_INFO;
  else
    val = JANS_INFO.(field);
  end; 
end

function  info = jans_info_init
  jans_home='`pwd`'; 

  % JANS directories 
  jans_dirs = {
    'JavaInterface',
    'JavaInterface/Fork',
    'JavaInterface/Base' };

  % current user
  [~,user] = unix('whoami');
  user = user(1:end-1);

	% path to save JANS system data or files
  sys_path = ['/var/tmp/',user,'/coho/jans/sys']; 

  % JAVA java_classpath
  java_classpath = [jans_home,'/Java/lib/cup.jar',':',jans_home,'/Java/bin/coho.jar'];
  fork_bin = [jans_home,'/JavaInterface/Fork/fork'];

  version = 1.1;
  license = 'bsd';
  
  info = struct('version',version, 'license',license, ...
                'jans_dirs',{jans_dirs}, 'jans_home',jans_home, ...
                'user',user, 'sys_path', sys_path, 'fork_bin', fork_bin, ...
                'java_classpath', java_classpath); 
end % jans_info
" > jans_info.m

echo "You can update the configurations later by editing jans_info.m file."

echo ""
echo "JANS Installed!" 
echo ""
