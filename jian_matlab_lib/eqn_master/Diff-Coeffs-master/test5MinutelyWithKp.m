% HOURLY LOG MEDIAN WAVELET POWER FOR DIFFUSION COEFFICIENTS CALCULATION
%
% Input Params ------------------------------------------------------------
day_beg = datenum(2010,1,1);
day_end = datenum(2010,1,2);
%day_end = datenum(2014,9,14);
% FREQS = 2.^(log2(0.5/1000):log2(1.5):log2(10/1000))';
FREQS = (0.1: 0.25: 20)'/1000;
MARGIN_FLAG = 1;

% stations = {'BJN', 'DOB', 'HOR', 'KEV', 'KIR', 'NUR', 'OUJ', 'RVK', 'SOD', 'SOR', 'TRO', 'UPS'};
% stations = {'FCHU', 'GILL', 'ISLL', 'OSAK', 'OXFO', 'PINA', 'THRF', 'LGRR', 'BACK'};
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
    out = eqn_groundMedianWaveletPSD_5min_Kp(i, FREQS, ...
    MARGIN_FLAG, FILE_TYPE, PATH, STATION_NAME);
    
    if ~isempty(out)
        s = size(out);

        out(isnan(out)) = -10^30;

        spaces = repmat(' ', [288,1]);
        dayString = num2str(fix(out(:,end)), '%d');
        hrString = datestr(out(:,end), 'HH');
        minString = datestr(out(:,end), 'MM');
        valString = sprintf('%+.6e ', out(:,1:end-1)');
        valMat = reshape(valString, [14*(s(2)-1), 288]);
        newline = repmat('\n', [288,1]);

        outCharMat = [dayString, spaces, hrString, spaces, minString, spaces, valMat',newline];
        fprintf(fid,outCharMat');
    end
end


fclose(fid);
toc

end