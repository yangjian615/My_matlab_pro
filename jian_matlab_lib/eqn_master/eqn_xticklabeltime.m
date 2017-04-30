function eqn_xticklabeltime(axh, nTicksOrTicks, varargin)
%EQN_XTICKLABELTIME Adds 2-row xticklabels to plot
%
%   NOTE: For the function to work properly, the x values of the plot must
%   be given in matlab datenum format!
%
%   EQN_XTICKLABELTIME(axh) changes the xticks of the x-axis that corresponds
%   to input argument 'axh' to double-row tick labels, with the first row
%   being the tick date in the 'dd/mm/yy' format and the second row the
%   tick time in the 'HH:MM:SS' format. The 'axh' argument must be the axes
%   handle.
% 
%   EQN_XTICKLABELTIME(axh, nTicks) does the same, but for custom number of
%   x ticks set in the input parameter 'nTicks'. Tick values will be
%   distributed evenly between the limit values of the x axis.
%
%   EQN_XTICKLABELTIME(axh, ticks) as above, but using the user defined
%   xticks that are specified in the input vector 'xticks'. If some ticks
%   end up outside the 'xlims' of the plot, they will not be drawn.
%
%   EQN_XTICKLABELTIME(axh, ticks, param, value, param, value, ...) works
%   as above, but with additional param-value pairs specified as additional
%   arguments. e.g.
%
%   EQN_XTICKLABELTIME(handle, time_ticks, 'FontName', 'Courier', 'FontSize', 12)
% 

if nargin >= 2
    % case where 2nd argument is nTicks
    if all(size(nTicksOrTicks) == [1,1]) && nTicksOrTicks > 0 && nTicksOrTicks < 100
        xlim = get(axh, 'xlim');
        xTicks = linspace(xlim(1), xlim(2), nTicksOrTicks)';
    else % case where 2nd argument is vector of ticks
        xTicks = nTicksOrTicks;
        
        % invert if given in row form
        if size(xTicks, 1) < size(xTicks, 2)
            xTicks = xTicks';
        end
    end
elseif nargin == 1
    xTicks = get(axh, 'xtick')';
else
    error('eqn_xticklabeltime: Wrong number of input arguments!');
end

xticklabels = [datestr(xTicks, 'dd/mm/yy'), ...
               repmat('\newline', size(xTicks)), ...
               datestr(xTicks, 'HH:MM:SS')];

set(axh, 'xtick', xTicks, 'xticklabel', []);
ylims = get(axh, 'ylim');
           
if isempty(varargin)
    text(xTicks, ones(size(xTicks))*ylims(1), xticklabels, ...
        'Interpreter', 'tex', ...
        'VerticalAlignment', 'top', 'HorizontalAlignment', 'center');
else
    text(xTicks, ones(size(xTicks))*ylims(1), xticklabels, ...
        'Interpreter', 'tex', ...
        'VerticalAlignment', 'top', 'HorizontalAlignment', 'center', ...
        varargin{:});
end

end

