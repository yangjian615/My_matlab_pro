function [data, file_meta, filenameList] = eqn_UniversalSpaceDataLoader_CHAMP(...
    DATE_RANGE, ~, FILETYPE, FIELD_CHOICE, DATA_SOURCE)
%eqn_SwarmDataLoader Gets data from the SWARM mission.
%
% DATE_RANGE: 1x2 vector of initial and final times (in matalbd)
% SATELLITE: Satellite symbol. Set to 'A', 'B' or 'C'.
% FILETYPE: Type of file. Can be 'MAG_LR', 'MAG_HR', 'MAG_CA' or 'EFI_PL'
% FIELD_CHOICE: The variable to be loaded, i.e. B_NEC, B_VFM, 

%------------INPUT PARAMS--------------------------------------------------

DATA_LOAD_FLAG = true;
% If set to 'false' only the files will be downloaded, at the specified
% folders, but no data will be read. Useful for mass downloads, when no
% processing is required.

MISSION = 'CH';
% 'SW' for Swarm mission. Leave as is.

CLASS = 'ME'; 
% 'OPER' for operational data or 'RPRO' for reprocessed data. Can also be
% set to '*' to search for whichever version is available

VERSION = '*';
% Data version. Can be set to '*' to get the latest version available.

SDL_OBS_NAME = 'CHAMP';

switch FILETYPE
    case 'FGM_FGM'
        TYPE = 'FGM-FGM';
        SAMPLING_TIME = 1;
    case 'FGM_NEC'
        TYPE = 'FGM-NEC';
        SAMPLING_TIME = 1;
    case 'OVM'
        TYPE = 'OVM';
        SAMPLING_TIME = 1;
    case 'PLP'
        TYPE = 'PLP';
        SAMPLING_TIME = 15;
    case 'FGMFGM' % spacial type for the ASCII FGM files
        TYPE = 'fgmfgm';
        SAMPLING_TIME = 1;
end

switch FIELD_CHOICE
    case 'B_FGM'
        VARS = {'VEC', 'GEO_LAT', 'GEO_LON', 'GEO_ALT', 'EPOCH'};
        DIMS = [ 3;         1;        1;          1;        1];
        SDL_VAR_NAMES = {'B^{FGM}_1', 'B^{FGM}_2', 'B^{FGM}_3','Latitude', 'Longitude', 'Radius', 'Time'};
        SDL_VAR_UNITS = {'nT','nT','nT','deg',        'deg',     'km',  'matlabd'};
        SDL_F_COORD = 'INSTR';
        SDL_X_COORD = 'rGEO';
        SDL_X_INDEX = 4; % Begining Index of Positional data
    case 'B_NEC'
        VARS = {'VEC', 'GEO_LAT', 'GEO_LON', 'GEO_ALT', 'EPOCH'};
        DIMS = [ 3;         1;        1;          1;        1];
        SDL_VAR_NAMES = {'B^{NEC}_N', 'B^{NEC}_E', 'B^{NEC}_C', 'Latitude', 'Longitude', 'Radius', 'Time'};
        SDL_VAR_UNITS = {'nT','nT','nT','deg',        'deg',     'km',  'matlabd'};
        SDL_F_COORD = 'NEC';
        SDL_X_COORD = 'rGEO';
        SDL_X_INDEX = 4; % Begining Index of Positional data
    case 'B'
        VARS = {'B_TOTAL', 'GEO_LAT', 'GEO_LON', 'GEO_ALT', 'GPS_TM', 'MSEC_O'};
        DIMS = [ 1;            1;        1;          1;        1;        1];
        SDL_VAR_NAMES = {'B^{OVM}', 'Latitude', 'Longitude', 'Radius', 'Time'};
        SDL_VAR_UNITS = {'nT',        'deg',        'deg',     'km',  'matlabd'};
        SDL_F_COORD = [];
        SDL_X_COORD = 'rGEO';
        SDL_X_INDEX = 2; % Begining Index of Positional data
    case 'n'
        VARS = {'n', 'GEO_LAT', 'GEO_LON', 'RADIUS', 'TIME'};
        DIMS = [ 1;      1;        1;          1;        1];
        SDL_VAR_NAMES = {'N_e', 'Latitude', 'Longitude', 'Radius', 'Time'};
        SDL_VAR_UNITS = {'cm^{-3}', 'deg',     'deg',     'km',  'matlabd'};
        SDL_F_COORD = [];
        SDL_X_COORD = 'rGEO';
        SDL_X_INDEX = 2; % Begining Index of Positional data
