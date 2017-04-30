function GEOPACK_RECALC (IYEAR,IDAY,IHOUR,MIN,ISEC)
% function GEOPACK_RECALC (IYEAR,IDAY,IHOUR,MIN,ISEC)
%      SUBROUTINE RECALC (IYEAR,IDAY,IHOUR,MIN,ISEC)
% C
% C  1. PREPARES ELEMENTS OF ROTATION MATRICES FOR TRANSFORMATIONS OF VECTORS BETWEEN
% C     SEVERAL COORDINATE SYSTEMS, MOST FREQUENTLY USED IN SPACE PHYSICS.
% C
% C  2. PREPARES COEFFICIENTS USED IN THE CALCULATION OF THE MAIN GEOMAGNETIC FIELD
% C      (IGRF MODEL)
% C
% C  THIS SUBROUTINE SHOULD BE INVOKED BEFORE USING THE FOLLOWING SUBROUTINES:
% C    IGRF_GEO, IGRF_GSM, DIP, GEOMAG, GEOGSM, MAGSM, SMGSM, GSMGSE, GEIGEO.
% C
% C  THERE IS NO NEED TO REPEATEDLY INVOKE RECALC, IF MULTIPLE CALCULATIONS ARE MADE
% C    FOR THE SAME DATE AND TIME.
% C
% C-----INPUT PARAMETERS:
% C
% C     IYEAR   -  YEAR NUMBER (FOUR DIGITS)
% C     IDAY  -  DAY OF YEAR (DAY 1 = JAN 1)
% C     IHOUR -  HOUR OF DAY (00 TO 23)
% C     MIN   -  MINUTE OF HOUR (00 TO 59)
% C     ISEC  -  SECONDS OF MINUTE (00 TO 59)
% C
% C-----OUTPUT PARAMETERS:   NONE (ALL OUTPUT QUANTITIES ARE PLACED
% C                         INTO THE COMMON BLOCKS /GEOPACK1/ AND /GEOPACK2/)
% C
% C    OTHER SUBROUTINES CALLED BY THIS ONE: SUN
% C
% C    AUTHOR:  N.A. TSYGANENKO
% C    DATE:    DEC.1, 1991
% C
% C    LAST REVISION: APRIL 3, 2003
% c      The code now includes preparation of the model coefficients for the subroutines
% c      IGRF and GEOMAG. This eliminates the need for the SAVE statements, used in the
% c      old versions, making the codes easier and more compiler-independent.
% C

%       COMMON /GEOPACK1/ ST0,CT0,SL0,CL0,CTCL,STCL,CTSL,STSL,SFI,CFI,SPS,
%      * CPS,SHI,CHI,HI,PSI,XMUT,A11,A21,A31,A12,A22,A32,A13,A23,A33,DS3,
%      * CGST,SGST,BA(6)
global GEOPACK1;

% C
% C  THE COMMON BLOCK /GEOPACK1/ CONTAINS ELEMENTS OF THE ROTATION MATRICES AND OTHER
% C   PARAMETERS RELATED TO THE COORDINATE TRANSFORMATIONS PERFORMED BY THIS PACKAGE
% C
%      COMMON /GEOPACK2/ G(66),H(66),REC(66)
global GEOPACK2
% C
% C  THE COMMON BLOCK /GEOPACK2/ CONTAINS COEFFICIENTS OF THE IGRF FIELD MODEL, CALCULATED
% C    FOR A GIVEN YEAR AND DAY FROM THEIR STANDARD EPOCH VALUES. THE ARRAY REC CONTAINS
% C    COEFFICIENTS USED IN THE RECURSION RELATIONS FOR LEGENDRE ASSOCIATE POLYNOMIALS.
% C
%       DIMENSION G65(66),H65(66),G70(66),H70(66),G75(66),H75(66),G80(66),
%      * H80(66),G85(66),H85(66),G90(66),H90(66),G95(66),H95(66),G00(66),
%      * H00(66),DG00(45),DH00(45)
% c
G65 = [0.,-30334.,-2119.,-1662.,2997.,1594.,1297.,-2038.,1292., ...
        856.,957.,804.,479.,-390.,252.,-219.,358.,254.,-31.,-157.,-62., ...
        45.,61.,8.,-228.,4.,1.,-111.,75.,-57.,4.,13.,-26.,-6.,13.,1.,13., ...
        5.,-4.,-14.,0.,8.,-1.,11.,4.,8.,10.,2.,-13.,10.,-1.,-1.,5.,1.,-2., ...
        -2.,-3.,2.,-5.,-2.,4.,4.,0.,2.,2.,0.];
