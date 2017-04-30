function [data, file_meta, filenameList] = eqn_UniversalSpaceDataLoader_Swarm_newPLP(...
    DATE_RANGE, SATELLITE, FILETYPE, FIELD_CHOICE, DATA_SOURCE)
%eqn_SwarmDataLoader Gets data from the SWARM mission.
%
% DATE_RANGE: 1x2 vector of initial and final times (in matalbd)
% SATELLITE: Satellite symbol. Set to 'A', 'B' or 'C'.
% FILETYPE: Type of file. Can be 'MAG_LR', 'MAG_HR', 'MAG_CA' or 'EFI_PL'
% FIELD_CHOICE: The variable to be loaded, i.e. B_NEC, B_VFM, 
% 
%------------INPUT PARAMS--------------------------------------------------

DATA_LOAD_FLAG = true;
% If set to 'false' only the files will be downloaded, at the specified
% folders, but no data will be read. Useful for mass downloads, when no
% processing is required.

MISSION = 'SW';
% 'SW' for Swarm mission. Leave as is.

CLASS = '*'; 
% 'OPER' for operational data or 'RPRO' for reprocessed data. Can also be
% set to '*' to search for whichever version is available. For new PLP data
% the CLASS 'PREL', for preliminary was added! Fore new MAG data the new
% class 'PPRO' was added!

VERSION = '*';
% Data version. Note that the official terminology for the version number
% assigns a four digit id to each version, i.e. version 0301. For this
% program, the official SWARM version has been broken down to two parts,
% the first two digits constitute the VERSION i.e. '03' for the previous
% case and the last two are dubbed SUBVERSION i.e. '01' for the example
% above. So here VERSION can be '01', '02' or '03' (so far). 
% WARNING: DO NOT use a wildcard character (*) here.

SUBVERSION = '*';
% Subversion of the data, usually set to '01'. Can be set to '*' to check
% for the latest subversion available.

SDL_OBS_NAME = ['SWARM-', SATELLITE];

switch FILETYPE
    case 'MAG_LR'
        TYPE = 'MAGX_LR_1B';
        RECORD = 'MDR_MAG_LR';
        SAMPLING_TIME = 1;
    case 'MAG_LR_PPRO'
        TYPE = 'MAGX_LR_1B';
        RECORD = 'MDR_MAG_LR';
        SAMPLING_TIME = 1;
    case 'MAG_HR'
        TYPE = 'MAGX_HR_1B';
        RECORD = 'MDR_MAG_HR';
        SAMPLING_TIME = 1/50;
    case 'MAG_CA'
        TYPE = 'MAGX_CA_1B';
        RECORD = 'MDR_MAG_CA';
        SAMPLING_TIME = 1;
    case 'EFI_PL'
        TYPE = 'EFIX_PL_1B';
        RECORD = 'MDR_EFI_PL';
        SAMPLING_TIME = 0.5;
    case 'EFI_LP' % new txt PLP data
        TYPE = 'EFIX_LP_1B';
        RECORD = '';
        SAMPLING_TIME = 0.5;
        VERSION = '01';
        FILE_EXT = 'txt';
    case 'EFI_TII'
        TYPE = 'EFIX_TII1B';
        RECORD = '';
        SAMPLING_TIME = 0.5;
        VERSION = '01';
        FILE_EXT = 'cdf';
end

