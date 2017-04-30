function sortdb
% sortdb
%
% sorts the shot database by shot number
%
% Jan. 2016, Adrian von Stechow

% load shotdb
conf = initMRX;
m = matfile(conf.dbPath,'writable',true);
% sort shot numbers
[a,s] = sort(m.shot);
% get field names
w = whos(m);
names = {w.name};
n = length(m.shot);

% step through field names
for i=1:length(names)
    tmp = m.(names{i});
    if length(tmp)<n
        % fill fields with <n entries with blank data
        if islogical(tmp)
            tmp = padarray(tmp,[n-length(tmp) 0],false,'post');
        else
            tmp = padarray(tmp,[n-length(tmp) 0],nan,'post');
        end
    end
    % sort field
    m.(names{i})=tmp(s);
end