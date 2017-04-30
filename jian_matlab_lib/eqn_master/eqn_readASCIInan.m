function data = eqn_readASCIInan(filename, no_of_headerlines, comment_line_symbol)

if nargin < 3
    comment_line_symbol = '%';
end

if nargin < 2
    no_of_headerlines = 0;
end

fid = fopen(filename);

if fid>0
    % get file properties
    properties = dir(filename);
    if properties.bytes == 0
        disp('WARNING: File is probably empty!');
        disp(['Filename: ', filename]);
    else
% Treatment of NaNs in the file: Replace the string NaN with a numeric FILL
% value - read the file as normal and then, in the final matrix with all
% the data, replace FILL value with NaN.
        % read the entire contents of the file into a char array
        fileStr = fileread(filename);
        
        % replace occurences of NaN with the FILL value -10E-30
        fillStr = regexprep(fileStr,'(NaN|nan)', '-10E-30');
        strLength = length(fillStr);
        
        % Proceed with trying to find the file's line format...
        
        % get first data line (non-comment, non-header)
        S = textscan(fillStr, '%[^\n\r]', 1, 'Headerlines', no_of_headerlines, ...
            'CommentStyle', comment_line_symbol, 'CollectOutput', 1);

        if ~isempty(S{1})
            sampleString = [cell2mat(S{1}), ' ']; % add a blank space at the end to facilitate regexp()

            numRegExp = '([\+\-]?\d+(\.\d*)?([Ee][\+\-]?\d+\.?\d*)?)';
            %separator = '([\s,:;/Tt]+)';
            separator = '([^\d\.\+\-]+)';
            dash = '(-)';
            separatorOrSingleDash = ['(', separator, '|', dash, ')'];
            matches = regexp(sampleString, [separator, '?', numRegExp, separatorOrSingleDash], 'tokens');

            % create format for textscan
            lineformat = '';
            for i=1:length(matches)
                lineformat = [lineformat,  matches{i}{1}, '%f', matches{i}{3}]; %#ok<AGROW>
            end

            % frewind(fid);
            % Not needed because:  for strings, repeated calls to textscan 
            % restart the scan from the beginning each time

            [D, pos] = textscan(fillStr, lineformat, 'Headerlines', no_of_headerlines, ...
                'CommentStyle', comment_line_symbol, 'CollectOutput', true);
            data = cell2mat(D);
            
            % Replace FILL value with NaN
            data(data == -10E-30) = NaN;

            if pos ~= strLength
                disp('WARNING: File was not read completely! Probably badly formatted line at byte');
                disp(['position ', num2str(pos), '.']);
                disp(['Filename: ', filename]);
            end

        else
            disp('WARNING: could not find a formated line to read as sample. Probably wrong number');
            disp('of header lines or comment symbol specified!');
            disp(['Filename: ', filename]);
        end
    end
    
    fclose(fid);
else
    disp(['Cannot find file: ', filename]);
end

end