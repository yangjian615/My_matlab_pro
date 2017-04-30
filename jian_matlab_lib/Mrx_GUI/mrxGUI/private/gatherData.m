function out = gatherData(handles)
% out = gatherData(handles)
%
% gathers data at selected time point for export to database
%
% Jan. 2016, Adrian von Stechow

% load langmuir data if not already done
if isappdata(handles.figure1,'langData')
    % already loaded!
    langData = getappdata(handles.figure1,'langData');
else
    % get langmuir probe data
    tmp = getappdata(handles.figure1,'matFile');
    setappdata(handles.figure1,'langData',tmp.LangData);
    langData = tmp.LangData;
end

% get magnetics data
magData = getappdata(handles.figure1,'magData');

% get selected time index
tInd = getappdata(handles.figure1,'tIndSelect');

% gather basic data
out.shot    = getappdata(handles.figure1,'shot');
out.tSelect = getappdata(handles.figure1,'tSelect');
out.tCross  = getappdata(handles.figure1,'tCross');
out.zx      = magData.Poloidal_Nulls.z(1,tInd)*1000;
out.rx      = magData.Poloidal_Nulls.x(1,tInd)*1000;
out.Ey      = magData.Poloidal_Nulls.Ephi(1,tInd);
out.I       = magData.I_2D(1,tInd)/1e3;
out.marked  = getappdata(handles.figure1,'shotMarked');

% index of point closest to X-point
rInd = ind_get(magData.x,out.rx/1000);
zInd = ind_get(magData.z,out.zx/1000);

% get upstream field, 5 cm from null
distance    = 50;
out.Bzup    = mean(...
    [magData.Bz(ind_get(magData.x,(out.rx+distance)/1000),zInd,tInd)*1000,...
    -magData.Bz(ind_get(magData.x,(out.rx-distance)/1000),zInd,tInd)*1000]);

% get guide field
out.By      = magData.By(rInd,zInd,tInd)*1000;

% get toroidal current density
out.j       = magData.Jy(rInd,zInd,tInd)/1e6;
out.jMax    = min(min(magData.Jy(:,:,tInd)))/1e6;

%select langmuir probe closest to center
for i=1:length(langData)
    rLang(i) = langData(i).R;
    yLang(i) = langData(i).Y;
    zLang(i) = langData(i).Z;
end
[~,index] = min((rLang-0.375).^2+zLang.^2+yLang.^2);

% get langmuir probe data
tmp         = [langData.ne];
out.ne      = tmp(ind_get(langData(index).time,out.tSelect));
tmp         = [langData.Te];
out.Te      = tmp(ind_get(langData(index).time,out.tSelect));