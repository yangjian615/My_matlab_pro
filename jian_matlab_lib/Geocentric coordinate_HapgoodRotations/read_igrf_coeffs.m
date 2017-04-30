%--------------------------------------------------------------------------
% NAME
%   read_igrf_coeffs
%
% PURPOSE
%   Read IGRF coefficients from a file.
%
% Calling Sequence:
%   COEF = read_igrf_coeffs(FILENAME)
%       Read IGRF coefficients from FILENAME.
%
%   COEF = read_igrf_coeffs(FILENAME, YEAR)
%       Read IGRF coefficients for YEAR from FILENAME. IGRF coefficeints
%       are calculated every 5 years, starting in 1900.
%
%   [COEF, YR, N, M, GH] = read_igrf_coeffs(___)
%       Return IGRF coefficients, the YEAR to which they correspond, the
%       spherical harmonic indices N and M, and the harmonic mode GH.
%
% References:
%   http://www.ngdc.noaa.gov/IAGA/vmod/igrf.html
%
%--------------------------------------------------------------------------
function [coef, yr, n, m, gh] = read_igrf_coeffs(filename, year)

    % Make sure the file exists
    assert(exist(filename, 'file') == 2, ['File does not exist: "', filename, '".']);

    % Open & Read the file
    fileID = fopen(filename);
    fmt    = '%s %d %d %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f';
    data   = textscan(fileID, fmt,               ...
                      'Delimiter',          ' ', ...
                      'HeaderLines',          4, ...
                      'MultipleDelimsAsOne',  1);
    fclose(fileID);

    % Convert year, doy, hours, and minutes to MatLab datenum
    yr   = [1900:5:2015 2015.5];
    gh   = data{1}';
    n    = data{2}';
    m    = data{3}';
    coef = [ data{4}  data{5}  data{6}  data{7}  data{8}  data{9}  data{10} ...
             data{11} data{12} data{13} data{14} data{15} data{16} data{17} ...
             data{18} data{19} data{20} data{21} data{22} data{23} data{24} ...
             data{25} data{26} data{27} ]';
    clear data

    % Return coefficients for a given year?
    if nargin == 2
        iYear = find(yr == year, 1, 'first');
        if isempty(iYear) == 0
            yr   = yr(iYear);
            coef = coef(iYear, :);
        else
            fprintf('Year %d not found. Returning data for all years.\n', year)
        end
    end
end