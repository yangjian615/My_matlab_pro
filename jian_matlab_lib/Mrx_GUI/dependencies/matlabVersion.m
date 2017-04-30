function out = matlabVersion
% function out = matlabVersion
% 
% returns the MATLAB version as a number

% 10/2015 Adrian von Stechow

versionInfo = ver('matlab');
out = str2double(versionInfo.Version);