function [M, S] = eqn_movingStatsNaN(X, windowSize, prc_to_accept)
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
    
    if nargout == 2
        Xsq = X.^2;
        Xsqav = filter(b, 1, Xsq) ./ actualWindowSize;
        S = sqrt( (actualWindowSize ./ (actualWindowSize - 1) ) .* (Xsqav - M.^2));
    end
    
else      % TIME_SERIES matrix
    M = zeros(L - windowSize + 1, N);
    if nargout == 2
        S = zeros(L - windowSize + 1, N);
    end
    
    for i=1:N-1
        buffer = filter(b, 1, X(:,i)) ./ actualWindowSize;
        M(:,i) = buffer(windowSize:end);
        
        if nargout == 2
            bufferXsq =  X(:,i).^2;
            bufferXsqav = filter(b, 1, bufferXsq) ./ actualWindowSize;
            bufferS = sqrt( (actualWindowSize ./ (actualWindowSize - 1) ) .* (bufferXsqav - buffer.^2));
            S(:,i) = bufferS(windowSize:end);
        end
    end
    
    % set time to correspond to the median time of the averaging window
    M(:,end) = X(ceil(windowSize/2):L - floor(windowSize/2),end);
    if nargout == 2
        S(:,end) = X(ceil(windowSize/2):L - floor(windowSize/2),end);
    end
end

end

