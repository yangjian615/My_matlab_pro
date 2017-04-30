function [XF,YF,ZF,XX,YY,ZZ,M] = GEOPACK_EXAMPLE1
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


%% **************************************************************************
%  时间
%% **************************************************************************
for w   =  [20030826,20030828];
     zuobian=[
    0.07,0.1,0.4,0.8;
    0.54,0.1,0.4,0.8;];
    if w==20030826
        subplot('position',zuobian(1,:))
        ts=5;
        te=7;
    else
        subplot('position',zuobian(2,:))
        ts=14;
        te=16;
    end
    %%
for GEOLON=[112,270]
    for GEOLAT=[-90:3:-45,45:3:90]
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
%   轨道数据和旋转角 
%% **************************************************************************
path_in  =  'D:\360Downloads\shuju\';
for j  =  1:6
    name_fgm  =  ['cl_sp_aux_',num2str(w),'_v0',num2str(j),'.cdf'];
    path_fgm  =  sprintf('%s',path_in,name_fgm); 
    filename  =  path_fgm;
    if exist(filename,'file')  ==  2
        info=cdfinfo(filename);
        break;
    end
end
varname  =  info.Variables;
t   =  cdfread(filename,'Variables',varname{3});
tt1 =  ones(size(t,1),1);
for j  =  1:size(t,1)
    tt1(j,1)  =  todatenum(t{j,1});
end
C3_P_gse  =  cdfread(filename,'Variables',varname{7});
C1_P_gse  =  cdfread(filename,'Variables',varname{11});
C2_P_gse  =  cdfread(filename,'Variables',varname{12});
C4_P_gse  =  cdfread(filename,'Variables',varname{14});
gse_gsm   =  cdfread(filename,'Variables',varname{31});
GSE_GSM   =  ones(size(gse_gsm,1),1);
C1_P_GSE  =  ones(size(gse_gsm,1),3);
C2_P_GSE  =  ones(size(gse_gsm,1),3);
C3_P_GSE  =  ones(size(gse_gsm,1),3);
C4_P_GSE  =  ones(size(gse_gsm,1),3);
for i  =  1:size(gse_gsm,1)
    C3_P_GSE(i,:)  =  C3_P_gse{i,:}(:,1)';
    C1_P_GSE(i,:)  =  C1_P_gse{i,:}(:,1)' * 20 +  C3_P_GSE(i,:) ;
    C2_P_GSE(i,:)  =  C2_P_gse{i,:}(:,1)' * 20 +  C3_P_GSE(i,:) ;
    C4_P_GSE(i,:)  =  C4_P_gse{i,:}(:,1)' * 20 +  C3_P_GSE(i,:);
    GSE_GSM(j,1)  =  gse_gsm{j,1}(1,1);
end

