function java_writeLabel
% java_writeLabel
% This function begin a new transaction to java
% each transaction must call this function before. 
TC = jans_cfg('get','javaTC')+1;
jans_cfg('set','javaTC',TC);
str = sprintf('println(''%%TRANSACTION %d\\n'');',TC); 
java_writeLine(str);
