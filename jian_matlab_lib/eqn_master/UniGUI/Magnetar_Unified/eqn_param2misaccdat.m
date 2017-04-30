function mis_access_dat = eqn_param2misaccdat(Params)
%eqn_param2misaccdat Helper function
% 
%   Converts 'Params' struct, as it emerges from the eqn_paramLoader()
%   function, to a 'mis_access_dat' cell matrix, in order for it to be
%   manipulated appropriately by the GUI functions that deal with user
%   defined changes in the input file source (PATH, TEMP & REMOTE params)
%

nMissions = length(Params.Missions);

mis_access_dat = cell(nMissions, 6);

for i=1:nMissions
    mis_access_dat{i,1} = Params.Missions{i};
    mis_access_dat{i,2} = Params.Sources{i,1};
    mis_access_dat{i,3} = Params.Sources{i,2};
    if isempty(Params.Sources{i,3})
        mis_access_dat{i,4} = [];
        mis_access_dat{i,5} = [];
        mis_access_dat{i,6} = [];
    else
        mis_access_dat{i,4} = Params.Sources{i,3}{1};
        mis_access_dat{i,5} = Params.Sources{i,3}{2};
        mis_access_dat{i,6} = Params.Sources{i,3}{3};
    end
end

