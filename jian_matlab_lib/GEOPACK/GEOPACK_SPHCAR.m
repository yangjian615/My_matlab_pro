function [A,B,C] = GEOPACK_SPHCAR (X,Y,Z,J)
% function [A,B,C] = GEOPACK_SPHCAR (X,Y,Z,J)
%      SUBROUTINE SPHCAR (R,THETA,PHI,X,Y,Z,J)
% C
% C   CONVERTS SPHERICAL COORDS INTO CARTESIAN ONES AND VICA VERSA
% C    (THETA AND PHI IN RADIANS).
% C
% C                  J>0            J<0
% C-----INPUT:   J,R,THETA,PHI     J,X,Y,Z
% C----OUTPUT:      X,Y,Z        R,THETA,PHI
% C
% C  NOTE: AT THE POLES (X=0 AND Y=0) WE ASSUME PHI=0 (WHEN CONVERTING
% C        FROM CARTESIAN TO SPHERICAL COORDS, I.E., FOR J<0)
% C
% C   LAST MOFIFICATION:  APRIL 1, 2003 (ONLY SOME NOTATION CHANGES AND MORE
% C                         COMMENTS ADDED)
% C
% C   AUTHOR:  N. A. TSYGANENKO
% C
if (J<0),
    [A,B,C] = GEOPACK_CAR2SPH(X,Y,Z);
else
    [A,B,C] = GEOPACK_SPH2CAR(X,Y,Z);
end

function [R,THETA,PHI] = GEOPACK_CAR2SPH(X,Y,Z)
SQ=X^2+Y^2;
R=sqrt(SQ+Z^2);
if (SQ == 0.),
    PHI=0.;
    if (Z >= 0.) 
        THETA=0.;
        return
    end
    THETA=3.141592654; % 1
    return
end
SQ=sqrt(SQ); % 2
PHI=atan2(Y,X);
THETA=atan2(SQ,Z);
if (PHI < 0.), PHI=PHI+6.28318531; end

function [X,Y,Z] = GEOPACK_SPH2CAR(R,THETA,PHI)
SQ=R*sin(THETA); %  3   
X=SQ*cos(PHI);
Y=SQ*sin(PHI);
Z=R*cos(THETA);

%       RETURN
%       END
% end of function SPHCAR
% C
% C===========================================================================
% c

