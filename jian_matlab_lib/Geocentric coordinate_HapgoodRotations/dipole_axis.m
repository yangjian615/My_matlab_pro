%--------------------------------------------------------------------------
% Name
%   dipole_axis
%
% Purpose
%   Calculate the position of the dipole in spherical GEO coordinates.
%
% Calling Sequence:
%   [lat, lon] = dipole_axis (g10, g11, h11)
%       Inputs G01, G11, and H11 are the first order IGRF coefficients,
%       adjusted to the time of interest. Angles are returned in
%       radians.
%       lat and lon are the (GEO) geocentric (radians) latitude and longitude
%       of the dipole north geomagnetic pole. MJD is the Modified Julian Date.
%       UTC is in decimal hours.
%
% See Also:
%   dipole_tilt_angle.m
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
function [lat, lon] = dipole_axis(g10, g11, h11)

	assert (nargin == 3, 'Missing arguments for dipole_axis ().'); % nargin > 2 ?

	% Compute the geocentric longitude and lattitude of the dipole.
	lon = atan(h11 ./ g11);
	lat = pi / 2.0 - atan( (g11 .* cos(lon) + h11 .* sin(lon)) ./ g10 );
end

%
% Test values from "The Centered Dipole Model"
%   https://www.spenvis.oma.be/help/background/magfield/cd.html
%
%  MODEL     LAT       LON
% DGRF 1945	78.47	291.47
% DGRF 1950	78.47	291.15
% DGRF 1955	78.46	290.84
% DGRF 1960	78.51	290.53
% DGRF 1965	78.53	290.15
% DGRF 1970	78.59	289.82
% DGRF 1975	78.69	289.53
% DGRF 1980	78.81	289.24
% DGRF 1985	78.97	289.10
% DGRF 1990	79.13	288.89
% IGRF 1995	79.30	288.59
% IGRF 2000	79.54	288.43
% 

%
%        DGRF   DGRF   DGRF   DGRF   DGRF   DGRF   DGRF   DGRF   DGRF   DGRF   DGRF     DGRF
%        1945.0 1950.0 1955.0 1960.0 1965.0 1970.0 1975.0 1980.0 1985.0 1990.0 1995.0   2000.0
% g10 = [-30594 -30554 -30500 -30421 -30334 -30220 -30100 -29992 -29873 -29775 -29692 -29619.4];
% g11 = [ -2285  -2250  -2215  -2169  -2119  -2068  -2013  -1956  -1905  -1848  -1784  -1728.2];
% h11 = [  5810   5815   5820   5791   5776   5737   5675   5604   5500   5406   5306   5186.1];
%
% [lat, lon] = dipole_axis(g10, g11, h11)
% lat = lat * 180/pi;
% lon = lon * 180/pi + 360;
%
% lat = [ 78.47   78.47   78.46   78.51   78.53   78.59   78.69   78.81   78.97   79.14   79.32   79.54]
% lon = [291.47  291.15  290.83  290.53  290.15  289.82  289.53  289.24  289.10  288.87  288.58  288.43]
%




