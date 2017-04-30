function [x,y] = mercatorProjection(lon, lat, width, height)
%mercatorProjection Converts [lon lat] coordinates to [x y] positions on a
%Mercator Map.
%
% stackoverflow
% answer by Amro
% http://stackoverflow.com/questions/11655532/plot-geo-locations-on-worldmap-with-matlab
%
 
    x = mod((lon+180)*width/360, width);
    y = height/2 - log(tan((lat+90)*pi/360))*width/(2*pi);
    
end