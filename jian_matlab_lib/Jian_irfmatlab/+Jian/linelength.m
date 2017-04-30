function [len] = linelength(x,y,z)
%Jian.LINELENGTH Calculate the length of a line.
%   
%   len = Jian.LINELENGTH(x,y,z) Calculates the length of a line given data
%   in x, y and z (z can be omitted).
%
%   len = Jian.LINELENGTH(X) Where X is a column matrix of the form 
%   X=[t,x,y,z].

n = length(x);

if(nargin == 2)
    z = zeros(1,n);
end

if(nargin == 1)
    y = x(:,3);
    z = x(:,4);
    x = x(:,2);
end

if(length(y) ~= n || length(z) ~= n)
    error('Vectors not the same length.')
end

len = sum(sqrt(diff(x).^2+diff(y).^2+diff(z).^2));

end

