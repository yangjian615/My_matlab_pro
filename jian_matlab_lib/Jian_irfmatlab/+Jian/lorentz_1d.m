function [vel, xMin, Y] = lorentz_1d(eF,bF,v0,runTime,x0)%,dT,nSlams)
%Jian.LORENTZ_1D performs a 1D test patrticle simulation
%   Jian.LORENTZ_1D(eF,bF,v0,runTime) runs a 1D simulation for a particle
%   with initial velocity v0 in fields eF and bF. The simulation ends after
%   runTime.
%   vel = Jian.LORENTZ_1D(eF,bF,v0,runTime) returns the velocity in a
%   matrix with time data, vel = [t,vx,vy,vz].
%   [vel,xMin] = Jian.LORENTZ_1D(eF,bF,v0,runTime) also returns the lowest
%   value for the particle position acheived during the simulation.
%   [vel,xMin,Y] = Jian.LORENTZ_1D(eF,bF,v0,runTime) also returns the full
%   simulation matrix Y = [x,y,z,vx,vy,vz].

if(nargin==4)
    x0 = -1e9;
end

set_global_E_B(eF,bF);

tSpan = [0, runTime];

xib = max(bF(:,1)); %initial position
xie = max(eF(:,1));

%Get initial position
if xib<xie
    x = xib;
else
    x = xie;
end

if(x0 > -1e8)
    x = x0;
end

y0 = [x,0,0,v0];

% ode45 for accuracy and performance
[T,Y] = ode45(@lorentz_force,tSpan,y0);

vel = [T,Y(:,4),Y(:,5),Y(:,6)];
xMin = min(Y(:,1));

end


function [dy] = lorentz_force(t,y)
%LORENTZ_FORCE Lorem
%   y = [x, y, z, vx, vy, vz]
q = 1.602e-19;
m = 1.67e-27;

eF = get_E_field(y(1));
[bF,inBounds] = get_B_field(y(1));
F = q*(eF+cross([y(4),y(5),y(6)],bF));

dy = zeros(6,1);

if(inBounds) %Sets velocities to NaN if out of box
    dy(1) = y(4);
    % dy(2) = y(5);
    % dy(3) = y(6);
    
    dy(4) = F(1)/m;
    dy(5) = F(2)/m;
    dy(6) = F(3)/m;
else
    dy(1) = 0;
    % dy(2) = y(5);
    % dy(3) = y(6);
    
    dy(4) = NaN;
    dy(5) = NaN;
    dy(6) = NaN;
end

end


function [interpE] = get_E_field(x) 

global eField
if(x<min(eField(:,1)) || x>max(eField(:,1)))
    interpE = zeros(1,3);
    %disp('Out of simulation!')
else
    interpE = interp1(eField(:,1),eField(:,2:4),x)/1e3;
    interpE(isnan(interpE)) = 0;
end

end

function [interpB,inBox] = get_B_field(x)

global bField
if(x<min(bField(:,1)) || x>max(bField(:,1)))
    interpB = zeros(1,3);
    inBox = false;
    %disp('Out of simulation!')
else
    interpB = interp1(bField(:,1),bField(:,2:4),x)/1e9;
    inBox = true;
end
end

function set_global_E_B(eF,bF)

global eField
global bField

eField = eF;
bField = bF;
end

