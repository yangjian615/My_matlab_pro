function Params = eqn_paramLoader(filename)
%eqn_paramLoader Reads the config file and extracts parameter values.
%
%

% read file into a single string
text = fileread(filename);

% Find blocks of parameters. Each block begins with an /BEGIN statement and
% ends with a /END statement
blocks = regexp(text, '/BEGIN(.+?)/END', 'tokens');

% Initialize output
Params.Missions = cell(length(blocks), 1);
Params.Sources = cell(length(blocks), 1);

for i=1:length(blocks)
    Name = regexp(blocks{i}{1}, 'MISSION\s*=\s*"(.*?)"', 'tokens', 'emptymatch');
    Temp = regexp(blocks{i}{1}, 'TEMP\s*=\s*"(.*?)"', 'tokens', 'emptymatch');
    Path = regexp(blocks{i}{1}, 'PATH\s*=\s*"(.*?)"', 'tokens', 'emptymatch');
    Remote = regexp(blocks{i}{1}, 'REMOTE\s*=\s*"(.*?)"[^"]*"(.*?)"[^"]*"(.*?)"', 'tokens', 'emptymatch');

    Name = Name{1}; if isempty(Name{1}); Name = []; else Name = Name{1}; end;
    Temp = Temp{1}; if isempty(Temp{1}); Temp = []; else Temp = Temp{1}; end;
    Path = Path{1}; if isempty(Path{1}); Path = []; else Path = Path{1}; end;
    Remote = Remote{1}; if isempty(Remote{1}); Remote = []; end;

    Params.Missions{i} = Name;
    Params.Sources{i,1} = Temp;
    Params.Sources{i,2} = Path;
    Params.Sources{i,3} = Remote;
end

end