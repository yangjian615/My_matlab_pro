function [XF,YF,ZF,XX,YY,ZZ,M] = Rc
%function [XF,YF,ZF,XX,YY,ZZ,M] = GEOPACK_EXAMPLE1;
%       PROGRAM EXAMPLE1
% XF,YF,ZF end of example field line trace (GSM)
% XX,YY,ZZ all points in field line trace (GSM)
% M index of last 'real' point in field line trace
% C
% C   IN THIS EXAMPLE IT IS ASSUMED THAT WE KNOW GEOGRAPHIC COORDINATES OF A FOOTPOINT
% C   OF A FIELD LINE AT THE EARTH'S SURFACE AND TRACE THAT LINE FOR A SPECIFIED
% C   MOMENT OF UNIVERSAL TIME, USING A FULL IGRF EXPANSION FOR THE INTERNAL FIELD
% C


%       DIMENSION XX(500),YY(500),ZZ(500), PARMOD(10)
PARMOD = zeros(10,1);
% c
% c    Be sure to include an EXTERNAL statement in your codes, specifying the names
% c    of external and internal field model subroutines in the package, as shown below.
% c    In this example, the external and internal field models are T96_01 and IGRF_GSM,
% c    respectively. Any other models can be used, provided they have the same format
% c    and the same meaning of the input/output parameters.
% c
%       EXTERNAL T96_01,IGRF_GSM
% C
% C   DEFINE THE UNIVERSAL TIME AND PREPARE THE COORDINATE TRANSFORMATION PARAMETERS
% C   BY INVOKING THE SUBROUTINE RECALC: IN THIS PARTICULAR CASE WE TRACE A LINE
% C   FOR YEAR=1997, IDAY=350, UT HOUR = 21, MIN = SEC = 0
% C
GEOPACK_RECALC (2003,238,05,30,0);
% c
% c   Enter T96 model input parameters:
% c
%       PRINT *, '   ENTER SOLAR WIND RAM PRESSURE IN NANOPASCALS'
%       READ *, PARMOD(1)
PARMOD(1) = 1.16; % Solar Wind Ram Pressure, nPa 1.13

% % C
%       PRINT *, '   ENTER DST '
%       READ *, PARMOD(2)
PARMOD(2) = -19; % Dst, nT -19

% % C
%       PRINT *, '   ENTER IMF BY AND BZ'
%       READ *, PARMOD(3),PARMOD(4)
PARMOD(3) = 1.27; % By, GSM, nT 0.4
PARMOD(4) = 3.1; % Bz, GSM, nT -0.7


