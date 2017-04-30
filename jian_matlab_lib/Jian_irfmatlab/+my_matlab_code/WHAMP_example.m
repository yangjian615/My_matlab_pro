% whamp whistler dispersion relation
clear
clc
%%
bmag=150;%nT
n=6;%1/cm^3
Te=1000;%keV parallel T
Ti=1000;%keV
fci=0.0153*bmag;
fce=28*bmag;

%%
s1 = struct('m',0,'n',n,'t',Te,'a',4.0,'vd',0,'d',1,'b',0);
s2 = struct('m',1,'n',n,'t',Ti,'a',1.0,'vd',0,'d',1,'b',0);
PlasmaModel = struct('B',bmag);
PlasmaModel.Species = {s1,s2};

InputParameters.fstart =0.3;
InputParameters.kpar  = [0.22 0.01 0.5];
InputParameters.kperp  = [0 0.01 0.5];
InputParameters.varyKzFirst =1;
InputParameters.useLog =0;
InputParameters.maxIterations =100;
Output = whamp.run(PlasmaModel,InputParameters);
flag1=double(Output.flagSolutionFound);
flag2=double(Output.flagNoConvergence);
f=real(Output.f).*flag1;
gamma=imag(Output.f).*flag1;
[p_x,p_y]=meshgrid(Output.kpar,Output.kperp);
subplot(2,1,2)
pcolor(p_x,p_y,f')
xlabel({'k_{||}'},'Interpreter','tex');
ylabel({'k_{กอ}'},'Interpreter','tex');

shading flat
colorbar
colormap('jet')
subplot(2,1,1)
pcolor(p_x,p_y,gamma')
xlabel({'k_{||}'},'Interpreter','tex');
ylabel({'k_{กอ}'},'Interpreter','tex');
shading flat
colorbar
colormap('jet')

