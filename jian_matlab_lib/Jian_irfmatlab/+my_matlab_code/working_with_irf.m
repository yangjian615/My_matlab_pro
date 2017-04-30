%% some use of irf procedure

irf_widget_omni;%IRF_WIDGET_OMNI plot solar wind and indices
f=irf_get_data_omni(tint,parameter, database);%dst 变量号改正case 'dst',    varOmni2=40;varOmni1min=41;
download_omni_data_irf

cluster_colors=[[0 0 0];[1 0 0];[0 0.5 0];[0 0 1];[1 0 1];[1 1 0];[0 1 1]];
mms_colors=[[0 0 0];[213,94,0];[0,158,115];[86,180,233]]/255;
[h]=adjust_multilines_color(h,mycolor)

alpha = irf_pres_anis(Pi, B) %Compute ion pressure anisotropy factor: (Pi_para - Pi_perp) * mu0 / B^2



%%before use c_pl_sc_conf_xyz change line 149
%['sc_r_xyz_gse__C' strSc'_CP_AUX_POSGSE_1M']--['sc_r_xyz_gse__' strSc'_CP_AUX_POSGSE_1M']
%line 504 516
%'epoch>yyyy-mm-dd HH:MM:SS'---'epoch>utc_yyyy-mm-dd HH:MM:SS'
c_pl_sc_conf_xyz ;%Plot the configuration of CLuster in XYZ coordinates
c_rapid_pad_plot_bf2004(C1_CP_RAP_EPADEX2, C1_CP_RAP_EPITCH, 1); %plot the electron pitch angle distribution of RAPID as function of time
j_C1_ISR2=c_coord_trans('GSM','ISR2',j_C1_gsm,'cl_id',1,'t',tint);
irf_pl_tx

ut=irf_convert(in,'eV2nm'); % convert from eV to nm

%magnetopause
[x,y] = irf_magnetosphere('mp_shue1998',0.45,2.91);  % magnetopause position
r_mp_Re = irf_shue_mp(pos_Re_gsm, bz_nT, swp_nPa);%distance to the magnetopause
[mindist,nvec] = MODEL.MAGNETOPAUSE_NORMAL(pos_Re_gsm, IMF_Bz_nT, swp_nPa);   %distance and normal vector to the magnetopause
%read cef from csa
data= cluster_read_cef_data(file)

save('j_4c.mat','-v6')% matlab idl

[h1,h2] = initialize_combined_plot(5,2,2,3,'horizontal'); % Combination of irf time panels and subplot(nRows,nCols,i_subplot).

% % wave analysis
%Decompose a vector into par/perp to B components
[Epar,Eperp]=irf_dec_parperp(Bisr2,Eibm,1); %line 36 change rtrnTS = 0;return mat format

% Transforms to a field-aligned coordinate (FAC) system defined as:
Bfac = irf_convert_fac(Bibm,Bisr2,SCpos);

%Filter time series if fmin = 0 do lowpass filter
%if fmax = 0 do highpass filter
[out] = irf_filt(inp,fmin,fmax,[Fs],[order])

% filter the data through low or highpas filter with max frequency fcut
%  and subtract from the original
[newdata]=irf_lowpass(data,fcut,fhz)


% compute power spectrum
specrec=irf_powerfft(Eibm,60,20,50);


% irf_wavefft: Short-Time Fourier Transform.
[S,F,T]=irf_wavefft(Bwave(:,2), 'hamming',frame_overlap,frame_length,fs); %frame_overlap in micro second


%Calculate wavevelet spectrogram based on fast FFT algorithm
specrec=irf_wavelet(Eibm,'f',[1 1000],'nf',200,'fs',20,'cutedge',0);
irf_wavelet(Eibm);%可视化 %irf_wavelet line 96更改成小写fs

% Power Spectral Density estimate
irf_psd(Ez_wave_at_DF,1024,222000,hamming(1024),512); %note Ez_wave_at_DF 时间序列 nx2
[Pxx,F]=irf_psd(Ez_wave_at_DF,1024,222000,hamming(1024),512); loglog(F,Pxx);

