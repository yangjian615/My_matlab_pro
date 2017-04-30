%% initialize

c = initMRX;

%% SCAN #2 %%

%% get shot list for scan

[scanShots,pos,fcshift] = shotListHighGFScan_2;

%% get langmuir probe data

out = getHighGfShotLpData(scanShots, fcshift);
save('Y:\mrxdata\highGfLpData_2','-struct','out')

%% get fluctuation data

out = getHighGfShotFlucData(scanShots);
save('Y:\mrxdata\highGfFlucData_2','-struct','out')

%% plot ne, Te and fluctuation profiles

evalHighGfLpScan(c.highGfLangDataPath2,2)

%% get mean CS

shots = scanShots(fcshift==0);
out   = getMeanCS(shots);
save('Y:\mrxdata\CSData_2_1','-struct','out')

shots = scanShots(fcshift==-3);
out   = getMeanCS(shots);
save('Y:\mrxdata\CSData_2_2','-struct','out')

%% SCAN #3 %%

%% get shot list for scan

[scanShots,pos,fcshift] = shotListHighGFScan_3;

%% get langmuir probe data

out = getHighGfShotLpData(scanShots, fcshift);
save('Y:\mrxdata\highGfLpData_3','-struct','out')

%% get fluctuation data

out = getHighGfShotFlucData(scanShots);
save('Y:\mrxdata\highGfFlucData_3','-struct','out')

%% plot ne, Te and fluctuation profiles

evalHighGfLpScan(c.highGfLangDataPath3,3)

%% get mean CS

shots = scanShots(fcshift==0);
out   = getMeanCS(shots);
save('Y:\mrxdata\CSData_3_1','-struct','out')

shots = scanShots(fcshift==+3);
out   = getMeanCS(shots);
save('Y:\mrxdata\CSData_3_2','-struct','out')

%% SCAN #4 %%

%% get shot list for scan

[scanShots,pos,fcshift] = shotListHighGFScan_4;

%% get langmuir probe data

out = getHighGfShotLpData(scanShots, fcshift);
save('Y:\mrxdata\highGfLpData_4','-struct','out')

%% get fluctuation data

out = getHighGfShotFlucData(scanShots);
save('Y:\mrxdata\highGfFlucData_4','-struct','out')

%% plot ne, Te and fluctuation profiles

evalHighGfLpScan(c.highGfLangDataPath4,4)

%% get mean CS

shots = scanShots(fcshift==0);
out   = getMeanCS(shots);
save('Y:\mrxdata\CSData_4_1','-struct','out')

shots = scanShots(fcshift==+3);
out   = getMeanCS(shots);
save('Y:\mrxdata\CSData_4_2','-struct','out')

%% SCAN #5 %%

%% get shot list for scan

[scanShots,pos,fcshift] = shotListHighGFScan_5;

%% get langmuir probe data

out = getHighGfShotLpData(scanShots, fcshift);
save('Y:\mrxdata\highGfLpData_5','-struct','out')

%% get fluctuation data

out = getHighGfShotFlucData(scanShots);
save('Y:\mrxdata\highGfFlucData_5','-struct','out')

%% plot ne, Te and fluctuation profiles

evalHighGfLpScan(c.highGfLangDataPath5,5)

%% get mean CS

shots = scanShots(fcshift==0);
out   = getMeanCS(shots);
save('Y:\mrxdata\CSData_5_1','-struct','out')

shots = scanShots(fcshift==+3);
out   = getMeanCS(shots);
save('Y:\mrxdata\CSData_5_2','-struct','out')

%% SCAN #8 %% high pressure, 150 GF, fixed position

scanShots = 169049:169098;