function Dst = eqn_getDst(t, DstDataStruct)
%eqn_getDst   Get value of Dst index
%
%   Dst = eqn_getDst(t, DstDataStruct), returns a list with the Dst values
%   corresponding to the moments in time given in the 't' list (in matlab 
%   time format). The values are read from 'DstDataStruct', which is the 
%   result of loading the mat file with the Dst values for the interval 
%   1/1/2000 to 31/12/2013.
%   
%   i.e. 
%        D = load('Dst_2000-2013.mat');
%        Dst = eqn_getDst(t, D)
% 

if nargin < 2; DstDataStruct = load('Dst_2000-2013.mat'); end;

t_init = datenum(2000,1,1,0,0,0);

L = length(t);
Dst = nan(L,1);
Dst(1:L) = DstDataStruct.dst(fix((t - t_init)*24) + 1);

end