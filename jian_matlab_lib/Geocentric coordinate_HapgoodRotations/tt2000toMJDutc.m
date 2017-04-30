%
% Name
%   mms_fg_read_ql
%
% Purpose
%   Read Quick-Look (QL) fluxgate magnetometer data from MMS.
%
% Calling Sequence
%   [MJD, UTC] = mms_tt2000toMJD(tt2000)
%       Convert CDF TT2000 epoch values to modified julian date MJD
%       and the decimal number of hours since midnight on that date UTC.
%
% Parameters
%   TT2000          in, required, type = int64 (cdf_time_tt2000)
%
% Returns
%   MJD             out, required, type=double
%   UTC             out, required, type=double
%
% MATLAB release(s) MATLAB 7.14.0.739 (R2012a)
% Required Products None
%
% History:
%   2015-11-19      Written by Matthew Argall
%
function [mjd, utc] = tt2000toMJDutc(tt2000)

	% Convert tt2000 to date vector
	dvec = spdfbreakdowntt2000(tt2000);

	% Turn [year, month, day] into modified julian date
	mjd = date2mjd(dvec(:,1), dvec(:,2), dvec(:,3));

	% Turn [hour, minutes, seconds] to seconds since midnight
	utc = dvec(:,4) .* 3600.0 + ...
	      dvec(:,5) .* 60.0   + ...
	      dvec(:,6)           + ...
	      dvec(:,7) .* 1e-3   + ...
	      dvec(:,8) .* 1e-6   + ...
	      dvec(:,9) .* 1e-9;
	
	% Convert to decimal hours
	utc = utc / 3600.0;
end