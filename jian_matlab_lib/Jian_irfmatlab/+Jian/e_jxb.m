function [eF] = e_jxb(bF,v,n,alpha)
%Jian.E_JXB Calculates E = jxB/ne. 
%   eF = Jian.E_JXB(bF,v,n) returns electric field given magnetic field bF,
%   plasma bulk velocity v and number density n. Electric field is
%   calculated by: E = jxB/ne.
%   eF = Jian.E_JXB(bF,v,n,alpha) introcuces a scalar constant alpha so
%   that: E = alpha*jxB/ne.
%
%   See also: IRF_JZ, Jian.E_VXB, Jian.TRANSFORM_E_FIELD

if(nargin == 3)
    alpha = 1;
end

u = irf_units; % Get units

current = irf_jz(v,bF); % Calculates current

jSize = size(current);

eF = zeros(jSize);

eF(:,1) = current(:,1);


for i = 1:jSize(1)
    B = bF(i,2:4)/1e9; % B-vector in T
    jz = current(i,2:4); % Current vector in A/m2
    
    % interpolates density for the time point [m-3]
    dens = interp1(n(:,1),n(:,2),bF(i,1))*1e6; 
    
    % calculates electric field E = jXB/ne in [mV/m]
    eF(i,2:4) = alpha*cross(jz,B)/(dens*u.e)*1e3;
end
end