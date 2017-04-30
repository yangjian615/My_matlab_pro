% 2D lat/lon plot of Earth's magnetic field strength at given altitude.
% Also plots direction in quiver plot.

clear all;

% array of latitudes and longitudes of satellite
lats = -60:2:60;
lons = -180:2:180;

% altitude of satellite
sat_alt = 750;

% load IGRF coefficients
date = datenum(2014,12,31,0,0,0);     % can be a datenum or datevec
global gh;
gh = loadigrfcoefs(date);
  

Bsat = zeros(length(lats),length(lons));
Bdir = zeros(length(lats),length(lons),2);

for i = 1:length(lats),

    for j = 1:length(lons),
        
        B1 = igrf(gh,lats(i),lons(j),sat_alt,'geodetic');
        Bsat(i,j) = norm(B1);
        Bdir(i,j,1) = B1(1);
        Bdir(i,j,2) = B1(2);
        
    end
    
end


%% PLOTTING


h1 = figure(1);
set(h1,'position',[100 50 1200 900]);
ax1 = subplot(211);
ax2 = subplot(212);

imagesc(lons,lats,Bsat*1e-3,'parent',ax1);
hold(ax1,'on');
title(ax1,sprintf('Magnetic Field intensity at %d km Altitude',...
    sat_alt));

load coast;
plot(ax1,long,lat,'w');
axis(ax1,'xy');
cax1 = colorbar('peer',ax1);
ylabel(cax1,'B-field in thousands of nT');

quiver(ax2,lons,lats,Bdir(:,:,2),Bdir(:,:,1),'r');
hold(ax2,'on');
title(ax2,sprintf('Magnetic Field direction at %d km Altitude',...
    sat_alt));

plot(ax2,long,lat,'k');
axis(ax2,'xy');
cax2 = colorbar('peer',ax2);
ylabel(cax2,'B-field in thousands of nT');