H65 = [0.,0.,5776.,0.,-2016.,114.,0.,-404.,240.,-165.,0.,148., ...
        -269.,13.,-269.,0.,19.,128.,-126.,-97.,81.,0.,-11.,100.,68.,-32., ...
        -8.,-7.,0.,-61.,-27.,-2.,6.,26.,-23.,-12.,0.,7.,-12.,9.,-16.,4., ...
        24.,-3.,-17.,0.,-22.,15.,7.,-4.,-5.,10.,10.,-4.,1.,0.,2.,1.,2., ...
        6.,-4.,0.,-2.,3.,0.,-6.];
% c
G70 = [0.,-30220.,-2068.,-1781.,3000.,1611.,1287.,-2091.,1278., ...
        838.,952.,800.,461.,-395.,234.,-216.,359.,262.,-42.,-160.,-56., ...
        43.,64.,15.,-212.,2.,3.,-112.,72.,-57.,1.,14.,-22.,-2.,13.,-2., ...
        14.,6.,-2.,-13.,-3.,5.,0.,11.,3.,8.,10.,2.,-12.,10.,-1.,0.,3., ...
        1.,-1.,-3.,-3.,2.,-5.,-1.,6.,4.,1.,0.,3.,-1.];
H70 = [0.,0.,5737.,0.,-2047.,25.,0.,-366.,251.,-196.,0.,167., ...
        -266.,26.,-279.,0.,26.,139.,-139.,-91.,83.,0.,-12.,100.,72.,-37., ...
        -6.,1.,0.,-70.,-27.,-4.,8.,23.,-23.,-11.,0.,7.,-15.,6.,-17.,6., ...
        21.,-6.,-16.,0.,-21.,16.,6.,-4.,-5.,10.,11.,-2.,1.,0.,1.,1.,3., ...
        4.,-4.,0.,-1.,3.,1.,-4.];
% c
G75 = [0.,-30100.,-2013.,-1902.,3010.,1632.,1276.,-2144.,1260., ...
        830.,946.,791.,438.,-405.,216.,-218.,356.,264.,-59.,-159.,-49., ...
        45.,66.,28.,-198.,1.,6.,-111.,71.,-56.,1.,16.,-14.,0.,12.,-5., ...
        14.,6.,-1.,-12.,-8.,4.,0.,10.,1.,7.,10.,2.,-12.,10.,-1.,-1.,4., ...
        1.,-2.,-3.,-3.,2.,-5.,-2.,5.,4.,1.,0.,3.,-1.];
H75 = [0.,0.,5675.,0.,-2067.,-68.,0.,-333.,262.,-223.,0.,191., ...
        -265.,39.,-288.,0.,31.,148.,-152.,-83.,88.,0.,-13.,99.,75.,-41., ...
        -4.,11.,0.,-77.,-26.,-5.,10.,22.,-23.,-12.,0.,6.,-16.,4.,-19.,6., ...
        18.,-10.,-17.,0.,-21.,16.,7.,-4.,-5.,10.,11.,-3.,1.,0.,1.,1.,3., ...
        4.,-4.,-1.,-1.,3.,1.,-5.];
% c
G80 = [0.,-29992.,-1956.,-1997.,3027.,1663.,1281.,-2180.,1251., ...
        833.,938.,782.,398.,-419.,199.,-218.,357.,261.,-74.,-162.,-48., ...
        48.,66.,42.,-192.,4.,14.,-108.,72.,-59.,2.,21.,-12.,1.,11.,-2., ...
        18.,6.,0.,-11.,-7.,4.,3.,6.,-1.,5.,10.,1.,-12.,9.,-3.,-1.,7.,2., ...
        -5.,-4.,-4.,2.,-5.,-2.,5.,3.,1.,2.,3.,0.];
