function [vRefl] = reflect_vector(vSW,vSLAM)
%Jian.REFLECT_VECTOR Mirrors a velocity vector on a moving plane.
%   vRefl = Jian.REFLECT_VECTOR(vSW,vSLAM) returns the velocity of reflected ions
%   given solar wind and SLAMS velocities.


% Change to a coordinate system in which the SLAMS is in rest v -> v-vSLAM
nHat = vSLAM/sqrt(sum(vSLAM.^2));
vIn = vSW-vSLAM;


vN = (vIn*nHat')*nHat; %Normal component
vT = vIn-vN;    %Other component

vR = -vN+vT; %Reflection

% Change back to s/c system
vRefl = vR+vSLAM;

end

