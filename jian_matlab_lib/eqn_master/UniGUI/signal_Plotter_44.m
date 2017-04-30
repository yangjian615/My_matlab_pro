function h = signal_Plotter_44(Magnetar)

namestring = ['Signal Plotter v1.5    COPYLEFT',char(169),'2013 SAGiamini -- ALL RIGHTS RESERVED'];

h.fig = findall(0, 'Name', namestring);

if ~isempty(h.fig)
    close(h.fig);
end

screen_res = get(0,'ScreenSize');
vert_pixels = 0.95*screen_res(4);
horz_pixels = vert_pixels*1.122; % optimal viewing aspect for the GUI
horz_ratio = horz_pixels/screen_res(3);
start_xpoint = (1-horz_ratio);

h.fig = figure( 'Units', 'normalized',...
                'MenuBar','none',...
                'Toolbar','figure',...
                'Name', 'plot_example',...
                'NumberTitle', 'off',...
                'Name', namestring,...
                'PaperPositionMode', 'auto',...
                'OuterPosition', [start_xpoint 0.05 horz_ratio 0.95]);

% get(h.fig,'PaperUnits');

global track_no track_b_ind track_r_ind track_d_ind resolution track_save_type track_bool save_fig_position track_lims B_lims

%%% saving images settings
local_dpi = get(0,'ScreenPixelsPerInch');
dpi_multiplier = 4096/screen_res(3); % 4k resolution is 4096x2160
fourK_dpi = dpi_multiplier*local_dpi; % will be used in -r option of print, see below
yim16to9 = screen_res(3)/(16/9);
yim169_norm = yim16to9/screen_res(4); % 16:9 is to be used as a default saving aspect ratio for images regardless of screen size/ratio
save_fig_position = [0 0 1 yim169_norm];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% CHANGE THE DEFAULT RESOLUTION OF SAVED IMAGES HERE %%%%            
resolution = sprintf('-r%0.5f',fourK_dpi); % '-r300' means 300 dpi, '-r150' means 150 dpi
%%%% CHANGE THE DEFAULT IMAGE TYPE OF SAVED TRACKS HERE %%%%
track_save_type = '-dpng'; % for jpg change to '-djpeg', for bmp '-dbmp'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

track_no = 1;
track_b_ind = [1 length(Magnetar.B{1,1}(:,1))];
track_r_ind = [1 length(Magnetar.R{1,1}(:,1))];
if ~isempty(Magnetar.d{1,1}); track_d_ind = [1 length(Magnetar.d{1,1}(:,1))]; end 
track_bool = false;
nColumns = length(Magnetar.B);
no_of_tracks = size(Magnetar.Bind{1,1}, 1);
for i=2:nColumns
    no_of_tracks = min([no_of_tracks, size(Magnetar.Bind{i,1}, 1)]);
end
track_lims = eqn_findLimsAcrossTracks(Magnetar);
B_lims = eqn_findLimsAcrossAll(Magnetar);

% satellites = Magnetar.SCF{1,1};
% component = Magnetar.SCF{2,1};
% field = Magnetar.SCF{3,1};
% 
% if ~isempty(strfind(field,'vectoral'))
%     max_comp =  max(sum(component,2));
% else max_comp = 1;
% end
% 
% max_sat = (sum(satellites));
if nColumns == 4
%      set(h.fig, 'OuterPosition',[0 0.04 1 0.96]);
    x_length = 0.17;
else
    x_length = 0.73/nColumns + 0.03*(3-nColumns); % parametrically calculate the length of axis according to number of columns
end
    y_length = 0.24; % the vertical dimension is fixed
dx = 0.06;
if nColumns == 1; x_start = 0.09;
else x_start = 0.07;
end


%%%% axes construction
for i=1:nColumns
    k = (i-1)*3 + 1;
    h.axes(k)   = axes('position',[x_start+(x_length+dx)*(i-1) 0.15 (x_length) y_length]); %#ok<*LAXES>
    h.axes(k+1) = axes('position',[x_start+(x_length+dx)*(i-1) 0.4 (x_length) y_length]);
    h.axes(k+2) = axes('position',[x_start+(x_length+dx)*(i-1) 0.65 (x_length) y_length]);
end

%%%% buttons construction



