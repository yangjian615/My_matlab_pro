function [y1,y2] = hodo(varargin)
%Jian.HODO Plots B-field in hodograms in an LMN frame.
%
%   h = Jian.HODO(B,scInd) Initiates a figure and plots a hodogram of magnetic
%   field B for spacecraft number scInd in an LMN frame, returns vector of
%   axes handles h. The red dot in the plots indicates start time.
%   
%   [h,v] = Jian.HODO(B) also returns column vector with LMN eigenvectors v.
%   
%   See also: Jian.HODO_GUI, Jian.LINEARROW
%


%% Input
if(nargin == 1) % Only B-field
    h = Jian.afigure(3,[10,10]);
    B = varargin{1};
    scInd = 0;
elseif(nargin == 2)
    h = Jian.afigure(3,[10,10]);
    B = varargin{1};
    scInd = varargin{2};
else
    error('unknown input')
end

% 1 if arrows should be included
plotArrows = 1;

%% Minimum variance
[Blmn,l,v] = irf_minvar(B);


%% Initiate figure
delete(h)
h = gobjects(1,3);
for i = 1:3
    h(i) = subplot(2,2,i);
    hold(h(i))
    h(i).Box = 'on';
end

%% Plotting

% Data

% First panel N-L
plot(h(1),Blmn(:,4),Blmn(:,2),'k-')
plot(h(1),Blmn(1,4),Blmn(1,2),'r*','MarkerSize',3)


% Second panel M-L
plot(h(2),Blmn(:,3),Blmn(:,2))
plot(h(2),Blmn(1,3),Blmn(1,2),'r*','MarkerSize',3)


% Thrid panel M-N
plot(h(3),Blmn(:,4),Blmn(:,3))
plot(h(3),Blmn(1,4),Blmn(1,3),'r*','MarkerSize',3)

if plotArrows
    Jian.linearrow(h(3),Blmn(:,4),Blmn(:,3),10);
    Jian.linearrow(h(2),Blmn(:,3),Blmn(:,2),10);
    Jian.linearrow(h(1),Blmn(:,4),Blmn(:,2),10);
end

% Dashed line for Bn = 0

% Original nlim
onlim = h(1).XLim;

plot(h(1),[0,0],[-100,100],'--','Color',[0.8,0.8,0.8])
plot(h(3),[0,0],[-100,100],'--','Color',[0.8,0.8,0.8])
% Restore YLim
h(1).YLim = h(2).YLim;
h(3).YLim = h(2).XLim;
% Restore XLim
h(1).XLim = onlim;
h(3).XLim = onlim;

%% Arrange panels

% Remove tick labels where appropriate
h(1).XTickLabel = '';
h(2).YTickLabel = '';

% Empirical vaules
H = 0.4;
W = 0.24;
U = 0.56;
L = 0.44;

% Set position and sizes
h(1).Position(3) = W;
h(1).Position(4) = H;
h(1).Position(2) = U;
h(2).Position(2) = U;
h(2).Position(4) = H;
h(2).Position(3) = H;
h(2).Position(1) = L;
h(3).Position(3) = W;
h(3).Position(4) = H;

% Scaling factor sf
dBl = abs(diff(h(2).YLim));
sf = dBl/H;
sf = sf*0.9; % For tighter fit

% Recalculating plotting limits for M and N
Mlim = h(2).XLim*sf*H/abs(diff(h(2).XLim));
Nlim = h(3).XLim*sf*W/abs(diff(h(3).XLim));

%Set limits to plot
h(2).XLim = Mlim;
h(3).YLim = Mlim;
h(1).XLim = Nlim;
h(3).XLim = Nlim;

% Labels
Jian.label(h(1),'y','$B_{L}$')
Jian.label(h(2),'x','$B_{M}$')
Jian.label(h(3),'x','$B_{N}$')
Jian.label(h(3),'y','$B_{M}$')

%% Legend
%setting h(3) to current axes
axes(h(3));

% text position
tPos = [1.2875,0.58,0];

leg = text(tPos(1),tPos(2),'Getting away with it all messed up');

% Default unit is data
leg.Units = 'normalized';
leg.Position = tPos;

% Data for the legend
l2l3 = l(2)/l(3);
mTime = mean(B(:,1));
mBn = mean(Blmn(:,4));
nHat = round(v(3,:),2);

% Change string
legStr = {['C',num2str(scInd),'   ', Jian.fast_date(mTime,2)], '',...
    ['\lambda_2/\lambda_3 = ',num2str(l2l3)],''...
    ['<B_N> = ',num2str(mBn),' nT'],'',...
    ['n = ','[ ', num2str(nHat),' ]']};
leg.String = legStr;

%% Output
if(nargout >= 1)
    y1 = h;
end
if(nargout == 2)
    y2 = v;
end

end
