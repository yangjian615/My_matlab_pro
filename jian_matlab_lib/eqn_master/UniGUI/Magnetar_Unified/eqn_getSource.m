function sourceCell = eqn_getSource(Params, MissionName)
%eqn_getSourceFor Reads 'Params' struct, as is created by the
%eqn_paramLoader() and gives the source-related cell that corresponds to
%'MissionName' mission.
%
% Params: Struct that is the output of the eqn_paramLoader() function
% MissionName: String with the name of the mission i.e. 'CHAMP', 'SWARM'
%

ind = find(strcmpi(Params.Missions, MissionName));
if ~isempty(ind)
    sourceCell = Params.Sources(ind,:);
else
    sourceCell = [];
    disp('eqn_getSource: ERROR! Unknown Mission Name!');
end

end

