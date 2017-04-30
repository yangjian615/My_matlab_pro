function data = eqn_load_CHAMP_PLP_Data(plpFileName)
% 

% DATA INPUT
if ~isempty(plpFileName)
        % check which file exists (if any)
        [TF, filename] = eqn_fileExists(plpFileName, 150);

        % open file (if exists) and load data
        if TF
            disp(['opening: ',filename]);
            fid = fopen(filename);
            
            if strcmp(filename(end-5:end-4),'_1') || strcmp(filename(end-5:end-4),'_3')
                file_data = textscan(fid, '%f %f %f %f %f %f %f %f %f %f %f',...
                'CollectOutput', 1, 'CommentStyle', '#');
            else
                file_data = textscan(fid, '%f %f %f %f %f %f %f %f %f %f %f %f',...
                'CollectOutput', 1, 'CommentStyle', '#');
            end
            fclose(fid);
            
            file_data = file_data{1};
            t = datenum(file_data(:,2), file_data(:,3), file_data(:,4),...
                        file_data(:,5), file_data(:,6), file_data(:,7));
                    
            data = [file_data(:,11), file_data(:,9), file_data(:,10), file_data(:,8), t];
            clear('file_data', 't');
            
        else
            disp('PLP data file does not exist!');
        end
    
end


end

