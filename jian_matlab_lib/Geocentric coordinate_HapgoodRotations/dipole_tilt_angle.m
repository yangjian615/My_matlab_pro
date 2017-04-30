%--------------------------------------------------------------------------
% Name
%   dipole_tilt_angle
%
% Purpose
%   Compute the angle between the dipole axis and the GSEz and GSMz axes.
%
% Calling Sequence:
%   [psiGSE, psiGSM] = dipole_tilt_angle(x, y, z)
%     Returns the dipole tilt angle and psi, the angle twixt GSMz GSEz.
%     (x, y, z) are the x-, y- and z-components of the UNIT vector
%     describing the direction of the north magnetic dipole in GSE.
%
%   [...] = dipole_tilt_angle(lat, lon, MJD, UTC)
%     lat and lon are the (radian) (GEO) geocentric latitude and longitude of the
%     dipole north geomagnetic pole. MJD is the Modified Julian Date.
%     UTC is in decimal hours.
%
%   [...] = dipole_tilt_angle(g10, g11, h11, MJD, UTC)
%     First order IGRF coefficients, adjusted to the time of interest.
%     Distinguished from (x, y, z) by the true flag. MJD is the Modified
%     Julian Date. UTC is in decimal hours.
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
function [psiGSM, psiGSE] = dipole_tilt_angle (arg1, arg2, arg3, arg4, arg5)

	assert(nargin > 2, 'Missing arguments for dipole_tilt_angle().');

	switch nargin
		case 3
			%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
			% Unit Vector of Dipole in GSE %
			%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
			x = arg1;
			y = arg2;
			z = arg3;

		case 4
			%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
			% Geocentric Longitude and Latitude %
			%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
			lat = arg1;
			lon = arg2;
			MJD = arg3;
			UTC = arg4;

		case 5
			%%%%%%%%%%%%%%%%%%%%%%%%%%%
			% IGRF Coefficients Given %
			%%%%%%%%%%%%%%%%%%%%%%%%%%%
			g10 = arg1;
			g11 = arg2;
			h11 = arg3;
			MJD = arg4;
			UTC = arg5;

			% Compute the geocentric longitude and lattitude of the dipole.
			[lat, lon] = dipole_axis(g10, g11, h11);
	end % switch

	% Geocentric Longitude and Latitude, continued
	if nargin >= 4
		% Unit vector of the dipole axis in GEO
		Qg      = zeros(3, length(lat));
		Qg(1,:) = cos(lat) .* cos(lon);
		Qg(2,:) = cos(lat) .* sin(lon);
		Qg(3,:) = sin(lat);

		% Rotations to bring GEO to GSE
		T1      = gei2geo(MJD, UTC);
		T2      = gei2gse(MJD, UTC);
		geo2gse = mrmultiply_matrices(T2, permute(T1, [2,1,3]));

		% Rotate the dipole axis to GSE
		Qe = mrvector_rotate( geo2gse, Qg );
		x  = Qe(1,:);
		y  = Qe(2,:);
		z  = Qe(3,:);
	end

	% Compute the angles
	%   - handle matrices
	%   - quadrant-safe because Lat & Lon are constrained
	psiGSM = atan( x ./ sqrt (y.^2 + z.^2) );
	psiGSE = atan( y ./ z);
end

% Test cases and results
% (x, y, z)
% [0.05, 0.05, 0.95] ./ norm ([0.05, 0.05, 0.95], 2) = [ 0.052486 0.052486 0.99724 ]
% dipole_tilt_angle (0.052486, 0.052486, 0.99724) = 0.05251

% (lat, lon, MJD, UTC), MJD (2014-10-14) = 56944
% WMM2010 coefficients for 2010.0 the geomagnetic north pole: 80.08°N latitude, 72.21°W longitude (287.79)
% dipole_tilt_angle (lat, lon, MJD, UTC) => dipole_tilt_angle (80.08, 287.79, 56944, 0.0) = 0.029236


%
%        DGRF   DGRF   DGRF   DGRF   DGRF   DGRF   DGRF   DGRF   DGRF   DGRF   DGRF     DGRF
%        1945.0 1950.0 1955.0 1960.0 1965.0 1970.0 1975.0 1980.0 1985.0 1990.0 1995.0   2000.0
% g10 = [-30594 -30554 -30500 -30421 -30334 -30220 -30100 -29992 -29873 -29775 -29692 -29619.4];
% g11 = [ -2285  -2250  -2215  -2169  -2119  -2068  -2013  -1956  -1905  -1848  -1784  -1728.2];
% h11 = [  5810   5815   5820   5791   5776   5737   5675   5604   5500   5406   5306   5186.1];
%
% lat = [ 78.47   78.47   78.46   78.51   78.53   78.59   78.69   78.81   78.97   79.14   79.32   79.54];
% lon = [291.47  291.15  290.83  290.53  290.15  289.82  289.53  289.24  289.10  288.87  288.58  288.43];
% lat = lat * pi/180;
% lon = lon * pi/180;
% mjd = date2mjd(1945:5:2000, 1, 1);
% utc = zeros(size(mjd));
%
% [zGSM_ll, zGSE_ll] = dipole_tilt_angle(lat, lon, mjd, utc)
% [zGSM_gh, zGSE_gh] = dipole_tilt_angle(g10, g11, h11, mjd, utc)
%