% C
% C    THE LINE WILL BE TRACED FROM A POINT WITH GEOGRAPHICAL LONGITUDE 45 DEGREES
% C     AND LATITUDE 75 DEGREES:
% C
figure
subplot('position',[0.1,0.1,0.8,0.8])
for GEOLON=[90,270]
    for GEOLAT=-90:2.5:-45
            COLAT=(90.-GEOLAT)*.01745329;
            XLON=GEOLON*.01745329;
        % C
        % C   CONVERT SPHERICAL COORDS INTO CARTESIAN :
        % C
        %      CALL SPHCAR(1.,COLAT,XLON,XGEO,YGEO,ZGEO,1)
        [XGEO,YGEO,ZGEO] = GEOPACK_SPHCAR(1.,COLAT,XLON,1);
        % C
        % C   TRANSFORM GEOGRAPHICAL GEOCENTRIC COORDS INTO SOLAR MAGNETOSPHERIC ONES:
        % C
        [XGSM,YGSM,ZGSM] = GEOPACK_GEOGSM (XGEO,YGEO,ZGEO,1);
        % C
        % c   SPECIFY TRACING PARAMETERS:
        % C
        DIR=GEOLAT/abs(GEOLAT);
        % C            (TRACE THE LINE WITH A FOOTPOINT IN THE NORTHERN HEMISPHERE, THAT IS,
        % C             ANTIPARALLEL TO THE MAGNETIC FIELD)
        RLIM=60.;
        % C            (LIMIT THE TRACING REGION WITHIN R=60 Re)
        % C
        R0=1.;
        % C            (LANDING POINT WILL BE CALCULATED ON THE SPHERE R=1,
        % C                   I.E. ON THE EARTH'S SURFACE)
        % c
        IOPT=0;
        % C           (IN THIS EXAMPLE IOPT IS JUST A DUMMY PARAMETER,
        % C                 WHOSE VALUE DOES NOT MATTER)
        % C
        % C   TRACE THE FIELD LINE:
        % C
        %       CALL TRACE(XGSM,YGSM,ZGSM,DIR,RLIM,R0,IOPT,PARMOD,T96_01,IGRF_GSM,
        %      *  XF,YF,ZF,XX,YY,ZZ,M)
        [XF,YF,ZF,XX,YY,ZZ,M] = GEOPACK_TRACE(XGSM,YGSM,ZGSM,DIR,RLIM,R0,IOPT,PARMOD,'T96','GEOPACK_IGRF_GSM');
        % C
        % C   WRITE THE RESULTS IN THE DATAFILE 'LINTEST1.DAT':
        % C
        %         OPEN(UNIT=1,FILE='LINTEST1.DAT',STATUS='NEW')
        %         WRITE (1,20) (XX(L),YY(L),ZZ(L),L=1,M)
        %  20     FORMAT((2X,3F6.2))
        %         CLOSE(UNIT=1)
        %       STOP
        %       END
        % end of function EXAMPLE2
        hold on
        plot(XX,ZZ,'Color',[0.8,0.8,0.8])
    end
end

%% **************************************************************************
%   figure
%% **************************************************************************

%%

alpha=pi/2:pi/20:3/2*pi;    %½Ç¶È[pi,2*pi] 
R  =  1;                   %°ë¾¶ 
x  =  R*cos(alpha); 
y  =  R*sin(alpha); 
plot(x,y,'k-') 
fill(x,y,'k');
alpha  =  0:pi/20:2*pi;    %½Ç¶È[0,pi] 
x  =  R*cos(alpha); 
y  =  R*sin(alpha);
plot(x,y,'k-') 

%%
hold on
R  =  [14.22,28.33,4.89,9.15];
the  =  [105.17,49.3,85.2,50.5];
the  =  the/180*pi;
Position=[1.63,-6.51;
    3.00,-4.84;
    0.45,-7.58;
    2.37,-5.78];
for i=1:4
    if i==1||i==3
        the(i)=270/180*pi+the(i);
    else
        the(i)=270/180*pi-the(i);
    end
    alpha=the(i)-7.5/180*pi:pi/60:the(i)+7.5/180*pi;
    x  =  R(i)*cos(alpha); 
    y  =  R(i)*sin(alpha);
    a=R(i)*cos(the(i)); 
    b=R(i)*sin(the(i)); 
    aa=Position(i,1)-a;
    bb=Position(i,2)-b;
    xx=aa+x;
    yy=bb+y;
%     plot(x,y,'k-') 
%     plot(a,b,'r.','MarkerSize',20)
if i>2
    plot(xx,yy,'r-','linewidth',2) 
    plot(Position(i,1),Position(i,2),'rp','MarkerSize',10)
else
    plot(xx,yy,'b-','linewidth',2) 
    plot(Position(i,1),Position(i,2),'bp','MarkerSize',10)
end
end
set(gca,'xtick',[-5:5:5],'ytick',[-5:5:5],'FontSize',10,'xlim',[-10,8],'ylim',[-10,5],'XDir','reverse');
text(-5,4,'B_Z(IMF)>0','FontSize',12,'Color','b')
text(-5,3,'B_Z(IMF)<0','FontSize',12,'Color','r')
text(5,0,'Dayside Magnetosphere','FontSize',10,'Color','k')
text(-5,-9,'Magnetospheric Lobes','FontSize',10,'Color','k')
xlabel('X_G_S_M (R_E)','FontSize',12)
ylabel('Z_G_S_M (R_E)','FontSize',12)
box on
    

