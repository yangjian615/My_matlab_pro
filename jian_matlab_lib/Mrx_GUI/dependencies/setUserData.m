% oldvalue = setUserData([handle],key,value)
function  oldvalue = setUserData(varargin)
narginchk(2,3)
if ishandle(varargin{1})
    [handle,key,value] = deal(varargin{1:3});
else
    [handle,key,value] = deal(gca,varargin{1,2});
end
UD = get(handle,'UserData');
if nargout~=0, oldvalue = UD.(key); end
UD.(key) = value;
set(handle,'UserData',UD)
end