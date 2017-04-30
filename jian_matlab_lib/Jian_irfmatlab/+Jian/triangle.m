function [q] = triangle(AX,varargin)
%Jian.TRIANGLE Plots triangles.
%   
%   Jian.TRIANGLE(AX,...) Plots in axes AX instead of current axis.
%
%   Jian.TRIANGLE(x,y) Like plot(x,y) but with triangles as markers.
%
%   Jian.TRIANGLE(x,y,angle) Specifies rotation angle of the triangle,
%   angle can be a number or a vector with the same length as x and y. The
%   triangles are slightly pointy, angle=0 means it is pointing upward.
%
%   Jian.TRIANGLE(x,y,angle,s) Specifies the size of the triangles, trial
%   and error is probably required.
%
%   See also: Jian.LINEARROW, Jian.MARKER


%% input
s = 'auto';
th = 0;
hInp = 1;

if(isnumeric(AX))
    x = AX;
    AX = gca;
    hInp = 0;
end

if((hInp && nargin<3) || nargin<2)
    error('Too few inputs')
else
    if(hInp)
       x = varargin{1};
    end
    y = varargin{1+hInp};
    if(nargin >= 3+hInp)
        th = varargin{2+hInp};
    end
    if(nargin == 4+hInp)
        s = varargin{3+hInp};
    end
    
end

%% Make triangles

% Plot a line to get axes and such.
hLine = plot(AX,x,y);
xl = AX.XLim;
yl = AX.YLim;

n = length(x);

if(ischar(s) && strcmp(s,'auto'))
    scale = 0.01;
    s = scale*(max(x)-min(x));
    sf = getSF(AX);
else
    sf = 1;
end

if(length(th) == 1)
    th = th*ones(1,n);
end

axes(AX); % make AX current axes
hAr = gobjects(1,n);

for i = 1:n
    R = [cosd(th(i)),-sind(th(i));sind(th(i)),cosd(th(i))];
    r1 = [-s,-s]';
    r2 = [ 0,+s]';
    r3 = [+s,-s]';
    
    r1p = R*r1;
    r2p = R*r2;
    r3p = R*r3;
    
    xt = x(i)+[r1p(1),r2p(1),r3p(1)]*sf;
    yt = y(i)+[r1p(2),r2p(2),r3p(2)];
    hAr(i) = patch(xt,yt,'k');
end
q = Jian.Marker(hAr);
delete(hLine)
AX.XLim = xl;
AX.YLim = yl+[-1,1]*0.1*diff(yl);

end

function sf = getSF(AX) % Scaling factor y/x
p = AX.Position;
dx = AX.XLim/p(3);
dy = AX.YLim/p(4);

sf = dx/dy;

end

