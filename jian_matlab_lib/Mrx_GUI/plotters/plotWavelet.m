function plotWavelet(w,chan)
% plotWavelet(w,chan)
%
% plot the wavelet data for wavelet struct w
% chan: 'Br','By','Bz','Ey','pref','pr','py','pz' 
%
% Jan. 2016, Adrian von Stechow

data = abs(w.(chan));

if any(strcmp(chan,{'Br','By','Bz','Ey'}))
    t=w.t1;
    f=w.f1;
elseif any(strcmp(chan,{'pref','pr','py','pz'}))
    t=w.t2;
    f=w.f2;
end

subplot(4,4,[5 6 7 9 10 11 13 14 15])
imagesc(t,f,data)
axis xy
labels('','t [µs]','f [Hz]')

subplot(4,4,[1 2 3])
plot(t,smooth(sum(data),20))

subplot(4,4,[8 12 16])
semilogx(sum(data,2),f)