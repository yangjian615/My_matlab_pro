function [TF, fullname] = eqn_ftpFileExists(ftpObj, filename, minSize)
%eqn_ftpFileExists Checks if a file exists on the specified ftp server and 
% is bigger than a minimum set filesize (in bytes)
%
% 'ftpObj' is the object returned after a successful call of the ftp()
% function.
% 
% The function returns 'true' if the file exists and also, as a second
% output argument, its filename. This enables the search to be conducted
% using wildcards, while the output 'fullname' will always correspond to
% the actual name of the file (if it exists).
% 
% If the search is performed with wildcards and more than one results are
% matched, then the ones with acceptable size will be selected and the
% "latest" (in the lexicographical sense) will be returned as the output. 
% 
% [Hopefully, if many files are present, the lexicographical latest will
% correspond to the latest version (supposing that the version number is 
% given in the filename)]
%

if nargin<3; minSize = 0; end

TF = false;
fullname = '';

fileMeta = dir(ftpObj, filename);
% if nothing found, check again in Linux format ('/' instead of '\')
if isempty(fileMeta)
    filename = strrep(filename, '\', '/');
    fileMeta = dir(ftpObj, filename);
end

if ~isempty(fileMeta)
    % check if there are more than one results 
    N = length(fileMeta); 
    
    if N == 1
        % single result - check size and save name
        if fileMeta.bytes >= minSize
            TF = true;
            name = fileMeta.name;
            f = find(name == '/' | name == '\', 1, 'last');
            if ~isempty(f)
                name = name(f+1:end);
            end

            f = find(filename == '/' | filename == '\', 1, 'last');
            fullname = [filename(1:f),name];
        end
    else
        % Many results. Find which have acceptable size and pick the "last"
        % one of them (in a lexicographical sense)
        %disp(['eqn_fileExists: Multiple results found for file: ',filename]);
        fileMeta = orderfields(fileMeta);
        metacell = struct2cell(fileMeta);
        
        % find files with size > minSize
        fileSizes = cell2mat(metacell(1,:));
        indAcceptableFiles = find(fileSizes >= minSize);
        
        if ~isempty(indAcceptableFiles)
            TF = true;
            % get their names and find the "last"
            fileNames = metacell(end, indAcceptableFiles);
            sortedFileNames = sort(fileNames);
            f = find(sortedFileNames{end} == '/' | sortedFileNames{end} == '\', 1, 'last');
            if ~isempty(f)
                sortedFileNames{end} = sortedFileNames{end}(f+1:end);
            end
            
            f = find(filename == '/' | filename == '\', 1, 'last');
            fullname = [filename(1:f),sortedFileNames{end}];
        end
    end
end
end

