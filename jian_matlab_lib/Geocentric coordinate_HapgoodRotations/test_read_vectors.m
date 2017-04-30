%--------------------------------------------------------------------------
% NAME
%   test_read_vector
%
% PURPOSE
%   Read data produced by
%       http://sscweb.gsfc.nasa.gov/cgi-bin/Locator.cgi
%
% Calling Sequence:
%   time = read_SPDF_Locator_Form(filename);
%       Reads time tags from FILENAME and returns them as a MatLab date
%       number.
%
%   [time, gei] = read_SPDF_Locator_Form(filename);
%       Reads satellite position in GEI coordinates at TIME from FILENAME.
%
%   [time, gei, geo, gm, gse, gsm, sm] = read_SPDF_Locator_Form(filename);
%       Returns position in GEO, MAG (GM), GSE, GSM, and SM coordinates.
%
%--------------------------------------------------------------------------
function [time, gei, geo, mag, gse, gsm, sm] = test_read_vectors(filename)

    % Make sure the file exists
    assert(exist(filename, 'file') == 2, ['File does not exist: "', filename, '".']);

    % Open & Read the file
    fileID = fopen(filename);
    fmt     = '%d %d %s %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %s %s';
    data   = textscan(fileID, fmt,               ...
                      'Delimiter',          ' ', ...
                      'HeaderLines',         49, ...
                      'MultipleDelimsAsOne',  1);
    fclose(fileID);

    % Convert year, doy, hours, and minutes to MatLab datenum
    nPts  = length(data{1});
    hhmm = data{3};
    hhmm = vertcat(hhmm{:});
    time = datenum([double(data{1}) ones(nPts, 1) ones(nPts, 1)]) + ...
           double(data{2})             + ...
           str2num(hhmm(:,1:2)) / 24.0 + ...
           str2num(hhmm(:,4:5)) / (24.0 * 60.0);

    % Select components
    gei  = [data{4}  data{5}  data{6}];
    geo  = [data{7}  data{8}  data{9}];
    mag  = [data{10} data{11} data{12}];
    gse  = [data{13} data{14} data{15}];
    gsm  = [data{16} data{17} data{18}];
    sm   = [data{19} data{20} data{21}];
end