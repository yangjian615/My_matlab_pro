function [rCar] = sph2car(rSph)
%Jian.SPH2CAR Transforms coordinates from spherical to cartesian
%   rCar = Jian.SPH2CAR(rSph). rSph = [r, theta, phi], theta is polar angle
%   in [0,180] and phi is azimuthal angle in [0,360].
rCar = [rSph(1)*sind(rSph(2))*cosd(rSph(3)),...
    rSph(1)*sind(rSph(2))*sind(rSph(3)),...
    rSph(1)*cosd(rSph(2))];

end