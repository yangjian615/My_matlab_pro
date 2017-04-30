% shows how the X-point is pushed out of the current sheet during guide
% field reconnection and only at late time points settles near the center.
%
% Jan. 2016, Adrian von Stechow

c = initMRX;
m = loadMRXshot(168423,c); % GF -50
% m = loadMRXshot(168304,c); % GF -150

d = m.Interp_Data_YA(1,1);
t = 295:10:345;
% t = 295:10:305;


tInd = ind_get(m.time,t);

figure(28282)
clf

for i=1:length(tInd)
    
    % Jy
    subplot(length(tInd),4,i*4-3)
    imagesc(d.z,d.x,d.Jy(:,:,tInd(i)))
    hold on
    plot(d.Poloidal_Nulls.z(1,tInd(i)),d.Poloidal_Nulls.x(1,tInd(i)),'sw')
    axis image xy
    caxis([-1 1]*1e6)
    title(['JY ' int2str(t(i))])
    
    % Br
    subplot(length(tInd),4,i*4-2)
    imagesc(d.z,d.x,d.Bx(:,:,tInd(i)))
    hold on
    plot(d.Poloidal_Nulls.z(1,tInd(i)),d.Poloidal_Nulls.x(1,tInd(i)),'sk')
    axis image xy
    caxis([-1 1]*30e-3)
    title(['BR ' int2str(t(i))])
    
    % Bpol
    subplot(length(tInd),4,i*4-1)
    imagesc(d.z,d.x,sqrt(d.Bx(:,:,tInd(i)).^2+d.Bz(:,:,tInd(i)).^2))
    hold on
    plot(d.Poloidal_Nulls.z(1,tInd(i)),d.Poloidal_Nulls.x(1,tInd(i)),'sk')
    axis image xy
    caxis([-1 1]*30e-3)
    title(['Bpol ' int2str(t(i))])
    
    % By
    subplot(length(tInd),4,i*4-0)
    imagesc(d.z,d.x,d.By(:,:,tInd(i)))
    hold on
    plot(d.Poloidal_Nulls.z(1,tInd(i)),d.Poloidal_Nulls.x(1,tInd(i)),'sk')
    axis image xy
    caxis([-1 1]*30e-3)
    title(['BY ' int2str(t(i))])
end

colormap bluered

ezpdf15(28282,['plots/' int2str(m.shot) '_xPush'],[320*5 240*4],'f',1)
dockfigs(28282)