end

% Path to the dir for final data files.
TEMP = DATA_SOURCE{1};
if ~isempty(TEMP)
    if TEMP(end) ~= '\'; TEMP = [TEMP, '\']; end;
    DELETE_TEMP = false;
else
    TEMP = 'temp\';
    DELETE_TEMP = true;
end

% Path to the local data directory.
PATH = DATA_SOURCE{2};
if ~isempty(PATH)
    if PATH(end) ~= '\'; PATH = [PATH, '\']; end;
    DELETE_PATH = false;
else
    PATH = 'tempPath\';
    DELETE_PATH = true;
end

% Remote server credentials
if ~isempty(DATA_SOURCE{3})
    REMOTE = DATA_SOURCE{3};
    SERVER = REMOTE{1};
    USER = REMOTE{2};
    PASS = REMOTE{3};
    if isempty(USER)
        SERVER = [];
        disp('DataLoader: No User Name specified for ftp connection!');
    end
else
    SERVER = [];
end

% END OF INPUT PARAMETERS-YOU DON'T NEED TO CHANGE ANYTHING BELOW THIS LINE
%--------------------------------------------------------------------------

%------------MODIFYING INPUT PARAMS----------------------------------------

% get dates in a list (one for each day) 
dateList = (fix(DATE_RANGE(1)) - 1 : 1 : fix(DATE_RANGE(end)))';
nDays = length(dateList);

% get date string in the format 'yyyy-mm-dd'
dateStrings = datestr(dateList, 'yyyy-mm-dd');

file_type = TYPE;
fgmfgm_Epoch = datenum(2000,1,1);

%------------ALLOCATING BUFFER TO HOLD OUTPUT------------------------------

% get number of matrix columns
nVars = sum(DIMS); 
% get maximum possible number of rows (1.002 * nDays because the daily
% files contain a few entries from the previous and next days as well, so
% they usually have a bit more that 86400 data)
maxL = ceil(1.002*nDays*86400/SAMPLING_TIME) + 1;
% initialize NaN matrix
data = nan(maxL, nVars);
% initialize counter
nEntries = 0;

% create an empty cell list to hold the final filenames
filenameList = cell(nDays,1);

%--------------------------------------------------------------------------

