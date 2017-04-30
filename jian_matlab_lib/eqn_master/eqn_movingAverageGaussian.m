function Y = eqn_movingAverageGaussian(X, windowSize)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

[L, N] = size(X);
windowSize = 2;
% select std so that the entire window will correspond to +/- 3 stds.
s = windowSize/6; 
b = exp( -((1:)'-(windowSize+1)/2).^2 / (2*s^2) );

% Cumulative_b will hold the summed values of the b parameter vector, so
% that cum_b(1) = b(1), cum_b(2) = b(1) + b(2), ... cum_b(end) = sum(b) and
% will be used for correct normalization of the output
cum_b = filter(1, [1, -1], b);

Y = filter(b, 1, X);
weights = [cum_b; cum_b(end)*ones(L-windowSize,1)];
Y = Y ./ weights;

end

