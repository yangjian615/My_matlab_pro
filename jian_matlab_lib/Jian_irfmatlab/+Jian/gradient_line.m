function [out] = gradient_line(varargin)
%Jian.GRADIENT_LINE Plots a 2D line with a color gradient.
%
%   Jian.GRADIENT_LINE(AX,...) Plots on axes AX instead of current axes.
%
%   Jian.GRADIENT_LINE(x,y,c) Plots x and y data with color data c. Acually
%   plots n-1 small line segments where n = length(x). c could
%   for example be a vector with time values or some function value. 
%
%   Jian.GRADIENT_LINE(x,y,c,cMap) Uses specified colormap cMap. If not set
%   parula colormap is used.
%
%   fLine = Jian.GRADIENT_LINE(...) Returns array of line handles. Not very
%   useful.

%% Input
if(nargin == 3)
    AX = gca;
    x = varargin{1};
    y = varargin{2};
    c = varargin{3};
    cMap = parula;
elseif(nargin == 4)
    if(isvalid(varargin{1}))
        AX = varargin{1};
        x = varargin{2};
        y = varargin{3};
        c = varargin{4};
        cMap = parula;
    else
        AX = jet;
        x = varargin{1};
        y = varargin{2};
        c = varargin{3};
        cMap = varargin{4};
    end
    
elseif(nargin == 5)
        AX = varargin{1};
        x = varargin{2};
        y = varargin{3};
        c = varargin{4};
        cMap = varargin{5};
end

%% Plot in loop 
n = length(x);
cX = linspace(min(c),max(c),length(cMap));
% Get colors
col = interp1(cX,cMap,c);

hold(AX,'on');

fLine = gobjects(1,n);
for i = 1:n-1
    fLine(i) = plot(AX,x(i:i+1),y(i:i+1));
    fLine(i).Color = col(i,:);
end

if(nargout == 1) 
    out = fLine;
end
    

