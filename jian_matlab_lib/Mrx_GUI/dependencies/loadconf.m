function out=loadconf(fileName)
%out=loadconf(fileName)
%
%loads .ini-style configuration files
%2012 Adrian von Stechow

fid = fopen(fileName);
if fid == -1
    error(['loadconf: invalid conf file: ' fileName])
end
s   = textscan(fid,'%s %s','delimiter','=');
fclose(fid);

tmp       = str2double(s{2}); idx = ~isnan(tmp);
s{2}(idx) = num2cell(tmp(idx));
out       = cell2struct(s{2}, s{1});