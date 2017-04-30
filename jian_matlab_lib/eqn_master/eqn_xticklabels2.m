function eqn_xticklabels2(axh, xticks, xticklabels2, ymultiplier)

if nargin<4
    ymultiplier = 0.06;
end

ylimits = get(axh, 'ylim');
font_size = get(axh, 'FontSize');
dy = ylimits(2) - ylimits(1);
text(xticks, (ylimits(1) - ymultiplier*dy)*ones(size(xticks)), xticklabels2, ...
    'HorizontalAlignment', 'center', 'FontSize', font_size);

end
