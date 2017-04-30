c  = initMRX;
db = load(c.dbPath);

figure(872)

for n = 3%2:5
    
    csZero  = load(fullfile(c.basePath,['CSData_' num2str(n) '_1']));
    csShift = load(fullfile(c.basePath,['CSData_' num2str(n) '_2']));
    x = 0.32:0.005:0.43;
    z = -0.09:0.01:0.12;
    
    [shots,pos,fcshift] = eval(['shotListHighGFScan_' num2str(n)]);
    f = load(c.(['highGfFlucDataPath' num2str(n)]));
    
    clear flucProbePos shift
    for i=1:length(f.shot)
        % get radial position of fluctuation probe for saved shots
        flucProbePos(i) = pos(shots==f.shot(i));
        % get flux core shift
        shift(i)= fcshift(shots == f.shot(i));
    end
    
    rPos = unique(flucProbePos);
    
    for i = 1:length(rPos)
%         f.meanBr(i) = mean(f.Br(flucProbePos==rPos(i)));
%         f.meanBy(i) = mean(f.By(flucProbePos==rPos(i)));
        f.meanBz(i,1) = mean(f.Bz(flucProbePos==rPos(i) & shift==0));
        f.meanBz(i,2) = mean(f.Bz(flucProbePos==rPos(i) & shift~=0));
%         f.meanEy(i) = mean(f.Ey(flucProbePos==rPos(i)));
    end

    clf
    
    % plot fluctuation amplitudes
    plot(flucProbePos(shift==0),f.Bz(shift==0),'.b')
    hold on
    plot(flucProbePos(shift~=0),f.Bz(shift~=0),'.r')
    
    % plot mean fluctuation amplitudes
    ph(1) = plot(rPos,f.meanBz(:,1),'b');
    ph(2) = plot(rPos,f.meanBz(:,2),'r');
    
    % plot current sheet profile
    ph(3) = plot(x*100,-csZero.Jy(:,ind_get(z,-0.01))/1e5,'--b');
    ph(4) = plot(x*100,-csShift.Jy(:,ind_get(z,-0.01))/1e5,'--r');

    legend('flucs fc0','flucs fc3','j fc0','j fc3')
    labels(['Bz fluctuation amplitude, scan #' num2str(n)],'R [cm]','amplitude [a.u.]')
    ezpdf(872,['plots/fluctuations/flucAmpVsPos_' num2str(n)],'f',1)
end
dockfigs(872)