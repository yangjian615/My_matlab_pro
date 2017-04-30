function [phi] = sc_azimuth(nu,vsw,vr)
%Jian.SC_AZIMUTH Transforms plasma azimuthal angle to s/c azimuthal angle.
%   
%   phi = Jian.SC_AZIMUTH(nu,vsw,vr) Returns s/c azimuth phi given plasma
%   azimuth nu, solar wind speed vsw and reflected speed vr.

N = length(nu);
phi = zeros(1,N);
for i = 1:N
vy = (vsw+vr)*sind(nu(i));
vx = (vsw+vr)*cosd(nu(i))-vsw;

rSph = Jian.car2sph([vx,vy,0]);


phi(i) = rSph(3);
end

end

