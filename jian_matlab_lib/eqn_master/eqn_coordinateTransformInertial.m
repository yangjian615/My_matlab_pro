function out = eqn_coordinateTransformInertial(t, in, input_format, output_format)
%eqn_coordinateTransform Transform coordinates to/from many geophysical
%systems.
%
%   out = eqn_coordinateTransform(t, in, input_format, output_format)
%   converts coordinates in the 3-column matrix 'in', which are in system
%   specified by 'input_format', to their corresponding coordinates in the
%   system specified by 'output_format'. The time stamps for each entry are
%   given in 't'. Supported formats are:
%
%   xGEO: cartesian Geographic [x, y, z] in Re
%   rGEO: geodetic [Lat, Long, R]. Lat and Lon are given in degrees, R is
%         radial distance from the center of the coordinate system in Re.
%   xSM:  cartesian Solar Magnetic [x, y, z] in Re
%   rSM:  geodetic Solar Magnetic [Lat, Long, R]. Lat and Long in
%         degrees, R is radial distance from the center of the coordinate 
%         system in Re.
%   xMAG: cartesian Geomagnetic [x, y, z] in Re
%   rMAG: geodetic Geomagnetic [Lat, Long, R]. Lat and Long in degrees,
%         R is radial distance from the center of the coordinate system
%         in Re.
%   xGSE: cartesian Geocentric Solar Ecliptic [x, y, z] in Re
%   rGSE: geodetic Geocentric Solar Ecliptic [Lat, Long, R]. Lat and Long
%         in degrees, R is radial distance from the center of the 
%         coordinate system in Re.
%   xGSM: cartesian Geocentric Solar Magnetic [x, y, z] in Re
%   rGSM: geodetic Geocentric Solar Magnetic [Lat, Long, R]. Lat and Long
%         in degrees, R is radial distance from the center of the 
%         coordinate system in Re.
%   MLT : Magnetic Local Time (used only as 'output_format')
%
%   The output is a 3-column matrix of the transformed coordinates, with
%   the exception of 'MLT' format, in which case it is just a single column
%   list of MLT values (decimal).

if isempty(t) || isempty(in)
    out = [];
else

li = length(input_format);
lo = length(output_format);
if li > 4 || lo > 4 || li < 3 || lo < 3
    error('coordinateTransform: Unknown or unsupported input or output format');
end
L1 = length(t); 
[L, D] = size(in);
if L ~= L1
    error('coordinateTransform: ''t'' and ''in'' vectors are of unequal lengths!');
end
if D ~=3
    error(['coordinateTransform: ''in'' should be a three-column matrix with the ',...
    'coordinates to be transformed in format specified by the ''input_format'' parameter']);
end

input_format = lower(input_format);
output_format = lower(output_format);

% Check if oner_desp_lib is installed (if the files exist in the matlab
% path)
if exist('onera_desp_lib_rotate','file') == 2

% Run a random line, to initialize library (it seems that if you try to
% perform a getMLT without having ran any of the coord transforms, as when
% the in and out are already in xGEO, the program fails and outputs only
% NaNs! just running a simple line as the one below seems to fix this)
onera_desp_lib_rotate([1,1.2,1],'geo2gsm',datenum(2012,1,1));

% The concept: Transform everything to xGEO. From there take it to xOUT and
% if necessary, transform to rOUT.

% WARNING: Matlab built-in functions for coordinate transforms between cartesian 
% and spherical systems symbolise the elevation and azimuth angles with PHI and 
% THETA respectively, contrary to common notation of spherical coordinates!!! 
% In general Matlab returns [azimuth, elevation, radius] while the typical
% format is [elevation, azimuth, radius]
xIN = zeros(L,3);
switch input_format(1)
    case 'r' % [LAT, LON, R]
        [xIN(:,1), xIN(:,2), xIN(:,3)] = sph2cart((pi/180)*(in(:,2)), (pi/180)*(in(:,1)), in(:,3));
    case 'x' 
        xIN = in;
    otherwise
        error('coordinateTransform: Unknown or unsupported input format');
end

xGEI = zeros(L,3); %#ok<NASGU>
switch input_format(2:li)
    case 'gei'
        % already in xGEI - do nothing
        xGEI = xIN;
    case 'geo' 
        xGEI = onera_desp_lib_rotate(xIN,'geo2gei',t);
    case 'sm'
        xGEI = onera_desp_lib_rotate(xIN,'sm2gei',t);
    case {'gm','mag'}
        xGEI = onera_desp_lib_rotate(xIN,'mag2gei',t);
    case {'gse'}
        xGEI = onera_desp_lib_rotate(xIN,'gse2gei',t);
    case 'gsm'
        xGEI = onera_desp_lib_rotate(xIN,'gsm2gei',t);
    otherwise
        error('coordinateTransform: Unknown or unsupported input format');
end

switch output_format(2:lo)
    case 'gei'
        % already in xGEI - do nothing
        xOUT = xGEI;
    case 'geo'
        xOUT = onera_desp_lib_rotate(xGEI,'gei2geo',t);
    case {'mag','gm'}
        xOUT = onera_desp_lib_rotate(xGEI,'gei2mag',t);
    case 'sm'
        xOUT = onera_desp_lib_rotate(xGEI,'gei2sm',t); 
    case 'gse'
        xOUT = onera_desp_lib_rotate(xGEI,'gei2gse',t); 
    case 'gsm'
        xOUT = onera_desp_lib_rotate(xGEI,'gei2gsm',t); 
    case 'lt'
        xOUT = onera_desp_lib_get_mlt(t,onera_desp_lib_rotate(xGEI,'gei2geo',t));
    otherwise
        error('coordinateTransform: Unknown or unsupported output format');
end
        
switch output_format(1)
    case 'r' % [LAT, LON, R]
        %[xIN(:,1), xIN(:,2), xIN(:,3)] = sph2cart(in(:,2), in(:,1), in(:,3));
        out = zeros(L,3);
        [out(:,2), out(:,1), out(:,3)] = cart2sph(xOUT(:,1), xOUT(:,2), xOUT(:,3));
        out(:,1) = (180/pi)*(out(:,1));
        out(:,2) = (180/pi)*(out(:,2));
        fneg = find(out(:,2) < 0);
        out(fneg ,2) = out(fneg ,2) + 360;
    case 'x' 
        out = xOUT;
    case 'm'
        out = xOUT;
    otherwise
        error('coordinateTransform: Unknown or unsupported input format');
end

else % if onera_desp_lib was not found
    out = [];
end
end

end