switch FIELD_CHOICE
    case 'F'
        VARS = {'F', 'Latitude', 'Longitude', 'Radius', 'Flags_F', 'Timestamp'};
        DIMS = [ 1;         1;        1;          1;        1;         1];
        SDL_VAR_NAMES = {'B^{ASM}', 'Latitude', 'Longitude', 'Radius', 'Time'};
        SDL_VAR_UNITS = {'nT',        'deg',        'deg',     'm',  'matlabd'};
        SDL_F_COORD = [];
        SDL_X_COORD = 'rGEO';
        SDL_X_INDEX = 2; % Begining Index of Positional data
        if ~strcmp(FILETYPE, 'MAG_CA')
            FlagInd = 5; % index of corresponding FLAG parameter
            FlagThresh = 64; % from this value and on, discard data
        end
    case 'B_VFM'
        VARS = {'B_VFM', 'Latitude', 'Longitude', 'Radius', 'Flags_B', 'Timestamp'};
        DIMS = [ 3;         1;        1;          1;        1;         1];
        SDL_VAR_NAMES = {'B^{VFM}_1', 'B^{VFM}_2','B^{VFM}_3', ...
                         'Latitude', 'Longitude', 'Radius', 'Time'};
        SDL_VAR_UNITS = {'nT','nT','nT','deg',        'deg',     'm',  'matlabd'};
        SDL_F_COORD = 'INSTR';
        SDL_X_COORD = 'rGEO';
        SDL_X_INDEX = 4; % Begining Index of Positional data
        FlagInd = 7; % index of corresponding FLAG parameter
        FlagThresh = 31; % from this value and on, discard data
    case 'B_NEC'
        VARS = {'B_NEC', 'Latitude', 'Longitude', 'Radius', 'Flags_B', 'Timestamp'};
        DIMS = [ 3;         1;        1;          1;        1;         1];
        SDL_VAR_NAMES = {'B^{VFM}_N', 'B^{VFM}_E','B^{VFM}_C', ...
                         'Latitude', 'Longitude', 'Radius', 'Time'};
        SDL_VAR_UNITS = {'nT','nT','nT','deg',        'deg',     'm',  'matlabd'};
        SDL_F_COORD = 'NEC';
        SDL_X_COORD = 'rGEO';
        SDL_X_INDEX = 4; % Begining Index of Positional data
        FlagInd = 7; % index of corresponding FLAG parameter
        FlagThresh = 31; % from this value and on, discard data
    case 'F_VFM' % CA only
        VARS = {'F_VFM', 'Latitude', 'Longitude', 'Radius', 'Timestamp'};
        DIMS = [ 1;         1;        1;          1;          1];
        SDL_VAR_NAMES = {'B^{VFM (CA)}', 'Latitude', 'Longitude', 'Radius', 'Time'};
        SDL_VAR_UNITS = {'nT',        'deg',        'deg',     'm',  'matlabd'};
        SDL_F_COORD = [];
        SDL_X_COORD = 'rGEO';
        SDL_X_INDEX = 2; % Begining Index of Positional data
    case 'B'   % CA only
        VARS = {'B', 'Latitude', 'Longitude', 'Radius', 'Timestamp'};
        DIMS = [ 3;         1;        1;          1;       1];
        SDL_VAR_NAMES = {'B^{VFM (CA)}_1', 'B^{VFM (CA)}_2','B^{VFM (CA)}_3', ...
                         'Latitude', 'Longitude', 'Radius', 'Time'};
        SDL_VAR_UNITS = {'nT','nT','nT','deg',        'deg',     'm',  'matlabd'};
        SDL_F_COORD = 'INSTR';
        SDL_X_COORD = 'rGEO';
        SDL_X_INDEX = 4; % Begining Index of Positional data
    case 'n'
        VARS = {'n', 'Latitude', 'Longitude', 'Radius', 'Flags_LP_n', 'Timestamp'};
        DIMS = [ 1;         1;        1;          1;         1;             1];
        SDL_VAR_NAMES = {'n',             'Latitude', 'Longitude', 'Radius', 'Time'};
        SDL_VAR_UNITS = {'x10^6 cm^{-3}',   'deg',     'deg',         'm',  'matlabd'};
        SDL_F_COORD = [];
        SDL_X_COORD = 'rGEO';
        SDL_X_INDEX = 2; % Begining Index of Positional data    
        FlagInd = 5; % index of corresponding FLAG parameter
        FlagThresh = 23; % from this value and on, discard data
        if strcmp(FILETYPE, 'EFI_LP')
            FlagThresh = 64;
        end
    case 'E_NEC'
        VARS = {'E', 'Latitude', 'Longitude', 'Radius', 'Flags_TII', 'Timestamp'};
        DIMS = [ 3;         1;        1;          1;         1;          1];
        SDL_VAR_NAMES = {'E_N', 'E_E','E_C', ...
                         'Latitude', 'Longitude', 'Radius', 'Time'};
        SDL_VAR_UNITS = {'mV/m','mV/m','mV/m',...
                           'deg',       'deg',     'm',  'matlabd'};
        SDL_F_COORD = 'NEC';
        SDL_X_COORD = 'rGEO';
        SDL_X_INDEX = 4; % Begining Index of Positional data    
        FlagInd = 7; % index of corresponding FLAG parameter
        FlagThresh = 24; % from this value and on, discard data
    case 'E'
        VARS = {'E', 'latitude', 'longitude', 'radius', 'Flags_TII', 'Timestamp'};
        DIMS = [ 3;         1;        1;          1;         1;          1];
        SDL_VAR_NAMES = {'E_N', 'E_E','E_C', ...
                         'Latitude', 'Longitude', 'Radius', 'Time'};
        SDL_VAR_UNITS = {'mV/m','mV/m','mV/m',...
                           'deg',       'deg',     'm',  'matlabd'};
        SDL_F_COORD = 'NEC';
        SDL_X_COORD = 'rGEO';
        SDL_X_INDEX = 4; % Begining Index of Positional data    
        FlagInd = 7; % index of corresponding FLAG parameter
        FlagThresh = 24; % from this value and on, discard data
