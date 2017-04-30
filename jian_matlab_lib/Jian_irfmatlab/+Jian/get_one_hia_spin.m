function [F,tData] = get_one_hia_spin(t,scInd,varargin)
%Jian.GET_ONE_HIA_SPIN get ion data for one full spin of CIS-HIA.
%   psdMat = Jian.GET_ONE_HIA_SPIN(t,scInd) returns ion data psdMat (matrix
%   of size 8x16x31) for spacecraft scInd = 1,3. The spin returned has
%   start time closest to the time t.
%   [psdMat,tData] = Jian.GET_ONE_HIA_SPIN(t,scInd) also returns time vector
%   tData = [tStart,tStop].
%
%   See also: Jian.GET_HIA_DATA
%
%   TODO: MAKE T START TIME.

%pDa = {'3d'};
pEn = {'full','half'};

enMode = Jian.incheck(varargin,pEn);

tint = [t-10,t+10];
[~,tArray] = Jian.get_hia_data(tint,scInd,enMode);
[F_3d,tvec] = Jian.get_hia_data(tint,scInd,enMode,'3d');

dataInd = Jian.fci(t,tArray);
tData = tArray(dataInd:dataInd+1);
tInd = find(tvec==tData(1));

% Chooses one spin
F = F_3d(:,tInd:tInd+15,:);

%F_3d = squeeze(F_4d(dataInd,:,:,:));

end