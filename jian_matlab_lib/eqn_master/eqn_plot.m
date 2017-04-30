function eqn_plot( time_series )
%eqn_plot Plots data in a TIME_SERIES matrix
%
%

% L = length, N = No of Vars
[L, N] = size(time_series);

for i=1:N-1
    subplot(N-1,1,i);
    plot(time_series(:,end), time_series(:,i));
    xlim([time_series(1,end), time_series(end,end)]);
    ylim([min(time_series(:,i)) max(time_series(:,i))]);
    xtick = linspace(time_series(1,end), time_series(end,end), 11)';
    xticklabel = datestr(xtick,'HH:MM');
    set(gca,'xtick',xtick,'xticklabel',xticklabel);
    xlabel('time');
end

end

