% test function for lossconeangle2

clear all;

% array of latitudes and longitudes of satellite
lats = -60:2:60;
lons = -180:2:180;

% altitude of satellite and mirror altitude
sat_alt = 750;
mir_alt = 110;

% trace step size in km for following field line to mirror point
tracestepsize = 2;

% load IGRF coefficients
date = datenum(2014,12,31,0,0,0);     % can be a datenum or datevec
global gh;
gh = loadigrfcoefs(date);

outfile = sprintf('Output%03d_%02d.mat',sat_alt,tracestepsize);
if exist(outfile,'file'),
    load(outfile);
else
    
    % okay, do the loop
    
    % magnetic field at the satellite
    Bsat = zeros(length(lats),length(lons));
    % Bmir includes mirror field at both ends of field line
    Bmir = zeros(length(lats),length(lons),2);
    % lca is loss cone angle, determined from minimum of two elements in Bmir
    lca = zeros(length(lats),length(lons));
    % hemi is an array of ones (for N) and twos (for S), determining which
    % hemisphere has the minimum Bmir
    hemi = zeros(length(lats),length(lons));
    
    tloop = tic;
    
    for i = 1:length(lats),
        
        tstart = tic;
        fprintf('Doing lat %d of %d...',i,length(lats));
        for j = 1:length(lons),
            
            [Bsat(i,j),Bmir(i,j,:)] = lossconeangle3(gh,lats(i),lons(j),sat_alt,mir_alt,tracestepsize);
            [chooseB,hemi(i,j)] = min(Bmir(i,j,:));
            lca(i,j) = asind(sqrt(Bsat(i,j)/chooseB));
        end
        timespent = toc(tstart);
        fprintf('Took %.2f seconds\n',timespent);
        
    end
    
    fulltime = toc(tloop);
    fprintf('Finished all latitudes: Total time is %.2f minutes\n',fulltime/60);
    
    save(outfile,'lats','lons','sat_alt','mir_alt','Bsat','Bmir','lca','hemi');
    
end

%% PLOTTING


h1 = figure(1);
set(h1,'position',[100 50 1200 900]);
ax1 = subplot(221);
ax2 = subplot(222);
ax3 = subplot(223);
ax4 = subplot(224);

imagesc(lons,lats,Bsat*1e-3,'parent',ax1);
hold(ax1,'on');
title(ax1,sprintf('Magnetic Field intensity at %d km Altitude',...
    sat_alt));

load coast;
plot(ax1,long,lat,'w');
axis(ax1,'xy');
cax1 = colorbar('peer',ax1);
ylabel(cax1,'B-field in thousands of nT');

imagesc(lons,lats,min(Bmir,[],3)*1e-3,'parent',ax2);
hold(ax2,'on');
title(ax2,sprintf('Magnetic Field intensity at %d km Mirror Point',...
    mir_alt));

plot(ax2,long,lat,'w');
axis(ax2,'xy');
cax2 = colorbar('peer',ax2);
ylabel(cax2,'B-field in thousands of nT');

imagesc(lons,lats,hemi,'parent',ax3);
hold(ax3,'on');
title(ax3,'Hemisphere of minimim magnetic field');
plot(ax3,long,lat,'w');
axis(ax3,'xy');
cax3 = colorbar('peer',ax3);
ylabel(cax3,'Ratio');
set(cax3,'ytick',[1 2],'yticklabel',[{'NH'} {'SH'}]);

imagesc(lons,lats,real(lca),'parent',ax4);
hold(ax4,'on');
title(ax4,sprintf('Loss Cone Pitch Angle for %d km Altitude Satellite',...
    sat_alt));

plot(ax4,long,lat,'w');
axis(ax4,'xy');
cax4 = colorbar('peer',ax4);
ylabel(cax4,'Loss Cone Pitch Angle (deg)');
caxis(ax4,[min(min(lca)) 75]);

%% locate minimum lca and maximum outside dead zone

[mm,ii] = min(lca(:));
[ix,iy] = ind2sub(size(lca),ii);
scatter(lons(iy),lats(ix),'ro','filled','parent',ax4);
t1 = text(lons(iy)-20,lats(ix)+10,sprintf('Min alpha \n= %.2f deg',mm),...
    'parent',ax4,'Color','r');

maxlat = -15;
maxind = find(lats < maxlat,1,'last');
lcasouth = lca(1:maxind,:);

[mm,ii] = max(lcasouth(:));
[ix,iy] = ind2sub(size(lcasouth),ii);
scatter(lons(iy),lats(ix),'ro','filled','parent',ax4);
t1 = text(lons(iy)-20,lats(ix)+10,sprintf('Max alpha \n= %.2f deg',mm),...
    'parent',ax4,'Color','r');