H80 = [0.,0.,5604.,0.,-2129.,-200.,0.,-336.,271.,-252.,0.,212., ...
        -257.,53.,-297.,0.,46.,150.,-151.,-78.,92.,0.,-15.,93.,71.,-43., ...
        -2.,17.,0.,-82.,-27.,-5.,16.,18.,-23.,-10.,0.,7.,-18.,4.,-22.,9., ...
        16.,-13.,-15.,0.,-21.,16.,9.,-5.,-6.,9.,10.,-6.,2.,0.,1.,0.,3., ...
        6.,-4.,0.,-1.,4.,0.,-6.];
% c
G85 = [0.,-29873.,-1905.,-2072.,3044.,1687.,1296.,-2208.,1247., ...
        829.,936.,780.,361.,-424.,170.,-214.,355.,253.,-93.,-164.,-46., ...
        53.,65.,51.,-185.,4.,16.,-102.,74.,-62.,3.,24.,-6.,4.,10.,0.,21., ...
        6.,0.,-11.,-9.,4.,4.,4.,-4.,5.,10.,1.,-12.,9.,-3.,-1.,7.,1.,-5., ...
        -4.,-4.,3.,-5.,-2.,5.,3.,1.,2.,3.,0.];
H85 = [0.,0.,5500.,0.,-2197.,-306.,0.,-310.,284.,-297.,0.,232., ...
        -249.,69.,-297.,0.,47.,150.,-154.,-75.,95.,0.,-16.,88.,69.,-48., ...
        -1.,21.,0.,-83.,-27.,-2.,20.,17.,-23.,-7.,0.,8.,-19.,5.,-23.,11., ...
        14.,-15.,-11.,0.,-21.,15.,9.,-6.,-6.,9.,9.,-7.,2.,0.,1.,0.,3., ...
        6.,-4.,0.,-1.,4.,0.,-6.];
% c
G90 = [0., -29775.,  -1848.,  -2131.,   3059.,   1686.,   1314., ...
        -2239.,   1248.,    802.,    939.,    780.,    325.,   -423., ...
        141.,   -214.,    353.,    245.,   -109.,   -165.,    -36., ...
        61.,     65.,     59.,   -178.,      3.,     18.,    -96., ...
        77.,    -64.,      2.,     26.,     -1.,      5.,      9., ...
        0.,     23.,      5.,     -1.,    -10.,    -12.,      3., ...
        4.,      2.,     -6.,      4.,      9.,      1.,    -12., ...
        9.,     -4.,     -2.,      7.,      1.,     -6.,     -3., ...
        -4.,      2.,     -5.,     -2.,      4.,      3.,      1., ...
        3.,      3.,      0.];

H90 = [0.,      0.,   5406.,      0.,  -2279.,   -373.,      0., ...
        -284.,    293.,   -352.,      0.,    247.,   -240.,     84., ...
        -299.,      0.,     46.,    154.,   -153.,    -69.,     97., ...
        0.,    -16.,     82.,     69.,    -52.,      1.,     24., ...
        0.,    -80.,    -26.,      0.,     21.,     17.,    -23., ...
        -4.,      0.,     10.,    -19.,      6.,    -22.,     12., ...
        12.,    -16.,    -10.,      0.,    -20.,     15.,     11., ...
        -7.,     -7.,      9.,      8.,     -7.,      2.,      0., ...
        2.,      1.,      3.,      6.,     -4.,      0.,     -2., ...
        3.,     -1.,     -6.];

G95 = [0., -29682.,  -1789.,  -2197.,   3074.,   1685.,   1329., ...
        -2268.,   1249.,    769.,    941.,    782.,    291.,   -421., ...
        116.,   -210.,    352.,    237.,   -122.,   -167.,    -26., ...
        66.,     64.,     65.,   -172.,      2.,     17.,    -94., ...
        78.,    -67.,      1.,     29.,      4.,      8.,     10., ...
        -2.,     24.,      4.,     -1.,     -9.,    -14.,      4., ...
        5.,      0.,     -7.,      4.,      9.,      1.,    -12., ...
        9.,     -4.,     -2.,      7.,      0.,     -6.,     -3., ...
        -4.,      2.,     -5.,     -2.,      4.,      3.,      1., ...
        3.,      3.,      0.];

