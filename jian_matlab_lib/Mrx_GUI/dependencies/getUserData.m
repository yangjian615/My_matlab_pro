% value = getUserData([handle],key);
function  value = getUserData(varargin)
narginchk(1,2)
if ishandle(varargin{1})
    [handle,key] = deal(varargin{1:2});
else
    [handle,key] = deal(gca,varargin{1});
end
UD = get(handle,'UserData');
if isfield(UD,key)
    value = UD.(key);
else
    if strcmp(key,'colorbar')
        value=gccb(handle);
        if ~isempty(value)
            setUserData(handle,key,value)
        end
    else
        value = [];
    end
end
end