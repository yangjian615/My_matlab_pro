% testing Jack's calculations for solid angles

clear all; close all;

% angles to vary (LES and LC)

THles = (30:0.5:60) * pi/180;
THlc = [54 55 56 57 60 65 70 75] * pi/180;
colors = [{'r'},{'b'},{'c'},{'k'},{'b'},{'g'},{'y'},{'m'}];

% parameters

det_diam = 2.393; % cm
h = 0.705; % cm
shell_angle = 10*pi/180;

% initialize arrays

GF = zeros(length(THles),length(THlc));     % geometric factor (goal)
Oratio = GF;    % ratio of solid angles
Osmile = GF;    % solid angle of 'smile'
ap = GF;        % aperture area
arad = GF;      % aperture radius

for m = 1:length(THlc),
    
    lca = THlc(m);
    core = lca - shell_angle;
    Ocore = 2*pi*(1 - cos(core));
    Olca = 2*pi*(1 - cos(lca));
    
    for n = 1:length(THles),
        
        les = THles(n);
        Oles = 2*pi*(1 - cos(les));
        
        if les >= lca,
            
            Osmile(m,n) = Olca - Ocore;
        
        elseif les < 0.5*(lca + core),
            
            % case 1
            
            alpha = lca - les;
            
            g1 = atan((cos(les) - cos(alpha)*cos(core)) / (sin(alpha)*cos(core)));
            b1 = acos(sin(g1)/sin(core));
            p1 = acos(tan(g1)/tan(core));
            O1 = 2*(b1 - p1 * cos(core));
            
            g2 = atan((cos(core) - cos(alpha)*cos(les)) / (sin(alpha)*cos(les)));
            b2 = acos(sin(g2)/sin(les));
            p2 = acos(tan(g2)/tan(les));
            O2 = 2*(b2 - p2 * cos(les));
            
            Osmile(m,n) = Oles - (O1 + O2);
            
        else
            % case 2
            
            Osmile(m,n) = Oles - Ocore;
            
        end
        
        arad(m,n) = 0.5 * (det_diam - 2*h*tan(les));    % in cm
        ap(m,n) = pi*arad(m,n)^2;
        
        % DID JACK USE ARAD INSTEAD OF AP?
        % TEST:
        %ap(m,n) = 2*arad(m,n);        % now looks more like Jack's
            
        GF(m,n) = ap(m,n) * Osmile(m,n);
        Oratio(m,n) = Oles / Olca;
        
    end
    
end

%% plotting


h1 = figure(1);
set(h1,'position',[100 100 1200 800]);
ax1 = subplot(221);
ax2 = subplot(222);
ax3 = subplot(223);
ax4 = subplot(224);

for m = 1:length(THlc),
    
    plot(ax1,THles*180/pi,Osmile(m,:),colors{m});
    hold(ax1,'on');
    
    plot(ax2,THles*180/pi,arad(m,:)*2,colors{m});
    hold(ax2,'on');
    
    plot(ax3,THles*180/pi,GF(m,:),colors{m});
    hold(ax3,'on');
    
    plot(ax4,THles*180/pi,Oratio(m,:),colors{m});
    hold(ax4,'on');
    
end

legend(ax1,num2str(THlc'*180/pi),'location','NorthWest');
xlabel(ax1,'LES acceptance angle (deg)');
ylabel(ax1,'Solid angle of smile (str)');
title(ax1,'[Legend refers to loss cone angle (deg)]');
title(ax2,'Diameter of aperture (Figure 4)');
xlabel(ax2,'LES acceptance angle (deg)');
ylabel(ax2,'Aperture  diameter (cm)');
title(ax3,'Geometric Factor (Figure 10)');
xlabel(ax3,'LES acceptance angle (deg)');
ylabel(ax3,'Geometric factor (cm2-str)');
title(ax4,'Ratio of solid angles (Figure 2)');
xlabel(ax4,'LES acceptance angle (deg)');
ylabel(ax4,'Ratio \Omega_{les}:\Omega_{LC}');
set(ax4,'ylim',[0 1]);
set(ax2,'ylim',[0 2]);
set([ax1 ax2 ax3 ax4],'xlim',[30 60]);