end

% Path to the dir for final, unzipped data files.
TEMP = DATA_SOURCE{1};
if ~isempty(TEMP)
    if TEMP(end) ~= '\'; TEMP = [TEMP, '\']; end;
    DELETE_TEMP = false;
else
    TEMP = 'temp\';
    DELETE_TEMP = true;
end

% Path to the local data directory. It should be the path to the folder 
% containing the "Swarm_L1B_CDF_ORBATT_MAGNET ..." directory.
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
dateList = (floor(DATE_RANGE(1)):1:floor(DATE_RANGE(end))+1)';
nDays = length(dateList) - 1;

% get date string in the format 'yyyymmdd'
dateStrings = datestr(dateList, 'yyyymmdd');

% replace the first 'X' in TYPE with the Satellite symbol ('A', 'B' or 'C')
file_type = regexprep(TYPE, 'X', SATELLITE, 1);

%------------ALLOCATING BUFFER TO HOLD OUTPUT------------------------------

% get number of matrix columns
nVars = sum(DIMS); 
% get maximum possible number of rows
maxL = ceil((DATE_RANGE(end) - DATE_RANGE(1))*86400/SAMPLING_TIME) + 1;
% initialize NaN matrix
data = nan(maxL, nVars);
% initialize counter
nEntries = 0;

% create an empty cell list to hold the final filenames
filenameList = cell(nDays,1);

%--------------------------------------------------------------------------

