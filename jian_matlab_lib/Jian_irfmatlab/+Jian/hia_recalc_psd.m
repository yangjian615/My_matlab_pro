function [varargout] = hia_recalc_psd(F0,e0)
%Jian.HIA_RECALC_PSD Recalculates PSD from 31 to 16 energy bins.
%  
%   [F1,e1] = Jian.HIA_RECALC_PSD(F0,e0) Returns psd matrix with size: 8x16Nx16
%   where N is number of spins, e1 is new energy table. F0 is original psd
%   matrix with size 8x16Nx31. Both matricies are indexed (THETAxPHIxENERGY).
%   e1 is the original energy table.
%   
%   This function exists because of a weird feature in some subspin CIS-HIA
%   data where counts are the same over two energy bins. This means that
%   the energy resolution is halved. This function actually halves the
%   resolution.
%  
%   NB. The values of phase space density returned are proxys and should
%   not be completely trusted.


% Trow away every other data point.


% Indicies to keep. Energy goes from high to low. 31 is included because I
% thik it is good.

n = [2:2:31,31];
F1 = F0(:,:,n);

if(nargin==1 && nargout==1)
    varargout{1} = F1;
elseif(nargin ==2 && nargout==2)
    e1 = e0(n);
    varargout{1} = F1;
    varargout{2} = e1;
else
    error('Input/output mismatch')
end