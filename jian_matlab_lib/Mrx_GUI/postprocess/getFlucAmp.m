function out=getFlucAmp(scanShots,fLow,fHigh,tWindow)
% out=getFlucAmp(scanShots)
%
% get fluctuation amplitudes for an array of shots given by scanShots
%
% Jan. 2016, Adrian von Stechow

conf      = initMRX;
db        = load(conf.dbPath);

if nargin==1
    % frequency limits
    fLow      = 5e5;
    fHigh     = 1e7;
end

if nargin < 4
    % time window in us
    tWindow   = 5;
end

n = 0;

out.fLow    = fLow;
out.fHigh   = fHigh;
out.tWindow = tWindow; 

for i=1:length(scanShots)
    m = loadMRXshot(scanShots(i),conf);
    
    if isobject(m)
        
        % index of selected shot in DB
        dbShotInd = find(db.shot==scanShots(i));
        % OLD METHOD
        % manually selected time point in shot
%         tSelect   = db.tSelect(dbShotInd);
        % NEW METHOD
        %manually chosen time point where fluctuations maximize
        tSelect = db.tSelectFP(dbShotInd);
        
        if ~db.marked(dbShotInd) % discard marked shots
            disp(['processing shot ' int2str(scanShots(i))])
            n = n+1;
            % load wavelet data
            w    = getMRXwavelet(scanShots(i));
            
            % time indices
            t1lo      = ind_get(w.t1,tSelect - tWindow/2);
            t1hi      = ind_get(w.t1,tSelect + tWindow/2);
%             t2lo      = ind_get(w.t2,tSelect - tWindow/2);
%             t2hi      = ind_get(w.t2,tSelect + tWindow/2);

            % indices of freqency limits
            f1lo  = ind_get(w.f1,fLow);
            f1hi  = ind_get(w.f1,fHigh);
%             f2lo  = ind_get(w.f2,fLow);
%             f2hi  = ind_get(w.f2,fHigh);
            
            % step through struct and get data around time point
            out.shot(n)   = scanShots(i);
            out.Br(n)     = mean(sum(abs(w.Br(f1lo:f1hi,t1lo:t1hi))));
            out.By(n)     = mean(sum(abs(w.By(f1lo:f1hi,t1lo:t1hi))));
            out.Bz(n)     = mean(sum(abs(w.Bz(f1lo:f1hi,t1lo:t1hi))));
            out.Ey(n)     = mean(sum(abs(w.Ey(f1lo:f1hi,t1lo:t1hi))));
%             out.specR{n}  = 1;
            
%             out.pref(n)   = mean(sum(abs(w.pref(f2lo:f2hi,t2lo:t2hi))));
%             out.pr(n)     = mean(sum(abs(w.pr(f2lo:f2hi,t2lo:t2hi))));
%             out.py(n)     = mean(sum(abs(w.py(f2lo:f2hi,t2lo:t2hi))));
%             out.pz(n)     = mean(sum(abs(w.pz(f2lo:f2hi,t2lo:t2hi))));

        end
    end
end