for i=1:nDays
    if strcmp(FILETYPE, 'EFI_TII')
        name = [MISSION, '_', CLASS, '_', file_type, '_', ...
        dateStrings(i,:), 'T000000_', dateStrings(i+1,:), 'T000000_', ...
        VERSION, SUBVERSION];
    else
        name = [MISSION, '_', CLASS, '_', file_type, '_', ...
        dateStrings(i,:), 'T000000_', dateStrings(i,:), 'T235959_', ...
        VERSION, SUBVERSION];
    end
    
    if isempty(RECORD)
        filename = [name, '.', FILE_EXT];
        zipname = [name, '.ZIP'];
    else
        filename = [name, '_', RECORD, '.cdf'];
        zipname = [name, '.CDF.ZIP'];
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
                disp('    File not found in temp!');
            end
        else
            mkdir(TEMP);
        end
    end
    % if the file was not found, go to the local path specified and look 
    % there for the corresponding zipped file
    if ~FILE_FOUND_FLAG && ~isempty(PATH)
        disp('Seeking file in local PATH');
        
        if strcmp(FILETYPE, 'EFI_LP')
            [TF, fullname] = eqn_fileExists([PATH, ...
            'External\', ...
            'Provisional_Plasma_dataset\',...
            'Langmuir_Probes_Data\',...
            ['Sat_', SATELLITE, '\'],...
            zipname], 100);
        elseif strcmp(FILETYPE, 'EFI_TII') 
            [TF, fullname] = eqn_fileExists([PATH, ...
            'External\', ...
            'Provisional_Plasma_dataset\',...
            'Thermal_Ion_Imagers_Data\',...
            ['Sat_', SATELLITE, '\'],...
            zipname], 100);
        elseif strcmp(FILETYPE, 'MAG_LR_PPRO') 
            [TF, fullname] = eqn_fileExists([PATH, ...
            'External\', ...
            'MAG_scalar_residual_corrected\',...
            'data\',...
            filename], 100);
        else
            [TF, fullname] = eqn_fileExists([PATH, ...
            'Level1b\', ...
            'Current\',...
            [TYPE(1:end-3), '\'],...
            ['Sat_', SATELLITE, '\'],...
            zipname], 100);
        end
        
        if TF % if file exists
            disp('    Zip archive found!');
            
%             % change '/' to '\' to make filename compatible with windows
%             strrep(fullname, '/', '\');
            
            % unzip contents to TEMP
            if strcmpi(fullname(end-2:end), 'zip')
                unzip(fullname, TEMP);
            else
                copyfile(fullname, TEMP, 'f')
            end
            
            % get the actualfilename
            out = regexp(fullname, '\\(\w+)', 'tokens');
            if ~isempty(out)
                if strcmp(FILETYPE, 'EFI_LP')
                    actualfilename = [TEMP, out{end}{1}, '.txt'];
                elseif strcmp(FILETYPE, 'EFI_TII') || strcmp(FILETYPE, 'MAG_LR_PPRO')
                    actualfilename = [TEMP, out{end}{1}, '.cdf'];                  
                else
                    actualfilename = [TEMP, out{end}{1}, '_', RECORD, '.cdf'];
                end
                
                if exist(actualfilename, 'file')
                    FILE_FOUND_FLAG = 1;
                    disp('    File found and unzipped to temp folder');
                    disp(actualfilename);
                    filenameList{i} = actualfilename;
                end
            else
                disp('    WARNING: Record probably missing from archive!');
            end
        else
            disp('    No archive found on the local PATH!');
        end
        
    end
    
    % if the file was not found, go to the FTP server and look there for
    % the corresponding zipped file, but ONLY if there SERVER var has a 
    % value, which means there are valid server credentials! 
    if ~FILE_FOUND_FLAG && ~isempty(SERVER)
        disp('Requesting file from server');
        if ~exist('ftpObj', 'var')
            ftpObj = ftp(SERVER, USER, PASS);
        end
        
        % Modify remote path for the case of Tromos ftp server
        if strfind(SERVER, 'tromos')
            ADDPATH = 'swarmdata/';
        else
            ADDPATH = '';
        end
        if strcmp(FILETYPE, 'EFI_LP')
            disp([ADDPATH, ...
                'External\', ...
                'Provisional_Plasma_dataset\',...
                'Langmuir_Probes_Data\',...
                ['Sat_', SATELLITE, '\'],...
                zipname]);
            [TF, fullname] = eqn_ftpFileExists(ftpObj,...
                [ADDPATH, ...
                'External\', ...
                'Provisional_Plasma_dataset\',...
                'Langmuir_Probes_Data\',...
                ['Sat_', SATELLITE, '\'],...
                zipname], 100);           
        elseif strcmp(FILETYPE, 'EFI_TII')
                disp([ADDPATH, ...
                'External\', ...
                'Provisional_Plasma_dataset\',...
                'Thermal_Ion_Imagers_Data\',...
                ['Sat_', SATELLITE, '\'],...
                zipname]);
            [TF, fullname] = eqn_ftpFileExists(ftpObj,...
                [ADDPATH, ...
                'External\', ...
                'Provisional_Plasma_dataset\',...
                'Thermal_Ion_Imagers_Data\',...
                ['Sat_', SATELLITE, '\'],...
                zipname], 100);
        elseif strcmp(FILETYPE, 'MAG_LR_PPRO')
                disp([ADDPATH, ...
                'External\', ...
                'MAG_scalar_residual_corrected\',...
                'data\',...
                filename]);
            [TF, fullname] = eqn_ftpFileExists(ftpObj,...
                [ADDPATH, ...
                'External\', ...
                'MAG_scalar_residual_corrected\',...
                'data\',...
                filename], 100);             
        else
            disp([ADDPATH, ...
                'Level1b\', ...
                'Current\',...
                [strrep(TYPE(1:end-3), 'X', 'x'), '\'],...
                ['Sat_', SATELLITE, '\'],...
                zipname]);
            [TF, fullname] = eqn_ftpFileExists(ftpObj, ...
                [ADDPATH, ...
                'Level1b/', ...
                'Current/',...
                [strrep(TYPE(1:end-3), 'X', 'x'), '/'],...
                ['Sat_', SATELLITE, '/'],...
                zipname], 100);
        end
        if TF % if file exists
            disp('    Zip archive found!');
            if ~exist(PATH, 'dir')
                mkdir(PATH);
            end
            
%             % change '/' to '\' to make filename compatible with windows
%             strrep(fullname, '/', '\');
            
            % mget() and unzip() work better with fullpathnames
            % check if PATH is full or relative path and 
            % correct it accordingly
            corrPath = '';
            if PATH(2) == ':' % begins with c: so is absolute path
                % nothing
            else
                corrPath = [pwd, '\'];
            end
            
            % download zip file from server
            mget(ftpObj, fullname, [corrPath, PATH]);
            
            % unzip contents to TEMP
            if strcmpi(fullname(end-2:end), 'zip')            
                unzip([corrPath, PATH, fullname], TEMP);
            else
                copyfile([corrPath, PATH, fullname], TEMP, 'f');
            end
            
            % get the actualfilename
            out = regexp(fullname, '[/\\](\w+)', 'tokens');
            if ~isempty(out)
                if strcmp(FILETYPE, 'EFI_LP')
                    actualfilename = [TEMP, out{end}{1}, '.txt'];
                elseif strcmp(FILETYPE, 'EFI_TII')
                    actualfilename = [TEMP, out{end}{1}, '.cdf'];
                else
                    actualfilename = [TEMP, out{end}{1}, '_', RECORD, '.cdf'];
                end
                
                disp(actualfilename);
                if exist(actualfilename, 'file')
                    FILE_FOUND_FLAG = 1;
                    disp('    File found and unzipped to temp folder');
                    disp(actualfilename);
                    filenameList{i} = actualfilename;
                end
            else
                disp('    WARNING: Record probably missing from archive!');
            end
        else
            disp('    No archive found on the server!');
        end
    end
    
    if ~FILE_FOUND_FLAG
        disp('No files found for this day. Continuing with the rest.');
        disp(' ');
    else
        % Proceeding to data loading.
        if DATA_LOAD_FLAG
            if strcmp(actualfilename(end-2:end), 'cdf')
                [file_data, file_meta] = eqn_readFile(actualfilename, 'cdf', VARS);
            elseif strcmp(actualfilename(end-2:end), 'txt')
                file_data = eqn_readASCII(actualfilename);
                file_data = [file_data(:,[15,9,10,12,18]), datenum(file_data(:,1:6))];
            else
                disp('SWARM_Data_Loader: Unknown file extension!');
                file_data = [];
            end
            % remove flagged
            if exist('FlagThresh', 'var')
               file_data(file_data(:, FlagInd) >= FlagThresh, 1:DIMS(1)) = NaN;
            end
            nFileEntries = size(file_data,1);
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

% clear unused part of the data matrix & Flag param (if any)
if DATA_LOAD_FLAG
    data(nEntries+1:maxL,:) = [];
    if exist('FlagInd', 'var')
        data(:, FlagInd) = [];
    end
    
    if strcmp(FIELD_CHOICE, 'n')
        data(:,1) = data(:,1) / 10^6;
    end
    
    if strcmp(FILETYPE, 'EFI_TII')
        data(:,end) = datenum(2000,1,1) + data(:,end)/86400;
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