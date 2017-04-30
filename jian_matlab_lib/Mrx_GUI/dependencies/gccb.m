% colorbarhandle = gccb([axishandle])
% get colorbar handle of (current) axis handle
function cbh = gccb(axishandle)
if nargin==0
    axishandle=gca;
end
fig = get(axishandle,'parent');

% figure handles are objects starting from MATLAB 2014b, this makes things terrible
if matlabVersion >= 8.4
    cbh = findobj(fig,'type','colorbar');
    axh = findobj(fig,'type','axes');
    
    % shitty hack to find which colorbar belongs to which axis
    % issue: there is no property that indicates a CB relationship with an axis
    % solution: move axes around and see which CB moves with it
    
    if ~isempty(cbh)
        % save old color bar positions
        cbhOldPos = cell2mat({cbh.Position}');
        for i=1:length(axh)
            % move axes by variable positions
            axh(i).Position = axh(i).Position + i;
        end
        % find which colorbar has changed by how much
        cbMoved = round(sum(cell2mat({cbh.Position}')-cbhOldPos,2)/4);
        for i=1:length(axh)
            % move axes back
            axh(i).Position = axh(i).Position - i;
        end
        % return the correct color bar
        if cbMoved~=0
            tmp = axh==axishandle;
            cbh = cbh(tmp(cbMoved));
        else % cb position was set to manual. we're screwed! just guess
            cbh = cbh(1);
        end
    end
    
else
    cbh = findobj(fig,'type','axes');
    cbh = cbh(iscolorbar(cbh));
    cbh = cbh(arrayfun(@axisispeer, cbh));
end

    function aip = axisispeer(cbh)
        hax = handle(cbh);
        aip = isequal(double(hax.axes),axishandle);
    end

    function tf = iscolorbar(ax)
        isacb = @(x) isa(handle(x),'scribe.colorbar');
        if isscalar(ax)
            tf = isacb(ax);
        else
            tf = arrayfun(isacb, ax);
        end
    end
end