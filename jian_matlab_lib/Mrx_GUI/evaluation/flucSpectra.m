c = initMRX;
d = load(c.dbPath);

window = 5; % time window for spectra in µs

shotlist{1} = 167e3+[763:776];
shotlist{2} = 168e3+[158:168 200:206];
shotlist{3} = 168e3+[306:322 365:375];
shotlist{4} = 168e3+[440:446 448 481:488];
shotlist{5} = 168e3+[590:597 638:647];
shotlist{6} = 169e3+[049:098];
shotlist{7} = 169e3+[107:147];

NA = [1.143 1.192 1.094]; %Br, By, Bz

Bymean = [28 27 30 10 0 19 10]*1e-3;

%% main loop

clear BzSpec shot By

warning off; % suppress -v7.3 warning message

for n=1:7
    disp(int2str(n))
    for i=1:length(shotlist{n})
        w         = getMRXwavelet(shotlist{n}(i));
%         tSelect   = d.tSelect(d.shot==shotlist{n}(i));
        tSelect   = d.tSelectFP(d.shot==shotlist{n}(i));
        t1lo      = ind_get(w.t1,tSelect - window/2);
        t1hi      = ind_get(w.t1,tSelect + window/2);
        BzSpec{n}(i,:) = mean(abs(w.Bz(:,t1lo:t1hi)),2)./NA(3)./(2*pi*w.f1');
        shot{n}(i)     = shotlist{n}(i);
        By{n}(i)       = d.By(d.shot==shotlist{n}(i));
    end
    
end

warning on;

f = w.f1;

%%

figure(887)
clf

for i=6:7
    ph(i) = loglog(f,mean(BzSpec{i},1));
%     loglog(f,BzSpec{i});
%     ph(i) = loglog(f,mean(BzSpec{i},1).*f.^(1.4),'.-');
%     loglog(f,BzSpec{i})
    
    vline(f_ci(Bymean(i),4,1))
    vline(f_lh(2e19, Bymean(i),4,1))
    hold on
end

% legend(ph,'1','2','3','4','5')
xlim([3e5 2e7])
ylim([1e-10 1e-6])
% ylim([1e0 1e1])
labels('mean spectra','f [Hz]','B_z [a.u.]')
% labels('mean spectra','f [Hz]','B_z f^{1.4} [a.u.]')
legend(ph(6:7),'19 mT','10 mT')

ezpdf15(887,'plots/fluctuations/mean_spectra_new',[320 240]*1.5,'f',1)
dockfigs(887)

%%
figure(888)
clf
for n=6:7%1:5
    plot(By{n},sum(abs(BzSpec{n}(:,5:end))'),'o')
    hold on
end
labels('fluctuations 500kHz-10MHz, 37.5 cm','B_y [mT]','B_z [a.u.]')
ezpdf(888,'plots/fluctuations/flucAmpVsGF_new',[320 240]*1.5,'f',1)