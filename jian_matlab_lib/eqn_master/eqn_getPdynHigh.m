function Pdyn = eqn_getPdynHigh(t, PdynDataStruct)
%eqn_getPdyn   Get value of Pdyn index
%
%   Pdyn = eqn_getPdyn(t, PdynDataStruct), returns a list with the Pdyn values
%   corresponding to the moments in time given in the 't' list (in matlab 
%   time format). The values are read from 'PdynDataStruct', which is the 
%   result of loading the mat file with the Pdyn values for the year of 
%   interest. Data must be of High sampling rate (dt = 1 min).
%   
%   i.e. 
%        P = load('Pdyn_High_2008.mat');
%        Pdyn = eqn_getPdyn(t, P)
% 

yyyy = year(t(1));

if nargin < 2; 
    PdynDataStruct = load(['Pdyn_High_',num2str(yyyy),'.mat']);
end

t_init = datenum(yyyy,1,1,0,0,0);

L = length(t);
Pdyn = nan(L,1);
Pdyn(1:L) = PdynDataStruct.p(fix((t - t_init)*24*60) + 1);
Pdyn(Pdyn == 99.99) = nan;

end