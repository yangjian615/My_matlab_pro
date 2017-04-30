function S = eqn_cumulativeNaN(X)
%eqn_cumulativeNaN Gives the cumulative sum of the input series
% 
%   S = eqn_cumulativeNaN(X), takes values from the list X and outputs their
%   cumulative sum, so that S(i) = sum(X(1:i)). If there are NaN values in
%   the input series the function ignores them and computes the sum without
%   them, but re-instates them in the output series, so that if X(n) == NaN
%   then also S(n) will be NaN. 
% 

s = size(X);
S = nan(s(1),s(2));
nanInd = isnan(X);
Sx = filter(1, [1, -1], X(~nanInd));
S(~nanInd) = Sx;


end

