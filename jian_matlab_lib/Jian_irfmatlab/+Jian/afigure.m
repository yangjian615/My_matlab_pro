function [h,f] = afigure(subNum,figSize)
%Jian.AFIGURE Quick way to call irf_plot.
%
%   Jian.AFIGURE(subNum) initiates figure with number of panels subNum.
%   Size of figure is set to 10x7 cm.
%
%   Jian.AFIGURE(subNum,figSize) declare size of figure with a vector
%   figSize = [width, height] in centimeters.
%   h = Jian.AFIGURE(...) returns vector of axes for the panels h
%
%   [h,f] = Jian.AFIGURE(...) also returns figure f.
%
%   See also: IRF_PLOT


%% Input
if(nargin == 1)
    figSize = [10,7];
elseif(nargin == 0)
    figSize = [10,7];
    subNum = 1;
end

%% Initiate figures
% Initiate figure
irf.log('w','Initiating new figure')
h = irf_plot(subNum,'newfigure');


f = h.Parent;

% Set parameters
f.PaperUnits = 'centimeters';
xSize = figSize(1); ySize = figSize(2);
xLeft = (21-xSize)/2; yTop = (30-ySize)/2;
f.PaperPosition = [xLeft yTop xSize ySize];
f.Position = [10 10 xSize*50 ySize*50];
f.PaperPositionMode = 'auto';

for i = 1:subNum
    h(i).UserData.XLabel.String = h(i).XLabel.String; % Stores XLabel for restoration
    if(i ~= subNum)
        h(i).UserData.XLabel.Visible = 'off';
        h(i).XTickLabel = '';
        h(i).XLabel.String = '';
    else
        h(i).UserData.XLabel.Visible = 'on';
    end
end

%% Create dropdown menu option
Jian.figmenu(f)






