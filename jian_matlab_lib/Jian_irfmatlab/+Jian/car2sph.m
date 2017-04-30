function [rSph] = car2sph(rCar)
%Jian.CAR2SPH Transforms coordinates from cartesian to spherical
%   rSph = car2sph(rCar). rSph = [r, theta, phi], theta is polar angle
%   in [0,180] and phi is the azimuthal angle in [0,360].
%
%   See also Jian.SPH2CAR Jian.GSE2NMR

r = sqrt(sum(rCar.^2));
phi = 0;
    if    (rCar(1)>=0 && rCar(2)>=0)
        phi = atan(abs(rCar(2)/rCar(1)));
    elseif(rCar(1)<0 && rCar(2)>=0)
        phi = pi-atan(abs(rCar(2)/rCar(1)));
    elseif(rCar(1)<0 && rCar(2)<0)
        phi = atan(abs(rCar(2)/rCar(1)))+pi;
    elseif(rCar(1)>=0 && rCar(2)<0)
        phi = 2*pi-atan(abs(rCar(2)/rCar(1)));
    end
    
    if(isnan(phi))
        phi = 0;
    end

rSph = [r, acosd(rCar(3)/r), phi*180/pi];

end