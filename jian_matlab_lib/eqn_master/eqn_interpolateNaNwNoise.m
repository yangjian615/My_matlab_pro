function Y = eqn_interpolateNaNwNoise(X)
%eqn_interpolateNaN Linearly interpolates NaN values in X.
%
%   Y = eqn_interpolateNaN(X), finds all NaN values in X and interpolates
%   them linearly, based on the values of their neighboring points. If the
%   NaN values are at either the begining or end of 'X', so that there are
%   is only one adjacent point (after or before the NaN segment) the
%   function assigns the value of the existing point to all NaN points. 
%

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
    maxGapLength = max(diff(gaps, [], 2));
    [M, S] = eqn_movingStatsNaN(X, maxGapLength);
    
    [nGaps, nCols] = size(gaps);
    if nCols ~= 2; error('eqn_interpolateNaN(): Unknown Error!'); end;
    
    for i=1:nGaps
        gapLength = gaps(i,2) - gaps(i,1) + 1;
        % find points left & right of gap
        left = NaN; right = NaN;
        if gaps(i,1) > 1; 
            left = X(gaps(i,1) - 1); 
            leftS = S(gaps(i,1) - 1); 
        end;
        if gaps(i,2) < L; 
            right = X(gaps(i,2) + 1); 
            rightS = S(gaps(i,2) + 1); 
        end;

        % if both exist => interpolate linearly
        if ~isnan(left) && ~isnan(right)
            Y(gaps(i,1)-1:gaps(i,2)+1) = linspace(left,right,gapLength + 2) + ...
                leftS * randn(1, gapLength + 2);
        % if only one exists => clone existing values
        elseif ~isnan(left)
            Y(gaps(i,1):gaps(i,2)) = left + leftS * randn(gapLength, 1);
        elseif ~isnan(right)
            Y(gaps(i,1):gaps(i,2)) = right + rightS * randn(gapLength, 1);
        else
            error('eqn_breakToConsecutiveIndices(): Unknown Error!');
        end

    end
    %disp(['Interpolated ',num2str(N,'%d'),' data points (',num2str(100*N/L,'%.2f'),'%)']);
else
    
end
end
end