H95 = [0.,      0.,   5318.,      0.,  -2356.,   -425.,      0., ...
        -263.,    302.,   -406.,      0.,    262.,   -232.,     98., ...
        -301.,      0.,     44.,    157.,   -152.,    -64.,     99., ...
        0.,    -16.,     77.,     67.,    -57.,      4.,     28., ...
        0.,    -77.,    -25.,      3.,     22.,     16.,    -23., ...
        -3.,      0.,     12.,    -20.,      7.,    -21.,     12., ...
        10.,    -17.,    -10.,      0.,    -19.,     15.,     11., ...
        -7.,     -7.,      9.,      7.,     -8.,      1.,      0., ...
        2.,      1.,      3.,      6.,     -4.,      0.,     -2., ...
        3.,     -1.,     -6.];

G00 = [0., -29615.,  -1728.,  -2267.,   3072.,   1672.,   1341., ...
        -2290.,   1253.,    715.,    935.,    787.,    251.,   -405., ...
        110.,   -217.,    351.,    222.,   -131.,   -169.,    -12., ...
        72.,     68.,     74.,   -161.,     -5.,     17.,    -91., ...
        79.,    -74.,      0.,     33.,      9.,      7.,      8., ...
        -2.,     25.,      6.,     -9.,     -8.,    -17.,      9., ...
        7.,     -8.,     -7.,      5.,      9.,      3.,    - 8., ...
        6.,     -9.,     -2.,      9.,     -4.,     -8.,     -2., ...
        -6.,      2.,     -3.,      0.,      4.,      1.,      2., ...
        4.,      0.,     -1.];


H00 = [0.,      0.,   5186.,      0.,  -2478.,   -458.,      0., ...
        -227.,    296.,   -492.,      0.,    272.,   -232.,    119., ...
        -304.,      0.,     44.,    172.,   -134.,    -40.,    107., ...
        0.,    -17.,     64.,     65.,    -61.,      1.,     44., ...
        0.,    -65.,    -24.,      6.,     24.,     15.,    -25., ...
        -6.,      0.,     12.,    -22.,      8.,    -21.,     15., ...
        9.,    -16.,     -3.,      0.,    -20.,     13.,     12., ...
        -6.,     -8.,      9.,      4.,     -8.,      5.,      0., ...
        1.,      0.,      4.,      5.,     -6.,     -1.,     -3., ...
        0.,     -2.,     -8.];


DG00 = [0.0,  14.6,    10.7,   -12.4,     1.1,    -1.1,     0.7, ...
        -5.4,   0.9,    -7.7,    -1.3,     1.6,    -7.3,     2.9, ...
        -3.2,   0.0,    -0.7,    -2.1,    -2.8,    -0.8,     2.5, ...
        1.0,  -0.4,     0.9,     2.0,    -0.6,    -0.3,     1.2, ...
        -0.4,  -0.4,    -0.3,     1.1,     1.1,    -0.2,     0.6, ...
        -0.9,  -0.3,     0.2,    -0.3,     0.4,    -1.0,     0.3, ...
        -0.5,  -0.7,    -0.4];

DH00 = [0.0,   0.0,   -22.5,     0.0,   -20.6,    -9.6,     0.0, ...
        6.0,  -0.1,   -14.2,     0.0,     2.1,     1.3,     5.0, ...
        0.3,   0.0,    -0.1,     0.6,     1.7,     1.9,     0.1, ...
        0.0,  -0.2,    -1.4,     0.0,    -0.8,     0.0,     0.9, ...
        0.0,   1.1,     0.0,     0.3,    -0.1,    -0.6,    -0.7, ...
        0.2,   0.0,     0.1,     0.0,     0.0,     0.3,     0.6, ...
        -0.4,   0.3,     0.7];
% C
% C
IY=IYEAR;
% C
% C  WE ARE RESTRICTED BY THE INTERVAL 1965-2005,
% C  FOR WHICH THE IGRF COEFFICIENTS ARE KNOWN; IF IYEAR IS OUTSIDE THIS INTERVAL,
% C  THE SUBROUTINE USES THE NEAREST LIMITING VALUE AND PRINTS A WARNING:
% C
if (IY < 1965),
    IY=1965;
    % 10   FORMAT(//1X,
    %      *'**** RECALC WARNS: YEAR IS OUT OF INTERVAL 1965-2005: IYEAR=',I4,
    %      * /,6X,'CALCULATIONS WILL BE DONE FOR IYEAR=',I4,/)
    %       WRITE (*,10) IYEAR,IY
    disp(sprintf(['**** RECALC WARNS: YEAR IS OUT OF INTERVAL 1965-2005: IYEAR=%d', ...
            'CALCULATIONS WILL BE DONE FOR IYEAR=%d'],IYEAR,IY));
