function Kp = eqn_getKp(t, KpDataStruct)
%eqn_getKp   Get value of Kp index
%
%   Kp = eqn_getKp(t, KpDataStruct), returns a list with the Kp values
%   corresponding to the moments in time given in the 't' list (in matlab 
%   time format). The values are read from 'KpDataStruct', which is the 
%   result of loading the mat file with the Kp values for the interval 
%   1/1/2000 to 31/12/2010.
%   
%   i.e. 
%        K = load('Kp_2000-2010.mat');
%        Kp = eqn_getKp(t, K)
% 

if nargin < 2; KpDataStruct = load('Kp_2000-2014.mat'); end;

t_init = datenum(2000,1,1,0,0,0);

L = length(t);
Kp = nan(L,1);
Kp(1:L) = KpDataStruct.Kp(fix((t - t_init)*24) + 1);

end