function M = eqn_movingAverageNaN(X, windowSize, prc_to_accept)
%eqn_movingAverageNaN Computes the moving average ignoring NaN values
%
%   M = eqn_movingAverageNaN(X, windowSize), same as eqn_movingAverage(),
%   but ingoring any NaN values. Specifically, if in a particular window of
%   length 'windowSize' there are N instances of NaNs, then the average
%   will be computed based on the remaining windowSize-N values, unless
%   they are too few (less than 75% of the original 'windowSize') for
%   the average to have any meaning and so the result will be set to NaN.
%
%   M = eqn_movingAverageNaN(..., thresh_prcnt), as above with the
%   percentage of non-NaN values in a window, for the window to be accepted
%   set to 'thresh_prcnt'. If there are more NaNs, the corresponding
%   average will be set to NaN.
%

if nargin < 3; prc_to_accept = .75; end;

[L, N] = size(X);
b = ones(windowSize,1);

% check for NaNs
nanLogicalIndices = isnan(X);
% set NaNs to 0 
X(nanLogicalIndices) = 0;

% Cannot divide sums by 'windowSize', because first windows are
% missing points and some others might include NaNs. Divide with the 
% actual number of points used in the filter() function.
actualWindowSize = eqn_movingWindowLengthExcludingNaNs(nanLogicalIndices, windowSize);
actualWindowSize(actualWindowSize < prc_to_accept*windowSize) = NaN;

if N == 1 % single-column data
    M = filter(b, 1, X) ./ actualWindowSize;
else      % TIME_SERIES matrix
    M = zeros(L - windowSize + 1, N);
    
    for i=1:N-1
        buffer = filter(b, 1, X(:,i)) ./ actualWindowSize;
        M(:,i) = buffer(windowSize:end);
    end
    
    % set time to correspond to the median time of the averaging window
    M(:,end) = X(ceil(windowSize/2):L - floor(windowSize/2),end);
end

end

