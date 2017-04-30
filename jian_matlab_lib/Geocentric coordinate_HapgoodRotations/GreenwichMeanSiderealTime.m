%--------------------------------------------------------------------------
% Name
%   GreenwichMeanSiderealTime
%
% Purpose
%   Compute the Greenwich Mean Sidereal Time -- the angle between the
%   Greenwich meridean and the First Point of Airies, in the plane of the
%   geographic equator.
%
% Inputs
%   Epoch2000: in, required, type = double
%              Integer number of Julian centuries from 12:00 UTC on
%              1 January 2000 (i.e. Epoch 2000), i.e., the Julian
%              Century at 00:00 UTC on the day of interest.
%   UTC:       in, required, type = double
%              UTC, in decimal hours.
%
% Returns
%   theta:     out, required, type = double
%              Greenwich Mean Sidereal Time in degrees.
%
% References:
%   See Hapgood Rotations Glossary.txt.
%   - https://www.spenvis.oma.be/help/background/coortran/coortran.html
%   - Hapgood, M. A. (1992). Space physics coordinate transformations:
%     A user guide. Planetary and Space Science, 40 (5), 711?717.
%     doi:http://dx.doi.org/10.1016/0032-0633 (92)90012-D
%   - Hapgood, M. A. (1997). Corrigendum. Planetary and Space Science,
%     45 (8), 1047 ?. doi:http://dx.doi.org/10.1016/S0032-0633 (97)80261-9
%
% MATLAB release(s) MATLAB 7.12 (R2011a), 8.3.0.532 (R2014a)
% Required Products None
%
% History
%   2014-10-14      Written by Matthew Argall
%   2015-08-24      Output in degrees. Force between [0,360). - MRA
%
%--------------------------------------------------------------------------
function theta = GreenwichMeanSiderealTime (Epoch2000, UTC)

	assert (nargin > 1, 'Missing arguments for GreenwichMeanSiderealTime ().');

	% Compute the Greenwich Mean Sidereal Time
	% Hapgood units: degrees + deg/century * centuries + deg/hr * hr
	theta = mod(100.461 + 36000.770 * Epoch2000 + 15.04107 * UTC, 360);
end
