%--------------------------------------------------------------------------
% Name
%   gsm2sm
%
% Purpose
%   Produce a rotation from GSM to SM.
%
% Calling Sequence:
%   T4 = gse2gsm (PSI)
%     Returns T4, the rotation matrix from GSE to GSM using PSI, the
%     angle between the GSE Z-axis and the dipole axis.
%
%   T4 = gse2gsm (X, Y, Z)
%     X, Y and Z are the x-, y- and z-components of the unit vector
%     describing the dipole axis direction in GSE.
%
%   T4 = gse2gsm (phi, lambda, MJD, UTC)
%     PHI and LAMBDA are the geocentric latitude and longitude of the
%     dipole North geomagnetic pole (GEO spherical coordinates). MJD
%     is the Modified Julian Date measured until 00:00 UTC on the date
%     of interest. UTC is Universal Time in fractional number of
%     hours.
%
%   T4 = gse2gsm (g10, g11, h11, MJD, UTC)
%       First order IGRF coefficients, adjusted to the time of interest.
%
% Returns
%   T3: out, required, type = double
%   Rotation matrix from GSE to GSM.
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
%   2014-10-14    Written by Matthew Argal;
%   2015-04-07    Vectorized to accept arrays of intputs. - MRA
%--------------------------------------------------------------------------
function T4 = gsm2sm (arg1, arg2, arg3, arg4, arg5)

	assert (nargin > 0, 'Missing arguments for gsm2sm ().');

	% Compute the projection angle of the dipole axis.
	switch nargin
		case 1
			mu = arg1;
		case 3
			mu = dipole_tilt_angle(arg1, arg2, arg3);
		case 4
			mu = dipole_tilt_angle(arg1, arg2, arg3, arg4);
		case 5
			mu = dipole_tilt_angle(arg1, arg2, arg3, arg4, arg5);
	end

	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	% Form the Transformation Matrix    %
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	%
	% The transformation from GSM to SM, then is
	%   - T4 = <-mu, Y>
	%   - A pure rotation about Y by angle -mu
	%

	% <-mu, Y>
	sinMu = sin ( -mu );
	cosMu = cos ( -mu );

	%      |  cos  0  sin |
	% T4 = |   0   1   0  |
	%      | -sin  0  cos |
	T4        =  zeros(3, 3, length(mu));
	T4(1,1,:) =  cosMu;
	T4(3,1,:) = -sinMu;
	T4(2,2,:) =  1;
	T4(1,3,:) =  sinMu;
	T4(3,3,:) =  cosMu;
end
