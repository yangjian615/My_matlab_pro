file='/Users/yangjian/Desktop/c1 data/WBD/C1_CE_WBD_WAVEFORM_CDF/C1_CE_WBD_DF_20010731_201417_20010731_201617.txt';
data=load(file);

DF_WBD_fft=data(:,8);
%fs=27.4430*1000;                        %HZ
fs=219.544*1000;
tstr=13;
tter=19;
Fs=0:100:10000;                           %Hz
window=hanning(1024);
noverlap=512;
%DF_WBD_fft=double(DF_WBD_fft)
spectrogram(DF_WBD_fft,window,noverlap,Fs,fs,'yaxis'); % Display the spectrogram
[S,F,T,P]=spectrogram(DF_WBD_fft,window,noverlap,Fs,fs); % Display the spectrogram
P=P';
%save('C:\Users\dell\Desktop\c1 data\WBD\C1_CE_WBD_WAVEFORM_CDF\Power_Spectra_DF_.txt','P','-ascii')