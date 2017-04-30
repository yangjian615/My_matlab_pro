shots = 167242:167270;
range = 300:350;

for i= 1:length(shots)

d = loadMRXshot(shots(i),initMRX);
x = getXpoint(d,range);
p = d.Interp_Data_YA;

dI(:,i)   = gradient(smooth(p(1).I_2D(range)));
EPhi(:,i) = x.EPhi;
smoothEPhi(:,i) = smooth(x.EPhi);
end

%%
% plot(x.EPhi(300:350))
plot(dI,(EPhi),'.')