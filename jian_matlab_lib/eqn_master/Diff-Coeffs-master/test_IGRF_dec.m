% Test how much IGRF declination values change within a day

target_day = datenum(2003,1,1);
d = nan(24,1);

alt = 0;
lat = 85;
lon = 30;

for i=1:24
    [~, ~, dec] = igrf11magm(alt, lat, lon, decyear(target_day + (i-1)/24));
    d(i) = dec
end

plot(1:24, d);

% Max diff within the same day ~ 0.001 of a degree, for locations at very
% high latitudes(~85 deg).