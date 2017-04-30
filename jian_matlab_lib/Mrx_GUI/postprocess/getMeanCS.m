function out = getMeanCS(shots)
% out = getMeanCS(shots)
%
% step through shots and get mean current density
%
% Jan. 2016, Adrian von Stechow

conf      = initMRX;
db        = load(conf.dbPath);

n = 0;

out.Jz = 0;
out.Jx = 0;
out.Jy = 0;
out.Flux = 0;

for i=1:length(shots)
    m = loadMRXshot(shots(i),conf);
    if isobject(m)
        
        % index in DB of selected shot
        dbShotInd = ind_get(db.shot,shots(i));
        % manually selected time point in shot
        tSelect   = db.tSelect(dbShotInd);
        % time index in langmuir probe data
        tInd      = ind_get(m.time,tSelect);
        
        if ~db.marked(dbShotInd)
            n = n+1;
            disp(['processing shot ' int2str(shots(i))])
            % step through probe struct and get data around time point
            d = m.Interp_Data_YA;
            d = d(1);
            out.Jz = ( (n-1)*out.Jz + d.Jz(:,:,tInd) ) / n;
            out.Jx = ( (n-1)*out.Jx + d.Jx(:,:,tInd) ) / n;
            out.Jy = ( (n-1)*out.Jy + d.Jy(:,:,tInd) ) / n;
            out.Flux = ( (n-1)*out.Flux + d.Flux(:,:,tInd) ) / n;
        end
    end
end