function A = java_readMatrix
%function A = java_readMatrix
% This function read a matrix from a file
% we rely on the fact that the matrix contents proper
% is between '(' and ')';
%
text = {java_readLine};
i = 2;

while 1
  RPARpos = strfind(text{i-1}, ')' );
  if ~isempty(RPARpos)
    text = cellstr(cell2mat(text));
	  text = text{1};
    
	  if ~isempty(strfind(text,'matrix')) && ~isempty(strfind(text, '$'))
      % to_matrix assumes the text is a hex matrix. do not use otherwise.
		  A = to_matrix(text);
	  else
		  % old slower code which relied on matlab eval
		  RPARpos = strfind(text, ')' );
      LPARpos = strfind(text, '(' );
      text = [ 'A = ' text(LPARpos+1:RPARpos-1) ';'];
      eval(java_hex2num(text));
    end
	  break;
  end

  text{i} = java_readLine;
  if (isnumeric(text{i}) && text{i} < 0) 
	  error('java_readMatrix: unexpected end of file');
  end
  i = i+1;
end
