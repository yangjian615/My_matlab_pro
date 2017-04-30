function htex = text_inGUI(axes_handles,text_xpos_in_gui,text_ypos_in_gui,text_string,varargin)
%text_inGUI places a text object anywhere on a figure (GUI)
%independently of its parent axes with its location given in normalized units relative to the GUI
%or figure as if it were a uicontrol object. It still needs however a parent axes to exist.
%It returns a handle to the text object.

    % htex = text_inGUI_positioner accepts the handles of its parent axes 
    % x,y coordinates in normalized units pertaining to the parent figure -not the axes-
    % a string to draw and any options text has.
    
    set(axes_handles,'Units','normalized');
    axes_Position = get(axes_handles,'Position');
 
    xpos = (text_xpos_in_gui - axes_Position(1))/axes_Position(3);    
    ypos = (text_ypos_in_gui - axes_Position(2))/axes_Position(4);
    
    htex = text(xpos,ypos,text_string,'Units','normalized',varargin{:});
end