axes_start = get(h.axes(1), 'Position');
axes_end = get(h.axes(end), 'Position');
ax_end = axes_end(1)+axes_end(3);

                    
h.figure_title = uicontrol('style','text','Units','normalized','position', [0.2 0.96 0.6 0.02],...
                        'fontsize',10,'Visible','on','string', '');                    

h.track_ind = uicontrol('style','edit','Units', 'normalized','position', [0.455 0.01 0.09 0.03],...
                        'fontsize',11,'Visible','off','Enable','inactive','string',sprintf('track:%d/%d',track_no,no_of_tracks));
set(h.track_ind, 'ButtonDownFcn',{@clear_track_ind,h});
set(h.track_ind, 'Callback',{@track_ind_signal,h});

h.track_increment_check = uicontrol('style','checkbox','Units', 'normalized','position', [0.655 0.023 0.04 0.02],...
                        'fontsize',10,'Visible','off','BackGroundColor',get(h.fig,'Color'));
h.increment_string = uicontrol('style','text','Units','normalized','position', [0.628 0.005 0.07 0.02],...
                        'fontsize',10,'Visible','off','string', 'Double step','BackGroundColor',get(h.fig,'Color'));

                    

%%%%%%                    
button_size_xy = [0.07 0.04];

% prev_string = sprintf('<html>track <br>&nbsp;%d&nbsp;&larr;&nbsp;',track_no-1);
h.prev_button = uicontrol('style','pushbutton','Units','normalized','position', [0.375 0.001 button_size_xy],...
                        'fontsize',10,'Visible','off','string', '<html>track <br>&nbsp;&nbsp;&larr');
set(h.prev_button,'callback',{@prev_button_signal,h});


h.next_button = uicontrol('style','pushbutton','Units', 'normalized','position', [0.555 0.001 button_size_xy],...
                        'fontsize',10,'Visible','off','string', '<html>track <br>&nbsp;&nbsp;&rarr');
set(h.next_button,'callback',{@next_button_signal,h});      

h.save_alltracks_button = uicontrol('style','pushbutton','Units', 'normalized','position', [ax_end-button_size_xy(1) 0.001 button_size_xy],...
                        'fontsize',10,'Visible','on','string', '<html>save all<br>&nbsp;tracks'); %keep the end of the button aligned with end of last axes
set(h.save_alltracks_button,'callback',{@save_alltracks_signal,h});

h.save_figure_button = uicontrol('style','pushbutton','Units', 'normalized','position', [ax_end-button_size_xy(1)-0.025-button_size_xy(1) 0.001 button_size_xy],...
                        'fontsize',9,'Visible','on','string', '<html>save this<br>&nbsp;&nbsp;&nbsp;&nbsp;figure');
set(h.save_figure_button,'callback',{@save_figure_signal,h});   

h.trackbytrack_button = uicontrol('Style','pushbutton','Units','normalized','position',[axes_start(1) 0.001 button_size_xy+[0.1 0]],...
                                 'fontsize',10,'string','View Track by Track'); %keep the start of the button aligned with start of first axes
set(h.trackbytrack_button, 'callback', {@trackbytrack_signal,h});
                   



plotter(h);

