function fetchMRXData(handles)
% fetchMRXData(handles)
%
% get initial (minimal) set of data from matobj
%
% Jan. 2016, Adrian von Stechow

matFile = getappdata(handles.figure1,'matFile');
setappdata(handles.figure1,'fastCurrents',matFile.Fast_Currents);
w=warning('off');
setappdata(handles.figure1,'magData',matFile.Interp_Data_YA(1,1));
warning(w);
setappdata(handles.figure1,'GFStruct',matFile.GF_Struct);
setappdata(handles.figure1,'shotDate',matFile.date);
setappdata(handles.figure1,'time',matFile.time);
