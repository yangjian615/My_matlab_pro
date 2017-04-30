function [data, meta, filelist] = eqn_UniversalSpaceDataLoader(MISSION, ...
    DATE_RANGE, SATELLITE, FILETYPE, FIELD_CHOICE, DATA_SOURCE)
%eqn_UniversalSpaceDataLoader         Data Loader for space missions.
% 
% Check the separate functions for the appropriate documentation
%    eqn_UniversalSpaceDataLoader_Swarm()
%    eqn_UniversalSpaceDataLoader_CHAMP
%

switch lower(MISSION)
    case 'swarm'
        [data, meta, filelist] = eqn_UniversalSpaceDataLoader_Swarm_v2(...
            DATE_RANGE, SATELLITE, FILETYPE, FIELD_CHOICE, DATA_SOURCE);
    case 'champ'
        [data, meta, filelist] = eqn_UniversalSpaceDataLoader_CHAMP(...
            DATE_RANGE, [], FILETYPE, FIELD_CHOICE, DATA_SOURCE);
    case 'st5'
        [data, meta, filelist] = eqn_UniversalSpaceDataLoader_ST5(...
            DATE_RANGE, SATELLITE, [], FIELD_CHOICE, DATA_SOURCE);
    otherwise
        
end

end

