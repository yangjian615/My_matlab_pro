function out=getScanLpData(scanShots, fcshift)
% out=getScanLpData(scanShots, fcshift)
%
% gets Langmuir probe data for shot vector scanShots and flux core shift
% vector fcshift
% out is a struct containing instantaneous and averaged data as well as
% short time traces
%
% Jan. 2016, Adrian von Stechow

meanWindow = 5; % averaging time window in us
windowInd  = floor(meanWindow/0.4);

conf      = initMRX;
db        = load(conf.dbPath);

n = 0;

for i=1:length(scanShots)
    
    dbShotInd = isUnmarkedShot(scanShots(i)); % check if shot exists
    
    if dbShotInd
        
        % get langmuir probe data
        l    = getMRXlangdata(scanShots(i));
        
        % manually selected time point in shot
        tSelect   = db.tSelect(dbShotInd);
        
        % time index in langmuir probe data
        tInd      = ind_get(l(1).time,tSelect);
        
        disp(['processing shot ' int2str(scanShots(i))])
        
        % step through probe struct and get data around selected time point
        for k=1:4
            n    = n+1;
            out.shot(n)   = scanShots(i);
            
            % density
            out.ne(n)     = l(k).ne(tInd);
            out.neMean(n) = mean(l(k).ne(tInd-windowInd:tInd+windowInd));
            out.neTrace{n}= l(k).ne(tInd-20:tInd+20);
            
            % temperature
            out.Te(n)     = l(k).Te(tInd);
            out.TeMean(n) = mean(l(k).Te(tInd-windowInd:tInd+windowInd));
            out.TeTrace{n}= l(k).Te(tInd-20:tInd+20);
            
            % probe positions
            out.R(n)      = l(k).R;
            out.Y(n)      = l(k).Y;
            % out.Z(n)      = l(k).Z;
            out.Z(n)      = l(k).Z-fcshift(scanShots==scanShots(i))/100; % correct for flux core position
            
            % probe number
            out.probe(n)  = k;
            
            % floating potential
            out.VfMean(n) = (mean(l(k).Vf1(tInd-windowInd:tInd+windowInd))+mean(l(k).Vf2(tInd-windowInd:tInd+windowInd)))/2;
            
            % remove shots with unrealistic temperatures and densities
            if out.Te(n)>30 || out.Te(n) < 2 || out.ne(n) < 0.1
                n=n-1;
            end
            
        end
    end
end