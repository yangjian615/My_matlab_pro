% Example of how to plot points on a Mercator Map
%
% Aknowledgements: stackoverflow
% Aknowledgements: Amro
% Source: http://stackoverflow.com/questions/11655532/plot-geo-locations-on-worldmap-with-matlab

%# world map in Mercator projection
f=filesep;
imageFilename = ['mercatorPlots' f 'Mercator-projection.jpg'];
img = imread(imageFilename);
[imgH, imgW, ~] = size(img);
image(1:imgW/2,1:imgH,img(1:end,1:imgW/2,:)); hold on;

xticks = [2; 88; 172; 258; 342; 428; 512; 598; 684; 770; 854; 938; 1024; 1112; 1196; 1280; 1366; 1452; 1536; 1622; 1708; 1792; 1876; 1962; 2048];
yticks = [134; 366; 508; 614; 708; 794; 880; 974; 1082; 1222; 1454];
xl = [(180:15:359)';(0:15:180)'];
xticklabels = num2str(xl,'%d');
yticklabels = num2str((75:-15:-75)','%d');
set(gca,'xtick',xticks,'xticklabel',xticklabels,'ytick',yticks,'yticklabel',yticklabels);
xlabel('Longitude');
ylabel('Latitude');

% plotting points ...
[x, y] = mercatorProjection(265.34, 53.856, imgW, imgH);
plot(x,y, 'ob', 'MarkerSize',10, 'LineWidth',3);
text(x, y, 'ISLL', 'Color','w', 'VerticalAlign','bottom', 'HorizontalAlign','right')

[x, y] = mercatorProjection(265.920, 58.763, imgW, imgH);
plot(x,y, 'ob', 'MarkerSize',10, 'LineWidth',3);
text(x, y, 'FCHU', 'Color','w', 'VerticalAlign','bottom', 'HorizontalAlign','right')

[x, y] = mercatorProjection(220.89, 64.048, imgW, imgH);
plot(x,y, 'ob', 'MarkerSize',10, 'LineWidth',3);
text(x, y, 'DAWS', 'Color','w', 'VerticalAlign','bottom', 'HorizontalAlign','right')

hold off;

