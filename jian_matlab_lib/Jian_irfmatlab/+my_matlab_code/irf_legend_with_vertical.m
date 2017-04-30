function [ h_out ] = irf_legend_with_vertical(h,space_legend,varargin)
%irf_legend_with_vertical Summary of this function goes here
%
%   Detailed explanation goes here
%legend in vertical or horizontal
%   Input:
%        h:get from h=irf_legend(AX,..)
%        space_legend: shift between different color legend
%         default 0.05
%   Output:
%        h_out: adjust h  in vertical or horizontal
%
%Example:
% % h_legend=irf_legend(h(1),cell_str,[0.02, 0.9]);
%   [ h_out ] = irf_legend_with_vertical(h_legend,0.08); %vertical
%   [ h_out ] = irf_legend_with_vertical(h_legend,0.08,'horizontal');
%
%----writen by Jian Yang at BUAA (2016-06-03)----

if nargin<1,
   error('Need input H : get from h=irf_legend(AX,..)')
   return
end   
if nargin<2 & isempty(varargin),
   space_legend=0.04; 
   
end   
position_legend=get(h(1),'Position');
x=position_legend(1);
y=position_legend(2);
z=position_legend(3);

for i=1:1:length(h),
    if ~isempty(varargin),
        if varargin{1}=='horizontal',
            set(h(i),'Position',[x+(i-1)*space_legend,y,z]);
        end
    else
        set(h(i),'Position',[x,y-(i-1)*space_legend,z]);
        
    end
end
h_out=h;


end

