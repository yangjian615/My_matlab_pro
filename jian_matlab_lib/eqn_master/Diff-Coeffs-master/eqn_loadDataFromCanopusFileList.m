function [data_init, file_meta] = eqn_loadDataFromImageFileList(t_beg_marg, t_end_marg,...
    SAMPLING_TIME, fileList)
% 
% 

% initialize matrix of file data
nVars = 4;
maxL = ceil((t_end_marg - t_beg_marg)*86400/SAMPLING_TIME) + 1;
data_init = nan(maxL, nVars);
nEntries = 0;
file_meta = [];

% DATA INPUT
if ~isempty(fileList)
    L = size(fileList,1);

    for i=1:L
        % check which file exists (if any)
        [TF, filename] = eqn_fileExists(fileList{i,1}, 150);

        % open file (if exists) and load data
        if ~isempty(filename)
            disp(['opening: ',filename]);
            [file_data, file_meta] = eqn_readFile(filename, 'canopus');
            nFileEntries = size(file_data,1);
            data_init(nEntries+1:nEntries+nFileEntries,:) = file_data;
            nEntries = nEntries + nFileEntries;
            clear('file_data');
        else
            disp('No data files found for the given time interval!');
        end
    end
    
end

data_init(nEntries+1:end,:) = [];

end