%Calculates wavelet spectra, Poynting flux, polarization params
%wavelet method
polarization = irf_ebsp(Eibm,Bibm,Bisr2,Bisr2,SCpos,[0.1 10],'polarization','fac');

% analysis the polarization of magnetic wave using "magnetic SVD" method
[Bpsd,planarity,waveangle,elliptict]=irf_wavepolarize_magneticSVD(Bwave,Bbgd,1.0e-7,80);

% estimates Poynting flux S and Poynting flux along Bo
% from electric field E and magnetic field B
[S,Sz,intSz]=irf_Poynting_flux(E,B,Bo)

%whamp use
whamp.plot_f(4e6,1,0.3,0.9,1,1,0);
[h,f,vp,vz] = whamp.plot_f(Oxygen,'km/s');% line 276 改为 nargout == 3  line 287 改为 nargout == 4

Output = whamp.run([],[]);
[h,f,vp,vz]=whamp.plot_f(Output.PlasmaModel,'PSDvsE','pitchangles',[0:30:180]);





irf_disp_surf %计算色散曲面
irf_estimate  %估计材料的电容
irf.ts2mat(B1) %Convert TSeries to MAT
irf_figmenu   %加入irf menu
H = irf_figure(2)%figure with n panels


% Get propagation direction by matching dBpar and "phi".
tint = irf.tint('2015-12-31T22:38:24.00000Z/2015-12-31T22:38:26.00000Z');
c_eval('B=mms.get_data(''B_gsm_srvy'',tint,?);',1);
c_eval('E=mms.db_get_ts(''mms?_edp_fast_l2_dce'',''mms?_edp_dce_gse_fast_l2'',tint);',1);

B=irf.ts2mat(B);  E=irf.ts2mat(E);
angles=1:3:360;
f_highpass=7;
[x y z corr_dir intEdt Bz B0 dEk dEn Ek En]=irf_match_phibe_dir(B,E,angles,f_highpass);
i_dir=find(corr_dir(:,1)==max(corr_dir(:,1)));
direction=x(i_dir,:);
% Velocity and density
n=linspace(0.01,0.1,100);
v=linspace(200,2000,100);
[corr_v,phi_E,phi_B]=irf_match_phibe_v(B0,Bz,intEdt(:,[1 1+i_dir]),n,v);
i_v=find(corr_v(:,1)==min(corr_v(:,1)));
velocity=v(i_v);
% Figures
gif_stuff_dir = irf_match_phibe_vis('direction',x,y,z,corr_dir,intEdt,Bz,Ek,En);
imwrite(gif_stuff_dir.im,gif_stuff_dir.map,'mygif_dir.gif','DelayTime',0.01,'LoopCount',inf);

i_n=50; % if more than one densitiy, choose one by specifying index
gif_stuff_v = irf_match_phibe_vis('velocity',phi_E,phi_B(:,[1 i_n]),v,n(i_n));
imwrite(gif_stuff_v.im,gif_stuff_v.map,'mygif_v.gif','DelayTime',0.01,'LoopCount',inf);

figure; h=axes;
axis_handle = irf_match_phibe_vis('velocity/density',h,n,v,corr_v);

irf_pl_add_info;%
irf_print_fig('figure','png');
h=irf_plot_get_subplot_handles();
t_st_e = irf_plot_start_epoch(); irf_time(t_st_e,'epoch>utc');


%% myself pro

% cd '/Users/yangjian/Desktop/c1 data/particles distributions/'
case_20010731_electronbeams_timeseries  %Plot pitch angle distribution PSD
case_20010731_electronbeams_DF
%计算图形位置
[pos_panel] = caculate_multiplot_position(plot_row,plot_col,plot_number,pos_init,space_subplot,plot_sort,varargin)

%legend in vertical or horizontal
% h_legend=irf_legend(h(1),cell_str,[0.02, 0.9]);
[ h_out ] = irf_legend_with_vertical(h_legend,0.08); %vertical
[ h_out ] = irf_legend_with_vertical(h_legend,0.08,'horizontal');

