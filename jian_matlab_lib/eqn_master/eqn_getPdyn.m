function Pdyn = eqn_getPdyn(t, PdynDataStruct)
%eqn_getPdyn   Get value of Pdyn index
%
%   Pdyn = eqn_getPdyn(t, PdynDataStruct), returns a list with the Pdyn values
%   corresponding to the moments in time given in the 't' list (in matlab 
%   time format). The values are read from 'PdynDataStruct', which is the 
%   result of loading the mat file with the Pdyn values for the interval 
%   1/1/2000 to 31/12/2013.
%   
%   i.e. 
%        P = load('Pdyn_2000-2013.mat');
%        Pdyn = eqn_getPdyn(t, P)
% 

if nargin < 2; PdynDataStruct = load('Pdyn_2000-2013.mat'); end;

t_init = datenum(2000,1,1,0,0,0);

L = length(t);
Pdyn = nan(L,1);
Pdyn(1:L) = PdynDataStruct.Pdyn(fix((t - t_init)*24) + 1);

end