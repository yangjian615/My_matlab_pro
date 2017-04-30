c = initMRX;

d = load(c.dbPath);


shotlist = [shotListHighGFScan_1 shotListHighGFScan_2 shotListHighGFScan_3 shotListHighGFScan_4 shotListHighGFScan_5 168857:169010 169048:169147];

ind      = ind_get(d.shot,shotlist);

edges    = cumsum([67 97 111 82 88 154 100]);

figure(1)

clf
plot(d.Bzup(ind),'.')
xlim([0 700])
hold on
vline(edges)
labels('upstream B','shot index','B_z [mT]')
ezpdf(1,'plots/allshots/Bzup','f',1)

figure(2)

clf
plot(d.By(ind),'.')
xlim([0 700])
ylim([-40 5])
hold on
vline(edges)
labels('guide field','shot index','B_y [mT]')
ezpdf(2,'plots/allshots/By','f',1)

figure(3)

clf
plot(d.By(ind)./d.Bzup(ind),'.')
xlim([0 700])
ylim([-2 1])
hold on
vline(edges)
labels('normalized guide field','shot index','')
ezpdf(3,'plots/allshots/Bynorm','f',1)

figure(4)

clf
plot(-d.I(ind),'.')
xlim([0 700])
ylim([0 9])
hold on
vline(edges)
labels('total plasma current','shot index','I [kA]')
ezpdf(4,'plots/allshots/Iy','f',1)

figure(5)

clf
plot(-d.Ey(ind),'.')
xlim([0 700])
ylim([0 300])
hold on
vline(edges)
labels('physical recon. rate','shot index','E [V/m]')
ezpdf(5,'plots/allshots/Ey','f',1)

figure(6)

recrate = -d.Ey(ind)./d.Bzup(ind)*1000./real(v_alfven(d.Bzup(ind)/1e3,d.ne(ind)*1e19,4));
clf
plot(recrate,'.')
xlim([0 700])
ylim([0 1])
hold on
vline(edges)
labels('normalized recon. rate','shot index','')
ezpdf(6,'plots/allshots/recrate','f',1)

figure(7)

clf
plot(-d.j,'.')
xlim([0 700])
ylim([0 2])
hold on
vline(edges)
labels('current density','shot index','j [MA/m^2]')
% ezpdf(7,'plots/allshots/j','f',1)

figure(8)

vA = real(v_alfven(d.Bzup(ind)/1e3,d.ne(ind)*1e19,4));
clf
% plot(vA,'.')
plot(d.ne(ind)*1e19,'.')
xlim([0 700])
% ylim([0 1])
hold on
vline(edges)
labels('normalized recon. rate','shot index','')

dockfigs