%irf_plot_double_axis
h_secondaxis=irf_plot_double_axis(h(3),Te,tint,{'N [cm^{-3}]','T_e [eV]'});
second_ylable=h_secondaxis.YLabel;
first_ylable=h(3).YLabel;
set(first_ylable,'Position',[-0.15,0.5]);

%自带的按线性拉伸倍数关系
irf_plot(h,n_efw_calibrated)
hold(h,'on');
irf_plot(h,n_efw_calibrated,'yy',coefficient);
hold(h,'off');
set(temp_doubleaxis(1),'YColor','k');
set(temp_doubleaxis(2),'YColor','b');
first_ylable=temp_doubleaxis(1).YLabel;
second_ylable=temp_doubleaxis(2).YLabel;

set(first_ylable,'Interpreter','tex');
set(first_ylable,'String','N [cm^{-3}]');
set(first_ylable,'Position',[-0.15,0.5]);
set(second_ylable,'String','T_e [eV]');

%particle distribution 粒子分布数据画取
data_structure = c_caa_distribution_data_mychange('C1_CP_CIS_HIA_HS_MAG_IONS_PSD'); data_structure.en_pol=abs(data_structure.en_pol);
data_structure = c_caa_distribution_data_mychange('C1_CP_PEA_PITCH_FULL_PSD');
h=c_caa_plot_distribution_function('tint',tint.epochUnix,'polar',data_structure);
h=c_caa_plot_distribution_function('tint',tint.epochUnix','cross-section',data_structure,'emin',10);


%cluster project
edit ECLAT_project %读取时间列表的cluster数据 画出每个event图片 统计用的


matlab_datenumber_data=irf_TSeriesdata_to_matlab_datenumber_data( irf_TSeriesdata ,varargin)% irf TSeriesdata to matlab datenumber data

% Finding Maxima or Peaks
edit PeakAnalysisExample




%% file process
fname = irf_fname(tint,FORMAT);


% search files
filename='/Users/yangjian/Desktop/c1 data/CIS/C1_CP_CIS-HIA_HS_1D_PEF/C1_CP_CIS-HIA_HS_1D_PEF__%Y%M%d_%H%m%S_%Y%M%d_%H%m%S_V*.cdf';
FILES = MrFile_Search(filename);%Find all files with name matching FILENAME
FILES= MrFile_Search(filename,'TStart','2001-07-31T20:14:17Z',TEnd,'2006-10-14T07:38:51Z','VersionRegex', vRegex);%精确时间记录
FILES = MrFile_Finder('/Users/yangjian/Desktop/*.txt');%  200%((*)%)
vertcat(FILES{:})


NLINES = MrFile_nLines(FILENAME); %Determine the number of lines in a file
data = MrFile_Read_nAscii(files,'ColumnNames', column_names,'DataStart',1,'nFooter',1);



%% MMS DATA process
% Load Data
mms.db_init('local_file_db','/data/mms');
mms.db_init('local_file_db_irfu','/data/mms/irfu');
mms.db_init('db_cache_size_max',4096) % set cache to 4GB


MMS_DB = mms_local_file_db('/data/mms');
mms_local_file_db  %Local file database for MMS Class handling a database of local MMS files

%data base cache status
mms.db_cache('on')
mms.db_cache_disp();

%   Dissect and construct a filename
filename = 'mms3_dfg_hr_l2p_duration-1h1m_20010704_v1.0.0.cdf';
[sc,instr,mode,level,tstart,version]=mms_dissect_filename(filename);
fname = mms_construct_filename(sc,instr,mode,level,'TStart',tstart,'Version',version);
[files, nFiles, searchstr] = mms_file_search(sc, instr, mode, level, varargin)




filenameData = mms_fields_file_info(file)

dfgFile = dataobj('/data/mms/mms1/dfg/srvy/l2pre/2015/09/mms1_dfg_srvy_l2pre_20150911_v2.0.0.cdf');
plot(fgmFile,'mms1_fgm_b_gsm_srvy_l2') %plot dataobj for quick look
gsmB1 = get_ts(dfgFile,'mms1_dfg_srvy_l2pre_gsm');
gsmR1 = get_ts(dfgFile,'mms1_pos_gsm');


mms1_fgm_b_gse_brst_l2=mms.db_get_ts('mms1_fgm_brst_l2','mms1_fgm_b_gse_brst_l2',Tint)
c_eval('Bxyz=mms.db_get_ts(''mms?_dfg_srvy_ql'',''mms?_dfg_srvy_dmpa'',tint);',ic);
c_eval('Exyz=mms.db_get_ts(''mms?_edp_brst_ql_dce2d'',''mms?_edp_dce_xyz_dsl'',tint);',ic);
R  = mms.get_data('R_gse',Tint);   % SC GSE position for all MMS SC
c_eval('etheta?=mms.db_get_variable(''mms?_fpi_fast_l2_des-dist'',''mms?_des_theta_fast'',tint);',ic)

%mr mms cdf
[data, depend_0] = MrCDF_nRead(file, 'mms1_fgm_b_gse_brst_l2');%读入原始时间ttns 读取多个cdf文件
[epoch_type] = cdf_epoch_type(depend_0) %Determine the type of CDF Epoch type of 't_epoch'

%plot MMS configuration
h = mms.mms4_pl_conf(time);  %load epht89d position
mms_orbit_configuration;%MMS configuration
% MMS processing
ts=mms.variable2ts(va); %Converst variable structure to TSeries
[paddist,theta,energy,tint] = mms.get_pitchangledist(pdist,B,[tint]); % addline 235 if length(dangle)==1, dangle=dangle+zeros(length(anglevec)); end

%timing use irf_4_v_gui
c_eval('B?=mms.get_data(''B_gsm_srvy'',tint,?);');
c_eval('R?=mms.get_data(''R_gsm'',tint,?);');
out=irf_4_v_gui('B?','R?','mms');

%load DEFATT/DEFEPH file
defAttFile = '/Users/yangjian/Desktop/mms_test_all/data/mms/ancillary/tetrahedron_qf/MMS_DEFQ_2015364_2015365.V00';
[dataIN,filenameData] = mms_load_ancillary(defAttFile,'defq')

Tint  = irf.tint('2015-12-31T00:04:00.00Z/2015-12-31T05:20:50.00Z');
quality=mms.db_get_variable('mms_ancillary_defq','Q',Tint); %Every 30s
res=mms.get_data('tetra_quality',Tint)







%% MMS distribution make
% Load PDist using mms.make_pdist
ic = 1; % spacecraft number
time = irf_time('2015-12-31T10:00:10.00000Z','utc>epochtt');

%filepath_and_filename = mms.get_filepath('mms1_fpi_fast_l2_des-dist',time);
filepath_and_filename = mms.get_filepath('mms1_fpi_brst_l2_des-dist',time);

c_eval('[ePDist?,ePDistError?] = make_pdist_mode(filepath_and_filename);',ic)

% Make skymap directly with PDist
tint = irf.tint('2015-12-31T22:38:24.00000Z/2015-12-31T22:38:40.00Z');

c_eval('desDist?=mms.db_get_ts(''mms?_fpi_fast_l2_des-dist'',''mms?_des_dist_fast'',tint);',ic)
c_eval('energy=mms.db_get_variable(''mms?_fpi_fast_l2_des-dist'',''mms?_des_energy_fast'',tint);',ic)  % only use mms.db_get_variable
c_eval('ephi?=mms.db_get_variable(''mms?_fpi_fast_l2_des-dist'',''mms?_des_phi_fast'',tint);',ic)
c_eval('etheta?=mms.db_get_variable(''mms?_fpi_fast_l2_des-dist'',''mms?_des_theta_fast'',tint);',ic)

% c_eval('ePDist? = PDist(desDist?.time,desDist?.data,''skymap'',energy,ephi?.data,etheta?.data);',ic)
c_eval('ePDist? = PDist(desDist?.time,desDist?.data,''skymap'',energy,ephi?,etheta?);',ic)
c_eval('ePDist?.userData = desDist?.userData; ePDist?.name = desDist?.name; ePDist?.units = desDist?.units;',ic)
c_eval('ePDist?.units = ''s^3/cm^6'';',ic)
c_eval('ePDist?.species = ''electrons'';',ic)

c_eval('ePDist?',ic)

ePDist1.depend{1,1}=repmat(ePDist1.depend{1,1}.data,numel(ePDist1.time.epoch),1);
ePDist1.depend{1,2}=repmat(ePDist1.depend{1,2}.data,numel(ePDist1.time.epoch),1);
ePDist1.depend{1,3}=ePDist1.depend{1,3}.data;

ePDist1.ancillary.dt_minus=2.25;
ePDist1.ancillary.dt_plus=2.25;
ePDist1.ancillary.energy0=energy.data;
ePDist1.ancillary.energy1=energy.data ;
ePDist1.ancillary.esteptable=uint8(zeros(numel(ePDist1.time.epoch),1)+1);

% Load Data with mms.get_data
% Particle distributions
c_eval('ePDist = mms.get_data(''PDe_fpi_fast_l2'',Tint,?);',ic)
ePDist.ancillary.dt_minus=2.25;
ePDist.ancillary.dt_plus=2.25;
ePDist.depend{1,2}=repmat(ePDist.depend{1,2},numel(ePDist.time.epoch),1);
ePDist.ancillary.esteptable=ePDist.ancillary.esteptable.data;


% Make skymap with irf.ts_skymap
% If energy table is NOT passed, energy0, energy1 and energysteptable is necessary
c_eval('ePDist? = irf.ts_skymap(desDist?.time,desDist?.data,[],ephi?.data,etheta?.data,''energy0'',eenergy0?.data,''energy1'',eenergy1?.data,''esteptable'',estepTable?.data);',ic)
c_eval('ePDist?.units = ''s^3/cm^6'';',ic)
c_eval('ePDist?',ic)
% If energy table is passed, energy0, energy1 and energysteptable is not necessary
c_eval('ePDist? = irf.ts_skymap(desDist?.time,desDist?.data,energy,ephi?.data,etheta?.data);',ic)
c_eval('ePDist?.units = ''s^3/cm^6'';',ic)
c_eval('ePDist?',ic)


% Plot particle distribution for all direction but a single energy

mms.plot_skymap(ePDist1,'tint',time,'energy',100,'vectors',{hatB0,'B'},'log');
mms.plot_skymap(ePDist1,'tint',time,'energy',100,'vectors',{hatB0,'B'},'flat','log');

% Plot projection onto a plane perpendicular to B
mms.plot_projection(ePDist1,'tint',time,'xyz',[1 0 0; 0 1 0; hatB0],'elevationlim',20,'vlim',15000);

% Plot particle distribution for pitch angles 0 90 and 180
mms.plot_cross_section_psd(ePDist1,B0,'tint',time,'scPot',scpot,'energies',[70 180])  %暂时没有 mms.get_pitchangledist代替


%% Define time intervals
% Give start and stop times
tint = irf.tint('2008-04-22T17:50:00.00Z/2008-04-22T18:15:00.00Z')
% or give start time and duration in seconds
tint = irf.tint('2008-04-22T17:50:00.00Z',25*60)

t=irf_time([2008 03 01 10 0 0]):.2:irf_time([2008 03 01 11 0 0]);%Convert time between different formats

Tsta='2001-07-31T20:14:17.499996Z';
Tend='2001-07-31T20:16:17.499996Z';
tint=[iso2epoch(Tsta) iso2epoch(Tend)]; %ISDAT epoch

y=irf_tlim(x,xlim);



%% Download data, if you don't have already
% This will download data into a subfolder of your current directory, so
% check where you are before you download it so you don't have to move it
% around.
% Do only once, otherwise the loading functions will find several files and
% ask you each time which one to download.

% ls /Users/Cecilia/Data/Cluster/
help caa_download
caa_download(tint,'list:*')
caa_download(tint,'C?_CP_CIS_HIA_ONBOARD_MOMENTS');
caa_download(tint,'C?_CP_FGM_FULL');

caa_download(tint,'C1_CP_AUX_POSGSE_1M','downloadDirectory=/Users/yangjian/Downloads/data/CAA'); %download define Directory

%%  checking cdf infor and CAA 变量 信息 读入的时间是EPOCH
info = spdfcdfinfo('CAA/C1_CP_FGM_FULL/C1_CP_FGM_FULL__20020330_131130_20020330_131200_V140306.cdf'); % query metadata
caa_meta('C1','PEA')
database=caa_meta('C1','PEA');
irf_cdf_read %- interactively choose file and variable        %进入cdf所在文件夹
% ======== Options ========
% q) quit, dont return anything
% v) list all variables
% vv) list all variables and their values
% r) read variable in default format
% t) read time variables in irfu format and return
% fa) list the file variable attributes
% fav) view the file variable attributes
% ga) list global attributes
% gav) view global attributes
irf_cdf_read('*.cdf','*'); %- allow to choose file and variables 一般不能返回时间序列


