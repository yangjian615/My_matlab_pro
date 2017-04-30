function [F,t] = get_hia_data(tint,scInd,varargin)
%Jian.GET_HIA_DATA returns data from HIA in phase space density [s^3km^-6].
%   [ionMat,t] = Jian.GET_HIA_DATA(tint,scInd,dataMode) returns data in
%   matrix ionMat and time vector t. tint is the time interval for the
%   data, scInd is the spacecraft number (1 or 3).
%
%   [ionMat,t] = Jian.GET_HIA_DATA(tint,scInd,dataMode,'half') Returns ion
%   data with half energy resolution.
%
%   mode:
%       'default'   - returns full 4-D matrix.
%       '3d'        - like default but matrix N*16x8x31
%       'energy'    - integrates over polar angle
%       'polar'     - integrates over energy
%       '1d'        - integrates over azimutal and polar angle
%
%   See also: Jian.GET_ONE_HIA_SPIN, Jian.GET_HIA_VALUES
%
%   ONLY WORKS FOR SUBSPIN DATA

if(scInd == 1 || scInd == 3)
    dataStr = ['3d_ions__C',num2str(scInd),'_CP_CIS-HIA_HS_MAG_IONS_PSD'];
else
    disp('NO HIA DATA');
    F = zeros(8,16,31);
    return;
end

pDa = {'default','3d','energy','polar','1d'}; % data modes
pEn = {'full','half'};  % energy modes
[dataMode,enMode] = Jian.incheck(varargin,pDa,pEn);

ion3d = local.c_read(dataStr,tint);
F_4d = double(ion3d{2});
tArray = (ion3d{1});

if(nargin >= 3)
    if(strcmp(dataMode,'default'))
        % do nothing
        F = F_4d;
        t = tArray;
        
    else
        [t,F_3d] = hia_sum_over_spin(tArray,F_4d);
        if(nargin == 4 && strcmp(enMode,pEn{2}))
            F_3d = Jian.hia_recalc_psd(F_3d);
        end
            
        if(strcmp(dataMode,pDa{3}))
            % sum over polar angle
            F_2d = Jian.hia_sum_over_pol(F_3d);
            F = F_2d;
            
        elseif(strcmp(dataMode,pDa{4}))
            % sum over energy
            F_2d = hia_sum_over_energy(F_3d);
            F = F_2d;
            
        elseif(strcmp(dataMode,pDa{2}))
            F = F_3d;
        elseif(strcmp(dataMode,pDa{5}))
            F_2d = Jian.hia_sum_over_pol(F_3d);
            F_1d = hia_sum_over_az(F_2d);
            F = F_1d;
        end
    end
end

end


function [t,F_3d] = hia_sum_over_spin(tArray,F_4d) 
% HIA_SUM_OVER_SPIN Transforms 4d ion matrix to 3d ion matrix. No data is
% lost.

N = size(F_4d,1);
F_3d = zeros(8,N*16,31);
t = zeros(1,N*16);

for i = 1:N
    tInd = (i-1)*16+1;
    F_3d(:,tInd:tInd+15,:) = squeeze(F_4d(i,:,:,:));
    
    %recalculate tSpin everytime
    if(i == N)
        tSpin = mean(diff(tArray));
    else
        tSpin = tArray(i+1)-tArray(i);
    end
    t(tInd:tInd+15) = tArray(i)+linspace(0,tSpin*15/16,16);
end

end

function [F_1d] = hia_sum_over_az(F_2d)
% Input is 3d matrix, size:     16Nx31
% Output is 2d matrix, size:    1x31

F_1d = sum(F_2d,1);

end

function [F_2d] = hia_sum_over_energy(F_3d)
% Input is 3d matrix, size:     8x16Nx31
% Output is 2d matrix, size:    8*16N

F_2d = squeeze(sum(F_3d,3));

end

