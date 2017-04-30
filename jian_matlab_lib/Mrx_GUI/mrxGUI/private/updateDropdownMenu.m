function updateDropdownMenu(handles)
% updateDropdownMenu(handles)
%
% updates the content of the dropdown menus
%
% Jan. 2016, Adrian von Stechow

% left side (time trace) dropdowns
strings = {'density','electron temperature','total current','x-point z pos.'};

set(handles.traceSelector1,'string',strings);
set(handles.traceSelector2,'string',strings);

% right side (image plot) dropdown
strings = {'Ey','Jx','Jz','Flux'};

set(handles.imageSelector,'string',strings);