%% Load data into a matrix with time in first column and date in subsequent columns
% data = cdfread(file);
% irf_cdf_read();
% B=irf_get_data('Spacecraft_potential__C1_CP_EFW_L2_P','caa');  %返回structure 等效与用 C_CAA_VAR_GET 获取caa         caa 目录 或下级目录
% caa=c_caa_var_get(varname,'caa')  ;  %returns VariableStruct
%
%
% dobj=c_caa_var_get(varname,'dobj') ;%returns DataObject  和 data_obj类似
% unit=c_caa_var_get(varname,'unit') ;%returns only units
%
% data_obj=dataobj(file);
% Ncis=getmat(data_obj,'density__C1_CP_CIS_HIA_ONBOARD_MOMENTS');
help caa_load


% In this case, the data (magnetic field,temperature, density, velocity,
% etc) and the time are the same data type. This has caused some precision
% problem with the time in prior missions.
gseB1mat  = c_caa_var_get('B_vec_xyz_gse__C1_CP_FGM_FULL','mat');
Ti1mat    = c_caa_var_get('temperature__C1_CP_CIS_HIA_ONBOARD_MOMENTS','mat');
ni1mat    = c_caa_var_get('density__C1_CP_CIS_HIA_ONBOARD_MOMENTS','mat');
gseVi1mat = c_caa_var_get('velocity_gse__C1_CP_CIS_HIA_ONBOARD_MOMENTS','mat')



