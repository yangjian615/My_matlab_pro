function plotMRXflucs(shot)
% plotMRXflucs(shot)
% 
% plot raw fluctuation signals for a given shot
% 
% Jan. 2016, Adrian von Stechow

% load data
c = initMRX;
db = load(c.dbPath);
f = getMRXflucs(shot);

% plot fluctuation probe data
figure(101)
clf
hold on
plot(f.time1,f.Br+3)
plot(f.time1,f.By+1)
plot(f.time1,f.Bz-1)
plot(f.time1,f.Ey-3)
ylim([-4 4])
vline(db.tSelect(db.shot==shot))
vline(db.tSelectFP(db.shot==shot),'r')
vline(db.tCross(db.shot==shot),'b')

legend('Br','By','Bz','Ey','location','west')
labels(int2str(shot),'t [µs]','U [V]')

% plot phase velocity probe data
figure(102)
clf
hold on
plot(f.time2(1:10:end),f.pref(1:10:end)+1.5)
plot(f.time2(1:10:end),f.pr(1:10:end)+0.5)
plot(f.time2(1:10:end),f.py(1:10:end)-0.5)
plot(f.time2(1:10:end),f.pz(1:10:end)-1.5)
ylim([-2 2])
vline(db.tSelect(db.shot==shot))
vline(db.tSelectPV(db.shot==shot),'r')
vline(db.tCross(db.shot==shot),'b')

legend('ref','r','y','z','location','west')
xlim([200 400])
labels(int2str(shot),'t [µs]','U [V]')

end