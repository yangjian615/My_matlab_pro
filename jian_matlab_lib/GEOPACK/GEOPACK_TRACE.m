function [XF,YF,ZF,XX,YY,ZZ,L] = GEOPACK_TRACE (XI,YI,ZI,DIR,RLIM,R0,IOPT,PARMOD,EXNAME,INNAME);
% function [XF,YF,ZF,XX,YY,ZZ,L] = GEOPACK_TRACE (XI,YI,ZI,DIR,RLIM,R0,IOPT,PARMOD,EXNAME,INNAME);
%       SUBROUTINE TRACE (XI,YI,ZI,DIR,RLIM,R0,IOPT,PARMOD,EXNAME,INNAME,
%      *XF,YF,ZF,XX,YY,ZZ,L)
% C
% C  TRACES A FIELD LINE FROM AN ARBITRARY POINT OF SPACE TO THE EARTH'S
% C  SURFACE OR TO A MODEL LIMITING BOUNDARY.
% C
% C  THE HIGHEST ORDER OF SPHERICAL HARMONICS IN THE MAIN FIELD EXPANSION USED
% C  IN THE MAPPING IS CALCULATED AUTOMATICALLY. IF INNAME=IGRF_GSM, THEN AN IGRF MODEL
% C  FIELD WILL BE USED, AND IF INNAME=DIP, A PURE DIPOLE FIELD WILL BE USED.
% 
% C  IN ANY CASE, BEFORE CALLING TRACE, ONE SHOULD INVOKE RECALC, TO CALCULATE CORRECT
% C  VALUES OF THE IGRF COEFFICIENTS AND ALL QUANTITIES NEEDED FOR TRANSFORMATIONS
% C  BETWEEN COORDINATE SYSTEMS INVOLVED IN THIS CALCULATIONS.
% C
% C  ALTERNATIVELY, THE SUBROUTINE RECALC CAN BE INVOKED WITH THE DESIRED VALUES OF
% C  IYEAR AND IDAY (TO SPECIFY THE DIPOLE MOMENT), WHILE THE VALUES OF THE DIPOLE
% C  TILT ANGLE PSI (IN RADIANS) AND ITS SINE (SPS) AND COSINE (CPS) CAN BE EXPLICITLY
% C  SPECIFIED AND FORWARDED TO THE COMMON BLOCK GEOPACK1 (11th, 12th, AND 16th ELEMENTS, RESP.)
% C
% C------------- INPUT PARAMETERS:
% C
% C   XI,YI,ZI - GSM COORDS OF INITIAL POINT (IN EARTH RADII, 1 RE = 6371.2 km),
% C
% C   DIR - SIGN OF THE TRACING DIRECTION: IF DIR=1.0 THEN WE MOVE ANTIPARALLEL TO THE
% C     FIELD VECTOR (E.G. FROM NORTHERN TO SOUTHERN CONJUGATE POINT),
% C     AND IF DIR=-1.0 THEN THE TRACING GOES IN THE OPPOSITE DIRECTION.
% C
% C   R0 -  RADIUS OF A SPHERE (IN RE) FOR WHICH THE FIELD LINE ENDPOINT COORDINATES
% C     XF,YF,ZF  SHOULD BE CALCULATED.
% C
% C   RLIM - UPPER LIMIT OF THE GEOCENTRIC DISTANCE, WHERE THE TRACING IS TERMINATED.
% C
% C   IOPT - A MODEL INDEX; CAN BE USED FOR SPECIFYING AN OPTION OF THE EXTERNAL FIELD
% C       MODEL (E.G., INTERVAL OF THE KP-INDEX). ALTERNATIVELY, ONE CAN USE THE ARRAY
% C       PARMOD FOR THAT PURPOSE (SEE BELOW); IN THAT CASE IOPT IS JUST A DUMMY PARAMETER.
% C
% C   PARMOD -  A 10-ELEMENT ARRAY CONTAINING MODEL PARAMETERS, NEEDED FOR A UNIQUE
% C      SPECIFICATION OF THE EXTERNAL FIELD. THE CONCRETE MEANING OF THE COMPONENTS
% C      OF PARMOD DEPENDS ON A SPECIFIC VERSION OF THE EXTERNAL FIELD MODEL.
% C
% C   EXNAME - NAME OF A SUBROUTINE PROVIDING COMPONENTS OF THE EXTERNAL MAGNETIC FIELD
% C    (E.G., T96). (empty string '' for no external field)
% C   INNAME - NAME OF A SUBROUTINE PROVIDING COMPONENTS OF THE INTERNAL MAGNETIC FIELD
% C    (EITHER GEOPACK_DIP OR GEOPACK_IGRF_GSM). (empty string '' for no internal field)
% C
% C-------------- OUTPUT PARAMETERS:
% C
% C   XF,YF,ZF - GSM COORDS OF THE LAST CALCULATED POINT OF A FIELD LINE
% C   XX,YY,ZZ - ARRAYS, CONTAINING COORDS OF FIELD LINE POINTS. HERE THEIR MAXIMAL LENGTH WAS
% C      ASSUMED EQUAL TO 999.
% C   L - ACTUAL NUMBER OF THE CALCULATED FIELD LINE POINTS. IF L EXCEEDS 999, TRACING
% C     TERMINATES, AND A WARNING IS DISPLAYED.
% C
% C
% C     LAST MODIFICATION:  MARCH 31, 2003.
% C
% C     AUTHOR:  N. A. TSYGANENKO
% C


