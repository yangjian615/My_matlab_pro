%function [BX,BY,BZ] = T96_01(IOPT,PARMOD,PS,X,Y,Z)
function [BX,BY,BZ] = T96(IOPT,PARMOD,PS,X,Y,Z)
% function [BX,BY,BZ] = T96(IOPT,PARMOD,PS,X,Y,Z)
% Tsyganenko's External Field Model, 1996 Version (T96)
% Translated from original FORTRAN March 27, 2003
% By Paul O'Brien (original by N.A. Tsyganenko)
% Paul.OBrien@aero.org (Nikolai.Tsyganenko@gsfc.nasa.gov)
%
% All subroutines enclosed here as subfunctions
%
% Updates:
% 4/17/2003 Fixed some COS,SIN,SQRT to cos,sin,sqrt
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% C----------------------------------------------------------------------
% c
%      SUBROUTINE T96_01 (IOPT,PARMOD,PS,X,Y,Z,BX,BY,BZ)
% C
% c     RELEASE DATE OF THIS VERSION:   JUNE 22, 1996.
% 
% C----------------------------------------------------------------------
% C
% C  WITH TWO CORRECTIONS, SUGGESTED BY T.SOTIRELIS' COMMENTS (APR.7, 1997)
% C
% C  (1) A "STRAY "  CLOSING PARENTHESIS WAS REMOVED IN THE S/R   R2_BIRK
% C  (2) A 0/0 PROBLEM ON THE Z-AXIS WAS SIDESTEPPED (LINES 44-46 OF THE
% c       DOUBLE PRECISION FUNCTION XKSI)
% c--------------------------------------------------------------------
% C DATA-BASED MODEL CALIBRATED BY (1) SOLAR WIND PRESSURE PDYN (NANOPASCALS),
% C           (2) DST (NANOTESLA),  (3) BYIMF, AND (4) BZIMF (NANOTESLA).
% c THESE INPUT PARAMETERS SHOULD BE PLACED IN THE FIRST 4 ELEMENTS
% c OF THE ARRAY PARMOD(10).
% C
% C   THE REST OF THE INPUT VARIABLES ARE: THE GEODIPOLE TILT ANGLE PS (RADIANS),
% C AND   X,Y,Z -  GSM POSITION (RE)
% C
% c   IOPT  IS JUST A DUMMY INPUT PARAMETER, NECESSARY TO MAKE THIS SUBROUTINE
% C COMPATIBLE WITH THE NEW RELEASE (APRIL 1996) OF THE TRACING SOFTWARE
% C PACKAGE (GEOPACK). IOPT VALUE DOES NOT AFFECT THE OUTPUT FIELD.
% c
% C
% c OUTPUT:  GSM COMPONENTS OF THE EXTERNAL MAGNETIC FIELD (BX,BY,BZ, nanotesla)
% C            COMPUTED AS A SUM OF CONTRIBUTIONS FROM PRINCIPAL FIELD SOURCES
% C
% c  (C) Copr. 1995, 1996, Nikolai A. Tsyganenko, Hughes STX, Code 695, NASA GSFC
% c      Greenbelt, MD 20771, USA
% c
% C                            REFERENCES:
% C
% C               (1) N.A. TSYGANENKO AND D.P. STERN, A NEW-GENERATION GLOBAL
% C           MAGNETOSPHERE FIELD MODEL  , BASED ON SPACECRAFT MAGNETOMETER DATA,
% C           ISTP NEWSLETTER, V.6, NO.1, P.21, FEB.1996.
% C
% c              (2) N.A.TSYGANENKO,  MODELING THE EARTH'S MAGNETOSPHERIC
% C           MAGNETIC FIELD CONFINED WITHIN A REALISTIC MAGNETOPAUSE,
% C           J.GEOPHYS.RES., V.100, P. 5599, 1995.
% C
% C              (3) N.A. TSYGANENKO AND M.PEREDO, ANALYTICAL MODELS OF THE
% C           MAGNETIC FIELD OF DISK-SHAPED CURRENT SHEETS, J.GEOPHYS.RES.,
% C           V.99, P. 199, 1994.
% C
% c----------------------------------------------------------------------
 

%      IMPLICIT REAL*8 (A-H,O-Z)
%      REAL PDYN,DST,BYIMF,BZIMF,PS,X,Y,Z,BX,BY,BZ,QX,QY,QZ,PARMOD(10),
%     *   A(9)
% c
PDYN0 = 2;
EPS10 = 3630.7;
% C
A = [1.162,22.344,18.50,2.602,6.903,5.287,0.5790,0.4462,0.7850];
% C
AM0 = 70;
S0 = 1.08;
X00 = 5.48;
DSIG = 0.005;
DELIMFX = 20;
DELIMFY = 10;
% C
PDYN=PARMOD(1);
DST=PARMOD(2);
BYIMF=PARMOD(3);
BZIMF=PARMOD(4);
% C
SPS=sin(PS);
PPS=PS;
% C
DEPR=0.8*DST-13.*sqrt(PDYN) ;  %!  DEPR is an estimate of total near-Earth
% c                                         depression, based on DST and Pdyn
% c                                             (usually, DEPR &lt 0 )
% C
% C  CALCULATE THE IMF-RELATED QUANTITIES:
% C
Bt=sqrt(BYIMF^2+BZIMF^2);

if (BYIMF==0) & (BZIMF==0.),
    THETA=0;
else
    % C
    THETA=atan2(BYIMF,BZIMF);
    if (THETA<=0), THETA=THETA+6.2831853; end;
end
CT=cos(THETA);
ST=sin(THETA);
EPS=718.5*sqrt(PDYN)*Bt*sin(THETA/2.);
% C
FACTEPS=EPS/EPS10-1;
FACTPD=sqrt(PDYN/PDYN0)-1;
% C
RCAMPL=-A(1)*DEPR ;    %!   RCAMPL is the amplitude of the ring current
% c                  (positive and equal to abs.value of RC depression at origin)
% C
TAMPL2=A(2)+A(3)*FACTPD+A(4)*FACTEPS;
TAMPL3=A(5)+A(6)*FACTPD;
B1AMPL=A(7)+A(8)*FACTEPS;
B2AMPL=20.*B1AMPL;  %! IT IS EQUIVALENT TO ASSUMING THAT THE TOTAL CURRENT
% C                           IN THE REGION 2 SYSTEM IS 40% OF THAT IN REGION 1
RECONN=A(9);
% C
XAPPA=(PDYN/PDYN0)^0.14;
XAPPA3=XAPPA^3;
YS=Y*CT-Z*ST;
ZS=Z*CT+Y*ST;
% C
FACTIMF=exp(X/DELIMFX-(YS/DELIMFY)^2);
% C
% C  CALCULATE THE "IMF" COMPONENTS OUTSIDE THE LAYER  (HENCE BEGIN WITH "O")
% C
OIMFX=0;
OIMFY=RECONN*BYIMF*FACTIMF;
OIMFZ=RECONN*BZIMF*FACTIMF;
% C
RIMFAMPL=RECONN*Bt;
% C
PPS=PS;
XX=X*XAPPA;
YY=Y*XAPPA;
ZZ=Z*XAPPA;
% C
% C  SCALE AND CALCULATE THE MAGNETOPAUSE PARAMETERS FOR THE INTERPOLATION ACROSS
% C   THE BOUNDARY LAYER (THE COORDINATES XX,YY,ZZ  ARE ALREADY SCALED)
% C
X0=X00/XAPPA;
AM=AM0/XAPPA;
RHO2=Y^2+Z^2;
ASQ=AM^2;
XMXM=AM+X-X0;
if (XMXM<0.), XMXM=0; end %! THE BOUNDARY IS A CYLINDER TAILWARD OF X=X0-AM
AXX0=XMXM^2;
ARO=ASQ+RHO2;
SIGMA=sqrt((ARO+AXX0+sqrt((ARO+AXX0)^2-4.*ASQ*AXX0))/(2.*ASQ));
% C
% C   NOW, THERE ARE THREE POSSIBLE CASES:
% C    (1) INSIDE THE MAGNETOSPHERE
% C    (2) IN THE BOUNDARY LAYER
% C    (3) OUTSIDE THE MAGNETOSPHERE AND B.LAYER
% C       FIRST OF ALL, CONSIDER THE CASES (1) AND (2):
% C
if (SIGMA<S0+DSIG) ,  %!  CALCULATE THE T95_06 FIELD (WITH THE
    % C                                POTENTIAL "PENETRATED" INTERCONNECTION FIELD):
    
    [CFX,CFY,CFZ] = T96_DIPSHLD(PPS,XX,YY,ZZ);
    [BXRC,BYRC,BZRC,BXT2,BYT2,BZT2,BXT3,BYT3,BZT3] = T96_TAILRC96(SPS,XX,YY,ZZ);
    [R1X,R1Y,R1Z] = T96_BIRK1TOT_02(PPS,XX,YY,ZZ);
    [R2X,R2Y,R2Z] =T96_BIRK2TOT_02(PPS,XX,YY,ZZ);
    [RIMFX,RIMFYS,RIMFZS] = T96_INTERCON(XX,YS*XAPPA,ZS*XAPPA);
    RIMFY=RIMFYS*CT+RIMFZS*ST;
    RIMFZ=RIMFZS*CT-RIMFYS*ST;
    % C
    FX=CFX*XAPPA3+RCAMPL*BXRC +TAMPL2*BXT2+TAMPL3*BXT3 ...
        +B1AMPL*R1X +B2AMPL*R2X +RIMFAMPL*RIMFX;
    FY=CFY*XAPPA3+RCAMPL*BYRC +TAMPL2*BYT2+TAMPL3*BYT3 ...
        +B1AMPL*R1Y +B2AMPL*R2Y +RIMFAMPL*RIMFY;
    FZ=CFZ*XAPPA3+RCAMPL*BZRC +TAMPL2*BZT2+TAMPL3*BZT3 ...
        +B1AMPL*R1Z +B2AMPL*R2Z +RIMFAMPL*RIMFZ;
    % C
    % C  NOW, LET US CHECK WHETHER WE HAVE THE CASE (1). IF YES - WE ARE DONE:
    % C
    if  (SIGMA < S0-DSIG),
        BX=FX;
        BY=FY;
        BZ=FZ;
    else  %!  THIS IS THE MOST COMPLEX CASE: WE ARE INSIDE
        % C                                         THE INTERPOLATION REGION
        FINT=0.5*(1.-(SIGMA-S0)/DSIG);
        FEXT=0.5*(1.+(SIGMA-S0)/DSIG);
        % C
        [QX,QY,QZ] = T96_DIPOLE(PS,X,Y,Z);
        BX=(FX+QX)*FINT+OIMFX*FEXT -QX;
        BY=(FY+QY)*FINT+OIMFY*FEXT -QY;
        BZ=(FZ+QZ)*FINT+OIMFZ*FEXT -QZ;
        % c
    end  %!   THE CASES (1) AND (2) ARE EXHAUSTED; THE ONLY REMAINING
    % C                      POSSIBILITY IS NOW THE CASE (3):
    
else
    [QX,QY,QZ] = T96_DIPOLE(PS,X,Y,Z);
    BX=OIMFX-QX;
    BY=OIMFY-QY;
    BZ=OIMFZ-QZ;
end
% C
% end function T96_01
% C=====================================================================

function [BX,BY,BZ] = T96_DIPSHLD(PS,X,Y,Z)
%      SUBROUTINE DIPSHLD(PS,X,Y,Z,BX,BY,BZ)
% C
% C   CALCULATES GSM COMPONENTS OF THE EXTERNAL MAGNETIC FIELD DUE TO
% C    SHIELDING OF THE EARTH'S DIPOLE ONLY
% C
%       IMPLICIT REAL*8 (A-H,O-Z)
%       DIMENSION A1(12),A2(12)
A1  = [.24777,-27.003,-.46815,7.0637,-1.5918,-.90317E-01,57.522,...
        13.757,2.0100,10.458,4.5798,2.1695];
A2 = [-.65385,-18.061,-.40457,-5.0995,1.2846,.78231E-01,39.592,...
        13.291,1.9970,10.062,4.5140,2.1558];
% C
CPS=cos(PS);
SPS=sin(PS);
[HX,HY,HZ] = T96_CYLHARM(A1,X,Y,Z);
[FX,FY,FZ] = T96_CYLHAR1(A2,X,Y,Z);
% C
BX=HX*CPS+FX*SPS;
BY=HY*CPS+FY*SPS;
BZ=HZ*CPS+FZ*SPS;
% end function DIPSHLD
% C

