function out = getXpoint(d,timePoints)
% out = getXpoint(data,timePoints)
%
% extract X-point position, electric field and flux
%
% Jan. 2016, Adrian von Stechow

m = d.Interp_Data_YA(1);

% indices of chosen time points
tInd = ind_get(d.time,timePoints);

% already available data
out.x    = m.Poloidal_Nulls.x(1,tInd);
out.z    = m.Poloidal_Nulls.z(1,tInd);
out.EPhi = m.Poloidal_Nulls.Ephi(1,tInd);
out.Flux = m.Poloidal_Nulls.Flux(1,tInd);

% get indices of positions
xInd = ind_get(m.x,out.x);
zInd = ind_get(m.z,out.z);

for i=1:length(tInd)
    if ~isnan(out.x(i))
        xi = xInd(i);
        zi = zInd(i);
        ti = tInd(i);
        out.Bx(i) = m.Bx(xi,zi,ti);
        out.By(i) = m.By(xi,zi,ti);
        out.Bz(i) = m.Bz(xi,zi,ti);
        out.Jy(i) = m.Jy(xi,zi,ti);
    else
        out.Bx(i) = NaN;
        out.By(i) = NaN;
        out.Bz(i) = NaN;
        out.Jy(i) = NaN;
    end
end