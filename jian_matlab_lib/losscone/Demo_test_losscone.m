%% init
addpath('../losscone')
% mkdir('Test_Matlab_Export_fig');
% cd Test_Matlab_Export_fig

%% 2D lat/lon plot of Earth's magnetic field strength at given altitude.
% Also plots direction in quiver plot.
% 给定高度磁场方向和大小  IGRF 模型
BfieldMap;

%% 2D lat/lon plot of Earth's magnetic field strength at given altitude.
%磁场错误 计算loss cone angle时间较长
BfieldTLEerror;
BfieldTLEerror_iter;

%% 对应地理经纬度的磁纬度
%调用 getmaglat
geomaglatitute;

%% testing Jack's calculations for solid angles

JackGF;

%% 对应地理经纬度给定时间高度对应的 L shell
% L-shell for Altitude 100 km: 31-Aug-2012

myLshellmap;


%% Plot the Earth's magnetic field lines using the IGRF.
plotbearth;
plotbline;

%% Loss Cone Pitch Angle 计算需要 8h
% 生成 Output750_02.mat


testlosscone








