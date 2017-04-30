function [Missions, Satellites, Filetype, Field_choice, Component] = MisSatFileFieldComp_get(handles)
    
    kr = findobj('-regexp','Tag','Mission_choice*'); % find number of Sat_choice panels (3 or 4 or...)
    nPanels = length(kr);
    
    Missions = cell(nPanels,1);
    Satellites = cell(nPanels,1);
    Filetype = cell(nPanels,1);
    Field_choice = cell(nPanels,1);
    Component = zeros(nPanels,1);
    for i=1:nPanels
        %%%Missions
        mission_str = get(handles.(sprintf('Mission_choice%d',i)),'String');
        mission_val = get(handles.(sprintf('Mission_choice%d',i)),'Value');
        cur_mission = mission_str{mission_val};
        if isempty(strfind(cur_mission,'--'))
            Missions{i} = cur_mission;
        end
        %%%Satellites
        sat_str = get(handles.(sprintf('Sat_choice%d',i)),'String');
        sat_val = get(handles.(sprintf('Sat_choice%d',i)),'Value');
        cur_sat = sat_str{sat_val};
         if isempty(strfind(cur_sat,'--'))
            Satellites{i} = cur_sat;
        end
%         table = [0 0 0 0];
%         if sat_val~= 1
%             table(sat_val-1) = 1;
%         end
%         Satellites{i} = table;
        
        %%%Filetypes
        file_str = get(handles.(sprintf('File_choice%d',i)),'String');
        file_val = get(handles.(sprintf('File_choice%d',i)),'Value');
        cur_file = file_str{file_val}; 
        if isempty(strfind(cur_file,'--'))
            Filetype{i} = cur_file;
        end
        %%%Fields
        field_str = get(handles.(sprintf('Field_choice%d',i)),'String');
        field_val = get(handles.(sprintf('Field_choice%d',i)),'Value');
        cur_field = field_str{field_val}; 
        if isempty(strfind(cur_field,'--'))
            Field_choice{i} = cur_field;
        end
        %%%Components
        comp_str = get(handles.(sprintf('Comp_choice%d',i)),'String'); 
        comp_val = get(handles.(sprintf('Comp_choice%d',i)),'Value');
        cur_comp = comp_str{comp_val};
        % 5/9/14 EDIT: New Component format!
        if ~isempty(strfind(cur_comp,'--'))
            Component(i) = 4; 
        else
            newCompValue = [4, 2, 1, 7];
            Component(i) = newCompValue(comp_val);
        end 
    end
end