function f=getMRXflucs(shot)
% f = getMRXflucs(shot)
% 
% load raw fluctuation signal of fluctuation and phase velocity probe.
%
% Jan. 2016, Adrian von Stechow

conf = initMRX;
m = matfile(conf.flucPath);

ind = find(m.shot==shot,1);

if isnan(ind) % shot not available
    f = nan;
    return
end

% fluctuation probe signals

[len,~] = size(m,'Br');
f.Br = m.Br(1:len,ind);
f.By = m.By(1:len,ind);
f.Bz = m.Bz(1:len,ind);
f.Ey = m.FP(1:len,ind);
f.time1 = m.time1+200; % 200: scope delay time in µs

% phase velocity probe signals

[len,~] = size(m,'pref');
f.pref = m.pref(1:len,ind);
f.pr = m.pr(1:len,ind);
f.py = m.py(1:len,ind);
f.pz = m.pz(1:len,ind);
% construct time vector
tmp     = linspace(0,400,len+1)';
f.time2 = tmp(1:len);