function evalGuideFieldShots
% evaluates shots from shotsdb (populated in mrxGUI)

conf = initMRX;
m = load(conf.dbPath);

% shots to plot
range = find(m.shot==167242):find(m.shot==167630); % initial testing
% range = ind_get(m.shot,shotListHighGFScan); % high guide field LP scan

writePDF      = 1; % save to PDF
plotLabels    = 0; % plot labels next to points
plotDiscarded = 0; % plot shots that were discarded in mrxGUI



if ~plotDiscarded
    range = range(~m.marked(range));
end

figure(1)

xData = m.By(range)./m.Bzup(range);
% xData = m.By(range);
yData = -m.Ey(range);
axisLabels = {['unnormalized rec. rate, shots '...
    int2str(min(m.shot(range))) '-' int2str(max(m.shot(range)))],'B_y/B_z','E_y [V/m]'};
fileName   = 'Ey_vs_GF';
plotThings(xData,yData,num2str(m.shot(range)),axisLabels,plotLabels,writePDF,fileName)

figure(2)

yData = -m.Ey(range)./m.Bzup(range)*1000./real(v_alfven(m.Bzup(range)/1000,m.ne(range)*1e19,4));
% yData = -m.Ey(range)./v_alfven(m.Bzup(range)/1000,m.ne(range)*1e19,4);
axisLabels = {['normalized rec. rate, shots ' int2str(min(m.shot(range))) '-' int2str(max(m.shot(range)))],'B_y/B_z','E/(B_{up}v_A)'};
fileName   = 'Enorm_vs_GF';
plotThings(xData,yData,num2str(m.shot(range)),axisLabels,plotLabels,writePDF,fileName)

figure(3)

yData = real(v_alfven(m.Bzup(range)/1000,m.ne(range)*1e19,4))/1e3;
axisLabels = {['alfven velocity, shots ' int2str(min(m.shot(range))) '-' int2str(max(m.shot(range)))],'B_y/B_z','v_A [km/s]'};
fileName   = 'vA_vs_GF';
plotThings(xData,yData,num2str(m.shot(range)),axisLabels,plotLabels,writePDF,fileName)

figure(4)

yData = m.Bzup(range);
axisLabels = {['upstream B, shots ' int2str(min(m.shot(range))) '-' int2str(max(m.shot(range)))],'B_y/B_z','B_{up} [mT]'};
fileName   = 'Bzup_vs_GF';
plotThings(xData,yData,num2str(m.shot(range)),axisLabels,plotLabels,writePDF,fileName)

figure(5)

yData = m.ne(range);
axisLabels = {['CS density, shots ' int2str(min(m.shot(range))) '-' int2str(max(m.shot(range)))],'B_y/B_z','n_e [10^{19}m^{-3}]'};
fileName   = 'ne_vs_GF';
plotThings(xData,yData,num2str(m.shot(range)),axisLabels,plotLabels,writePDF,fileName)

figure(6)

yData = -m.I(range);
axisLabels = {['total current, shots ' int2str(min(m.shot(range))) '-' int2str(max(m.shot(range)))],'B_y/B_z','I [kA]'};
fileName   = 'I2D_vs_GF';
plotThings(xData,yData,num2str(m.shot(range)),axisLabels,plotLabels,writePDF,fileName)

figure(7)

yData = -m.j(range);
axisLabels = {['X-point current density, shots ' int2str(min(m.shot(range))) '-' int2str(max(m.shot(range)))],'B_y/B_z','j [MA/m^2]'};
fileName   = 'jx_vs_GF';
plotThings(xData,yData,num2str(m.shot(range)),axisLabels,plotLabels,writePDF,fileName)

figure(8)

% not quite correct: spitzer values should transistion from perp to par at
% higher guide fields, using parallel for all values here
yData = m.Ey(range)./m.j(range)./1e6./real(eta_spitzer(m.Te(range),m.ne(range)*1e19,1)*2);
axisLabels = {['anomalous resistivity, shots '...
    int2str(min(m.shot(range))) '-' int2str(max(m.shot(range)))],'B_y/B_z','E/(\eta_{||} j)'};
fileName   = 'anomalous_vs_GF';
plotThings(xData,yData,num2str(m.shot(range)),axisLabels,plotLabels,writePDF,fileName)

% figure(9)
% 
% yData = m.Te(range);
% axisLabels = {['anomalous resistivity, shots ' int2str(min(m.shot(range))) '-' int2str(max(m.shot(range)))],'B_y/B_z','E/(\eta j)'};
% fileName   = 'anomalous_vs_GF';
% plotThings(xData,yData,num2str(m.shot(range)),axisLabels,plotLabels,writePDF,fileName)


dockfigs

function plotThings(xData,yData,texts,axisLabels,plotLabels,writePDF,fileName)
clf
plot(xData,yData,'.','Markersize',10)
labels(axisLabels{1},axisLabels{2},axisLabels{3})
if plotLabels
    text(xData,yData,texts, 'horizontal','left', 'vertical','bottom');
end
if writePDF
    ezpdf(fullfile(fileparts(mfilename('fullpath')),'../plots/gfscan/',fileName),[320 240],'f',1)
end