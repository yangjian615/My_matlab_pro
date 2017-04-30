function varargout = MissionsUnifiedGui(varargin)
% MISSIONSUNIFIEDGUI MATLAB code for MissionsUnifiedGui.fig
%      MISSIONSUNIFIEDGUI, by itself, creates a new MISSIONSUNIFIEDGUI or raises the existing
%      singleton*.
%
%      H = MISSIONSUNIFIEDGUI returns the handle to a new MISSIONSUNIFIEDGUI or the handle to
%      the existing singleton*.
%
%      MISSIONSUNIFIEDGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MISSIONSUNIFIEDGUI.M with the given input arguments.
%
%      MISSIONSUNIFIEDGUI('Property','Value',...) creates a new MISSIONSUNIFIEDGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before MissionsUnifiedGui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to MissionsUnifiedGui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help MissionsUnifiedGui

% Last Modified by GUIDE v2.5 04-Mar-2015 14:29:13

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @MissionsUnifiedGui_OpeningFcn, ...
                   'gui_OutputFcn',  @MissionsUnifiedGui_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before MissionsUnifiedGui is made visible.
function MissionsUnifiedGui_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;
clc
set(handles.figure1,'Name',['SwarmGui_unified v1.4   COPYLEFT',char(169),'2014 SiAv -- ALL RIGHTS RESERVED']);
% Update handles structure

% Add to path the dir for the "Magnetar_Unified" library
local_path = [pwd, filesep, 'Magnetar_Unified'];
addpath(local_path);

clear global
% handles.output = hObject;
global Full_date Pc_class miscells Latitude Remote_data mis_access_dat Params procFlag alignFlag
Pc_class = 'Pc34-16';
Latitude = [-60,60];
Remote_data = cell(3,1);
miscells =  Mission_cells;

% fid = fopen('access_data.txt');
% data = textscan(fid, '%s', 'Delimiter', '\n');
% k = data{1,1};
% m = length(k);
% mis_access_dat = reshape(k,6,m/6).';

Params = eqn_paramLoader('config.txt');
mis_access_dat = eqn_param2misaccdat(Params);
procFlag = 1;
alignFlag = 0;
%%%% Update handles structures and set values to various UIs

