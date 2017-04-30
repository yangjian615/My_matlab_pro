function [out] = plot_3d_b_field(x1,x2,scInd,plotMode)
%Jian.PLOT_3D_B_FIELD plot 3D FGM data in GSE.
%   Jian.PLOT_3D_B_FIELD(AX,tint,scInd) - plots components and amplitude of
%   magnetic field for time interval tint for spacecraft scInd.
%   Jian.PLOT_3D_B_FIELD(AX,tint,scInd,plotMode)
%   mode:
%       'default'   - plots components and amplitude.
%       '3d'        - plots only components.
%       'abs'       - plots only amplitude.
%
%   Jian.PLOT_3D_B_FIELD(AX,bField) plots the input B-field with the
%   correct plot mode.
%   Jian.PLOT_3D_B_FIELD(bField) Initiates a new figure and plots the
%   input B-field.
%   bField = Jian.PLOT_3D_B_FIELD(...) also returns magnetic field.
%
%   See also: Jian.GET_3D_B_FIELD, Jian.GET_3D_E_FIELD,
%   Jian.PLOT_3D_E_FIELD




if(nargin < 4)
    plotMode = 'default';
end

if(nargin <= 2) % B-field input!
    if(nargin == 1)
        AX = Jian.afigure(1);
        bField = x1;
        
    elseif(nargin == 2)
        AX = x1;
        bField = x2;
    end
    tint = [min(bField(:,1)),max(bField(:,1))];
    bSize = size(bField);
    switch bSize(2) % Set plotMode after size of input B-field.
        case 5
            plotMode = 'default';
        case 4
            plotMode = '3d';
        case 2
            plotMode = 'abs';
    end
    
else % Get data
    AX = x1;
    tint = x2;
    bField = Jian.get_3d_b_field(tint,scInd,plotMode);
end


switch plotMode
    case 'default'
        legStr = {'B_{x}','B_{y}','B_{z}','|B|'};
    case '3d'
        legStr = {'B_{x}','B_{y}','B_{z}'};
    case 'abs'
        if(nargin > 2)
            scColor = Jian.get_cluster_colors(scInd);
            set(AX,'ColorOrder',scColor)
            %No legend
        end
end

irf_plot(AX,bField);

if(strcmp(plotMode,'abs'))
    % No legend
else
    legLD = [0.02,0.06]; % Left down
    irf_legend(AX,legStr,legLD);
end

Jian.label(AX,'$B$ [nT]')

irf_zoom(AX,'x',tint)

if(isfield(AX.UserData.XLabel,'Visible') && strcmp(AX.UserData.XLabel.Visible,'off'))
    AX.XTickLabel = '';
    AX.XLabel.String = '';
else
    irf_timeaxis(AX)
end


if(nargout == 1)
    out = bField;
end

end