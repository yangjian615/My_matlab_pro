%--------------------------------------------------------------------------
% Name
%   nJulCenturies
%
% Purpose
%   Given a fractional number of days, compute the number of Julian Centuries.
%
% Calling Sequence:
%   NJC = date2mjd(NDAYS)
%       Compute the number of Julian Centuries in a certain number of days.
%
% Inputs
%   NDAYS: in, required, type = double
%          Fractional number of days (could be from a given epoch,
%          such as Epoch 2000, the Modified Julian Date, etc.).
%
% Returns
%   nJC:   out, required, type = double
%          Number of Julian Centuries.
%
% Examples
%   Number of days from the beginning of J2000 to 2015-08-24T00:00:00.
%     nDays = datenum( [2015 8 24 0 0 0] ) - datenum( [2000 01 01 12 0 0] );
%     nJC   = nJulCenturies(nDays);
%        0.156427104722793
%
%   Number of days from the beginning of J2000 to J2100: 2100-01-01T12:00:00.
%     nDays = datenum( [2100 1 1 12 0 0] ) - datenum( [2000 01 01 12 0 0] );
%     nJC   = nJulCenturies(nDays);
%          1
%
% References:
%   See Hapgood Rotations Glossary.txt.
%   - https://www.spenvis.oma.be/help/background/coortran/coortran.html
%   - Hapgood, M. A. (1992). Space physics coordinate transformations:
%       A user guide. Planetary and Space Science, 40 (5), 711?717.
%       doi:http://dx.doi.org/10.1016/0032-0633 (92)90012-D
%   - Hapgood, M. A. (1997). Corrigendum. Planetary and Space Science,
%       45 (8), 1047 ?. doi:http://dx.doi.org/10.1016/S0032-0633 (97)80261-9
%
% Last update: 2014-10-14
% MATLAB release(s) MATLAB 7.12 (R2011a), 8.3.0.532 (R2014a)
% Required Products None
%--------------------------------------------------------------------------
function nJC = nJulCenturies(nDays)

	assert (nargin > 0, 'Usage: nJC = nJulCenturies(NDAYS)');

	% There are exactly 36525 days in a Julian Century
	nJC = nDays / 36525.0;
end
