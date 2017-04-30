function [varargout] = hia_plot_velspace(AX,F,varargin)
%Jian.HIA_PLOT_VELSPACE plot CIS-HIA data in velocity space.
%
%   Jian.HIA_PLOT_VELSPACE(AX,F) plots ion data stored in F (matrix
%   of size 8x16x31) in axis AX. The function assumes that all ions are
%   protons and plots in ISR2 coordinate system. F can also be of half
%   energy resolution.
%
%   [hsf,hcb] = Jian.HIA_PLOT_VELSPACE(psdMat,fn) returns axis handle for the
%   pcolor object hsf, and colorbar handle hcb.
%
%   Some rebinning of data is done. The bins are the same as that of
%   CIS-HIA.
%
%   NB. only for XY-plane so far 

%% Input
if nargin == 1
    % 3D ion data
    f3d = AX;
    AX = Jian.afigure;
elseif nargin == 2
    f3d = F;
else
    error('Unknown input')
end


%% Data handling
if size(f3d,3) == 31
    eres = 'full';
elseif size(f3d,3) == 16
    eres = 'half';
else
    error('Unknown matrix size')
end

[th,phi,etab] = Jian.get_hia_values('all',eres);
u = irf_units;
v = sqrt(2*etab*u.e/u.mp)/1000; % Velocity table in km/s.

nTh = length(th);
nPhi = length(phi);
nEn = length(etab);

% 2D matrix to be filled.
f2d = zeros(16,nEn);

% Rebins data
for i = 1:nTh
    % ft is a 2D cut-out of 3D distribution for one theta angle
    ft = squeeze(f3d(i,:,:));
    % new velocity table in xy-plane
    vt = v*cosd(th(i));
    % new indicies for the data
    idv = Jian.fci(vt,v,'ext');
    
    % loops through phi and energy
    for j = 1:nPhi
        for k = 1:nEn
            % adds the data to the f2d matrix. cos(th) is a geometric
            % factor.
            f2d(j,idv(k)) = f2d(j,idv(k))+ft(j,k)*cosd(th(i));
        end
    end
end

% Add one row of zeros, no new data
f2dex = zeros(size(f2d)+[1,0]);
f2dex(1:end-1,:) = f2d;


nPhi = length(phi);
% Adds phiP(17) = phi(1). The term 11.25 degres is to rotate the circle.
phiP = interp1([phi,phi(1)],linspace(1,17,nPhi+1))+11.25;
phiRad = phiP*pi/180;

[PHI,R] = meshgrid(phiRad,v); % Creates the mesh
[X,Y] = pol2cart(PHI,R);    % Converts to cartesian


%% Plotting
hsf = pcolor(AX,X,Y,log10(f2dex'));
hsf.EdgeColor = 'none';

% Adds colorbar
hcb = colorbar;
Jian.label(hcb,'$\log{F}$ [s$^3$km$^{-6}$]')

% Reverses the direction of the x-axis. The Sun is to the left!
AX.XDir = 'reverse';

Jian.label(AX,'x','$v_{x}$ [kms$^{-1}$]')
Jian.label(AX,'y','$v_{y}$ [kms$^{-1}$]')

axis equal


%% Output
if nargout == 1
    varargout{1} = hsf;
elseif nargout == 2
    varargout{1} = hsf;
    varargout{2} = hcb;
end

end