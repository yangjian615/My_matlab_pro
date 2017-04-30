% test function for lossconeangle2

clear all;

% array of latitudes and longitudes of satellite
lats = -70:0.5:70;
lons = -180:0.5:180;

% altitude of satellite and mirror altitude
alt = 100;

% trace step size in km for following field line to mirror point
tracestepsize = 5;

% load IGRF coefficients
date = datenum(2012,8,31,0,0,0);     % can be a datenum or datevec
global gh;
gh = loadigrfcoefs(date);

outfile = ['LshellMap-' datestr(date,1) '.mat'];
if exist(outfile,'file'),
    load(outfile);
else
    
    % initialize array of L-shell values
    L = zeros(length(lats),length(lons));
    
    tloop = tic;
    
    for i = 1:length(lats),
        
        tstart = tic;
        fprintf('Doing lat %d of %d...',i,length(lats));
        for k = 1:length(lons),
            
            thisL = findLvalue(gh,lats(i),lons(k),alt,tracestepsize);
            L(i,k) = thisL;
        end
        timespent = toc(tstart);
        fprintf('Took %.2f seconds\n',timespent);
        
    end
    
    fulltime = toc(tloop);
    fprintf('Finished all latitudes: Total time is %.2f minutes\n',fulltime/60);
    
    save(outfile,'L','lats','lons','alt','date');
    
end

%% PLOTTING


h1 = figure(1);
set(h1,'position',[100 250 1200 600]);
ax1 = axes;
set(ax1,'FontName','Times','Fontsize',12);

V = [1 1.2 1.5 2 2.5 3 4 5 6 7 8];
[mlats,mlons] = meshgrid(lats,lons);
[C,hc] = contourf(mlons,mlats,L',V,'parent',ax1);
set(hc,'ShowText','on','TextStep',get(hc,'LevelStep')*1)
ht = clabel(C,hc);
set(ht,'FontName','Times','Fontsize',12);
hold(ax1,'on');
title(ax1,sprintf('L-shell for Altitude %d km: %s',alt,datestr(date,1)),...
    'FontName','Times','Fontsize',14);

load coast;
plot(ax1,long,lat,'w');
axis(ax1,'xy');
%cax1 = colorbar('peer',ax1);
caxis(ax1,[0 8]);
xlabel(ax1,'Longitude','FontName','Times','Fontsize',14);
ylabel(ax1,'Latitude','FontName','Times','Fontsize',14);
