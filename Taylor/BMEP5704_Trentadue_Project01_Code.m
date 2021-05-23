%% TRENTADUE TP - BMEP 5704 - PROJECT 01 

%% COMBINED SIGNAL / SIMULATOR

seed = 232323;
fs = 2000;
sec = 30;
ecgScale = .02;
emgScale = .01; % Loop through scale from 0:x:0.1
emgScale_varied = emgScale/100 : emgScale/100 : emgScale*5;
noiseScale = .001;
scales = [ecgScale emgScale noiseScale];
notCool = 0;

sig = BuildCombinedSignal(seed,sec,fs,scales,notCool);
combined_n = sig(7,:);

%% FFT

signal_combined = sig(7,:);

fs = 2000; %Hz, from INFO file
Y = fft(signal_combined);
P2 = abs(Y/length(signal_combined));
P1 = P2(1:length(signal_combined)/2+1);
P1(2:end-1) = 2*P1(2:end-1);
f = fs*(0:(length(signal_combined)/2))/length(signal_combined);
plot(f,P1)
title('Single-Sided Amplitude Spectrum of X(t)')
xlabel('f (Hz)')
xlim([0 60])

f_sample = fs;
ripple = 3; %dB, in passband
stop_attenuation = 80; %dB, in stopband
passband = 30; %Hz
stopband = 40; %Hz

Pass = passband/(f_sample/2);
Stop = stopband/(f_sample/2);

order= 8;
[B,A] = butter(order,f_cutoffs);

Merged_filtered = filter(B,A, signal_combined);
plot(Merged_filtered)

%% EMG DATA

fs_emg = 4000; %Hz
T = 1/fs_emg;

load emg_healthym.mat
EMG_healthy=val;
t_EMG_healthy = 1/fs_emg:T:(length(EMG_healthy)/fs_emg);
EMG_healthy_abs = abs(EMG_healthy);

load emg_neuropathym.mat
EMG_neuropathy=val;
t_EMG_neuropathy = 1/fs_emg:T:(length(EMG_neuropathy)/fs_emg);
EMG_neuropathy_abs = abs(EMG_neuropathy);

%% HEALTHY

figure;
subplot(2,1,1)
plot(t_EMG_healthy,EMG_healthy)
xlabel('time (s)')
ylabel('Amplitude (mV)')
title('Raw EMG signal, healthy')
xlim([0, max(t_EMG_healthy)])
subplot(2,1,2)
plot(t_EMG_healthy,EMG_healthy_abs)
xlabel('time (s)')
ylabel('Amplitude (mV)')
title('Absolute value of Raw EMG signal, healthy')
xlim([0, max(t_EMG_healthy)])

%% Compute FFT(EMG)
fs = fs_emg; %Hz, from INFO file
Y = fft(EMG_healthy);
P2 = abs(Y/length(EMG_healthy));
P1 = P2(1:length(EMG_healthy)/2+1);
P1(2:end-1) = 2*P1(2:end-1);
f = fs*(0:(length(EMG_healthy)/2))/length(EMG_healthy);

figure;
subplot(2,1,1)
plot(f,P1)
title('Single-Sided Amplitude Spectrum of Healthy EMG')
xlabel('f (Hz)')
ylabel('Amplitude (f)')
xlim([0.5 300])

% ABS(EMG)
fs = fs_emg; %Hz, from INFO file (above)
Y = fft(EMG_healthy_abs);
P2 = abs(Y/length(EMG_healthy_abs));
P1 = P2(1:length(EMG_healthy_abs)/2+1);
P1(2:end-1) = 2*P1(2:end-1);
f = fs*(0:(length(EMG_healthy_abs)/2))/length(EMG_healthy_abs);
ylim([0 150])

subplot(2,1,2)
plot(f,P1)
title('Single-Sided Amplitude Spectrum of |Healthy EMG|')
xlabel('f (Hz)')
ylabel('Amplitude (f)')
xlim([0.5 300])
ylim([0 150])

%% Design filters
% Design highpass butterworth filter

butter_order = 3;
bandpass_min = 20;
bandpass_max = 200;
[B,A] = butter(butter_order,[bandpass_min bandpass_max]/(fs_emg/2));
EMG_healthy_filter1 = filter(B,A,EMG_healthy);

figure;
subplot(4,2,1)
plot(t_EMG_healthy,EMG_healthy)
xlabel('Time (s)')
ylabel('Amplitude')
title('Raw signal')
xlim([0,max(t_EMG_healthy)])

subplot(4,2,2)
plot(t_EMG_healthy,abs(EMG_healthy))
xlabel('Time (s)')
ylabel('Amplitude')
title('|Raw signal|')
xlim([0,max(t_EMG_healthy)])

subplot(4,2,3)
plot(t_EMG_healthy,EMG_healthy_filter1);
xlabel('Time (s)')
ylabel('Amplitude')
title(['Filtered signal - order = ',num2str(butter_order),', bandpass [', num2str(bandpass_min),' ',num2str(bandpass_max),']'])
xlim([0,max(t_EMG_healthy)])

subplot(4,2,5)
EMG_healthy_abs_filter1 = filter(B,A,abs(EMG_healthy));
plot(t_EMG_healthy,EMG_healthy_abs_filter1)
xlabel('Time (s)')
ylabel('Amplitude')
title(['Filtered |signal| - order = ',num2str(butter_order),', bandpass [', num2str(bandpass_min),' ',num2str(bandpass_max),']'])
xlim([0,max(t_EMG_healthy)])

