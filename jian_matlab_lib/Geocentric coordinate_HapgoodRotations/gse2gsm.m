%--------------------------------------------------------------------------
% Name
%   gse2gsm
%
% Purpose
%   Produce a rotation from GSE to GSM.
%
%   Calling Sequence:
%   T3 = gse2gsm(PSI)
%   Calculate the rotation matrix from GSE to GSM using PSI, the
%   angle between the GSEz and the dipole axis.
%
%   T3 = gse2gsm(X, Y, Z)
%   X, Y and Z are the x-, y- and z-components of the UNIT vector
%   describing the dipole axis direction in GSE.
%
%   T3 = gse2gsm(phi, lambda, MJD, UTC)
%   PHI and LAMBDA are the geocentric latitude and longitude of the
%   dipole North geomagnetic pole (GEO spherical coordinates). MJD
%   is the Modified Julian Date measured until 00:00 UTC on the date
%   of interest. UTC is in decimal hours.
%
%   T3 = gse2gsm(g10, g11, h11, MJD, UTC)
%   First order IGRF coefficients, adjusted to the time of interest.
%
% Returns
%   T3:  out, required, type = double
%        Rotation matrix from GSE to GSM.
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
% Last update: 2014-10-14
% MATLAB release(s) MATLAB 7.12 (R2011a), 8.3.0.532 (R2014a)
% Required Products None
%--------------------------------------------------------------------------
function T3 = gse2gsm(arg1, arg2, arg3, arg4, arg5)

	assert (nargin > 0, 'Missing arguments for gse2gsm ().');

	% Compute the projection angle of the dipole axis.
	switch nargin
		case 5
			[~, psi] = dipole_tilt_angle(arg1, arg2, arg3, arg4, arg5);
		case 4
			[~, psi] = dipole_tilt_angle(arg1, arg2, arg3, arg4);
		case 3
			[~, psi] = dipole_tilt_angle(arg1, arg2, arg3);
		case 1
			psi = arg1;
	end

	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	% Form the Transformation Matrix    %
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	%
	% The transformation from GSE to GSM, then is
	%   - T3 = <-psi, X>
	%   - A pure rotation about X by angle -psi
	%

	% <psi, X>
	sinPsi = sin ( -psi );
	cosPsi = cos ( -psi );

	%      | 1   0    0  |
	% T3 = | 0  cos  sin |
	%      | 0 -sin  cos |
	T3        =  zeros(3, 3, length(psi));
	T3(1,1,:) =  1;
	T3(2,2,:) =  cosPsi;
	T3(2,3,:) =  sinPsi;
	T3(3,2,:) = -sinPsi;
	T3(3,3,:) =  cosPsi;
end