%% **************************************************************************
%   GSE_GSM
%% **************************************************************************
C1_P_GSM  =  C1_P_GSE;
C2_P_GSM  =  C2_P_GSE;
C3_P_GSM  =  C3_P_GSE;
C4_P_GSM  =  C4_P_GSE;
for i=1:size(gse_gsm,1)
    A=[1,0,0;...
        0,cos(GSE_GSM(i,1)*pi/180),-sin(GSE_GSM(i,1)*pi/180);...
        0,sin(GSE_GSM(i,1)*pi/180),cos(GSE_GSM(i,1)*pi/180)];
    C1_P_GSM(i,:)=(A*(C1_P_GSE(i,:))')'/6371;
    C2_P_GSM(i,:)=(A*(C2_P_GSE(i,:))')'/6371;
    C3_P_GSM(i,:)=(A*(C3_P_GSE(i,:))')'/6371;
    C4_P_GSM(i,:)=(A*(C4_P_GSE(i,:))')'/6371;
end
 
% clearvars -except C1_P_GSM C2_P_GSM C3_P_GSM C4_P_GSM tt1 t dat
%% **************************************************************************
%  数据归一同时化
%% **************************************************************************
Cluster_1=  ones(24,12);
n  =  1;
for i=1:60:1381
    Cluster_1(n,1:3)  =  C1_P_GSM(i,:); 
    Cluster_1(n,4:6)  =  C2_P_GSM(i,:); 
    Cluster_1(n,7:9)  =  C3_P_GSM(i,:); 
    Cluster_1(n,10:12)  =  C4_P_GSM(i,:); 
    n  =  n+1;
end



%% **************************************************************************
%   figure
%% **************************************************************************

%%

alpha=pi/2:pi/20:3/2*pi;    %角度[pi,2*pi] 
R  =  1;                   %半径 
x  =  R*cos(alpha); 
y  =  R*sin(alpha); 
plot(x,y,'k-') 
fill(x,y,'k');
alpha  =  0:pi/20:2*pi;    %角度[0,pi] 
x  =  R*cos(alpha); 
y  =  R*sin(alpha);
plot(x,y,'k-') 
%%
plot(C3_P_GSM(:,1),C3_P_GSM(:,3),'k','LineWidth',2)
grid on
%%
plot(Cluster_1(:,7),Cluster_1(:,9),'k.','Markersize',20)
plot(Cluster_1([ts+1,te+1],7),Cluster_1([ts+1,te+1],9),'k.','Markersize',10) %C3
plot(Cluster_1([ts+1,te+1],1),Cluster_1([ts+1,te+1],3),'k*','Markersize',10) %C1
plot(Cluster_1([ts+1,te+1],4),Cluster_1([ts+1,te+1],6),'k>','Markersize',10) %C2
plot(Cluster_1([ts+1,te+1],10),Cluster_1([ts+1,te+1],12),'ko','Markersize',10) %C4
line([Cluster_1(ts+1,1),Cluster_1(ts+1,4)],[Cluster_1(ts+1,3),Cluster_1(ts+1,6)],'LineWidth',2,'Color',[.2,.2,.2])
line([Cluster_1(ts+1,1),Cluster_1(ts+1,7)],[Cluster_1(ts+1,3),Cluster_1(ts+1,9)],'LineWidth',2,'Color',[.2,.2,.2])
line([Cluster_1(ts+1,1),Cluster_1(ts+1,10)],[Cluster_1(ts+1,3),Cluster_1(ts+1,12)],'LineWidth',2,'Color',[.2,.2,.2])
line([Cluster_1(ts+1,4),Cluster_1(ts+1,7)],[Cluster_1(ts+1,6),Cluster_1(ts+1,9)],'LineWidth',2,'Color',[.2,.2,.2])
line([Cluster_1(ts+1,4),Cluster_1(ts+1,10)],[Cluster_1(ts+1,6),Cluster_1(ts+1,12)],'LineWidth',2,'Color',[.2,.2,.2])
line([Cluster_1(ts+1,7),Cluster_1(ts+1,10)],[Cluster_1(ts+1,9),Cluster_1(ts+1,12)],'LineWidth',2,'Color',[.2,.2,.2])
line([Cluster_1(te+1,1),Cluster_1(te+1,4)],[Cluster_1(te+1,3),Cluster_1(te+1,6)],'LineWidth',2,'Color',[.2,.2,.2])
line([Cluster_1(te+1,1),Cluster_1(te+1,7)],[Cluster_1(te+1,3),Cluster_1(te+1,9)],'LineWidth',2,'Color',[.2,.2,.2])
line([Cluster_1(te+1,1),Cluster_1(te+1,10)],[Cluster_1(te+1,3),Cluster_1(te+1,12)],'LineWidth',2,'Color',[.2,.2,.2])
line([Cluster_1(te+1,4),Cluster_1(te+1,7)],[Cluster_1(te+1,6),Cluster_1(te+1,9)],'LineWidth',2,'Color',[.2,.2,.2])
line([Cluster_1(te+1,4),Cluster_1(te+1,10)],[Cluster_1(te+1,6),Cluster_1(te+1,12)],'LineWidth',2,'Color',[.2,.2,.2])
line([Cluster_1(te+1,7),Cluster_1(te+1,10)],[Cluster_1(te+1,9),Cluster_1(te+1,12)],'LineWidth',2,'Color',[.2,.2,.2])
set(gca,'xtick',[-10:5:20],'ytick',[-20:5:20],'FontSize',16,'xlim',[-10,10],'ylim',[-10,5],'XDir','reverse');
xlabel('X_G_S_M (R_E)','FontSize',16)
ylabel('Z_G_S_M (R_E)','FontSize',16)

text(8,0,'Dayside Magnetosphere','FontSize',16,'Color','k')
text(3,-3,'Cluster orbit and tetrahedron','FontSize',16,'Color','k')
text(-1,-9,'Magnetospheric Lobes','FontSize',16,'Color','k')
text(4,-6,'Cusp','FontSize',16,'Color','k')
text(-4,4,['DATE:',num2str(w)],'FontSize',18,'Color','k')

if w==20030826
    text(6,-5,'07:00:00','FontSize',16,'Color','k')
    text(0,-7,'05:00:00','FontSize',16,'Color','k')
    text(9,4,'(a)','FontSize',18,'Color','k')
    
else
    text(6,-5,'16:00:00','FontSize',16,'Color','k')
    text(0,-7,'14:00:00','FontSize',16,'Color','k')
    text(9,4,'(b)','FontSize',18,'Color','k')
end

end
%%

