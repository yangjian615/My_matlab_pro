function [matrix, xBinEdges, yBinEdges, xBinCentr, yBinCentr] =...
    eqn_countMatrix(x, y, Nx, Ny, xLims, yLims)
%eqn_countMatrix Gives a matrix of counts from pairs of values
% 
%   Detailed explanation goes here
%

if nargin < 6; yLims = [min(y) max(y)]; end
if nargin < 5; xLims = [min(x) max(x)]; end

% get limits and their diff() 
dx = diff(xLims);
dy = diff(yLims);

% Increase (a little) values equal to 'init' to make sure they are within
% the first bin & decrease (a little) values quale to 'fin' to make them
% fall within the last bin. [Perhaps unnecessary, but just to be sure]
x(x == xLims(1)) = xLims(1) + dx/(10*Nx);
y(y == yLims(1)) = yLims(1) + dy/(10*Ny);
x(x == xLims(2)) = xLims(2) - dx/(10*Nx);
y(y == yLims(2)) = yLims(2) - dy/(10*Ny);

% Get indices from values
xInd = ceil(((x - xLims(1))/dx)*Nx);
yInd = ceil(((y - yLims(1))/dy)*Ny);

% Keep only index values within limits
xIndInBins = xInd;
yIndInBins = yInd;
fi = find(xIndInBins < 1 | xIndInBins > Nx);
xIndInBins(fi) = [];
yIndInBins(fi) = [];
fi = find(yIndInBins < 1 | yIndInBins > Ny);
xIndInBins(fi) = [];
yIndInBins(fi) = [];

% Create array
if ~isempty(xIndInBins)
    matrix = accumarray([xIndInBins,yIndInBins], 1, [Nx, Ny], @sum);
else
    matrix = zeros(Nx, Ny);
end

if nargout > 1
    xBinEdges = linspace(xLims(1), xLims(2), Nx+1);
    yBinEdges = linspace(yLims(1), yLims(2), Ny+1);
end
if nargout > 3
    xBinCentr = filter([1 1], 1, xBinEdges(1:end))/2; xBinCentr(1) = [];
    yBinCentr = filter([1 1], 1, yBinEdges(1:end))/2; yBinCentr(1) = [];
end

end