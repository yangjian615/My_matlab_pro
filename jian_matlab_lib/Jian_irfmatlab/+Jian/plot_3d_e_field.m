function [out] = plot_3d_e_field(x1,x2,scInd)
%Jian.PLOT_3D_E_FIELD plot 3D EFW data in ISR2.
%   Jian.PLOT_3D_E_FIELD(AX,tint,scInd) plots 3D electric field data from EFW
%   data in ISR2 during the time interval tint and for s/c number scInd =
%   1,2,3,4.
%   Jian.PLOT_3D_E_FIELD(AX,eField) plots the input E-field with the
%   correct plot mode.
%   Jian.PLOT_3D_E_FIELD(eField) Initiates a new figure and plots the
%   input E-field.
%   eField = Jian.PLOT_3D_E_FIELD(...) also returns the eField.
%
%   See also: Jian.GET_3D_E_FIELD, Jian.PLOT_3D_B_FIELD, 
%   Jian.GET_3D_B_FIELD


if(nargin == 1) % E-field input!
    AX = Jian.afigure(1);
    eField = x1;
    tint = [min(eField(:,1)),max(eField(:,1))];
elseif(nargin == 2) % handle and field
    AX = x1;
    eField = x2; 
    tint = [min(eField(:,1)),max(eField(:,1))];
else % three inputs
    AX = x1;
    tint = x2;
    eField = Jian.get_3d_e_field(tint,scInd);
end

irf_plot(AX,eField);

legLD = [0.02,0.06];
irf_legend(AX,{'E_{x}','E_{y}','E_{z}'},legLD);

Jian.label(AX,'$E$ [mVm$^{-1}$]')

irf_zoom(AX,'x',tint)

if(isfield(AX.UserData.XLabel,'Visible') && strcmp(AX.UserData.XLabel.Visible,'off'))
    AX.XTickLabel = '';
    AX.XLabel.String = '';
else
    irf_timeaxis(AX)
end


if(nargout == 1)
    out = eField;
end

end