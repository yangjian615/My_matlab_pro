c = initMRX;

figure(871)
for i = 3%1:5
    d = load(c.(['highGfFlucDataPath' num2str(i)]));
    plot(d.shot-168000,d.Bz,'o')
    labels(['Bz fluctuation amplitude, scan #' num2str(i)],'shot 168...','amplitude [a.u.]')
    ezpdf(871,['plots/fluctuations/flucAmpVsShots_' num2str(i)])
end