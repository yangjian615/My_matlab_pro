%--------------------------------------------------------------------------
% Name
%   earth_obliquity
%
% Purpose
%   Axial tilt (obliquity) is the angle between an object's rotational axis
%   and its orbital axis; equivalently, the angle between its equatorial
%   plane and orbital plane.
%
% Inputs
%   T0          in, required, type = double
%   Time in Julian centuries calculated from 12:00:00 UTC
%   on 2000-01-01 (known as Epoch 2000) to the previous
%   midnight. It is computed as:
%   T0 = (MJD - 51544.5) / 36525.0
%
% Returns
%   obliquity:  out, required, type = double
%               Obliquity of Earth's ecliptic orbit.
%
% References:
%   See Hapgood Rotations Glossary.txt.
%   - https://www.spenvis.oma.be/help/background/coortran/coortran.html
%   - U.S. Naval Observatory, Almanac for Computers 1990. Nautical
%     Almanac Office, U.S. Naval Observatory, Washington, D.C., 1989.
%
% Last update: 2014-10-14
% MATLAB release(s) MATLAB 7.12 (R2011a), 8.3.0.532 (R2014a)
% Required Products None
%--------------------------------------------------------------------------
function obliquity = earth_obliquity (T0)

	assert (nargin > 0, 'Usage: OBLIQUITY = earth_obliquity(T0)');

	% Compute Obliquity
	obliquity = 23.439 - 0.013 * T0;
end