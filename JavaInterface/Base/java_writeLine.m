function java_writeLine(str)
% java_writeLine(str)
% This function writes a new line to java
% It add '\n' to the string automatically.

results = jans_cfg('get','javaIn','currThread');
javaIn = results{1}; idx  = results{2};
fprintf(javaIn(idx), '%s\n',str);
