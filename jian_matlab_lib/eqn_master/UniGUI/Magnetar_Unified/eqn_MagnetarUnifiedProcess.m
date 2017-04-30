function Magnetar = eqn_MagnetarUnifiedProcess(Missions, Satellites, ...
    Filetype, Field_choice, Component, Full_date, Pc_class, Latitude, Params,...
    procFlag)

% input parameters --------------------------------------------------------
% -------------------------------------------------------------------------

if nargin < 10; procFlag = 1; end

% end of input parameters -------------------------------------------------
% -------------------------------------------------------------------------

switch Pc_class
    case 'Pc34-16'
        CUTOFF = 16/1000; % in Hz
        FREQS = 2.^linspace(log2(10/1000), log2(100/1000), 50); % in
    case 'Pc34-10'
        CUTOFF = 10/1000; % in Hz
        FREQS = 2.^linspace(log2(10/1000), log2(100/1000), 50); % in
    case 'Pc34-5'
        CUTOFF = 5/1000; % in Hz
        FREQS = 2.^linspace(log2(10/1000), log2(100/1000), 50); % in
    case 'Pc34-20'
        CUTOFF = 20/1000; % in Hz
        FREQS = 2.^linspace(log2(10/1000), log2(100/1000), 50); % in
    case 'Pc45'
        CUTOFF = 1/1000; % in Hz
        FREQS = 2.^linspace(log2(1/1000), log2(10/1000), 50); % in Hz        
    case 'Pc35'
        CUTOFF = 1/1000; % in Hz
        FREQS = 2.^linspace(log2(1/1000), log2(100/1000), 50); % in Hz  
        
    case 'Pc1'
        CUTOFF = 1200/1000; % in Hz ( 0 => no filtering)
        FREQS = 2.^linspace(log2(1000/1000), log2(5000/1000), 50); % in Hz 
    case 'Pc2'
        CUTOFF = 100/1000; % in Hz ( 0 => no filtering)
        FREQS = 2.^linspace(log2(100/1000), log2(200/1000), 50); % in Hz 
    case 'Pc3'
        CUTOFF = 20/1000; % in Hz ( 0 => no filtering)
        FREQS = 2.^linspace(log2(20/1000), log2(100/1000), 50); % in Hz         
end

nPanels = sum(~cellfun(@isempty, Missions));

% Initialize output struct
Magnetar = struct('B', [], 'W', [], 'd', [] , 'R', [], 'Freq', [],...
                  'Bind', [], 'dind', [], 'Rind', [], 'label', []);
Magnetar.B = cell(nPanels,1);
Magnetar.W = cell(nPanels,1);
Magnetar.R = cell(nPanels,1);
Magnetar.d = cell(nPanels,1);
Magnetar.Freq = cell(nPanels,1);
Magnetar.Bind = cell(nPanels,1);
Magnetar.Rind = cell(nPanels,1);
Magnetar.dind = cell(nPanels,1);
Magnetar.label = cell(nPanels,1);

