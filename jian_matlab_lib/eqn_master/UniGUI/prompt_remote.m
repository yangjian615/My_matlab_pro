function remote_cell = prompt_remote(parentgui_position,varargin)
% prompt_remote opens a dialog to insert host user and password to connect
% to be used to connect remotely to ESA server

    % remote_cell = prompt_remote(parentgui_position) accepts its parent
    % gui position in normalized units and opens it to its
    % right and top equal aligned 
    
    
    
    %%% START TOP-TOP SECRET - ERASE IN FUTURE VERSIONS
%     top_host = 'swarm-diss.eo.esa.int';
%     top_user = 'calval2';
%     top_pass = 'RaydGiwep5';
    %%% END TOP-TOP SECRET - ERASE IN FUTURE VERSIONS

    %initialize cell array in case no argins came 
    remote_cell = cell(3,1);
    remote_cell = varargin{2}; % take the host user and password data from the argin
    top_host = remote_cell{1};
    top_user = remote_cell{2};
    top_pass = remote_cell{3};    
        
    bgcolor = get(0,'defaultUicontrolBackgroundColor');
    length = 0.14;
    height = 0.2;
    pos = parentgui_position;
    title = sprintf('%s Remote Access',varargin{1});
    position = [pos(1)+pos(3)+0.01,pos(2)+pos(4)-height,length,height];
    remote_Wind.fig = figure('Units','normalized','Position',position,...
                             'MenuBar','none','NumberTitle','off',...
                             'WindowStyle','modal','Color',bgcolor,'Name',title);

    %set up GUI controls and text
    remote_Wind.hosttext = uicontrol('style','text','String',sprintf('%s Host',varargin{1}),'Units','normalized',...
                                     'Position',[0.05,0.8,0.9,0.1],'HorizontalAlignment','left','Fontsize',10);
    remote_Wind.host = uicontrol('style','edit','String',top_host,'Units','normalized',...
        'Position',[0.05,0.72,0.9,0.1],'HorizontalAlignment','left','BackgroundColor','white');
    remote_Wind.usertext = uicontrol('style','text','String',sprintf('%s Username',varargin{1}),'Units','normalized',...
                                     'Position',[0.05,0.6,0.9,0.1],'HorizontalAlignment','left','Fontsize',10);
    remote_Wind.user = uicontrol('style','edit','String',top_user,'Units','normalized',...
    'Position',[0.05,0.52,0.9,0.1],'HorizontalAlignment','left','BackgroundColor','white');
    remote_Wind.pswdtext = uicontrol('style','text','String',sprintf('%s Password',varargin{1}),'Units','normalized',...
                                     'Position',[0.05,0.4,0.9,0.1],'HorizontalAlignment','left','Fontsize',10);
    remote_Wind.pswd = uicontrol('style','edit','String',top_pass,'Units','normalized',...
        'Position',[0.05,0.32,0.9,0.1],'HorizontalAlignment','left','BackgroundColor','white');
    
    remote_Wind.okayButton = uicontrol('style','pushbutton','Units','normalized',...
        'position', [0.32,0.05,0.3,0.15],'string','OK','callback',@okCallback);
    remote_Wind.cancelButton = uicontrol('style','pushbutton','Units','normalized',...
        'position', [0.65,0.05,0.3,0.15],'string','Cancel','callback',@cancCallback);

   

    %wait for user input, and close once a button is pressed 
    uiwait(remote_Wind.fig);

    %callbacks for 'OK' and 'Cancel' buttons
        function okCallback(hObject,eventdata)
            remote_cell{1} = get(remote_Wind.host,'String');
            remote_cell{2} = get(remote_Wind.user,'String');
            remote_cell{3} = get(remote_Wind.pswd,'String');
            uiresume(remote_Wind.fig);
            close(remote_Wind.fig);
        end

        function cancCallback(hObject,eventdata)
            uiresume(remote_Wind.fig);
            close(remote_Wind.fig);
        end        
end