function [message,Full_date] = Time_range_check(Full_date)

point_vec = cell(1,4);
    
   

% fix the hour
Full_date{4,1} = hour_fix(Full_date{4,1});
Full_date{4,2} = hour_fix(Full_date{4,2});

% scan the hour into appropriate format
hour_start = sscanf(Full_date{4,1},'%2d:%2d:%2d'); %convert the strings into {3,1} cells (hour;min;sec)
hour_end = sscanf(Full_date{4,2},'%2d:%2d:%2d');




if (hour_start(1)> 23)||(hour_start(2)> 59)||(hour_start(3)> 59)||...
        (hour_end(1)> 23)||(hour_end(2)> 59)||(hour_end(3)> 59)
    pointer = -1000; % if not ok (hour is not in 24hour format) assign the point special value -1000
else % if hour format is ok  move on to flag calculation
   for i=1:3
       r = str2num(Full_date{i,2})-str2num(Full_date{i,1}); % check each time field
%        disp('r is:');
%        disp(r);
       if r<0 % if start is greater than end return 00
           point_vec{i}='00';
       elseif r>0 % if end is greater than start return 11
           point_vec{i}='11';
       elseif r==0 % if end and start equal return 10
           point_vec{i}='10';
       end
   end
   
   hour_start = datenum(Full_date{4,1},'HH:MM:SS'); % convert into matlab time for calculations
   hour_end = datenum(Full_date{4,2 },'HH:MM:SS');
   if hour_start > hour_end % calculate the last part of the point_vec, the hours
       point_vec{4} = '00';
   elseif hour_start < hour_end
       point_vec{4} = '11';
   elseif hour_start == hour_end
        point_vec{4} = '10';
   end
   pointer = [point_vec{:}]; % make string from vector
   pointer = bin2dec(pointer); % convert to decimal
end

% if pointer < 0
%     message = 'check format of hours';
if pointer <= 63
%     message = 'check range of years';
    message = '';
elseif pointer <= 143
    message = 'Month';
elseif pointer <= 163
    message = 'Day';
elseif pointer <= 168
    message = 'Hour';
elseif pointer <=255
    message = '';
else 
    message = 'unknown error';
end
end