for i=1:nDays-1
    % filenames can be either of the type "2003-01-01-00-00-00" or of the 
    % type "2002-12-31-23-59-59". So to get the Jan 1st of 2003 you have to
    % look for both Dec 31st of 2002 (23-59-59) AND Jan 1st 2003 (00-00-00)
    
    % Index i is for the previous date. i+1 for the current date of
    % interest.
    disp(['Target Date: ', dateStrings(i+1,:)]);
    
    if strcmpi(FILETYPE, 'fgmfgm')
        filename = [FILETYPE, '-' , num2str(dateList(i+1) - fgmfgm_Epoch, '%04d')];
        SEARCH_0 = false;
    elseif strcmp(FILETYPE, 'PLP')
        filename = [MISSION, '-', CLASS, '-', '2', '-', file_type, '+',...
            dateStrings(i+1,:), '_', VERSION, '.dat'];
        SEARCH_0 = false;
    else
        filename = [MISSION, '-', CLASS, '-', '2', '-', file_type, '+',...
            dateStrings(i,:),'-', '2*-*-*','.140-', VERSION, '.cdf'];
        filename0 = [MISSION, '-', CLASS, '-', '2', '-', file_type, '+',...
            dateStrings(i+1,:),'-', '0*-*-*','.140-', VERSION, '.cdf'];
        SEARCH_0 = true;
    end


    FILE_FOUND_FLAG = 0;
    
    % look for the file in the temporary directory
    if ~isempty(TEMP)
        if exist(TEMP, 'dir')
            disp('Looking for file in the temp dir');
            [TF, actualfilename] = eqn_fileExists([TEMP, filename], 10);
            if TF
                FILE_FOUND_FLAG = 1;
                disp('    File found in temp!');
                disp(actualfilename);
                filenameList{i} = actualfilename;
            else
                if SEARCH_0
                    [TF, actualfilename] = eqn_fileExists([TEMP, filename0], 10);
                    if TF
                        FILE_FOUND_FLAG = 1;
                        disp('    File found in temp!');
                        disp(actualfilename);
                        filenameList{i} = actualfilename;
                    else
                        disp('    File not found in temp!');
                    end
                else
                    disp('    File not found in temp!');
                end
            end
        else
            mkdir(TEMP);
        end
    end
    
    % if the file was not found, go to the local path specified and look 
    % there for the corresponding file
    if ~FILE_FOUND_FLAG && ~isempty(PATH)
        disp('Seeking file in local PATH');
        localpathname = [PATH, ...
            FILETYPE, '\', ...
            dateStrings(i, 1:4), '\', ...
            filename];
        disp(localpathname);
        [TF, fullname] = eqn_fileExists(localpathname, 100);
        if TF % if file exists
            disp('    File found!');
            FILE_FOUND_FLAG = 1;
            filenameList{i} = fullname;
        else
            if SEARCH_0
                localpathname0 = [PATH, ...
                    FILETYPE, '\', ...
                    dateStrings(i, 1:4), '\', ...
                    filename0];
                [TF, fullname] = eqn_fileExists(localpathname0, 100);
                
                if TF % if file exists
                    disp('    File found!');
                    FILE_FOUND_FLAG = 1;
                    filenameList{i} = fullname;
                    disp(localpathname0);
                else
                    disp('    No file found on the local PATH!');
                end
            else
                disp('    No file found on the local PATH!');
            end
        end
        
    end
    
    % if the file was not found, go to the FTP server and look there for
    % the corresponding file
    if ~FILE_FOUND_FLAG && ~isempty(SERVER)
        disp('Requesting file from server');
        if ~exist('ftpObj', 'var')
            ftpObj = ftp(SERVER, USER, PASS);
        end
        
        % Modify remote path for the case of Tromos ftp server
        if strfind(SERVER, 'tromos')
            ADDPATH = 'champdata/';
        else
            ADDPATH = '';
        end
        
        remotepathname = [ADDPATH, FILETYPE, '/', ...
            dateStrings(i, 1:4), '/', ...
            filename];
        
        [TF, fullname] = eqn_ftpFileExists(ftpObj, remotepathname, 100);
        if ~TF && SEARCH_0
            remotepathname0 = [ADDPATH, FILETYPE, '/', ...
                dateStrings(i, 1:4), '/', ...
                filename0];
            [TF, fullname] = eqn_ftpFileExists(ftpObj, remotepathname0, 100);
        end
            
        if TF % if file exists
            disp('    File found on the server!');
            
            COPY_FLAG = false;
            
