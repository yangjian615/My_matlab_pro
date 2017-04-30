function [TF, fullname] = eqn_fileExists(filename, minSize)
%eqn_fileExists Checks if a file exists and is bigger than a minimum set
%filesize (in bytes)
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

if nargin<2; minSize = 0; end

TF = false;
fullname = '';

fileMeta = dir(filename);

if ~isempty(fileMeta)
    % check if there are more than one results 
    N = length(fileMeta); 
    
    if N == 1
        % single result - check size and save name
        if fileMeta.bytes >= minSize
            TF = true;
            name = fileMeta.name;

            f = find(filename == '\' | filename == '/', 1, 'last');
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
            
            f = find(filename == '\' | filename == '/', 1, 'last');
            fullname = [filename(1:f),sortedFileNames{end}];
        end
    end
end
end

