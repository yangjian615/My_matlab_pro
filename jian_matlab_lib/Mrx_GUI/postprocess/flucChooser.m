function flucChooser
% plots fluctuation data for a given shot and allows for manual selection
% of the time point of optimal fluctuations.
% This info is stored in shotdb when save is pressed.
%
% Jan. 2016, Adrian von Stechow

c   = initMRX;
% shot database
db = matfile(c.dbPath);
db.Properties.Writable = true;

%  Create and then hide the UI as it is being constructed.
f = figure('Visible','off','Position',[10,50,800,850]);
f.Name = 'FlucChooser';
f.NumberTitle = 'off';
f.KeyPressFcn = @keyPress;

%  Construct the components.
hshot = uicontrol('Style','edit','String','Shot',...
    'Position',[220,410,100,30],...
    'Callback',@hshot_callback);
hauto = uicontrol('Style','pushbutton','String','Auto',...
    'Position',[100,410,100,30]);
hsel1 = uicontrol('Style','edit','String','t1',...
    'Position',[340,410,100,30]);
hsel2 = uicontrol('Style','edit','String','t2',...
    'Position',[460,410,100,30]);
hsave = uicontrol('Style','pushbutton','String','Save',...
    'Position',[580,410,100,30],...
    'Callback',@hsave_callback);
ax1 = axes('Units','Pixels','Position',[100,470,600,350]);
hp1 = plot(ax1,[200 400],[0 0],[200 400],[5 5],[200 400],[-5 -5],[200 400],[0 0],...
    'ButtonDownFcn',@hp1_callback);
hv1 = vline(ax1,200,'k');
hvs1= vline(ax1,200,'r');
hvc1= vline(ax1,200,'b');
ax2 = axes('Units','Pixels','Position',[100,40,600,350],...
    'ButtonDownFcn',@ax2_callback);
hp2 = plot(ax2,[200 400],[0 0],[200 400],[0 0],[200 400],[0 0],[200 400],[0 0],...
    'ButtonDownFcn',@hp2_callback);
hv2 = vline(ax2,200,'k');
hvs2= vline(ax2,200,'r');
hvc2= vline(ax2,200,'b');

% move UI to center screen
movegui(f,'center')

% make the UI visible
f.Visible = 'on';

% initialize variables
t1 = 0;
t2 = 0;
tSelect = 0;
tCross  = 0;
index   = 0;

% callback for shot text field
    function hshot_callback(source,eventdata)
        shot = str2num(source.String);
        
        % get current sheet selection and crossing time from shotdb
        index = find(db.shot == shot,1);
        if isempty(index)
            index = 0;
            tSelect = 0;
            tCross  = 0;
        else
            tSelect = db.tSelect(index,1);
            tCross  = db.tCross(index,1);
        end
        
        updateplots(shot);
    end

% update axes
    function updateplots(shot)
        % get fluctuation signals
        flucs = getMRXflucs(shot);
        
        components1 = {'Br','By','Bz','Ey'};
        shift1      = [3 1 -1 -3];
        components2 = {'pref','pr','py','pz'};
        shift2      = [0.6 0.2 -0.2 -0.6];
        
        for i = 1:4
            hp1(i).XData = flucs.time1;
            hp1(i).YData = flucs.(components1{i}) + shift1(i);
            hp2(i).XData = flucs.time2;
            hp2(i).YData = flucs.(components2{i}) + shift2(i);
        end
        
        ax1.XLim = [300 400];
        ax2.XLim = [300 400];
        
        % update time markers
        hvs1{1}.XData = [tSelect tSelect];
        hvc1{1}.XData = [tCross tCross];
        hvs2{1}.XData = [tSelect tSelect];
        hvc2{1}.XData = [tCross tCross];
        
        % TODO update selection marker 
    end

% axes 1 click callback
    function hp1_callback(source,eventdata)
        t1 = source.Parent.CurrentPoint(1);
        hsel1.String = num2str(t1,4);
        hv1{1}.XData = [t1 t1];
    end

% axes 1 click callback
    function hp2_callback(source,eventdata)
        t2 = source.Parent.CurrentPoint(1);
        hsel2.String = num2str(t2,4);
        hv2{1}.XData = [t2 t2];
    end

% save data
    function hsave_callback(source,eventdata)
        if index
            db.tSelectFP(index,1) = t1;
            db.tSelectPV(index,1) = t2;
        end
    end

% key press
    function keyPress(source,eventdata)
        if strcmp(eventdata.Key,'u')
            hshot.String = int2str(str2num(hshot.String)-1);
            hshot_callback(hshot,eventdata)
        elseif strcmp(eventdata.Key,'i')
            hshot.String = int2str(str2num(hshot.String)+1);
            hshot_callback(hshot,eventdata)
        elseif strcmp(eventdata.Key,'s')
            hsave_callback(hsave,eventdata)
        end
    end
end