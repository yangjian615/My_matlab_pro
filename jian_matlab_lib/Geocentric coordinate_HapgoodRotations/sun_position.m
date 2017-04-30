%--------------------------------------------------------------------------
% NAME
%   SCSfGEI
%
% PURPOSE
%   Determine the direction of the sun in GEI.
%
%   Program to caluclate sidereal time and position of the sun. It is good
%   for years 1901 through 2099 due to leap-year limitations. Its accuracy
%   is 0.006 degrees.
%
%   Direction of the sun in cartesian coordinates:
%       X = cos(SRASN) cos(SDEC)
%       Y = sin(SRASN) cos(SDEC)
%       Z = sin(SDEC)
%
%   REFERENCES:
%       C.T. Russel, Geophysical Coordinate Transformations.
%       http://www-ssc.igpp.ucla.edu/personnel/russell/papers/gct1.html/#appendix2
%
%   See the following reference, page C5, for a brief description of the
%   algorithm (with updated coefficients?).
%
%       (US), N. A. O. (Ed.). (2013). The Astronomical Almanac for the Year
%           2014. U.S. Government Printing Office. Retrieved from
%           http://books.google.com/books?id=2E0jXu4ZSQAC
%
%   This reference provides an algroithm that reduces the error and extends
%   the valid time range (i.e. not this algorithm).
%
%       Reda, I.; Andreas, A. (2003). Solar Position Algorithm for Solar
%           Radiation Applications. 55 pp.; NREL Report No. TP-560-34302,
%           Revised January 2008. http://www.nrel.gov/docs/fy08osti/34302.pdf
%
% PARAMS:
%   IYR:        in, required, type=integer
%               Year.
%   IDAY:       in, required, type=integer
%               Day of year.
%   SECS:       in, required, type=double/array
%               Seconds in day.
%
% RETURNS
%   S:          out, optional, type=float
%               Sidereal time and position of the sun.
%
%
%
% USES
%   Uses the following external programs:
%       sunrad.m
%--------------------------------------------------------------------------
function S = sun_position(IYR, IDAY, SECS)

    % Make sure the date is within range.
    assert( sum( IYR < 1901 ) == 0 && sum( IYR > 2099 ) == 0, ...
            'Year must be between 1901 and 2099.');

    % Constants
    RAD = 57.29578;         % 180/pi

    % Convert seconds to days.
    FDAY=SECS/86400;

    % Number of days since noon on 1 Jan 1900.
    DDJ = 365 .* (IYR-1900) + fix((IYR-1901) / 4) + IDAY - 0.5 ;
    DJ  = DDJ .* ones(1, length(SECS)) + FDAY  ;

    % Convert to Julian centuries from 1900
    %   - Julian Year:    Exactly 365.25 days of 86,400 SI seconds each.
    %   - Julian Century: 36,525 days
    T   = DJ / 36525;

    % Degrees per day
    %   - It takes 365.2422 days to complete a revolution about the sun.
    %   - There are 360 degrees in a circle.
    %  => 360.0 / 365.2422 = 0.9856 degrees/day

    % Keep degrees between 0 and 360
    %   mod(..., 360) will force answer to be in range [0, 360).


    % Mean longitude of the sun
    VL     = mod(279.696678 + 0.9856473354 .* DJ, 360);

    % Greenwhich sidereal time.
    GST    = mod(279.690983 + 0.9856473354 .* DJ + 360 .* FDAY + 180., 360);

    % Mean anomaly
    G      = mod(358.475845 + 0.985600267 .* DJ, 360)/RAD;

    % Ecliptic longitude
    SLONG  = VL + (1.91946 - 0.004789 .* T) .* sin(G) + 0.020094 .* sin(2 .* G);

    % Obliquity (Axial tilt)
    OBLIQ  = (23.45229 - 0.0130125 .* T) / RAD;


    SLP    = (SLONG - 0.005686) / RAD;
    SIND   = sin(OBLIQ) .* sin(SLP);
    COSD   = sqrt(1 - SIND.^2);

    % Solar declination
    SDEC   = RAD .* atan(SIND / COSD);

    % Solar right ascension
    SRASN  = 180 - RAD .* atan2(SIND / (tan(OBLIQ) .* COSD), -cos(SLP) / COSD);

    % Equatorial rectangular coordinates of the sun
    S(1,:) = cos( SRASN/RAD) .* COSD;
    S(2,:) = sin( SRASN/RAD) .* COSD;
    S(3,:) = SIND;
end