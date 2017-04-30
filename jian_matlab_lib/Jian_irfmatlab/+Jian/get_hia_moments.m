
function [hia_moments] = get_hia_moments(tint,scInd)
%Jian.get_hia_moments returns hia moments gse.
%   hia_moments = Jian.get_hia_moments(tint,scInd) - returns 3D electic field
%   for time interval tint and for spacecraft scInd.

%   See also: Jian.PLOT_hia_moments, Jian.get_hia_moments,
%   Jian.PLOT_3D_B_FIELD

if(scInd == 1 || scInd == 2 || scInd == 3 || scInd == 4)
    
    dataStr = ['density__C',num2str(scInd),'_CP_CIS_HIA_ONBOARD_MOMENTS'];
    hia_density= local.c_read(dataStr,tint);
    hia_moments.density=hia_density;
    
    dataStr = ['velocity_gse__C',num2str(scInd),'_CP_CIS_HIA_ONBOARD_MOMENTS'];
    hia_velocitygse= local.c_read(dataStr,tint);
    hia_moments.velocitygse=hia_velocitygse;
    
    
    dataStr = ['temperature__C',num2str(scInd),'_CP_CIS_HIA_ONBOARD_MOMENTS'];
    hia_temperature= local.c_read(dataStr,tint);
    hia_moments.temperature=hia_temperature;
    
    
    dataStr = ['pressure__C',num2str(scInd),'_CP_CIS_HIA_ONBOARD_MOMENTS'];
    hia_pressure= local.c_read(dataStr,tint);
    hia_moments.pressure=hia_pressure;
    
    
else
    hia_moments = zeros(1,4);
    disp('Not a spacecraft!')
    return;
end

end
