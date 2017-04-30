%--------------------------------------------------------------------------
% Name
%   gse2scs
%
% Purpose
%   Return the transformation matrix to the despun spacecraft system (SCS)
%   to Geocentric Solar Ecliptic (GSE).
%
% Inputs
%   YEAR:    in, required, type = double
%   MONTH:   in, required, type = double
%   DAY:     in, required, type = string
%   SECS:    in, required, type = double
%            Seconds into `DAY`.
%   RA:      in, required, type = double
%            Right-ascention of the spacecraft.
%   DEC:     in, required, type = double
%            Declination of the spacecraft.
%
% Returns
%   GSE2SCS: out, optional, type = float
%            Transformation matrix to rotate GSE to SCS.
%
% USES
%   Uses the following external programs:
%     gei2scs.m                                   ???
%     gei2gse.m
%     get_mjd.m
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
function rot_gse2scs = gse2scs (year, month, day, secs, RA, dec)


	assert (nargin > 5, 'Missing arguments for gse2scs ().');




% My interpretation of how the program should work, based on file names.
%     rot_gei2scs = gei2scs (year, month, day, secs, RA, dec);
%     rot_gei2gse = gei2gse (date2mjd (year, month, day), secs/3600));
%     rot_gse2scs = rot_gei2scs * rot_gse2gei;

	rot_gse2scs =  gei2scs (year, month, day, secs, RA, dec) * ...
	               (gei2gse (date2mjd (year, month, day), secs/3600))';
end