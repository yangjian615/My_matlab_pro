%--------------------------------------------------------------------------
% Name
%   date2julday
%
% Purpose
%   Convert MATLAB date numbers or date strings to Julian Days.
%
%   Julian Day number of 0 is assigned to the day starting at noon on
%   January 1, 4713 BC, proleptic Julian calendar (November 24, 4714 BC,
%   in the proleptic Gregorian calendar). See Hapgood Rotations Glossary.txt.
%
% Calling Sequence:
%   JULDAY = date2julday (DATENUMBER)
%     Convert MATLAB date number to Julian Days.
%
%   JULDAY = date2julday (DATESTRING)
%     Convert date strings or cell array of date strings to Julian Days. A
%     format of 'yyyy-mm-ddTHH:MM:SS' is assumed.
%
%   JULDAY = date2julday (__, 'ParamName', ParamValue)
%     Any parameter name-value pair given below can be appended to any of
%     the previous calling methods.
%
% Parameters
%   DATE:         in, required, type=datevec or datestring
%   'Format':     in, optional, type=string, default='yyyy-mm-dd HH:MM:SS'
%   'MJD':        in, optional, type=boolean, default=false
%
% Returns
%   JULDAY        out, required, type=double
%
% Examples:
%   Convert a MATLAB date number to julian day.
%     >> date2julday( datenum(2000, 01, 01, 12, 0, 0 ) )   ACCEPTED
%       2451545.0                                          2451545.0
%
%   Convert a MATLAB date number to modified julian day.
%     >> date2julday( datenum( 2000, 01, 01, 12, 0, 0 ), 'MJD', true )
%       51544.5                                            51544.5
%
%   Convert an array of MATLAB date numbers to julian day.
%     >> datvec = repmat( [2014, 10, 08, 14, 13, 0], 2, 1);
%     >> datnum = datenum( datvec );
%     >> julday = date2julday( datnum );
%       2456939.092361                                     2456939.092361
%       2456939.092361
%
%   Convert a cell array of date strings to julian days.
%     >> dateStr = {'2014-10-08 14:13:00', '2014-10-08 14:13:00'};
%     >> julday  = date2julday( dateStr, 'Format', 'yyyy-mm-dd HH:MM:SS')
%       2456939.092361                                     2456939.092361
%       2456939.092361
%
% References:
%   http://en.wikipedia.org/wiki/Julian_day
%   http://www.cs.utsa.edu/~cs1063/projects/Spring2011/Project1/jdn-explanation.html
%   http://articles.adsabs.harvard.edu/full/1983IAPPP..13...16F
%   http://aa.usno.navy.mil/data/docs/JulianDate.php
%
% MATLAB release(s) MATLAB 7.14.0.739 (R2012a)
% Required Products None
%
% History:
%   2014-10-08      Written by Matthew Argall
%   2015-04-07      'Format' has a parameter name associated with it.
%                     Created default value for date strings. - MRA
%--------------------------------------------------------------------------
function julday = date2julday (date, varargin)

  % Defaults
  mjd = false;
  fmt = '';

	% Look through the optional arguments
	nOptArgs = length (varargin);
	for ii = 1 : 2 : nOptArgs
		switch varargin{ii}
			case 'MJD'
				mjd = varargin{ii+1};
			case 'Format'
				fmt = varargin{ii+1};
			otherwise
				error( ['Optional parameter not recognized: "' varargin{ii} '".'] )
		end
	end

	% Default format
	if isempty(fmt) && (ischar(date) || iscell(date))
		fmt = 'yyyy-mm-dd HH:MM:SS';
	end

	% DateNum or Date string? datevec returns doubles
  if isempty(fmt)
    [year, month, day, hour, minute, second] = datevec(date);
  else
    [year, month, day, hour, minute, second] = datevec(date, fmt);
  end

  %
  % Values
  %   1 for January & February
  %   0 for all other months
  a = floor ( (14 - month) / 12 );

  % Offset months so year starts in March
  %   m = 10 -- January
  %   m = 11 -- February
  %   m =  0 -- March
  m = month + (12 * a) - 3;

  % Offset the year so that we begin counting on 1 March -4800 (4801 BC).
  %   - Subtract a year for Jan and Feb
  %   - (The year does not begin until March)
  %
  %   1 AD = 1
  %   1 BC = 0
  %   2 BC = -1
  %   3 BC = -2
  %   etc.
  y = (year + 4800.0) - a;

  % Julian Day Number
  %     1. Number of days in current month
  %     2. Number of days in previous months
  %        Mar-Jul:  31 30 31 30 31
  %        Aug-Dec:  31 30 31 30 31
  %        Jan-Feb:  31 28
  %     3. Number of days in previous years
  %   4-6. Number of leap days since 4800
  %        - Every year that is divisible by 4
  %        - Except years that are divisible by 100 but not by 400.
  %     7. Ensure JND=0 for January 1, 4713 BC.
  JDN = day                                + ...
        floor ( ((m * 153.0) + 2.0) / 5.0) + ...
        y * 365.0                          + ...
        floor (y / 4.0)                    - ...
        floor (y / 100.0)                  + ...
        floor (y / 400.0)                  - ...
        32045.0;

  % Add the fractional part of the day
  %   - Julian Day begins at noon.
  julday = JDN + ((hour - 12.0) / 24.0) + (minute / 1440.0) + (second / 86400.0);

  % Modified Julian Day?
  %   - Days since 17 Nov 1858 00:00 UT
  if mjd
  	julday = julday - 2400000.5;
  end
end

%----------------------------
% Alternative Methods
%----------------------------
%    % See http://articles.adsabs.harvard.edu/full/1983IAPPP..13...16F
%
%    % Valid for all Gregorian Calendar dates
%    JD = 367 * year - ...
%      7 * floor ( (   year + floor ( (month + 9) / 12) ) / 4 ) - ...
%      3 * floor ( ( ( year + floor ( (month - 9) /  7) ) / 100 + 1 ) / 4 ) + ...
%      floor (275 * month / 9)  + ...
%      day + ...
%      1721020;
%
%    % Valid for dates after March 1900
%    JD = 367 * year - ...
%      7 * floor ( ( year + floor ( (month + 9) / 12) ) / 4 ) + ...
%      floor (275 * month / 9) + ...
%      1721014;
%---------------------------