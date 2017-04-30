function test_find_str_in_vargin (arg1, arg2)
  % Test with testFindStrInVargin ('date placeholder', 'MJD', true)
  disp ('test_find_str_in_vargin');
  disp ('arg list');
  nArgIn = nargin
%   args (0: nArgIn)
  print (Unquoted, "number of arguments" = args (0)):
  print (Unquoted, "sequence of all arguments" = args ()):
  if args (0) > 0 then
    print (Unquoted, "first argument" = args (1)):
  end
  if args (0) >= 3 then
    print (Unquoted, "second, third argument" = args(2..3)):
  end_if

%   mjd0 = strcmp (varargin (nargin-1), 'MJD')
%   if mjd0
% 	  disp ('MJD is true.');
%   end
%   if nargin == 3
% 	  iMJD1 = find (strcmp (varargin, 'MJD') == 1)
% 	  if ~isempty (iMJD1)
% 	    mjd1 = logical (varargin {iMJD1 + 1})
% 	  end
% 	end

%   mjd0 = strcmp (varargin (nargin-1), 'MJD') % used with test_find_str_in_vargin (Date, vargin)
%   if mjd0
% 	  disp ('MJD is true.');
%   end
%   if nargin == 3
% 	  iMJD1 = find (strcmp (varargin, 'MJD') == 1)
% 	  if ~isempty (iMJD1)
% 	    mjd1 = logical (varargin {iMJD1 + 1})
% 	  end
% 	end

end

% date2julday (DateNumber)
% date2julday (DateString)
% date2julday (Date, format)
% date2julday (__, 'MJD', {true | false})

% '2014-10-08T14:13:00', 'yyyy-mm-ddTHH:MM:SS')
% [year, month, day, hour, minute, second] = datevec ('2014-10-08T14:13:00', '') FAILS, see datevec
% [year, month, day, hour, minute, second] = datevec ('2014-10-08T14:13:00', 'yyyy-mm-ddTHH:MM:SS')

% testFindStrInVargin ('2014-10-08T14:13:00'

% testFindStrInVargin (__, 'MJD', {true | false})
% testFindStrInVargin ('date placeholder', 'MJD', true)

% Test setup for date2julday ()
% DateNum = datenum (clock)
% DateString = datestr (DateNum)
% date2julday (DateNum)
% date2julday (DateString)
% date2julday (DateString, 'dd-mmm-yyyy HH:MM:SS') % Ex: 24-Oct-2014 09:35:46, specific for /this/ MATLAB installation
% % datevec (DateString, 'dd-mmm-yyyy HH:MM:SS')

