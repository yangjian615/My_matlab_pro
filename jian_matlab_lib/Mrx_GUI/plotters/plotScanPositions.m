function plotScanPositions
% plotScanPositions
%
% plot the probe positions used in the guide field scans
%
% Jan. 2016, Adrian von Stechow

figure(41992)
clf

d = load('Y:\mrxdata\ProcessedDataFiles\Processed_Data_167750.mat');

% magnetic probes
for i=1:8
    plot(d.MagProbes(i).By.z,d.MagProbes(i).By.x,'r.')
    hold on
    plot(d.MagProbes(i).Bx.z,d.MagProbes(i).Bx.x,'b.')
    plot(d.MagProbes(i).Bz.z,d.MagProbes(i).Bz.x,'k.')
end

for i=1:3
    plot(d.LangData(i).Z,d.LangData(i).R,'o')
    plot(d.LangData(i).Z,d.LangData(i).R+2e-2,'o')
    plot(d.LangData(i).Z,d.LangData(i).R-2e-2,'o')
    plot(d.LangData(i).Z,d.LangData(i).R-4e-2,'o')
    plot(d.LangData(i).Z,d.LangData(i).R-6e-2,'o')
end

% fixed langmuir probe
plot(d.LangData(4).Z,d.LangData(4).R,'x')
text(d.LangData(4).Z,d.LangData(4).R,'LP4','horizontal','right','vertical','top')

% fixed vph probe
plot(-0.045,0.375,'^r')
text(-0.045,0.375,'vph','horizontal','right','vertical','top')

% fluctuation probe
plot(0.015,[0.335:0.02:0.415],'^')
text(0.015,0.375,'FP','horizontal','right','vertical','top')

hline(0.375)
vline(0)
labels('','Z','R')
axis image

ezpdf15(41992,'scanpositions',[320 240]*1.5,'f',1)
dockfigs(41992)