%             if DELETE_PATH
%                 DOWNLOAD_LOCATION = TEMP;
%             else
%                 DOWNLOAD_LOCATION = PATH;
%                 if ~DELETE_TEMP
%                     COPY_FLAG = true;
%                 end
%             end

                DOWNLOAD_LOCATION = PATH;
                if ~DELETE_TEMP
                    COPY_FLAG = true;
                end

            % mget() and unzip() work better with fullpathnames
            % check if PATH is full or relative path and 
            % correct it accordingly
            corrPath = '';
            if DOWNLOAD_LOCATION(2) == ':' % begins with c: so is absolute path
                % nothing
            else
                corrPath = [pwd, '\'];
            end
            
            % download zip file from server
            mget(ftpObj, fullname, [corrPath, DOWNLOAD_LOCATION]);
            
            % get the actualfilename
            actualfilename = [DOWNLOAD_LOCATION, fullname];
            if exist(actualfilename, 'file')
                FILE_FOUND_FLAG = 1;
                disp('    File was transfered correctly!');
                disp(actualfilename);
                filenameList{i} = actualfilename;
            end
            
            if COPY_FLAG % also copy file from PATH to TEMP
                ind = find(actualfilename=='/' | actualfilename=='\', 1, 'last');
                copyfile(actualfilename, [TEMP, actualfilename(ind+1:end)]);
            end

        else
            disp('    No file found on the server!');
        end
    end
    
    if ~FILE_FOUND_FLAG
        disp('No files found for this day. Continuing with the rest.');
        disp(' ');
    else
        % Proceeding to data loading.
        if DATA_LOAD_FLAG
            if strcmpi(TYPE, 'FGMFGM')
                [file_data, file_meta] = eqn_readFile(filenameList{i}, 'champ-fgm');
            elseif strcmpi(TYPE, 'PLP')
                file_data = eqn_load_CHAMP_PLP_Data(filenameList{i});
            else
                [file_data, file_meta] = eqn_readFile(filenameList{i}, 'cdf', VARS);
            end
            nFileEntries = size(file_data,1);
    
            % case 'OVM': calculate the correct time (from GPS format to matlab time)
            % and divide B measurements by 100 to convert to nT
            if strcmp(TYPE, 'OVM')
                matlab_time_from_GPS_time = (file_data(:,end-1)+(file_data(:,end)/10000))/(86400) + datenum('1980-01-06 00:00');
                file_data(:,end-1) = matlab_time_from_GPS_time;
                clear('matlab_time_from_GPS_time');
                file_data(:,1) = file_data(:,1) / 100;
            end
            
            data(nEntries+1:nEntries+nFileEntries,:) = file_data;
            nEntries = nEntries + nFileEntries;
            clear('file_data');
        end
    end
    
end

% close connection to the server
if exist('ftpObj', 'var')
    close(ftpObj);
end

% delete PATH and all its contents (if flag set to true)
if exist(PATH, 'dir')
    if DELETE_PATH
        rmdir(PATH, 's');
    end
end

% delete TEMP and all its contents (if flag set to true)
if exist(TEMP, 'dir')
    if DELETE_TEMP
        rmdir(TEMP, 's');
    end
end

% clear unused part of the data matrix & correct Altitude to Radius
if DATA_LOAD_FLAG
    data(nEntries+1:maxL,:) = [];
    
    % Add reference radius to Altitude to make it Radius
    % NOT for PLP data (they are already in RADIUS format)
    if ~strcmp(TYPE, 'PLP')
        data(:, SDL_X_INDEX+2) = data(:, SDL_X_INDEX+2) + 6371.200195312500;
    else
        % change units for n_e (count million e- per cm^{-3}_
        data(:,1) = data(:,1) / 10^6;
    end
    
    if strcmp(TYPE, 'OVM')
        % clear last column (has the MSEC field which is not necessary any
        % more since the matlab time has been placed in the end-1 column
        data(:,end) = []; 
    end
                             
    [intTime, data] = eqn_setCadence(data(:,end), data, SAMPLING_TIME/86400, DATE_RANGE);
    data(:,end) = intTime;
    
    % Additional Metadata (included in the file metadata)
    file_meta.SDL_OBS_NAME = SDL_OBS_NAME;
    file_meta.SDL_VAR_NAMES = SDL_VAR_NAMES;
    file_meta.SDL_VAR_UNITS = SDL_VAR_UNITS;
    file_meta.SDL_F_COORD = SDL_F_COORD;
    file_meta.SDL_X_COORD = SDL_X_COORD;
    file_meta.SDL_X_INDEX = SDL_X_INDEX;
    file_meta.SDL_SAMPLING_TIME = SAMPLING_TIME;
end

end