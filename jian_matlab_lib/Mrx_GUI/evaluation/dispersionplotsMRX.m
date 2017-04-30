%% initialization

scanShots = 169049:169098;  % shot list - constant high guide field 
conf      = initMRX;
db        = load(conf.dbPath); % load shot db
tWindow   = 5;              % time window for cross-phase in µs

dx        = 1.5e-3;  % probe separation
maxk      = pi./dx; % maximum detectable k

n = 0;

%% load data

for i=1:length(scanShots)

    dbShotInd = isUnmarkedShot(scanShots(i)); % check if data has been processed
    
    if dbShotInd % is 0 if shot 
        
        % index of selected shot in DB
        dbShotInd = find(db.shot==scanShots(i));
        
        % manually chosen time point where fluctuations
        % maximize
        tSelect = db.tSelectPV(dbShotInd);
        
        if tSelect == 0
            
            disp(['skipping shot ' int2str(scanShots(i)) ', tSelect=0!'])
            
        else
            
            disp(['processing shot ' int2str(scanShots(i))])
            n = n+1;
            
            % load fluctuation data
            f    = getMRXflucs(scanShots(i));
            
            % time indices
            t1lo      = ind_get(f.time2,tSelect - tWindow/2);
            t1hi      = ind_get(f.time2,tSelect + tWindow/2);
            
            % step through struct and get data around time point
            data.shot(n)   = scanShots(i);
            data.pref(n,:) = f.pref(t1lo:t1hi);
            data.pr(n,:)   = f.pr(t1lo:t1hi);
            data.py(n,:)   = f.py(t1lo:t1hi);
            data.pz(n,:)   = f.pz(t1lo:t1hi);
            
        end
        
    end
end

%% TODO here

%% do dispersion calculation

% subtract mean fluctuations
data1   = (data.pref-repmat(mean(data.pref,2),1,size(data.pref,2)))';
% data1   = (data.pr-repmat(mean(data.pr,2),1,size(data.pr,2)))';
% data1   = -(data.py-repmat(mean(data.py,2),1,size(data.py,2)))';
data2   = (data.pz-repmat(mean(data.pz,2),1,size(data.pz,2)))';

% do dispersion calculation
[S,Snorm,fOut,k]=dispersion(data1,data2,5e9,maxk/1.5,41,dx,0,1e5,20e6);

%% plot data

smoothData  = csp(S,0.95);
[~,maxmarkers] = max(smoothData,[],2);
kmax        = k(maxmarkers);
flh         = f_lh(3e19,19e-3,4,1);
% fPlot       = fOut./flh;
fPlot = fOut;

% s           = 2:41;
% linfit      = ezfit(kmax(s),fPlot(s),{'a*x',{'x'},{'a'}});

for i=1:size(S,1) % step through frequencies
    
    meank(i)  = sum(dot(k,S(i,:)))/sum(S(i,:));
    devs      = k-meank(i);
    stdDev(i) = sqrt(sum(dot(devs.^2,S(i,:))))/sum(S(i,:));
    
end

% frequencies from velocity fit
% fv{1} = k.*vd/2/pi/flh;
% fv{2} = k.*1.4e5/2/pi/flh; %from linear fit up to f_lh

figure(666)
clf

contourf(k,fPlot/1e6,smoothData,20,'linecolor','none')
hold on
plot(meank,fOut/1e6,'.k')
% errorbarxy(meank,fOut/flh,stdDev/2,stdDev/2,zeros(size(stdDev)),zeros(size(stdDev)),'.k')

% ylim([0 5e6])
colormap pastellhalf
hold on

% plot(kmax(1:end-3)*rhohybrid,fPlot(1:end-3),'.k')
% plot(k{j}*rhohybrid,fv{1},'k')
% p2=plot(k{j}*rhohybrid,fv{2},'k--');
vline(0)
hline(flh/1e6)

% labels('','k_r [m^{-1}]','f [MHz]')
% labels('','k_y [m^{-1}]','f [MHz]')
labels('','k_z [m^{-1}]','f [MHz]')

ezpdf15(666,'plots/fluctuations/dispersion_z','f',1)
dockfigs(666)
% if type=='T'
%     text(200,0.6,'v_d')
%     text(180,2.5,'fit')
%     ezpdfw(666,'flucs/dispersion-5mm')
% else
%     delete(p2)
%     text(200,0.5,'v_d')
%     ezpdfw(666,'flucs/dispersion-5mm-x')
% end

%% plot whistler wave

figure(445)
clf
contourf(k{j}*rhohybrid,fPlot/1e6,smoothData,20,'linecolor','none')
hold on
% whistler dispersion relation
n = 1e19;
B = 15e-3;
m = 40;

colormap pastellhalf

f = (1:5e2)*1e4;
kwhis = 2*pi./disp_whistler(f,n,B);
plot(kwhis,f/flh,'k')

ka = 2*pi*f/v_alfven(B,n,m);
plot(ka,f/flh,'k')

ks = 2*pi*f/v_ionsound(10);
plot(ks,f/flh,'k')

vline(0)
hline(1,'--k')
xlim([-250 250])
ylim([0 3])

text(70,2,'Whistler')

text(150,0.5,'Alfvèn')

text(150,0.18,'Ion sound')

% text(150,1.1,'Alfvèn')

labels('','k_z [m^{-1}]','f/f_{lh}')

ezpdfw(445,'flucs/dispersion_whistler')