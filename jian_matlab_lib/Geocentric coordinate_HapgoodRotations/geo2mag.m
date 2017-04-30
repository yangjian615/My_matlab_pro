%--------------------------------------------------------------------------
% Name
%   geo2mag
%
% Purpose
%   Produce a transformation from GEO to MAG. It involves two rotations:
%   one in the plane of the Earth's equator from the Greenwich meridian to
%   the meridian containing the dipole pole, and another rotation in that
%   meridian from the geogralatc pole to the dipole pole.
%
%   Calling Sequence:
%   T5 = gse2gsm (lat, lon)
%     lat and lon are the geocentric latitude and longitude of the
%     dipole North geomagnetic pole (GEO spherical coordinates).
%
%   T5 = gse2gsm(g10, g11, h11, MJD, UTC)
%     First order IGRF coefficients, adjusted to the time of interest.
%
% Returns
%   T5: out, required, type = double
%     Transformation matrix from GEO to MAG.
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
%                 Vectorized to accept array inputs. - MRA
%--------------------------------------------------------------------------
function T5 = geo2mag(arg1, arg2, arg3)

	assert (nargin > 1, 'Missing arguments for geo2mag().');

	% Dipole axis.
	switch nargin
		case 2
			lat = arg1;
			lon = arg2;
		case 3
			g10 = arg1;
			g11 = arg2;
			h11 = arg3;
			[lat, lon] = dipole_axis(g10, g11, h11);
		% end case
	end % switch


	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	% Form the Transformation Matrix    %
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	%
	% The transformation from GSM to SM, then is
	%   - T5 = <lat - 90, Y> <lon, Z>
	%   - A pure rotation about Z by angle lon
	%   - A pure rotation about Y by angle (lat - 90)

	% <lon, Z>
	sinLon = sin(lon);  %sind?
	cosLon = cos(lon);

	%      |  cos  sin  0 |
	% T1 = | -sin  cos  0 |
	%      |   0    0   1 |
	T51        =  zeros(3, 3, length(lon));
	T51(1,1,:) =  cosLon;
	T51(1,2,:) =  sinLon;
	T51(2,1,:) = -sinLon;
	T51(2,2,:) =  cosLon;
	T51(3,3,:) =  1;

	% < (lat - 90, Y>
	sinLat = sin ( lat - pi/2 );
	cosLat = cos ( lat - pi/2 );

	%      |  cos  0  sin |
	% T4 = |   0   1   0  |
	%      | -sin  0  cos |
	T52        =  zeros(3, 3, length(lat));
	T52(1,1,:) =  cosLat;
	T52(1,3,:) =  sinLat;
	T52(2,2,:) =  1;
	T52(3,1,:) = -sinLat;
	T52(3,3,:) =  cosLat;

	% Create the transformation
	T5 = mrmultiply_matrices(T52, T51);
end
