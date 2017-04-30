function M = eqn_movingAverage(X, windowSize)
%eqn_movingAverage Computes the moving average
%
%   M = eqn_movingAverage(X, windowSize) gives the average value of data
%   points in X, by means of a sliding window of length 'windowSize', that
%   slides by a single point each time. If X is a single column, then the
%   result is also a single column, of equal length (the first 'windowSize'
%   - 1 averages will be computed approximately). If X is a TIME_SERIES
%   column matrix, then the resulting M will also be a TIME_SERIES matrix,
%   of total length equal to L - windowSize + 1 (L is the length of X). The
%   time stamp of each average will be given in M(:,end) by the median time
%   stamp of each window.
%

[L, N] = size(X);
b = ones(windowSize,1);

if N == 1 % single-column data
    % Cannot divide everything with 'windowSize', because first windows are
    % missing points. Divide with the actual number of points used in the
    % filter() function.
    actualWindowSize = [(1:windowSize)';windowSize*ones(L-windowSize,1)];
    M = filter(b, 1, X) ./ actualWindowSize;
else      % TIME_SERIES matrix
    % No need to use 'actualWindowSize' here, because we're only keeping
    % the "good" windows.
    M = zeros(L - windowSize + 1, N);
    
    for i=1:N-1
        buffer = filter(b, 1, X(:,i)) / windowSize;
        M(:,i) = buffer(windowSize:end);
    end
    
    M(:,end) = X(ceil(windowSize/2):L - floor(windowSize/2),end);
end
    
end

