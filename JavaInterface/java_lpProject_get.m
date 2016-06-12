function hull = java_lpProject_get(x, y)
% hull = java_lpProject_get(x, y)
%  Get the result of last lp_project
%
%  Inputs:
%    x and y are vectors of the same size
%
%  Outputs:
%    hull: a matrix
%      The columns hull are the vertices of a counterclockwise tour of the projection of the lp. 
%		 	 Return [] if the lp is not feasible.
%

  hull = java_readMatrix; 
  if(size(hull,2)<3) 
  	hull = zeros(2,[]); 
  	return; 
  end; 
  
  % convert 2D
  hull = [x,y]\hull; 
end 
