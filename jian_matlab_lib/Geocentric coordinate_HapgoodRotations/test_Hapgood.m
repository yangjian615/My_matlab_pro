%--------------------------------------------------------------------------
% NAME
%   test_Hapgood
%
% PURPOSE
%   Test the Hapgood Rotations
%
% Calling Sequence:
%   test_Hapgood
%       Display the results of transforming vectors from GSE to other
%       geocentric coordinate systems using the Hapgood rotations. Results
%       are obtained by comparing Hapgood results with results obtained by
%       NASA GSFC.
%
% References:
%   CXFORM
%       http://nssdcftp.gsfc.nasa.gov/selected_software/coordinate_transform/
%   Test results from CXFORM
%       http://nssdcftp.gsfc.nasa.gov/selected_software/coordinate_transform/test_results/ACE_2000_results.pdf
%   NASA Spacecraft locator for generating test vectors.
%       http://sscweb.gsfc.nasa.gov/cgi-bin/Locator.cgi
%
%--------------------------------------------------------------------------
function [] = test_Hapgood()
    % Files with test vectors and IGRF coefficients
    root      = '';
    test_file = fullfile(root, 'test_vectors.dat');
    igrf_file = fullfile(root, 'igrf_coeffs.txt');

    % Read data from file
    [time, gei, geo, mag, gse, gsm, sm] = test_read_vectors(test_file);

%-------------------------------------
% Get Required Parameters            |
%-------------------------------------

    % Get Modified Julian Date and UT
    %   - Number of days since 17 Nov 1858
    mjd = date2julday(time, 'MJD', true);
    ut  = mod(mjd, 1) * 24.0;
    mjd = floor(mjd);

    % Read IGRF coefficients.
    %   - Get year of data.
    %   - Read coefficients.
    %   - Get indices of desired coefficients.
    [year, ~, ~]        = datevec(time(1));
    [coef, ~, n, m, gh] = read_igrf_coeffs(igrf_file, round(year/5.0)*5.0);
    ig10 = find(n == 1 & m == 0 & strcmp(gh, 'g'), 1, 'first');
    ig11 = find(n == 1 & m == 1 & strcmp(gh, 'g'), 1, 'first');
    ih11 = find(n == 1 & m == 1 & strcmp(gh, 'h'), 1, 'first');

    % Get the coefficients
    g10 = double(coef(ig10));
    g11 = double(coef(ig11));
    h11 = double(coef(ih11));

%-------------------------------------
% Create Transformations             |
%-------------------------------------

    % Create transformation matrices.
    T1 = gei2geo(mjd, ut);
    T2 = gei2gse(mjd, ut);
    T3 = gse2gsm(g10, g11, h11, mjd, ut);
    T4 = gsm2sm (g10, g11, h11, mjd, ut);
    T5 = geo2mag(g10, g11, h11);

%-------------------------------------
% Transform from GSE to *            |
%-------------------------------------
		% GSE2GEI
		%   gei = T2' * gse
    gei_hap = mrvector_rotate( permute(T2, [2,1,3]), gse);

		% GSE2GEO
		%   geo = T1 * T2' * gse
    geo_hap = mrvector_rotate( T1, mrvector_rotate( permute(T2, [2,1,3]), gse) );

		% GSE2GSM
		%   gsm = T3' * gse
    gsm_hap = mrvector_rotate( permute(T3, [2,1,3]), gse);

		% GSE2SM
		%   sm = T4 * T3 * gse
    sm_hap  = mrvector_rotate( T4, mrvector_rotate(T3, gse) );

		% GSE2MAG
		%   mag = T5 * T1 * T2' * gse
    mag_hap = mrvector_rotate( T5, mrvector_rotate( T1, mrvector_rotate( permute(T2, [2,1,3]), gse ) ) );

%-------------------------------------
% Absolute difference                |
%-------------------------------------
    diff_gei = mean( abs(gei_hap - gei) );
    diff_geo = mean( abs(geo_hap - geo) );
    diff_gsm = mean( abs(gsm_hap - gsm) );
    diff_sm  = mean( abs(sm_hap  - sm)  );
    diff_mag = mean( abs(mag_hap - mag) );

%-------------------------------------
% Percent difference                 |
%-------------------------------------
    perc_gei = mean( abs(100.0 - gei ./ gei_hap .* 100.0) );
    perc_geo = mean( abs(100.0 - geo ./ geo_hap .* 100.0) );
    perc_gsm = mean( abs(100.0 - gsm ./ gsm_hap .* 100.0) );
    perc_sm  = mean( abs(100.0 - sm  ./ sm_hap  .* 100.0) );
    perc_mag = mean( abs(100.0 - mag ./ mag_hap .* 100.0) );

%-------------------------------------
% Output Answers                     |
%-------------------------------------
    fprintf('Cluster 1 - Year 2004     X          Y          Z         AVG\n');
    fprintf('\n');
    fprintf('GSE to GEI\n');
    fprintf('Absolute Difference: %0.4f %0.4f %0.4f\n', diff_gei);
    fprintf('Percent Difference:  %0.4f %0.4f %0.4f\n', perc_gei);
    fprintf('\n');
    fprintf('GSE to GEO\n');
    fprintf('Absolute Difference: %0.4f %0.4f %0.4f\n', diff_geo);
    fprintf('Percent Difference:  %0.4f %0.4f %0.4f\n', perc_geo);
    fprintf('\n');
    fprintf('GSE to GSM\n');
    fprintf('Absolute Difference: %0.4f %0.4f %0.4f\n', diff_gsm);
    fprintf('Percent Difference:  %0.4f %0.4f %0.4f\n', perc_gsm);
    fprintf('\n');
    fprintf('GSE to SM\n');
    fprintf('Absolute Difference: %0.4f %0.4f %0.4f\n', diff_sm);
    fprintf('Percent Difference:  %0.4f %0.4f %0.4f\n', perc_sm);
    fprintf('\n');
    fprintf('GSE to MAG\n');
    fprintf('Absolute Difference: %0.4f %0.4f %0.4f\n', diff_mag);
    fprintf('Percent Difference:  %0.4f %0.4f %0.4f\n', perc_mag);
end