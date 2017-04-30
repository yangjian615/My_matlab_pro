% file='C:\Users\dell\Desktop\c1 data\EFW\C1_CP_EFW_L2_P\C1_CP_EFW_L2_P__20061014_073851_20061014_074051_V101216.cdf'
file='C:\Users\dell\Desktop\c1 data\EFW\C1_CP_EFW_L2_P\C1_CP_EFW_L2_P__20010731_201417_20010731_201617_V110503.cdf'
%Spacecraft_potential=irf_cdf_read(file,'Spacecraft_potential__C1_CP_EFW_L2_P');
%data=cdfread(file'Structure',true);
% data=cdfread(file);
% DATENUM=EPOCH16toDATENUM(data(:,1));
% time_epoch=IRF_TIME(DATENUM,'datenum2cdfepoch');
% 
% [y,m,d,h,mi,s]=datevec(DATENUM);
% efw_time=h*3600+mi*60+s;
% Vps=double(cell2mat(data(:,2)));
% a=[time_epoch,Vps];
% Vps1=c_efw_wash_scp(a);
% ne=c_efw_scp2ne(Vps);


data_obj=dataobj(file);
vps=getmat(data_obj,'Spacecraft_potential__C1_CP_EFW_L2_P');
time=getmat(data_obj,'time_tags__C1_CP_EFW_L2_P');
DATENUM=IRF_TIME(time,'datenum');
time_epoch=IRF_TIME(DATENUM,'datenum2epoch');

[y,m,d,h,mi,s]=datevec(DATENUM);
efw_time=h*3600+mi*60+s;
Vps1=c_efw_wash_scp(vps);
ne=c_efw_scp2ne(Vps1);
data=[efw_time vps(:,2) ne(:,2)];
save('C:\Users\dell\Desktop\c1 data\EFW_electron_density_20010731201417.txt','data','-ascii')
%save('C:\Users\dell\Desktop\EFW_electron_density.txt','-ascii')

