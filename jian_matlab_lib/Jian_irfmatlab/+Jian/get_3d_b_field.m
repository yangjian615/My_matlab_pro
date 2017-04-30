function [bField] = get_3d_b_field(tint,scInd,dataMode)
%Jian.GET_3D_B_FIELD returns 3D FGM data in GSE.
%   bField = Jian.GET_3D_B_FIELD(tint,scInd) - returns components and
%   amplitue of magnetic field for time interval tint for spacecraft scInd.
%   bField = Jian.GET_3D_B_FIELD(tint,scInd,plotMode)
%   mode:
%       'default'   - returns components and amplitude.
%       '3d'        - returns only components.
%       'abs'       - returns only amplitude.
%
%   See also: Jian.PLOT_3D_B_FIELD, Jian.GET_3D_E_FIELD,
%   Jian.PLOT_3D_E_FIELD


if(nargin < 3)
    dataMode = 'default';
end

if(scInd == 1 || scInd == 2 || scInd == 3 || scInd == 4)
    dataStr = ['B_vec_xyz_gse__C',num2str(scInd),'_CP_FGM_FULL'];
    bField = local.c_read(dataStr,tint);
    
else
    bField = zeros(1,4);
    disp('Not a spacecraft!')
    return;
end

switch dataMode
    case 'default'
        normB = sqrt(sum(bField(:,2:4).^2,2));
        bField = [bField,normB];
        
    case '3d'
        %nothing
        
    case 'abs'
        normB = sqrt(sum(bField(:,2:4).^2,2));
        bField = [bField(:,1),normB];
end


end

