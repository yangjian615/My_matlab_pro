function evalHighGfLpScan(path,num)

%TODO cleanup!

% c    = initMRX;
% l    = load(c.highGfLangDataPath); % langmuir probe data
l    = load(path); % langmuir probe data
% f    = load(c.highGfFlucDataPath); % flucutations
% m    = load(c.dbPath);

num = num2str(num); % used in save path to choose different directories

% [list,pos]    = shotListHighGFScan1; % shots to consider


% todo: this doesn't belong here...

% % get radial position of fluctuation probe
% for i=1:length(f.shot)
%     flucProbePos(i) = pos(list==f.shot(i));
% end
% 
% rPos = unique(flucProbePos);
% for i = 1:length(rPos)
%     f.meanBr(i) = mean(f.Br(flucProbePos==rPos(i)));
%     f.meanBy(i) = mean(f.By(flucProbePos==rPos(i)));
%     f.meanBz(i) = mean(f.Bz(flucProbePos==rPos(i)));
%     f.meanEy(i) = mean(f.Ey(flucProbePos==rPos(i)));
% end

R = unique(l.R);
Z = unique(l.Z);

[neTrace,TeTrace] = deal(cell(length(R),length(Z)));

for ir = 1:length(R)
   for iz = 1:length(Z)
       idx              = l.R==R(ir) & l.Z==Z(iz);
       ne(ir,iz)        = mean(l.ne(idx));
       neMean(ir,iz)    = mean(l.neMean(idx));
       neMeanStd(ir,iz) = std(l.neMean(idx));
       neTrace{ir,iz}   = l.neTrace(idx);
       Te(ir,iz)        = mean(l.Te(idx));
       TeMean(ir,iz)    = mean(l.TeMean(idx));
       TeMeanStd(ir,iz) = std(l.TeMean(idx));
       TeTrace{ir,iz}   = l.TeTrace(idx);
       VfMean(ir,iz)    = mean(l.VfMean(idx));
       count(ir,iz)     = sum(idx);
       
   end
end

% plot density
figure(1)
clf
plotStuff(Z,R,neMean)
labels('n_e [10^{13} cm^{-3}]','x','y')
ezpdf15(1,['plots/2dscan_high_gf_' num '/ne_2d'],'f',1)
dockfigs(1)

% figure(11)
% errorbar([R; R; R]',neMean,neMeanStd/2)
% labels('std(n_e)','r','n_e [10^{13} cm^{-3}]')
% ezpdf(11,'plots/2dscan_high_gf/ne_2d_std_2','f',1)
% dockfigs(11)

% plot electron temperature
figure(2)
clf
plotStuff(Z,R,TeMean)
labels('T_e [eV]','x','y')
ezpdf15(2,['plots/2dscan_high_gf_' num '/Te_2d'],'f',1)
dockfigs(2)

% figure(12)
% errorbar([R; R; R]',TeMean,TeMeanStd/2)
% labels('std(T_e)','r','T_e [eV]')
% ezpdf(12,'plots/2dscan_high_gf/Te_2d_std_2','f',1)
% dockfigs(12)

% plot pressure profile
figure(3)
clf
plotStuff(Z,R,TeMean.*neMean)
labels('n_e T_e [eV]','x','y')
ezpdf15(3,['plots/2dscan_high_gf_' num '/pe_2d'],'f',1)
dockfigs(3)


% plot floating potential profile
figure(4)
clf
plotStuff(Z,R,VfMean)
labels('Vf [V]','x','y')
% ezpdf(4,'plots/2dscan_high_gf/pe_2d','f',1)
dockfigs(4)

% figure(10)
% clf
% imagesc(Z,R,count)
% axis image xy
% labels('# of datapoints','x','y')

% % plot fluctuation amplitude
% figure(5)
% clf
% plot(flucProbePos,f.Br,'o')
% hold on
% plot(rPos,f.meanBr)
% plot(rPos,f.meanBy)
% plot(rPos,f.meanBz)
% % plot(rPos,f.meanEy)
% 
% % plot(flucProbePos,f.By,'o')
% % plot(flucProbePos,f.Bz,'o')
% % plot(flucProbePos,f.Ey,'o')
% 
% labels('fluctuation amplitude','R [cm]','B [a.u.]')
% legend('Br','Br','By','Bz')
% ylim([0 22])
% % ezpdf(5,'plots/2dscan_high_gf/flucprofile','f',1)
% dockfigs(5)

figure(6)
clf
% plot individual time traces
interval = -20*0.4:0.4:20*0.4;

for iz = 1:length(Z)
    for ir = 1:length(R)
        subplot(length(R),length(Z),(ir-1)*length(Z)+iz)
        plot(interval,cell2mat(TeTrace{ir,iz}))
        title(['R ' num2str(R(ir)) ' Z ' num2str(Z(iz))])
        axis([-8 8 0 20])
    end
end

ezpdf(6,['plots/2dscan_high_gf_' num '/Te_singleplots'])
dockfigs(6)

figure(7)
clf
% plot individual time traces
interval = -20*0.4:0.4:20*0.4;

for iz = 1:length(Z)
    for ir = 1:length(R)
        subplot(length(R),length(Z),(ir-1)*length(Z)+iz)
        plot(interval,cell2mat(neTrace{ir,iz}))
        title(['R ' num2str(R(ir)) ' Z ' num2str(Z(iz))])
        axis([-8 8 0 10])
    end
end

ezpdf(7,['plots/2dscan_high_gf_' num '/ne_singleplots'])
dockfigs(7)

end

function plotStuff(Z,R,data)
contourfmod(Z,R,data)
% contourf(Z,R,data,40,'LineColor','None')
% meshc(Z,R,data)
vline(0)
hline(0.375)
% colorbar
% axis image xy
end