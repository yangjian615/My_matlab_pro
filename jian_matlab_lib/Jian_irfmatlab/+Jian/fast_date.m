function [tOut] = fast_date(tIn,mode)
%Jian.FAST_DATE Returns a date string
%   tOut = Jian.FAST_DATE(tIn) returns a date string of tIn,
%   which is in Unix time.
%   
%   tOut = Jian.FAST_DATE(tIn,mode) specify the type of string reurned.
%   Default is mode=1.
%
%   Mode:
%       0   -   yyyy-mm-dd HH:MM:SS
%       1   -   yyyy-mm-dd HH:MM:SS.FFF
%       2   -   HH:MM:SS
%       3   -   HH:MM:SS.FFF
%
%   Example
%       tint = [irf_time([2002 02 03 04 18 00]), irf_time([2002 02 04 04 18 23])];
%       tOut = Jian.fast_date(tint,1);


if(nargin == 1)
    mode = 1; %Default
end

% If resolution is seconds, then round
if(mode/2 == floor(mode/2)) % even
    tIn = round(tIn);
end


% Start of Unix time
t0 = datenum([1970 01 01 00 00 00]);

% Value of tIn in some other time 
tVal = tIn/(3600*24)+t0;

switch mode
    case 0
        tOut = datestr(tVal,...
            'yyyy-mm-dd HH:MM:SS');
        
    case 1
        tOut = datestr(tVal,...
            'yyyy-mm-dd HH:MM:SS.FFF');
        
    case 2  %short
        tOut = datestr(tVal,...
            'HH:MM:SS');
        
    case 3  %short exaxt
        tOut = datestr(tVal,...
            'HH:MM:SS.FFF');
end

end

