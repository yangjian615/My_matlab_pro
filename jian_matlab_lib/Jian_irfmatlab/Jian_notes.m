% Jian_notes Notes on how to use irf routines
%   Includes different examples that can be directly used
%
%  Jian_notes   opens file with all the different examples
%
% enable code folding!!! (including cells and if/endif blocks)
% This allows to fast find your necessary examples and execute them.
%

edit Jian_notes.m; return
%% init library
% jian_irfmatlab=jian_irfmatlab('data_path','/data/caalocal');
jian_irfmatlab=jian_irfmatlab();
jian_irfmatlab.init;

%% Downloads data from CSA, stores it in data/caalocal.
if 0
cd data_cluster
tint=irf.tint('2001-07-31T20:14:17.499996Z/2001-07-31T20:16:17.499996Z'); % time interval
Jian.import_c_data(tint,'fgm');

Jian.import_c_data(tint,'efw');
Jian.import_c_data(tint,'cisMom');
Jian.import_c_data(tint,'cisHiapsd');

end

%% load data use local.c_read
%load b field
scInd=1;
tint=irf.tint('2001-07-31T20:14:17.499996Z/2001-07-31T20:16:17.499996Z'); % time interval
ok=local.c_read('test');
local.c_update
local.c_read('list');
cd ../../..


%% load pos
R = Jian.get_c_pos(tint);
R
%% load bfield C?_CP_FGM_FULL
bField = Jian.get_3d_b_field(tint,scInd);
Jian.plot_3d_b_field(bField);

%% load efield C?_CP_EFW_L2_E3D_GSE
eField = Jian.get_3d_e_field(tint,scInd);
Jian.plot_3d_e_field(eField);

%% load cisMom C?_CP_CIS_HIA_ONBOARD_MOMENTS
[hia_moments] = Jian.get_hia_moments(tint,scInd);
hia_moments = Jian.PLOT_hia_moments(hia_moments);
     
%% load cis HIA PSD C?_CP_CIS-HIA_HS_MAG_IONS_PSD
% returns some parameters as given by the CIS-HIA team.
[th,phi,etab] = Jian.get_hia_values('all','full');
[th,phi,etab_half] = Jian.get_hia_values('all','half');

%returns full 4-D matrix.
[ionMat,t] = Jian.get_hia_data(tint,scInd,'default');

%like default but matrix N*16x8x31
[ionMat,t] = Jian.get_hia_data(tint,scInd,'3d');

%integrates over polar angle
[ionMat,t] = Jian.get_hia_data(tint,scInd,'energy');

%integrates over energy
[ionMat,t] = Jian.get_hia_data(tint,scInd,'polar');
%integrates over azimutal and polar angle
[ionMat,t] = Jian.get_hia_data(tint,scInd,'1d');
%energy table half
[ionMat,t] = Jian.get_hia_data(tint,scInd,'default','half');


%plot
[h,f]=Jian.afigure(1);
[hsf,ionMat,t] = Jian.plot_hia_subspin(h,tint.epochUnix,scInd,'energy');
[hsf,ionMat,t] = Jian.plot_hia_subspin(h,tint.epochUnix,scInd,'polar');

[psdMat,tData] = Jian.get_one_hia_spin(tint.epochUnix,scInd);
[h,f]=Jian.afigure(1);
[hsf,hcb] = Jian.hia_plot_velspace(h,psdMat);


%% initial figure
subNum=5;
figSize=[15,15];
[h,f]=Jian.afigure(subNum,figSize);
for i=1:subNum
irf_plot(h(i),bField);
end

%% Hodograms LMN frame 
% The red dot in the plots indicates start time
[h,v] = Jian.hodo(bField);

% gui 选定时间和时刻
Jian.hodo_gui(bField,1)

%% 1D test patrticle simulation
runTime=20;

[vel,xMin,Y] = Jian.lorentz_1d(eF,bF,v0,runTime)














