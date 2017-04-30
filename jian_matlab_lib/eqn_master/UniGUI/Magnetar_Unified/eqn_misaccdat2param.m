function Params = eqn_misaccdat2param(mis_access_dat)
%eqn_misaccdat2param Helper function
% 
%   Converts 'mis_access_dat' cell array to a Params structure, like the
%   one that is produced as the output of the eqn_paramLoader() function.
%

nMissions = size(mis_access_dat, 1);

Params.Missions = cell(nMissions, 1);
Params.Sources = cell(nMissions, 3);

for i=1:nMissions
    Params.Missions{i} = mis_access_dat{i,1};
    for j=1:2
        Params.Sources{i,j} = mis_access_dat{i,j+1};
        if isempty(Params.Sources{i,j})
            Params.Sources{i,j} = [];
        end
    end
    
    if isempty(mis_access_dat{i,4}) && isempty(mis_access_dat{i,5}) && ...
            isempty(mis_access_dat{i,6})
        Params.Sources{i,3} = [];
    else
        Params.Sources{i,3} = cell(1,3);
        Params.Sources{i,3}{1} = mis_access_dat{i,4};
        Params.Sources{i,3}{2} = mis_access_dat{i,5};
        Params.Sources{i,3}{3} = mis_access_dat{i,6};
    end
end

