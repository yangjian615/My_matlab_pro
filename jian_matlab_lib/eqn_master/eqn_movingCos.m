function C = eqn_movingCos(X, sample)
%eqn_movingCos Calculates the cosine similarity of a sample with parts of 
%equal length in X.
%
%   C = eqn_movingCos(X, sample), with X being a series (long) of data 
%   points and 'sample' a series of equal or smaller length, will compute 
%   the cosine similarity of this 'sample' with each segment of equal 
%   length in 'X', as if using a "sliding" window with a step of one point.
%   The result is a series of length(X) - length(sample) + 1 values of 
%   those similarities.
%

% sample properties
S = length(sample);
m = sqrt(sum(sample.^2));

% moving vector magnitude
M = filter(ones(S,1), 1, X.^2);
M = sqrt(M);

% corr calculated by (Sum(xi*yi) - N*<x><y>)/((N-1)*std(x)*std(y))
% with the series-sample multiplication performed by filter()
C = filter(sample(end:-1:1), 1, X);
C = C ./ (M*m);

% ignore first S-1 points, as there were not enough points in the series to
% fill an entire window of length S
C = C(S:end);
C(isnan(C))=0;



end