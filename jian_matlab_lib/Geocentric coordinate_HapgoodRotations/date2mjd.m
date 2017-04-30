%--------------------------------------------------------------------------
% Name
%   date2mjd
%
% Purpose
%   Convert a date to Modified Julian Date -- the number WHOLE of days since
%   1858-11-17T00:00:00Z. -- or a serial date number representing the whole and fractional number of days
%
% Calling Sequence:
%   mjd = date2mjd (year, month, day)
%   Calculate the Modified Julian Date from the numeric year, month and day.
%
%   mjd = date2mjd (date)
%   Calulate the Modified Julian Date from a date string, Nx10
%   character array, or 1xN element cell array of strings, where N
%   represents the number of dates formatted as 'yyyy-mm-dd'.
%
% Inputs
%   year:   required, type = double
%   month:  required, type = double
%   day:    required, type = double
%
% Returns
%   MJD:    required, type = double
%
% References:
% - https://www.spenvis.oma.be/help/background/coortran/coortran.html
% - Hapgood, M. A. (1992). Space physics coordinate transformations:
%   A user guide. Planetary and Space Science, 40 (5), 711?717.
%   doi:http://dx.doi.org/10.1016/0032-0633 (92)90012-D
% - Hapgood, M. A. (1997). Corrigendum. Planetary and Space Science,
%   45 (8), 1047 ?. doi:http://dx.doi.org/10.1016/S0032-0633 (97)80261-9
%
% Last update: 2014-10-14
% MATLAB release(s) MATLAB 7.12 (R2011a), 8.3.0.532 (R2014a)
% Required Products None
%--------------------------------------------------------------------------
function mjd = date2mjd(year, month, day)

	assert(nargin > 0, 'Missing arguments for date2mjd().');

	% If only 1 argument passed, expect it to be an ISO date yyyy-mm-dd of some sort.
	if nargin == 1
		% Date string
		if ischar(year)
			date_vector = year;
			mjd         = datenum(date_vector, 'yyyy-mm-dd') - 678942.0;
		% Date number
		else
			date_number = year;
			mjd         = date_number - 678942.0;
		end
	else
		% Adjust date using MATLAB datenum base, January 0, 0000
		% datenum (1858, 11, 17) = 678942.0
		mjd = datenum(year, month, day) - 678942.0;
	end
end

% Related code snippits
% [year, month, day, hour, minute, second] = datevec(MJD + 678942.0)

% Test cases and results (To use this table, add the day-of-month to the tabulated entry. Ex: (2009, 01, 01) = 54832).
%         2000  2001  2002  2003  2004  2005  2006  2007  2008  2009
%  Jan   51543 51909 52274 52639 53004 53370 53735 54100 54465 54831
%  Feb   51574 51940 52305 52670 53035 53401 53766 54131 54496 54862
%  Mar   51603 51968 52333 52698 53064 53429 53794 54159 54525 54890
%  Apr   51634 51999 52364 52729 53095 53460 53825 54190 54556 54921
%  May   51664 52029 52394 52759 53125 53490 53855 54220 54586 54951
%  Jun   51695 52060 52425 52790 53156 53521 53886 54251 54617 54982
%  Jul   51725 52090 52455 52820 53186 53551 53916 54281 54647 55012
%  Aug   51756 52121 52486 52851 53217 53582 53947 54312 54678 55043
%  Sep   51787 52152 52517 52882 53248 53613 53978 54343 54709 55074
%  Oct   51817 52182 52547 52912 53278 53643 54008 54373 54739 55104
%  Nov   51848 52213 52578 52943 53309 53674 54039 54404 54770 55135
%  Dec   51878 52243 52608 52973 53339 53704 54069 54434 54800 55165
