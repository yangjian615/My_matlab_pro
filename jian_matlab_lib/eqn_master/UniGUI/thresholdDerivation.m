addpath('Magnetar_Unified');
% Enter PATH of stored "Magnetar" files
PATH = 'G:\PROCESSED\SWARM\VFM_OPER\Pc1UB\Swarm-A\';
% Load database file (database variable should be named "DB")
DB_STRUCT = load('C:\Users\User\Desktop\Pc1\DB_B-Total_OPER_A_Pc1UB_NoDetection_FULL2015.mat');
% set outpath for plots
PLOTPATH = 'C:\Users\User\Desktop\Pc1\paramPlots\';

% Enter sorting index and index of time column
%      3: time of peak power
%     11: max amplitude
%     12: max abs diff amplitude
%     21: total power

if ~exist(PLOTPATH, 'dir')
    mkdir(PLOTPATH);
end

sortingIndex = 21; 
timeIndex = 3;

DB = DB_STRUCT.DB;

% Enter additional constraints here:
f = find(DB(:,3) >= datenum(2015,6,1) & DB(:,3) <= datenum(2015,6,30)+1 );
DB = DB(f, :);

[sortVals, sortOrder] = sort(DB(:, sortingIndex), 1, 'descend');
sortTime = DB(sortOrder, timeIndex);

% plot and save the Distribution of param. values
fh = figure(1);
edges = 10.^linspace(log10(min(DB(:, sortingIndex))), log10(max(DB(:, sortingIndex))));
loglog(edges, histc(DB(:, sortingIndex), edges), '-x');
xlim([edges(1), edges(end)]);
xlabel('Param Value'); ylabel('Count');
grid on;
saveas(fh, [PLOTPATH, 'Distr.fig']);
close(fh);

for i=1:1:100
    dayString = datestr(sortTime(i), 'yyyy-mm-dd');
    initTime = DB(sortOrder(i), 1);
    finTime = DB(sortOrder(i), 2);
    
% load Magnetar
    load([PATH, 'SWARM-A_B-Total_Pc1_', dayString]); 
    
    if exist('Magnetar', 'var')
% find to which track the candidate event belongs
        f = find(sortTime(i) >= Magnetar.B{1}(Magnetar.Bind{1}(:, 1), 3) & ...
                 sortTime(i) <= Magnetar.B{1}(Magnetar.Bind{1}(:, 2), 3) );
        
        if length(f) == 1
% isolate the candidate's track and plot it
            B_init = Magnetar.Bind{1}(f, 1);
            B_end = Magnetar.Bind{1}(f, 2);
            d_init = Magnetar.dind{1}(f, 1);
            d_end = Magnetar.dind{1}(f, 2);
            R_init = Magnetar.Rind{1}(f, 1);
            R_end = Magnetar.Rind{1}(f, 2);
            
            Magnetar.B{1} = Magnetar.B{1}(B_init:B_end, :);
            Magnetar.W{1} = Magnetar.W{1}(:, B_init:B_end);
            Magnetar.Bind{1} = [1, size(Magnetar.B{1}, 1)];
            Magnetar.d{1} = Magnetar.d{1}(d_init:d_end, :);
            Magnetar.R{1} = Magnetar.R{1}(R_init:R_end, :);
            
            h = signal_Plotter_44(Magnetar);
            title(['Param Values: ', num2str(DB(sortOrder(i), [8:13, 18, 21]))], 'FontWeight', 'bold');
            text(sortTime(i), 0, ' ', 'color', 'r', 'HorizontalAlignment', 'center');
            text(initTime, 0, '|', 'color', 'r', 'HorizontalAlignment', 'center', 'FontSize', 40);
            text(finTime, 0, '|', 'color', 'r', 'HorizontalAlignment', 'center', 'FontSize', 40);
            export_fig(h.fig, [PLOTPATH, 'Fig', num2str(i, '%04d'), '.png']);
        end
        
        close all
        clear Magnetar
    end
end


