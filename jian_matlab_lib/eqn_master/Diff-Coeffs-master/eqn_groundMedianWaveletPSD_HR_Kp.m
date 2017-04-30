function outputMatrix = eqn_groundMedianWaveletPSD_HR_Kp(day, FREQS, ...
    MARGIN_FLAG, FILE_TYPE, PATH, STATION_NAME)

% Gives the logarithm of the median wavelet PSD for diffusion coefficients 
% calculation.
%
% logMedianPSD = eqn_groundMedianWaveletPSD(t_beg, t_end, FREQS, 
%                               MARGIN_FLAG, FILE_TYPE, PATH, STATION_NAME)
%
% t_beg and t_end are the initial and final times of the interval in
% question. Use i.e. datenum(2003, 12, 31, 23, 56, 45) to set one of them
% to 31st Dec 2003, 23:56:45. 
%
% FREQS: list of frequency values to use for the process (in Hz)
%
% MARGIN_FLAG: true or false, specifying if additional MARGINS are needed
% for the spectral processing
%
% FILE_TYPE: string of the type of input data to be used. Valid choices
% are: 
%     'IMAGE'      for data from the IMAGE network
%     'CARISMA'    for data from the CARISMA network
%     'CANOPUS'    for pre 2005 data from the CARISMA network
%
% PATH: the path to the location of the data. IMAGE data require a specific
% placement in the drive of the form i.e.
%     C:\Data\KIR\2003\IMAGE_KIR_2003_04_01.txt
% In this case PATH corresponds to 'C:\Data\' and tha data must be placed
% in folders according to station and year. 
%
% STATION_NAME: a string with the name of the station (as it appears in the
% filename itself, i.e. PINA for the Pinawa station of CARISMA, or KIR for 
% Kiruna station of IMAGE.
%
% The result is the logarithm of the median wavelet PSD for each input 
% frequency, with the median taken only from daytime values (MLT > 6:00 & 
% MLT < 18:00).
%

t_beg = fix(day);
t_end = t_beg + 1 - 10^(-7);
noon = t_beg + 0.5;
disp(['Processing: ',datestr(t_beg,'dd mmm yyyy HH:MM'),' - ',datestr(t_end,'dd mmm yyyy HH:MM')])

MIN_FREQ = min(FREQS);

% Calculate MARGINS according to min frequency
if MARGIN_FLAG
    MARGIN = (5*(1/MIN_FREQ))/86400;
else
    MARGIN = 0;
end

% Add MARGINS to time interval (if needed)
t_beg_marg = t_beg - MARGIN;
t_end_marg = t_end + MARGIN;

% Check if PATH parameter was given correctly (with a final '\' char)
if filesep=='\';
if PATH(end) ~= '\'; PATH = [PATH,'\']; end
else
if PATH(end) ~= '/'; PATH = [PATH,'/']; end    
end

% Read data from files according to FILE_TYPE
FILL_VAL = [];
switch FILE_TYPE
    case 'IMAGE'
        SAMPLING_TIME = 10;
        filelist = eqn_getImageFileList(t_beg_marg, t_end_marg, PATH, STATION_NAME);
        [data_init, temp_file_meta] = eqn_loadDataFromImageFileList(t_beg_marg, t_end_marg, SAMPLING_TIME, filelist);
        if ~isempty(temp_file_meta); 
            FILL_VAL = str2double(temp_file_meta.FILL_VAL);
            file_meta = temp_file_meta;
        end
    case 'CARISMA'
        SAMPLING_TIME = 1;
        filelist = eqn_getCarismaFileList(t_beg_marg, t_end_marg, PATH, STATION_NAME);
        [data_init, file_meta] = eqn_loadDataFromCarismaFileList(t_beg_marg, t_end_marg, SAMPLING_TIME, filelist);
    case 'CANOPUS'
        SAMPLING_TIME = 5;
        filelist = eqn_getCanopusFileList(t_beg_marg, t_end_marg, PATH, STATION_NAME);
        [data_init, file_meta] = eqn_loadDataFromCanopusFileList(t_beg_marg, t_end_marg, SAMPLING_TIME, filelist);
    otherwise
        error('Unrecognised FILE_TYPE parameter!');
end

if ~isempty(data_init)

    if ~isempty(FILL_VAL)
        disp('!');
        data_init(data_init == FILL_VAL) = NaN;
    end

    % Set constant Cadence
    [t, data] = eqn_setCadence(data_init(:,end), data_init, SAMPLING_TIME/86400, [t_beg_marg, t_end_marg]);
    % clear('data_init');
    L = length(t);

    % Choose component for processing (1, 2, or 3 for H, D, Z or X, Y, Z)
    % calculate declination of IGRF magnetic field at station's location
    % (once per day is enough)
    lat = file_meta.COORDS(1);
    lon = file_meta.COORDS(2);
    alt = 0;
    [~, ~, dec] = igrf11magm(alt, lat, lon, decyear(noon));
    Bd = - sqrt(sum(data(:,1:2).^2,2)) .* sin((pi/180)*dec - atan(data(:,2)./data(:,1)));
    % B = data(:,2); % plot(data(:,end), data(:,2), '-b', data(:,end), Bd, '-r');
    B = Bd;
    disp(['    Decl = ', num2str(dec, '%.3f')]);
    clear('data');

    % Interpolate NaNs
    Bi = eqn_interpolateNaN(B);

    % Filter data (if needed)
    % B = B - eqn_filter(B, SAMPLING_TIME, MIN_FREQ, 'low', 'cheby2');

    % Wavelet Analysis
    W = eqn_wavelet_morlet(Bi, SAMPLING_TIME, FREQS, 6);
    Wp = abs(W).^2; % PSD spectrum
    clear('W');

    % Remove MARGINS
    if MARGIN_FLAG
        ti_beg = find(t >= t_beg, 1, 'first');
        ti_end = find(t <= t_end, 1, 'last');
    else
        ti_beg = 1;
        ti_end = L;
    end
    t = t(ti_beg:ti_end);
    Wout = Wp(:, ti_beg:ti_end);   
    B = B(ti_beg:ti_end);
    clear('Wp');

    % Calculate MLT (station taken at 1 Re distance)
    L = length(t); % run length() again because t might have changed due to margin removal
    rGEO = nan(L,3);
    rGEO(:,1) = file_meta.COORDS(1) * ones(L,1);
    rGEO(:,2) = file_meta.COORDS(2) * ones(L,1);
    rGEO(:,3) = ones(L,1);
    MLT = eqn_coordinateTransform(t, rGEO, 'rGEO', 'MLT');

    % load Kp data
    Kp_data = load('Kp_2000-2014.mat');

    nFreqs = length(FREQS);
    outputMatrix = nan(24, nFreqs + 1 + 1 + 1); % nFreqs + Kp + MLT + time

    % do the processing for each hour (UT)
    for i=0:23
        timeInd = find(t >= t_beg + i/24 & t < t_beg + (i+1)/24);
        timeInterval = t(timeInd);

        % Accept intervals with more than 50% real data
        if ((length(timeInterval) - sum(isnan(B(timeInd))))*SAMPLING_TIME > 3600*0.5)
            logMedianPSD = log10(median(Wout(:, timeInd), 2));
        else
            logMedianPSD = nan(nFreqs,1);
        end
        medianMLT = median(MLT(timeInd));
        meanKp = mean(eqn_getKp(timeInterval, Kp_data));
        outputMatrix(i+1,:) = [logMedianPSD', meanKp, medianMLT, median(timeInterval)];
    end
else
    outputMatrix = [];
end
end

% % PLOTTING PART ---------------------------------------------------------
% xticks = linspace(t(1),t(end),11);
% xticklabels = datestr(xticks,'HH:MM');
% 
% subplot(3,1,1); plot(t, MLT, '-b', t(ind), MLT(ind), 'xr', 'LineWidth', 3)
% set(gca, 'xtick', xticks, 'xticklabel', xticklabels);
% ylabel('MLT');
% 
% subplot(3,1,3); plot(log10(FREQS), log10(medianPSD), '-x');
% set(gca, 'xtick', (log10(0.5/1000):log10(2):log10(1000/1000))', 'xticklabel', 10.^(log10(0.5/1):log10(2):log10(1000/1)));
% xlabel('log_{10} Freq (Hz)');
% ylabel('log_{10} PSD (nT^2/Hz)');
% P = polyfit(log10(FREQS), log10(medianPSD), 1);
% P(1)
% 
% subplot(3,1,2); imagesc(t, log10(FREQS), log10(Wout), [-2 2]);
% p = get(gca, 'Position'); p(3) = p(3)*1.16; set(gca, 'Position', p);
% colorbar;
% set(gca, 'ydir', 'normal', 'xtick', xticks, 'xticklabel', xticklabels, ...
%     'ytick', (log10(0.5/1000):log10(2):log10(1000/1000)), 'yticklabel', 10.^(log10(0.5):log10(2):log10(1000))');
% ylabel('Freq (mHz)');