function [BX,BY,BZ] = T96_CYLHARM( A, X,Y,Z)
% C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% C
% C  THIS CODE YIELDS THE SHIELDING FIELD FOR THE PERPENDICULAR DIPOLE
% C
%         SUBROUTINE  CYLHARM( A, X,Y,Z, BX,BY,BZ)
% C
% C
% C   ***  N.A. Tsyganenko ***  Sept. 14-18, 1993; revised March 16, 1994 ***
% C
% C   An approximation for the Chapman-Ferraro field by a sum of 6 cylin-
% c   drical harmonics (see pp. 97-113 in the brown GSFC notebook #1)
% c
% C      Description of parameters:
% C
% C  A   - input vector containing model parameters;
% C  X,Y,Z   -  input GSM coordinates
% C  BX,BY,BZ - output GSM components of the shielding field
% C - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% C  The 6 linear parameters A(1)-A(6) are amplitudes of the cylindrical harmonic
% c       terms.
% c  The 6 nonlinear parameters A(7)-A(12) are the corresponding scale lengths
% C       for each term (see GSFC brown notebook).
% c
% C - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% C
%	 IMPLICIT  REAL * 8  (A - H, O - Z)
% C
%	 DIMENSION  A(12)
% C
RHO=sqrt(Y^2+Z^2);
if (RHO<1.e-8),
    SINFI=1.0;
    COSFI=0.0;
    RHO=1.e-8;
else
    % C
    SINFI=Z/RHO;
    COSFI=Y/RHO;
end
SINFI2=SINFI^2;
SI2CO2=SINFI2-COSFI^2;
% C
BX=0;
BY=0;
BZ=0;
% C
for I = 1:3,
    DZETA=RHO/A(I+6);
    XJ0=T96_BES(DZETA,0);
    XJ1=T96_BES(DZETA,1);
    XEXP=exp(X/A(I+6));
    BX=BX-A(I)*XJ1*XEXP*SINFI;
    BY=BY+A(I)*(2.D0*XJ1/DZETA-XJ0)*XEXP*SINFI*COSFI;
    BZ=BZ+A(I)*(XJ1/DZETA*SI2CO2-XJ0*SINFI2)*XEXP;
end
% c
for I = 4:6,
    DZETA=RHO/A(I+6);
    XKSI=X/A(I+6);
    XJ0=T96_BES(DZETA,0);
    XJ1=T96_BES(DZETA,1);
    XEXP=exp(XKSI);
    BRHO=(XKSI*XJ0-(DZETA^2+XKSI-1.D0)*XJ1/DZETA)*XEXP*SINFI;
    BPHI=(XJ0+XJ1/DZETA*(XKSI-1.D0))*XEXP*COSFI;
    BX=BX+A(I)*(DZETA*XJ0+XKSI*XJ1)*XEXP*SINFI;
    BY=BY+A(I)*(BRHO*COSFI-BPHI*SINFI);
    BZ=BZ+A(I)*(BRHO*SINFI+BPHI*COSFI);
end
% C
% c
% end function CYLHARM

function [BX,BY,BZ] = T96_CYLHAR1(A, X,Y,Z)
% c%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% C
% C  THIS CODE YIELDS THE SHIELDING FIELD FOR THE PARALLEL DIPOLE
% C
%         SUBROUTINE  CYLHAR1(A, X,Y,Z, BX,BY,BZ)
% C
% C
% C   ***  N.A. Tsyganenko ***  Sept. 14-18, 1993; revised March 16, 1994 ***
% C
% C   An approximation of the Chapman-Ferraro field by a sum of 6 cylin-
% c   drical harmonics (see pages 97-113 in the brown GSFC notebook #1)
% c
% C      Description of parameters:
% C
% C  A   - input vector containing model parameters;
% C  X,Y,Z - input GSM coordinates,
% C  BX,BY,BZ - output GSM components of the shielding field
% C
% C - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% C
% C      The 6 linear parameters A(1)-A(6) are amplitudes of the cylindrical
% c  harmonic terms.
% c      The 6 nonlinear parameters A(7)-A(12) are the corresponding scale
% c  lengths for each term (see GSFC brown notebook).
% c
% C - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% C
%	 IMPLICIT  REAL * 8  (A - H, O - Z)
% C
%	 DIMENSION  A(12)
% C
RHO=sqrt(Y^2+Z^2);
if (RHO<1.e-10),
    SINFI=1;
    COSFI=0;
else
    % C
    SINFI=Z/RHO;
    COSFI=Y/RHO;
end
% C
BX=0;
BY=0;
BZ=0;
% C
for I = 1:3,
    DZETA=RHO/A(I+6);
    XKSI=X/A(I+6);
    XJ0=T96_BES(DZETA,0);
    XJ1=T96_BES(DZETA,1);
    XEXP=exp(XKSI);
    BRHO=XJ1*XEXP;
    BX=BX-A(I)*XJ0*XEXP;
    BY=BY+A(I)*BRHO*COSFI;
    BZ=BZ+A(I)*BRHO*SINFI;
end
% c
for I = 4:6,
    DZETA=RHO/A(I+6);
    XKSI=X/A(I+6);
    XJ0=T96_BES(DZETA,0);
    XJ1=T96_BES(DZETA,1);
    XEXP=exp(XKSI);
    BRHO=(DZETA*XJ0+XKSI*XJ1)*XEXP;
    BX=BX+A(I)*(DZETA*XJ1-XJ0*(XKSI+1.D0))*XEXP;
    BY=BY+A(I)*BRHO*COSFI;
    BZ=BZ+A(I)*BRHO*SINFI;
end% C
% end of function CYLHAR1

% c%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% C
function BES = T96_BES(X,K);
%      DOUBLE PRECISION FUNCTION BES(X,K)
%      IMPLICIT REAL*8 (A-H,O-Z)
% C
BES = besselj(K,X);
% if (K==0) ,
%     BES=T96_BES0(X);
%     return
% end
% % C
% if (K==1),
%     BES=T96_BES1(X);
%     return
% end
% % C
% if (X==0),
%     BES=0
%     return
% end
% % C
% G=2/X;
% if X > K,
%     % C
%     N=1;
%     XJN=T96_BES1(X);
%     XJNM1=T96_BES0(X);
%     % C
%     while 1,
%         XJNP1=G*N*XJN-XJNM1;
%         N=N+1;
%         if (N>=K) 
%             BES=XJNP1;
%             return
%             % C
%         end 
%         XJNM1=XJN;
%         XJN=XJNP1;
%     end
%     % C
% end
% N=24;
% XJN=1.0;
% XJNP1=0.0;
% SUM=0.0;
% % C
% while 1,
%     if (mod(N,2)==0), SUM=SUM+XJN; end
%     XJNM1=G*N*XJN-XJNP1;
%     N=N-1;
%     % C
%     XJNP1=XJN;
%     XJN=XJNM1;
%     if (N==K), BES=XJN; end
%     % C
%     if (abs(XJN)>1.e5),
%         XJNP1=XJNP1*1.D-5;
%         XJN=XJN*1.D-5;
%         SUM=SUM*1.D-5;
%         if (N<=K), BES=BES*1.D-5; end
%     end
%     % C
%     if (N==0), break; end;
% end% C
% SUM=XJN+2.D0*SUM;
% BES=BES/SUM;
% end of function BES
% c-------------------------------------------------------------------
% c
function BES0 = T96_BES0(X)
%       DOUBLE PRECISION FUNCTION BES0(X)
% C
%        IMPLICIT REAL*8 (A-H,O-Z)
% C
BES0 = besselj(0,X);
% 
% if (abs(X)<3.D0),
%     X32=(X/3.D0)^2;
%     BES0=1.D0-X32*(2.2499997D0-X32*(1.2656208D0-X32* ...
%         (0.3163866D0-X32*(0.0444479D0-X32*(0.0039444D0 ...
%         -X32*0.00021D0)))));
% else
%     XD3=3.D0/X;
%     F0=0.79788456D0-XD3*(0.00000077D0+XD3*(0.00552740D0+XD3* ...
%         (0.00009512D0-XD3*(0.00137237D0-XD3*(0.00072805D0 ...
%         -XD3*0.00014476D0)))));
%     T0=X-0.78539816D0-XD3*(0.04166397D0+XD3*(0.00003954D0-XD3* ...
%         (0.00262573D0-XD3*(0.00054125D0+XD3*(0.00029333D0 ...
%         -XD3*0.00013558D0)))));
%     BES0=F0/sqrt(X)*cos(T0);
% end
% end of function BES0
% c
% c--------------------------------------------------------------------------
% c

function BES1 = T96_BES1(X)
% DOUBLE PRECISION FUNCTION BES1(X)
% C
%        IMPLICIT REAL*8 (A-H,O-Z)
% C
BES1 = besselj(1,X);
% if (abs(X)<3.D0),
%     X32=(X/3.D0)^2;
%     BES1XM1=0.5D0-X32*(0.56249985D0-X32*(0.21093573D0-X32* ...
%         (0.03954289D0-X32*(0.00443319D0-X32*(0.00031761D0 ...
%         -X32*0.00001109D0)))));
%     BES1=BES1XM1*X;
% else
%     XD3=3.D0/X;
%     F1=0.79788456D0+XD3*(0.00000156D0+XD3*(0.01659667D0+XD3* ...
%         (0.00017105D0-XD3*(0.00249511D0-XD3*(0.00113653D0 ...
%         -XD3*0.00020033D0)))));
%     T1=X-2.35619449D0+XD3*(0.12499612D0+XD3*(0.0000565D0-XD3* ...
%         (0.00637879D0-XD3*(0.00074348D0+XD3*(0.00079824D0 ...
%         -XD3*0.00029166D0)))));
%     BES1=F1/sqrt(X)*cos(T1);
% end
% end function BES1

% C------------------------------------------------------------
% C
function [BX,BY,BZ] = T96_INTERCON(X,Y,Z);
%         SUBROUTINE INTERCON(X,Y,Z,BX,BY,BZ)
% C
% C      Calculates the potential interconnection field inside the magnetosphere,
% c  corresponding to  DELTA_X = 20Re and DELTA_Y = 10Re (NB#3, p.90, 6/6/1996).
% C  The position (X,Y,Z) and field components BX,BY,BZ are given in the rotated
% c   coordinate system, in which the Z-axis is always directed along the BzIMF
% c   (i.e. rotated by the IMF clock angle Theta)
% C   It is also assumed that the IMF Bt=1, so that the components should be
% c     (i) multiplied by the actual Bt, and
% c     (ii) transformed to standard GSM coords by rotating back around X axis
% c              by the angle -Theta.
% c
% C      Description of parameters:
% C
% C     X,Y,Z -   GSM POSITION
% C      BX,BY,BZ - INTERCONNECTION FIELD COMPONENTS INSIDE THE MAGNETOSPHERE
% C        OF A STANDARD SIZE (TO TAKE INTO ACCOUNT EFFECTS OF PRESSURE CHANGES,
% C         APPLY THE SCALING TRANSFORMATION)
% C
% C - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% C
% C     The 9 linear parameters are amplitudes of the "cartesian" harmonics
% c     The 6 nonlinear parameters are the scales Pi and Ri entering
% c    the arguments of exponents, sines, and cosines in the 9 "Cartesian"
% c       harmonics (3+3)
% C - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% C
%        IMPLICIT  REAL * 8  (A - H, O - Z)
% C
%        DIMENSION A(15),RP(3),RR(3),P(3),R(3)
% C
A = [-8.411078731,5932254.951,-9073284.93,-11.68794634,...
        6027598.824,-9218378.368,-6.508798398,-11824.42793,18015.66212,...
        7.99754043,13.9669886,90.24475036,16.75728834,1015.645781,...
        1553.493216];
% C
persistent M P R RP RR
if isempty(M),
    M = 0;
end
% C
if M==0,
    M=1;
    % C
    P(1)=A(10);
    P(2)=A(11);
    P(3)=A(12);
    R(1)=A(13);
    R(2)=A(14);
    R(3)=A(15);
    % C
    % C
    RP = 1./P;
    RR = 1./R;
    % C
end
% C
L=0;
% C
BX=0.;
BY=0.;
BZ=0.;
% C
% c        "PERPENDICULAR" KIND OF SYMMETRY ONLY
% C
for I = 1:3,
    CYPI=cos(Y*RP(I));
    SYPI=sin(Y*RP(I));
    % C
    for K = 1:3,
        SZRK=sin(Z*RR(K));
        CZRK=cos(Z*RR(K));
        SQPR=sqrt(RP(I)^2+RR(K)^2);
        EPR=exp(X*SQPR);
        % C
        HX=-SQPR*EPR*CYPI*SZRK;
        HY=RP(I)*EPR*SYPI*SZRK;
        HZ=-RR(K)*EPR*CYPI*CZRK;
        L=L+1;
        % c
        BX=BX+A(L)*HX;
        BY=BY+A(L)*HY;
        BZ=BZ+A(L)*HZ;
    end
end
% C
% end of function INTERCON

function [BXRC,BYRC,BZRC,BXT2,BYT2,BZT2,BXT3,BYT3,BZT3] = T96_TAILRC96(SPS,X,Y,Z);
% C~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%      SUBROUTINE TAILRC96(SPS,X,Y,Z,BXRC,BYRC,BZRC,BXT2,BYT2,BZT2,
%     *   BXT3,BYT3,BZT3)
% c
% c  COMPUTES THE COMPONENTS OF THE FIELD OF THE MODEL RING CURRENT AND THREE
% c                   TAIL MODES WITH UNIT AMPLITUDES
% C      (FOR THE RING CURRENT, IT MEANS THE DISTURBANCE OF Bz=-1nT AT ORIGIN,
% C   AND FOR THE TAIL MODES IT MEANS MAXIMAL BX JUST ABOVE THE SHEET EQUAL 1 nT.
% C
%         IMPLICIT REAL*8 (A-H,O-Z)
%         DIMENSION ARC(48),ATAIL2(48),ATAIL3(48)
global T96;
%         COMMON /WARP/ CPSS,SPSS,DPSRR,RPS,WARP,D,XS,ZS,DXSX,DXSY,DXSZ,
%     *   DZSX,DZSY,DZSZ,DZETAS,DDZETADX,DDZETADY,DDZETADZ,ZSWW
% C
ARC = [-3.087699646,3.516259114,18.81380577,-13.95772338,...
        -5.497076303,0.1712890838,2.392629189,-2.728020808,-14.79349936,...
        11.08738083,4.388174084,0.2492163197E-01,0.7030375685,...
        -.7966023165,-3.835041334,2.642228681,-0.2405352424,-0.7297705678,...
        -0.3680255045,0.1333685557,2.795140897,-1.078379954,0.8014028630,...
        0.1245825565,0.6149982835,-0.2207267314,-4.424578723,1.730471572,...
        -1.716313926,-0.2306302941,-0.2450342688,0.8617173961E-01,...
        1.54697858,-0.6569391113,-0.6537525353,0.2079417515,12.75434981,...
        11.37659788,636.4346279,1.752483754,3.604231143,12.83078674,...
        7.412066636,9.434625736,676.7557193,1.701162737,3.580307144,...
        14.64298662];
% C
ATAIL2 = [.8747515218,-.9116821411,2.209365387,-2.159059518,...
        -7.059828867,5.924671028,-1.916935691,1.996707344,-3.877101873,...
        3.947666061,11.38715899,-8.343210833,1.194109867,-1.244316975,...
        3.73895491,-4.406522465,-20.66884863,3.020952989,.2189908481,...
        -.09942543549,-.927225562,.1555224669,.6994137909,-.08111721003,...
        -.7565493881,.4686588792,4.266058082,-.3717470262,-3.920787807,...
        .02298569870,.7039506341,-.5498352719,-6.675140817,.8279283559,...
        -2.234773608,-1.622656137,5.187666221,6.802472048,39.13543412,...
        2.784722096,6.979576616,25.71716760,4.495005873,8.068408272,...
        93.47887103,4.158030104,9.313492566,57.18240483];
% C
ATAIL3 =[-19091.95061,-3011.613928,20582.16203,4242.918430,...
        -2377.091102,-1504.820043,19884.04650,2725.150544,-21389.04845,...
        -3990.475093,2401.610097,1548.171792,-946.5493963,490.1528941,...
        986.9156625,-489.3265930,-67.99278499,8.711175710,-45.15734260,...
        -10.76106500,210.7927312,11.41764141,-178.0262808,.7558830028,...
        339.3806753,9.904695974,69.50583193,-118.0271581,22.85935896,...
        45.91014857,-425.6607164,15.47250738,118.2988915,65.58594397,...
        -201.4478068,-14.57062940,19.69877970,20.30095680,86.45407420,...
        22.50403727,23.41617329,48.48140573,24.61031329,123.5395974,...
        223.5367692,39.50824342,65.83385762,266.2948657];
% C
RH = 9;
DR = 4;
G = 10;
D0 = 2;
DELTADY = 10;
% C
% C   TO ECONOMIZE THE CODE, WE FIRST CALCULATE COMMON VARIABLES, WHICH ARE
% C      THE SAME FOR ALL MODES, AND PUT THEM IN THE COMMON-BLOCK /WARP/
% C
DR2=DR*DR;
C11=sqrt((1.D0+RH)^2+DR2);
C12=sqrt((1.D0-RH)^2+DR2);
C1=C11-C12;
SPSC1=SPS/C1;
T96.WARP.RPS=0.5*(C11+C12)*SPS;  %!  THIS IS THE SHIFT OF OF THE SHEET WITH RESPECT
% C                            TO GSM EQ.PLANE FOR THE 3RD (ASYMPTOTIC) TAIL MODE
% C
R=sqrt(X*X+Y*Y+Z*Z);
SQ1=sqrt((R+RH)^2+DR2);
SQ2=sqrt((R-RH)^2+DR2);
C=SQ1-SQ2;
CS=(R+RH)/SQ1-(R-RH)/SQ2;
T96.WARP.SPSS=SPSC1/R*C;
T96.WARP.CPSS=sqrt(1.D0-T96.WARP.SPSS^2);
T96.WARP.DPSRR=SPS/(R*R)*(CS*R-C)/sqrt((R*C1)^2-(C*SPS)^2);
% C
WFAC=Y/(Y^4+1.D4);   %!   WARPING
W=WFAC*Y^3;
WS=4.D4*Y*WFAC^2;
T96.WARP.WARP=G*SPS*W;
T96.WARP.XS=X*T96.WARP.CPSS-Z*T96.WARP.SPSS;
T96.WARP.ZSWW=Z*T96.WARP.CPSS+X*T96.WARP.SPSS;  %! "WW" MEANS "WITHOUT Y-Z WARPING" (IN X-Z ONLY)
T96.WARP.ZS=T96.WARP.ZSWW +T96.WARP.WARP;

T96.WARP.DXSX=T96.WARP.CPSS-X*T96.WARP.ZSWW*T96.WARP.DPSRR;
T96.WARP.DXSY=-Y*T96.WARP.ZSWW*T96.WARP.DPSRR;
T96.WARP.DXSZ=-T96.WARP.SPSS-Z*T96.WARP.ZSWW*T96.WARP.DPSRR;
T96.WARP.DZSX=T96.WARP.SPSS+X*T96.WARP.XS*T96.WARP.DPSRR;
T96.WARP.DZSY=T96.WARP.XS*Y*T96.WARP.DPSRR  +G*SPS*WS;  %!  THE LAST TERM IS FOR THE Y-Z WARP
T96.WARP.DZSZ=T96.WARP.CPSS+T96.WARP.XS*Z*T96.WARP.DPSRR;        %!      (TAIL MODES ONLY)

T96.WARP.D=D0+DELTADY*(Y/20.D0)^2;   %!  SHEET HALF-THICKNESS FOR THE TAIL MODES
DDDY=DELTADY*Y*0.005D0;      %!  (THICKENS TO FLANKS, BUT NO VARIATION
% C                                         ALONG X, IN CONTRAST TO RING CURRENT)
% C
T96.WARP.DZETAS=sqrt(T96.WARP.ZS^2+T96.WARP.D^2);  %!  THIS IS THE SAME SIMPLE WAY TO SPREAD
% C                                        OUT THE SHEET, AS THAT USED IN T89
T96.WARP.DDZETADX=T96.WARP.ZS*T96.WARP.DZSX/T96.WARP.DZETAS;
T96.WARP.DDZETADY=(T96.WARP.ZS*T96.WARP.DZSY+T96.WARP.D*DDDY)/T96.WARP.DZETAS;
T96.WARP.DDZETADZ=T96.WARP.ZS*T96.WARP.DZSZ/T96.WARP.DZETAS;
% C
[WX,WY,WZ] = T96_SHLCAR3X3(ARC,X,Y,Z,SPS);
[HX,HY,HZ] = T96_RINGCURR96(X,Y,Z);
BXRC=WX+HX;
BYRC=WY+HY;
BZRC=WZ+HZ;
% C
[WX,WY,WZ] = T96_SHLCAR3X3(ATAIL2,X,Y,Z,SPS);
[HX,HY,HZ]  =  T96_TAILDISK(X,Y,Z);
BXT2=WX+HX;
BYT2=WY+HY;
BZT2=WZ+HZ;
% C
[WX,WY,WZ] = T96_SHLCAR3X3(ATAIL3,X,Y,Z,SPS);
[HX,HZ] = T96_TAIL87(X,Z);
BXT3=WX+HX;
BYT3=WY;
BZT3=WZ+HZ;
% C
% end of function TAILRC96



function [BX,BY,BZ] = T96_RINGCURR96(X,Y,Z);
% C
% c********************************************************************
% C
%        SUBROUTINE RINGCURR96(X,Y,Z,BX,BY,BZ)
% c
% c       THIS SUBROUTINE COMPUTES THE COMPONENTS OF THE RING CURRENT FIELD,
% C        SIMILAR TO THAT DESCRIBED BY TSYGANENKO AND PEREDO (1994).  THE
% C          DIFFERENCE IS THAT NOW WE USE SPACEWARPING, AS DESCRIBED IN THE
% C           PAPER ON MODELING BIRKELAND CURRENTS (TSYGANENKO AND STERN, 1996),
% C            INSTEAD OF SHEARING IT IN THE SPIRIT OF THE T89 TAIL MODEL.
% C
% C          IN  ADDITION, INSTEAD OF 7 TERMS FOR THE RING CURRENT MODEL, WE USE
% C             NOW ONLY 2 TERMS;  THIS SIMPLIFICATION ALSO GIVES RISE TO AN
% C                EASTWARD RING CURRENT LOCATED EARTHWARD FROM THE MAIN ONE,
% C                  IN LINE WITH WHAT IS ACTUALLY OBSERVED
% C
% C             FOR DETAILS, SEE NB #3, PAGES 70-73
% C
%        IMPLICIT REAL*8 (A-H,O-Z)
%        DIMENSION F(2),BETA(2)
%        COMMON /WARP/ CPSS,SPSS,DPSRR, XNEXT(3),XS,ZSWARPED,DXSX,DXSY,
%     *   DXSZ,DZSX,DZSYWARPED,DZSZ,OTHER(4),ZS  %!  ZS HERE IS WITHOUT Y-Z WARP
%%%% note some changes to common block and local names:
% original common block (not the same as local block above):
%         COMMON /WARP/ CPSS,SPSS,DPSRR,RPS,WARP,D,XS,ZS,DXSX,DXSY,DXSZ,
%     *   DZSX,DZSY,DZSZ,DZETAS,DDZETADX,DDZETADY,DDZETADZ,ZSWW
% local ZS == T96.WARP.ZSWW
% local DZSYWARPED == T96.WARP.DZSY
% local D ~= T96.WARP.D
% local WARP ~= T96.WARP.WARP
% local RPS ~= T96.WARP.RPS
% local DZETAS ~= T96.WARP.DZETAS
% local DDZETA* ~= T96.WARP.DDZETA*

global T96;
% C
%      DATA D0,DELTADX,XD,XLDX /2.,0.,0.,4./  %!  ACHTUNG !!  THE RC IS NOW
% C                                            COMPLETELY SYMMETRIC (DELTADX=0)
D0 = 2;
DELTADX = 0;
XD = 0;
XLDX = 4;


% C
%       DATA F,BETA /569.895366D0,-1603.386993D0,2.722188D0,3.766875D0/
F = [569.895366D0,-1603.386993D0];
BETA = [2.722188D0,3.766875D0];
% C
% C  THE ORIGINAL VALUES OF F(I) WERE MULTIPLIED BY BETA(I) (TO REDUCE THE
% C     NUMBER OF MULTIPLICATIONS BELOW)  AND BY THE FACTOR -0.43, NORMALIZING
% C      THE DISTURBANCE AT ORIGIN  TO  B=-1nT
% C
DZSY=T96.WARP.XS*Y*T96.WARP.DPSRR;  %! NO WARPING IN THE Y-Z PLANE (ALONG X ONLY), AND
% C                         THIS IS WHY WE DO NOT USE  DZSY FROM THE COMMON-BLOCK
XXD=X-XD;
FDX=0.5D0*(1.D0+XXD/sqrt(XXD^2+XLDX^2));
DDDX=DELTADX*0.5D0*XLDX^2/sqrt(XXD^2+XLDX^2)^3;
D=D0+DELTADX*FDX; % note, not D from common block

DZETAS=sqrt(T96.WARP.ZSWW^2+D^2);  %!  THIS IS THE SAME SIMPLE WAY TO SPREAD
% C                                        OUT THE SHEET, AS THAT USED IN T89
RHOS=sqrt(T96.WARP.XS^2+Y^2);
DDZETADX=(T96.WARP.ZSWW*T96.WARP.DZSX+D*DDDX)/DZETAS;
DDZETADY=T96.WARP.ZSWW*DZSY/DZETAS;
DDZETADZ=T96.WARP.ZSWW*T96.WARP.DZSZ/DZETAS;
if (RHOS<1.D-5),
    DRHOSDX=0.D0;
    DRHOSDY=1.D0*sign(Y);
    DRHOSDZ=0.D0;
else
    DRHOSDX=T96.WARP.XS*T96.WARP.DXSX/RHOS;
    DRHOSDY=(T96.WARP.XS*T96.WARP.DXSY+Y)/RHOS;
    DRHOSDZ=T96.WARP.XS*T96.WARP.DXSZ/RHOS;
end
% C
BX=0.D0;
BY=0.D0;
BZ=0.D0;
% C
for I = 1:2,
    % C
    BI=BETA(I);
    % C
    S1=sqrt((DZETAS+BI)^2+(RHOS+BI)^2);
    S2=sqrt((DZETAS+BI)^2+(RHOS-BI)^2);
    DS1DDZ=(DZETAS+BI)/S1;
    DS2DDZ=(DZETAS+BI)/S2;
    DS1DRHOS=(RHOS+BI)/S1;
    DS2DRHOS=(RHOS-BI)/S2;
    % C
    DS1DX=DS1DDZ*DDZETADX+DS1DRHOS*DRHOSDX;
    DS1DY=DS1DDZ*DDZETADY+DS1DRHOS*DRHOSDY;
    DS1DZ=DS1DDZ*DDZETADZ+DS1DRHOS*DRHOSDZ;
    % C
    DS2DX=DS2DDZ*DDZETADX+DS2DRHOS*DRHOSDX;
    DS2DY=DS2DDZ*DDZETADY+DS2DRHOS*DRHOSDY;
    DS2DZ=DS2DDZ*DDZETADZ+DS2DRHOS*DRHOSDZ;
    % C
    S1TS2=S1*S2;
    S1PS2=S1+S2;
    S1PS2SQ=S1PS2^2;
    FAC1=sqrt(S1PS2SQ-(2.D0*BI)^2);
    AS=FAC1/(S1TS2*S1PS2SQ);
    TERM1=1.D0/(S1TS2*S1PS2*FAC1);
    FAC2=AS/S1PS2SQ;
    DASDS1=TERM1-FAC2/S1*(S2*S2+S1*(3.D0*S1+4.D0*S2));
    DASDS2=TERM1-FAC2/S2*(S1*S1+S2*(3.D0*S2+4.D0*S1));
    % C
    DASDX=DASDS1*DS1DX+DASDS2*DS2DX;
    DASDY=DASDS1*DS1DY+DASDS2*DS2DY;
    DASDZ=DASDS1*DS1DZ+DASDS2*DS2DZ;
    % C
    BX=BX+F(I)*((2.D0*AS+Y*DASDY)*T96.WARP.SPSS-T96.WARP.XS*DASDZ ...
        +AS*T96.WARP.DPSRR*(Y^2*T96.WARP.CPSS+Z*T96.WARP.ZSWW));
    BY=BY-F(I)*Y*(AS*T96.WARP.DPSRR*T96.WARP.XS+DASDZ*T96.WARP.CPSS+DASDX*T96.WARP.SPSS);
    BZ=BZ+F(I)*((2.D0*AS+Y*DASDY)*T96.WARP.CPSS+T96.WARP.XS*DASDX ...
        -AS*T96.WARP.DPSRR*(X*T96.WARP.ZSWW+Y^2*T96.WARP.SPSS));
end
% end of function RINGCURR96

function [BX,BY,BZ] = T96_TAILDISK(X,Y,Z)
% C$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
% C
%         SUBROUTINE TAILDISK(X,Y,Z,BX,BY,BZ)
% C
% c
% c       THIS SUBROUTINE COMPUTES THE COMPONENTS OF THE TAIL CURRENT FIELD,
% C        SIMILAR TO THAT DESCRIBED BY TSYGANENKO AND PEREDO (1994).  THE
% C          DIFFERENCE IS THAT NOW WE USE SPACEWARPING, AS DESCRIBED IN OUR
% C           PAPER ON MODELING BIRKELAND CURRENTS (TSYGANENKO AND STERN, 1996)
% C            INSTEAD OF SHEARING IT IN THE SPIRIT OF T89 TAIL MODEL.
% C
% C          IN  ADDITION, INSTEAD OF 8 TERMS FOR THE TAIL CURRENT MODEL, WE USE
% C           NOW ONLY 4 TERMS
% C
% C             FOR DETAILS, SEE NB #3, PAGES 74-
% C
%IMPLICIT REAL*8 (A-H,O-Z)
%DIMENSION F(4),BETA(4)
%COMMON /WARP/ CPSS,SPSS,DPSRR,XNEXT(3),XS,ZS,DXSX,DXSY,DXSZ,
%*    OTHER(3),DZETAS,DDZETADX,DDZETADY,DDZETADZ,ZSWW
global T96;
%%%% note some changes to common block and local names:
% original common block (not the same as local block above):
%         COMMON /WARP/ CPSS,SPSS,DPSRR,RPS,WARP,D,XS,ZS,DXSX,DXSY,DXSZ,
%     *   DZSX,DZSY,DZSZ,DZETAS,DDZETADX,DDZETADY,DDZETADZ,ZSWW
% local D ~= T96.WARP.D
% local WARP ~= T96.WARP.WARP
% local RPS ~= T96.WARP.RPS
% local DZS* ~= T96.WARP.DZS*
% C
XSHIFT = 4.5;
% C
F = [ -745796.7338D0,1176470.141D0,-444610.529D0,-57508.01028D0];
BETA = [ 7.9250000D0,8.0850000D0,8.4712500D0,27.89500D0];
% c
% c  here original F(I) are multiplied by BETA(I), to economize
% c    calculations
% C
RHOS=sqrt((T96.WARP.XS-XSHIFT)^2+Y^2);
if (RHOS<1.D-5),
    DRHOSDX=0.D0;
    DRHOSDY=1.D0*sign(Y);
    DRHOSDZ=0.D0;
else
    DRHOSDX=(T96.WARP.XS-XSHIFT)*T96.WARP.DXSX/RHOS;
    DRHOSDY=((T96.WARP.XS-XSHIFT)*T96.WARP.DXSY+Y)/RHOS;
    DRHOSDZ=(T96.WARP.XS-XSHIFT)*T96.WARP.DXSZ/RHOS;
end
% C
BX=0.D0;
BY=0.D0;
BZ=0.D0;
% C
for I=1:4,
    % C
    BI=BETA(I);
    % C
    S1=sqrt((T96.WARP.DZETAS+BI)^2+(RHOS+BI)^2);
    S2=sqrt((T96.WARP.DZETAS+BI)^2+(RHOS-BI)^2);
    DS1DDZ=(T96.WARP.DZETAS+BI)/S1;
    DS2DDZ=(T96.WARP.DZETAS+BI)/S2;
    DS1DRHOS=(RHOS+BI)/S1;
    DS2DRHOS=(RHOS-BI)/S2;
    % C
    DS1DX=DS1DDZ*T96.WARP.DDZETADX+DS1DRHOS*DRHOSDX;
    DS1DY=DS1DDZ*T96.WARP.DDZETADY+DS1DRHOS*DRHOSDY;
    DS1DZ=DS1DDZ*T96.WARP.DDZETADZ+DS1DRHOS*DRHOSDZ;
    % C
    DS2DX=DS2DDZ*T96.WARP.DDZETADX+DS2DRHOS*DRHOSDX;
    DS2DY=DS2DDZ*T96.WARP.DDZETADY+DS2DRHOS*DRHOSDY;
    DS2DZ=DS2DDZ*T96.WARP.DDZETADZ+DS2DRHOS*DRHOSDZ;
    % C
    S1TS2=S1*S2;
    S1PS2=S1+S2;
    S1PS2SQ=S1PS2^2;
    FAC1=sqrt(S1PS2SQ-(2.D0*BI)^2);
    AS=FAC1/(S1TS2*S1PS2SQ);
    TERM1=1.D0/(S1TS2*S1PS2*FAC1);
    FAC2=AS/S1PS2SQ;
    DASDS1=TERM1-FAC2/S1*(S2*S2+S1*(3.D0*S1+4.D0*S2));
    DASDS2=TERM1-FAC2/S2*(S1*S1+S2*(3.D0*S2+4.D0*S1));
    % C
    DASDX=DASDS1*DS1DX+DASDS2*DS2DX;
    DASDY=DASDS1*DS1DY+DASDS2*DS2DY;
    DASDZ=DASDS1*DS1DZ+DASDS2*DS2DZ;
    % C
    BX=BX+F(I)*((2.D0*AS+Y*DASDY)*T96.WARP.SPSS-(T96.WARP.XS-XSHIFT)*DASDZ ...
        +AS*T96.WARP.DPSRR*(Y^2*T96.WARP.CPSS+Z*T96.WARP.ZSWW));
    % C
    BY=BY-F(I)*Y*(AS*T96.WARP.DPSRR*T96.WARP.XS+DASDZ*T96.WARP.CPSS+DASDX*T96.WARP.SPSS);
    BZ=BZ+F(I)*((2.D0*AS+Y*DASDY)*T96.WARP.CPSS+(T96.WARP.XS-XSHIFT)*DASDX ...
        -AS*T96.WARP.DPSRR*(X*T96.WARP.ZSWW+Y^2*T96.WARP.SPSS));
end
% end of function TAILDISK

function [BX,BZ] = T96_TAIL87(X,Z)
% C-------------------------------------------------------------------------
% C
%      SUBROUTINE TAIL87(X,Z,BX,BZ)

%IMPLICIT REAL*8 (A-H,O-Z)

%COMMON /WARP/ FIRST(3), RPS,WARP,D, OTHER(13)
global T96;
% only shares T96.WARP.RPS, T96.WARP.WARP, T96.WARP.D
% C
% C      'LONG' VERSION OF THE 1987 TAIL MAGNETIC FIELD MODEL
% C              (N.A.TSYGANENKO, PLANET. SPACE SCI., V.35, P.1347, 1987)
% C
% C      D   IS THE Y-DEPENDENT SHEET HALF-THICKNESS (INCREASING TOWARDS FLANKS)
% C      RPS  IS THE TILT-DEPENDENT SHIFT OF THE SHEET IN THE Z-DIRECTION,
% C           CORRESPONDING TO THE ASYMPTOTIC HINGING DISTANCE, DEFINED IN THE
% C           MAIN SUBROUTINE (TAILRC96) FROM THE PARAMETERS RH AND DR OF THE
% C           T96-TYPE MODULE, AND
% C      WARP  IS THE BENDING OF THE SHEET FLANKS IN THE Z-DIRECTION, DIRECTED
% C           OPPOSITE TO RPS, AND INCREASING WITH DIPOLE TILT AND |Y|
% C

DD = 3.;
% C
HPI = 1.5707963;
RT = 40.;
XN = -10.;
X1 =  -1.261;
X2  = -0.663;
B0 = 0.391734;
B1 = 5.89715;
B2 = 24.6833;
XN21 = 76.37;
XNR =  -0.1071;
ADLN = 0.13238005;
% C                !!!   THESE ARE NEW VALUES OF  X1, X2, B0, B1, B2,
% C                       CORRESPONDING TO TSCALE=1, INSTEAD OF TSCALE=0.6
% C
% C  THE ABOVE QUANTITIES WERE DEFINED AS FOLLOWS:------------------------
% C       HPI=PI/2
% C       RT=40.      !  Z-POSITION OF UPPER AND LOWER ADDITIONAL SHEETS
% C       XN=-10.     !  INNER EDGE POSITION
% C
% C       TSCALE=1  !  SCALING FACTOR, DEFINING THE RATE OF INCREASE OF THE
% C                       CURRENT DENSITY TAILWARDS
% C
% c  ATTENTION !  NOW I HAVE CHANGED TSCALE TO:  TSCALE=1.0, INSTEAD OF 0.6
% c                  OF THE PREVIOUS VERSION
% c
% C       B0=0.391734
% C       B1=5.89715 *TSCALE
% C       B2=24.6833 *TSCALE**2
% C
% C    HERE ORIGINAL VALUES OF THE MODE AMPLITUDES (P.77, NB#3) WERE NORMALIZED
% C      SO THAT ASYMPTOTIC  BX=1  AT X=-200RE
% C
% C      X1=(4.589  -5.85) *TSCALE -(TSCALE-1.)*XN ! NONLINEAR PARAMETERS OF THE
% C                                                         CURRENT FUNCTION
% C      X2=(5.187  -5.85) *TSCALE -(TSCALE-1.)*XN
% c
% c
% C      XN21=(XN-X1)**2
% C      XNR=1./(XN-X2)
% C      ADLN=-DLOG(XNR**2*XN21)
% C
% C---------------------------------------------------------------
% C
ZS=Z -T96.WARP.RPS +T96.WARP.WARP;
ZP=Z-RT;
ZM=Z+RT;
% C
XNX=XN-X;
XNX2=XNX^2;
XC1=X-X1;
XC2=X-X2;
XC22=XC2^2;
XR2=XC2*XNR;
XC12=XC1^2;
D2=DD^2;    %!  SQUARE OF THE TOTAL HALFTHICKNESS (DD=3Re for this mode)
B20=ZS^2+D2;
B2P=ZP^2+D2;
B2M=ZM^2+D2;
B=sqrt(B20);
BP=sqrt(B2P);
BM=sqrt(B2M);
XA1=XC12+B20;
XAP1=XC12+B2P;
XAM1=XC12+B2M;
XA2=1./(XC22+B20);
XAP2=1./(XC22+B2P);
XAM2=1./(XC22+B2M);
XNA=XNX2+B20;
XNAP=XNX2+B2P;
XNAM=XNX2+B2M;
F=B20-XC22;
FP=B2P-XC22;
FM=B2M-XC22;
XLN1=log(XN21/XNA);
XLNP1=log(XN21/XNAP);
XLNM1=log(XN21/XNAM);
XLN2=XLN1+ADLN;
XLNP2=XLNP1+ADLN;
XLNM2=XLNM1+ADLN;
ALN=0.25*(XLNP1+XLNM1-2.*XLN1);
S0=(atan(XNX/B)+HPI)/B;
S0P=(atan(XNX/BP)+HPI)/BP;
S0M=(atan(XNX/BM)+HPI)/BM;
S1=(XLN1*.5+XC1*S0)/XA1;
S1P=(XLNP1*.5+XC1*S0P)/XAP1;
S1M=(XLNM1*.5+XC1*S0M)/XAM1;
S2=(XC2*XA2*XLN2-XNR-F*XA2*S0)*XA2;
S2P=(XC2*XAP2*XLNP2-XNR-FP*XAP2*S0P)*XAP2;
S2M=(XC2*XAM2*XLNM2-XNR-FM*XAM2*S0M)*XAM2;
G1=(B20*S0-0.5*XC1*XLN1)/XA1;
G1P=(B2P*S0P-0.5*XC1*XLNP1)/XAP1;
G1M=(B2M*S0M-0.5*XC1*XLNM1)/XAM1;
G2=((0.5*F*XLN2+2.*S0*B20*XC2)*XA2+XR2)*XA2;
G2P=((0.5*FP*XLNP2+2.*S0P*B2P*XC2)*XAP2+XR2)*XAP2;
G2M=((0.5*FM*XLNM2+2.*S0M*B2M*XC2)*XAM2+XR2)*XAM2;
BX=B0*(ZS*S0-0.5*(ZP*S0P+ZM*S0M)) ...
    +B1*(ZS*S1-0.5*(ZP*S1P+ZM*S1M))+B2*(ZS*S2-0.5*(ZP*S2P+ZM*S2M));
BZ=B0*ALN+B1*(G1-0.5*(G1P+G1M))+B2*(G2-0.5*(G2P+G2M));
% C
% C    CALCULATION OF THE MAGNETOTAIL CURRENT CONTRIBUTION IS FINISHED
% C
% end of function tail87

function [HX,HY,HZ] = T96_SHLCAR3X3(A,X,Y,Z,SPS)
% C$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
% C
% C THIS CODE RETURNS THE SHIELDING FIELD REPRESENTED BY  2x3x3=18 "CARTESIAN"
% C    HARMONICS
% C
%         SUBROUTINE  SHLCAR3X3(A,X,Y,Z,SPS,HX,HY,HZ)
% C
% C - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% C  The 36 coefficients enter in pairs in the amplitudes of the "cartesian"
% c    harmonics (A(1)-A(36).
% c  The 12 nonlinear parameters (A(37)-A(48) are the scales Pi,Ri,Qi,and Si
% C   entering the arguments of exponents, sines, and cosines in each of the
% C   18 "Cartesian" harmonics
% C - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% C
%IMPLICIT  REAL * 8  (A - H, O - Z)
% C
%DIMENSION A(48)
% C
CPS=sqrt(1.D0-SPS^2);
S3PS=4.D0*CPS^2-1.D0;   %!  THIS IS SIN(3*PS)/SIN(PS)
% C
HX=0.D0;
HY=0.D0;
HZ=0.D0;
L=0;
% C
for M=1:2,
    %DO 1 M=1,2     %!    M=1 IS FOR THE 1ST SUM ("PERP." SYMMETRY)
    % C                           AND M=2 IS FOR THE SECOND SUM ("PARALL." SYMMETRY)
    for I = 1:3,
        %DO 2 I=1,3
        P=A(36+I);
        Q=A(42+I);
        CYPI=cos(Y/P);
        CYQI=cos(Y/Q);
        SYPI=sin(Y/P);
        SYQI=sin(Y/Q);
        % C
        for K=1:3,
            %DO 3 K=1,3
            R=A(39+K);
            S=A(45+K);
            SZRK=sin(Z/R);
            CZSK=cos(Z/S);
            CZRK=cos(Z/R);
            SZSK=sin(Z/S);
            SQPR=sqrt(1.D0/P^2+1.D0/R^2);
            SQQS=sqrt(1.D0/Q^2+1.D0/S^2);
            EPR=exp(X*SQPR);
            EQS=exp(X*SQQS);
            % C
            for N = 1:2,
                %DO 4 N=1,2  %! N=1 IS FOR THE FIRST PART OF EACH COEFFICIENT
                % C                                  AND N=2 IS FOR THE SECOND ONE
                % C
                L=L+1;
                if (M==1),
                    if (N==1),
                        DX=-SQPR*EPR*CYPI*SZRK;
                        DY=EPR/P*SYPI*SZRK;
                        DZ=-EPR/R*CYPI*CZRK;
                        HX=HX+A(L)*DX;
                        HY=HY+A(L)*DY;
                        HZ=HZ+A(L)*DZ;
                    else
                        DX=DX*CPS;
                        DY=DY*CPS;
                        DZ=DZ*CPS;
                        HX=HX+A(L)*DX;
                        HY=HY+A(L)*DY;
                        HZ=HZ+A(L)*DZ;
                    end
                else
                    if (N==1),
                        DX=-SPS*SQQS*EQS*CYQI*CZSK;
                        DY=SPS*EQS/Q*SYQI*CZSK;
                        DZ=SPS*EQS/S*CYQI*SZSK;
                        HX=HX+A(L)*DX;
                        HY=HY+A(L)*DY;
                        HZ=HZ+A(L)*DZ;
                    else
                        DX=DX*S3PS;
                        DY=DY*S3PS;
                        DZ=DZ*S3PS;
                        HX=HX+A(L)*DX;
                        HY=HY+A(L)*DY;
                        HZ=HZ+A(L)*DZ;
                    end
                end
                % c
            end %4   CONTINUE
        end %3   CONTINUE
    end %2   CONTINUE
end % 1 CONTINUE
% C
% end of function CHLCAR3X#

function [BX,BY,BZ] = T96_BIRK1TOT_02(PS,X,Y,Z)

% C
% C@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
% C
%       SUBROUTINE BIRK1TOT_02(PS,X,Y,Z,BX,BY,BZ)
% C
% C  THIS IS THE SECOND VERSION OF THE ANALYTICAL MODEL OF THE REGION 1 FIELD
% C   BASED ON A SEPARATE REPRESENTATION OF THE POTENTIAL FIELD IN THE INNER AND
% C   OUTER SPACE, MAPPED BY MEANS OF A SPHERO-DIPOLAR COORDINATE SYSTEM (NB #3,
% C   P.91).   THE DIFFERENCE FROM THE FIRST ONE IS THAT INSTEAD OF OCTAGONAL
% C   CURRENT LOOPS, CIRCULAR ONES ARE USED IN THIS VERSION FOR APPROXIMATING THE
% C   FIELD IN THE OUTER REGION, WHICH IS FASTER.
% C
%IMPLICIT REAL*8 (A-H,O-Z)
% C
%DIMENSION D1(3,26),D2(3,79),XI(4),C1(26),C2(79)
%
%COMMON /COORD11/ XX1(12),YY1(12)
%COMMON /RHDR/ RH,DR
%COMMON /LOOPDIP1/ TILT,XCENTRE(2),RADIUS(2), DIPX,DIPY
% C
%COMMON /COORD21/ XX2(14),YY2(14),ZZ2(14)
%COMMON /DX1/ DX,SCALEIN,SCALEOUT
global T96;
% C
C1 = [-0.911582E-03,-0.376654E-02,-0.727423E-02,-0.270084E-02, ...
        -0.123899E-02,-0.154387E-02,-0.340040E-02,-0.191858E-01,...
        -0.518979E-01,0.635061E-01,0.440680,-0.396570,0.561238E-02,...
        0.160938E-02,-0.451229E-02,-0.251810E-02,-0.151599E-02,...
        -0.133665E-02,-0.962089E-03,-0.272085E-01,-0.524319E-01,...
        0.717024E-01,0.523439,-0.405015,-89.5587,23.2806];

% C
C2 = [6.04133,.305415,.606066E-02,.128379E-03,-.179406E-04,...
        1.41714,-27.2586,-4.28833,-1.30675,35.5607,8.95792,.961617E-03,...
        -.801477E-03,-.782795E-03,-1.65242,-16.5242,-5.33798,.424878E-03,...
        .331787E-03,-.704305E-03,.844342E-03,.953682E-04,.886271E-03,...
        25.1120,20.9299,5.14569,-44.1670,-51.0672,-1.87725,20.2998,...
        48.7505,-2.97415,3.35184,-54.2921,-.838712,-10.5123,70.7594,...
        -4.94104,.106166E-03,.465791E-03,-.193719E-03,10.8439,-29.7968,...
        8.08068,.463507E-03,-.224475E-04,.177035E-03,-.317581E-03,...
        -.264487E-03,.102075E-03,7.71390,10.1915,-4.99797,-23.1114,...
        -29.2043,12.2928,10.9542,33.6671,-9.3851,.174615E-03,-.789777E-06,...
        .686047E-03,.460104E-04,-.345216E-02,.221871E-02,.110078E-01,...
        -.661373E-02,.249201E-02,.343978E-01,-.193145E-05,.493963E-05,...
        -.535748E-04,.191833E-04,-.100496E-03,-.210103E-03,-.232195E-02,...
        .315335E-02,-.134320E-01,-.263222E-01];
% c
T96.LOOPDIP1.TILT = 1.00891;
T96.LOOPDIP1.XCENTRE = [2.28397,-5.60831];
T96.LOOPDIP1.RADIUS = [1.86106,7.83281];
T96.LOOPDIP1.DIPX = 1.12541;
T96.LOOPDIP1.DIPY = 0.945719;

T96.DX1.DX = -0.16D0;
T96.DX1.SCALEIN = 0.08D0;
T96.DX1.SCALEOUT = 0.4D0;

T96.COORD11.XX1 = [ -11.D0,repmat(-7.D0,1,2),repmat(-3.D0,1,2),repmat(1.D0,1,3),repmat(5.D0,1,2),repmat(9.D0,1,2)];
T96.COORD11.YY1 = [ 2.D0,0.D0,4.D0,2.D0,6.D0,0.D0,4.D0,8.D0,2.D0,6.D0,0.D0, 4.D0];
T96.COORD21.XX2 = [-10.D0,-7.D0,repmat(-4.D0,1,2),0.D0,repmat(4.D0,1,2),7.D0,10.D0,repmat(0.D0,1,5)];
T96.COORD21.YY2 = [3.D0,6.D0,3.D0,9.D0,6.D0,3.D0,9.D0,6.D0,3.D0,5*0.D0];
T96.COORD21.ZZ2 = [repmat(20.D0,1,2),4.D0,20.D0,repmat(4.D0,1,2),repmat(20.D0,1,3),2.D0,3.D0,4.5D0,7.D0,10.D0];
% C
T96.RHDR.RH = 9.D0;   %!  RH IS THE "HINGING DISTANCE" AND DR IS THE
T96.RHDR.DR = 4.D0;   % TRANSITION SCALE LENGTH, DEFINING THE
% C                                CURVATURE  OF THE WARPING (SEE P.89, NB #2)
% C
XLTDAY = 78.D0;
XLTNGHT = 70.D0;
%!  THESE ARE LATITUDES OF THE R-1 OVAL
% C                                             AT NOON AND AT MIDNIGHT
DTET0  = 0.034906;  %!   THIS IS THE LATITUDINAL HALF-THICKNESS OF THE
% C                                  R-1 OVAL (THE INTERPOLATION REGION BETWEEN
% C                                    THE HIGH-LAT. AND THE PLASMA SHEET)
% C
TNOONN=(90.D0-XLTDAY)*0.01745329D0;
TNOONS=3.141592654D0-TNOONN;     %! HERE WE ASSUME THAT THE POSITIONS OF
% C                                          THE NORTHERN AND SOUTHERN R-1 OVALS
% C                                          ARE SYMMETRIC IN THE SM-COORDINATES
DTETDN=(XLTDAY-XLTNGHT)*0.01745329D0;
DR2=T96.RHDR.DR^2;
% C
SPS=sin(PS);
R2=X^2+Y^2+Z^2;
R=sqrt(R2);
R3=R*R2;
% C
RMRH=R-T96.RHDR.RH;
RPRH=R+T96.RHDR.RH;
SQM=sqrt(RMRH^2+DR2);
SQP=sqrt(RPRH^2+DR2);
C=SQP-SQM;
Q=sqrt((T96.RHDR.RH+1.D0)^2+DR2)-sqrt((T96.RHDR.RH-1.D0)^2+DR2);
SPSAS=SPS/R*C/Q;
CPSAS=sqrt(1.D0-SPSAS^2);
XAS = X*CPSAS-Z*SPSAS;
ZAS = X*SPSAS+Z*CPSAS;
if (XAS~=0.D0) | (Y~=0.D0),
    PAS = atan2(Y,XAS);
else
    PAS=0.D0;
end
% C
TAS=atan2(sqrt(XAS^2+Y^2),ZAS);
STAS=sin(TAS);
F=STAS/(STAS^6*(1.D0-R3)+R3)^0.1666666667D0;
% C
TET0=asin(F);
if (TAS>1.5707963D0), TET0=3.141592654D0-TET0; end
DTET=DTETDN*sin(PAS*0.5D0)^2;
TETR1N=TNOONN+DTET;
TETR1S=TNOONS-DTET;
% C
% C NOW LET'S DEFINE WHICH OF THE FOUR REGIONS (HIGH-LAT., NORTHERN PSBL,
% C   PLASMA SHEET, SOUTHERN PSBL) DOES THE POINT (X,Y,Z) BELONG TO:
% C
if (TET0<TETR1N-DTET0) | (TET0>TETR1S+DTET0),  LOC=1; end %! HIGH-LAT.
if (TET0>TETR1N+DTET0) & (TET0<TETR1S-DTET0), LOC=2; end %! PL.SHEET
if (TET0>=TETR1N-DTET0) & (TET0<=TETR1N+DTET0), LOC=3; end %! NORTH PSBL
if (TET0>=TETR1S-DTET0) & (TET0<=TETR1S+DTET0), LOC=4; end %! SOUTH PSBL
% C
if (LOC==1),   %! IN THE HIGH-LAT. REGION USE THE SUBROUTINE DIPOCT
    % C
    % C      print *, '  LOC=1 (HIGH-LAT)'    !  (test printout; disabled now)
    XI(1)=X;
    XI(2)=Y;
    XI(3)=Z;
    XI(4)=PS;
    D1 = T96_DIPLOOP1(XI);
    
    % for loop replaced
    % BX=0.D0;
    % BY=0.D0;
    % BZ=0.D0;
    % for I = 1:26,
    %     BX=BX+C1(I)*D1(1,I);
    %     BY=BY+C1(I)*D1(2,I);
    %     BZ=BZ+C1(I)*D1(3,I);
    % end
    BX = sum(D1(1,:).*C1);
    BY = sum(D1(2,:).*C1);
    BZ = sum(D1(3,:).*C1);
end                                           %!  END OF THE CASE 1

% C
if (LOC==2),
    % C           print *, '  LOC=2 (PLASMA SHEET)'  !  (test printout; disabled now)
    % C
    XI(1)=X;
    XI(2)=Y;
    XI(3)=Z;
    XI(4)=PS;
    D2 = T96_CONDIP1(XI);
    
    % for loop replaced
    %BX=0.D0;
    %BY=0.D0;
    %BZ=0.D0;
    % for I=1:79,
    %     BX=BX+C2(I)*D2(1,I)
    %     BY=BY+C2(I)*D2(2,I)
    %     BZ=BZ+C2(I)*D2(3,I)
    % end
    BX = sum(D2(1,:).*C2);
    BY = sum(D2(2,:).*C2);
    BZ = sum(D2(3,:).*C2);
    
end %!   END OF THE CASE 2
% C
if (LOC==3),
    % C       print *, '  LOC=3 (north PSBL)'  !  (test printout; disabled now)
    % C
    T01=TETR1N-DTET0;
    T02=TETR1N+DTET0;
    SQR=sqrt(R);
    ST01AS=SQR/(R3+1.D0/sin(T01)^6-1.D0)^0.1666666667;
    ST02AS=SQR/(R3+1.D0/sin(T02)^6-1.D0)^0.1666666667;
    CT01AS=sqrt(1.D0-ST01AS^2);
    CT02AS=sqrt(1.D0-ST02AS^2);
    XAS1=R*ST01AS*cos(PAS);
    Y1=  R*ST01AS*sin(PAS);
    ZAS1=R*CT01AS;
    X1=XAS1*CPSAS+ZAS1*SPSAS;
    Z1=-XAS1*SPSAS+ZAS1*CPSAS; %! X1,Y1,Z1 ARE COORDS OF THE NORTHERN
    % c                                                      BOUNDARY POINT
    XI(1)=X1;
    XI(2)=Y1;
    XI(3)=Z1;
    XI(4)=PS;
    D1 = T96_DIPLOOP1(XI);
    
    % for loop replaced
    % BX1=0.D0
    % BY1=0.D0
    % BZ1=0.D0
    % DO 11 I=1,26
    % BX1=BX1+C1(I)*D1(1,I) %!   BX1,BY1,BZ1  ARE FIELD COMPONENTS
    % BY1=BY1+C1(I)*D1(2,I)  %!  IN THE NORTHERN BOUNDARY POINT
    % 11           BZ1=BZ1+C1(I)*D1(3,I)  %!
    BX1 = sum(C1.*D1(1,:));
    BY1 = sum(C1.*D1(2,:));
    BZ1 = sum(C1.*D1(3,:));
    
    % C
    XAS2=R*ST02AS*cos(PAS);
    Y2=  R*ST02AS*sin(PAS);
    ZAS2=R*CT02AS;
    X2=XAS2*CPSAS+ZAS2*SPSAS;
    Z2=-XAS2*SPSAS+ZAS2*CPSAS; %! X2,Y2,Z2 ARE COORDS OF THE SOUTHERN
    % C                                        BOUNDARY POINT
    XI(1)=X2;
    XI(2)=Y2;
    XI(3)=Z2;
    XI(4)=PS;
    D2 = T96_CONDIP1(XI);
    
    % for loop replaced
    % BX2=0.D0
    % BY2=0.D0
    % BZ2=0.D0
    % DO 12 I=1,79
    % BX2=BX2+C2(I)*D2(1,I)%!  BX2,BY2,BZ2  ARE FIELD COMPONENTS
    % BY2=BY2+C2(I)*D2(2,I) %!  IN THE SOUTHERN BOUNDARY POINT
    % 12          BZ2=BZ2+C2(I)*D2(3,I)
    
    BX2 = sum(C2.*D2(1,:));
    BY2 = sum(C2.*D2(2,:));
    BZ2 = sum(C2.*D2(3,:));
    
    % C
    % C  NOW INTERPOLATE:
    % C
    SS=sqrt((X2-X1)^2+(Y2-Y1)^2+(Z2-Z1)^2);
    DS=sqrt((X-X1)^2+(Y-Y1)^2+(Z-Z1)^2);
    FRAC=DS/SS;
    BX=BX1*(1.D0-FRAC)+BX2*FRAC;
    BY=BY1*(1.D0-FRAC)+BY2*FRAC;
    BZ=BZ1*(1.D0-FRAC)+BZ2*FRAC;
    % C
end %! END OF THE CASE 3
% C
if (LOC==4),
    % C       print *, '  LOC=4 (south PSBL)'  !  (test printout; disabled now)
    % C
    T01=TETR1S-DTET0;
    T02=TETR1S+DTET0;
    SQR=sqrt(R);
    ST01AS=SQR/(R3+1.D0/sin(T01)^6-1.D0)^0.1666666667;
    ST02AS=SQR/(R3+1.D0/sin(T02)^6-1.D0)^0.1666666667;
    CT01AS=-sqrt(1.D0-ST01AS^2);
    CT02AS=-sqrt(1.D0-ST02AS^2);
    XAS1=R*ST01AS*cos(PAS);
    Y1=  R*ST01AS*sin(PAS);
    ZAS1=R*CT01AS;
    X1=XAS1*CPSAS+ZAS1*SPSAS;
    Z1=-XAS1*SPSAS+ZAS1*CPSAS; %! X1,Y1,Z1 ARE COORDS OF THE NORTHERN
    % C                                               BOUNDARY POINT
    XI(1)=X1;
    XI(2)=Y1;
    XI(3)=Z1;
    XI(4)=PS;
    D2 = T96_CONDIP1(XI);
    
    % for loop replaced
    % BX1=0.D0
    % BY1=0.D0
    % BZ1=0.D0
    % DO 21 I=1,79
    % BX1=BX1+C2(I)*D2(1,I) %!  BX1,BY1,BZ1  ARE FIELD COMPONENTS
    % BY1=BY1+C2(I)*D2(2,I)  %!  IN THE NORTHERN BOUNDARY POINT
    % 21           BZ1=BZ1+C2(I)*D2(3,I)  %!
    BX1 = sum(C2.*D2(1,:));
    BY1 = sum(C2.*D2(2,:));
    BZ1 = sum(C2.*D2(3,:));
    
    % C
    XAS2=R*ST02AS*cos(PAS);
    Y2=  R*ST02AS*sin(PAS);
    ZAS2=R*CT02AS;
    X2=XAS2*CPSAS+ZAS2*SPSAS;
    Z2=-XAS2*SPSAS+ZAS2*CPSAS; %! X2,Y2,Z2 ARE COORDS OF THE SOUTHERN
    %C                                          BOUNDARY POINT
    XI(1)=X2;
    XI(2)=Y2;
    XI(3)=Z2;
    XI(4)=PS;
    D1 = T96_DIPLOOP1(XI);
    
    % for loop replaced
    % BX2=0.D0
    % BY2=0.D0
    % BZ2=0.D0
    % DO 22 I=1,26
    % BX2=BX2+C1(I)*D1(1,I) %!  BX2,BY2,BZ2  ARE FIELD COMPONENTS
    % BY2=BY2+C1(I)*D1(2,I) %!     IN THE SOUTHERN BOUNDARY POINT
    % 22          BZ2=BZ2+C1(I)*D1(3,I)
    
    BX2 = sum(C1.*D1(1,:));
    BY2 = sum(C1.*D1(2,:));
    BZ2 = sum(C1.*D1(3,:));
    
    
    % C
    % C  NOW INTERPOLATE:
    % C
    SS=sqrt((X2-X1)^2+(Y2-Y1)^2+(Z2-Z1)^2);
    DS=sqrt((X-X1)^2+(Y-Y1)^2+(Z-Z1)^2);
    FRAC=DS/SS;
    BX=BX1*(1.D0-FRAC)+BX2*FRAC;
    BY=BY1*(1.D0-FRAC)+BY2*FRAC;
    BZ=BZ1*(1.D0-FRAC)+BZ2*FRAC;
    % C
end                 %! END OF THE CASE 4
% C
% C   NOW, LET US ADD THE SHIELDING FIELD
% C
[BSX,BSY,BSZ] = T96_BIRK1SHLD(PS,X,Y,Z);
BX=BX+BSX;
BY=BY+BSY;
BZ=BZ+BSZ;
% end of BIRK1TOT_02

% C
% C------------------------------------------------------------------------------
% C
% C
function D = T96_DIPLOOP1(XI)
%SUBROUTINE  DIPLOOP1(XI,D)
% C
% C
% C      Calculates dependent model variables and their deriva-
% C  tives for given independent variables and model parame-
% C  ters.  Specifies model functions with free parameters which
% C  must be determined by means of least squares fits (RMS
% C  minimization procedure).
% C
% C      Description of parameters:
% C
% C  XI  - input vector containing independent variables;
% C  D   - output double precision vector containing
% C        calculated values for derivatives of dependent
% C        variables with respect to LINEAR model parameters;
% C
% C - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% C
% c  The  26 coefficients are moments (Z- and X-components) of 12 dipoles placed
% C    inside the  R1-shell,  PLUS amplitudes of two octagonal double loops.
% C     The dipoles with nonzero  Yi appear in pairs with equal moments.
% c                  (see the notebook #2, pp.102-103, for details)
% C - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% c
%IMPLICIT  REAL * 8  (A - H, O - Z)
% C
%COMMON /COORD11/ XX(12),YY(12)
% XX -> COORD11.XX1
% YY -> COORD11.YY1
%COMMON /LOOPDIP1/ TILT,XCENTRE(2),RADIUS(2),  DIPX,DIPY
%COMMON /RHDR/RH,DR
global T96;
%DIMENSION XI(4),D(3,26)
D = repmat(nan,3,26);
% C
X = XI(1);
Y = XI(2);
Z = XI(3);
PS= XI(4);
SPS=sin(PS);
% C
for I = 1:12,
    %DO 1 I=1,12
    R2=(T96.COORD11.XX1(I)*T96.LOOPDIP1.DIPX)^2+(T96.COORD11.YY1(I)*T96.LOOPDIP1.DIPY)^2;
    R=sqrt(R2);
    RMRH=R-T96.RHDR.RH;
    RPRH=R+T96.RHDR.RH;
    DR2=T96.RHDR.DR^2;
    SQM=sqrt(RMRH^2+DR2);
    SQP=sqrt(RPRH^2+DR2);
    C=SQP-SQM;
    Q=sqrt((T96.RHDR.RH+1.D0)^2+DR2)-sqrt((T96.RHDR.RH-1.D0)^2+DR2);
    SPSAS=SPS/R*C/Q;
    CPSAS=sqrt(1.D0-SPSAS^2);
    XD= (T96.COORD11.XX1(I)*T96.LOOPDIP1.DIPX)*CPSAS;
    YD= (T96.COORD11.YY1(I)*T96.LOOPDIP1.DIPY);
    ZD=-(T96.COORD11.XX1(I)*T96.LOOPDIP1.DIPX)*SPSAS;
    
    [BX1X,BY1X,BZ1X,BX1Y,BY1Y,BZ1Y,BX1Z,BY1Z,BZ1Z]  = T96_DIPXYZ(X-XD,Y-YD,Z-ZD);
    
    if (abs(YD)>1.D-10),
        [BX2X,BY2X,BZ2X,BX2Y,BY2Y,BZ2Y,BX2Z,BY2Z,BZ2Z] = T96_DIPXYZ(X-XD,Y+YD,Z-ZD);
    else
        BX2X=0.D0;
        BY2X=0.D0;
        BZ2X=0.D0;
        % C
        BX2Z=0.D0;
        BY2Z=0.D0;
        BZ2Z=0.D0;
    end
    % C
    D(1,I)=BX1Z+BX2Z;
    D(2,I)=BY1Z+BY2Z;
    D(3,I)=BZ1Z+BZ2Z;
    D(1,I+12)=(BX1X+BX2X)*SPS;
    D(2,I+12)=(BY1X+BY2X)*SPS;
    D(3,I+12)=(BZ1X+BZ2X)*SPS;
end % 1   CONTINUE
% c
R2=(T96.LOOPDIP1.XCENTRE(1)+T96.LOOPDIP1.RADIUS(1))^2;
R=sqrt(R2);
RMRH=R-T96.RHDR.RH;
RPRH=R+T96.RHDR.RH;
DR2=T96.RHDR.DR^2;
SQM=sqrt(RMRH^2+DR2);
SQP=sqrt(RPRH^2+DR2);
C=SQP-SQM;
Q=sqrt((T96.RHDR.RH+1.D0)^2+DR2)-sqrt((T96.RHDR.RH-1.D0)^2+DR2);
SPSAS=SPS/R*C/Q;
CPSAS=sqrt(1.D0-SPSAS^2);
XOCT1= X*CPSAS-Z*SPSAS;
YOCT1= Y;
ZOCT1= X*SPSAS+Z*CPSAS;
% C
[BXOCT1,BYOCT1,BZOCT1] = T96_CROSSLP(XOCT1,YOCT1,ZOCT1,T96.LOOPDIP1.XCENTRE(1),T96.LOOPDIP1.RADIUS(1),T96.LOOPDIP1.TILT);
D(1,25)=BXOCT1*CPSAS+BZOCT1*SPSAS;
D(2,25)=BYOCT1;
D(3,25)=-BXOCT1*SPSAS+BZOCT1*CPSAS;
% C
R2=(T96.LOOPDIP1.RADIUS(2)-T96.LOOPDIP1.XCENTRE(2))^2;
R=sqrt(R2);
RMRH=R-T96.RHDR.RH;
RPRH=R+T96.RHDR.RH;
DR2=T96.RHDR.DR^2;
SQM=sqrt(RMRH^2+DR2);
SQP=sqrt(RPRH^2+DR2);
C=SQP-SQM;
Q=sqrt((T96.RHDR.RH+1.D0)^2+DR2)-sqrt((T96.RHDR.RH-1.D0)^2+DR2);
SPSAS=SPS/R*C/Q;
CPSAS=sqrt(1.D0-SPSAS^2);
XOCT2= X*CPSAS-Z*SPSAS -T96.LOOPDIP1.XCENTRE(2);
YOCT2= Y;
ZOCT2= X*SPSAS+Z*CPSAS;
[BX,BY,BZ] = T96_CIRCLE(XOCT2,YOCT2,ZOCT2,T96.LOOPDIP1.RADIUS(2));
D(1,26) =  BX*CPSAS+BZ*SPSAS;
D(2,26) =  BY;
D(3,26) = -BX*SPSAS+BZ*CPSAS;
% C
% end of DIPLOOP1

% c-------------------------------------------------------------------------
% C
function [BX,BY,BZ] = T96_CIRCLE(X,Y,Z,RL);
%SUBROUTINE CIRCLE(X,Y,Z,RL,BX,BY,BZ)
% C
% C  RETURNS COMPONENTS OF THE FIELD FROM A CIRCULAR CURRENT LOOP OF RADIUS RL
% C  USES THE SECOND (MORE ACCURATE) APPROXIMATION GIVEN IN ABRAMOWITZ AND STEGUN

%IMPLICIT REAL*8 (A-H,O-Z)
%REAL*8 K
PI = 3.141592654D0;
% C
RHO2=X*X+Y*Y;
RHO=sqrt(RHO2);
R22=Z*Z+(RHO+RL)^2;
R2=sqrt(R22);
R12=R22-4.D0*RHO*RL;
R32=0.5D0*(R12+R22);
XK2=1.D0-R12/R22;
XK2S=1.D0-XK2;
DL=log(1.D0/XK2S);
K=1.38629436112d0+XK2S*(0.09666344259D0+XK2S*(0.03590092383+ ...
    XK2S*(0.03742563713+XK2S*0.01451196212))) +DL* ...
    (0.5D0+XK2S*(0.12498593597D0+XK2S*(0.06880248576D0+ ...
    XK2S*(0.03328355346D0+XK2S*0.00441787012D0))));
E=1.D0+XK2S*(0.44325141463D0+XK2S*(0.0626060122D0+XK2S* ...
    (0.04757383546D0+XK2S*0.01736506451D0))) +DL* ...
    XK2S*(0.2499836831D0+XK2S*(0.09200180037D0+XK2S* ...
    (0.04069697526D0+XK2S*0.00526449639D0)));

if (RHO>1.D-6),
    BRHO=Z/(RHO2*R2)*(R32/R12*E-K); %!  THIS IS NOT EXACTLY THE B-RHO COM-
else           %!   PONENT - NOTE THE ADDITIONAL
    BRHO=PI*RL/R2*(RL-RHO)/R12*Z/(R32-RHO2);  %!      DIVISION BY RHO
end

BX=BRHO*X;
BY=BRHO*Y;
BZ=(K-E*(R32-2.D0*RL*RL)/R12)/R2;
% end of funciton CIRCLE


% C-------------------------------------------------------------
% C
function [BX,BY,BZ] = T96_CROSSLP(X,Y,Z,XC,RL,AL)
%SUBROUTINE CROSSLP(X,Y,Z,BX,BY,BZ,XC,RL,AL)
% C
% c   RETURNS FIELD COMPONENTS OF A PAIR OF LOOPS WITH A COMMON CENTER AND
% C    DIAMETER,  COINCIDING WITH THE X AXIS. THE LOOPS ARE INCLINED TO THE
% C    EQUATORIAL PLANE BY THE ANGLE AL (RADIANS) AND SHIFTED IN THE POSITIVE
% C     X-DIRECTION BY THE DISTANCE  XC.
% c
%IMPLICIT REAL*8 (A-H,O-Z)
% C
CAL=cos(AL);
SAL=sin(AL);
% C
Y1=Y*CAL-Z*SAL;
Z1=Y*SAL+Z*CAL;
Y2=Y*CAL+Z*SAL;
Z2=-Y*SAL+Z*CAL;
[BX1,BY1,BZ1] = T96_CIRCLE(X-XC,Y1,Z1,RL);
[BX2,BY2,BZ2] = T96_CIRCLE(X-XC,Y2,Z2,RL);
BX=BX1+BX2;
BY= (BY1+BY2)*CAL+(BZ1-BZ2)*SAL;
BZ=-(BY1-BY2)*SAL+(BZ1+BZ2)*CAL;
% C
% end of function CROSSLP


% C*******************************************************************
function [BXX,BYX,BZX,BXY,BYY,BZY,BXZ,BYZ,BZZ] = T96_DIPXYZ(X,Y,Z);
% SUBROUTINE DIPXYZ(X,Y,Z,BXX,BYX,BZX,BXY,BYY,BZY,BXZ,BYZ,BZZ)
% C
% C       RETURNS THE FIELD COMPONENTS PRODUCED BY THREE DIPOLES, EACH
% C        HAVING M=Me AND ORIENTED PARALLEL TO X,Y, and Z AXIS, RESP.
% C
%IMPLICIT REAL*8 (A-H,O-Z)
% C
X2=X^2;
Y2=Y^2;
Z2=Z^2;
R2=X2+Y2+Z2;

XMR5=30574.D0/(R2*R2*sqrt(R2));
XMR53=3.D0*XMR5;
BXX=XMR5*(3.D0*X2-R2);
BYX=XMR53*X*Y;
BZX=XMR53*X*Z;
% C
BXY=BYX;
BYY=XMR5*(3.D0*Y2-R2);
BZY=XMR53*Y*Z;
% C
BXZ=BZX;
BYZ=BZY;
BZZ=XMR5*(3.D0*Z2-R2);
% C
% end of function DIPXYZ

% C
% C------------------------------------------------------------------------------
function D = T96_CONDIP1(XI)
%SUBROUTINE  CONDIP1(XI,D)
% C
% C      Calculates dependent model variables and their derivatives for given
% C  independent variables and model parameters.  Specifies model functions with
% C  free parameters which must be determined by means of least squares fits
% C  (RMS minimization procedure).
% C
% C      Description of parameters:
% C
% C  XI  - input vector containing independent variables;
% C  D   - output double precision vector containing
% C        calculated values for derivatives of dependent
% C        variables with respect to LINEAR model parameters;
% C
% C - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% C
% c  The  79 coefficients are (1) 5 amplitudes of the conical harmonics, plus
% c                           (2) (9x3+5x2)x2=74 components of the dipole moments
% c              (see the notebook #2, pp.113-..., for details)
% C - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% c
%IMPLICIT  REAL * 8  (A - H, O - Z)
% C
%COMMON /DX1/ DX,SCALEIN,SCALEOUT
%COMMON /COORD21/ XX(14),YY(14),ZZ(14)
global T96;
% XX -> COORD21.XX2
% YY -> COORD21.YY2
% ZZ -> COORD21.ZZ2
% c
%DIMENSION XI(4),D(3,79),CF(5),SF(5)
D = repmat(nan,3,79);
% C
X = XI(1);
Y = XI(2);
Z = XI(3);
PS= XI(4);
SPS=sin(PS);
CPS=cos(PS);
% C
XSM=X*CPS-Z*SPS  - T96.DX1.DX;
ZSM=Z*CPS+X*SPS;
RO2=XSM^2+Y^2;
RO=sqrt(RO2);
% C
CF(1)=XSM/RO;
SF(1)=Y/RO;
% C
CF(2)=CF(1)^2-SF(1)^2;
SF(2)=2.*SF(1)*CF(1);
CF(3)=CF(2)*CF(1)-SF(2)*SF(1);
SF(3)=SF(2)*CF(1)+CF(2)*SF(1);
CF(4)=CF(3)*CF(1)-SF(3)*SF(1);
SF(4)=SF(3)*CF(1)+CF(3)*SF(1);
CF(5)=CF(4)*CF(1)-SF(4)*SF(1);
SF(5)=SF(4)*CF(1)+CF(4)*SF(1);
% C
R2=RO2+ZSM^2;
R=sqrt(R2);
C=ZSM/R;
S=RO/R;
CH=sqrt(0.5D0*(1.D0+C));
SH=sqrt(0.5D0*(1.D0-C));
TNH=SH/CH;
CNH=1.D0/TNH;
% C
for M=1:5,
    %DO 1 M=1,5
    BT=M*CF(M)/(R*S)*(TNH^M+CNH^M);
    BF=-0.5D0*M*SF(M)/R*(TNH^(M-1)/CH^2-CNH^(M-1)/SH^2);
    BXSM=BT*C*CF(1)-BF*SF(1);
    BY=BT*C*SF(1)+BF*CF(1);
    BZSM=-BT*S;
    % C
    D(1,M)=BXSM*CPS+BZSM*SPS;
    D(2,M)=BY;
    D(3,M)=-BXSM*SPS+BZSM*CPS;
end
% C
XSM = X*CPS-Z*SPS;
ZSM = Z*CPS+X*SPS;
% C
for I=1:9,
    %DO 2 I=1,9
    % C
    if (I==3) | (I==5) | (I==6),
        XD =  T96.COORD21.XX2(I)*T96.DX1.SCALEIN;
        YD =  T96.COORD21.YY2(I)*T96.DX1.SCALEIN;
    else
        XD =  T96.COORD21.XX2(I)*T96.DX1.SCALEOUT;
        YD =  T96.COORD21.YY2(I)*T96.DX1.SCALEOUT;
    end
    % C
    ZD =  T96.COORD21.ZZ2(I);
    % C
    [BX1X,BY1X,BZ1X,BX1Y,BY1Y,BZ1Y,BX1Z,BY1Z,BZ1Z] = T96_DIPXYZ(XSM-XD,Y-YD,ZSM-ZD);
    [BX2X,BY2X,BZ2X,BX2Y,BY2Y,BZ2Y,BX2Z,BY2Z,BZ2Z] = T96_DIPXYZ(XSM-XD,Y+YD,ZSM-ZD);
    [BX3X,BY3X,BZ3X,BX3Y,BY3Y,BZ3Y,BX3Z,BY3Z,BZ3Z] = T96_DIPXYZ(XSM-XD,Y-YD,ZSM+ZD);
    [BX4X,BY4X,BZ4X,BX4Y,BY4Y,BZ4Y,BX4Z,BY4Z,BZ4Z] = T96_DIPXYZ(XSM-XD,Y+YD,ZSM+ZD);
    % C
    IX=I*3+3;
    IY=IX+1;
    IZ=IY+1;
    % C
    D(1,IX)=(BX1X+BX2X-BX3X-BX4X)*CPS+(BZ1X+BZ2X-BZ3X-BZ4X)*SPS;
    D(2,IX)= BY1X+BY2X-BY3X-BY4X;
    D(3,IX)=(BZ1X+BZ2X-BZ3X-BZ4X)*CPS-(BX1X+BX2X-BX3X-BX4X)*SPS;
    % C
    D(1,IY)=(BX1Y-BX2Y-BX3Y+BX4Y)*CPS+(BZ1Y-BZ2Y-BZ3Y+BZ4Y)*SPS;
    D(2,IY)= BY1Y-BY2Y-BY3Y+BY4Y;
    D(3,IY)=(BZ1Y-BZ2Y-BZ3Y+BZ4Y)*CPS-(BX1Y-BX2Y-BX3Y+BX4Y)*SPS;
    % C
    D(1,IZ)=(BX1Z+BX2Z+BX3Z+BX4Z)*CPS+(BZ1Z+BZ2Z+BZ3Z+BZ4Z)*SPS;
    D(2,IZ)= BY1Z+BY2Z+BY3Z+BY4Z;
    D(3,IZ)=(BZ1Z+BZ2Z+BZ3Z+BZ4Z)*CPS-(BX1Z+BX2Z+BX3Z+BX4Z)*SPS;
    % C
    IX=IX+27;
    IY=IY+27;
    IZ=IZ+27;
    % C
    D(1,IX)=SPS*((BX1X+BX2X+BX3X+BX4X)*CPS+(BZ1X+BZ2X+BZ3X+BZ4X)*SPS);
    D(2,IX)=SPS*(BY1X+BY2X+BY3X+BY4X);
    D(3,IX)=SPS*((BZ1X+BZ2X+BZ3X+BZ4X)*CPS-(BX1X+BX2X+BX3X+BX4X)*SPS);
    % C
    D(1,IY)=SPS*((BX1Y-BX2Y+BX3Y-BX4Y)*CPS+(BZ1Y-BZ2Y+BZ3Y-BZ4Y)*SPS);
    D(2,IY)=SPS*(BY1Y-BY2Y+BY3Y-BY4Y);
    D(3,IY)=SPS*((BZ1Y-BZ2Y+BZ3Y-BZ4Y)*CPS-(BX1Y-BX2Y+BX3Y-BX4Y)*SPS);
    % C
    D(1,IZ)=SPS*((BX1Z+BX2Z-BX3Z-BX4Z)*CPS+(BZ1Z+BZ2Z-BZ3Z-BZ4Z)*SPS);
    D(2,IZ)=SPS*(BY1Z+BY2Z-BY3Z-BY4Z);
    D(3,IZ)=SPS*((BZ1Z+BZ2Z-BZ3Z-BZ4Z)*CPS-(BX1Z+BX2Z-BX3Z-BX4Z)*SPS);
end % 2   CONTINUE
% C
for I=1:5,
    ZD=T96.COORD21.ZZ2(I+9);
    [BX1X,BY1X,BZ1X,BX1Y,BY1Y,BZ1Y,BX1Z,BY1Z,BZ1Z] = T96_DIPXYZ(XSM,Y,ZSM-ZD);
    [BX2X,BY2X,BZ2X,BX2Y,BY2Y,BZ2Y,BX2Z,BY2Z,BZ2Z] = T96_DIPXYZ(XSM,Y,ZSM+ZD);
    IX=58+I*2;
    IZ=IX+1;
    D(1,IX)=(BX1X-BX2X)*CPS+(BZ1X-BZ2X)*SPS;
    D(2,IX)=BY1X-BY2X;
    D(3,IX)=(BZ1X-BZ2X)*CPS-(BX1X-BX2X)*SPS;
    % C
    D(1,IZ)=(BX1Z+BX2Z)*CPS+(BZ1Z+BZ2Z)*SPS;
    D(2,IZ)=BY1Z+BY2Z;
    D(3,IZ)=(BZ1Z+BZ2Z)*CPS-(BX1Z+BX2Z)*SPS;
    % C
    IX=IX+10;
    IZ=IZ+10;
    D(1,IX)=SPS*((BX1X+BX2X)*CPS+(BZ1X+BZ2X)*SPS);
    D(2,IX)=SPS*(BY1X+BY2X);
    D(3,IX)=SPS*((BZ1X+BZ2X)*CPS-(BX1X+BX2X)*SPS);
    % C
    D(1,IZ)=SPS*((BX1Z-BX2Z)*CPS+(BZ1Z-BZ2Z)*SPS);
    D(2,IZ)=SPS*(BY1Z-BY2Z);
    D(3,IZ)=SPS*((BZ1Z-BZ2Z)*CPS-(BX1Z-BX2Z)*SPS);
end
% C
% end function CONDIP1


% C
% C$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
% C
function [BX,BY,BZ] = T96_BIRK1SHLD(PS,X,Y,Z);
%SUBROUTINE  BIRK1SHLD(PS,X,Y,Z,BX,BY,BZ)
% C
% C - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% C
% C  The 64 linear parameters are amplitudes of the "box" harmonics.
% c The 16 nonlinear parameters are the scales Pi, and Qk entering the arguments
% C  of sines/cosines and exponents in each of  32 cartesian harmonics
% c  N.A. Tsyganenko, Spring 1994, adjusted for the Birkeland field Aug.22, 1995
% c    Revised  June 12, 1996.
% C - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% C
%IMPLICIT  REAL * 8  (A - H, O - Z)
% C
%DIMENSION A(80)
%DIMENSION P1(4),R1(4),Q1(4),S1(4),RP(4),RR(4),RQ(4),RS(4)
% C
%EQUIVALENCE (P1(1),A(65)),(R1(1),A(69)),(Q1(1),A(73)),
%* (S1(1),A(77))
% equivalence allows P1,R1, Q1, and S1 to be shorthand for parts of A
% C
A = [1.174198045,-1.463820502,4.840161537,-3.674506864, ...
        82.18368896,-94.94071588,-4122.331796,4670.278676,-21.54975037, ...
        26.72661293,-72.81365728,44.09887902,40.08073706,-51.23563510, ...
        1955.348537,-1940.971550,794.0496433,-982.2441344,1889.837171, ...
        -558.9779727,-1260.543238,1260.063802,-293.5942373,344.7250789, ...
        -773.7002492,957.0094135,-1824.143669,520.7994379,1192.484774, ...
        -1192.184565,89.15537624,-98.52042999,-0.8168777675E-01, ...
        0.4255969908E-01,0.3155237661,-0.3841755213,2.494553332, ...
        -0.6571440817E-01,-2.765661310,0.4331001908,0.1099181537, ...
        -0.6154126980E-01,-0.3258649260,0.6698439193,-5.542735524, ...
        0.1604203535,5.854456934,-0.8323632049,3.732608869,-3.130002153, ...
        107.0972607,-32.28483411,-115.2389298,54.45064360,-0.5826853320, ...
        -3.582482231,-4.046544561,3.311978102,-104.0839563,30.26401293, ...
        97.29109008,-50.62370872,-296.3734955,127.7872523,5.303648988, ...
        10.40368955,69.65230348,466.5099509,1.645049286,3.825838190, ...
        11.66675599,558.9781177,1.826531343,2.066018073,25.40971369, ...
        990.2795225,2.319489258,4.555148484,9.691185703,591.8280358];

% now handle equivalences
%%%% EQUIVALENCE (P1(1),A(65)),(R1(1),A(69)),(Q1(1),A(73)),
%%%% * (S1(1),A(77))
P1 = A(65+[0:3]);
R1 = A(69+[0:3]);
Q1 = A(73+[0:3]);
S1 = A(77+[0:3]);

% C
BX=0.D0;
BY=0.D0;
BZ=0.D0;
CPS=cos(PS);
SPS=sin(PS);
S3PS=4.D0*CPS^2-1.D0;

% replace for loop
% DO 11 I=1,4
% RP(I)=1.D0/P1(I)
% RR(I)=1.D0/R1(I)
% RQ(I)=1.D0/Q1(I)
% 11       RS(I)=1.D0/S1(I)
RP = 1./P1;
RR = 1./R1;
RQ = 1./Q1;
RS = 1./S1;
% C
L=0;
% C
for M = 1:2,
    %DO 1 M=1,2     %!    M=1 IS FOR THE 1ST SUM ("PERP." SYMMETRY)
    % C                           AND M=2 IS FOR THE SECOND SUM ("PARALL." SYMMETRY)
    for I = 1:4,
        %DO 2 I=1,4
        CYPI=cos(Y*RP(I));
        CYQI=cos(Y*RQ(I));
        SYPI=sin(Y*RP(I));
        SYQI=sin(Y*RQ(I));
        % C
        for K = 1:4,
            %DO 3 K=1,4
            SZRK=sin(Z*RR(K));
            CZSK=cos(Z*RS(K));
            CZRK=cos(Z*RR(K));
            SZSK=sin(Z*RS(K));
            SQPR=sqrt(RP(I)^2+RR(K)^2);
            SQQS=sqrt(RQ(I)^2+RS(K)^2);
            EPR=exp(X*SQPR);
            EQS=exp(X*SQQS);
            % C
            for N = 1:2,
                %DO 4 N=1,2  %! N=1 IS FOR THE FIRST PART OF EACH COEFFICIENT
                % C                                  AND N=2 IS FOR THE SECOND ONE
                if (M==1),
                    if (N==1),
                        HX=-SQPR*EPR*CYPI*SZRK;
                        HY=RP(I)*EPR*SYPI*SZRK;
                        HZ=-RR(K)*EPR*CYPI*CZRK;
                    else
                        HX=HX*CPS;
                        HY=HY*CPS;
                        HZ=HZ*CPS;
                    end
                else
                    if (N==1),
                        HX=-SPS*SQQS*EQS*CYQI*CZSK;
                        HY=SPS*RQ(I)*EQS*SYQI*CZSK;
                        HZ=SPS*RS(K)*EQS*CYQI*SZSK;
                    else
                        HX=HX*S3PS;
                        HY=HY*S3PS;
                        HZ=HZ*S3PS;
                    end
                end
                L=L+1;
                % c
                BX=BX+A(L)*HX;
                BY=BY+A(L)*HY;
                BZ=BZ+A(L)*HZ;
            end
        end % 3   CONTINUE
    end % 2   CONTINUE
end % 1   CONTINUE
% C
% end of function BIRK1SHLD

% C
% C##########################################################################
% C
function [BX,BY,BZ] = T96_BIRK2TOT_02(PS,X,Y,Z);
%         SUBROUTINE BIRK2TOT_02(PS,X,Y,Z,BX,BY,BZ)
% C
%IMPLICIT REAL*8 (A-H,O-Z)
% C
[WX,WY,WZ] = T96_BIRK2SHL(X,Y,Z,PS);
[HX,HY,HZ] = T96_R2_BIRK(X,Y,Z,PS);
BX=WX+HX;
BY=WY+HY;
BZ=WZ+HZ;
% end function BIRK2TOT_02

function [HX,HY,HZ] = T96_BIRK2SHL(X,Y,Z,PS)
% C
% C$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
% C
% C THIS CODE IS FOR THE FIELD FROM  2x2x2=8 "CARTESIAN" HARMONICS
% C
%SUBROUTINE  BIRK2SHL(X,Y,Z,PS,HX,HY,HZ)
% C
% C - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% C    The model parameters are provided to this module via common-block /A/.
% C  The 16 linear parameters enter in pairs in the amplitudes of the
% c       "cartesian" harmonics.
% c    The 8 nonlinear parameters are the scales Pi,Ri,Qi,and Si entering the
% c  arguments of exponents, sines, and cosines in each of the 8 "Cartesian"
% c   harmonics
% C - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% C
%IMPLICIT  REAL * 8  (A - H, O - Z)
% C
%DIMENSION P(2),R(2),Q(2),S(2)
%DIMENSION A(24)
% C
%EQUIVALENCE(P(1),A(17)),(R(1),A(19)),(Q(1),A(21)),(S(1),A(23))
A = [-111.6371348,124.5402702,110.3735178,-122.0095905,...
        111.9448247,-129.1957743,-110.7586562,126.5649012,-0.7865034384,...
        -0.2483462721,0.8026023894,0.2531397188,10.72890902,0.8483902118,...
        -10.96884315,-0.8583297219,13.85650567,14.90554500,10.21914434,...
        10.09021632,6.340382460,14.40432686,12.71023437,12.83966657];
%
% manage the equivalence
P = A(17+[0:1]);
R = A(19+[0:1]);
Q = A(21+[0:1]);
S = A(23+[0:1]);

% C
CPS=cos(PS);
SPS=sin(PS);
S3PS=4.D0*CPS^2-1.D0;   %!  THIS IS SIN(3*PS)/SIN(PS)
% C
HX=0.D0;
HY=0.D0;
HZ=0.D0;
L=0;
% C
for M=1:2,
    %DO 1 M=1,2     %!    M=1 IS FOR THE 1ST SUM ("PERP." SYMMETRY)
    % C                           AND M=2 IS FOR THE SECOND SUM ("PARALL." SYMMETRY)
    for I=1:2,
        %DO 2 I=1,2
        CYPI=cos(Y/P(I));
        CYQI=cos(Y/Q(I));
        SYPI=sin(Y/P(I));
        SYQI=sin(Y/Q(I));
        % C
        for K=1:2,
            %DO 3 K=1,2
            SZRK=sin(Z/R(K));
            CZSK=cos(Z/S(K));
            CZRK=cos(Z/R(K));
            SZSK=sin(Z/S(K));
            SQPR=sqrt(1.D0/P(I)^2+1.D0/R(K)^2);
            SQQS=sqrt(1.D0/Q(I)^2+1.D0/S(K)^2);
            EPR=exp(X*SQPR);
            EQS=exp(X*SQQS);
            % C
            for N=1:2,
                %DO 4 N=1,2  %! N=1 IS FOR THE FIRST PART OF EACH COEFFICIENT
                % C                                  AND N=2 IS FOR THE SECOND ONE
                % C
                L=L+1;
                if (M==1),
                    if (N==1),
                        DX=-SQPR*EPR*CYPI*SZRK;
                        DY=EPR/P(I)*SYPI*SZRK;
                        DZ=-EPR/R(K)*CYPI*CZRK;
                        HX=HX+A(L)*DX;
                        HY=HY+A(L)*DY;
                        HZ=HZ+A(L)*DZ;
                    else
                        DX=DX*CPS;
                        DY=DY*CPS;
                        DZ=DZ*CPS;
                        HX=HX+A(L)*DX;
                        HY=HY+A(L)*DY;
                        HZ=HZ+A(L)*DZ;
                    end
                else
                    if (N==1),
                        DX=-SPS*SQQS*EQS*CYQI*CZSK;
                        DY=SPS*EQS/Q(I)*SYQI*CZSK;
                        DZ=SPS*EQS/S(K)*CYQI*SZSK;
                        HX=HX+A(L)*DX;
                        HY=HY+A(L)*DY;
                        HZ=HZ+A(L)*DZ;
                    else
                        DX=DX*S3PS;
                        DY=DY*S3PS;
                        DZ=DZ*S3PS;
                        HX=HX+A(L)*DX;
                        HY=HY+A(L)*DY;
                        HZ=HZ+A(L)*DZ;
                    end
                end
                % c
            end %4   CONTINUE
        end %3   CONTINUE
    end %2   CONTINUE
end %1   CONTINUE
% C
% end of function BIRK2SHL


function [BX,BY,BZ] = T96_R2_BIRK(X,Y,Z,PS);
% c********************************************************************
% C
%SUBROUTINE R2_BIRK(X,Y,Z,PS,BX,BY,BZ)
% C
% C  RETURNS THE MODEL FIELD FOR THE REGION 2 BIRKELAND CURRENT/PARTIAL RC
% C    (WITHOUT SHIELDING FIELD)
% C
%IMPLICIT REAL*8 (A-H,O-Z)
persistent PSI CPS SPS
DELARG = 0.030D0;
DELARG1 = 0.015D0;
if isempty(PSI),
    PSI = 10.D0;
end
% C
if (abs(PSI-PS)>1.D-10),
    PSI=PS;
    CPS=cos(PS);
    SPS=sin(PS);
end
% C
XSM=X*CPS-Z*SPS;
ZSM=Z*CPS+X*SPS;
% C
XKS=T96_XKSI(XSM,Y,ZSM);
if (XKS<-(DELARG+DELARG1)),
    [BXSM,BY,BZSM] = T96_R2OUTER(XSM,Y,ZSM);
    
    BXSM=-BXSM*0.02;      %!  ALL COMPONENTS ARE MULTIPLIED BY THE
    BY=-BY*0.02;          %!  FACTOR -0.02, IN ORDER TO NORMALIZE THE
    BZSM=-BZSM*0.02;      %!  FIELD (SO THAT Bz=-1 nT at X=-5.3 RE, Y=Z=0)
end
if (XKS>=-(DELARG+DELARG1)) & (XKS<-DELARG+DELARG1),
    [BXSM1,BY1,BZSM1] = T96_R2OUTER(XSM,Y,ZSM);
    [BXSM2,BY2,BZSM2] = T96_R2SHEET(XSM,Y,ZSM);
    F2=-0.02*T96_TKSI(XKS,-DELARG,DELARG1);
    F1=-0.02-F2;
    BXSM=BXSM1*F1+BXSM2*F2;
    BY=BY1*F1+BY2*F2;
    BZSM=BZSM1*F1+BZSM2*F2;
end

if (XKS>=-DELARG+DELARG1)&(XKS<DELARG-DELARG1),
    [BXSM,BY,BZSM] = T96_R2SHEET(XSM,Y,ZSM);
    BXSM=-BXSM*0.02;
    BY=-BY*0.02;
    BZSM=-BZSM*0.02;
end
if (XKS>=DELARG-DELARG1) & (XKS<DELARG+DELARG1) ,
    [BXSM1,BY1,BZSM1] = T96_R2INNER(XSM,Y,ZSM);
    [BXSM2,BY2,BZSM2] = T96_R2SHEET(XSM,Y,ZSM);
    F1=-0.02*T96_TKSI(XKS,DELARG,DELARG1);
    F2=-0.02-F1;
    BXSM=BXSM1*F1+BXSM2*F2;
    BY=BY1*F1+BY2*F2;
    BZSM=BZSM1*F1+BZSM2*F2;
end
if (XKS>=DELARG+DELARG1),
    [BXSM,BY,BZSM] = T96_R2INNER(XSM,Y,ZSM);
    BXSM=-BXSM*0.02;
    BY=-BY*0.02;
    BZSM=-BZSM*0.02;
end
% C
BX=BXSM*CPS+BZSM*SPS;
BZ=BZSM*CPS-BXSM*SPS;
% C
% end of function R2_BIRK

% C
% C****************************************************************

% c
function [BX,BY,BZ] = T96_R2INNER (X,Y,Z);
%SUBROUTINE R2INNER (X,Y,Z,BX,BY,BZ)
% C
% C
%IMPLICIT REAL*8 (A-H,O-Z)
%DIMENSION CBX(5),CBY(5),CBZ(5)
% C
PL1 = 154.185;
PL2 = -2.12446;
PL3 = .601735E-01;
PL4 =  -.153954E-02;
PL5 =  .355077E-04;
PL6 =  29.9996;
PL7 =  262.886;
PL8 =  99.9132;

PN1 = -8.1902;
PN2 = 6.5239;
PN3 = 5.504;
PN4 = 7.7815;
PN5 = 0.8573;
PN6 = 3.0986;
PN7 = 0.0774;
PN8 = -0.038;
% C
[CBX,CBY,CBZ] = T96_BCONIC(X,Y,Z,5);
% C
% C   NOW INTRODUCE  ONE  4-LOOP SYSTEM:
% C

% Extra comma in  output vector of function definition is 
% ignored by Matlab, but breaks Octave
% (changed on 3/11/05 by E.J. Rigler)
%[DBX8,DBY8,DBZ8,] = T96_LOOPS4(X,Y,Z,PN1,PN2,PN3,PN4,PN5,PN6);
[DBX8,DBY8,DBZ8] = T96_LOOPS4(X,Y,Z,PN1,PN2,PN3,PN4,PN5,PN6);
% C
[DBX6,DBY6,DBZ6] = T96_DIPDISTR(X-PN7,Y,Z,0);
[DBX7,DBY7,DBZ7] = T96_DIPDISTR(X-PN8,Y,Z,1);

% C                           NOW COMPUTE THE FIELD COMPONENTS:

BX=PL1*CBX(1)+PL2*CBX(2)+PL3*CBX(3)+PL4*CBX(4)+PL5*CBX(5) ...
    +PL6*DBX6+PL7*DBX7+PL8*DBX8;
BY=PL1*CBY(1)+PL2*CBY(2)+PL3*CBY(3)+PL4*CBY(4)+PL5*CBY(5) ...
    +PL6*DBY6+PL7*DBY7+PL8*DBY8;
BZ=PL1*CBZ(1)+PL2*CBZ(2)+PL3*CBZ(3)+PL4*CBZ(4)+PL5*CBZ(5) ...
    +PL6*DBZ6+PL7*DBZ7+PL8*DBZ8;
% C
% end of function R2INNER
% C-----------------------------------------------------------------------

function [CBX,CBY,CBZ] = T96_BCONIC(X,Y,Z,NMAX)
%SUBROUTINE BCONIC(X,Y,Z,CBX,CBY,CBZ,NMAX)
% C
% c   "CONICAL" HARMONICS
% c
%IMPLICIT REAL*8 (A-H,O-Z)
% C
%DIMENSION CBX(NMAX),CBY(NMAX),CBZ(NMAX)

RO2=X^2+Y^2;
RO=sqrt(RO2);
% C
CF=X/RO;
SF=Y/RO;
CFM1=1.D0;
SFM1=0.D0;
% C
R2=RO2+Z^2;
R=sqrt(R2);
C=Z/R;
S=RO/R;
CH=sqrt(0.5D0*(1.D0+C));
SH=sqrt(0.5D0*(1.D0-C));
TNHM1=1.D0;
CNHM1=1.D0;
TNH=SH/CH;
CNH=1.D0/TNH;
% C
for M=1:NMAX,
    CFM=CFM1*CF-SFM1*SF;
    SFM=CFM1*SF+SFM1*CF;
    CFM1=CFM;
    SFM1=SFM;
    TNHM=TNHM1*TNH;
    CNHM=CNHM1*CNH;
    BT=M*CFM/(R*S)*(TNHM+CNHM);
    BF=-0.5D0*M*SFM/R*(TNHM1/CH^2-CNHM1/SH^2);
    TNHM1=TNHM;
    CNHM1=CNHM;
    CBX(M)=BT*C*CF-BF*SF;
    CBY(M)=BT*C*SF+BF*CF;
    CBZ(M)=-BT*S;
end
% C
% end of BCONIC


% C-------------------------------------------------------------------
% C
function [BX,BY,BZ] = T96_DIPDISTR(X,Y,Z,MODE);
%SUBROUTINE DIPDISTR(X,Y,Z,BX,BY,BZ,MODE)
% C
% C   RETURNS FIELD COMPONENTS FROM A LINEAR DISTRIBUTION OF DIPOLAR SOURCES
% C     ON THE Z-AXIS.  THE PARAMETER MODE DEFINES HOW THE DIPOLE STRENGTH
% C     VARIES ALONG THE Z-AXIS:  MODE=0 IS FOR A STEP-FUNCTION (Mx=const &gt 0
% c         FOR Z &gt 0, AND Mx=-const &lt 0 FOR Z &lt 0)
% C      WHILE MODE=1 IS FOR A LINEAR VARIATION OF THE DIPOLE MOMENT DENSITY
% C       SEE NB#3, PAGE 53 FOR DETAILS.
% C
% C
% C INPUT: X,Y,Z OF A POINT OF SPACE, AND MODE
% C
%IMPLICIT REAL*8 (A-H,O-Z)
X2=X*X;
RHO2=X2+Y*Y;
R2=RHO2+Z*Z;
R3=R2*sqrt(R2);

if (MODE==0),
    BX=Z/RHO2^2*(R2*(Y*Y-X2)-RHO2*X2)/R3;
    BY=-X*Y*Z/RHO2^2*(2.D0*R2+RHO2)/R3;
    BZ=X/R3;
else
    BX=Z/RHO2^2*(Y*Y-X2);
    BY=-2.D0*X*Y*Z/RHO2^2;
    BZ=X/RHO2;
end
%end of function DIPDISTR

% 
% C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% C
function [BX,BY,BZ]= T96_R2OUTER (X,Y,Z);
%SUBROUTINE R2OUTER (X,Y,Z,BX,BY,BZ)
% C
%IMPLICIT REAL*8 (A-H,O-Z)
% C
PL1 = -34.105;
PL2 = -2.00019;
PL3 = 628.639;
PL4 = 73.4847;
PL5 = 12.5162;

PN1 = .55;
PN2 = .694;
PN3 = .0031;
PN4 = 1.55;
PN5 = 2.8;
PN6 = .1375;
PN7 = -.7;
PN8 = .2;
PN9 = .9625;
PN10 =  -2.994;
PN11 =  2.925;
PN12 =  -1.775;
PN13 =  4.3;
PN14 =  -.275;
PN15 =  2.7;
PN16 =  .4312;
PN17 =  1.55;
% c
% C    THREE PAIRS OF CROSSED LOOPS:
% C
[DBX1,DBY1,DBZ1] = T96_CROSSLP(X,Y,Z,PN1,PN2,PN3);
[DBX2,DBY2,DBZ2] = T96_CROSSLP(X,Y,Z,PN4,PN5,PN6);
[DBX3,DBY3,DBZ3] = T96_CROSSLP(X,Y,Z,PN7,PN8,PN9);
% C
% C    NOW AN EQUATORIAL LOOP ON THE NIGHTSIDE
% C
[DBX4,DBY4,DBZ4] = T96_CIRCLE(X-PN10,Y,Z,PN11);
% c
% c   NOW A 4-LOOP SYSTEM ON THE NIGHTSIDE
% c

[DBX5,DBY5,DBZ5] = T96_LOOPS4(X,Y,Z,PN12,PN13,PN14,PN15,PN16,PN17);

% C---------------------------------------------------------------------
% 
% C                           NOW COMPUTE THE FIELD COMPONENTS:

BX=PL1*DBX1+PL2*DBX2+PL3*DBX3+PL4*DBX4+PL5*DBX5;
BY=PL1*DBY1+PL2*DBY2+PL3*DBY3+PL4*DBY4+PL5*DBY5;
BZ=PL1*DBZ1+PL2*DBZ2+PL3*DBZ3+PL4*DBZ4+PL5*DBZ5;

%end function R2OUTER

% C
% C--------------------------------------------------------------------
% C
function [BX,BY,BZ] = T96_LOOPS4(X,Y,Z,XC,YC,ZC,R,THETA,PHI);
%SUBROUTINE LOOPS4(X,Y,Z,BX,BY,BZ,XC,YC,ZC,R,THETA,PHI)
% C
% C   RETURNS FIELD COMPONENTS FROM A SYSTEM OF 4 CURRENT LOOPS, POSITIONED
% C     SYMMETRICALLY WITH RESPECT TO NOON-MIDNIGHT MERIDIAN AND EQUATORIAL
% C      PLANES.
% C  INPUT: X,Y,Z OF A POINT OF SPACE
% C        XC,YC,ZC (YC &gt 0 AND ZC &gt 0) - POSITION OF THE CENTER OF THE
% C                                         1ST-QUADRANT LOOP
% C        R - LOOP RADIUS (THE SAME FOR ALL FOUR)
% C        THETA, PHI  -  SPECIFY THE ORIENTATION OF THE NORMAL OF THE 1ST LOOP
% c      -----------------------------------------------------------

%IMPLICIT REAL*8 (A-H,O-Z)
% C
CT=cos(THETA);
ST=sin(THETA);
CP=cos(PHI);
SP=sin(PHI);
% C------------------------------------1ST QUADRANT:
XS=(X-XC)*CP+(Y-YC)*SP;
YSS=(Y-YC)*CP-(X-XC)*SP;
ZS=Z-ZC;
XSS=XS*CT-ZS*ST;
ZSS=ZS*CT+XS*ST;

[BXSS,BYS,BZSS] = T96_CIRCLE(XSS,YSS,ZSS,R);
BXS=BXSS*CT+BZSS*ST;
BZ1=BZSS*CT-BXSS*ST;
BX1=BXS*CP-BYS*SP;
BY1=BXS*SP+BYS*CP;
% C-------------------------------------2nd QUADRANT:
XS=(X-XC)*CP-(Y+YC)*SP;
YSS=(Y+YC)*CP+(X-XC)*SP;
ZS=Z-ZC;
XSS=XS*CT-ZS*ST;
ZSS=ZS*CT+XS*ST;

[BXSS,BYS,BZSS] = T96_CIRCLE(XSS,YSS,ZSS,R);
BXS=BXSS*CT+BZSS*ST;
BZ2=BZSS*CT-BXSS*ST;
BX2=BXS*CP+BYS*SP;
BY2=-BXS*SP+BYS*CP;
% C-------------------------------------3RD QUADRANT:
XS=-(X-XC)*CP+(Y+YC)*SP;
YSS=-(Y+YC)*CP-(X-XC)*SP;
ZS=Z+ZC;
XSS=XS*CT-ZS*ST;
ZSS=ZS*CT+XS*ST;

[BXSS,BYS,BZSS] = T96_CIRCLE(XSS,YSS,ZSS,R);
BXS=BXSS*CT+BZSS*ST;
BZ3=BZSS*CT-BXSS*ST;
BX3=-BXS*CP-BYS*SP;
BY3=BXS*SP-BYS*CP;
% C-------------------------------------4TH QUADRANT:
XS=-(X-XC)*CP-(Y-YC)*SP;
YSS=-(Y-YC)*CP+(X-XC)*SP;
ZS=Z+ZC;
XSS=XS*CT-ZS*ST;
ZSS=ZS*CT+XS*ST;

[BXSS,BYS,BZSS] = T96_CIRCLE(XSS,YSS,ZSS,R);
BXS=BXSS*CT+BZSS*ST;
BZ4=BZSS*CT-BXSS*ST;
BX4=-BXS*CP+BYS*SP;
BY4=-BXS*SP-BYS*CP;

BX=BX1+BX2+BX3+BX4;
BY=BY1+BY2+BY3+BY4;
BZ=BZ1+BZ2+BZ3+BZ4;

% end function LOOPS4

% C
% C@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
% C
function [BX,BY,BZ] = T96_R2SHEET(X,Y,Z)
%SUBROUTINE R2SHEET(X,Y,Z,BX,BY,BZ)
% C
%IMPLICIT REAL*8 (A-H,O-Z)
% C
PNONX1 = -19.0969D0;
PNONX2 = -9.28828D0;
PNONX3 = -0.129687D0;
PNONX4 = 5.58594D0;
PNONX5 = 22.5055D0;
PNONX6 = 0.483750D-01;
PNONX7 = 0.396953D-01;
PNONX8 = 0.579023D-01;
PNONY1 = -13.6750D0;
PNONY2 = -6.70625D0;
PNONY3 = 2.31875D0;
PNONY4 = 11.4062D0;
PNONY5 = 20.4562D0;
PNONY6 = 0.478750D-01;
PNONY7 = 0.363750D-01;
PNONY8 = 0.567500D-01;
PNONZ1 = -16.7125D0;
PNONZ2 = -16.4625D0;
PNONZ3 = -0.1625D0;
PNONZ4 = 5.1D0;
PNONZ5 = 23.7125D0;
PNONZ6 = 0.355625D-01;
PNONZ7 = 0.318750D-01;
PNONZ8 = 0.538750D-01;
% C
% C
A1 = 8.07190D0;
A2 = -7.39582D0;
A3 = -7.62341D0;
A4 = 0.684671D0;
A5 = -13.5672D0;
A6 = 11.6681D0;
A7 = 13.1154;
A8 = -0.890217D0;
A9 = 7.78726D0;
A10 = -5.38346D0;
A11 = -8.08738D0;
A12 = 0.609385D0;
A13 = -2.70410D0;
A14 = 3.53741D0;
A15 = 3.15549D0;
A16 = -1.11069D0;
A17 = -8.47555D0;
A18 = 0.278122D0;
A19 = 2.73514D0;
A20 = 4.55625D0;
A21 = 13.1134D0;
A22 = 1.15848D0;
A23 = -3.52648D0;
A24 = -8.24698D0;
A25 = -6.85710D0;
A26 = -2.81369D0;
A27 = 2.03795D0;
A28 = 4.64383D0;
A29 = 2.49309D0;
A30 = -1.22041D0;
A31 = -1.67432D0;
A32 = -0.422526D0;
A33 = -5.39796D0;
A34 = 7.10326D0;
A35 = 5.53730D0;
A36 = -13.1918D0;
A37 = 4.67853D0;
A38 = -7.60329D0;
A39 = -2.53066D0;
A40 = 7.76338D0;
A41 = 5.60165D0;
A42 = 5.34816D0;
A43 = -4.56441D0;
A44 = 7.05976D0;
A45 = -2.62723D0;
A46 = -0.529078D0;
A47 = 1.42019D0;
A48 = -2.93919D0;
A49 = 55.6338D0;
A50 = -1.55181D0;
A51 = 39.8311D0;
A52 = -80.6561D0;
A53 = -46.9655D0;
A54 = 32.8925D0;
A55 = -6.32296D0;
A56 = 19.7841D0;
A57 = 124.731D0;
A58 = 10.4347D0;
A59 = -30.7581D0;
A60 = 102.680D0;
A61 = -47.4037D0;
A62 = -3.31278D0;
A63 = 9.37141D0;
A64 = -50.0268D0;
A65 = -533.319D0;
A66 = 110.426D0;
A67 = 1000.20D0;
A68 = -1051.40D0;
A69 = 1619.48D0;
A70 = 589.855D0;
A71 = -1462.73D0;
A72 = 1087.10D0;
A73 = -1994.73D0;
A74 = -1654.12D0;
A75 = 1263.33D0;
A76 = -260.210D0;
A77 = 1424.84D0;
A78 = 1255.71D0;
A79 = -956.733D0;
A80 = 219.946D0;
% C
% C
B1 = -9.08427D0;
B2 = 10.6777D0;
B3 = 10.3288D0;
B4 = -0.969987D0;
B5 = 6.45257D0;
B6 = -8.42508D0;
B7 = -7.97464D0;
B8 = 1.41996D0;
B9 = -1.92490D0;
B10 = 3.93575D0;
B11 = 2.83283D0;
B12 = -1.48621D0;
B13 = 0.244033D0;
B14 = -0.757941D0;
B15 = -0.386557D0;
B16 = 0.344566D0;
B17 = 9.56674D0;
B18 = -2.5365D0;
B19 = -3.32916D0;
B20 = -5.86712D0;
B21 = -6.19625D0;
B22 = 1.83879D0;
B23 = 2.52772D0;
B24 = 4.34417D0;
B25 = 1.87268D0;
B26 = -2.13213D0;
B27 = -1.69134D0;
B28 = -.176379D0;
B29 = -.261359D0;
B30 = .566419D0;
B31 = 0.3138D0;
B32 = -0.134699D0;
B33 = -3.83086D0;
B34 = -8.4154D0;
B35 = 4.77005D0;
B36 = -9.31479D0;
B37 = 37.5715D0;
B38 = 19.3992D0;
B39 = -17.9582D0;
B40 = 36.4604D0;
B41 = -14.9993D0;
B42 = -3.1442D0;
B43 = 6.17409D0;
B44 = -15.5519D0;
B45 = 2.28621D0;
B46 = -0.891549D-2;
B47 = -.462912D0;
B48 = 2.47314D0;
B49 = 41.7555D0;
B50 = 208.614D0;
B51 = -45.7861D0;
B52 = -77.8687D0;
B53 = 239.357D0;
B54 = -67.9226D0;
B55 = 66.8743D0;
B56 = 238.534D0;
B57 = -112.136D0;
B58 = 16.2069D0;
B59 = -40.4706D0;
B60 = -134.328D0;
B61 = 21.56D0;
B62 = -0.201725D0;
B63 = 2.21D0;
B64 = 32.5855D0;
B65 = -108.217D0;
B66 = -1005.98D0;
B67 = 585.753D0;
B68 = 323.668D0;
B69 = -817.056D0;
B70 = 235.750D0;
B71 = -560.965D0;
B72 = -576.892D0;
B73 = 684.193D0;
B74 = 85.0275D0;
B75 = 168.394D0;
B76 = 477.776D0;
B77 = -289.253D0;
B78 = -123.216D0;
B79 = 75.6501D0;
B80 = -178.605D0;

% C
C1 = 1167.61D0;
C2 = -917.782D0;
C3 = -1253.2D0;
C4 = -274.128D0;
C5 = -1538.75D0;
C6 = 1257.62D0;
C7 = 1745.07D0;
C8 = 113.479D0;
C9 = 393.326D0;
C10 = -426.858D0;
C11 = -641.1D0;
C12 = 190.833D0;
C13 = -29.9435D0;
C14 = -1.04881D0;
C15 = 117.125D0;
C16 = -25.7663D0;
C17 = -1168.16D0;
C18 = 910.247D0;
C19 = 1239.31D0;
C20 = 289.515D0;
C21 = 1540.56D0;
C22 = -1248.29D0;
C23 = -1727.61D0;
C24 = -131.785D0;
C25 = -394.577D0;
C26 = 426.163D0;
C27 = 637.422D0;
C28 = -187.965D0;
C29 = 30.0348D0;
C30 = 0.221898D0;
C31 = -116.68D0;
C32 = 26.0291D0;
C33 = 12.6804D0;
C34 = 4.84091D0;
C35 = 1.18166D0;
C36 = -2.75946D0;
C37 = -17.9822D0;
C38 = -6.80357D0;
C39 = -1.47134D0;
C40 = 3.02266D0;
C41 = 4.79648D0;
C42 = 0.665255D0;
C43 = -0.256229D0;
C44 = -0.857282D-1;
C45 = -0.588997D0;
C46 = 0.634812D-1;
C47 = 0.164303D0;
C48 = -0.15285D0;
C49 = 22.2524D0;
C50 = -22.4376D0;
C51 = -3.85595D0;
C52 = 6.07625D0;
C53 = -105.959D0;
C54 = -41.6698D0;
C55 = 0.378615D0;
C56 = 1.55958D0;
C57 = 44.3981D0;
C58 = 18.8521D0;
C59 = 3.19466D0;
C60 = 5.89142D0;
C61 = -8.63227D0;
C62 = -2.36418D0;
C63 = -1.027D0;
C64 = -2.31515D0;
C65 = 1035.38D0;
C66 = 2040.66D0;
C67 = -131.881D0;
C68 = -744.533D0;
C69 = -3274.93D0;
C70 = -4845.61D0;
C71 = 482.438D0;
C72 = 1567.43D0;
C73 = 1354.02D0;
C74 = 2040.47D0;
C75 = -151.653D0;
C76 = -845.012D0;
C77 = -111.723D0;
C78 = -265.343D0;
C79 = -26.1171D0;
C80 = 216.632D0;
% C
% c------------------------------------------------------------------
% C
XKS=T96_XKSI(X,Y,Z);    %!  variation across the current sheet
T1X=XKS/sqrt(XKS^2+PNONX6^2);
T2X=PNONX7^3/sqrt(XKS^2+PNONX7^2)^3;
T3X=XKS/sqrt(XKS^2+PNONX8^2)^5 *3.493856D0*PNONX8^4;
% C
T1Y=XKS/sqrt(XKS^2+PNONY6^2);
T2Y=PNONY7^3/sqrt(XKS^2+PNONY7^2)^3;
T3Y=XKS/sqrt(XKS^2+PNONY8^2)^5 *3.493856D0*PNONY8^4;
% C
T1Z=XKS/sqrt(XKS^2+PNONZ6^2);
T2Z=PNONZ7^3/sqrt(XKS^2+PNONZ7^2)^3;
T3Z=XKS/sqrt(XKS^2+PNONZ8^2)^5 *3.493856D0*PNONZ8^4;
% C
RHO2=X*X+Y*Y;
R=sqrt(RHO2+Z*Z);
RHO=sqrt(RHO2);
% C
C1P=X/RHO;
S1P=Y/RHO;
S2P=2.D0*S1P*C1P;
C2P=C1P*C1P-S1P*S1P;
S3P=S2P*C1P+C2P*S1P;
C3P=C2P*C1P-S2P*S1P;
S4P=S3P*C1P+C3P*S1P;
CT=Z/R;
ST=RHO/R;
% C
S1=T96_FEXP(CT,PNONX1);
S2=T96_FEXP(CT,PNONX2);
S3=T96_FEXP(CT,PNONX3);
S4=T96_FEXP(CT,PNONX4);
S5=T96_FEXP(CT,PNONX5);
% C
% C                   NOW COMPUTE THE GSM FIELD COMPONENTS:
% C
% C
BX=S1*((A1+A2*T1X+A3*T2X+A4*T3X) ...
    +C1P*(A5+A6*T1X+A7*T2X+A8*T3X) ...
    +C2P*(A9+A10*T1X+A11*T2X+A12*T3X) ...
    +C3P*(A13+A14*T1X+A15*T2X+A16*T3X)) ...
    +S2*((A17+A18*T1X+A19*T2X+A20*T3X) ...
    +C1P*(A21+A22*T1X+A23*T2X+A24*T3X) ...
    +C2P*(A25+A26*T1X+A27*T2X+A28*T3X) ...
    +C3P*(A29+A30*T1X+A31*T2X+A32*T3X)) ...
    +S3*((A33+A34*T1X+A35*T2X+A36*T3X) ...
    +C1P*(A37+A38*T1X+A39*T2X+A40*T3X) ...
    +C2P*(A41+A42*T1X+A43*T2X+A44*T3X) ...
    +C3P*(A45+A46*T1X+A47*T2X+A48*T3X)) ...
    +S4*((A49+A50*T1X+A51*T2X+A52*T3X) ...
    +C1P*(A53+A54*T1X+A55*T2X+A56*T3X) ...
    +C2P*(A57+A58*T1X+A59*T2X+A60*T3X) ...
    +C3P*(A61+A62*T1X+A63*T2X+A64*T3X)) ...
    +S5*((A65+A66*T1X+A67*T2X+A68*T3X) ...
    +C1P*(A69+A70*T1X+A71*T2X+A72*T3X) ...
    +C2P*(A73+A74*T1X+A75*T2X+A76*T3X) ...
    +C3P*(A77+A78*T1X+A79*T2X+A80*T3X));
% C
% C
S1=T96_FEXP(CT,PNONY1);
S2=T96_FEXP(CT,PNONY2);
S3=T96_FEXP(CT,PNONY3);
S4=T96_FEXP(CT,PNONY4);
S5=T96_FEXP(CT,PNONY5);
% C
BY=S1*(S1P*(B1+B2*T1Y+B3*T2Y+B4*T3Y) ...
    +S2P*(B5+B6*T1Y+B7*T2Y+B8*T3Y) ...
    +S3P*(B9+B10*T1Y+B11*T2Y+B12*T3Y) ...
    +S4P*(B13+B14*T1Y+B15*T2Y+B16*T3Y)) ...
    +S2*(S1P*(B17+B18*T1Y+B19*T2Y+B20*T3Y) ...
    +S2P*(B21+B22*T1Y+B23*T2Y+B24*T3Y) ...
    +S3P*(B25+B26*T1Y+B27*T2Y+B28*T3Y) ...
    +S4P*(B29+B30*T1Y+B31*T2Y+B32*T3Y)) ...
    +S3*(S1P*(B33+B34*T1Y+B35*T2Y+B36*T3Y) ...
    +S2P*(B37+B38*T1Y+B39*T2Y+B40*T3Y) ...
    +S3P*(B41+B42*T1Y+B43*T2Y+B44*T3Y) ...
    +S4P*(B45+B46*T1Y+B47*T2Y+B48*T3Y)) ...
    +S4*(S1P*(B49+B50*T1Y+B51*T2Y+B52*T3Y) ...
    +S2P*(B53+B54*T1Y+B55*T2Y+B56*T3Y) ...
    +S3P*(B57+B58*T1Y+B59*T2Y+B60*T3Y) ...
    +S4P*(B61+B62*T1Y+B63*T2Y+B64*T3Y)) ...
    +S5*(S1P*(B65+B66*T1Y+B67*T2Y+B68*T3Y) ...
    +S2P*(B69+B70*T1Y+B71*T2Y+B72*T3Y) ...
    +S3P*(B73+B74*T1Y+B75*T2Y+B76*T3Y) ...
    +S4P*(B77+B78*T1Y+B79*T2Y+B80*T3Y));
% C
S1=T96_FEXP1(CT,PNONZ1);
S2=T96_FEXP1(CT,PNONZ2);
S3=T96_FEXP1(CT,PNONZ3);
S4=T96_FEXP1(CT,PNONZ4);
S5=T96_FEXP1(CT,PNONZ5);
% C
%
% The continuation ellipses in the following lines were originally comprised
% of four dots; this syntax error was ignored in Matlab, but broke Octave
% (changed on 3/11/05 by E.J. Rigler)
BZ=S1*((C1+C2*T1Z+C3*T2Z+C4*T3Z) ...
    +C1P*(C5+C6*T1Z+C7*T2Z+C8*T3Z) ...
    +C2P*(C9+C10*T1Z+C11*T2Z+C12*T3Z) ...
    +C3P*(C13+C14*T1Z+C15*T2Z+C16*T3Z)) ...
    +S2*((C17+C18*T1Z+C19*T2Z+C20*T3Z) ...
    +C1P*(C21+C22*T1Z+C23*T2Z+C24*T3Z) ...
    +C2P*(C25+C26*T1Z+C27*T2Z+C28*T3Z) ...
    +C3P*(C29+C30*T1Z+C31*T2Z+C32*T3Z)) ...
    +S3*((C33+C34*T1Z+C35*T2Z+C36*T3Z) ...
    +C1P*(C37+C38*T1Z+C39*T2Z+C40*T3Z) ...
    +C2P*(C41+C42*T1Z+C43*T2Z+C44*T3Z) ...
    +C3P*(C45+C46*T1Z+C47*T2Z+C48*T3Z)) ...
    +S4*((C49+C50*T1Z+C51*T2Z+C52*T3Z) ...
    +C1P*(C53+C54*T1Z+C55*T2Z+C56*T3Z) ...
    +C2P*(C57+C58*T1Z+C59*T2Z+C60*T3Z) ...
    +C3P*(C61+C62*T1Z+C63*T2Z+C64*T3Z)) ...
    +S5*((C65+C66*T1Z+C67*T2Z+C68*T3Z) ...
    +C1P*(C69+C70*T1Z+C71*T2Z+C72*T3Z) ...
    +C2P*(C73+C74*T1Z+C75*T2Z+C76*T3Z) ...
    +C3P*(C77+C78*T1Z+C79*T2Z+C80*T3Z));
% C
% end of R2SHEET
% C
% C^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

function XKSI = T96_XKSI(X,Y,Z);
%DOUBLE PRECISION FUNCTION XKSI(X,Y,Z)
% C
%IMPLICIT REAL*8 (A-H,O-Z)
% C
% C   A11 - C72, R0, and DR below  ARE STRETCH PARAMETERS (P.26-27, NB# 3),
% C
A11A12 = 0.305662;
A21A22 = -0.383593;
A41A42 = 0.2677733;
A51A52 = -0.097656;
A61A62 = -0.636034;
B11B12 = -0.359862;
B21B22 = 0.424706;
C61C62 = -0.126366;
C71C72 = 0.292578;
R0 = 1.21563;
DR = 7.50937;

%DATA TNOON,DTETA/0.3665191,0.09599309/ %! Correspond to noon and midnight
TNOON = 0.3665191;
DTETA = 0.09599309;

% C                                         latitudes 69 and 63.5 degs, resp.
DR2=DR*DR;
% C;
X2=X*X;
Y2=Y*Y;
Z2=Z*Z;
XY=X*Y;
XYZ=XY*Z;
R2=X2+Y2+Z2;
R=sqrt(R2);
R3=R2*R;
R4=R2*R2;
XR=X/R;
YR=Y/R;
ZR=Z/R;
% C
if (R<R0),
    PR=0.D0;
else
    PR=sqrt((R-R0)^2+DR2)-DR;
end
% C
F=X+PR*(A11A12+A21A22*XR+A41A42*XR*XR+A51A52*YR*YR+ ...
    A61A62*ZR*ZR);
G=Y+PR*(B11B12*YR+B21B22*XR*YR);
H=Z+PR*(C61C62*ZR+C71C72*XR*ZR);
G2=G*G;
% C
FGH=F^2+G2+H^2;
FGH32=sqrt(FGH)^3;
FCHSG2=F^2+G2;

if (FCHSG2<1.D-5),
    XKSI=-1.D0;               %!  THIS IS JUST FOR ELIMINATING PROBLEMS
    return %!  ON THE Z-AXIS
end

SQFCHSG2=sqrt(FCHSG2);
ALPHA=FCHSG2/FGH32;
THETA=TNOON+0.5D0*DTETA*(1.D0-F/SQFCHSG2);
PHI=sin(THETA)^2;
% C
XKSI=ALPHA-PHI;
% C
% end of function XKSI

% C
% C--------------------------------------------------------------------
% C
function FEXP = T96_FEXP(S,A)
%FUNCTION FEXP(S,A)
%IMPLICIT REAL*8 (A-H,O-Z)
E =2.718281828459D0;
if (A<0.D0), FEXP=sqrt(-2.D0*A*E)*S*exp(A*S*S); end;
if (A>=0.D0) FEXP=S*exp(A*(S*S-1.D0)); end;
% end of function FEXP

% C
% C-----------------------------------------------------------------------
function FEXP1 = T96_FEXP1(S,A)
%FUNCTION FEXP1(S,A)
%IMPLICIT REAL*8 (A-H,O-Z)
if (A<=0.D0), FEXP1=exp(A*S*S); end
if (A>0.D0), FEXP1=exp(A*(S*S-1.D0)); end
% end of function FEXP1

% C
% C************************************************************************
% C
function TKSI = T96_TKSI(XKSI,XKS0,DXKSI);
%DOUBLE PRECISION FUNCTION TKSI(XKSI,XKS0,DXKSI)
%IMPLICIT REAL*8 (A-H,O-Z)
persistent M TDZ3
if isempty(M),
    M=0;
end
% C
if (M==0),
    TDZ3=2.*DXKSI^3;
    M=1;
end

% C
if (XKSI-XKS0<-DXKSI), TKSII=0; end;
if (XKSI-XKS0>=DXKSI),  TKSII=1.; end;
% C
if (XKSI>=XKS0-DXKSI) & (XKSI<XKS0),
    BR3=(XKSI-XKS0+DXKSI)^3;
    TKSII=1.5*BR3/(TDZ3+BR3);
end
% C
if (XKSI>=XKS0) & (XKSI<XKS0+DXKSI),
    BR3=(XKSI-XKS0-DXKSI)^3;
    TKSII=1.+1.5*BR3/(TDZ3-BR3);
end
TKSI=TKSII;
% end of function TKSI

% C
% C~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% c
function [BX,BY,BZ]=T96_DIPOLE(PS,X,Y,Z)
%       SUBROUTINE DIPOLE(PS,X,Y,Z,BX,BY,BZ)
% C
% C  CALCULATES GSM COMPONENTS OF GEODIPOLE FIELD WITH THE DIPOLE MOMENT
% C  CORRESPONDING TO THE EPOCH OF 1980.
% C------------INPUT PARAMETERS:
% C   PS - GEODIPOLE TILT ANGLE IN RADIANS, X,Y,Z - GSM COORDINATES IN RE
% C------------OUTPUT PARAMETERS:
% C   BX,BY,BZ - FIELD COMPONENTS IN GSM SYSTEM, IN NANOTESLA.
% C
% C
% C     WRITEN BY: N. A. TSYGANENKO

persistent M PSI % guessed from structure of M
M = 0;
PSI = 5;
if ~((M==1) & (abs(PS-PSI)<1.E-5)),
    SPS=sin(PS);
    CPS=cos(PS);
    PSI=PS;
    M=1;
end
P=X^2;
U=Z^2;
V=3.*Z*X;
T=Y^2;
Q=30574./sqrt(P+T+U)^5;
BX=Q*((T+U-2.*P)*SPS-V*CPS);
BY=-3.*Y*Q*(X*SPS+Z*CPS);
BZ=Q*((P+T-2.*U)*CPS-V*SPS);
% end of function DIPOLE

