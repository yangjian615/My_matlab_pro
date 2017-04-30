function varargout = eqn_movingStDev(X, windowSize)
%eqn_movingAverage Computes the moving standard deviation
%
%   S = eqn_movingStDev(X, windowSize) gives the st.dev. value of data
%   points in X, by means of a sliding window of length 'windowSize', that
%   slides by a single point each time. If X is a single column, then the
%   result is also a single column, of equal length (the first 'windowSize'
%   - 1 deviations will be computed approximately). If X is a TIME_SERIES
%   column matrix, then the resulting M will also be a TIME_SERIES matrix,
%   of total length equal to L - windowSize + 1 (L is the length of X). 
%   The time stamp of each value will be given in S(:,end) by the median 
%   time stamp of each window.
%
%   [M, S] = eqn_movingStDev(X, windowSize), as above with an additional
%   output of the moving average M, alongside the moving standard deviation
%   S. Again, the type of the output can be either a single-column or a
%   TIME_SERIES matrix according to the type of the input X. 
%

[L, N] = size(X);
b = ones(windowSize,1);

if N == 1 % single-column data
    % Cannot divide everything with 'windowSize', because first windows are
    % missing points. Divide with the actual number of points used in the
    % filter() function.
    actualWindowSize = [(1:windowSize)';windowSize*ones(L-windowSize,1)];
    Xsq = X.^2;
    M = filter(b, 1, X) ./ actualWindowSize;
    Xsqav = filter(b, 1, Xsq) ./ actualWindowSize;
    S = sqrt( (actualWindowSize ./ (actualWindowSize - 1) ) .* (Xsqav - M.^2));
else % TIME_SERIES matrix
    % No need to use 'actualWindowSize' here, because we're only keeping
    % the "good" windows.
    Xsq = X(:,end-1).^2;
    M = zeros(L - windowSize + 1, N);
    S = zeros(L - windowSize + 1, N);
    
    for i=1:N-1
        bufferM = filter(b, 1, X(:,i)) / windowSize;
        M(:,i) = bufferM(windowSize:end);
        bufferS = filter(b, 1, Xsq(:,i)) / windowSize;
        bufferS2 = bufferS(windowSize:end);
        S(:,i) = sqrt( (windowSize / (windowSize - 1)) * (bufferS2 - M(:,i).^2) );
    end
    
    M(:,end) = X(ceil(windowSize/2):L - floor(windowSize/2),end);
    S(:,end) = X(ceil(windowSize/2):L - floor(windowSize/2),end);
end

if nargout == 2; 
    varargout{2} = S; 
    varargout{1} = M;
elseif nargout == 1; 
    varargout{1} = S;
elseif nargout == 0
    S %#ok<NOPRT>
end
    
end