for i=1:nPanels
    
    Mission = Missions{i};
    
    % Get "Source" cell
    Source = eqn_getSource(Params, Mission);
    
    % Get Date Range & Extended Date Range
    if all(size(Full_date) == [1,2])
        DateRange = Full_date;
    else
        DateRange = eqn_CellDate2Datenum(Full_date);
    end
    MARGIN = round(10*(1/min(FREQS)))/86400; % in matlab_time
    t_beg_marg = DateRange(1) - MARGIN;
    t_end_marg = DateRange(end) + MARGIN;
    ExtDateRange = [t_beg_marg, t_end_marg];
    
    % Get Data
    [data, meta] = eqn_UniversalSpaceDataLoader(Mission, ...
        ExtDateRange, Satellites{i}, Filetype{i}, ...
        Field_choice{i}, Source);
    
    % Extract Field Data (selected component or sqrt of sum of squares of 
    % selected components.
    % The rule: Select the appopriate component (or magnitude) based on
    % the binary value of its representation:
    %           X  Y  Z
    % ONLY X : [1, 0, 0] = 4 (dec value of binary '100')
    % ONLY Y : [0, 1, 0] = 2 (dec value of binary '010')
    % ONLY Z : [0, 0, 1] = 1 (dec value of binary '001')
    % TOTAL  : [1, 1, 1] = 7 (dec value of binary '111')
    % |X+Y|  : [1, 1, 0] = 6 (dec value of binary '110')
    % |X+Z|  : [1, 0, 1] = 5 (dec value of binary '101')
    % |Y+Z|  : [0, 1, 1] = 3 (dec value of binary '011')
    compInds = find(dec2bin(Component(i), 3) == '1');
    if length(compInds) == 1 % Single Component Case
        F = data(:, [compInds(1), end]);
        label = meta.SDL_VAR_NAMES{compInds(1)};
    elseif sum(compInds == [1,2,3]) == 3 % Magnitude of all three comps
        F = [sqrt(sum(data(:, compInds).^2, 2)), data(:,end)];
        label_init = meta.SDL_VAR_NAMES{compInds(1)};
        label = [label_init(1:end-1), '{Total}'];
    else              % Some form of magnitude is needed
        F = [sqrt(sum(data(:, compInds).^2, 2)), data(:,end)];
        label_init = meta.SDL_VAR_NAMES{compInds(1)};
        label_all = cell2mat(meta.SDL_VAR_NAMES(compInds));
        label_comps = label_all(length(label_init):length(label_init):length(compInds)*length(label_init));
        label_comps_with_commas = regexprep(label_comps, '(\w)', '$0,');
        label = [label_init(1:end-1), '{', label_comps_with_commas(1:end-1), '}'];
    end
    
    % if absolutely no valid data points were found, create and assign an
    % empty Magnetar structure with nan values! Additionally create empty
    % Tracks, so that if there are multiple panels, the rest of the process
    % and plotting may continue unaffected!
    if all(all(isnan(data(:,1:end-1))))
        L = size(F,1);
        Magnetar.W{i} = nan(length(FREQS), L); 
        Magnetar.B{i} = [nan(L, 2), F(:,end)]; 
        Magnetar.R{i} = [zeros(L, 1), F(:,end)];
        Magnetar.d{i} = [];
        Magnetar.Freq{i} = FREQS;
        Magnetar.label{i} = [meta.SDL_OBS_NAME, ' ', label];
        
        % estimate max possible number of tracks = no_of_days * max_no_of_tracks_per_day
        nTracks = (floor(abs(diff(DateRange))) + 1) * 34; 
        Magnetar.Rind{i} = [ones(nTracks,1), L*ones(nTracks,1)];
        Magnetar.Bind{i} = [ones(nTracks,1), L*ones(nTracks,1)];
        Magnetar.dind{i} = nan(nTracks,2);
    else
    
    % Extract Positional Data and transform to the appropriate coordinates
    X = data(:, meta.SDL_X_INDEX:meta.SDL_X_INDEX+2);
    xGEO = eqn_coordinateTransform(data(:,end), X, meta.SDL_X_COORD, 'xGEO',...
        meta.SDL_VAR_UNITS{meta.SDL_X_INDEX+2});
    rMAG = eqn_coordinateTransform(data(:,end), xGEO, 'xGEO', 'rMAG');
    rGEO = eqn_coordinateTransform(data(:,end), xGEO, 'xGEO', 'rGEO');
    if isempty(rMAG)
        R = [rGEO(:,1:3), nan(size(xGEO, 1), 3), xGEO, data(:,end)];
    else
        R = [rGEO(:,1:3), rMAG(:,1:3), xGEO, data(:,end)];
    end

    clear data X xGEO rMAG;
    
    % Extract PLP data (if available)
    if strcmp(Mission, 'SWARM')
        [plpData, plpMeta] = eqn_UniversalSpaceDataLoader_Swarm_v2(...
        DateRange, Satellites{i}, 'EFI_PL', 'n', Source);
        d = [plpData(:,1), plpData(:,end)];
    elseif strcmp(Mission, 'CHAMP')
        [plpData, plpMeta] = eqn_UniversalSpaceDataLoader(Mission, ...
            DateRange, Satellites{i}, 'PLP', 'n', Source); %#ok<NASGU>
        d = [plpData(:,1), plpData(:,end)];
    else
        d = [];
    end
%    d = [];
    
    % Begining Processing -------------------------------------------------
    
    % Processing Params
    SAMPLING_TIME = meta.SDL_SAMPLING_TIME;
    WAVELET_PARAMETER = 6;
    t_beg = DateRange(1);
    t_end = DateRange(end);
    TRACK_BY_TRACK_FLAG = true;
    magLatLims = Latitude;
    
    % check for NaNs
    nanInds = isnan(F(:,1));
    nNaNs = sum(nanInds);
    nPnts = size(F, 1);
    disp(['NaN Values: ' num2str(nNaNs) ' out of ' num2str(nPnts),...
        ' data points (' num2str(100*nNaNs/nPnts, '%.2f') '%)']);
    
    % interpolate NaNs
    Fix = eqn_interpolateNaN(F(:,1));
    
    % filter
    if CUTOFF > 0
        Ffix = Fix - eqn_filter(Fix, SAMPLING_TIME, CUTOFF, 'low', 'cheby2');
      % Ffix = eqn_filter(Fix, SAMPLING_TIME, CUTOFF, 'high', 'cheby1');
    else
        Ffix = Fix;
    end
    
    % zero pad
    Fpfix = [Ffix; zeros(ceil(2*MARGIN*86400/SAMPLING_TIME),1)];
    
    % make sure Length is even
    if mod(length(Fpfix),2) ~= 0; Fpfix(end) = []; end; 
    
    if procFlag
        % wavelet
        wave = eqn_wavelet_morlet(Fpfix, SAMPLING_TIME, FREQS, WAVELET_PARAMETER);
        % save results to Magnetar
        Magnetar.W{i} = abs(wave(:,1:length(Ffix))).^2;
    else
        % otherwise use an empty Magnetar
        Magnetar.W{i} = nan(length(FREQS), length(Ffix));
    end
    
    Magnetar.B{i} = [Ffix, F(:,1), F(:,end)];
    % Magnetar.B{i} = F;
    Magnetar.B{i}(nanInds, 1) = NaN;
    Magnetar.R{i} = R;
    Magnetar.d{i} = d;
    Magnetar.Freq{i} = FREQS;
    Magnetar.label{i} = [meta.SDL_OBS_NAME, ' ', label];

    % remove margins
    ti_big = find(Magnetar.B{i}(:,end) >= t_beg, 1, 'first');
    ti_end = find(Magnetar.B{i}(:,end) <= t_end, 1, 'last');
    Magnetar.B{i} = Magnetar.B{i}(ti_big:ti_end,:);
    Magnetar.W{i} = Magnetar.W{i}(:,ti_big:ti_end);

    ti_big = find(Magnetar.R{i}(:,end) >= t_beg, 1, 'first');
    ti_end = find(Magnetar.R{i}(:,end) <= t_end, 1, 'last');
    Magnetar.R{i} = Magnetar.R{i}(ti_big:ti_end,:);

%         % 'd' does not have Margins, so there is nothing to remove        
%         if ~isempty(Magnetar.d{i})
%             ti_big = find(Magnetar.d{i}(:,end) >= t_beg, 1, 'first');
%             ti_end = find(Magnetar.d{i}(:,end) <= t_end, 1, 'last');
%             Magnetar.d{i} = Magnetar.d{i}(ti_big:ti_end,:);
%         end

    % use findpeaks() to make sure track_by_track works even when the lims are
    % below the local maxima (i.e. set X(findpeaks) = 100 (sth above 90), so 
    % that the algorithm will detect it and cut the track there)

    % get indexes for plotting
    if ~TRACK_BY_TRACK_FLAG
        % Single Pass Analysis
            B_L = size(Magnetar.B{i},1);
            Magnetar.Bind{i} = [1, B_L];

            R_L = size(Magnetar.R{i},1);
            Magnetar.Rind{i} = [1, R_L];

            if ~isempty(Magnetar.d{i})
                d_L = size(Magnetar.d{i},1);
                Magnetar.dind{i} = [1, d_L];
            end

    else
        % Track By Track Analysis
            % get Mag. Lat (or GEO latitude, if IRBEM was not found)
            if all(isnan(Magnetar.R{i}(:,4)))
                latIndex = 1;
            else
                latIndex = 4;
            end
            iMagLat = eqn_interpolateNaN(Magnetar.R{i}(:, latIndex));

            % find local max/min and set to extreme values, so that the process
            % will always cut the Tracks at those points
            [~, locsMax] = findpeaks(iMagLat, 'MINPEAKHEIGHT', 30);
            [~, locsMin] = findpeaks(-iMagLat, 'MINPEAKHEIGHT', 30);
            iMagLat(locsMax) = 91;
            iMagLat(locsMin) = -91;

            trackLogicalIndices = find(iMagLat >= min(magLatLims) & iMagLat <= max(magLatLims));
            if ~isempty(trackLogicalIndices)
                trackIndices = eqn_breakToConsecutiveIndices(trackLogicalIndices);
                nTracks = size(trackIndices,1);

                Magnetar.Rind{i} = trackIndices;
                Magnetar.Bind{i} = zeros(nTracks,2);
                Magnetar.dind{i} = zeros(nTracks,2);
    %            Magnetar.Lind{i} = zeros(nTracks,2);

                for trackIndex = 1:nTracks
                    Bind1 = find(Magnetar.B{i}(:,end) >= Magnetar.R{i}(trackIndices(trackIndex,1),end), 1, 'first');
                    Bind2 = find(Magnetar.B{i}(:,end) <= Magnetar.R{i}(trackIndices(trackIndex,2),end), 1, 'last');

                    Magnetar.Bind{i}(trackIndex,1) = Bind1;
                    Magnetar.Bind{i}(trackIndex,2) = Bind2;

                    if ~isempty(Magnetar.d{i})
                        f1 = find(Magnetar.d{i}(:,end) >= Magnetar.R{i}(trackIndices(trackIndex,1),end), 1, 'first');
                        f2 = find(Magnetar.d{i}(:,end) <= Magnetar.R{i}(trackIndices(trackIndex,2),end), 1, 'last');
                        if isempty(f1) || isempty(f2)
                            Magnetar.dind{i}(trackIndex,1) = nan;
                            Magnetar.dind{i}(trackIndex,2) = nan;
                        else
                            Magnetar.dind{i}(trackIndex,1) = f1;
                            Magnetar.dind{i}(trackIndex,2) = f2;
                        end
                    end
                end

            else
                disp('No Tracks found for the declared limits!');
                nTracks = 0;
            end
    end

    if nTracks >2
        % remove first track if too short
        d = diff(Magnetar.Bind{i}(1,:));
        if d < 100
                Magnetar.Rind{i}(1,:) = [];
                Magnetar.Bind{i}(1,:) = [];
                Magnetar.dind{i}(1,:) = [];
        end

        % remove last track if too short
        d = diff(Magnetar.Bind{i}(end,:));
        if d < 100
                Magnetar.Rind{i}(end,:) = [];
                Magnetar.Bind{i}(end,:) = [];
                Magnetar.dind{i}(end,:) = [];
        end
    end
    end % end if all(isnan)
end % end loop on panels

% assignin('base','Magnetar',Magnetar);
% signal_Plotter_44(Magnetar)

end % ends function