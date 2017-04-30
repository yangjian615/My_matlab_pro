function [data, file_meta, filenameList] = eqn_UniversalSpaceDataLoader_ST5(...
    DATE_RANGE, SATELLITE, ~, FIELD_CHOICE, DATA_SOURCE)
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

MISSION = 'ST5';
% 'SW' for Swarm mission. Leave as is.

switch SATELLITE
    case 'A'
        SAT = '094';
    case 'B'
        SAT = '155';
    case 'C'
        SAT = '224';
    otherwise
        error('Wrong Satellite name/number!');
end

SDL_OBS_NAME = [MISSION, '-', SAT];

SAMPLING_TIME = 1;

switch FIELD_CHOICE
    case 'B_SM'
        % VARS = {'VEC', 'X', 'Y', 'Z', 'EPOCH'}; & unnecessary for non-cdf
        DIMS = [ 3;     1;   1;   1;        1];
        SDL_VAR_NAMES = {'B^{SM}_X', 'B^{SM}_Y', 'B^{SM}_Z', 'X_{SM}', 'Y_{SM}', 'Z_{SM}', 'Time'};
        SDL_VAR_UNITS = {'nT',          'nT',       'nT',     'Re',      'Re',     'Re',  'matlabd'};
        SDL_F_COORD = 'xSM';
        SDL_X_COORD = 'xSM';
        SDL_X_INDEX = 4; % Begining Index of Positional data
    case 'B-IGRF_SM'
        % VARS = {'VEC', 'X', 'Y', 'Z', 'EPOCH'}; & unnecessary for non-cdf
        DIMS = [ 3;     1;   1;   1;        1];
        SDL_VAR_NAMES = {'(B-IGRF)^{SM}_X', '(B-IGRF)^{SM}_Y', '(B-IGRF)^{SM}_Z', 'X_{SM}', 'Y_{SM}', 'Z_{SM}', 'Time'};
        SDL_VAR_UNITS = {'nT',                    'nT',               'nT',        'Re',      'Re',     'Re',  'matlabd'};
        SDL_F_COORD = 'xSM';
        SDL_X_COORD = 'xSM';
        SDL_X_INDEX = 4; % Begining Index of Positional data        
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
dateList = (fix(DATE_RANGE(1)) : 1 : fix(DATE_RANGE(end)))';
nDays = length(dateList);

% get date string in the format 'yyyy_mm_dd'
dateStrings = datestr(dateList, 'yyyy_mm_dd');

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

for i=1:nDays
    disp(['Target Date: ', dateStrings(i,:)]);
    
    filename = [MISSION, '-' , SAT, '_', dateStrings(i,:), '_1sec'];

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
                disp('    File not found in temp!');
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
            MISSION, '-', SAT, '\',...
            filename];
        
        [TF, fullname] = eqn_fileExists(localpathname, 100);
        if TF % if file exists
            disp('    File found!');
            FILE_FOUND_FLAG = 1;
            filenameList{i} = fullname;
        else
            disp('    No file found on the local PATH!');
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
            ADDPATH = 'st5data/';
        else
            ADDPATH = '';
        end
        
        remotepathname = [ADDPATH, MISSION, '-', SAT, '/',...
            filename];
        
        [TF, fullname] = eqn_ftpFileExists(ftpObj, remotepathname, 100);
            
        if TF % if file exists
            disp('    File found on the server!');
            
            COPY_FLAG = false;

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
            [file_data, file_meta] = eqn_readFile(filenameList{i}, 'ST5');
            nFileEntries = size(file_data,1);
            
            if strcmp(FIELD_CHOICE, 'B_SM')
                data(nEntries+1:nEntries+nFileEntries,:) = file_data(:, [1:3,7:end]);
            elseif strcmp(FIELD_CHOICE, 'B-IGRF_SM')
                file_data(:,1:3) = file_data(:,1:3) - file_data(:,4:6);
                data(nEntries+1:nEntries+nFileEntries,:) = file_data(:, [1:3,7:end]);
            end
            
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