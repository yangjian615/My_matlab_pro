% adds a horizontal line to plot
% line_handle = hline([axes_handle], y_pos, [line_color_style])
% default:  axes_handle         =   gca
%           line_color_style    =   'k-'
function lh = hline(varargin)
switch nargin
    case 0
        error(help('hline'))
    case 1
        ah = gca;
        y = varargin{1}(:);
        c = 'k-';
        ioff=2;
    otherwise
        if isscalar(varargin{1})&&ishandle(varargin{1})&&strcmp(get(varargin{1},'type'),'axes')
            ah = varargin{1};
            ioff=3;
        else
            ah = gca;
            ioff=2;
        end
        y = varargin{ioff-1}(:);      
        if mod(nargin-ioff,2)==0,
            c=varargin{ioff};
            ioff=ioff+1;
        else
            c = 'k-';
        end
end
xlims=get(ah,'Xlim');
xlim(ah,xlims);
old = get(ah,'NextPlot');
hold(ah,'on');
lh = arrayfun(@(y) plot(ah,xlims,[y,y],c,varargin{ioff:end}),y,'uniformoutput',0);
set(ah,'NextPlot',old);
if nargout==0,    clear lh; end
end