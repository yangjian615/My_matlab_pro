function celldate = getnowdate()
% getcurrentdate returns a 3x1 cell with three strings (day string, month
% string and  year) string for each element of the current date.

    % htex = text_inGUI_positioner accepts the handles of its parent axes 
    % x,y coordinates in normalized units pertaining to the parent figure -not the axes-
    % a string to draw and any options text has.
    celldate = cell(3,1);
    dateformat = 'dd/mm/yyyy';
    loc_date_str = datestr(now,dateformat);
    slash_ind = strfind(loc_date_str,'/');
    celldate{1} = loc_date_str(1:slash_ind(1)-1);
    celldate{2} = loc_date_str(slash_ind(1)+1:slash_ind(2)-1);
    celldate{3} = loc_date_str(slash_ind(2)+1:end);
end