%--------------------------------------------------------------------------
% Name
%   sun_ecliptic_longitude
%
% Purpose
%   Determine the ecliptic longitude of the sun
%
%   Note:
%   Strictly speaking, TDT (Terrestrial Dynamical Time) should be used
%   here in place of UTC, but the difference of about a minute gives a
%   difference of about 0.0007° in lambdaSun.
%
%   Calling Sequence:
%   eLon = sun_ecliptic_longitude (T0, UTC)
%   Compute the sun's ecliptic longitude (degrees) given the number
%   of julian centuries (T0) from 12:00 UTC 01-Jan-2000 until
%   00:00 UTC on the day of interest, and Universal Time (UTC) in
%   fractional number of hours.
%
% Inputs
%   T0:   in, required, type = double
%         Time in Julian centuries calculated from 12:00:00 UTC
%         on 1 Jan 2000 (known as Epoch 2000) to the previous
%         midnight. It is computed as:
%         T0 = (MJD - 51544.5) / 36525.0
%
%   UTC:   in, required, type = double
%
% Returns
%   ELON: out, required, type = double
%         Mean anomaly of the sun, in degrees
%
% References:
% See Hapgood Rotations Glossary.txt.
% - https://www.spenvis.oma.be/help/background/coortran/coortran.html
% - Hapgood, M. A. (1992). Space physics coordinate transformations:
%   A user guide. Planetary and Space Science, 40 (5), 711?717.
%   doi:http://dx.doi.org/10.1016/0032-0633 (92)90012-D
% - Hapgood, M. A. (1997). Corrigendum. Planetary and Space Science,
%   45 (8), 1047 ?. doi:http://dx.doi.org/10.1016/S0032-0633 (97)80261-9
%
% MATLAB release(s) MATLAB 7.12 (R2011a), 8.3.0.532 (R2014a)
% Required Products None
%
% History:
%   2014-10-14    Written by Matthew Argall
%   2015-04-07    Vectorized by changing "*" to ".*". - MRA
%   2015-08-24    Fixed typo in calculation of eLon. - MRA
%--------------------------------------------------------------------------
function eLon = sun_ecliptic_longitude (T0, UTC)

	assert (nargin > 1, 'Usage: ELON = sun_ecliptic_longitude(T0, UTC)');
	DEG2RAD = pi / 360.0;

	% Sun's Mean anomaly
	ma = sun_mean_anomaly(T0, UTC);

	% Mean longitude
	mLon = sun_mean_longitude(T0, UTC);

	% Ecliptic Longitude
	%   - Force to the range [0, 360)
	eLon = mod ( ...
	             mLon + ...     % Degrees
	             (1.915 - 0.0048 * T0) .* sind(ma) + ...
	             0.020 * sind(2.0 * ma), ...
	             360.0 );
end
