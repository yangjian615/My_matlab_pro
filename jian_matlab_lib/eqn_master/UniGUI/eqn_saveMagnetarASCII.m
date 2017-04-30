local_path = [pwd '/Magnetar_Unified'];
addpath(local_path);

% source input through the config.txt file
Params = eqn_paramLoader('config.txt');

date_vec = [datenum(2014, 9, 12, 12, 0, 0), datenum(2014, 9, 12, 23, 59, 59)];

    
outpath = ['C:\Users\User\Desktop\']; %#ok<NBRAK>

Pc_class = 'Pc3';
Missions = {'SWARM'; 'SWARM'; 'SWARM'; []};
Satellites = {'C'; 'C'; 'C'; []};
Filetype = {'MAG_LR'; 'MAG_LR'; 'MAG_LR'; []};
Field_choice = {'B_NEC'; 'B_NEC'; 'B_NEC'; []};
Component = [4;2;1;7];
Latitude = [-90, 90];

ti = date_vec(1); 
tend = date_vec(2);

Full_date = {num2str(year(ti),'%04d'), num2str(year(tend),'%04d');
             num2str(month(ti),'%02d'), num2str(month(tend),'%02d');
             num2str(day(ti),'%02d'), num2str(day(tend),'%02d');
             datestr(ti, 'HH:MM:SS'), datestr(tend, 'HH:MM:SS')};

Magnetar = eqn_MagnetarUnifiedProcess(Missions, Satellites, ...
        Filetype, Field_choice, Component, Full_date, Pc_class, Latitude, Params, false);

if exist('Magnetar', 'var');
    w = whos('Magnetar');
    s = w.bytes;

% An "empty" Magnetar may have size > 1 kB, but it can be
% recognized by the fact that the 'R' variable inside will have only
% two columns and not 5 as is normally the case!
if (s > 1000) && (size(Magnetar.R{1}, 2) == 5)
    disp('OK');
    time = Magnetar.B{1}(:,end);
    time_vec = datevec(time);
    
    filename = [Missions{1}, '-', Satellites{1}, '_', Filetype{1},  '-', ...
        Field_choice{1}, '_' datestr(ti, 'yyyymmddHHMMSS'), '-', ...
        datestr(tend, 'yyyymmddHHMMSS'), '.txt'];
    
    fid = fopen([outpath, filename], 'w');
    
    spaces = repmat(' ', [length(time), 1]);
    newLine = repmat('\n', [length(time), 1]);
    
    yearStr = num2str(time_vec(:,1), '%04d');
    monthStr = num2str(time_vec(:,2), '%02d');
    dayStr = num2str(time_vec(:,3), '%02d');
    hourStr = num2str(time_vec(:,4), '%02d');
    minStr = num2str(time_vec(:,5), '%02d');
    secStr = num2str(time_vec(:,6), '%02d');
    
    % all R are the same for the same sat, so use the first
    posX = num2str(Magnetar.R{1}(:,2), '%.6f');
    posY = num2str(Magnetar.R{1}(:,3), '%.6f');
    posZ = num2str(Magnetar.R{1}(:,4), '%.2f');
    
    % different B components are stored in different cells (unfiltered)
    Bx = num2str(Magnetar.B{1}(:,2), '%.6f');
    By = num2str(Magnetar.B{2}(:,2), '%.6f');
    Bz = num2str(Magnetar.B{3}(:,2), '%.6f');
    
    % different B components are stored in different cells (filtered)
    Bfx = num2str(Magnetar.B{1}(:,1), '%.6f');
    Bfy = num2str(Magnetar.B{2}(:,1), '%.6f');
    Bfz = num2str(Magnetar.B{3}(:,1), '%.6f');
    
    textMat = [yearStr, spaces, monthStr, spaces, dayStr, spaces, hourStr, spaces, ...
        minStr, spaces, secStr, spaces, posX, spaces, posY, spaces, posZ, spaces, ...
        Bx, spaces, By, spaces, Bz, spaces, Bfx, spaces, Bfy, spaces, Bfz, newLine];
    
    fprintf(fid, textMat');
    fclose(fid);
end

% clear 'Magnetar';
end
