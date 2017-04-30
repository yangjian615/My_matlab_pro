% calculate loss cone angle at given location in space

function L = findLvalue(gh,lat,lon,alt,tracestepsize)

% magnetic field components at given location
B1 = igrf(gh,lat,lon,alt,'geodetic');
Re = 6370;

% components
Bx = B1(1); % north component
By = B1(2); % east component
Bz = B1(3); % vertical component; positive down

% alt0 will be my "previous" altitude step
alt0 = alt;
lat0 = lat;
lon0 = lon;
alt_outN = alt0;
trueflag = 1;
while trueflag,
    [newlat,newlon,altitude] = igrftracestep(gh,lat0,lon0,alt0,'geodetic','N',tracestepsize);
    if altitude < alt0,
        trueflag = 0;
        alt_outN = alt0;
        %disp('found something N');
        break;
    else
        alt0 = altitude;
        lat0 = newlat;
        lon0 = newlon;
    end
end

% also go south
alt0 = alt;
alt_outS = alt;
trueflag = 1;
while trueflag,
    [newlat,newlon,altitude] = igrftracestep(gh,lat0,lon0,alt0,'geodetic','S',tracestepsize);
    if altitude < alt0,
        trueflag = 0;
        alt_outS = alt0;
        %disp('found something S');
        break;
    else
        alt0 = altitude;
        lat0 = newlat;
        lon0 = newlon;
    end
end

maxalt = max([alt_outN alt_outS]);

L = (maxalt + Re) / Re;
