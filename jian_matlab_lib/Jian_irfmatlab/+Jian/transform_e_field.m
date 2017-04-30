function [eTrans] = transform_e_field(eF,bF,dv)
%Jian.TRANSFORM_E_FIELD Transforms electric field to another inertial frame
%   eTrans = Jian.TRANSFORM_E_FIELD(eF,bF,dv) returns the transformed
%   E-field given original E-field, B-field and change in velocity dV,
%   where dv is a 1x3 vector.
%
%   E' = E + dv x B

%   Should work in burst and normal modes.


eTrans = zeros(size(eF));
eTrans(:,1) = eF(:,1);

for i = 1:length(eF)
    % Get B-field for time of E-field measurement
    bInt = get_b(eF(i,1),bF);
    eTrans(i,2:4) = eF(i,2:4)*1e-3 + cross(dv,bInt);
end
eTrans(:,2:4) = eTrans(:,2:4)*1e3;

end


function [bInt] = get_b(t,bF) % in Teslas
    
    bInt = interp1(bF(:,1),bF(:,2:4),t)*1e-9;
    
   
end