end

if(IY > 2005) ,
    IY=2005;
    %       WRITE (*,10) IYEAR,IY
    disp(sprintf(['**** RECALC WARNS: YEAR IS OUT OF INTERVAL 1965-2005: IYEAR=%d', ...
            'CALCULATIONS WILL BE DONE FOR IYEAR=%d'],IYEAR,IY));
end

% C
% C  CALCULATE THE ARRAY REC, CONTAINING COEFFICIENTS FOR THE RECURSION RELATIONS,
% C  USED IN THE IGRF SUBROUTINE FOR CALCULATING THE ASSOCIATE LEGENDRE POLYNOMIALS
% C  AND THEIR DERIVATIVES:
% c
for N=1:11,
    %      DO 20 N=1,11
    N2=2*N-1;
    N2=N2*(N2-2);
    for M=1:N,
        %         DO 20 M=1,N
        MN=N*(N-1)/2+M;
        GEOPACK2.REC(MN)=((N-M)*(N+M-2))/(N2); % 20    
    end
end
% C
%       IF (IY < 1970) GOTO 50          %!INTERPOLATE BETWEEN 1965 - 1970
%       IF (IY < 1975) GOTO 60          %!INTERPOLATE BETWEEN 1970 - 1975
%       IF (IY < 1980) GOTO 70          %!INTERPOLATE BETWEEN 1975 - 1980
%       IF (IY < 1985) GOTO 80          %!INTERPOLATE BETWEEN 1980 - 1985
%       IF (IY < 1990) GOTO 90          %!INTERPOLATE BETWEEN 1985 - 1990
%       IF (IY < 1995) GOTO 100         %!INTERPOLATE BETWEEN 1990 - 1995
%       IF (IY < 2000) GOTO 110         %!INTERPOLATE BETWEEN 1995 - 2000
% C
% C       EXTRAPOLATE BEYOND 2000:
% C
if (IY >= 2000),
    DT=IY+(IDAY-1)/365.25-2000.;
    %     for N=1:66,
    %         G(N)=G00(N);
    %         H(N)=H00(N);
    %         if (N>=45),
    %             G(N)=G(N)+DG00(N)*DT;
    %             H(N)=H(N)+DH00(N)*DT;
    %         end
    %     end
    GEOPACK2.G = G00;
    GEOPACK2.H = H00;
    GEOPACK2.G(1:45) = GEOPACK2.G(1:45)+DG00*DT;
    GEOPACK2.H(1:45) = GEOPACK2.H(1:45)+DH00*DT;
    %      GOTO 300
elseif (IY < 1970),
    % C
    % C       INTERPOLATE BETWEEEN 1965 - 1970:
    % C
    F2=((IY)+(IDAY-1)/365.25-1965)/5.;
    F1=1.-F2;
    %     for N=1:66,
    %         G(N)=G65(N)*F1+G70(N)*F2;
    %         H(N)=H65(N)*F1+H70(N)*F2;
    %     end
    GEOPACK2.G = G65*F1+G70*F2;
    GEOPACK2.H = H65*F1+H70*F2;
    %      GOTO 300
elseif (IY < 1975),
    % C
    % C       INTERPOLATE BETWEEN 1970 - 1975:
    % C
    F2=((IY)+(IDAY-1)/365.25-1970)/5.;
    F1=1.-F2;
    % for N=1:66,
    %     G(N)=G70(N)*F1+G75(N)*F2;
    %     H(N)=H70(N)*F1+H75(N)*F2;
    % end
    GEOPACK2.G = G70*F1 + G75*F2;
    GEOPACK2.H = H70*F1 + H75*F2;
    %       GOTO 300
