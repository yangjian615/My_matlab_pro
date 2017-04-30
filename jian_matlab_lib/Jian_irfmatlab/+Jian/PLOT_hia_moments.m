function [out] = PLOT_hia_moments(hia_moments)
%Jian.PLOT_hia_moments plot hiamoments data in GSE.

%   Jian.PLOT_hia_moments(hia_moments) Initiates a new figure and plots the
%   input hia_moments.
%   hia_moments = 
% 
%         density: [Nx2 double]
%     velocitygse: [Nx4 double]
%     temperature: [Nx2 double]
%        pressure: [Nx2 double]

%   hia_moments = Jian.PLOT_hia_moments(...) also returns the hia_moments.
%
%   See also: Jian.get_hia_moments

if(nargin == 1) % hia_moments input!
    figSize=[15,12];
    AX = Jian.afigure(4,figSize);
    tint = [min(hia_moments.density(:,1)),max(hia_moments.density(:,1))];
end

irf_plot(AX(1),hia_moments.density);
irf_plot(AX(2),hia_moments.velocitygse);
irf_plot(AX(3),hia_moments.temperature);
irf_plot(AX(4),hia_moments.pressure);

Units=irf_units;
temperature_kev=irf_tappl(hia_moments.temperature,'*Units.MK/11600.0');
h_secondaxis=irf_plot_double_axis(AX(1),temperature_kev,tint,{'N_{i} [cm^{-3}]','T_{i} [eV]'}); %#ok<*NASGU>

legLD = [0.02,0.06];
irf_legend(AX(2),{'V_{x}','V_{y}','V_{z}'},legLD);

AX_LABEL(1)=Jian.label(AX(1),'N_{i} [cm^{-3}]'); %#ok<NASGU>
AX_LABEL(2)=Jian.label(AX(2),'V_{gse} [km/s]');
AX_LABEL(3)=Jian.label(AX(3),'T_{i} [MK]');
AX_LABEL(4)=Jian.label(AX(4),'P_{i} [nPa]');

set(h_secondaxis.YLabel,'FontSize',12);
set(AX_LABEL,'Interpreter','tex','FontSize',12);
irf_zoom(AX,'x',tint);
irf_plot_axis_align;
irf_plot_ylabels_align;

if(isfield(AX(4).UserData.XLabel,'Visible') && strcmp(AX(4).UserData.XLabel.Visible,'off'))
    AX(4).XTickLabel = '';
    AX(4).XLabel.String = '';
else
    irf_timeaxis(AX)
end


if(nargout == 1)
    out = hia_moments;
end

end