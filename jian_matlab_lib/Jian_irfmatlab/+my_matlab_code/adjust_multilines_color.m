function [h]=adjust_multilines_color(h,mycolor)

%adjust_multilines_color Summary of this function goes here
%   Detailed explanation goes here
%   for use initialize_combined_plot
%   Input:
%      h;图形句柄
%   mycolor;数组或者 字符串:'mms' or 'cluster'
%    cluster_colors=[[0 0 0];[1 0 0];[0 0.5 0];[0 0 1];[1 0 1];[1 1 0];[0 1 1]];
%    mms_colors=[[0 0 0];[213,94,0];[0,158,115];[86,180,233]]/255;
%   Output:
%
%
%  Example:
%   [h]=adjust_multilines_color(h,mycolor)
%
%----writen by Jian Yang at BUAA (2016-05-28)----
if nargin==0,
    display('just for testing change color');
    [h1,h2] = initialize_combined_plot(2,2,1,0.6,'horizontal');
    
    t=irf_time([2008 03 01 10 0 0]):.2:irf_time([2008 03 01 11 0 0]);
    t=t(:);									% make time column vector
    y=exp(0.001*(t-t(1))).*sin(2*pi*t/180);	% create y(t)=exp(0.001(t-to))*sin(t)
    z=exp(0.001*(t-t(1))).*cos(2*pi*t/180);	% z(t)=exp(0.001(t-to))*cos(t)
    x=0.5*y;
    B=[t x y z];
    irf_plot(h1(1),B);
    irf_plot(h2(1),B);
    
    cluster_colors=[[0 0 0];[1 0 0];[0 0.5 0];[0 0 1];[1 0 1];[1 1 0];[0 1 1]];
    if length(h1)>1,
        for i=1:length(h1),
            if length(h1(i).Children)>1,
                for j=1:length(h1(i).Children),
                    set(h1(i).Children(j),'color',cluster_colors(j,:))
                end
            end
        end
    end
    irf_legend(h1(1),{'X','Y','Z'},[0.2,0.1],'color','cluster');
    
else
    
    if isnumeric(mycolor),
    else
        if ischar(mycolor) && strcmp(strupcase(mycolor),'CLUSTER'),
            
            cluster_colors=[[0 0 0];[1 0 0];[0 0.5 0];[0 0 1];[1 0 1];[1 1 0];[0 1 1]];
            mycolor=cluster_colors;
            
        else ischar(mycolor) && strcmp(strupcase(mycolor),'MMS')
            mms_colors=[[0 0 0];[213,94,0];[0,158,115];[86,180,233]]/255;
            mycolor=mms_colors;
        end
    end
    
    if length(h)>=1,
        for i=1:length(h),
            if length(h(i).Children)>1,
                for j=1:length(h(i).Children),
                    set(h(i).Children(j),'color',mycolor(j,:))
                end
            end
        end
    end
    
end
end