subplot(4,2,7)
plot(t_EMG_healthy,abs(EMG_healthy_filter1))
xlabel('Time (s)')
ylabel('Amplitude')
title(['|Filtered signal| - order = ',num2str(butter_order),', bandpass [', num2str(bandpass_min),' ',num2str(bandpass_max),']'])
xlim([0,max(t_EMG_healthy)])

% Vary butter parameters and repeat
butter_order = 5;
bandpass_min = 50;
bandpass_max = 150;
[B,A] = butter(butter_order,[bandpass_min bandpass_max]/(fs_emg/2));
EMG_healthy_filter2 = filter(B,A,EMG_healthy);

subplot(4,2,4)
plot(t_EMG_healthy,EMG_healthy_filter2);
EMG_healthy_abs_filter2 = filter(B,A,abs(EMG_healthy));
xlabel('Time (s)')
ylabel('Amplitude')
title(['Filtered signal - order = ',num2str(butter_order),', bandpass [', num2str(bandpass_min),' ',num2str(bandpass_max),']'])
xlim([0,max(t_EMG_healthy)])

subplot(4,2,6)
plot(t_EMG_healthy,EMG_healthy_abs_filter2)
xlabel('Time (s)')
ylabel('Amplitude')
title(['Filtered |signal| - order = ',num2str(butter_order),', bandpass [', num2str(bandpass_min),' ',num2str(bandpass_max),']'])
xlim([0,max(t_EMG_healthy)])

subplot(4,2,8)
plot(t_EMG_healthy,abs(EMG_healthy_filter2))
xlabel('Time (s)')
ylabel('Amplitude')
title(['|Filtered signal| - order = ',num2str(butter_order),', bandpass [', num2str(bandpass_min),' ',num2str(bandpass_max),']'])
xlim([0,max(t_EMG_healthy)])

%% Find means and STDEVs of permutations above

mean_EMG_healthy = mean(EMG_healthy);
stdev_EMG_healthy = std(EMG_healthy);

mean_EMG_healthy_abs = mean(abs(EMG_healthy));
stdev_EMG_healthy_abs = std(abs(EMG_healthy));

mean_EMG_healthy_filter1 = mean(EMG_healthy_filter1);
stdev_EMG_healthy_filter1 = std(EMG_healthy_filter1);

mean_EMG_healthy_abs_filter1 = mean(EMG_healthy_abs_filter1);
stdev_EMG_healthy_abs_filter1 = std(EMG_healthy_abs_filter1);

mean_EMG_abs_healthy_filter1 = mean(abs(EMG_healthy_filter1));
stdev_EMG_abs_healthy_filter1 = std(abs(EMG_healthy_filter1));

mean_EMG_healthy_filter2 = mean(EMG_healthy_filter2);
stdev_EMG_healthy_filter2 = std(EMG_healthy_filter2);

mean_EMG_healthy_abs_filter2 = mean(EMG_healthy_abs_filter2);
stdev_EMG_healthy_abs_filter2 = std(EMG_healthy_abs_filter2);

mean_EMG_abs_healthy_filter2 = mean(abs(EMG_healthy_filter2));
stdev_EMG_abs_healthy_filter2 = std(abs(EMG_healthy_filter2));

means = [mean_EMG_healthy;mean_EMG_healthy_abs;mean_EMG_healthy_filter1;mean_EMG_healthy_abs_filter1; mean_EMG_abs_healthy_filter1;mean_EMG_healthy_filter2;mean_EMG_healthy_abs_filter2;mean_EMG_abs_healthy_filter2];
stdevs = [stdev_EMG_healthy;stdev_EMG_healthy_abs;stdev_EMG_healthy_filter1;stdev_EMG_healthy_abs_filter1;stdev_EMG_abs_healthy_filter1;stdev_EMG_healthy_filter2;stdev_EMG_healthy_abs_filter2;stdev_EMG_abs_healthy_filter2];
COVs = stdevs(:,1)./means(:,1);
labels = {'Raw','|Raw|','Filter (raw) 1','Filter (|raw|) 1','|Filter (raw)| 1','Filter (raw) 2','Filter (|raw|) 2','|Filter (raw)| 2'};

