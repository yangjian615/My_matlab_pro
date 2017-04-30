function [matObj,filePath]=loadMRXshot(shotNum,conf)
% [matObj,filePath]=loadMRXshot(shotNum,conf)
% loads an MRX shot file as matfile object

if ischar(shotNum)
    filePath = fullfile(conf.dataPath,['Processed_Data_' shotNum '.mat']);
else
    filePath = fullfile(conf.dataPath,['Processed_Data_' int2str(shotNum) '.mat']);
end

if exist(filePath,'file')
    matObj      = matfile(filePath);
else
    matObj      = NaN;
    warning(['file ' filePath ' does not exist!'])
end