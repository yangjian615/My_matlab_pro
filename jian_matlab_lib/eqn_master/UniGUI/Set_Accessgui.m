function mission_access = Set_Accessgui(mission_access,handles, parentgui_position)
% prompt_remote opens a dialog to insert host user and password to connect
% to be used to connect remotely to ESA server

    % remote_cell = Set_Accessgui(handles, parentgui_position) accepts its parent
    % gui handles structure and its position in normalized units and opens it to its
    % right and top equal aligned 
    
    
    %initialize ANSWER to empty cell array
%     global top_pass
    %%% START TOP-TOP SECRET - ERASE IN FUTURE VERSIONS
%     top_host = 'swarm-diss.eo.esa.int';
%     top_user = 'calval2';
%     top_pass = 'RaydGiwep5';
%     top_host = 'tromos.space.noa.gr';
%     top_user = 'swarm';
%     top_pass = 'swarm2501';
    %%% END TOP-TOP SECRET - ERASE IN FUTURE VERSIONS

    
    temp_mis_names = cell(4,1);
    
    for i=1:4
        str= get(handles.(sprintf('Mission_choice%d',i)),'String'); % get selected mission names from the UnifiedGui
        val = get(handles.(sprintf('Mission_choice%d',i)),'Value');
        if isempty(strfind(str{val},'--'))
            temp_mis_names{i}  = str{val};
        end
    end
    temp_mis_names = temp_mis_names(~cellfun(@isempty,temp_mis_names)); % remove empty fields 
    [~, idx] = unique(temp_mis_names,'first'); %take only unique fields - no double names
    mis_names = temp_mis_names(sort(idx)); % names to be displayed so user knows for which mission he's setting access for sorted as appearing in UnifiedGui
    idx_L2L = zeros(numel(mis_names),1); % index line to line (idx_L2L is a direct mapping of lines of mis_names corresponding to lines of mission_access
    for i=1:numel(mis_names) % find corresponding mission names in the mission_access cell array fed from the UnifiedGui
        idx_L2L(i) = find(ismember(mission_access(:,1),mis_names(i))); % and store the indexes to be used
    end
    loc_mission_access = mission_access;
    
    bgcolor = get(0,'defaultUicontrolBackgroundColor');
    xlength = 0.34;
    yheight = 0.2;
    pos = parentgui_position;
    title = 'Set Access Data';
    position = [pos(1)+pos(3)+0.01,pos(2)+pos(4)-yheight,xlength,yheight];
    Access_gui.fig = figure('Units','normalized','Position',position,...
                             'MenuBar','none','NumberTitle','off',...
                             'WindowStyle','modal','Color',bgcolor,'Name',title);

        %set up GUI controls and text
        Access_gui.TempDirtext = uicontrol('style','text','String','Temp Dir','Units','normalized',...
            'Position',[0.1 0.8 0.2 0.1],'HorizontalAlignment','left','Fontsize',10);
        Access_gui.LocalDBtext = uicontrol('style','text','String','Local Database','Units','normalized',...
        'Position',[0.45 0.8 0.2 0.1],'HorizontalAlignment','left','Fontsize',10);
        Access_gui.RemoteDBtext = uicontrol('style','text','String','Remote Database','Units','normalized',...
            'Position',[0.80 0.8 0.2 0.1],'HorizontalAlignment','left','Fontsize',10);

        %%%%% parametric input uicontrols
        for i=1:numel(mis_names)
            %mission texts
            Access_gui.(sprintf('Mission_name%d',i)) = uicontrol('style','text','String',loc_mission_access{idx_L2L(i),1},'Units','normalized',...
            'Position',[0.005 0.7-(i-1)*0.15 0.1 0.1],'HorizontalAlignment','left','Fontsize',9);
        
            %temp dir UIs
            Access_gui.(sprintf('TempDir%d',i)) = uicontrol('style','edit','String',loc_mission_access{idx_L2L(i),2},'Units','normalized',...
            'Position',[0.1 0.71-(i-1)*0.15 0.27 0.1],'HorizontalAlignment','left','BackgroundColor','white','Fontsize',10);
            Access_gui.(sprintf('TempDirSet%d',i)) = uicontrol('style','pushbutton','String','...','Units','normalized',...
            'Position',[0.375 0.71-(i-1)*0.15 0.04 0.1],'HorizontalAlignment','left',...
            'Tag',sprintf('TempDirSet%d',i),'Callback', @DirSet_Callback);

            %local DB UIs
            Access_gui.(sprintf('LocalDB%d',i)) = uicontrol('style','edit','String',loc_mission_access{idx_L2L(i),3},'Units','normalized',...
            'Position',[0.45 0.71-(i-1)*0.15 0.27 0.1],'HorizontalAlignment','left','BackgroundColor','white','Fontsize',9);
            Access_gui.(sprintf('LocalDBSet%d',i)) = uicontrol('style','pushbutton','String','...','Units','normalized',...
            'Position',[0.725 0.71-(i-1)*0.15 0.04 0.1],'HorizontalAlignment','left',...
            'Tag',sprintf('LocalDBSet%d',i),'Callback', @DirSet_Callback);

            %remote DB UIs
            Access_gui.(sprintf('RemoteDBSet%d',i)) = uicontrol('style','pushbutton','String','Set Data','Units','normalized',...
            'Position',[0.81 0.71-(i-1)*0.15 0.1 0.1],'HorizontalAlignment','left',...
            'Tag',sprintf('RemoteDBSet%d',i),'Callback',@RemoteSet_Callback);
        end
        
        Access_gui.okayButton = uicontrol('style','pushbutton','Units','normalized',...
            'position', [0.3 0.05 0.15 0.15],'string','OK','callback',@okCallback);
        Access_gui.cancelButton = uicontrol('style','pushbutton','Units','normalized',...
            'position', [0.55 0.05 0.15 0.15],'string','Cancel','callback',@cancCallback);
        
        %wait for user input, and close once a button is pressed 
        uiwait(Access_gui.fig);

        %callbacks for '...', 'Set Data', 'OK' and 'Cancel' buttons
        
        function DirSet_Callback(hObject,eventdata)
            ctrl_name = get(hObject,'Tag'); % get the tag of the button that called the function to identify it by its name and number
            col_ind = logical([~isempty(strfind(ctrl_name,'Temp')) isempty(strfind(ctrl_name,'Temp')) 0]);
            row_ind = str2num(ctrl_name(end)); % identify

            Dir = loc_mission_access{row_ind,col_ind};
            user_dir = uigetdir();
            if user_dir ~= 0 % the user did not press cancel and a new dir was defined
                if user_dir(end) ~= '\'
                    Dir = [user_dir '\'];
                else Dir = user_dir;
                end
            end
            loc_mission_access{row_ind,col_ind} = Dir;
            new_name = strrep(ctrl_name,'Set','');
            set(Access_gui.(sprintf('%s',new_name)),'String',Dir);
        end

    function RemoteSet_Callback(hObject, eventdata)
            ctrl_name = get(hObject,'Tag'); % get the tag of the button that called the function to identify it by its name and number
            temp_pos = get(Access_gui.fig,'position');
            idxr = str2num(ctrl_name(end)); % find the row that the button belongs to in the Set_access gui
            idxc = idx_L2L(idxr);
%           idxc = find(ismember(mission_access(:,1),mis_names(idxr))); % find the name of the mission in which row is in mission_access
            remote_title = mis_names{idxr}; % use the name of the mission for which the remote will be called to be displayed in the title of the remote
            loc_mission_access(idxc,4:6) = prompt_remote(temp_pos,remote_title,loc_mission_access(idxc,4:6)); % give and store the info to/from the prompt from/in the mission_access array
    end

    
        function okCallback(hObject,eventdata)
            for j=1:numel(mis_names)
                loc_mission_access{idx_L2L(i),2} = get(Access_gui.(sprintf('TempDir%d',j)),'String');
                loc_mission_access{idx_L2L(i),3} = get(Access_gui.(sprintf('LocalDB%d',i)),'String');
            end
            mission_access = loc_mission_access; % return the data from the loc_mission access to the mission_access to be returned to the UnifiedGui
            uiresume(Access_gui.fig);
            close(Access_gui.fig);
        end

        function cancCallback(hObject,eventdata)
            uiresume(Access_gui.fig); % return nothing just close the GUI
            close(Access_gui.fig);
        end        
end