%       DIMENSION XX(1000),YY(1000),ZZ(1000), PARMOD(10)
%       COMMON /GEOPACK1/ AA(26),DD,BB(8)
global GEOPACK1;
% DD -> GEOPACK1.DS3
%       EXTERNAL EXNAME,INNAME
% C
ERR=0.0001; % changed from 0.0005 4/21/03, per email from Tsyganenko
L=0;
DS=0.5*DIR;
X=XI;
Y=YI;
Z=ZI;
GEOPACK1.DS3=DIR;
AL=0.;
% c
% c  here we call RHAND just to find out the sign of the radial component of the field
% c   vector, and to determine the initial direction of the tracing (i.e., either away
% c   or towards Earth):
% c
[R1,R2,R3] = GEOPACK_RHAND (X,Y,Z,IOPT,PARMOD,EXNAME,INNAME);
AD=0.01;
if (X*R1+Y*R2+Z*R3 < 0.), AD=-0.01; end;
% C
% c     |AD|=0.01 and its sign follows the rule:
% c (1) if DIR=1 (tracing antiparallel to B vector) then the sign of AD is the same as of Br
% c (2) if DIR=-1 (tracing parallel to B vector) then the sign of AD is opposite to that of Br
% c     AD is defined in order to initialize the value of RR (radial distance at previous step):

RR=sqrt(X^2+Y^2+Z^2)+AD;
while 1,
    breakcode = 0;
    L=L+1; % 1
    %      IF(L > 999) GOTO 7
    if L>999,
        breakcode = 7;
        break
    end
    XX(L)=X;
    YY(L)=Y;
    ZZ(L)=Z;
    RYZ=Y^2+Z^2;
    R2=X^2+RYZ;
    R=sqrt(R2);
    
    % c  check if the line hit the outer tracing boundary; if yes, then terminate
    % c   the tracing (label 8):
    
    %   IF (R > RLIM) | (RYZ > 1600.D0) | (X > 20.D0) GOTO 8
    if (R > RLIM) | (RYZ > 1600.D0) | (X > 20.D0) ,
        breakcode = 8;
        break
    end
    % c
    % c  check whether or not the inner tracing boundary was crossed from outside,
    % c  if yes, then calculate the footpoint position by interpolation (go to label 6):
    % c
    %    IF (R < R0) & (RR > R) GOTO 6
    if (R < R0) & (RR > R) ,
        breakcode = 6;
        break
    end
    
    % c  check if (i) we are moving outward, or (ii) we are still sufficiently
    % c    far from Earth (beyond R=5Re); if yes, proceed further:
    % c
    %    IF (R >= RR) | (R > 5.) GOTO 5
    if ~ ( (R >= RR) | (R > 5.) ),
        
        % c  now we moved closer inward (between R=3 and R=5); go to 3 and begin logging
        % c  previous values of X,Y,Z, to be used in the interpolation (after having
        % c  crossed the inner tracing boundary):
        
        %    IF (R >= 3.) GOTO 3
        if ~ (R >= 3.) ,
            % c
            % c  we entered inside the sphere R=3: to avoid too large steps (and hence inaccurate
            % c  interpolated position of the footpoint), enforce the progressively smaller
            % c  stepsize values as we approach the inner boundary R=R0:
            % c
            FC=0.2;
            if (R-R0 < 0.05), FC=0.05; end
            AL=FC*(R-R0+0.2);
            DS=DIR*AL;
            %     GOTO 4
        else
            DS=DIR; % 3
        end
        XR=X; % 4
        YR=Y;
        ZR=Z;
    end
    RR=R; % 5
    [X,Y,Z] = GEOPACK_STEP(X,Y,Z,DS,ERR,IOPT,PARMOD,EXNAME,INNAME);
    % GOTO 1
end % while 
% c
% c  find the footpoint position by interpolating between the current and previous
% c   field line points:
% c
if breakcode <=6,
    R1=(R0-R)/(RR-R); % 6
    X=X-(X-XR)*R1;
    Y=Y-(Y-YR)*R1;
    Z=Z-(Z-ZR)*R1;
    %    GOTO 8
else
    if breakcode <= 7,
        %  7   WRITE (*,10)
        disp(['**** COMPUTATIONS IN THE SUBROUTINE TRACE ARE', ...
                ' TERMINATED: THE CURRENT NUMBER OF POINTS EXCEEDED 1000 ****']);
        L=999;
    end
end
XF=X; % 8
YF=Y;
ZF=Z;
%       RETURN
%  10   FORMAT(//,1X,'**** COMPUTATIONS IN THE SUBROUTINE TRACE ARE',
%      *' TERMINATED: THE CURRENT NUMBER OF POINTS EXCEEDED 1000 ****'//)
%       END
% end of function TRACE
% c
% C====================================================================================
% C


