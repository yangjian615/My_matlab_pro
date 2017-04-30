function y = eqn_logarithm(x, base)
%eqn_logarithm Computes the logarithm with an arbitrary base.
%
%   y = eqn_logarithm(x, base)
%   Gives the result of the logarithm of input 'x', at a predefined 'base'.
%   If base is not given, then it computes the natural logarithm instead.
%   Works with both scalar and vector input.

if nargin < 2
    y = log(x);
else
    y = log(x) ./ log(base);
end

end