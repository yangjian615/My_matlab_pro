function [eField] = get_3d_e_field(tint,scInd)
%Jian.GET_3D_E_FIELD returns 3D EFW data in ISR2.
%   eField = Jian.GET_3D_E_FIELD(tint,scInd) - returns 3D electic field
%   for time interval tint and for spacecraft scInd.

%   See also: Jian.PLOT_3D_E_FIELD, Jian.GET_3D_E_FIELD,
%   Jian.PLOT_3D_B_FIELD

if(scInd == 1 || scInd == 2 || scInd == 3 || scInd == 4)
    dataStr = ['E_Vec_xyz_GSE__C',num2str(scInd),'_CP_EFW_L2_E3D_GSE'];
    eField = local.c_read(dataStr,tint);
    
else
    eField = zeros(1,4);
    disp('Not a spacecraft!')
    return;
end

end
