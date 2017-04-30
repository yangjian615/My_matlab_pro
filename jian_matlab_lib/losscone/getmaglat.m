% calculate loss cone angle at given location in space

function latout = getmaglat(gh,lat,lon,alt,tracestepsize)



[newlatN,newlon] = igrftracetoalt(gh,lat,lon,alt,'geodetic',0,'N',tracestepsize);
%B0 = igrf(gh,newlat,newlon,basealt,'geodetic');
%Bmir(1) = norm(B0);

% if angle is heavily negative, trace South until it hits basealt
[newlatS,newlon] = igrftracetoalt(gh,lat,lon,alt,'geodetic',0,'S',tracestepsize);
%B0 = igrf(gh,newlat,newlon,basealt,'geodetic');
%Bmir(2) = norm(B0);

% super sketchy:
% I'm going to claim that the magnetic latitude is half the difference
% between the latitudes at the southern and northern ends of the field
% line. 

latout = 0.5*(newlatN - newlatS);