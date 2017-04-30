function time_series = eqn_qualia_readAinoFile(filename, DT, skipNBytes)
%eqn_qualia_readAinoFile Reads an AINO timestamp file and exports a
%TIME_SERIES matrix
%
%   time_series = eqn_qualia_readAinoFile(filename), reads the file
%   specified by 'filename', which must be a AINO file, with time stamps in
%   the form "yyyy-mm-dd HH:MM:SS.FFF" (the time stamps can be followed by
%   additional data, which will be ignored) and counts the number of
%   occurence of these time stamps per 24-HR period. The output will be a
%   TIME_SERIES matrix.
%
%   time_series = eqn_qualia_readAinoFile(filename, DT), as above but
%   instead of a 24-HR period, it operates in a time window of DT hours.
%
%   time_series = eqn_qualia_readAinoFile(filename, DT, skipNBytes), as
%   above, but skipping the first skipNBytes of the file. By default, even
%   when the argument is absent, the function will skip the first 3 bytes,
%   as it was found that this is needed for most AINO files. To cancel this
%   run as: eqn_qualia_readAinoFile(filename, DT, 0).

if nargin < 3; skipNBytes = 3; end;
if nargin < 2; DT = 24; end;

fid = fopen(filename);
% skip first N bytes
byteOrderMarker = textscan(fid, '%c', skipNBytes); %#ok<NASGU>
data = textscan(fid, '%f-%f-%f %f:%f:%f %*[^\n]');
fclose(fid);

timeStamps = datenum(data{1}, data{2}, data{3}, data{4}, data{5}, data{6});
min_t = fix(min(timeStamps));
max_t = ceil(max(timeStamps));

t = (min_t:DT/24:max_t+1)';
cnt = histc(timeStamps, t);

% remove initial zeros
f1 = find(cnt~=0, 1, 'first');
if f1 > 1
    t(1:f1-1) = [];
    cnt(1:f1-1) = [];
end

% remove trailing zeros
f2 = find(cnt~=0, 1, 'last');
if f2 < length(cnt)
    t(f2+1:end) = [];
    cnt(f2+1:end) = [];
end

time_series = [cnt,t];

end

