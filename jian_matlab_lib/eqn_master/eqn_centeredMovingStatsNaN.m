function [M, S] = eqn_centeredMovingStatsNaN(X, halfWindowSize, prc_to_accept)
%eqn_movingStatsNaN Computes the moving average & std ignoring NaN values
%
%   M = eqn_movingStatsNaN(X, windowSize), same as eqn_movingAverage(),
%   but ingoring any NaN values. Specifically, if in a particular window of
%   length 'windowSize' there are N instances of NaNs, then the average
%   will be computed based on the remaining windowSize-N values, unless
%   they are too few (less than 75% of the original 'windowSize') for
%   the average to have any meaning and so the result will be set to NaN.
%
%   M = eqn_movingStatsNaN(..., thresh_prcnt), as above with the
%   percentage of non-NaN values in a window, for the window to be accepted
%   set to 'thresh_prcnt'. If there are more NaNs, the corresponding
%   average will be set to NaN.
%
%   [M, S] = eqn_movingStatsNaN(...), computes both the moving average and
%   moving standard deviation (unbiased) for the specified parameters.
% 

if nargin < 3; prc_to_accept = .75; end;

windowSize = 2 * halfWindowSize + 1;

[L, N] = size(X);
b = [ones(halfWindowSize,1); 0; ones(halfWindowSize,1)];

X = [X; nan(2 * halfWindowSize + 1, N)];

% check for NaNs
nanLogicalIndices = isnan(X);
% set NaNs to 0 
X(nanLogicalIndices) = 0;

% Cannot divide sums by 'windowSize', because first windows are
% missing points and some others might include NaNs. Divide with the 
% actual number of points used in the filter() function.
actualWindowSize = eqn_movingWindowLengthExcludingNaNs(nanLogicalIndices, windowSize) - 1;
actualWindowSize(actualWindowSize < prc_to_accept*(windowSize-1)) = NaN;

if N == 1 % single-column data
    M = filter(b, 1, X) ./ actualWindowSize;
    
    if nargout == 2
        Xsq = X.^2;
        Xsqav = filter(b, 1, Xsq) ./ actualWindowSize;
        S = sqrt( (actualWindowSize ./ (actualWindowSize - 1) ) .* (Xsqav - M.^2));
        
        S = S(halfWindowSize + 1 : L + halfWindowSize);
    end
    
    M = M(halfWindowSize + 1 : L + halfWindowSize);
else

end



end

