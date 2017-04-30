function [cmap] = cmap(varargin)
%Jian.CMAP Custom colormap.
%
%   c = Jian.CMAP Returns custom colormap that goes from light to dark.
%   Similar to irfu "standard" but with more yellow.
%
%   c = Jian.CMAP(colorMapName) Returns special colormap.
%
%   c = Jian.CMAP(color) Returns monochromatic colormap from white to
%   black with specified color.
%
%   Colormap Names:
%       'standard'  -   similar to irf_colormap
%       'Jian'      -   orange and blue
%       'speedway'  -   white-yellow-red-blue
%
%   Special colormaps, are read from files
%       'dawn'      -   from colormap.org
%       'boxer'     -   good colormap
%       'stillill'  -   white-blue-black colormap
%
%   Colors:
%       'red'
%       'green'
%       'blue'
%       'yellow'
%       'orange'
%       'lime'
%       'gray'
%
%   Examples:  colormap(AX,Jian.CMAP('blue'));
%
%   See also: IRF_COLORMAP

%% Input
if(nargin == 0)
    cMapMode = 'standard';
else
    cMapMode = varargin{1};
end
inmap = 1; %Is a colormap that is NOT read.

xmaps = {'dawn','boxer','stillill'}; % Colormaps from colormap.org
if(ismember(cMapMode,xmaps))
    inmap = 0;
end

%% Set which colors
if(inmap)
    switch lower(cMapMode) % Special colormaps
        case 'standard'
            c = [255,255,255;...
                043,255,255;...
                000,255,000;...
                255,255,000;...
                255,255,000;...
                255,000,000;...
                000,000,255]/255;
            
        case 'Jian'
            c = [1,1,1;...
                1,0.7,0;...
                0,0,0.8;...
                0,0,0];
        case 'speedway'
            c = [255,255,255;...
                255,255,000;...
                255,000,000;...
                000,000,200]/255;
            
        otherwise % Single color
            
            switch lower(cMapMode)
                case 'red'
                    cMiddle = [1,0,0];
                case 'green'
                    cMiddle = [0,1,0];
                case 'blue'
                    cMiddle = [0,0,1];
                case 'yellow'
                    cMiddle = [1,1,0];
                case 'orange'
                    cMiddle = [1,0.7,0];
                case 'lime'
                    cMiddle = [0.5,1,0];
                case 'gray'
                    cMiddle = [0.5,0.5,0.5];
                case 'grey'
                    cMiddle = [0.5,0.5,0.5];
                otherwise
                    if(inmap)
                        error('Unknown color')
                    end
            end
            if(inmap)
                c = [1,1,1;cMiddle;0,0,0];
            end   
    end
else
    % Read colormap from folder
    cmstr = [Jian('path'),'/colmaps/',cMapMode,'.txt'];
    c = dlmread(cmstr)/255;
end

%% Create colormap
cN = size(c,1);
x = linspace(1,64,cN);
cmap = zeros(64,3);

for i = 1:64
    cmap(i,:) = interp1(x,c,i);
end

end