%% Load data into a TSeries class object and creat new TSeries
gseB1  = c_caa_var_get('B_vec_xyz_gse__C1_CP_FGM_FULL','ts');
Ti1    = c_caa_var_get('temperature__C1_CP_CIS_HIA_ONBOARD_MOMENTS','ts');
ni1    = c_caa_var_get('density__C1_CP_CIS_HIA_ONBOARD_MOMENTS','ts');
gseVi1 = c_caa_var_get('velocity_gse__C1_CP_CIS_HIA_ONBOARD_MOMENTS','ts');

% creat new TSeries
epochtt=read_cdfepoch16_dcomplex(file,'epochtt'); % if read epoch16

epochtt=irf_cdf_read(file,'epochtt'); % read cdf epoch

T  = EpochTT('2002-03-04T09:30:00Z')
data=irf.ts_scalar(time_epochtt,data);
data= irf.ts_vec_xy(T,[bx by]);
data= irf.ts_vec_xyz(T,[bx by bz]);

c_eval('gseB?mat2ts=irf.ts_vec_xyz(gseB?mat(:,1),gseB?mat(:,2:4));',1); %string run
eval(irf_ssub('R?=r?;C?=R?.^2;',ic))

%% Make a simple overview plot

irf_plot('B_mag__C1_CP_FGM_5VPS') %plot CAA variable B_mag__C1_CP_FGM_5VPS (if necessary load it)=
irf_plot({gseB1,gseVi1,ni1,Ti1}) % plots different components in different panels
% ylabels are not very pretty, but they display the information contained
% within the TSeries object.
h=irf_plot(5,'newfigure');

