
function t = date2doy(y,m,d)
%date2doy Summary of this function goes here
%
%   Detailed explanation goes here
% translate the data to days of the years
%   Input:
%        y year
%        d day
%        m month
%   Output:
%        doy 一年中的那一天可判断闰年
%Example:
% % doy= date2doy(2015,12,31)

%----writen by Jian Yang at BUAA (2016-11-06)----

% judge whether the year is a leap year or not
if ((rem(y,400) == 0) || (rem(y,100) ~= 0 && rem(y,4) == 0)) && (m>2)
	a = 1;
else
	a = 0;
	end

% sum the day before the month
month_day = [0 31 59 90 120 151 181 212 243 273 304 334];
b = month_day(m);

t = a+b+d;