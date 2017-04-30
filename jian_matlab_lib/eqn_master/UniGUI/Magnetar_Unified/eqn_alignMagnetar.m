function Magnetar = eqn_alignMagnetar(Magnetar)
%eqn_alignMagnetar  Makes sure all tracks are ascending/descending at the
%same times
% 
%   Check if the track direction (ascending or descending) is the same. If
%   not, remove the first track and check again. Continue doing so, until
%   all tracks correspond to the same direction.
%

if ~isempty(Magnetar.B)
    n = length(Magnetar.B);
    
    if n > 1
        % if some data files were not found the track indices might be all
        % equal to [1, length(B)]. In this case, ignore these from the process,
        % namely remove them from the "list" vector
        list = (1:1:n)';
        indsToRem = [];
        j = 1;
        for i=1:length(list)
            if Magnetar.Rind{i}(1,1) == 1 && Magnetar.Rind{i}(1,2) == size(Magnetar.R{i}, 1)
                % empty: Remove from list
                indsToRem(j) = i; %#ok<AGROW>
                j = j + 1;
            end
        end
        if ~isempty(indsToRem)
            list(indsToRem) = [];
        end
    end
    
    if length(list) > 1
        alignmentOK = 0;
        nChanges = 0;
        initMagnetar = Magnetar;
        while ~alignmentOK && nChanges <= n-1
            % get each pass' direction (+1 for asc., -1 for desc., 0 for no data)
            passDir = zeros(n,1);
            for i=1:length(list)
                ii = list(i);
                lat = Magnetar.R{ii}(Magnetar.Rind{ii}(1,1):Magnetar.Rind{ii}(1,2),1);
                lat = lat(~isnan(lat));
                if ~isempty(lat)
                    if mean(diff(lat)) > 0
                        passDir(ii) = 1;
                    elseif mean(diff(lat)) < 0
                        passDir(ii) = -1;
                    end
                end
            end

            if all(passDir >= 0) || all(passDir <= 0)
                alignmentOK = 1;
            else
                % get duration of each track % erase the shortest
                duration = nan(length(list),1);
                for i=1:length(list)
                    ii = list(i);
                    duration(i) = Magnetar.B{ii}(Magnetar.Bind{ii}(1,2), end) - ...
                        Magnetar.B{ii}(Magnetar.Bind{ii}(1,1), end);
                end
                
                [~, indMinDuration] = min(duration);
                % delete Track that corresponds to the min duration index
                Magnetar.Bind{list(indMinDuration)}(1,:) = [];
                Magnetar.dind{list(indMinDuration)}(1,:) = [];
                Magnetar.Rind{list(indMinDuration)}(1,:) = [];
                nChanges = nChanges + 1;
            end
        end
        
        if nChanges > n-1
            Magnetar = initMagnetar;
        end
    end
end

% The final structure might end with different number of tracks for each
% panel, but that is OK because the Plotter will then plot only the first N
% ones that they have in common!

end

