function filelist = eqn_getCarismaFileList(t_beg, t_end, PATH, STATION)
% 
% 

daysInMatlabTime = (fix(t_beg):fix(t_end))';

N = length(daysInMatlabTime);

dateStrings = datestr(daysInMatlabTime, 'yyyymmdd');

% initialize filelist
filelist = cell(N,1);

for i=1:length(daysInMatlabTime)
    target = [PATH, dateStrings(i, :), STATION, '.F01'];
    filelist{i,1} = target;
end

end