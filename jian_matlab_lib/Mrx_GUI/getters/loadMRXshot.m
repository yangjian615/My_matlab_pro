function [matObj,filePath] = loadMRXshot(shotNum,conf)
% [matObj,filePath] = loadMRXshot(shotNum,conf)
%
% loads an MRX shot file as matfile object
%
% Jan. 2016, Adrian von Stechow

% construct file path
if ischar(shotNum)
    % mrxGUI gives shotNum as string, handle this here
    filePath = fullfile(conf.dataPath,['Processed_Data_' shotNum '.mat']);
else
    % normal case where shotNum is an integer
    filePath = fullfile(conf.dataPath,['Processed_Data_' int2str(shotNum) '.mat']);
end

if exist(filePath,'file')
    % load if exists
    matObj      = matfile(filePath);
else
    % warning if not
    matObj      = NaN;
    warning(['file ' filePath ' does not exist!'])
end