function saveData(handles)
% saveData(handles)
%
% saves gathered data to shotdb database
%
% Jan. 2016, Adrian von Stechow

data    = getappdata(handles.figure1,'shotData');
fields  = fieldnames(data);
conf    = getappdata(handles.figure1,'conf');
m       = matfile(conf.dbPath,'Writable',true);
w       = whos(m);

if ~ismember('shot',{w.name})
    % shotdb file is empty, start with index 1
    index = 1;
else
    % not empty, check if shot previously saved
    index = find(m.shot==data.shot);
    if isempty(index)
        % not saved, add to end of array
        index = length(m.shot)+1;
    end
end

% write data to index found above
for i=1:length(fields)
    m.(fields{i})(index,1) = data.(fields{i});
end

end