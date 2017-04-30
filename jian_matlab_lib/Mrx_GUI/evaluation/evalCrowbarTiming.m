function evalCrowbarTiming
% evaluates shots from shotsdb (populated in mrxGUI)
% copy of evalGuideFieldShots on 151109

writePDF      = 1; % save to PDF
plotLabels    = 1; % plot labels next to points
plotDiscarded = 0; % plot shots that were discarded in mrxGUI

conf = initMRX;

m = load(conf.dbPath);

range = find(m.shot==167611):find(m.shot==167630);

colors = [ones(5,1)*1 ones(5,1)*2 ones(5,1)*3 ones(5,1)*4];

if ~plotDiscarded
    range = range(~m.marked(range));
end

figure(1)

xData = m.By(range)./m.Bzup(range);
yData = -m.Ey(range);
axisLabels = {'unnormalized rec. rate, shots 167611-167630','B_y/B_z','E_y [V/m]'};
fileName   = 'Ey_vs_GF';
plotThings(xData,yData,num2str(m.shot(range)),axisLabels,plotLabels,writePDF,fileName,colors(range-40))

figure(2)

yData = -m.Ey(range)./m.Bzup(range)*1000./v_alfven(m.Bzup(range)/1000,m.ne(range)*1e19,4);
% yData = -m.Ey(range)./v_alfven(m.Bzup(range)/1000,m.ne(range)*1e19,4);
axisLabels = {'normalized rec. rate, shots 167611-167630','B_y/B_z','E/(B_{up}v_A)'};
fileName   = 'Enorm_vs_GF';
plotThings(xData,yData,num2str(m.shot(range)),axisLabels,plotLabels,writePDF,fileName,colors(range-40))

figure(3)

yData = v_alfven(m.Bzup(range)/1000,m.ne(range)*1e19,4)/1e3;
axisLabels = {'alfven velocity, shots 167611-167630','B_y/B_z','v_A [km/s]'};
fileName   = 'vA_vs_GF';
plotThings(xData,yData,num2str(m.shot(range)),axisLabels,plotLabels,writePDF,fileName,colors(range-40))

figure(4)

yData = m.Bzup(range);
axisLabels = {'upstream B, shots 167611-167630','B_y/B_z','B_{up} [mT]'};
fileName   = 'Bzup_vs_GF';
plotThings(xData,yData,num2str(m.shot(range)),axisLabels,plotLabels,writePDF,fileName,colors(range-40))

figure(5)

yData = m.ne(range);
axisLabels = {'CS density, shots 167611-167630','B_y/B_z','n_e [10^{19}m^{-3}]'};
fileName   = 'ne_vs_GF';
plotThings(xData,yData,num2str(m.shot(range)),axisLabels,plotLabels,writePDF,fileName,colors(range-40))

figure(6)

yData = -m.I(range);
axisLabels = {'total current, shots 167611-167630','B_y/B_z','I [kA]'};
fileName   = 'I2D_vs_GF';
plotThings(xData,yData,num2str(m.shot(range)),axisLabels,plotLabels,writePDF,fileName,colors(range-40))

figure(7)

yData = -m.j(range);
axisLabels = {'X-point current density, shots 167611-167630','B_y/B_z','j [MA/m^2]'};
fileName   = 'jx_vs_GF';
plotThings(xData,yData,num2str(m.shot(range)),axisLabels,plotLabels,writePDF,fileName,colors(range-40))

figure(8)

yData = m.Ey(range)./m.j(range)./1e6./eta_spitzer(m.Te(range),m.ne(range)*1e19,1)*2;
% *2 for parallel spitzer resistivity
axisLabels = {'anomalous resistivity, shots 167611-167630','B_y/B_z','E/(\eta j)'};
fileName   = 'anomalous_vs_GF';
plotThings(xData,yData,num2str(m.shot(range)),axisLabels,plotLabels,writePDF,fileName,colors(range-40))

% figure(9)
% 
% yData = m.Te(range);
% axisLabels = {'anomalous resistivity, shots 167611-167630','B_y/B_z','E/(\eta j)'};
% fileName   = 'anomalous_vs_GF';
% plotThings(xData,yData,num2str(m.shot(range)),axisLabels,plotLabels,writePDF,fileName,colors(range))


dockfigs

function plotThings(xData,yData,texts,axisLabels,plotLabels,writePDF,fileName,colors)
clf
c = lines(4);
for i=1:length(yData)
    plot(xData(i),yData(i),'.','Markersize',10,'color',c(colors(i),:))
    hold on
end
labels(axisLabels{1},axisLabels{2},axisLabels{3})
if plotLabels
    text(xData,yData,texts, 'horizontal','left', 'vertical','bottom');
end
if writePDF
    ezpdf(fullfile(fileparts(mfilename('fullpath')),'plots/crowbareval/',fileName),[320 240]*1.5,'f',1)
end