elseif (IY < 1980),
    % C
    % C       INTERPOLATE BETWEEN 1975 - 1980:
    % C
    F2=((IY)+(IDAY-1)/365.25-1975)/5.;
    F1=1.-F2;
    GEOPACK2.G = G75*F1+G80*F2;
    GEOPACK2.H = H75*F1+H80*F2;
    %       GOTO 300
elseif (IY < 1985),
    % C
    % C       INTERPOLATE BETWEEN 1980 - 1985:
    % C
    F2=((IY)+(IDAY-1)/365.25-1980)/5.;
    F1=1.-F2;
    GEOPACK2.G = G80*F1 + G85*F2;
    GEOPACK2.H = H80*F1 + H85*F2;
    %       GOTO 300
elseif (IY < 1990),
    % C
    % C       INTERPOLATE BETWEEN 1985 - 1990:
    % C
    F2=((IY)+(IDAY-1)/365.25-1985)/5.;
    F1=1.-F2;
    GEOPACK2.G = G85*F1+G90*F2;
    GEOPACK2.H = H85*F1+H90*F2;
    %       GOTO 300
elseif (IY < 1995),
    % C
    % C       INTERPOLATE BETWEEN 1990 - 1995:
    % C
    F2=((IY)+(IDAY-1)/365.25-1990)/5.;
    F1=1.-F2;
    GEOPACK2.G = G90*F1 + G95*F2;
    GEOPACK2.H = H90*F1 + H95*F2;
    %       GOTO 300
elseif (IY < 2000),
    % C
    % C       INTERPOLATE BETWEEN 1995 - 2000:
    % C
    F2=((IY)+(IDAY-1)/365.25-1995)/5.;
    F1=1.-F2;
    GEOPACK2.G = G95*F1+G00*F2;
    GEOPACK2.H = H95*F1+H00*F2;
end
%       GOTO 300
% C
% C   COEFFICIENTS FOR A GIVEN YEAR HAVE BEEN CALCULATED; NOW MULTIPLY
% C   THEM BY SCHMIDT NORMALIZATION FACTORS:
% C
S=1.; % 300
for N=2:11,
    %      DO 120 N=2,11
    MN=N*(N-1)/2+1;
    S=S*(2*N-3)/(N-1);
    GEOPACK2.G(MN)=GEOPACK2.G(MN)*S;
    GEOPACK2.H(MN)=GEOPACK2.H(MN)*S;
    P=S;
    for M=2:N,
        %         DO 120 M=2,N
        AA=1.;
        if (M == 2), AA=2.; end
        P=P*sqrt(AA*(N-M+1)/(N+M-2));
        MNN=MN+M-1;
        GEOPACK2.G(MNN)=GEOPACK2.G(MNN)*P;
        GEOPACK2.H(MNN)=GEOPACK2.H(MNN)*P; % 120         
    end
end

