function out=getMRXwavelet(shot)
% out=getMRXwavelet(shot)
%
% load a precomputed wavelet spectrum from the wavelet database as created
% by doWavelet()
%
% Jan. 2016, Adrian von Stechow

conf = initMRX;

filePath = fullfile(conf.waveletPath,['wavelet_' int2str(shot) '.mat']);

if exist(filePath,'file')
    out = matfile(filePath);
else
    disp(['no wavelet info stored for shot ' int2str(shot)])
end