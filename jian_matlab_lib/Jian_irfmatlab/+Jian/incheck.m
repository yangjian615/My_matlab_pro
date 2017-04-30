function [varargout] = incheck(inp,varargin)
%Jian.INCHECK Matches inputs to parameters.
%
%   paramval = Jian.INCHECK(inp,A,B,...) Returns parameter values given
%   input vector or cell inp and vector or cell lists of possible
%   parameters A,B,... . Returns parameters in the order same order as
%   parameter lists. Return default if not found. Default value is the
%   first element in the parameter list.
%
%   Use cells if one or more parameters are defined by a string. Otherwise,
%   vectors are fine. Does not work with mixed number/string input now.
%
%   Examples:
%       pv = Jian.incheck([12,3],[0,1,2],[10,11,12])
%       [warning: incheck(66)] Parameter: "3" not found. Set to default value.
%       pv = [0    12]
%
%       [lorem,ipsum] = Jian.incheck({'full'},{'da','hej'},{'sw','full'})
%       lorem = 'da'
%       ipsum = 'full'
%
%   See also: Jian.PLOT_SIM_VEL
%                _for a working example
%
%   TODO:   Allow mixed number/string input. 
%           Allow single string input.
%


%% Handles input
%inp = varargin{1};  % First is a unsorted list of inputs.
N = length(varargin); % Number of possible parameters
n = length(inp);    % Number of given inputs

isc = 0;

if(iscell(inp) || ischar(inp)) % Is it a cell?
    isc = 1;
end

% If not found, returns default

if(isc) %Output is cell if input is
    %out = repmat({NaN},1,N-1);
    out = cell(1,N);
    for i = 1:N
        out{i} = varargin{i}{1};
    end
    
else % Otherwise a vector
    %out = nan(1,N-1);
    out = zeros(1,N);
    for i = 1:N
        out(i) = varargin{i}(1);
    end
end

%%Checks for matches
for i = 1:n
    for j = 1:N
        parvec = varargin{j};
        p = is_in(inp(i),parvec); % Does this work for a cell?
        
        if(length(p) > 1)
            error('Wrong input type.')
        end
        
        if(~isempty(p)) % If found, store and break j-loop
            if isc
                out{j} = p{1};
            else
                out(j) = p;
            end
            break
        end
        if(j==N)
            % Parameter not found
            if(isc)
                pnf = inp{i};
            else
                pnf = num2str(inp(i));
            end
            
            irf.log('w',['Parameter: "',pnf, '" not found. Set to default value.'])
        end
    end
end

%% Output
if(nargout == 1)
    varargout{1} = out{1};
elseif(nargout == N)
    if(isc)
        varargout = out;
    else
        varargout = cell(1,N);
        for i = 1:N
            varargout{i} = out(i);
        end
    end
end

end

function out = is_in(x,y)
% Is x in y? Returns x if it is, otherwise empty cell or matrix.

out = x(ismember(x,y));

end