G10=-GEOPACK2.G(2);
G11= GEOPACK2.G(3);
H11= GEOPACK2.H(3);
% C
% C  NOW CALCULATE THE COMPONENTS OF THE UNIT VECTOR EzMAG IN GEO COORD.SYSTEM:
% C   sin(TETA0)*cos(LAMBDA0), sin(TETA0)*sin(LAMBDA0), AND cos(TETA0)
% C         ST0 * CL0                ST0 * SL0                CT0
% C
SQ=G11^2+H11^2;
SQQ=sqrt(SQ);
SQR=sqrt(G10^2+SQ);
GEOPACK1.SL0=-H11/SQQ;
GEOPACK1.CL0=-G11/SQQ;
GEOPACK1.ST0=SQQ/SQR;
GEOPACK1.CT0=G10/SQR;
GEOPACK1.STCL=GEOPACK1.ST0*GEOPACK1.CL0;
GEOPACK1.STSL=GEOPACK1.ST0*GEOPACK1.SL0;
GEOPACK1.CTSL=GEOPACK1.CT0*GEOPACK1.SL0;
GEOPACK1.CTCL=GEOPACK1.CT0*GEOPACK1.CL0;
% C
%      CALL SUN (IY,IDAY,IHOUR,MIN,ISEC,GST,SLONG,SRASN,SDEC)
[GST,SLONG,SRASN,SDEC] = GEOPACK_SUN (IY,IDAY,IHOUR,MIN,ISEC);
% C
% C  S1,S2, AND S3 ARE THE COMPONENTS OF THE UNIT VECTOR EXGSM=EXGSE IN THE
% C   SYSTEM GEI POINTING FROM THE EARTH'S CENTER TO THE SUN:
% C
S1=cos(SRASN)*cos(SDEC);
S2=sin(SRASN)*cos(SDEC);
S3=sin(SDEC);
GEOPACK1.CGST=cos(GST);
GEOPACK1.SGST=sin(GST);
% C
% C  DIP1, DIP2, AND DIP3 ARE THE COMPONENTS OF THE UNIT VECTOR EZSM=EZMAG
% C   IN THE SYSTEM GEI:
% C
DIP1=GEOPACK1.STCL*GEOPACK1.CGST-GEOPACK1.STSL*GEOPACK1.SGST;
DIP2=GEOPACK1.STCL*GEOPACK1.SGST+GEOPACK1.STSL*GEOPACK1.CGST;
DIP3=GEOPACK1.CT0;
% C
% C  NOW CALCULATE THE COMPONENTS OF THE UNIT VECTOR EYGSM IN THE SYSTEM GEI
% C   BY TAKING THE VECTOR PRODUCT D x S AND NORMALIZING IT TO UNIT LENGTH:
% C
Y1=DIP2*S3-DIP3*S2;
Y2=DIP3*S1-DIP1*S3;
Y3=DIP1*S2-DIP2*S1;
Y=sqrt(Y1*Y1+Y2*Y2+Y3*Y3);
Y1=Y1/Y;
Y2=Y2/Y;
Y3=Y3/Y;
% C
% C   THEN IN THE GEI SYSTEM THE UNIT VECTOR Z = EZGSM = EXGSM x EYGSM = S x Y
% C    HAS THE COMPONENTS:
% C
Z1=S2*Y3-S3*Y2;
Z2=S3*Y1-S1*Y3;
Z3=S1*Y2-S2*Y1;
% C
% C    THE VECTOR EZGSE (HERE DZ) IN GEI HAS THE COMPONENTS (0,-sin(DELTA),
% C     cos(DELTA)) = (0.,-0.397823,0.917462); HERE DELTA = 23.44214 DEG FOR
% C   THE EPOCH 1978 (SEE THE BOOK BY GUREVICH OR OTHER ASTRONOMICAL HANDBOOKS).
% C    HERE THE MOST ACCURATE TIME-DEPENDENT FORMULA IS USED:
% C
DJ=(365*(IY-1900)+floor((IY-1901)/4) +IDAY) ...
    -0.5+(IHOUR*3600+MIN*60+ISEC)/86400.;