h(1)=irf_panel('B1gsm');

irf_plot(h(1),B1gsm);
y_h(1)=ylabel(h(1),'Bgsm(nT)','interpreter','tex');
hca.YLabel.String = 'B (nT)';

irf_legend(h(1),{'Bx','By','Bz'},[0.02, 0.85])
hold(h(1),'on')
irf_plot(h(1),[B1gsm(1,1) 0;B1gsm(end,1) 0],'k','LineStyle','--')              %draw y=0 line
%% draw spectrogram
h(1)=irf_panel('STAFF spectrogram B and fce lines');
specrec=struct('t',Time__C1_CP_STA_PSD,'p_label',['V^{2}m^{-2}Hz^{-1}']);%NX1
specrec.f=Frequency__C1_CP_STA_PSD';%1xM
specrec.p=Bsum2D;%NXM
specrec.f_label=' ';
specrec.p_label={'log_{10}B^{2}','nt^2 Hz^{-1}'};

[h(1),hcb(1)]=irf_spectrogram(h(1),specrec,'log','donotfitcolorbarlabel');
%   irf_legend(h(1),'(a)',[0.99 0.98],'color','w','fontsize',12)
hold(h(1),'on');

irf_plot(h(1),fce,'linewidth',1.5,'color','w')

hold(h(1),'off');


 %irf_pl_matrix plot matrix type data, for example energy/pitchangle distribution
  [h] = irf_pl_matrix(specrec)
  [h] = irf_pl_matrix(x,y,F,[dx],[dy],[Flabel],[xlabel],[ylabel])





