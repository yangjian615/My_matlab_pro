function index = isUnmarkedShot(shot,m)
% index = isUnmarkedShot(shot,dbmat)
%
% returns the index in shotdb of a shot number if "marked" field is false,
% 0 if true or if shot is unavailable
% faster if shotdb matfile object is supplied as optional argument dbmat
%
% Jan. 2016, Adrian von Stechow

if nargin == 1
    c = initMRX;
    m = matfile(c.dbPath);
end

index  = find(m.shot==shot);

if isempty(index) || m.marked(index,1)
    index = 0;
end