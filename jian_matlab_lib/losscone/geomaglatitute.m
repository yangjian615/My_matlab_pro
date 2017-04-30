% test function for lossconeangle2

clear all;

if(exist('MagLat.mat','file')),
    load('MagLat.mat');
else
    
    % array of latitudes and longitudes of satellite
    lats = -60:2:60;
    lons = -180:2:180;
    
    % altitude of satellite and mirror altitude
    sat_alt = 750;
    
    % trace step size in km for following field line to mirror point
    tracestepsize = 10;
    
    % load IGRF coefficients
    date = datenum(2014,12,31,0,0,0);     % can be a datenum or datevec
    global gh;
    gh = loadigrfcoefs(date);
    
    
    % initiialze vector of latitudes
    maglat = zeros(length(lats),length(lons));
    
    tloop = tic;
    
    for i = 1:length(lats),
        
        fprintf('Doing lat %d of %d...\n',i,length(lats));
        for j = 1:length(lons),
            maglat(i,j) = getmaglat(gh,lats(i),lons(j),sat_alt,tracestepsize);
        end
        
    end
    
    fulltime = toc(tloop);
    fprintf('Finished all latitudes: Total time is %.2f minutes\n',fulltime/60);
    
    outfile = 'MagLat.mat';
    save(outfile,'lats','lons','maglat');
    
end

%% PLOTTING


h1 = figure(1);
set(h1,'position',[100 50 1200 800]);
ax1 = axes;

latcontours = [10 15 20 25 30 35 40 45 50 55 60];
[cs,ch] = contourf(ax1,lons,lats,maglat,latcontours);
clabel(cs,ch,'Fontsize',12,'Color','w');
hold(ax1,'on');
title(ax1,'Magnetic Latitude on the ground');
xlabel(ax1,'Geographic Longitude');
ylabel(ax1,'Geographic Latitude');

load coast;
plot(ax1,long,lat,'w');
axis(ax1,'xy');
cax1 = colorbar('peer',ax1);
ylabel(cax1,'Magnetic Latitude');