%% Adjust the figure a little bit
h(1).Title.String = 'Cluster 1 (GSE)';
tintZoom = irf.tint('2008-04-22T18:00:00.00Z/2008-04-22T18:10:00.00Z');
irf_zoom(h,'x',tintZoom); % zoom in figure
irf_zoom(h,'y'); % adjusts y limits so it's good for the new time interval
irf_plot_axis_align % align labels on y axis

% Marklight some time interval
tintZoom = irf.tint('2008-04-22T18:04:55.00Z/2008-04-22T18:10:05.05Z');
irf_pl_mark(h,tintZoom,'yellow');

% % change position of panels
plot_number=5;

for i=1:1:plot_number
    
    xwidth = 0.85;
    ywidth = 0.16;
    space_subplot=0.01;
    
    set(h(i),'position',[0.10 0.99-i*ywidth-i*space_subplot xwidth ywidth]);
    % irf_legend(h(i),plot_panel_mark(i),[0.99,0.98])
    
end

set(h,'Gridlinestyle','none');
set(h,'FontSize',14);
set(y_h,'FontSize',14)



%对齐 x y轴标注
%
irf_zoom(h(1:5),'x',tint);
irf_timeaxis(h(1:4),'nodate');   %timeaxis biao zhu
irf_timeaxis(h(1:4),'nolabels');
irf_pl_number_subplots(h,[0.94,0.97],'num','(?)');

irf_plot_axis_align(1,h(1:5));
irf_plot_ylabels_align(h);

hold(h(1),'on')

irf_plot(h(1),[B1gsm(1,1) 0;B1gsm(end,1) 0],'k','LineStyle','--')              %draw y=0 line

% set(h,'Gridlinestyle','none','GridAlpha',0.01);
set(h,'Gridlinestyle','none');  %remove grid

%% adjust colorbar
for i=1:1:plot_number
    colormap(h(i),'jet');
    %colorbar(h(i),'EastOutside')
    %colorbar(h(i),'Position',[0.1 0.5 0.5 0.6]);  %da xiao
    
    % % change position of panel
    positon_plot=h(i).Position;
    set(h(i),'position',[positon_plot(1)-0.03 positon_plot(2)-0.006*i positon_plot(3) positon_plot(4)]);
    set(h(i),'color','w');
    set(hcb(i),'position',[positon_plot(1)-0.03 positon_plot(2)-0.006*i positon_plot(3)-0.1 positon_plot(4)]);%colorbar
    
end

%% add position markers to x labels, remove UT date at bottom and add at top
R=irf_get_data('sc_r_xyz_gse__C1_CP_AUX_POSGSE_1M','caa','mat');
irf_timeaxis(h(end),'usefig',[R(:,1) R(:,2:4)/6371.2],...
    {'X [Re] GSE','Y [Re] GSE','Z [Re] GSE'})
