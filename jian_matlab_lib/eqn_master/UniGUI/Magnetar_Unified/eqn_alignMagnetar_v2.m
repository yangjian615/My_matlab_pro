function Magnetar = eqn_alignMagnetar_v2(Magnetar)
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
                % get median time of each track
                mt = nan(length(list),1);
                mt_next = nan(length(list),1);
                for i=1:length(list)
                    ii = list(i);
                    mt(i) = median(Magnetar.B{ii}(...
                        Magnetar.Bind{ii}(1,1):Magnetar.Bind{ii}(1,2), end));
                    mt_next(i) = median(Magnetar.B{ii}(...
                        Magnetar.Bind{ii}(2,1):Magnetar.Bind{ii}(2,2), end));
                end
                
                % find the track that, if replaced with the next, will 
                % yield the lowest possible total time difference between 
                % all track pairs
                dt = nan(length(list),1);
                for i=1:length(list)
                    % read times
                    qq = mt;
                    % replace track i with the next
                    qq(i) = mt_next(i);
                    % create matrix of differences of all pairs
                    dmat = abs(bsxfun(@minus, qq, qq'));
                    % calculate total abs diffs (upper triag. part only)
                    dt(i) = sum(sum(triu(dmat)));
                end
                
                [~, indMin] = min(dt);
                % delete Track that corresponds to the min mt index
                Magnetar.Bind{list(indMin)}(1,:) = [];
                Magnetar.dind{list(indMin)}(1,:) = [];
                Magnetar.Rind{list(indMin)}(1,:) = [];
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

