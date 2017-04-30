function [R1,R2,R3] = GEOPACK_RHAND (X,Y,Z,IOPT,PARMOD,EXNAME,INNAME)
% function [R1,R2,R3] = GEOPACK_RHAND (X,Y,Z,IOPT,PARMOD,EXNAME,INNAME)
%      SUBROUTINE RHAND (X,Y,Z,R1,R2,R3,IOPT,PARMOD,EXNAME,INNAME)
% C
% C  CALCULATES THE COMPONENTS OF THE RIGHT HAND SIDE VECTOR IN THE GEOMAGNETIC FIELD
% C    LINE EQUATION  (a subsidiary subroutine for the subroutine STEP)
% C
% C     LAST MODIFICATION:  MARCH 31, 2003
% C
% C     AUTHOR:  N. A. TSYGANENKO
% C
%      DIMENSION PARMOD(10)
% C
% C     EXNAME AND INNAME ARE NAMES OF SUBROUTINES FOR THE EXTERNAL AND INTERNAL
% C     PARTS OF THE TOTAL FIELD (empty string for no EXTERNAL/INTERNAL field)
% C

%      COMMON /GEOPACK1/ A(15),PSI,AA(10),DS3,BB(8)
global GEOPACK1;

%      CALL EXNAME (IOPT,PARMOD,PSI,X,Y,Z,BXGSM,BYGSM,BZGSM)
if isempty(EXNAME),
    BXGSM = 0;
    BYGSM = 0;
    BZGSM = 0;
else
    [BXGSM,BYGSM,BZGSM] = feval(EXNAME ,IOPT,PARMOD,GEOPACK1.PSI,X,Y,Z);
end

%CALL INNAME (X,Y,Z,HXGSM,HYGSM,HZGSM)
if isempty(INNAME),
    HXGSM = 0;
    HYGSM = 0;
    HZGSM = 0;
else
    [HXGSM,HYGSM,HZGSM] = feval(INNAME,X,Y,Z);
end

BX=BXGSM+HXGSM;
BY=BYGSM+HYGSM;
BZ=BZGSM+HZGSM;
B=GEOPACK1.DS3/sqrt(BX^2+BY^2+BZ^2);
R1=BX*B;
R2=BY*B;
R3=BZ*B;
%       RETURN
%       END
% end of function RHAND
% C
% C===================================================================================
% C

