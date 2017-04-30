function [X,Y,Z] = GEOPACK_STEP (X,Y,Z,DS,ERRIN,IOPT,PARMOD,EXNAME,INNAME)
% function [X,Y,Z] = GEOPACK_STEP (X,Y,Z,DS,ERRIN,IOPT,PARMOD,EXNAME,INNAME)
%      SUBROUTINE STEP (X,Y,Z,DS,ERRIN,IOPT,PARMOD,EXNAME,INNAME)
% C
% C   RE-CALCULATES {X,Y,Z}, MAKING A STEP ALONG A FIELD LINE.
% C   DS IS THE STEP SIZE, ERRIN IS PERMISSIBLE ERROR VALUE, IOPT SPECIFIES THE EXTERNAL
% C   MODEL VERSION, THE ARRAY PARMOD CONTAINS INPUT PARAMETERS FOR THAT MODEL
% C   EXNAME IS THE NAME OF THE EXTERNAL FIELD SUBROUTINE (empty '' for none)
% C   INNAME IS THE NAME OF THE INTERNAL FIELD SUBROUTINE 
%           (EITHER GEOPACK_DIP OR GEOPACK_IGRF_GSM) (empty '' for none)
% C
% C   ALL THE PARAMETERS ARE INPUT ONES; OUTPUT IS THE RENEWED TRIPLET X,Y,Z
% C
% C     LAST MODIFICATION:  MARCH 31, 2003
% C
% C     AUTHOR:  N. A. TSYGANENKO
% C

%       DIMENSION PARMOD(10)
%       COMMON /GEOPACK1/ A(26),DS3,B(8)
global GEOPACK1;
%       EXTERNAL EXNAME,INNAME

while 1,
    GEOPACK1.DS3=-DS/3.; % 1
    [R11,R12,R13] = GEOPACK_RHAND (X,Y,Z,IOPT,PARMOD,EXNAME,INNAME);
    
    [R21,R22,R23] = GEOPACK_RHAND (X+R11,Y+R12,Z+R13,IOPT,PARMOD,EXNAME,INNAME);

% Extra comma in  output vector of function definition is
% ignored by Matlab, but breaks Octave
% (changed on 3/11/05 by E.J. Rigler)
%    [R31,R32,R33,] = GEOPACK_RHAND (X+.5*(R11+R21),Y+.5*(R12+R22),Z+.5* ...
    [R31,R32,R33] = GEOPACK_RHAND (X+.5*(R11+R21),Y+.5*(R12+R22),Z+.5* ...
        (R13+R23),IOPT,PARMOD,EXNAME,INNAME);
    
    [R41,R42,R43] = GEOPACK_RHAND (X+.375*(R11+3.*R31),Y+.375*(R12+3.*R32 ...
        ),Z+.375*(R13+3.*R33),IOPT,PARMOD,EXNAME,INNAME);
    
    [R51,R52,R53] = GEOPACK_RHAND (X+1.5*(R11-3.*R31+4.*R41),Y+1.5*(R12- ...
        3.*R32+4.*R42),Z+1.5*(R13-3.*R33+4.*R43), ...
        IOPT,PARMOD,EXNAME,INNAME);
    
    ERRCUR=abs(R11-4.5*R31+4.*R41-.5*R51)+abs(R12-4.5*R32+4.*R42-.5* ...
        R52)+abs(R13-4.5*R33+4.*R43-.5*R53);
    
    %IF (ERRCUR < ERRIN) GOTO 2
    if (ERRCUR < ERRIN), break; end
    
    DS=DS*.5;
    
    %GOTO 1
end % while 1

X=X+.5*(R11+4.*R41+R51); % 2
Y=Y+.5*(R12+4.*R42+R52);
Z=Z+.5*(R13+4.*R43+R53);

if (ERRCUR < ERRIN*.04) & (abs(DS) < 1.33), DS=DS*1.5; end

%       RETURN
%       END
% end of function step
% C
% C==============================================================================
% C


