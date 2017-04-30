function loadMRXData(handles,shotNum)
% loadMRXData(handles,shotNum)
%
% loads shot data into GUIdata
%
% Jan. 2016, Adrian von Stechow

% get shot referemce
conf                = getappdata(handles.figure1,'conf');
[matObj,filePath]   = loadMRXshot(shotNum,conf);
setappdata(handles.figure1,'fileName',filePath);

% error if file doesn't exist
if ~isobject(matObj)
    % set the text box to reflect new file path
    set(handles.fileNameTextBox,'string',['NOT AVAILABLE: ' filePath])
    return
else
    % set the text box to reflect new file path
    set(handles.fileNameTextBox,'string',filePath)
end

% set matfile reference
setappdata(handles.figure1,'matFile',matObj);

% remove old langmuir probe data
if isappdata(handles.figure1,'langData')
    rmappdata(handles.figure1,'langData')
end

% load parts of the data file
fetchMRXData(handles);

% initalize 2D plots
initImages(handles);

% update dropdown menu content
updateDropdownMenu(handles);

% plot time traces
plotMRXTraces(handles);

% check if data has been previously saved in DB, load if yes
data  = loadFromDB(handles);

if isstruct(data)
    
    % load shot data into GUIDATA
    names = fieldnames(data);
    set(handles.uitable1,'Data',[names, struct2cell(data)])
    setappdata(handles.figure1,'shotData',data)

    if ~get(handles.freezeButton,'Value')
        % freeze button not pressed, set time marker to tSelect from
        % previously saved data
        setappdata(handles.figure1,'tSelect',data.tSelect);
        set(handles.timeSelectorTextBox,'String',getappdata(handles.figure1,'tSelect'))
        setappdata(handles.figure1,'tIndSelect',NaN);
    end
    
    % recover saved "shot marked" value
    setappdata(handles.figure1,'shotMarked',data.marked)
        
else
    
    if ~get(handles.freezeButton,'Value')
        % set time selector to X-point crossing time if freeze button not
        % pressed
        set(handles.timeSelectorTextBox,'String',num2str(getappdata(handles.figure1,'tCross')))
        setappdata(handles.figure1,'tSelect',getappdata(handles.figure1,'tCross'));
        setappdata(handles.figure1,'tIndSelect',NaN);
    end
    
    % remove possible "shot marked" setting
    setappdata(handles.figure1,'shotMarked',false)

end

% plot images
plotImages(handles);