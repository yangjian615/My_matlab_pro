function [HXGSM,HYGSM,HZGSM] = GEOPACK_IGRF_GSM (XGSM,YGSM,ZGSM)
% function [HXGSM,HYGSM,HZGSM] = GEOPACK_IGRF_GSM (XGSM,YGSM,ZGSM)
%      SUBROUTINE IGRF_GSM (XGSM,YGSM,ZGSM,HXGSM,HYGSM,HZGSM)
% c
% C  CALCULATES COMPONENTS OF THE MAIN (INTERNAL) GEOMAGNETIC FIELD IN THE GEOCENTRIC SOLAR
% C  MAGNETOSPHERIC COORDINATE SYSTEM, USING IAGA INTERNATIONAL GEOMAGNETIC REFERENCE MODEL
% C  COEFFICIENTS  (e.g., http://www.ngdc.noaa.gov/IAGA/wg8/igrf2000.html)
% C
% C  BEFORE THE FIRST CALL OF THIS SUBROUTINE, OR IF THE DATE/TIME (IYEAR,IDAY,IHOUR,MIN,ISEC)
% C  WAS CHANGED, THE MODEL COEFFICIENTS AND GEO-GSM ROTATION MATRIX ELEMENTS SHOULD BE UPDATED
% c  BY CALLING THE SUBROUTINE RECALC
% C
% C-----INPUT PARAMETERS:
% C
% C     XGSM,YGSM,ZGSM - CARTESIAN GSM COORDINATES (IN UNITS RE=6371.2 KM)
% C
% C-----OUTPUT PARAMETERS:
% C
% C     HXGSM,HYGSM,HZGSM - CARTESIAN GSM COMPONENTS OF THE MAIN GEOMAGNETIC FIELD IN NANOTESLA
% C
% C     LAST MODIFICATION:  MARCH 30, 2003.
% C     THIS VERSION OF THE  CODE ACCEPT DATES FROM 1965 THROUGH 2005.
% c
% C     AUTHOR: N. A. TSYGANENKO
% C
% C

%      COMMON /GEOPACK2/ G(66),H(66),REC(66)
global GEOPACK2;

%      DIMENSION A(11),B(11)

%      CALL GEOGSM (XGEO,YGEO,ZGEO,XGSM,YGSM,ZGSM,-1)
[XGEO,YGEO,ZGEO] = GEOPACK_GEOGSM(XGSM,YGSM,ZGSM,-1);
RHO2=XGEO^2+YGEO^2;
R=sqrt(RHO2+ZGEO^2);
C=ZGEO/R;
RHO=sqrt(RHO2);
S=RHO/R;
if (S < 1.E-5),
    CF=1.;
    SF=0.;
else
    CF=XGEO/RHO;
    SF=YGEO/RHO;
end
% C
PP=1./R;
P=PP;
% C
% C  IN THIS NEW VERSION, THE OPTIMAL VALUE OF THE PARAMETER NM (MAXIMAL ORDER OF THE SPHERICAL
% C    HARMONIC EXPANSION) IS NOT USER-PRESCRIBED, BUT CALCULATED INSIDE THE SUBROUTINE, BASED
% C      ON THE VALUE OF THE RADIAL DISTANCE R:
% C
IRP3=R+3;
NM=4+30/IRP3;
if (NM > 10), NM=10; end

K=NM+1;      
for N=1:K,
    %      DO 150 N=1,K
    P=P*PP;
    A(N)=P;
    B(N)=P*N; % 150
end

P=1.;
D=0.;
BBR=0.;
BBT=0.;
BBF=0.;

for M=1:K,
    %      DO 200 M=1,K
    %    IF(M == 1) GOTO 160
    if (M~= 1),
        MM=M-1;
        W=X;
        X=W*CF+Y*SF;
        Y=Y*CF-W*SF;
        %         GOTO 170
    else
        X=0.;% 160
        Y=1.;
    end
    Q=P; % 170      
    Z=D;
    BI=0.;
    P2=0.;
    D2=0.;
    for N=M:K,
        %         DO 190 N=M,K
        AN=A(N);
        MN=N*(N-1)/2+M;
        E=GEOPACK2.G(MN);
        HH=GEOPACK2.H(MN);
        W=E*Y+HH*X;
        BBR=BBR+B(N)*W*Q;
        BBT=BBT-AN*W*Z;
        %            IF(M == 1) GOTO 180
        if (M~= 1),
            QQ=Q;
            if (S < 1.E-5), QQ=Z; end
            BI=BI+AN*(E*X-HH*Y)*QQ;
        end % 180
        XK=GEOPACK2.REC(MN);
        DP=C*Z-S*Q-XK*D2;
        PM=C*Q-XK*P2;
        D2=Z;
        P2=Q;
        Z=DP;
        Q=PM;
    end % 190
    D=S*D+C*P;
    P=S*P;
    %         IF(M == 1) GOTO 200
    if (M~= 1),
        BI=BI*MM;
        BBF=BBF+BI;
    end
end% 200   CONTINUE
% C
BR=BBR;
BT=BBT;
%IF(S < 1.E-5) GOTO 210
if (S>= 1.E-5),
    BF=BBF/S;
    %      GOTO 211
else
    if (C < 0.), BBF=-BBF; end % 210   
    BF=BBF;
end

HE=BR*S+BT*C; % 211   
HXGEO=HE*CF-BF*SF;
HYGEO=HE*SF+BF*CF;
HZGEO=BR*C-BT*S;

%      CALL GEOGSM (HXGEO,HYGEO,HZGEO,HXGSM,HYGSM,HZGSM,1)
[HXGSM,HYGSM,HZGSM] = GEOPACK_GEOGSM(HXGEO,HYGEO,HZGEO,1);

%      RETURN
%      END
% end of function IGRF_GSM
% C
% c==========================================================================================
% C
% c

