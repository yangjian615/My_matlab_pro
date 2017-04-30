function lims = eqn_findLimsAcrossTracks(Magnetar)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
nColumns = length(Magnetar.B);
no_of_tracks = size(Magnetar.Bind{1,1}, 1);
for i=2:nColumns
    no_of_tracks = min([no_of_tracks, size(Magnetar.Bind{i,1}, 1)]);
end

lims = nan(no_of_tracks, 2);

for i=1:no_of_tracks
    x = Magnetar.B{1,1}(Magnetar.Bind{1,1}(i,1) : Magnetar.Bind{1,1}(i,2), 1);
    x = x(~isnan(x));
    lims(i,1) = min(x);
    lims(i,2) = max(x);
    
    for j=2:nColumns
        xj = Magnetar.B{j,1}(Magnetar.Bind{j,1}(i,1) : Magnetar.Bind{j,1}(i,2), 1);
        xj = xj(~isnan(xj));
        
        mn = min(xj);
        if mn < lims(i,1); lims(i,1) = mn; end
        
        mx = max(xj);
        if mx > lims(i,2); lims(i,2) = mx; end
    end
end

end