MeanSTDEVs = table(labels',means,stdevs,COVs);

%% Moving window average

mm1 = 51;
mm2 = 251;
mm3 = 501;
mm4 = 1001;

y_mm1 = movmean(abs(EMG_healthy_abs_filter2),mm1);
y_mm2 = movmean(abs(EMG_healthy_abs_filter2),mm2);
y_mm3 = movmean(abs(EMG_healthy_abs_filter2),mm3);
y_mm4 = movmean(abs(EMG_healthy_abs_filter2),mm4);

figure;
subplot(5,1,1)
plot(t_EMG_healthy,abs(EMG_healthy_abs_filter2));
xlabel('Time (s)')
ylabel('Amplitude')
title('|Filtered 2|')

subplot(5,1,2)
plot(t_EMG_healthy,y_mm1);
xlabel('Time (s)')
ylabel('Amplitude')
title(['k= ',num2str(mm1)])

subplot(5,1,3)
plot(t_EMG_healthy,y_mm2);
xlabel('Time (s)')
ylabel('Amplitude')
title(['k= ',num2str(mm2)])

subplot(5,1,4)
plot(t_EMG_healthy,y_mm3)
xlabel('Time (s)')
ylabel('Amplitude')
title(['k= ',num2str(mm3)])

subplot(5,1,5)
plot(t_EMG_healthy,y_mm4)
xlabel('Time (s)')
ylabel('Amplitude')
title(['k= ',num2str(mm4)])

%% Mean and STDEV table
mm_means = [mean(y_mm1);mean(y_mm2);mean(y_mm3);mean(y_mm4)];
mm_stdevs = [std(y_mm1);std(y_mm2);std(y_mm3);std(y_mm4)];
mm_ks = [mm1;mm2;mm3;mm4];
mm_covs = mm_stdevs./mm_means;
mm_table = table(mm_ks,mm_means,mm_stdevs,mm_covs)

%% Try movmean
Zerostring3 = [];
Zerostringmed = [];
Zerostringmax = [];

for i= 1:length(y_mm4)
    if y_mm4(i)>3*std(y_mm4)
        zerostringmin = 1;
    else zerostringmin = 0;
    end
    Zerostring3 = [Zerostring3;zerostringmin];
    
    if y_mm4(i)>3.5*std(y_mm4)
        zerostringmed = 1;
    else zerostringmed = 0;
    end
    Zerostringmed = [Zerostringmed;zerostringmed];
    
    if y_mm4(i)>4*std(y_mm4)
        zerostringmax = 1;
    else zerostringmax = 0;
    end
    Zerostringmax = [Zerostringmax;zerostringmax];
end


%% Make plots
figure;
subplot(3,1,1)
plot(t_EMG_healthy, Zerostring3)
ylim([-0.1 1.1])
xlabel('Time (s)')
ylabel('EMG activity yes/no')
title('Threshold: 3*STDEV')
xlim([0,max(t_EMG_healthy)])

subplot(3,1,2)
plot(t_EMG_healthy, Zerostringmed)
ylim([-0.1 1.1])
xlabel('Time (s)')
ylabel('EMG activity yes/no')
title('Threshold: 3.5*STDEV')
xlim([0,max(t_EMG_healthy)])

subplot(3,1,3)
plot(t_EMG_healthy, Zerostringmax)
ylim([-0.1 1.1])
xlabel('Time (s)')
ylabel('EMG activity yes/no')
title('Threshold: 4*STDEV')
xlim([0,max(t_EMG_healthy)])

%% Try moving averages on the 0/1s

t_detect = 182/1000; %ms
% per Dieterich AV, Botter A, Vieira TM, Peolsson A, Petzke F, Davey P,
% Falla D. Spatial variation and inconsistency between estimates of onset
% of muscle activation from EMG and ultrasound. Sci Rep. 2017 Feb
% 8;7:42011. doi: 10.1038/srep42011. PMID: 28176821; PMCID: PMC5296741.
l_threshold = t_detect*fs;

onoff_mm1 = movmean(Zerostringmed,l_threshold);

Zerostring_onoff1 = [];
Zerostring_onoff2 = [];
Zerostring_onoff3 = [];

cutmax = 0.85;
cutmed = 0.7;
cutmin = 0.55;

for i= 1:length(onoff_mm1)
    if onoff_mm1(i)>cutmax
        zerostring_onoff1 = 1;
    else zerostring_onoff1 = 0;
    end
    Zerostring_onoff1 = [Zerostring_onoff1;zerostring_onoff1];
    
    if onoff_mm1(i)>cutmed
        zerostring_onoff2 = 1;
    else zerostring_onoff2 = 0;
    end
    Zerostring_onoff2 = [Zerostring_onoff2;zerostring_onoff2];
    
    if onoff_mm1(i)>cutmin
        zerostring_onoff3 = 1;
    else zerostring_onoff3 = 0;
    end
    Zerostring_onoff3 = [Zerostring_onoff3;zerostring_onoff3];
    
end

%% Make plots

figure;
subplot(5,1,1)
plot(t_EMG_healthy,y_mm4)
xlabel('Time (s)')
ylabel('AVG amplitude')
title(['Moving average, k=',num2str(mm4)])
xlim([0,max(t_EMG_healthy)])

subplot(5,1,2)
plot(t_EMG_healthy, Zerostringmed)
ylim([-0.1 1.1])
xlabel('Time (s)')
ylabel('EMG yes/no')
title('Threshold: 3.5*STDEV')
xlim([0,max(t_EMG_healthy)])

subplot(5,1,3)
plot(t_EMG_healthy, Zerostring_onoff1)
ylim([-0.1 1.1])
xlabel('Time (s)')
ylabel('EMG yes/no')
title(['Threshold: mean > ',num2str(cutmax)])
xlim([0,max(t_EMG_healthy)])

subplot(5,1,4)
plot(t_EMG_healthy, Zerostring_onoff2)
ylim([-0.1 1.1])
xlabel('Time (s)')
ylabel('EMG yes/no')
title(['Threshold: mean > ',num2str(cutmed)])
xlim([0,max(t_EMG_healthy)])

subplot(5,1,5)
plot(t_EMG_healthy, Zerostring_onoff3)
ylim([-0.1 1.1])
xlabel('Time (s)')
ylabel('EMG yes/no')
title(['Threshold: mean > ',num2str(cutmin)])
xlim([0,max(t_EMG_healthy)])

%% 
%% REPEAT ALL FOR NEUROPATHY

%% START NEUROPATHY

subplot(2,1,1)
plot(t_EMG_neuropathy,EMG_neuropathy)
xlabel('time (s)')
ylabel('Amplitude (mV)')
title('Raw EMG signal, neuropathy')
subplot(2,1,2)
plot(t_EMG_neuropathy,EMG_neuropathy_abs)
xlabel('time (s)')
ylabel('Amplitude (mV)')
title('Absolute value of Raw EMG signal, neuropathy')

%% Compute FFT(EMG)
fs = fs_emg; %Hz, from INFO file
Y = fft(EMG_neuropathy);
P2 = abs(Y/length(EMG_neuropathy));
P1 = P2(1:length(EMG_neuropathy)/2+1);
P1(2:end-1) = 2*P1(2:end-1);
f = fs*(0:(length(EMG_neuropathy)/2))/length(EMG_neuropathy);

figure;
subplot(2,1,1)
plot(f,P1)
title('Single-Sided Amplitude Spectrum of Neuropathy EMG')
xlabel('f (Hz)')
ylabel('Amplitude (f)')
xlim([0.5 300])

% ABS(EMG)
fs = fs_emg; %Hz, from INFO file (above)
Y = fft(EMG_neuropathy_abs);
P2 = abs(Y/length(EMG_neuropathy_abs));
P1 = P2(1:length(EMG_neuropathy_abs)/2+1);
P1(2:end-1) = 2*P1(2:end-1);
f = fs*(0:(length(EMG_neuropathy_abs)/2))/length(EMG_neuropathy_abs);
ylim([0 300])

subplot(2,1,2)
plot(f,P1)
title('Single-Sided Amplitude Spectrum of |Neuropathy EMG|')
xlabel('f (Hz)')
ylabel('Amplitude (f)')
xlim([0.5 300])
ylim([0 300])

%% Design filters
% Design highpass butterworth filter

butter_order = 3;
bandpass_min = 20;
bandpass_max = 200;
[B,A] = butter(butter_order,[bandpass_min bandpass_max]/(fs_emg/2));

EMG_neuropathy_filter1 = filter(B,A,EMG_neuropathy);

figure;
subplot(4,2,1)
plot(t_EMG_neuropathy,EMG_neuropathy)
xlabel('Time (s)')
ylabel('Amplitude')
title('Raw signal')
xlim([0,max(t_EMG_neuropathy)])

subplot(4,2,2)
plot(t_EMG_neuropathy,abs(EMG_neuropathy))
xlabel('Time (s)')
ylabel('Amplitude')
title('|Raw signal|')
xlim([0,max(t_EMG_neuropathy)])

subplot(4,2,3)
plot(t_EMG_neuropathy,EMG_neuropathy_filter1);
xlabel('Time (s)')
ylabel('Amplitude')
title(['Filtered signal - order = ',num2str(butter_order),', bandpass [', num2str(bandpass_min),' ',num2str(bandpass_max),']'])
xlim([0,max(t_EMG_neuropathy)])

subplot(4,2,5)
EMG_neuropathy_abs_filter1 = filter(B,A,abs(EMG_neuropathy));
plot(t_EMG_neuropathy,EMG_neuropathy_abs_filter1)
xlabel('Time (s)')
ylabel('Amplitude')
title(['Filtered |signal| - order = ',num2str(butter_order),', bandpass [', num2str(bandpass_min),' ',num2str(bandpass_max),']'])
xlim([0,max(t_EMG_neuropathy)])

subplot(4,2,7)
plot(t_EMG_neuropathy,abs(EMG_neuropathy_filter1))
xlabel('Time (s)')
ylabel('Amplitude')
title(['|Filtered signal| - order = ',num2str(butter_order),', bandpass [', num2str(bandpass_min),' ',num2str(bandpass_max),']'])
xlim([0,max(t_EMG_neuropathy)])

% Vary butter parameters and repeat
butter_order = 5;
bandpass_min = 50;
bandpass_max = 150;
[B,A] = butter(butter_order,[bandpass_min bandpass_max]/(fs_emg/2));
EMG_neuropathy_filter2 = filter(B,A,EMG_neuropathy);
 
subplot(4,2,4)
plot(t_EMG_neuropathy,EMG_neuropathy_filter2);
EMG_neuropathy_abs_filter2 = filter(B,A,abs(EMG_neuropathy));
xlabel('Time (s)')
ylabel('Amplitude')
title(['Filtered signal - order = ',num2str(butter_order),', bandpass [', num2str(bandpass_min),' ',num2str(bandpass_max),']'])
xlim([0,max(t_EMG_neuropathy)])
 
subplot(4,2,6)
plot(t_EMG_neuropathy,EMG_neuropathy_abs_filter2)
xlabel('Time (s)')
ylabel('Amplitude')
title(['Filtered |signal| - order = ',num2str(butter_order),', bandpass [', num2str(bandpass_min),' ',num2str(bandpass_max),']'])
xlim([0,max(t_EMG_neuropathy)])
 
subplot(4,2,8)
plot(t_EMG_neuropathy,abs(EMG_neuropathy_filter2))
xlabel('Time (s)')
ylabel('Amplitude')
title(['|Filtered signal| - order = ',num2str(butter_order),', bandpass [', num2str(bandpass_min),' ',num2str(bandpass_max),']'])
xlim([0,max(t_EMG_neuropathy)])
 
%% Find means and STDEVs of permutations above

mean_EMG_neuropathy = mean(EMG_neuropathy);
stdev_EMG_neuropathy = std(EMG_neuropathy);
 
mean_EMG_neuropathy_abs = mean(abs(EMG_neuropathy));
stdev_EMG_neuropathy_abs = std(abs(EMG_neuropathy));
 
mean_EMG_neuropathy_filter1 = mean(EMG_neuropathy_filter1);
stdev_EMG_neuropathy_filter1 = std(EMG_neuropathy_filter1);
 
mean_EMG_neuropathy_abs_filter1 = mean(EMG_neuropathy_abs_filter1);
stdev_EMG_neuropathy_abs_filter1 = std(EMG_neuropathy_abs_filter1);
 
mean_EMG_abs_neuropathy_filter1 = mean(abs(EMG_neuropathy_filter1));
stdev_EMG_abs_neuropathy_filter1 = std(abs(EMG_neuropathy_filter1));
 
mean_EMG_neuropathy_filter2 = mean(EMG_neuropathy_filter2);
stdev_EMG_neuropathy_filter2 = std(EMG_neuropathy_filter2);
 
mean_EMG_neuropathy_abs_filter2 = mean(EMG_neuropathy_abs_filter2);
stdev_EMG_neuropathy_abs_filter2 = std(EMG_neuropathy_abs_filter2);
 
mean_EMG_abs_neuropathy_filter2 = mean(abs(EMG_neuropathy_filter2));
stdev_EMG_abs_neuropathy_filter2 = std(abs(EMG_neuropathy_filter2));
 
means = [mean_EMG_neuropathy;mean_EMG_neuropathy_abs;mean_EMG_neuropathy_filter1;mean_EMG_neuropathy_abs_filter1; mean_EMG_abs_neuropathy_filter1;mean_EMG_neuropathy_filter2;mean_EMG_neuropathy_abs_filter2;mean_EMG_abs_neuropathy_filter2];
stdevs = [stdev_EMG_neuropathy;stdev_EMG_neuropathy_abs;stdev_EMG_neuropathy_filter1;stdev_EMG_neuropathy_abs_filter1;stdev_EMG_abs_neuropathy_filter1;stdev_EMG_neuropathy_filter2;stdev_EMG_neuropathy_abs_filter2;stdev_EMG_abs_neuropathy_filter2];
COVs = stdevs(:,1)./means(:,1);
labels = {'Raw','|Raw|','Filter (raw) 1','Filter (|raw|) 1','|Filter (raw)| 1','Filter (raw) 2','Filter (|raw|) 2','|Filter (raw)| 2'};
MeanSTDEVs = table(labels',means,stdevs,COVs);
 
%% Moving window average
 
mm1 = 51;
mm2 = 251;
mm3 = 501;
mm4 = 1001;
 
y_mm1 = movmean(abs(EMG_neuropathy_abs_filter2),mm1);
y_mm2 = movmean(abs(EMG_neuropathy_abs_filter2),mm2);
y_mm3 = movmean(abs(EMG_neuropathy_abs_filter2),mm3);
y_mm4 = movmean(abs(EMG_neuropathy_abs_filter2),mm4);
 
figure;
subplot(5,1,1)
plot(t_EMG_neuropathy,abs(EMG_neuropathy_abs_filter2));
xlabel('Time (s)')
ylabel('Amplitude')
title('|Filtered 2|')
 
subplot(5,1,2)
plot(t_EMG_neuropathy,y_mm1);
xlabel('Time (s)')
ylabel('Amplitude')
title(['k= ',num2str(mm1)])
 
subplot(5,1,3)
plot(t_EMG_neuropathy,y_mm2);
xlabel('Time (s)')
ylabel('Amplitude')
title(['k= ',num2str(mm2)])
 
subplot(5,1,4)
plot(t_EMG_neuropathy,y_mm3)
xlabel('Time (s)')
ylabel('Amplitude')
title(['k= ',num2str(mm3)])
 
subplot(5,1,5)
plot(t_EMG_neuropathy,y_mm4)
xlabel('Time (s)')
ylabel('Amplitude')
title(['k= ',num2str(mm4)])
 
%% Mean and STDEV table
mm_means = [mean(y_mm1);mean(y_mm2);mean(y_mm3);mean(y_mm4)];
mm_stdevs = [std(y_mm1);std(y_mm2);std(y_mm3);std(y_mm4)];
mm_ks = [mm1;mm2;mm3;mm4];
mm_covs = mm_stdevs./mm_means;
mm_table = table(mm_ks,mm_means,mm_stdevs,mm_covs)
 
%% Try movmean for mm4

Zerostringmin1 = [];
Zerostringmed1 = [];
Zerostringmax1 = [];

min1=2;
med1=2.5;
max1=3;

tic;

for i= 1:length(y_mm4)
    if y_mm4(i)>min1*std(y_mm4)
        zerostringmin = 1;
    else zerostringmin = 0;
    end
    Zerostringmin1 = [Zerostringmin1;zerostringmin];
    
    if y_mm4(i)>med1*std(y_mm4)
        zerostringmed = 1;
    else zerostringmed = 0;
    end
    Zerostringmed1 = [Zerostringmed1;zerostringmed];
    
    if y_mm4(i)>max1*std(y_mm4)
        zerostringmax = 1;
    else zerostringmax = 0;
    end
    Zerostringmax1 = [Zerostringmax1;zerostringmax];
end
toc;

%% Try movmean for mm3
Zerostringmin2 = [];
Zerostringmed2 = [];
Zerostringmax2 = [];

min2=2;
med2=2.5;
max2=3;

tic;

for i= 1:length(y_mm3)
    if y_mm4(i)>min2*std(y_mm3)
        zerostringmin = 1;
    else zerostringmin = 0;
    end
    Zerostringmin2 = [Zerostringmin2;zerostringmin];
    
    if y_mm4(i)>med2*std(y_mm3)
        zerostringmed = 1;
    else zerostringmed = 0;
    end
    Zerostringmed2 = [Zerostringmed2;zerostringmed];
    
    if y_mm4(i)>max2*std(y_mm3)
        zerostringmax = 1;
    else zerostringmax = 0;
    end
    Zerostringmax2 = [Zerostringmax2;zerostringmax];
end
toc;


%% Make plots
figure;
subplot(3,2,1)
plot(Zerostringmin1)
ylim([-0.1 1.1])
xlabel('Time (s)')
ylabel('EMG activity yes/no')
title(['Threshold: ',num2str(min1),'*STDEV'])
 
subplot(3,2,3)
plot(Zerostringmed1)
ylim([-0.1 1.1])
xlabel('Time (s)')
ylabel('EMG activity yes/no')
title(['Threshold: ',num2str(med1),'*STDEV'])
 
subplot(3,2,5)
plot(Zerostringmax1)
ylim([-0.1 1.1])
xlabel('Time (s)')
ylabel('EMG activity yes/no')
title(['Threshold: ',num2str(max1),'*STDEV'])

subplot(3,2,2)
plot(Zerostringmin2)
ylim([-0.1 1.1])
xlabel('Time (s)')
ylabel('EMG activity yes/no')
title(['Threshold: ',num2str(min2),'*STDEV'])
 
subplot(3,2,4)
plot(Zerostringmed2)
ylim([-0.1 1.1])
xlabel('Time (s)')
ylabel('EMG activity yes/no')
title(['Threshold: ',num2str(med2),'*STDEV'])
 
subplot(3,2,6)
plot(Zerostringmax2)
ylim([-0.1 1.1])
xlabel('Time (s)')
ylabel('EMG activity yes/no')
title(['Threshold: ',num2str(max2),'*STDEV'])
 
%% Try moving averages on the 0/1s
% Original attempt
 
t_detect = 182/1000; %ms
% per Dieterich AV, Botter A, Vieira TM, Peolsson A, Petzke F, Davey P,
% Falla D. Spatial variation and inconsistency between estimates of onset
% of muscle activation from EMG and ultrasound. Sci Rep. 2017 Feb
% 8;7:42011. doi: 10.1038/srep42011. PMID: 28176821; PMCID: PMC5296741.
l_threshold = t_detect*fs;
 
onoff_mm1 = movmean(Zerostringmed2,l_threshold);
 
Zerostring_onoff1 = [];
Zerostring_onoff2 = [];
Zerostring_onoff3 = [];
 
cutmax = 0.85;
cutmed = 0.7;
cutmin = 0.55;

tic;
for i= 1:length(onoff_mm1)
    if onoff_mm1(i)>cutmax
        zerostring_onoff1 = 1;
    else zerostring_onoff1 = 0;
    end
    Zerostring_onoff1 = [Zerostring_onoff1;zerostring_onoff1];
    
    if onoff_mm1(i)>cutmed
        zerostring_onoff2 = 1;
    else zerostring_onoff2 = 0;
    end
    Zerostring_onoff2 = [Zerostring_onoff2;zerostring_onoff2];
    
    if onoff_mm1(i)>cutmin
        zerostring_onoff3 = 1;
    else zerostring_onoff3 = 0;
    end
    Zerostring_onoff3 = [Zerostring_onoff3;zerostring_onoff3];
    
end

toc;

%% Make plots
 
figure;
subplot(5,1,1)
plot(t_EMG_neuropathy,y_mm4)
xlabel('Time (s)')
ylabel('AVG amplitude')
title(['Moving average, k=',num2str(mm4)])
xlim([0,max(t_EMG_neuropathy)])
 
subplot(5,1,2)
plot(t_EMG_neuropathy, Zerostringmed1)
ylim([-0.1 1.1])
xlabel('Time (s)')
ylabel('EMG yes/no')
title('Threshold: 2.5*STDEV')
xlim([0,max(t_EMG_neuropathy)])
 
subplot(5,1,3)
plot(t_EMG_neuropathy, Zerostring_onoff1)
ylim([-0.1 1.1])
xlabel('Time (s)')
ylabel('EMG yes/no')
title(['Threshold: mean > ',num2str(cutmax)])
xlim([0,max(t_EMG_neuropathy)])
 
subplot(5,1,4)
plot(t_EMG_neuropathy, Zerostring_onoff2)
ylim([-0.1 1.1])
xlabel('Time (s)')
ylabel('EMG yes/no')
title(['Threshold: mean > ',num2str(cutmed)])
xlim([0,max(t_EMG_neuropathy)])
 
subplot(5,1,5)
plot(t_EMG_neuropathy, Zerostring_onoff3)
ylim([-0.1 1.1])
xlabel('Time (s)')
ylabel('EMG yes/no')
title(['Threshold: mean > ',num2str(cutmin)])
xlim([0,max(t_EMG_neuropathy)])
 
%% Try moving averages on the 0/1s
% Raise time to detection threshold
 
t_detect = 182/1000; %ms
% per Dieterich AV, Botter A, Vieira TM, Peolsson A, Petzke F, Davey P,
% Falla D. Spatial variation and inconsistency between estimates of onset
% of muscle activation from EMG and ultrasound. Sci Rep. 2017 Feb
% 8;7:42011. doi: 10.1038/srep42011. PMID: 28176821; PMCID: PMC5296741.

multiplier_dz = 4; %arbitrary
l_threshold = multiplier_dz*t_detect*fs;
 
onoff_mm1 = movmean(Zerostringmed2,l_threshold);
 
Zerostring_onoff1 = [];
Zerostring_onoff2 = [];
Zerostring_onoff3 = [];
 
cutmax = 0.85;
cutmed = 0.7;
cutmin = 0.55;

tic;
for i= 1:length(onoff_mm1)
    if onoff_mm1(i)>cutmax
        zerostring_onoff1 = 1;
    else zerostring_onoff1 = 0;
    end
    Zerostring_onoff1 = [Zerostring_onoff1;zerostring_onoff1];
    
    if onoff_mm1(i)>cutmed
        zerostring_onoff2 = 1;
    else zerostring_onoff2 = 0;
    end
    Zerostring_onoff2 = [Zerostring_onoff2;zerostring_onoff2];
    
    if onoff_mm1(i)>cutmin
        zerostring_onoff3 = 1;
    else zerostring_onoff3 = 0;
    end
    Zerostring_onoff3 = [Zerostring_onoff3;zerostring_onoff3];
    
end

toc;

%% Make plots
 
figure;
subplot(5,1,1)
plot(t_EMG_neuropathy,y_mm4)
xlabel('Time (s)')
ylabel('AVG amplitude')
title(['Moving average, k=',num2str(mm4)])
xlim([0,max(t_EMG_neuropathy)])
 
subplot(5,1,2)
plot(t_EMG_neuropathy, Zerostringmed1)
ylim([-0.1 1.1])
xlabel('Time (s)')
ylabel('EMG yes/no')
title('Threshold: 2.5*STDEV')
xlim([0,max(t_EMG_neuropathy)])
 
subplot(5,1,3)
plot(t_EMG_neuropathy, Zerostring_onoff1)
ylim([-0.1 1.1])
xlabel('Time (s)')
ylabel('EMG yes/no')
title(['Threshold: mean > ',num2str(cutmax)])
xlim([0,max(t_EMG_neuropathy)])
 
subplot(5,1,4)
plot(t_EMG_neuropathy, Zerostring_onoff2)
ylim([-0.1 1.1])
xlabel('Time (s)')
ylabel('EMG yes/no')
title(['Threshold: mean > ',num2str(cutmed)])
xlim([0,max(t_EMG_neuropathy)])
 
subplot(5,1,5)
plot(t_EMG_neuropathy, Zerostring_onoff3)
ylim([-0.1 1.1])
xlabel('Time (s)')
ylabel('EMG yes/no')
title(['Threshold: mean > ',num2str(cutmin)])
xlim([0,max(t_EMG_neuropathy)])
 

%% Try moving averages on the 0/1s
 
t_detect = 182/1000; %ms
% per Dieterich AV, Botter A, Vieira TM, Peolsson A, Petzke F, Davey P,
% Falla D. Spatial variation and inconsistency between estimates of onset
% of muscle activation from EMG and ultrasound. Sci Rep. 2017 Feb
% 8;7:42011. doi: 10.1038/srep42011. PMID: 28176821; PMCID: PMC5296741.

l_threshold = multiplier_dz*t_detect*fs;
 
onoff_mm1 = movmean(Zerostringmin2,l_threshold);
 
Zerostring_onoff1 = [];
Zerostring_onoff2 = [];
Zerostring_onoff3 = [];
 
cutmax = 0.85;
cutmed = 0.7;
cutmin = 0.55;

tic;
for i= 1:length(onoff_mm1)
    if onoff_mm1(i)>cutmax
        zerostring_onoff1 = 1;
    else zerostring_onoff1 = 0;
    end
    Zerostring_onoff1 = [Zerostring_onoff1;zerostring_onoff1];
    
    if onoff_mm1(i)>cutmed
        zerostring_onoff2 = 1;
    else zerostring_onoff2 = 0;
    end
    Zerostring_onoff2 = [Zerostring_onoff2;zerostring_onoff2];
    
    if onoff_mm1(i)>cutmin
        zerostring_onoff3 = 1;
    else zerostring_onoff3 = 0;
    end
    Zerostring_onoff3 = [Zerostring_onoff3;zerostring_onoff3];
    
end

toc;

%% Make plots
 
figure;
subplot(5,1,1)
plot(t_EMG_neuropathy,y_mm4)
xlabel('Time (s)')
ylabel('AVG amplitude')
title(['Moving average, k=',num2str(mm4)])
xlim([0,max(t_EMG_neuropathy)])
 
subplot(5,1,2)
plot(t_EMG_neuropathy, Zerostringmed1)
ylim([-0.1 1.1])
xlabel('Time (s)')
ylabel('EMG yes/no')
title('Threshold: 2*STDEV')
xlim([0,max(t_EMG_neuropathy)])
 
subplot(5,1,3)
plot(t_EMG_neuropathy, Zerostring_onoff1)
ylim([-0.1 1.1])
xlabel('Time (s)')
ylabel('EMG yes/no')
title(['Threshold: mean > ',num2str(cutmax)])
xlim([0,max(t_EMG_neuropathy)])
 
subplot(5,1,4)
plot(t_EMG_neuropathy, Zerostring_onoff2)
ylim([-0.1 1.1])
xlabel('Time (s)')
ylabel('EMG yes/no')
title(['Threshold: mean > ',num2str(cutmed)])
xlim([0,max(t_EMG_neuropathy)])
 
subplot(5,1,5)
plot(t_EMG_neuropathy, Zerostring_onoff3)
ylim([-0.1 1.1])
xlabel('Time (s)')
ylabel('EMG yes/no')
title(['Threshold: mean > ',num2str(cutmin)])
xlim([0,max(t_EMG_neuropathy)])
 
%%
%%
%% BACK TO ORIGINAL COMBINED CODE:

time_filt = sig(1,:);
filt_EMG_HP = highpass(combined_n, 50, fs);
filt_EMG_BP = bandpass(combined_n, [50 150], fs);

figure;
plot(time_filt,filt_EMG_BP)
xlabel('Time (s)')
ylabel('Amplitude')

%% Moving window average

mm1 = 51;
mm2 = 251;
mm3 = 501;
mm4 = 1001;

y_mm1 = movmean(abs(filt_EMG_BP),mm1);
y_mm2 = movmean(abs(filt_EMG_BP),mm2);
y_mm3 = movmean(abs(filt_EMG_BP),mm3);
y_mm4 = movmean(abs(filt_EMG_BP),mm4);

figure;
subplot(5,1,1)
plot(time_filt,abs(filt_EMG_BP));
xlabel('Time (s)')
ylabel('Amplitude')
title('|Filtered separated EMG|')

subplot(5,1,2)
plot(time_filt,y_mm1);
xlabel('Time (s)')
ylabel('Amplitude')
title(['k= ',num2str(mm1)])

subplot(5,1,3)
plot(time_filt,y_mm2);
xlabel('Time (s)')
ylabel('Amplitude')
title(['k= ',num2str(mm2)])

subplot(5,1,4)
plot(time_filt,y_mm3)
xlabel('Time (s)')
ylabel('Amplitude')
title(['k= ',num2str(mm3)])

subplot(5,1,5)
plot(time_filt,y_mm4)
xlabel('Time (s)')
ylabel('Amplitude')
title(['k= ',num2str(mm4)])

%% Mean and STDEV table
mm_means = [mean(y_mm1);mean(y_mm2);mean(y_mm3);mean(y_mm4)];
mm_stdevs = [std(y_mm1);std(y_mm2);std(y_mm3);std(y_mm4)];
mm_ks = [mm1;mm2;mm3;mm4];
mm_covs = mm_stdevs./mm_means;
mm_table = table(mm_ks,mm_means,mm_stdevs,mm_covs)

%% Try movmean
minmult = 1.5;
medmult = 2;
maxmult = 2.5;

Zerostringmin = [];
Zerostringmed = [];
Zerostringmax = [];

tic;
for i= 1:length(y_mm4)
    if y_mm4(i)>minmult*std(y_mm4)
        zerostringmin = 1;
    else zerostringmin = 0;
    end
    Zerostringmin = [Zerostringmin;zerostringmin];
    
    if y_mm4(i)>medmult*std(y_mm4)
        zerostringmed = 1;
    else zerostringmed = 0;
    end
    Zerostringmed = [Zerostringmed;zerostringmed];
    
    if y_mm4(i)>maxmult*std(y_mm4)
        zerostringmax = 1;
    else zerostringmax = 0;
    end
    Zerostringmax = [Zerostringmax;zerostringmax];
end
toc;

%% Make plots
figure;
subplot(3,1,1)
plot(time_filt, Zerostringmin)
ylim([-0.1 1.1])
xlabel('Time (s)')
ylabel('EMG activity yes/no')
title(['Threshold: ',num2str(minmult),'*STDEV'])
xlim([0,max(time_filt)])

subplot(3,1,2)
plot(time_filt, Zerostringmed)
ylim([-0.1 1.1])
xlabel('Time (s)')
ylabel('EMG activity yes/no')
title(['Threshold: ',num2str(medmult),'*STDEV'])
xlim([0,max(time_filt)])

subplot(3,1,3)
plot(time_filt, Zerostringmax)
ylim([-0.1 1.1])
xlabel('Time (s)')
ylabel('EMG activity yes/no')
title(['Threshold: ',num2str(maxmult),'*STDEV'])
xlim([0,max(time_filt)])

%% Try moving averages on the 0/1s

t_detect = 182/1000; %ms
% per Dieterich AV, Botter A, Vieira TM, Peolsson A, Petzke F, Davey P,
% Falla D. Spatial variation and inconsistency between estimates of onset
% of muscle activation from EMG and ultrasound. Sci Rep. 2017 Feb
% 8;7:42011. doi: 10.1038/srep42011. PMID: 28176821; PMCID: PMC5296741.
l_threshold = t_detect*fs;

onoff_mm1 = movmean(Zerostringmed,l_threshold);

Zerostring_onoff1 = [];
Zerostring_onoff2 = [];
Zerostring_onoff3 = [];

cutmax = 0.85;
cutmed = 0.7;
cutmin = 0.55;

tic;
for i= 1:length(onoff_mm1)
    if onoff_mm1(i)>cutmax
        zerostring_onoff1 = 1;
    else zerostring_onoff1 = 0;
    end
    Zerostring_onoff1 = [Zerostring_onoff1;zerostring_onoff1];
    
    if onoff_mm1(i)>cutmed
        zerostring_onoff2 = 1;
    else zerostring_onoff2 = 0;
    end
    Zerostring_onoff2 = [Zerostring_onoff2;zerostring_onoff2];
    
    if onoff_mm1(i)>cutmin
        zerostring_onoff3 = 1;
    else zerostring_onoff3 = 0;
    end
    Zerostring_onoff3 = [Zerostring_onoff3;zerostring_onoff3];
    
end
toc;

%% Make plots

figure;
subplot(5,1,1)
plot(time_filt,y_mm4)
xlabel('Time (s)')
ylabel('AVG amplitude')
title(['Moving average, k=',num2str(mm4)])
xlim([0,max(time_filt)])

subplot(5,1,2)
plot(time_filt, Zerostringmed)
ylim([-0.1 1.1])
xlabel('Time (s)')
ylabel('EMG yes/no')
title(['Threshold: ',num2str(medmult),'*STDEV'])
xlim([0,max(time_filt)])

subplot(5,1,3)
plot(time_filt, Zerostring_onoff1)
ylim([-0.1 1.1])
xlabel('Time (s)')
ylabel('EMG yes/no')
title(['Threshold: mean > ',num2str(cutmax)])
xlim([0,max(time_filt)])

subplot(5,1,4)
plot(time_filt, Zerostring_onoff2)
ylim([-0.1 1.1])
xlabel('Time (s)')
ylabel('EMG yes/no')
title(['Threshold: mean > ',num2str(cutmed)])
xlim([0,max(time_filt)])

subplot(5,1,5)
plot(time_filt, Zerostring_onoff3)
ylim([-0.1 1.1])
xlabel('Time (s)')
ylabel('EMG yes/no')
title(['Threshold: mean > ',num2str(cutmin)])
xlim([0,max(time_filt)])
