function out = loadFromDB(handles)
% out = loadFromDB(handles)
%
% loads data from shotdb
% Jan. 2016, Adrian von Stechow

shot    = getappdata(handles.figure1,'shot');
conf    = getappdata(handles.figure1,'conf');

% get shotdb reference
m       = matfile(conf.dbPath,'Writable',true);

% get field names
w       = whos(m);
names   = {w.name};

if ~ismember('shot',names) % empty file, return NaN
    out = NaN;
else
    index = find(m.shot==shot,1); % not empty, check if shot saved
    if isempty(index) % not saved, return NaN
        out = NaN;
    else
        for i = 1:length(names) % step through fields
            try
                out.(names{i}) = m.(names{i})(index,1); % get values
            catch % catches case where m.(names{i}) is not fully populated yet
                out.(names{i}) = NaN;
            end
        end
    end
end