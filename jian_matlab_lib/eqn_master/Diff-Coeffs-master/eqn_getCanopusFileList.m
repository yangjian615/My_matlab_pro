function filelist = eqn_getCanopusFileList(t_beg, t_end, PATH, STATION)
% 
% 

daysInMatlabTime = (fix(t_beg):fix(t_end))';

N = length(daysInMatlabTime);

dateStrings = datestr(daysInMatlabTime, 'yyyymmdd');

% initialize filelist
filelist = cell(N,1);

for i=1:length(daysInMatlabTime)
    target = [PATH, dateStrings(i, :), STATION, '.MAG'];
    filelist{i,1} = target;
end

end