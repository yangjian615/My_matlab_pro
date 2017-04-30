function [hsf,ionMat,t] = plot_hia_subspin(AX,tint,scInd,varargin)
%Jian.PLOT_HIA_SUBSPIN plots data from HIA in phase space density [s^3km^-6].
%   [hsf,ionMat,t] = Jian.PLOT_HIA_SUBSPIN(AX,tint,scInd,mode,colLim) plots
%   HIA data in phase space density. Returns data in ionMat and time vector
%   t. Input tint is the time interval for the data, scInd is the
%   spacecraft number (1 or 3) and colLim is the limits of the colorbar.
%
%   mode:
%       'default'   - returns full 4-D matrix.
%       'energy'    - integrates over polar angle
%
%   See also: Jian.GET_HIA_DATA
%
%   ONLY WORKS FOR SUBSPIN DATA


% if(nargin<5)
%     enMode = 'full';
% end
% if(nargin<6)
%     colLim = [2,10];
% end

pEn = {'full','half'};
pDa = {'energy','polar'};

[plotMode,enMode] = Jian.incheck(varargin,pDa,pEn);


tintData = [tint(1)-12,tint(2)+12];
[ionMat,t] = Jian.get_hia_data(tintData,scInd,plotMode,enMode);
[th,~,etab] = Jian.get_hia_values('all');
if(strcmp(enMode,'half'))
    etab = Jian.get_hia_values('etab','half');
end

fPar = AX.Parent;
if(~isfield(fPar.UserData,'t_start_epoch'))
    fPar.UserData.t_start_epoch = tint(1);
end


P.p = ionMat;
P.t = t;

switch plotMode
    case 'energy'
        P.f = etab*1e3; % factor 1000 because irf_spectrogram believes 
                        % input is kHz.
        hsf = irf_spectrogram(AX,P);
        labStr = 'Energy [eV]';
        AX.YScale = 'log';
        AX.YTick = 10.^[1,2,3,4];
    case 'polar'
        P.p =P.p';
        P.f = th;
        hsf = irf_spectrogram(AX,P);

        labStr = '$\theta$ [deg]';
end

irf_zoom(AX,'x',tint')

Jian.label(AX,labStr)
legStr = ['C',num2str(scInd)];
hleg = irf_legend(AX,{legStr},[0.98,0.95]);
hleg.Color = 'k';

if(isfield(AX.UserData.XLabel,'Visible') && strcmp(AX.UserData.XLabel.Visible,'off'))
    AX.XTickLabel = '';
    AX.XLabel.String = '';
else
    irf_timeaxis(AX)
end


end
