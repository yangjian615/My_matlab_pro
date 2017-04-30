function [R] = get_c_pos(t)
%Jian.GET_C_POS Returns the position of all Cluster satellites
%   R = Jian.GET_C_POS(t) returns one satellite position at time t. If t is
%   a vector it is seen as a time interval.

    tint = 0;
    if(length(t) == 1)
        tint = [t-35,t+35];
    elseif(length(t) == 2)
        tint = t;
    end
    
    R = [];
    
    R.R1 = local.c_read('sc_r_xyz_gse__C1_CP_AUX_POSGSE_1M',tint);
    R.R2 = local.c_read('sc_r_xyz_gse__C2_CP_AUX_POSGSE_1M',tint);
    R.R3 = local.c_read('sc_r_xyz_gse__C3_CP_AUX_POSGSE_1M',tint);
    R.R4 = local.c_read('sc_r_xyz_gse__C4_CP_AUX_POSGSE_1M',tint);
    
end