irf_timeaxis(h(end),'nodate')
title(h(1),irf_time(tint(1),'yyyy-mm-dd'))

%% %%%%%%%%%%%%%%%%%%%%%%
% add tmarks and mark intervals
% add line marks
tmarks=irf_time([2002 8 21 7 53 15;2002 8 21 7 53 55]);
irf_pl_mark(h,tmarks,'black','LineWidth',0.5)
text_tmarks={'A','B','C','D','E'};
ypos=ylim(h(1));ypos(2)=ypos(2);ypos(1)=[];
for j=1:length(tmarks)
    irf_legend(h(1),text_tmarks{j},[tmarks(j) ypos],'horizontalalignment','center');
end

irf_pl_number_subplots(h,[0.94,0.97],'num','(?)');


%%  initialize_figure
number_of_subplots=6;
figure
set(gcf,'color','white'); % white background for figures (default is grey)
set(gcf,'renderer','zbuffer'); % opengl has problems on Mac (no log scale in spectrograms)
set(gcf,'PaperUnits','centimeters');
set(gcf,'defaultlinelinewidth',1.0);
set(gcf,'defaultAxesFontSize',14);
set(gcf,'defaultTextFontSize',14);
set(gcf,'defaultAxesFontUnits','pixels');
set(gcf,'defaultTextFontUnits','pixels');
set(gcf,'defaultAxesColorOrder',[0 0 0;0 0 1;1 0 0;0 0.5 0;0 1 1 ;1 0 1; 1 1 0])

xSize = 10;
ySize = 5+5*sqrt(number_of_subplots);
xLeft = (21-xSize)/2; yTop = (30-ySize)/2;
set(gcf,'PaperPosition',[xLeft yTop xSize ySize])
sz=get(0,'screensize');
xx=min(min(600,sz(3))/xSize,min(900,sz(4))/ySize); % figure at least 600 wide or 900 height but not outside screen
set(gcf,'Position',[10 10 xSize*xx ySize*xx])
clear xSize sLeft ySize yTop

for j=1:number_of_subplots,
    c(j)=irf_subplot(number_of_subplots,1,-j);
    cla(c(j));
    set(c(j),'tag','');
end
user_data = get(gcf,'userdata');
user_data.subplot_handles = c;
user_data.current_panel=0;
set(gcf,'userdata',user_data);
figure(gcf); % bring figure to front

if isempty(findobj(gcf,'type','uimenu','label','&Options'))
    hcoordfigmenu=uimenu('Label','&Options');
    uimenu(hcoordfigmenu,'Label','Start time','Callback','irf_widget_omni(''new_start_time'')')
    uimenu(hcoordfigmenu,'Label','Time interval','Callback','irf_widget_omni(''new_time_interval'')')
    user_data = get(gcf,'userdata');
    user_data.coordfigmenu=1;
    set(gcf,'userdata',user_data);
end

%% initial multi plot
plot_number=6;
plot_row=2;
plot_col=3;
xstar=0.48;
ystar=0.9;
xwidth = 0.13;
ywidth = 0.32;
pos_init=[xstar ystar xwidth ywidth];
space_subplot_x=0.02;
space_subplot_y=0.05;
space_subplot=[space_subplot_x space_subplot_y];
plot_sort=0;% plot follow row
pos_panel=caculate_multiplot_position(plot_row,plot_col,plot_number,pos_init,space_subplot,plot_sort);



%% printing the figure save
if 0,
    set(gcf,'PaperPositionMode','auto');   %same paper as on screen
    
    figname=['figure'] ;
    % % to get bitmap file
    % print(gcf, '-dpng','-painters', [figname '.png']);
    % % print(gcf, '-dpsc','-painters', [figname '.ps']);
    %
    % % to get pdf file with no white margins pint to eps and convert after
    % print(gcf, '-depsc2','-painters', [figname '.eps']);
    
    print(gcf, '-dpdf','-painters', [figname '.pdf']);
    
end






