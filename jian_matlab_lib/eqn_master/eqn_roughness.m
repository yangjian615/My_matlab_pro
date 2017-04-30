function [roughness, N] = eqn_roughness(series)
%eqn_roughness Estimates the "roughness" of a series
%
% Roughness is defined only for points in the series where the gradient
% changes (local maxima and minima) and is equal to the difference of the
% value of the peak (or min) from the average of its immediate neighbours
% (namely the average of the previous and next points).
% This is proven to be related to the second differential of the series, as
% d1 = diff(x) = [x2-x1, x3-x2, x4-x3, ...]
% d2 = diff(d1) = [(x3-x2) - (x2-x1), (x4-x3) - (x3-x2), ...]
% and it can be easily seen that i.e. d2(1) = x3 - 2*x2 + x1 = 
% -2*x2 + (x1+x3) = -2 * ( x2 - (1/2)*(x1+x3) ) = -2*( x2 - mean([x1,x3]) )
% so d2 = -2 * roughness => roughness = - (1/2) * d2.
% In order to have a criterion that is not dependent of whether the series
% has maxima or minima, the absolute value of (1/2)*d2 is chosen, and is
% being computed only at the local minima and maxima. The final series'
% roughness is the average of the roughness of all such extrema.
%

d = diff(series);
m = [nan; d(2:end).*d(1:end-1)];
d2 = [nan; diff(d)];

N = sum(m<=0);
roughness = sum(abs(0.5*d2(m<=0))) / N;

% subplot(2,1,1); plot(series);
% subplot(2,1,2); plot(m<=0);

end