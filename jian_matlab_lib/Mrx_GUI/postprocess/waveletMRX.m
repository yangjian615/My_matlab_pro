function out = waveletMRX(f)
% function waveletMRX(f)
%
% calculates the wavelet spectrum for fluctuation data extracted with
% getMRXflucs
% 
% Jan. 2016, Adrian von Stechow

% channels to process
fieldNames = {'Br','By','Bz','Ey','pref','pr','py','pz'};

% channels that need decimation (otherwise cwt takes forever)
decimateVec = [0   0    0    0    1      1    1    1];

decFactor = 50; % factor by which to decimate signal

for i=1:length(fieldNames)
    
    if decimateVec(i)
        % decimate time vector and signal
        out.t2 = decimate(f.time2,decFactor);
        sig = decimate(f.(fieldNames{i}),decFactor);
        % sampling frequency
        fs = 1/(out.t2(2)-out.t2(1))*1e6;
        % do cwt on data
        [out.f2,cwtData,~] = fspec(sig,fs,'wname','cmor1-1.5','fMax',fs/2);
        % cut down by another factor 5 to save space
        out.t2 = out.t2(1:5:end);
        out.(fieldNames{i})= cwtData(:,1:5:end);
    else
        out.t1 = f.time1;
        sig = f.(fieldNames{i});
        fs = 1/(out.t1(2)-out.t1(1))*1e6;
        % do cwt on data
        [out.f1,cwtData,~] = fspec(sig,fs,'wname','cmor1-1.5','fMax',fs/2);
        % cut down by another factor 5 to save space
        out.t1 = out.t1(1:5:end);
        out.(fieldNames{i})= cwtData(:,1:5:end);
    end

end