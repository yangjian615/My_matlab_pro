function [pos_panel] = caculate_multiplot_position(plot_row,plot_col,plot_number,pos_init,space_subplot,plot_sort,varargin)
%caculate_multiplot_position Summary of this function goes here
%   Detailed explanation goes here
%
%   Input:
%       plot_row: row
%       plot_col: col
%       plot_number: total number
%       pos_init:vector [xstar ystar xwidth ywidth] 1x4 double each panel size and star
%       space_subplot:[space_subplot_x space_subplot_y] 1x2 double panel gap
%       plot_sort：plot  0 or 1 先画完一列还是一行%  默认0 画一列
%   Output:
%       pos_panel: postion plot_numberx4 double
%    default：2x2 PANEL
%     plot_number=4;
%     plot_row=2;
%     plot_col=2;
%     xstar=0.08;
%     ystar=0.99;
%     xwidth = 0.4;
%     ywidth = 0.4;
%     space_subplot_x=0.03;
%     space_subplot_y=0.03;
%     plot_sort=0
%     'test' 0 or 1

% % change position of panels
%  Example:
%pos_panel= caculate_multiplot_position(plot_row,plot_col,plot_number,pos_init,space_subplot,plot_sort)
%
%----writen by Jian Yang at BUAA (2016-05-28)----
if nargin<1,
    plot_number=4;
    plot_row=2;
    plot_col=2;
    xstar=0.08;
    ystar=0.99;
    xwidth = 0.4;
    ywidth = 0.4;
    space_subplot_x=0.03;
    space_subplot_y=0.03;
    plot_sort=0;    % 默认按列画即画一行 共plot_col个panel
else
    xstar=pos_init(1);
    ystar=pos_init(2);
    xwidth = pos_init(3);
    ywidth = pos_init(4);
    space_subplot_x=space_subplot(1);
    space_subplot_y=space_subplot(2);
end

pos_panel=zeros(plot_number,4);

for i=1:1:plot_row
    for j=1:1:plot_col,
        pos_panel(i+(j-1)*plot_row,:)=[xstar+(j-1)*(xwidth+space_subplot_x) ystar-i*ywidth-i*space_subplot_y xwidth ywidth];
        
        %     set(h(i+(j-1)*plot_row),'position',pos_panel(i+(j-1)*plot_row,:));
        % irf_legend(h(i),plot_panel_mark(i),[0.99,0.98])
    end
end

index_sort_row=0;
if plot_sort,
    for i=1:1:plot_row,
        index_sort_row_temp=i:plot_row:plot_number;
        index_sort_row=[index_sort_row index_sort_row_temp];
    end
    
    index_sort_row=index_sort_row(index_sort_row>0);
    pos_pane_row=pos_panel(index_sort_row,:);
    pos_panel=pos_pane_row;
end


if nargin>6,
    if ~isempty(varargin),
        if varargin{1}=='test',
            if varargin{2}==1,
                [h1,h] = initialize_combined_plot(2,plot_row,plot_col,0.0,'vertical');
                for i=1:1:length(h)
                    
                    set(h(i),'position',pos_panel(i,:));
                    % irf_legend(h(i),plot_panel_mark(i),[0.99,0.98])
                    
                end
            end
        end
    end
else
    [h1,h] = initialize_combined_plot(2,plot_row,plot_col,0.0,'vertical');
    for i=1:1:length(h)
        
        set(h(i),'position',pos_panel(i,:));
    end
    
end

