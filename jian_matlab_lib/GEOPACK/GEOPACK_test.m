function GEOPACK_test;
% function GEOPACK_test;
% ====testing of the coordinate transformations =============================
% and return to starting point for field-line trace

% 
%           print *, '   enter iyear,iday,ihour,min,isec'
%           read *, iyear,iday,ihour,min,isec
%           call recalc (iyear,iday,ihour,min,isec)
GEOPACK_RECALC(1999,305,3,45,22);

%           print *, '   enter xgeo,ygeo,zgeo'
%           read *, xgeo,ygeo,zgeo
xgeo = 1;
ygeo = 2;
zgeo = 3;

%           call geomag(xgeo,ygeo,zgeo,xmag,ymag,zmag,1)
[xmag,ymag,zmag] = GEOPACK_GEOMAG(xgeo,ygeo,zgeo,1);


%           call magsm (xmag,ymag,zmag,xsm,ysm,zsm,1)
[xsm,ysm,zsm] = GEOPACK_MAGSM(xmag,ymag,zmag,1);

%           call smgsm (xsm,ysm,zsm,xgsm,ygsm,zgsm,1)
[xgsm,ygsm,zgsm] = GEOPACK_SMGSM(xsm,ysm,zsm,1);

%           call geogsm(xgeo,ygeo,zgeo,xgsm1,ygsm1,zgsm1,1)
[xgsm1,ygsm1,zgsm1] = GEOPACK_GEOGSM(xgeo,ygeo,zgeo,1);

%           print *, '  compare (should be equal):'
%           print *, xgsm,ygsm,zgsm
%           print *, xgsm1,ygsm1,zgsm1
disp('compare, should be equal');
disp([xgsm,ygsm,zgsm;xgsm1,ygsm1,zgsm1]);

%           pause
% 
%           call geogsm (xgeo1,ygeo1,zgeo1,xgsm,ygsm,zgsm,-1)
[xgeo1,ygeo1,zgeo1] = GEOPACK_GEOGSM(xgsm,ygsm,zgsm,-1);
%           print *, '  compare (should be equal):'
%           print *, xgeo,ygeo,zgeo
%           print *, xgeo1,ygeo1,zgeo1
disp('compare, should be equal');
disp([xgeo,ygeo,zgeo;xgeo1,ygeo1,zgeo1]);

%           pause

%           print *, ' checking bcarsp, bspcar:'

%           call sphcar (r,t,f,xgeo,ygeo,zgeo,-1)
[r,t,f] = GEOPACK_SPHCAR(xgeo,ygeo,zgeo,-1);
%           call igrf_geo (r,t,f,br,bt,bf)
[br,bt,bf] = GEOPACK_IGRF_GEO(r,t,f);
%           call bspcar (t,f,br,bt,bf,bx,by,bz)
[bx,by,bz] = GEOPACK_BSPCAR(t,f,br,bt,bf);
%           call bcarsp (xgeo,ygeo,zgeo,bx,by,bz,br1,bt1,bf1)
[br1,bt1,bf1] = GEOPACK_BCARSP(xgeo,ygeo,zgeo,bx,by,bz);
%           print *, '  compare (should be equal):'
%           print *, br,bt,bf
%           print *, br1,bt1,bf1
%           pause
disp('compare, should be equal');
disp([br,bt,bf;br1,bt1,bf1]);

PARMOD = zeros(10,1);
GEOPACK_RECALC (1997,350,21,0,0);
PARMOD(1) = 3; % Solar Wind Ram Pressure, nPa
PARMOD(2) = -20; % Dst, nT
PARMOD(3) = 3; % By, GSM, nT
PARMOD(4) = -3; % Bz, GSM, nT


%  1        print *,
%      *'  enter Geographic Lat and Long of the starting footpoint (degs)'
%           read *, Geolat,Geolon

Geolat=62.;
Geolon=45.;

Ri=1.;

Xgeoi=Ri*cos(Geolat*0.01745329)*cos(Geolon*0.01745329);
Ygeoi=Ri*cos(Geolat*0.01745329)*sin(Geolon*0.01745329);
Zgeoi=Ri*sin(Geolat*0.01745329);

[Xgsmi,Ygsmi,Zgsmi] = GEOPACK_GEOGSM(Xgeoi,Ygeoi,Zgeoi,1);

DIR=1.;
RLIM=50.;
R0=1.;
IOPT=0;

[XF,YF,ZF,XX,YY,ZZ,L] = GEOPACK_TRACE(Xgsmi,Ygsmi,Zgsmi,DIR,RLIM,R0,IOPT,PARMOD,'T96','GEOPACK_IGRF_GSM');

% c   find the radial extent of the field line:

r=sqrt(XX.^2+YY.^2+ZZ.^2);
[rmax,imax] = max(r);
disp(sprintf('  at the field line apex: x,y,z=%f,%f,%f',XX(imax),YY(imax),ZZ(imax)));

RF=sqrt(XF.^2+YF.^2+ZF.^2);
if (RF>2.) ,
    disp('  the line is "open"');
else
    %     c
    %     c   Now go back to the starting footpoint along the same field line:
    %     c
    DIR=-1.;
    Xgsmi=XF;
    Ygsmi=YF;
    Zgsmi=ZF;
    
    [XF,YF,ZF,XX,YY,ZZ,L] = GEOPACK_TRACE(Xgsmi,Ygsmi,Zgsmi,DIR,RLIM,R0,IOPT,PARMOD,'T96','GEOPACK_IGRF_GSM');
    [Xgeo,Ygeo,Zgeo] = GEOPACK_GEOGSM(XF,YF,ZF,-1);
    [R,T,F] = GEOPACK_SPHCAR(Xgeo,Ygeo,Zgeo,-1);
    Geolatfi=90.-57.29578*T;
    Geolonfi=57.29578*F;
    
    disp(sprintf('Starting at: Lat = %f & Lon = %f',Geolat,Geolon));
    disp(sprintf('After going to the conjugate point and back: Lat = %f & Lon = %f', ...
        Geolatfi,   Geolonfi));
    disp(sprintf('number of points on the line:%d', L));
end    
% end of test