initial_year = 2000;
datecell = getnowdate;
year_now = str2num(datecell{3}); year_list = cellstr(num2str((initial_year:year_now).')); % make cell of strings with year list to go to the menu
set(handles.Year1,'String', year_list);         set(handles.Year2,'String', year_list) % set list of available years
set(handles.Year1, 'Value', length(year_list)); set(handles.Year2, 'Value', length(year_list)); % set initial value at current year

k = cell(31,1);
for i=1:31;  k{i} = sprintf('%02d',i); end % make cell of strings with month/day list to go to the menus

month_list = k(1:12); month_val = find(strcmp(k,datecell{2}));
set(handles.Month1, 'String', month_list);      set(handles.Month2, 'String', month_list);  
set(handles.Month1, 'Value', month_val);        set(handles.Month2, 'Value', month_val); % set indices corresponding to current month

day_list = k; day_val = find(strcmp(k,datecell{1}));
set(handles.Day1, 'String', day_list);      set(handles.Day1, 'Value', day_val);
set(handles.Day2, 'String', day_list);      set(handles.Day2, 'Value', day_val);

Full_date = {datecell{3},datecell{3}; datecell{2}, datecell{2}; datecell{1}, datecell{1}; '00:00:00', '23:59:59';};
% eg: Full_date = {'2013','2013'; '01', '01'; '01','01'; '00:00:00', '23:59:59';};

Mission_strs =  strrep(fieldnames(miscells),'NoChoice','----'); % take the names of the missions and change the initial from NoChoice to ------
for i=1:4
    set(handles.(sprintf('Mission_choice%d',i)),'String',Mission_strs);
    set(handles.(sprintf('Sat_choice%d',i)),'Enable','off');
    set(handles.(sprintf('Sat_choice%d',i)),'String',{'----';'----'})
    set(handles.(sprintf('File_choice%d',i)),'Enable','off');
    set(handles.(sprintf('File_choice%d',i)),'String',{'----';'----'})
    set(handles.(sprintf('Field_choice%d',i)),'Enable','off');
    set(handles.(sprintf('Field_choice%d',i)),'String',{'----';'----'})
    set(handles.(sprintf('Comp_choice%d',i)),'String',{'----';'----'})
    set(handles.(sprintf('Comp_choice%d',i)),'Enable','off');
end
set(handles.Hour1, 'String', Full_date{4,1});
set(handles.Hour2, 'String', Full_date{4,2});
set(handles.Lat_from,'String','-60');
set(handles.Lat_to,'String','60');

guidata(hObject, handles);

% --- Outputs from this function are returned to the command line.
function varargout = MissionsUnifiedGui_OutputFcn(hObject, eventdata, handles) 
r = get(0,'ScreenSize');
x_length = (1920*0.175)/r(3); % calculate x length of gui depending on screensize
y_length = (1080*0.62)/r(4); % calculate y length of gui depending on screensize
start_ypoint =  (1-y_length)/2;
set(handles.output, 'Units' , 'Normalized');
set(handles.output, 'OuterPosition', [0.005, start_ypoint, x_length, y_length]);
varargout{1} = handles.output;
guidata(hObject,handles)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%UI CODE STARTS HERE%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% --- Executes on button press in Set_Access_call.
function Set_Access_call_Callback(hObject, eventdata, handles)
global mis_access_dat
loc_missions = MisSatFileFieldComp_get(handles);
if ~isempty([loc_missions{:}]) 
    gui_pos = get(handles.figure1,'Position');
    mis_access_dat = Set_Accessgui(mis_access_dat,handles, gui_pos);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%MISSION-1_START%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% --- Executes on selection change in Mission_choice1.
function Mission_choice1_Callback(hObject, eventdata, handles)
global miscells
handles = Mission_Menu_choice_Callback(handles,hObject,miscells,eventdata);
% Sat_choice1_Callback(handles.Sat_choice1, eventdata, handles)
guidata(hObject, handles)

function Sat_choice1_Callback(hObject, eventdata, handles)
global miscells
handles = Mission_Menu_choice_Callback(handles,hObject,miscells,eventdata);
guidata(hObject,handles);

function File_choice1_Callback(hObject, eventdata, handles)
global miscells
handles = Mission_Menu_choice_Callback(handles,hObject,miscells,eventdata);
guidata(hObject,handles)

function Field_choice1_Callback(hObject, eventdata, handles)
global miscells
handles =  Mission_Menu_choice_Callback(handles,hObject,miscells,eventdata);
guidata(hObject,handles);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%MISSION-1_END%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%MISSION-2_START%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% --- Executes on selection change in Mission_choice2.
function Mission_choice2_Callback(hObject, eventdata, handles)
global miscells
handles =  Mission_Menu_choice_Callback(handles,hObject,miscells,eventdata);
guidata(hObject, handles)

function Sat_choice2_Callback(hObject, eventdata, handles)
global miscells
handles =  Mission_Menu_choice_Callback(handles,hObject,miscells,eventdata);
guidata(hObject,handles);

function File_choice2_Callback(hObject, eventdata, handles)
global miscells
handles =  Mission_Menu_choice_Callback(handles,hObject,miscells,eventdata);
guidata(hObject,handles)

function Field_choice2_Callback(hObject, eventdata, handles)
global miscells
handles =  Mission_Menu_choice_Callback(handles,hObject,miscells,eventdata);
guidata(hObject,handles)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%MISSION-2_END%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%MISSION-3_START%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% --- Executes on selection change in Mission_choice3.
function Mission_choice3_Callback(hObject, eventdata, handles)
global miscells
handles =  Mission_Menu_choice_Callback(handles,hObject,miscells,eventdata);
guidata(hObject,handles)

function Sat_choice3_Callback(hObject, eventdata, handles)
global miscells
handles =  Mission_Menu_choice_Callback(handles,hObject,miscells,eventdata);
guidata(hObject,handles)

function File_choice3_Callback(hObject, eventdata, handles)
global miscells
handles =  Mission_Menu_choice_Callback(handles,hObject,miscells,eventdata);
guidata(hObject,handles)

function Field_choice3_Callback(hObject, eventdata, handles)
global miscells
handles =  Mission_Menu_choice_Callback(handles,hObject,miscells,eventdata);
guidata(hObject,handles)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%MISSION-3_END%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%MISSION-4_START%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% --- Executes on selection change in Mission_choice4.
function Mission_choice4_Callback(hObject, eventdata, handles)
global miscells
handles =  Mission_Menu_choice_Callback(handles,hObject,miscells,eventdata);
guidata(hObject,handles)

function Sat_choice4_Callback(hObject, eventdata, handles)
global miscells
handles =  Mission_Menu_choice_Callback(handles,hObject,miscells,eventdata);
guidata(hObject,handles)

function File_choice4_Callback(hObject, eventdata, handles)
global miscells
handles =  Mission_Menu_choice_Callback(handles,hObject,miscells,eventdata);
guidata(hObject,handles)

function Field_choice4_Callback(hObject, eventdata, handles)
global miscells
handles =  Mission_Menu_choice_Callback(handles,hObject,miscells,eventdata);
guidata(hObject,handles)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%MISSION-4_END%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%END_OF_MISSIONS%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%START_OF_DATES%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% --- Executes on selection change in Year1.
function Year1_Callback(hObject, eventdata, handles)
global Full_date 
[Full_date, handles,next_cell] = Date_Menu_Callback(handles,hObject,Full_date,eventdata);
if ~isempty(next_cell) % if the date_menu returns name use it to call the appropriate in-gui function e.g Month1_Callback(handles.Month1,eventdata,handles)
    next_callback=str2func(next_cell{1});  next_callback(handles.(sprintf('%s',next_cell{2})),eventdata,handles);
end
guidata(hObject,handles);

% --- Executes on selection change in Year2.
function Year2_Callback(hObject, eventdata, handles)
global Full_date
[Full_date, handles,next_cell] = Date_Menu_Callback(handles,hObject,Full_date,eventdata);
if ~isempty(next_cell)
    next_callback=str2func(next_cell{1});  next_callback(handles.(sprintf('%s',next_cell{2})),eventdata,handles);
end
guidata(hObject,handles);

% --- Executes on selection change in Month1.
function Month1_Callback(hObject, eventdata, handles)
global Full_date
[Full_date, handles,next_cell] = Date_Menu_Callback(handles,hObject,Full_date,eventdata);
if ~isempty(next_cell)
    next_callback=str2func(next_cell{1});  next_callback(handles.(sprintf('%s',next_cell{2})),eventdata,handles);
end
guidata(hObject,handles);

% --- Executes on selection change in Month2.
function Month2_Callback(hObject, eventdata, handles)
global Full_date
[Full_date, handles,next_cell] = Date_Menu_Callback(handles,hObject,Full_date,eventdata);
if ~isempty(next_cell)
    next_callback=str2func(next_cell{1});  next_callback(handles.(sprintf('%s',next_cell{2})),eventdata,handles);
end
guidata(hObject,handles);

% --- Executes on selection change in Day1.
function Day1_Callback(hObject, eventdata, handles)
global Full_date
[Full_date, handles,next_cell] = Date_Menu_Callback(handles,hObject,Full_date,eventdata);
if ~isempty(next_cell)
    next_callback=str2func(next_cell{1});  next_callback(handles.(sprintf('%s',next_cell{2})),eventdata,handles);
end
guidata(hObject,handles);

% --- Executes on selection change in Day2.
function Day2_Callback(hObject, eventdata, handles)
global Full_date
[Full_date, handles,next_cell] = Date_Menu_Callback(handles,hObject,Full_date,eventdata);
if ~isempty(next_cell)
    next_callback=str2func(next_cell{1});  next_callback(handles.(sprintf('%s',next_cell{2})),eventdata,handles);
end
guidata(hObject,handles);

function Hour1_Callback(hObject, eventdata, handles)
global Full_date
[Full_date, handles,next_cell] = Date_Menu_Callback(handles,hObject,Full_date,eventdata);
if ~isempty(next_cell)
    next_callback=str2func(next_cell{1});  next_callback(handles.(sprintf('%s',next_cell{2})),eventdata,handles);
end
guidata(hObject,handles);

function Hour2_Callback(hObject, eventdata, handles)
global Full_date
[Full_date, handles,next_cell] = Date_Menu_Callback(handles,hObject,Full_date,eventdata);
if ~isempty(next_cell)
    next_callback=str2func(next_cell{1});  next_callback(handles.(sprintf('%s',next_cell{2})),eventdata,handles);
end
guidata(hObject,handles);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%END_OF_DATES%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function Lat_from_Callback(hObject, eventdata, handles)
global Latitude
lat_from = get(hObject,'String');
temp_lat_from = str2double(lat_from);
if ~isnan(temp_lat_from)
    Latitude(1) = temp_lat_from;
else
    set(handles.Lat_from,'String',num2str(Latitude(1)));
end
guidata(hObject,handles);

function Lat_to_Callback(hObject, eventdata, handles)
global Latitude
lat_to = get(hObject,'String');
temp_lat_to = str2double(lat_to);
if ~isnan(temp_lat_to)
    Latitude(2) = temp_lat_to;
else
    set(handles.Lat_to,'String',num2str(Latitude(2)));
end
guidata(hObject,handles);


% --- Executes on selection change in Freq_range.
function Freq_range_Callback(hObject, eventdata, handles)
global Pc_class
str = get(hObject, 'String');
val = get(hObject,'Value');
pc_choice = str{val}; % take the choice of month made as a string
switch pc_choice;
    case 'Pc 3-4 (16 mHz)', Pc_class = 'Pc34-16';
    case 'Pc 3-4 (10 mHz)', Pc_class = 'Pc34-10';
    case 'Pc 3-4 (5 mHz)', Pc_class = 'Pc34-5';
    case 'Pc 3-4 (20 mHz)', Pc_class = 'Pc34-20';
    case 'Pc 3 (20mHz)', Pc_class = 'Pc3';
    case 'Pc 4-5 (1 mHz)', Pc_class = 'Pc45';
    case 'Pc 3-5 (1 mHz)', Pc_class = 'Pc35';
    case 'Pc 1', Pc_class = 'Pc1';
    case 'Pc 2', Pc_class = 'Pc2';
end
guidata(hObject,handles);


function Sender_Callback(hObject, eventdata, handles)
global Full_date Pc_class Latitude mis_access_dat Params procFlag alignFlag
[Missions, Satellites, Filetype, Field_choice, Component] = MisSatFileFieldComp_get(handles);
if ~isempty([Missions{:}])   % check if at least one mission is chosen
        Params = eqn_misaccdat2param(mis_access_dat);
        Magnetar = eqn_MagnetarUnifiedProcess(Missions, Satellites, ...
            Filetype, Field_choice, Component, Full_date, Pc_class, Latitude, Params, procFlag);
        if alignFlag; Magnetar = eqn_alignMagnetar(Magnetar); end
        signal_Plotter_44(Magnetar);
        assignin('base', 'Magnetar', Magnetar);
end
guidata(hObject,handles);


% --- Executes when figure1 is resized.
function figure1_ResizeFcn(hObject, eventdata, handles)
% --- Executes during object creation, after setting all properties.
function figure1_CreateFcn(hObject, eventdata, handles)


% --- Executes on button press in checkbox10.
function checkbox10_Callback(hObject, eventdata, handles)
global procFlag

 procFlag = get(hObject,'Value');


% --- Executes on button press in checkbox11.
function checkbox11_Callback(hObject, eventdata, handles)
global alignFlag

alignFlag = get(hObject,'Value');
