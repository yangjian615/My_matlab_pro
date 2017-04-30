function Y = eqn_interpolateNaN(X, margins)
%eqn_interpolateNaN Linearly interpolates NaN values in X.
%
%   Y = eqn_interpolateNaN(X), finds all NaN values in X and interpolates
%   them linearly, based on the values of their neighboring points. If the
%   NaN values are at either the begining or end of 'X', so that there are
%   is only one adjacent point (after or before the NaN segment) the
%   function assigns the value of the existing point to all NaN points. 
%

if nargin < 2
    margins = 0;
end

if numel(margins) == 1
    margins = [margins, margins];
end

L = length(X);
Y = X;

posLogicalInd = isnan(X);
if sum(posLogicalInd) == L
    % everything is NaN !!!
    Y = zeros(L,1);
else

pos = find(isnan(X));
if ~isempty(pos)
    gaps = eqn_breakToConsecutiveIndices(pos);
    [nGaps, nCols] = size(gaps);
    if nCols ~= 2; error('eqn_interpolateNaN(): Unknown Error!'); end;
    
    if ~all(margins == 0)
        % expand margins
        for i=1:nGaps
            X(max(gaps(i,1) - margins(1), 1) : min(gaps(i,2) + margins(2), L) ) = NaN;
        end
        % recalculate gap indices
        pos = find(isnan(X));
        gaps = eqn_breakToConsecutiveIndices(pos);
        [nGaps, nCols] = size(gaps);
        if nCols ~= 2; error('eqn_interpolateNaN(): Unknown Error 2!'); end;
    end
    
    for i=1:nGaps
        gapLength = gaps(i,2) - gaps(i,1) + 1;
        % find points left & right of gap
        left = NaN; right = NaN;
        if gaps(i,1) > 1; left = X(gaps(i,1) - 1); end;
        if gaps(i,2) < L; right = X(gaps(i,2) + 1); end;

        % if both exist => interpolate linearly
        if ~isnan(left) && ~isnan(right)
            Y(gaps(i,1)-1:gaps(i,2)+1) = linspace(left,right,gapLength + 2);
        % if only one exists => clone existing values
        elseif ~isnan(left)
            Y(gaps(i,1):gaps(i,2)) = left;
        elseif ~isnan(right)
            Y(gaps(i,1):gaps(i,2)) = right;
        else
            error('eqn_breakToConsecutiveIndices(): Unknown Error!');
        end

    end
    %disp(['Interpolated ',num2str(N,'%d'),' data points (',num2str(100*N/L,'%.2f'),'%)']);
else
    
end
end
end

