function  handles_out = Mission_Menu_choice_Callback(handles,hObject,miscells,eventdata,varargin)

menu_tag = get(hObject,'Tag');
char_of_menu_ind = strfind(menu_tag,'choice'); % find where the 'choice' part of the name starts 
menu_name = (menu_tag(1:char_of_menu_ind-2)); % and take the previous-2 characters to see if a Mission or Sat or etc pop-up menu called
menu_numb = str2double(menu_tag(end)); % and also take the number of the pop-up menu
mission_str = get(handles.(sprintf('Mission_choice%d',menu_numb)),'String'); % take the mission strings
cur_mission = mission_str{get(handles.(sprintf('Mission_choice%d',menu_numb)),'Value')}; % and save in cur_mission which one is selected
cur_mission = strrep(cur_mission,'----','NoChoice'); % if the no-mission '----' choice is made, replace it with NoChoice so that the appropriate cells
% in the miscells structure can be accessed
str = get(hObject, 'String'); val = get(hObject,'Value'); % take the strings and selected value of the current object


switch menu_name
    case 'Mission'
        next_menu_prefix = 'Sat'; % the next menu that will be set AND called will be a sat menu since this was a mission menu
        next_menu_flag = 'go';
        sat_strs = miscells.(cur_mission){1,1}; % access the cell array in the miscell struct and take the {1,1} cell containing the satellite names 
        appropriate_strs = sat_strs;
    case 'Sat'
        temp_strs = miscells.(cur_mission)(:,2); % retrieve the file names for this mission from miscells
        file_strs = [temp_strs{:}].'; % and make them vertical cell of strings
        appropriate_strs = file_strs;
        next_menu_prefix = 'File'; % the next menu that will be called will be set AND called a file since this was a sat menu
        next_menu_flag = 'go';
    case 'File'
        cur_file = str{val};
        temp_vert = miscells.(cur_mission)(:,2); % take the 2nd column of cells from the corresponding mission which contains the file names and see which was chosen
        temp_vert = [temp_vert{:}].';
        log_ar = strcmp(temp_vert,cur_file); % strcmp to find vector of logicals indicating in which line is the chosen file e.g. [0 0 1 0]
        field_strs = miscells.(cur_mission)(log_ar,3);% take the element from the 3rd column of cells (containing field options) and the previously found line in the log_ar vector of logical 
        % from the corresponding mission which contains so that the corresponding fields can be loaded directly
        appropriate_strs = [field_strs{:}];
        next_menu_prefix = 'Field'; % the next menu that will be set AND called will be a field since this was a file menu
        next_menu_flag = 'go';
    case 'Field'
        compfield_strs = {'1';'2';'3';'Total'}; appropriate_strs = compfield_strs; 
        nocomp_choices = {'F';'B';'n'};
        next_menu_prefix = 'Comp'; % the next menu that will be -ONLY- set will be a comp menu since this was a field menu
        next_menu_flag = '';% NO next menu will be called since this was a field menu and component menus have/need no callback
        if logical(sum(strcmp(nocomp_choices,str{val}))) % if a scalar field (F,B,n) was chosen
            str{val} = '--'; % set the string as '--' so that in the if-else below the Comp_choice menu will NOT be set-activated
        end   
    otherwise
        error('Menu_choice_Callback cannot identify this uicontrol');
end

if isempty(strfind(str{val},'--')) % if a mission/sat/file/field was chosen and not the ---- (no-choice) selected
    set(handles.(sprintf('%s_choice%d',next_menu_prefix,menu_numb)),'Enable','on'); % turn on the next menu chooser
    set(handles.(sprintf('%s_choice%d',next_menu_prefix,menu_numb)),'String',appropriate_strs); % set its appropriate string choices
    set(handles.(sprintf('%s_choice%d',next_menu_prefix,menu_numb)),'Value',1); % and set the next menu at its first choice
else
    set(handles.(sprintf('%s_choice%d',next_menu_prefix,menu_numb)),'Enable','off');
    set(handles.(sprintf('%s_choice%d',next_menu_prefix,menu_numb)),'String',{'----';'----'});
    set(handles.(sprintf('%s_choice%d',next_menu_prefix,menu_numb)),'Value',1);
end

if ~isempty(next_menu_flag)
    next_menu_callback = sprintf('%s_choice%d_Callback',next_menu_prefix,menu_numb); % create the name of the callback for the menu to be called after
    next_menu_handle = findobj('TAG',sprintf('%s_choice%d',next_menu_prefix,menu_numb)); % % create and retrieve the NUMERIC HANDLE for the menu to be called after
    % next_menu_handle = str2func(next_menu_callback); % THIS would be used if we wanted the FUNCTION_HANDLE of the menu e.g. @Sat_choice1_Callback
    MissionsUnifiedGui(next_menu_callback,next_menu_handle,eventdata,handles); % call then next menu callback from inside the GUI to be activated
end
handles_out = handles; % return the handles structure
end

