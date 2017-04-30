%********************************************************%
function MD=DOY_MD(YEAR,DOY)
%DOY_MD Summary of this function goes here
%
%   Detailed explanation goes here
% translate the days of the years to month date
%   Input:
%        YEAR
%        DOY

%   Output:
%        MD month date
%Example:
% % MD= DOY_MD(2015,365)

%----writen by Jian Yang at BUAA (2016-11-11)----



    MD='00000000';
    if (mod(YEAR,4)==0)&&(mod(YEAR,100)~=0)
        leap_year=1;
    elseif (mod(YEAR,100)==0)&&(mod(YEAR,400)~=0)
        leap_year=0;
    else
        leap_year=1;
    end

    if (DOY>=1)&&(DOY<=31)
        MONTH='01';
        DAY=DOY;
    elseif(DOY>=32)&&(DOY<=59+leap_year)
        MONTH='02';
        DAY=DOY-31;
    elseif(DOY>=60+leap_year)&&(DOY<=90+leap_year)
        MONTH='03';
        DAY=DOY-(59+leap_year);
    elseif(DOY>=91+leap_year)&&(DOY<=120+leap_year)
        MONTH='04';
        DAY=DOY-(90+leap_year);
    elseif(DOY>=121+leap_year)&&(DOY<=151+leap_year)
        MONTH='05';
        DAY=DOY-(120+leap_year);
    elseif(DOY>=152+leap_year)&&(DOY<=181+leap_year)
        MONTH='06';
        DAY=DOY-(151+leap_year);
    elseif(DOY>=182+leap_year)&&(DOY<=212+leap_year)
        MONTH='07';
        DAY=DOY-(181+leap_year);
    elseif(DOY>=213+leap_year)&&(DOY<=243+leap_year)
        MONTH='08';
        DAY=DOY-(212+leap_year);
    elseif(DOY>=244+leap_year)&&(DOY<=273+leap_year)
        MONTH='09';
        DAY=DOY-(243+leap_year);
    elseif(DOY>=274+leap_year)&&(DOY<=304+leap_year)
        MONTH='10';
        DAY=DOY-(273+leap_year);
    elseif(DOY>=305+leap_year)&&(DOY<=334+leap_year)
        MONTH='11';
        DAY=DOY-(304+leap_year);
    else
        MONTH='12';
        DAY=DOY-(334+leap_year);
    end

    MD(1:4)=num2str(YEAR);
    length_DAY=length(num2str(DAY));
    MD(5:6)=MONTH;
    MD(end-length_DAY+1:end)=num2str(DAY);
    MD=str2num(MD);
    
end
%********************************************************%