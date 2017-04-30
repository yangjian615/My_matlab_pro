function [ h_secondaxis ] = irf_plot_double_axis(h_firstaxis,variable,tint,varargin)
%irf_plot_double_axis Summary of this function goes here
%   Detailed explanation goes here
%   Input:
%       h_firstaxis:   axis
%       variable: variable
%   option varargin: ylable with two axis 1x2 cell sring

%   Output:
%       h_secondaxis:  axis
     
% % change position of panels
%  Example:
%  h_secondaxis=irf_plot_double_axis(h(3),n_efw,tint,{'N [cm^{-3}]','Ne [cm^{-3}]'});
%
%----writen by Jian Yang at BUAA (2016-06-06)----
set(h_firstaxis,'box','off')
h_secondaxis = axes('Position',get(h_firstaxis,'Position'));
irf_plot(h_secondaxis,variable,'r');
irf_zoom(h_secondaxis,'x',tint); % zoom in figure
irf_timeaxis(h_secondaxis,'nodate');
set(h_secondaxis,'XAxisLocation','top','xtick',[]); % remove 'xtick' if xticks required
set(h_secondaxis,'YAxisLocation','right');
set(h_secondaxis,'Color','none','box','off'); % color of axis
set(h_secondaxis,'XColor','k','YColor','r'); % color of axis lines and numbers
set(h_secondaxis,'GridLineStyle','none');

if ~isempty(varargin),
    switch length(varargin{1})
        case 1  
        ylabel(h_firstaxis,varargin{1}{1},'interpreter','tex');
        case 2
        ylabel(h_firstaxis,varargin{1}{1},'interpreter','tex');
        ylabel(h_secondaxis,varargin{1}{2},'interpreter','tex')
    end
end

end

