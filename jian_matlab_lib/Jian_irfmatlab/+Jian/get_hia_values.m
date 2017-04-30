function [x1,x2,x3] = get_hia_values(varargin)
%Jian.GET_HIA_VALUES Returns instrument parameters for HIA
%   
%   [x1,x2,x3] = Jian.GET_HIA_VALUES(value,resolution) returns some
%   parameters as given by the CIS-HIA team.
%   
%   value:
%       'all'   - returns all parameters [th,phi,etab], default.
%       'theta' - returns polar angle in degrees.
%       'phi'   - returns azimuthal angle in degrees.
%       'etab'  - returns energy values in eV.
%
%   resolution:
%       'full'  - returns energy with half resolution, default.
%       'half'  - returns energy with half resolution.

pvel = {'all','theta','phi','etab'};
pres = {'full','half'};

[value,res] = Jian.incheck(varargin,pvel,pres);

switch value
    case pvel{1}
        x1 = get_theta();
        x2 = get_phi();
        x3 = get_e_tab(res);
    case pvel{2}
        x1 = get_theta();
    case pvel{3}
        x1 = get_phi();
    case pvel{4}
        x1 = get_e_tab(res);
end



end

function th = get_theta()
    th = [-78.750, -56.250, -33.750, -11.250, 11.250, 33.750,...
        56.250,78.750];
    %th = 90-th;

end

function phi = get_phi()
    phi = [134.583 112.083 89.583 67.083 44.583 22.083 -0.417 -22.917...
        -45.417 -67.917 -90.417 -112.917 -135.417 -157.917 179.583 ...
        157.083];

%     for i = 1:length(phi)
%         if(phi(i)<0)
%             phi(i) = 360+phi(i);
%         end
%     end
end

function eTab = get_e_tab(res)
    e0 = [28898.33 21728.22 16337.12 12283.63 9235.88 6944.32 ...
        5221.33 3925.84 2951.78 2219.40 1668.73 1254.69 943.39 ...
        709.32 533.32 401.00 301.50 226.70 170.45 128.16 96.36 ...
        72.45 54.48 40.96 30.80 23.16 17.41 13.09 9.84 7.40 5.56];
    if strcmp(res,'full')
        eTab = e0;
    elseif strcmp(res,'half')
        % Hack so that it is not necessary to define half energy twice.
        f0 = zeros(1,1,31);
        [~,eTab] = Jian.hia_recalc_psd(f0,e0); 
    else
        error('Undefined energy resolution.')
    end
end