T=DJ/36525.;
OBLIQ=(23.45229-0.0130125*T)/57.2957795;
DZ1=0.;
DZ2=-sin(OBLIQ);
DZ3=cos(OBLIQ);
% C
% C  THEN THE UNIT VECTOR EYGSE IN GEI SYSTEM IS THE VECTOR PRODUCT DZ x S :
% C
DY1=DZ2*S3-DZ3*S2;
DY2=DZ3*S1-DZ1*S3;
DY3=DZ1*S2-DZ2*S1;
% C
% C   THE ELEMENTS OF THE MATRIX GSE TO GSM ARE THE SCALAR PRODUCTS:
% C   CHI=EM22=(EYGSM,EYGSE), SHI=EM23=(EYGSM,EZGSE), EM32=(EZGSM,EYGSE)=-EM23,
% C     AND EM33=(EZGSM,EZGSE)=EM22
% C
GEOPACK1.CHI=Y1*DY1+Y2*DY2+Y3*DY3;
GEOPACK1.SHI=Y1*DZ1+Y2*DZ2+Y3*DZ3;
GEOPACK1.HI=asin(GEOPACK1.SHI);
% C
% C    TILT ANGLE: PSI=ARCSIN(DIP,EXGSM)
% C
GEOPACK1.SPS=DIP1*S1+DIP2*S2+DIP3*S3;
GEOPACK1.CPS=sqrt(1.-GEOPACK1.SPS^2);
GEOPACK1.PSI=asin(GEOPACK1.SPS);
% C
% C    THE ELEMENTS OF THE MATRIX MAG TO SM ARE THE SCALAR PRODUCTS:
% C CFI=GM22=(EYSM,EYMAG), SFI=GM23=(EYSM,EXMAG); THEY CAN BE DERIVED AS FOLLOWS:
% C
% C IN GEO THE VECTORS EXMAG AND EYMAG HAVE THE COMPONENTS (CT0*CL0,CT0*SL0,-ST0)
% C  AND (-SL0,CL0,0), RESPECTIVELY.    HENCE, IN GEI THE COMPONENTS ARE:
% C  EXMAG:    CT0*CL0*cos(GST)-CT0*SL0*sin(GST)
% C            CT0*CL0*sin(GST)+CT0*SL0*cos(GST)
% C            -ST0
% C  EYMAG:    -SL0*cos(GST)-CL0*sin(GST)
% C            -SL0*sin(GST)+CL0*cos(GST)
% C             0
% C  THE COMPONENTS OF EYSM IN GEI WERE FOUND ABOVE AS Y1, Y2, AND Y3;
% C  NOW WE ONLY HAVE TO COMBINE THE QUANTITIES INTO SCALAR PRODUCTS:
% C
EXMAGX=GEOPACK1.CT0*(GEOPACK1.CL0*GEOPACK1.CGST-GEOPACK1.SL0*GEOPACK1.SGST);
EXMAGY=GEOPACK1.CT0*(GEOPACK1.CL0*GEOPACK1.SGST+GEOPACK1.SL0*GEOPACK1.CGST);
EXMAGZ=-GEOPACK1.ST0;
EYMAGX=-(GEOPACK1.SL0*GEOPACK1.CGST+GEOPACK1.CL0*GEOPACK1.SGST);
EYMAGY=-(GEOPACK1.SL0*GEOPACK1.SGST-GEOPACK1.CL0*GEOPACK1.CGST);
GEOPACK1.CFI=Y1*EYMAGX+Y2*EYMAGY;
GEOPACK1.SFI=Y1*EXMAGX+Y2*EXMAGY+Y3*EXMAGZ;
% C
GEOPACK1.XMUT=(atan2(GEOPACK1.SFI,GEOPACK1.CFI)+3.1415926536)*3.8197186342;
% C
% C  THE ELEMENTS OF THE MATRIX GEO TO GSM ARE THE SCALAR PRODUCTS:
% C
% C   A11=(EXGEO,EXGSM), A12=(EYGEO,EXGSM), A13=(EZGEO,EXGSM),
% C   A21=(EXGEO,EYGSM), A22=(EYGEO,EYGSM), A23=(EZGEO,EYGSM),
% C   A31=(EXGEO,EZGSM), A32=(EYGEO,EZGSM), A33=(EZGEO,EZGSM),
% C
% C   ALL THE UNIT VECTORS IN BRACKETS ARE ALREADY DEFINED IN GEI:
% C
% C  EXGEO=(CGST,SGST,0), EYGEO=(-SGST,CGST,0), EZGEO=(0,0,1)
% C  EXGSM=(S1,S2,S3),  EYGSM=(Y1,Y2,Y3),   EZGSM=(Z1,Z2,Z3)
% C                                                           AND  THEREFORE:
% C
GEOPACK1.A11=S1*GEOPACK1.CGST+S2*GEOPACK1.SGST;
GEOPACK1.A12=-S1*GEOPACK1.SGST+S2*GEOPACK1.CGST;
GEOPACK1.A13=S3;
GEOPACK1.A21=Y1*GEOPACK1.CGST+Y2*GEOPACK1.SGST;
GEOPACK1.A22=-Y1*GEOPACK1.SGST+Y2*GEOPACK1.CGST;
GEOPACK1.A23=Y3;
GEOPACK1.A31=Z1*GEOPACK1.CGST+Z2*GEOPACK1.SGST;
GEOPACK1.A32=-Z1*GEOPACK1.SGST+Z2*GEOPACK1.CGST;
GEOPACK1.A33=Z3;
% C
%  10   FORMAT(//1X,
%      *'**** RECALC WARNS: YEAR IS OUT OF INTERVAL 1965-2005: IYEAR=',I4,
%      * /,6X,'CALCULATIONS WILL BE DONE FOR IYEAR=',I4,/)
%       RETURN
%       END
% end of function RECALC
% c
% c====================================================================
% C

