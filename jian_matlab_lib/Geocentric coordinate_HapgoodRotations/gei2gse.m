%--------------------------------------------------------------------------
% Name
%   gei2gse
%
% Purpose
%   Produce a rotation matrix from GEI to GSE.
%
% Inputs
%   MJD:   in, required, type = double
%          Modified Julian Date.
%   UTC:   in, required, type = double
%          UTC in decimal hours since midnight.
%
% Returns
%   T3:    out, required, type = double
%          Totation matrix from GEI to GSE.
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
% MATLAB release(s) MATLAB 7.12 (R2011a), 8.3.0.532 (R2014a)
% Required Products None
%
% Histroy:
%   2014-10-14    Written by Matthew Argall
%   2015-04-07    Vectorized to accept arrays. - MRA
%--------------------------------------------------------------------------
function T2 = gei2gse(mjd, UTC)

	assert (nargin > 1, 'Usage: T2 = gei2gse(mjd, UTC).');

	% Conversion to radians
	deg2rad = pi / 180.0;

	% Number of points given
	nPts = length(mjd);

	% Number of julian centuries since Epoch 2000
	T0 = nJulCenturies( mjd2epoch2000( fix(mjd)) );

	% Axial tilt
	obliq = earth_obliquity(T0)             .* deg2rad;
	eLon  = sun_ecliptic_longitude(T0, UTC) .* deg2rad;

	%
	% The transformation from GEI to GSE, then is
	%   - T2 = <eLon, Z> <obliq, X>
	%   - A pure rotation about X by angle obliq
	%   - A pure rotation about Z by angle eLon
	%

	% <obliq, X>
	sinObliq = sin( obliq );
	cosObliq = cos( obliq );

	%       | 1   0    0  |
	% T21 = | 0  cos  sin |
	%       | 0 -sin  cos |
	T21        =  zeros(3, 3, nPts);
	T21(1,1,:) =  1;
	T21(2,2,:) =  cosObliq;
	T21(2,3,:) =  sinObliq;
	T21(3,2,:) = -sinObliq;
	T21(3,3,:) =  cosObliq;

	% <eLon, X>
	sinLon = sin( eLon );
	cosLon = cos( eLon );

	%       |  cos  sin  0 |
	% T22 = | -sin  cos  0 |
	%       |   0    0   1 |
	T22        =  zeros(3, 3, nPts);
	T22(1,1,:) =  cosLon;
	T22(1,2,:) =  sinLon;
	T22(2,1,:) = -sinLon;
	T22(2,2,:) =  cosLon;
	T22(3,3,:) =  1;

	% Rotation from GEI to GSE
	%   - T22 * T21
	T2 = mrmultiply_matrices(T22, T21);
end
