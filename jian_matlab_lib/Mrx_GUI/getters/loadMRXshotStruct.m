function out = loadMRXshotStruct(shotNum,conf)
% out = loadMRXshotStruct(shotNum,conf)
%
% loads an MRX shot file as struct (instead of matfile object). Slower than
% loadMRXshot()
%
% Jan. 2016, Adrian von Stechow

% construct path
filePath = fullfile(conf.dataPath,['Processed_Data_' int2str(shotNum) '.mat']);

if exist(filePath,'file')
    % load file if exists
    out      = load(filePath);
else
    % warning if not
    out      = NaN;
    warning(['file ' filePath ' does not exist!'])
end