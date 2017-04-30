%--------------------------------------------------------------------------
% NAME
%   test_coordinate_transformations
%
% PURPOSE
%   Read data produced by
%       http://sscweb.gsfc.nasa.gov/cgi-bin/Locator.cgi
%
% Calling Sequence:
%   gei = read_SPDF_Locator_Form(filename);
%       Reads satellite position data from FILENAME and returns the
%       position in GEI coordinates.
%
%   [gei, geo, gm, gse, gsm, sm] = read_SPDF_Locator_Form(filename);
%       Returns position in GEO, GM, GSE, GSM, and SM coordinates.
%
%--------------------------------------------------------------------------
function [] = test_Hapgood()
	
	use_rbsp = true;
	
	% Load data
	if use_rbsp
		% Load the mat file
		filename = '/home/argall/MATLAB/HapgoodRotations/rbsp-a_magnetometer_hires_emfisis-L3_20140814.mat';
		load(filename);
		
		% Pick a single vector
		t1_datvec = spdfbreakdowntt2000( t_gei(1) );
		t1_datnum = datenum( t1_datvec(1:3) );
		t1_utc    = MrCDF_epoch2ssm( t_gei(1) ) / 3600.0;
%		gei1 = b_gei(:,1);
%		geo1 = b_geo(:,1);
%		gm1  = zeros(3,1);
%		gse1 = b_gse(:,1);
%		gsm1 = b_gsm(:,1);
%		sm1  = b_sm(:,1);
		gei1 = b_gei;
		geo1 = b_geo;
		gm1  = zeros(size(b_gei));
		gse1 = b_gse;
		gsm1 = b_gsm;
		sm1  = b_sm;
	else
		% Read the text file
		filename = '/home/argall/MATLAB/HapgoodRotations/test_vectors.dat';
		[time, gei, geo, gm, gse, gsm, sm] = test_read_vectors(filename);

		% Start with a single vector
		t1_datnum = time(1,:)';
		t1_utc    = mod(t1_datnum, 1) * 24;
		gei1 = gei(1,:)';
		geo1 = geo(1,:)';
		gm1  = gm(1,:)';
		gse1 = gse(1,:)';
		gsm1 = gsm(1,:)';
		sm1  = sm(1,:)';
	end


%-------------------------------------
% Transformations                    |
%-------------------------------------

	% Get Modified Julian Date and UT
	%   - Number of days since 17 Nov 1858
	mjd = date2julday(t1_datnum, 'MJD', true);

	% Create transformation matrices.
	T1 = gei2geo(mjd, t1_utc);
	T2 = gei2gse(mjd, t1_utc);

	% GEO, GSM, and SM
	filename = '/home/argall/MATLAB/HapgoodRotations/igrf_coeffs.txt';
	[coef, yr, n, m, gh] = read_igrf_coeffs(filename, 2015);
	g10 = coef(1);
	g11 = coef(2);
	h11 = coef(3);
	T3  = gse2gsm(g10, g11, h11, mjd, t1_utc);
	T4  = gsm2sm(g10, g11, h11, mjd, t1_utc);
	T5  = gsm2sm(g10, g11, h11, mjd, t1_utc);

%-------------------------------------
% Transform from GEI to *            |
%-------------------------------------
	geo_hap =           T1 * gei1;
	gse_hap =           T2 * gei1;
	gsm_hap =      T3 * T2 * gei1;
	sm_hap  = T4 * T3 * T2 * gei1;
	mag_hap =      T5 * T1 * gei1;

%-------------------------------------
% Absolute difference                |
%-------------------------------------
	diff_geo = mean( abs(geo_hap - geo1), 2 );
	diff_gse = mean( abs(gse_hap - gse1), 2 );
	diff_gsm = mean( abs(gsm_hap - gsm1), 2 );
	diff_sm  = mean( abs(sm_hap  - sm1),  2 );

%-------------------------------------
% Percent difference                 |
%-------------------------------------
	perc_geo = mean( abs(100.0 - geo1 ./ geo_hap * 100.0), 2 );
	perc_gse = mean( abs(100.0 - gse1 ./ gse_hap * 100.0), 2 );
	perc_gsm = mean( abs(100.0 - gsm1 ./ gsm_hap * 100.0), 2 );
	perc_sm  = mean( abs(100.0 - sm1  ./ sm_hap  * 100.0), 2 );


%-------------------------------------
% Output Answers                     |
%-------------------------------------
%	fprintf('Cluster 1 - Year 2004     X          Y          Z         AVG\n');
%	fprintf('\n');
	fprintf('GEI to GEO\n');
	fprintf('  Absolute Difference: %0.4f %0.4f %0.4f\n', diff_geo);
	fprintf('  Percent Difference:  %0.4f %0.4f %0.4f\n', perc_geo);
	fprintf('\n');
	fprintf('GEI to GSE\n');
	fprintf('  Absolute Difference: %0.4f %0.4f %0.4f\n', diff_gse);
	fprintf('  Percent Difference:  %0.4f %0.4f %0.4f\n', perc_gse);
	fprintf('\n');
	fprintf('GEI to GSM\n');
	fprintf('  Absolute Difference: %0.4f %0.4f %0.4f\n', diff_gsm);
	fprintf('  Percent Difference:  %0.4f %0.4f %0.4f\n', perc_gsm);
	fprintf('\n');
	fprintf('GEI to SM\n');
	fprintf('  Absolute Difference: %0.4f %0.4f %0.4f\n', diff_sm);
	fprintf('  Percent Difference:  %0.4f %0.4f %0.4f\n', perc_sm);
end