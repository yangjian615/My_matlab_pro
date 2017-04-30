% adds a vertical line to plot
% line_handle = hline([axes_handle], x_pos, [line_color_style])
% default:  axes_handle         =   gca
%           line_color_style    =   'k-'
function lh = vline(varargin)
switch nargin
    case 0
        error(help('hline'))
    case 1
        ah = gca;
        x = varargin{1}(:);
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
        x = varargin{ioff-1}(:);      
        if mod(nargin-ioff,2)==0,
            c=varargin{ioff};
            ioff=ioff+1;
        else
            c = 'k-';
        end
end
ylims=get(ah,'Ylim');
ylim(ah,ylims);
old = get(ah,'NextPlot');
hold(ah,'on');
lh = arrayfun(@(x) plot(ah,[x,x],ylims,c,varargin{ioff:end}),x,'uniformoutput',0);
set(ah,'NextPlot',old);
if nargout==0,    clear lh; end
end