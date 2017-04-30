function [index] = fci(num,vec,varargin)
%Jian.FCI Finds relevant index of a vector
%   
%   index = Jian.FCI(num, vec) Returns the index of the vector
%   vec where vec is the closest to the number num. vec must be increasing
%   or decreasing. num can be a vector or a scalar.
%
%   index = Jian.FCI(num, vec, mode) Define how out of bounds number are
%   handled. 
%
%   Modes:
%       'ext'   - Out of numbers outside the domain of vec is set to the
%               extreme values: 1 or n = length(vec) dependant on sorting. 
%               This is the default mode.
%       'nan'   -  Out of numbers outside the domain of vec is set to NaN.
%
%   Function used to be called: Jian.find_closest_index. This version is
%   vectorized and has much better performance.


% Possible pararmeters, default is the first element.
pm = {'ext','nan'};

% Get parameters, deafult if not set.
mode = Jian.incheck(varargin,pm);


n = length(vec);
maxV = max(vec);
minV = min(vec);

if vec(1)<vec(n)
    srt = 'inc';
else
    srt = 'dec';
end

% Vector of indicies
Y = 1:n;

index = interp1(vec,Y,num,'nearest');

% Handles out of bound numbers.
switch mode
    case 'ext'
        if strcmp(srt,'inc')
            index(num<minV) = 1;
            index(num>maxV) = n;
        else
            index(num<minV) = n;
            index(num>maxV) = 1;
        end
    %Indices are set to NaN by the interp1 function.
end
end