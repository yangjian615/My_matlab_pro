function plotProbePositions(shot)
% plotProbePositions(shot)
%
% plot magnetic and Langmuir probe positions for a given shot
%
% Jan. 2016, Adrian von Stechow

conf    = initMRX;
d       = loadMRXshot(shot,conf);
m       = d.MagProbes;
l       = d.LangData;

figure(1481)
clf

for i=1:8
    plot(m(i).By.z,m(i).By.x,'r.')
    hold on
    plot(m(i).Bx.z,m(i).Bx.x,'b.')
    plot(m(i).Bz.z,m(i).Bz.x,'k.')
end

for i=1:4
    plot(l(i).Z,l(i).R,'o')
end

hline(0.375)
axis image

labels('','Z','R')