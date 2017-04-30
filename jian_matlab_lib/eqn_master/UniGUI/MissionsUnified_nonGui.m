local_path = [pwd '/Magnetar_Unified'];
addpath(local_path);

%load inputVars.mat

% Mission = 'SWARM';
Mission = 'CHAMP';

Params = eqn_paramLoader('config.txt');
Source = eqn_getSource(Params, Mission);


% [data, meta, filenameList] = eqn_UniversalSpaceDataLoader_Swarm(...
%     eqn_CellDate2Datenum(Full_date), Satellites{1}, Filetype{1}, ...
%     Field_choice{1}, Source);


[data, meta, filenameList] = eqn_UniversalSpaceDataLoader_CHAMP(...
    eqn_CellDate2Datenum(Full_date), [], Filetype{1}, ...
    Field_choice{1}, Source);

