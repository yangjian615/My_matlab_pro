% HOURLY LOG MEDIAN WAVELET POWER FOR DIFFUSION COEFFICIENTS CALCULATION
%
% Input Params ------------------------------------------------------------
day_beg = datenum(2010,1,1);
day_end = datenum(2010,1,2);
% FREQS = 2.^(log2(0.5/1000):log2(1.5):log2(10/1000))';
FREQS = (0.6: 0.25: 20)'/1000;
MARGIN_FLAG = 1;

% stations = {'BJN', 'DOB', 'HOR', 'KEV', 'KIR', 'NUR', 'OUJ', 'RVK', 'SOD', 'SOR', 'TRO', 'UPS'};
%stations = {'BJN', 'HOR', 'KEV', 'NUR', 'OUJ', 'RVK', 'SOD', 'SOR', 'TRO', 'UPS'};
stations = {'DOB'};

for j=1:length(stations)

FILE_TYPE = 'IMAGE';
PATH = 'DATA/IMAGE/';
STATION_NAME = stations{j};

OUTPUT_FILENAME = ['TEST/out_', STATION_NAME, '_', ...
    datestr(day_beg, 'yyyymmdd'), '-', datestr(day_end, 'yyyymmdd'), '.txt'];

% end of Input params -----------------------------------------------------
tic;
nFreqs = length(FREQS);

fid = fopen(OUTPUT_FILENAME, 'w');
%fprintf(fid, '--info--\n');

for i=fix(day_beg):ceil(day_end)
    out = eqn_groundMedianWaveletPSD_HR_Kp(i, FREQS, ...
    MARGIN_FLAG, FILE_TYPE, PATH, STATION_NAME);
    
    if ~isempty(out)
        s = size(out);

        out(isnan(out)) = -10^30;

        spaces = repmat(' ',[24,1]);
        dayString = repmat(num2str(i), [24,1]);
        hrString = num2str((0:23)','%02d');
        valString = sprintf('%+.6e ', out(:,1:end-1)');
        valMat = reshape(valString, [14*(s(2)-1), 24]);
        newline = repmat('\n', [24,1]);

        outCharMat = [dayString, spaces, hrString, spaces, valMat',newline];
        fprintf(fid,outCharMat');
    end
end


fclose(fid);
toc

end