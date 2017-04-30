function [varargout] = figmenu(f)
%Jian.FIGMENU Helpful menu items.
%
%   Jian.FIGMENU(f) Creates an option "Jian" in the irf figure menu.
%
%   mh = Jian.FIGMENU Also returns handle to the uimenu.

%% Get the IRF menu handle
if(nargin == 0)
    f = gcf;
end

irf.log('w',['Creating dropdown menu for figure ',num2str(f.Number)])

% Initiate IRF figmenu
irf_figmenu

% Get the menu handle
mirf = findall(f.Children,'Type','uimenu','Label','&irf');

%% Create menu items
mh = uimenu(mirf,'Label','&Jian');
mh.Separator = 'on';
menuLabels = {'Print as...','Fix axes position','Restore x-axis'};

nl = length(menuLabels);
m2h = gobjects(1,nl);

for i = 1:nl
    m2h(i) = uimenu(mh,'Label',menuLabels{i});
end


%% Create individual submenus and irf commands

% 1 - printing
ftype = {'eps','pdf','png'};

m13h = gobjects(1,3);
for i = 1:3
    m13h(i) = uimenu(m2h(1),'Label',ftype{i});
end
% Callbacks
m13h(1).Callback = 'Jian.print_fig(Jian.ask(''Name of file:'',''fig''),''eps'')';
m13h(2).Callback = 'Jian.print_fig(Jian.ask(''Name of file:'',''fig''),''pdf'')';
m13h(3).Callback = 'Jian.print_fig(Jian.ask(''Name of file:'',''fig''),''png'')';

if(nargout==1)
    varargout{1} = mh;
end


% 2 - fix x-label
m2h(2).Callback = 'Jian.fix_x_label';


% 3 - remove time axis
cmd3 = ['tempFIG=gcf;',...
    'tempAXar = findall(tempFIG.Children,''Type'',''Axes'');',...
    'tempAX = tempAXar(1);',...
    'tempAX.XLabel.String = tempAX.UserData.XLabel.String;',...
    'tempAX.XTickLabelMode = ''auto'';',...
    'tempAX.XTickMode = ''auto'';',...
    'clear tempAX tempAXar tempFIG'];
m2h(3).Callback = cmd3;



end


