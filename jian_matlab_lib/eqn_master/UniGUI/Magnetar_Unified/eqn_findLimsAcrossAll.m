function lims = eqn_findLimsAcrossAll(Magnetar)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
nColumns = length(Magnetar.B);

lims = nan(1, 2);
i=1;

x = Magnetar.B{1,1}(:, 1);
x = x(~isnan(x));
lims(i,1) = min(x);
lims(i,2) = max(x);

for j=2:nColumns
    xj = Magnetar.B{j,1}(:, 1);
    xj = xj(~isnan(xj));

    mn = min(xj);
    if mn < lims(i,1); lims(i,1) = mn; end

    mx = max(xj);
    if mx > lims(i,2); lims(i,2) = mx; end
end

end

