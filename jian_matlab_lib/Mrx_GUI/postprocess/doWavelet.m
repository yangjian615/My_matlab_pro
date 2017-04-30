function doWavelet(shots)
% doWavelet(shots)
%
% does wavelet analysis on fluctuation data and stores result in
% conf.waveletPath directory
% 
% Jan. 2016, Adrian von Stechow

conf       = initMRX;
files      = dir(conf.waveletPath);

for i=1:length(shots)
    shotStr = int2str(shots(i));
    % check if previously processed
    if strmatch(['wavelet_' shotStr '.mat'],{files.name}) 
        disp(['shot ' shotStr ' exists, skipping'])
    else
        disp(['processing shot ' shotStr])
        % load fluctuations
        f = getMRXflucs(shots(i));
        % do wavelet transform
        w = waveletMRX(f);
        % save data
        save(fullfile(conf.waveletPath,['wavelet_' shotStr '.mat']),'-v7.3','-struct','w')
    end
    
end