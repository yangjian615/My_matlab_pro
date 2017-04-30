function [time_series, metadata, flag] = eqn_readFile_1( filename, type, params )
%eqn_readFile Extracts data and metadata from files of various types.
%
%   [time_series, metadata] = eqn_readFile( filename, type ), reads the
%   content of 'filename' according to the format specified in 'type' and
%   outputs a 'TIME_SERIES' column matrix (first columns are the data and
%   the last column the time) and a 'metadata' structure, containing
%   various information about the source file and the data. 
%   Supported values for 'type' are: 
%       'carisma' (for data downloaded from the CARISMA network site)
%       'canopus' (for pre 2005 data downloaded from the CARISMA network site)
%       'image'   (for converted ASCII files from the IMAGE network)
%       'cdaweb'  (for data downloaded from NASA's CDAWeb)
%       'cdf'     (for cdf files - requires extra parameters - see below)
%       'swarm'   (for binary data files from the SWARM mission - requires 
%                  extra parameters, as per the cdf case)
%
%   NOTE: For cdf files an additional parameter with the variable names to be
%   extracted from the file is needed. If the function is called simply as
%   is, the time_series output will be an empty cell and the metadata a
%   struct, containing all relevant information about the cdf file. From
%   this structure, the variable names can be read. When the decision on
%   the variables has been made, the function is called again as
%   [time_series, metadata] = eqn_readFile( filename, type, varNames), with
%   'varNames' being a cell of strings of the variable names to be
%   extracted. Again, in accordance with the TIME_SERIES matrix format, the
%   time or epoch variable must by placed last!

if isempty(filename); 
    warning('eqn_readFile: Filename is an empty cell/string!');
    flag = -1000;
    time_series = [];
    metadata = [];
else

fid = fopen(filename, 'r');
if fid == -1
    warning('eqn_readFile: File not found!');
    flag = -100;
    time_series = [];
    metadata = [];
else

type = lower(type);

switch type
    case 'carisma'
        % read header and extract metadata
        name = fscanf(fid,'%s',1);
        coords(1) = fscanf(fid,'%f',1);
        coords(2) = fscanf(fid,'%f',1);
        day = fscanf(fid,'%s',1);
        system = fscanf(fid,'%s',1);
        unit = fscanf(fid,'%s',1);
        sampl = fscanf(fid,'%s\n',1);
         
        metadata = struct('TYPE', 'CARISMA Network Magnetic Field Data',...
             'STATION', name, 'COORDS', coords, 'SYSTEM', system, 'UNIT', unit, ...
             'SAMPL', sampl, 'TIME', day );
        
        % read the rest of the file (actual data)
        data = fscanf(fid,'%f %f %f %f %c', [5, inf]);
        data = data';
        L = length(data);
        
        % format time matrix (6-column matrix)
        t = zeros(L,6);
        t(:,1) = floor(data(:,1)/10^10);       %yr
        buff = t(:,1)*10^2;
        t(:,2) = floor(data(:,1)/10^8) - buff; %mon
        buff = (buff + t(:,2))*10^2;
        t(:,3) = floor(data(:,1)/10^6) - buff; %day
        buff = (buff + t(:,3))*10^2;
        t(:,4) = floor(data(:,1)/10^4) - buff; %hr
        buff = (buff+ t(:,4))*10^2;
        t(:,5) = floor(data(:,1)/10^2) - buff; %min
        buff = (buff + t(:,5))*10^2;
        t(:,6) = data(:,1) - buff;             %sec
        
        time_series = zeros(L,4);
        time_series(:,1) = data(:,2);
        time_series(:,2) = data(:,3);
        time_series(:,3) = data(:,4);
        time_series(:,4) = datenum(t);
        
    case 'canopus'
        % ignore comments (#)
        line = '#';
        while line(1) == '#'
            line = fgetl(fid);
        end
        % read header and extract metadata
        SC = textscan(line,'%s  %f %f %s %s %*s');
        name = cell2mat(SC{1});
        coords(1) = SC{2};
        coords(2) = SC{3};
        day = cell2mat(SC{4});
        system = cell2mat(SC{5});
        unit = 'nT';
        
        % read the rest of the file (actual data)
        data = fscanf(fid,'%f %f %f %f %c', [5, inf]);
        data = data';
        L = length(data);
        
        % format time matrix (6-column matrix)
        t = zeros(L,6);
        t(:,1) = floor(data(:,1)/10^10);       %yr
        buff = t(:,1)*10^2;
        t(:,2) = floor(data(:,1)/10^8) - buff; %mon
        buff = (buff + t(:,2))*10^2;
        t(:,3) = floor(data(:,1)/10^6) - buff; %day
        buff = (buff + t(:,3))*10^2;
        t(:,4) = floor(data(:,1)/10^4) - buff; %hr
        buff = (buff+ t(:,4))*10^2;
        t(:,5) = floor(data(:,1)/10^2) - buff; %min
        buff = (buff + t(:,5))*10^2;
        t(:,6) = data(:,1) - buff;             %sec
        
        time_series = zeros(L,4);
        time_series(:,1:3) = data(:,2:4);
        time_series(:,4) = datenum(t);
        
        sampl = mode(diff(time_series(:,4)))*24*3600; % in sec
        
        metadata = struct('TYPE', 'CARISMA Network Magnetic Field Data',...
             'STATION', name, 'COORDS', coords, 'SYSTEM', system, 'UNIT', unit, ...
             'SAMPL', sampl, 'TIME', day );
        
    case 'image'
        % read header & extract metadata
        IN_HEADER = 1;
        while IN_HEADER
            line = fgetl(fid);
            if strcmp(line(1:4),'YYYY')
                name = sscanf(line,'%*s %*s %*s %*s %*s %*s     %s %*s   %*s %*s   %*s %*s ');
            elseif strcmp(line(1:4),'   0')
                coords = sscanf(line,'   %*d  %*d  %*d  %*d  %*d  %*d      %f   %f     %*d  ');
            elseif strcmp(line(1:4),'----')
                IN_HEADER = 0;
            else
                disp('readFile(): Unknown line found! Check if file type is actually an IMAGE txt file or if there are other errors.');
            end
        end
        
        data = textscan(fid,'%f %f %f %f %f %f %f %f %f');
        data = cell2mat(data);
        t = datenum(data(:,1),data(:,2),data(:,3),data(:,4),data(:,5),data(:,6));
        L = length(t);
        
        time_series = zeros(L,4);
        time_series(:,1:3) = data(:,7:9);
        time_series(:,4) = t;
        
        dt = mode(diff(t))*(24*3600);
        fillValue = '99999.9';
        day = datestr(median(t),'yyyymmdd');
        
        metadata = struct('TYPE', 'IMAGE Network Magnetic Field Data',...
             'STATION', name, 'COORDS', coords', 'SYSTEM', 'INSTR.', 'UNIT', 'nT', ...
             'SAMPL_TIME_SEC', dt, 'FILL_VAL', fillValue, 'TIME', day );
        
        
    case 'cdaweb'
        % ignore comments (#) and read the first 3 Header Lines
        META = textscan(fid, '%s', 3, 'CommentStyle', '#', 'Delimiter', {'\n','\r'});
        % get Variable Names
        VARIABLES = textscan(cell2mat(META{1}(1,:)), '%s', 'MultipleDelimsAsOne', 1);
        VARIABLES = VARIABLES{1,1};
        nVars = length(VARIABLES);
        % get Units
        UNITS = textscan(cell2mat(META{1}(3,:)), '%s', 'MultipleDelimsAsOne', 1);
        UNITS = UNITS{1,1};

        string_format = '%f-%f-%f %f:%f:%f';
        for i=2:nVars
            string_format = [string_format,' %f']; %#ok<AGROW>
        end

        FILE_DATA = textscan(fid, string_format, 'CommentStyle', '#');
        FILE_DATA = cell2mat(FILE_DATA);

        t = datenum(FILE_DATA(:,3), FILE_DATA(:,2), FILE_DATA(:,1), FILE_DATA(:,4), FILE_DATA(:,5), FILE_DATA(:,6));
        time_series = zeros(length(t), nVars);
        time_series(:, 1:nVars-1) = FILE_DATA(:, 7:end);
        time_series(:, end) = t;

        VARIABLES = [VARIABLES(2:end); 'Time']; %throw time in the end
        UNITS = [UNITS(3:end); 'matlabd']; %throw time in the end
        metadata = struct('TYPE', 'CDAWEB Data', 'VARIABLES', {VARIABLES}, 'UNITS', {UNITS});
        
    case 'cdf'
        if nargin < 3
            metadata = cdfinfo(filename);
            time_series = {};
        else
            [CDF_DATA, metadata] = cdfread(filename, ...
                    'Variables',params,...
                    'ConvertEpochToDatenum', 1, 'CombineRecords', 1);
            
            
            t = CDF_DATA{:,end};
            % count rows & columns and initialize TIME_SERIES matrix
            Nrows = length(t);
            Ncols = 0;
            for i=1:length(CDF_DATA)-1
                s = size(CDF_DATA{:,i});
                Ncols = Ncols + s(2);
            end
            time_series = zeros(Nrows, Ncols);
            % pass data into TIME_SERIES matrix
            colIndex = 1;
            for i = 1:length(CDF_DATA) - 1
                s = size(CDF_DATA{:,i});
                X = double(CDF_DATA{:,i});
                for j=1:s(2)
                    time_series(:,colIndex) = X(:,j);
                    colIndex = colIndex + 1;
                end
            end
            time_series(:,colIndex) = t;

        end
        
    case 'swarm'
        if nargin < 3
            [time_series, metadata] = eqn_readSwarmNative(filename);
        else
            [time_series, metadata] = eqn_readSwarmNative(filename, params);
        end
        
    otherwise
        error('eqn_readFile: Wrong or unsupported file type!');
end

fclose(fid);
flag = 1;


end
end
end
