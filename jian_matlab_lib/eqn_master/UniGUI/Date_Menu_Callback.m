function [Full_date, handles_out, next_cell] = Date_Menu_Callback(handles,hObject,Full_date,varargin)

next_cell = {};
toc = {'Year',1;'Month',2;'Day',3;'Hour',4};
str = get(hObject,'String');
val = get(hObject,'Value');

%%%%finding calling menu elements
menu_tag = get(hObject,'Tag');
idxrow = strncmp(toc,menu_tag,3);% compare first 3 characters to find row (what kind of menu has been activated)
menu_prefix = toc{idxrow}; % idxrow is a logical 4x2 here
%%% switching between calling elements for appropriate actions (set etc)
switch menu_tag
    case 'Year1'; set(handles.Year2,'String',str(val:end));
        set(handles.Year2,'Value',1); % set the year_to to show the same year
    case {'Month1','Day1'};
        set(handles.(sprintf('%s2',menu_prefix)),'Value',val); % set the year_to to show the same year 
    case 'Hour1'
        str = hour_fix(str);
        set(handles.Hour1,'String',str);
        set(handles.Hour2,'String',str);
    case 'Hour2'
        str = hour_fix(str);
        set(handles.Hour2,'String',str);
end
%%% Retrieve the actual showing elements from the gui handles and store them in Full_date
for i=1:3
    col1_el = get(handles.(sprintf('%s1',toc{i,1})),'String');
    Full_date{i,1} = col1_el{get(handles.(sprintf('%s1',toc{i,1})),'Value')};
    col2_el = get(handles.(sprintf('%s2',toc{i,1})),'String');
    Full_date{i,2} = col2_el{get(handles.(sprintf('%s2',toc{i,1})),'Value')};
end
Full_date{4,1} = get(handles.Hour1,'String');
Full_date{4,2} = get(handles.Hour2,'String');

%%% send the Full_date to be checked and take any messages that are returned (if any inconsistencies occured)
[message] = Time_range_check(Full_date);

if ~isempty(message) % if any messages returned make ready the elements that will be used to call it inside the GUI ***see below
    next_cell{1} = sprintf('%s1_Callback',message);% (next_menu_callback) create the name of the callback for the menu that something is wrong to be called
    next_cell{2} = sprintf('%s1',message);
end

%**** this cannot be done from here because the callback eg Month1_Callback in the GUI will execute BEFORE this function has completed and returned
% the new Full_date and made it available to the GUI. This is bad and you should feel bad if you do it.
handles_out=handles;
end