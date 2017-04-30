function C = eqn_movingCorr(X, sample)
%eqn_movingCorr Calculates the correlation of a sample with parts of equal
%length in X
%
%   C = eqn_movingCorr(X, sample), with X being a series (long) of data 
%   points and 'sample' a series of equal or smaller length, will compute 
%   the correlation of this 'sample' with each segment of equal length in 
%   'X', as if using a "sliding" window with a step of one point. The 
%   result is a series of length(X) - length(sample) + 1 values of those 
%   correlations (Pearson's correlation coefficient).
%
%

% sample statistics
S = length(sample);
m = mean(sample);
s = std(sample);

% series' moving avg & std
[AVG, STDEV] = eqn_movingStDev(X, S);

% corr calculated by (Sum(xi*yi) - N*<x><y>)/((N-1)*std(x)*std(y))
% with the series-sample multiplication performed by filter()
C = filter(sample(end:-1:1), 1, X);
C = (C - S*m*AVG)./((S-1)*s*STDEV);

% ignore first S-1 points, as there were not enough points in the series to
% fill an entire window of length S
C = C(S:end);
C(isnan(C))=0;


end