%%%% nested functions
    function prev_button_signal(hObject, eventdata, h)
    % hObject    handle to prev_button (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
        min_tracks = 1;
        if track_no >=2
            extra_step = get(h.track_increment_check,'Value');
            prev_track_no = track_no;
            track_no = track_no-(1+extra_step);
            if track_no < min_tracks; 
                if extra_step > 0
                    track_no = prev_track_no;
                else
                    track_no = min_tracks; 
                end
            end 
%             track_b_ind = Magnetar.Bind{1,1}(track_no,:);
%             track_r_ind = Magnetar.Rind{1,1}(track_no,:);
			if ~isempty(Magnetar.d{1,1}); track_d_ind = Magnetar.dind{1,1}(track_no,:);end
            set(h.track_ind,'String',sprintf('track:%d/%d',track_no,no_of_tracks),'Enable','inactive')
			set(h.prev_button,'Enable','off');
            plotter(h);
			set(h.prev_button,'Enable','on');
        end
    end

    function next_button_signal(hObject, eventdata, h)
    % hObject    handle to next_button (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
            max_tracks = no_of_tracks;
            if track_no < max_tracks
                extra_step = get(h.track_increment_check,'Value');
                prev_track_no = track_no;
                track_no = track_no+(1+extra_step);
            if track_no > max_tracks; 
                if extra_step > 0
                    track_no = prev_track_no;
                else
                    track_no = max_tracks; 
                end
            end 
    %             track_b_ind = Magnetar.Bind{1,1}(track_no,:);
    %             track_r_ind = Magnetar.Rind{1,1}(track_no,:);
                if ~isempty(Magnetar.d{1,1}); track_d_ind = Magnetar.dind{1,1}(track_no,:); end
                set(h.track_ind,'String',sprintf('track:%d/%d',track_no,no_of_tracks),'Enable','inactive')
                set(h.next_button,'Enable','off');
                plotter(h);
                set(h.next_button,'Enable','on');
            end
    end

    function save_figure_signal(hObject,eventdata,h)
        time_name_loc(1) = Magnetar.B{1,1}(track_b_ind(1),end); % take date from the time column of B (in MATLAB format)
        time_name_loc(2) = Magnetar.B{1,1}(track_b_ind(2),end); % to use in filename save for beginning and end time
        name =  ['SWARM-', datestr(time_name_loc(1), 'yyyy_mm_dd__HH_MM'),...
                    '___',datestr(time_name_loc(2), 'yyyy_mm_dd__HH_MM')];
        [path_name_output, type_index] = path_name_maker(name);
        if path_name_output ~= 0 % if the user did not cancel the action
            switch type_index
                case 1; type_opt = '-dpng';
                case 2; type_opt = '-djpeg';
                case 3; type_opt = '-dbmp';
                case 4; type_opt = '-depsc2';
            end
            title_pos = get(h.figure_title,'position');
            title_str = get(h.figure_title,'String');
            temp_pos_vec = get(h.fig, 'OuterPosition');
            plotter(h,'off'); % re-draw the GUI in "invisible" mode to be able to make it "fullscreen"
            set(h.fig, 'OuterPosition',save_fig_position); % make the GUI "fullscreen" for default saving size
            
            htex = text_inGUI(h.axes(end),title_pos(1)+title_pos(3)/2,title_pos(2)+title_pos(4)/2,title_str,...
                'HorizontalAlignment','Center','Units','normalized','fontsize',12);
            print(h.fig, type_opt, '-noui','-loose',resolution,path_name_output);
            delete(htex);
            set(h.fig, 'OuterPosition',temp_pos_vec); % restore the GUI's size as it was before
            plotter(h) % re-draw the GUI in "visible" mode with previous size
            % fancy checkmark appearing for 1 second to indicate all went well
            temp_str = get(h.save_figure_button,'String');
            temp_font = get(h.save_figure_button,'fontsize');
            set(h.save_figure_button,'String','<html> &#10003','fontsize',15);
            pause(1)
            set(h.save_figure_button,'String',temp_str,'fontsize',temp_font);
        end        
    end

    function save_alltracks_signal(hObject,eventdata,h, saveinfolder, figure_type)
        if nargin < 5
            figure_type = track_save_type;
        end
        if nargin < 4
            saveinfolder = uigetdir(pwd,'Select directory to save tracks');
        end
        if saveinfolder ~= 0 % if the user did not cancel the action
            temp_trackbind = track_b_ind; % temporarily store the currently
            temp_trackrind = track_r_ind; % plotted parts of the signals       
			temp_trackdind = track_d_ind;          
            temp_track_bool_status = track_bool;
            temp_track_no = track_no;
            number_of_tracks = no_of_tracks;
            progressbar('                                             Saving tracks please wait');
			time_name_loc =zeros(number_of_tracks,2);
            track_bool = true;
            temp_pos_vec = get(h.fig, 'OuterPosition');
            set(h.fig, 'OuterPosition',save_fig_position); % make the GUI "fullscreen" in 16:9 mode for default saving aspect ratio
            for i_loc = 1:number_of_tracks
                progressbar(i_loc/number_of_tracks);
                track_no = i_loc;
%                 track_b_ind = Magnetar.Bind{1,1}(i_loc,:);
%                 track_r_ind = Magnetar.Rind{1,1}(i_loc,:);

                plotter(h,'off');
                time_name_loc(i_loc,1) = Magnetar.B{1,1}(track_b_ind(1),end); % take date from the time column of B (in MATLAB format)
                time_name_loc(i_loc,2) = Magnetar.B{1,1}(track_b_ind(2),end); % to use in filename save for beginning and end time

                path_name_output = [saveinfolder, '\TRACK-', datestr(time_name_loc(i_loc,1), 'yyyy_mm_dd__HH_MM'),...
                    '___',datestr(time_name_loc(i_loc,2), 'yyyy_mm_dd__HH_MM')];
                title_pos = get(h.figure_title,'position');
                title_str = get(h.figure_title,'String');
                htex = text_inGUI(h.axes(end),title_pos(1)+title_pos(3)/2,title_pos(2)+title_pos(4)/2,title_str,...
                    'HorizontalAlignment','Center','Units','normalized','fontsize',12);
                print(h.fig,figure_type, '-noui','-loose',resolution,path_name_output);
                delete(htex);
            end
            
            set(h.fig, 'OuterPosition',temp_pos_vec); % restore the GUI's size as it was before
            track_b_ind = temp_trackbind; % restore the original
            track_r_ind = temp_trackrind; % values and call plotter 
			track_d_ind = temp_trackdind; 
            track_bool = temp_track_bool_status;
            track_no = temp_track_no;
            plotter(h);                   % restore the figure as it was before saving the tracks
            % fancy checkmark appearing for 1.5 second to indicate all went well
            temp_str = get(h.save_alltracks_button,'String');
            temp_font = get(h.save_alltracks_button,'fontsize');
            set(h.save_alltracks_button,'String','<html> &#10003','fontsize',15);
            pause(1.5)
            set(h.save_alltracks_button,'String',temp_str,'fontsize',temp_font);
        end
    end


    function trackbytrack_signal(hObject,eventdata,h)
        
        if ~isempty(strfind(get(h.trackbytrack_button,'String'),'Track'))
            track_str = 'View full timeseries';
            vis_str = 'on';
            track_bool = true;
        else
            track_str = 'View Track by Track';
            vis_str = 'off';
            track_bool = false;
        end
        set(h.trackbytrack_button,'String',track_str);
        set(h.prev_button,'Visible',vis_str);
        set(h.next_button,'Visible',vis_str);
        set(h.track_ind,'Visible',vis_str);
        set(h.track_increment_check,'Visible',vis_str);
        set(h.increment_string,'Visible',vis_str);
        plotter(h);
    end

    function clear_track_ind(hObject,eventdata,h)
        set(h.track_ind, 'String','','Enable','on');
        uicontrol(h.track_ind); % This activates the edit box and places the cursor in the box, ready for user input.
    end
    
    function track_ind_signal(hObject,eventdata,h)
        temp_track_no = str2num(get(h.track_ind,'String'));
        if ~isempty(temp_track_no) && (temp_track_no <= length(Magnetar.Bind{1,1})) && (temp_track_no >= 1)
            track_no = temp_track_no;
        end
        set(h.track_ind,'String',sprintf('track:%d/%d',track_no,no_of_tracks),'Enable','off');
        plotter(h);
        set(h.track_ind,'Enable','inactive');
    end


    function plotter(h,vis_flag)
        if nargin < 2; vis_flag = 'on';
        end
        
        TITLE_CHANGE_FLAG = 0;

        axes_len = length(h.axes);
        
        for i_local=1:3:axes_len % the axes are "numbered" [3 6 9; 2 5 8; 1 4 7]. They are constructed in columns 
                               % starting from the left down corner and
                               % going upwards continuing from the bottom of the next column and so on

            set(h.fig,'Visible',vis_flag)                   
            index_inside_magn = floor(i_local/3)+1;
            
            % Assignment of track indices (for this column of plots)
            if track_bool
                track_b_ind = Magnetar.Bind{index_inside_magn,1}(track_no,:);
                track_r_ind = Magnetar.Rind{index_inside_magn,1}(track_no,:);
                if ~isempty(Magnetar.d{index_inside_magn,1});track_d_ind = Magnetar.dind{index_inside_magn,1}(track_no,:);end
            else
                track_b_ind = [1 length(Magnetar.B{index_inside_magn,1}(:,1))];
                track_r_ind = [1 length(Magnetar.R{index_inside_magn,1}(:,1))];
                if ~isempty(Magnetar.d{index_inside_magn,1});track_d_ind = [1 length(Magnetar.d{index_inside_magn,1}(:,1))];end
            end
            
            % Assignment of local variables (for this column of plots)
            time = Magnetar.B{index_inside_magn,1}(track_b_ind(1):track_b_ind(2),end);
			
            Lat_time = Magnetar.R{index_inside_magn,1}(track_r_ind(1):track_r_ind(2),end);
            Bsignal = Magnetar.B{index_inside_magn,1}(track_b_ind(1):track_b_ind(2),1);
            Bsignal(abs(Bsignal)<1e-10) = 0;
            Wsignal = Magnetar.W{index_inside_magn,1}(:,track_b_ind(1):track_b_ind(2));
            % structure of Magnetar.R is [rGEO rMAG xGEO Time]
            Geolat_signal = Magnetar.R{index_inside_magn,1}(track_r_ind(1):track_r_ind(2),1); % GEO Latitude
            Geolon_signal = Magnetar.R{index_inside_magn,1}(track_r_ind(1):track_r_ind(2),2); % GEO Longitude
            MagLat_signal = Magnetar.R{index_inside_magn,1}(track_r_ind(1):track_r_ind(2),4); % MAG Latitude
            Xsignal = Magnetar.R{index_inside_magn,1}(track_r_ind(1):track_r_ind(2),7:9); % GEO XYZ
            
            columnLabel = Magnetar.label{index_inside_magn,1};
            
            % NaNs = sum(isnan(Bsignal));
            % disp(['NaN values = ', num2str(nNaNs)]);
            % disp(['NaN percentage = ', num2str(100*nNaNs/length(Bsignal))]);
			
            if fix(time(1))~=fix(time(end))
                title_string = ['Date Range: ',datestr(time(1),'dd mmm yyyy'),' - ', datestr(time(end),'dd mmm yyyy')];
                TITLE_CHANGE_FLAG = 1;
            elseif fix(time(1))==fix(time(end)) && ~TITLE_CHANGE_FLAG
                title_string = ['Date: ', datestr(time(1),'dd mmm yyyy')];
            end
            set(h.figure_title,'String',title_string);
            
            if ~isempty(Magnetar.d{index_inside_magn,1}) && ~isnan(track_d_ind(1))
                dsignal = Magnetar.d{index_inside_magn,1}(track_d_ind(1):track_d_ind(2),1);
                Ionic_time = Magnetar.d{index_inside_magn,1}(track_d_ind(1):track_d_ind(2),end);
            else
                dsignal = nan(length(time),1);
                Ionic_time = time;
            end

 			frequencies = Magnetar.Freq{index_inside_magn,1};
            freq_ceil = ceil(log2(max(frequencies)));
            nTimeTicks = [11, 8, 5, 4];
            timeTicks = linspace(time(1),time(end),nTimeTicks(round(axes_len/3)))';
            timeTickLabels = datestr(timeTicks, 'HH:MM');
            df = diff(frequencies);
            if abs(df(2)-df(3)) < 10^-10 % linear freq scale
                disp('linear scale detected');
                freqTicks = (0:0.2:1)'; % for linear freqs
                freqTickLabels = 1000*(freqTicks); % for linear freqs
            else % logarithmicallyspaced freqs
                frequencies = log2(frequencies);
                freqTicks = (log2(1/1000):1:freq_ceil)'; % convert frequencies in power of 2 and use as number for ticks
                freqTicks = [freqTicks; frequencies(1); frequencies(end)]; %#ok<AGROW>
                freqTicks = sort(freqTicks, 1, 'ascend');
                freqTickLabels = 1000*(2.^freqTicks); % but use ticklabels as actual frequencies (for readability)
            end
			%%% plot bottom row of axes
            if all(isnan(MagLat_signal));  lat_plot = Geolat_signal;
            else lat_plot = MagLat_signal; end;
            
            [axh, h1, h2] = plotyy(Lat_time,lat_plot,Ionic_time,dsignal,'Parent',h.axes(i_local));         
            set(h1, 'color', 'blue','Linewidth',2);
            set(h2, 'color', [0 0.5 0],'Linewidth',2); % greenish color
			
			y1tick = (-90:30:90)';
            extra_limit1 = 0.05*(max(y1tick)-min(y1tick));
            max_dens = 3.0;
            y2tick = (0:(max_dens/6):max_dens)';
            extra_limit2 = 0.05*max_dens;

            set(axh(1), 'ylim', [-90-extra_limit1 90+extra_limit1],'ytick',y1tick,...
                'xlim', [time(1), time(end)], 'xtick', timeTicks, 'xticklabel', timeTickLabels);
			label_multiplier = 0.025*((axes_len/3)+1); % wiil be used in middle row as well
            
            if i_local == 1; % bottom row leftmost axes needs a label and a xlabel (UT:)           
                yh1 = get(axh(1),'ylabel');
                if all(isnan(MagLat_signal)); ax_lab = 'Latitude'; else ax_lab = 'Mag.Lat.'; end
                set(yh1,'String',[ax_lab,' (degrees)'],'Units','normalized', 'position',[-label_multiplier, 0.5],'FontWeight','bold');
%                 set(axh(1),'Units','normalized');
%                 axh1_pos = get(axh(1),'position');
%                 text_inGUI(axh(1),axh1_pos(1)-0.04,axh1_pos(2)-0.01,'UT:','HorizontalAlignment','Center','FontWeight','bold');
                xh1 = get(axh(1),'xlabel');
                set(xh1,'String','UT:','Units','normalized', 'position',[-0.8*label_multiplier, -0.025],...
                    'HorizontalAlignment','Right','FontWeight','bold');
            end
            if i_local == axes_len-2 % bottom row righttmost axes needs a label
                yh2 = get(axh(2),'ylabel');
                extra_small_space = (axes_len/3)*0.005;
                set(yh2,'String','n_{e^-} (10^6/cm^3)','Units','normalized', 'position',[1+extra_small_space+label_multiplier, 0.5],'FontWeight','bold');
            end
                
            set(axh(2), 'ylim', [0-extra_limit2 max_dens+extra_limit2], 'ytick', y2tick, ...
                 'xlim', [time(1), time(end)],'xtick', []);
				 
			set(axh(1), 'ygrid', 'on', 'xgrid','on' );
            set(axh,{'ycolor'},{'k';[0 0.5 0]});
            
            [dts, inds] = min(abs(bsxfun(@minus,timeTicks,Lat_time')),[],2);
            xh1_pos = get(xh1,'Position');
            
            if i_local == 1
                GeoLon_txt = text(xh1_pos(1), xh1_pos(2)-0.08,...
                    'Long.:','Parent',axh(1),'HorizontalAlignment','Right','VerticalAlignment','top','FontWeight','bold','Units','normalized');
            end
            set(GeoLon_txt, 'Units','data'); geolon_txt_pos = get(GeoLon_txt,'Position');
            text(timeTicks,(geolon_txt_pos(2))*ones(length(timeTicks),1),num2str(Geolon_signal(inds), '%.2f'),...
                'Parent',axh(1),'HorizontalAlignment','Center','VerticalAlignment','top','Units','data');
			
            % bottom line of MLT values
            if ~isempty(Xsignal)
%                 inds(dts > 60/86400) = NaN;
                MLT = eqn_coordinateTransform(timeTicks,Xsignal(inds,:),'xGEO','MLT');
%                For moofiko MLT:
%                MLT = hour(timeTicks) + minute(timeTicks)/60;
                MLT(dts > 60/86400) = NaN;                
                if ~isempty(MLT)
    %                 set(yh1,'Units','normalized');
    %                 tr2 = get(yh1,'position');
%                     text(timeTicks,(min(y1tick)-4*extra_limit1)*ones(length(timeTicks),1),eqn_dec2hr(MLT),...
%                         'Parent',axh(1),'HorizontalAlignment','Center');
                    
                    if i_local == 1
                        MLT_txt = text(xh1_pos(1), xh1_pos(2)-0.16,...
                            'MLT:','Parent',axh(1),'HorizontalAlignment','Right','VerticalAlignment','top','FontWeight','bold','Units','normalized');
                    end
                    set(MLT_txt, 'Units','data'); mlt_txt_pos = get(MLT_txt,'Position');
                    text(timeTicks,(mlt_txt_pos(2))*ones(length(timeTicks),1),eqn_dec2hr(MLT),...
                        'Parent',axh(1),'HorizontalAlignment','Center','VerticalAlignment','top','Units','data');
                end
            end
            
            
           
            
            %%% plot middle row of axes
            
			axes(h.axes(i_local+1)); 
            bar_label = 'log_2(nT^2/Hz)';
            pow_multi = 1;
            if ~isempty(regexp(Magnetar.label{index_inside_magn,1},'SWARM-[ABC] E', 'once'))
                pow_multi = 1/100;
                bar_label = 'log_2((mV/m)^2/Hz)';
            end
            clims = [-2, 4];
            if 2^min(frequencies) > 100/1000
                clims = [-8, -4]; 
            end
            h_isc = imagesc(time,frequencies,log2(pow_multi*Wsignal), clims); %
%            set(h_isc, 'AlphaData', ~isnan(Wsignal));
            set(h.axes(i_local+1),'ydir','normal', 'xtick', timeTicks, 'ytick', freqTicks, ...
                'xticklabel', [], 'yticklabel', freqTickLabels);
            if i_local == 1; % middle row leftmost axes needs a label
                yh2 = get(h.axes(2),'ylabel');
%                 pos1 = time(1)-label_mutiplier*(time(end)-time(1)); % x-position
%                 pos2 = 25;                              % y-position
                set(yh2,'String','Freq (mHz)','Units','normalized', 'position',[-label_multiplier, 0.5],'FontWeight','bold');
            end
            if i_local+1 == axes_len-1 % the middle row rightmost axes needs a colorbar and appropriate sizing to fit it
                axes_s = get(h.axes(i_local+1),'position'); % get the position of this axes
                ch_loc=colorbar('peer',h.axes(i_local+1),'position',[axes_s(1)+axes_s(3)+0.005,axes_s(2),0.03,axes_s(4)]);
                % set the position of the colorbar and its size (as high as the graph, and 0.03 -normalised units- the gui length)
                chh_loc=get(ch_loc,'ylabel');
                set(chh_loc,'String',bar_label,'rot',90,'VerticalAlignment','Middle','FontWeight','bold');
                set(ch_loc,'YTick',(-20:2:20)); % generic tick locations limits allowing for future increase 
                % (will plot within limits from imagesc )
            end
            set(h.fig,'Visible',vis_flag)
          
			%%% plot top row of axes
            tic
            field_label = 'B (nT)';
            if ~isempty(strfind(Magnetar.label{index_inside_magn,1},'EFI'))
                field_label = 'E (mV/m)';
            end
            axes(h.axes(i_local+2));
            plot(time,Bsignal,'-','Linewidth',2); %grid on;
            xlim([time(1), time(end)]);
%            max_of_sig = max(Bsignal);
%            min_of_sig = min(Bsignal);
            if track_bool
                max_of_sig = track_lims(track_no, 2);
                min_of_sig = track_lims(track_no, 1);
            else
                max_of_sig = B_lims(1,2);
                min_of_sig = B_lims(1,1);
            end
            if isnan(max_of_sig); max_of_sig = 0.8; end
            if isnan(min_of_sig); min_of_sig = -0.8; end
            if (min_of_sig == max_of_sig); min_of_sig = min_of_sig-0.01; max_of_sig = max_of_sig+0.01; end
            range_of_sig = max_of_sig-min_of_sig;
            axis_percent = 0.1*range_of_sig;
            ylim([min_of_sig-axis_percent, max_of_sig+axis_percent]) % set ylim of axes: it will show a little more up and down from the signal (aesthetic reasons)
            set(h.axes(i_local+2), 'xtick',timeTicks, 'xticklabel', []); % empty ticklabels instead of timeTickLabels
			th = title(h.axes(i_local+2), columnLabel,'FontWeight','bold');
            set(th,'Units','normalized');
            tp = get(th,'position');
            tp(2) = tp(2)-0.0155; % lower the position of the title a little bit
            set(th,'position',tp);
            if i_local == 1; % the top row leftmost axes needs a label
                yh = get(h.axes(i_local+2),'ylabel');
                pos1 = time(1)-1.1*label_multiplier*(time(end)-time(1)); % x-position same as above (redundant)
                pos2 = (min_of_sig + (range_of_sig/2));   % y-position
                set(yh,'String',field_label,'position',[pos1,pos2],'FontWeight','bold');
            end
        end
		% Resetting of track_b_ind to take elements from first column to be used in saving figures (single or all tracks)
        if track_bool
            track_b_ind = Magnetar.Bind{1,1}(track_no,:);
        else
            track_b_ind = [1 length(Magnetar.B{1,1}(:,1))];
        end
        set(h.fig,'Visible',vis_flag)
    end
        
end