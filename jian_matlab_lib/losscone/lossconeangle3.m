% calculate loss cone angle at given location in space

function [Bsat,Bmir] = lossconeangle3(gh,lat,lon,alt,basealt,tracestepsize)

% magnetic field components at given location
B1 = igrf(gh,lat,lon,alt,'geodetic');
Bsat = norm(B1);

% components
Bx = B1(1); % north component
By = B1(2); % east component
Bz = B1(3); % vertical component; positive down


[newlat,newlon] = igrftracetoalt(gh,lat,lon,alt,'geodetic',basealt,'N',tracestepsize);
B0 = igrf(gh,newlat,newlon,basealt,'geodetic');
Bmir(1) = norm(B0);

% if angle is heavily negative, trace South until it hits basealt
[newlat,newlon] = igrftracetoalt(gh,lat,lon,alt,'geodetic',basealt,'S',tracestepsize);
B0 = igrf(gh,newlat,newlon,basealt,'geodetic');
Bmir(2) = norm(B0);
