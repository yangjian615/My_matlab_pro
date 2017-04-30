%--------------------------------------------------------------------------
% Name
%   mjd2epoch2000
%
% Purpose
%   Convert Modified Julian Date (mjd) to Epoch 2000
%   mjd       -- Fractional number of days since 1858-11-17T00:00:00Z
%   Epoch2000 -- Fractional number of days since 2000-01-01T12:00:00Z
%
% Calling Sequence:
%   epoch2000 = date2mjd (mjd)
%   Convert Modified Julian Date to Epoch 2000.
%
% Inputs
%   MJD:       in, required, type = double
%              Number of days since 1858-11-17T00:00:00Z, which is
%              the definition of Modified Julian Date.
%
% Returns
%   EPOCH2000: out, required, type = double
%              Number of days since 2000-01-01T12:00:00Z, which is
%              the definition of Epoch 2000.
%
% Examples
%   Create an array of times beginning at 2000-01-01T12:00:00Z and
%   incrementing in half-day intervals for four days.
%     dnum      = datenum( [2000 01 01 12 00 00]  );
%     dnum      = dnum + [0:0.5:4];
%     mjd       = date2julday(dnum, 'MJD', true);
%     epoch2000 = mjd2epoch2000(mjd);
%              0    0.5000    1.0000    1.5000    2.0000    2.5000    3.0000    3.5000    4.0000
%
% References:
%   See Hapgood Rotations Glossary.txt.
%    - https://www.spenvis.oma.be/help/background/coortran/coortran.html
%    - Hapgood, M. A. (1992). Space physics coordinate transformations:
%        A user guide. Planetary and Space Science, 40 (5), 711?717.
%        doi:http://dx.doi.org/10.1016/0032-0633 (92)90012-D
%    - Hapgood, M. A. (1997). Corrigendum. Planetary and Space Science,
%        45 (8), 1047 ?. doi:http://dx.doi.org/10.1016/S0032-0633 (97)80261-9
%
% Last update: 2014-10-14
% MATLAB release(s) MATLAB 7.12 (R2011a), 8.3.0.532 (R2014a)
% Required Products None
%--------------------------------------------------------------------------
function epoch2000 = mjd2epoch2000(mjd)

	assert (nargin > 0, 'Usage: EPOCH2000 = mjd2epoch2000(MJD)');

	% Time in Julian centuries from Epoch 2000 (2000-01-01T12:00:00Z)
	%   - mjd        starts 1858-11-17T00:00:00Z
	%   - Epoch 2000 starts 2000-01-01T12:00:00Z
	%   - datestr ( 51544.5 + datenum (1858, 11, 17)) = 2000-01-01T12:00:00Z
	epoch2000 = mjd - 51544.5;
end
