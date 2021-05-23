%Attempt to Seperate
clc, clear all, close all
%Build Combined Signal

seed = 232323;
fs = 2000;
sec = 30;
ecgScale = .02;
emgScale = .01;
noiseScale = .001;
scales = [ecgScale emgScale noiseScale];
notCool = 0;

sig = BuildCombinedSignal(seed,sec,fs,scales,notCool);
Time = sig(1,:);
ECG_R_loc = sig(2,:);
ECG = sig(3,:);
EMG_loc = sig(4,:);
EMG = sig(5,:);
Comb = sig(6,:);
CombN = sig(7,:);

%Plot combined signal with noise
figure(1)
plot(Time,CombN)
title('Combined Signal + Noise')
xlabel('Seconds')

%Plot just ECG
figure(2)
plot(Time,ECG)
title('ECG')
xlabel('Seconds')

%Perform FFT on entire signal
FFT = fft(Comb);
freqComb = (0:length(Comb)-1)*fs/length(Comb);
figure(3)
plot(freqComb,abs(FFT));
xlim([1 150])
title('FFT Entire Signal');
xlabel('Hz')

%Perform FFT of only ECG
FFTECG = fft(ECG);
freqECG = (0:length(ECG)-1)*fs/length(ECG);
figure(4)
plot(freqECG,abs(FFTECG));
xlim([1 40])
title('FFT of ECG');
xlabel('Hz')

%Perform FFT of only EMG
FFTEMG = fft(EMG);
freqEMG = (0:length(EMG)-1)*fs/length(EMG);
figure(5)
plot(freqEMG,abs(FFTEMG));
xlim([1 500])
title('FFT of EMG');
xlabel('Hz')
ylabel('Amplitude')

%Apply 10.5Hz low pass filter
filt_ECG_LP10 = lowpass(CombN,10.5,fs);
figure(6)
plot(Time,filt_ECG_LP10)
title('Low Pass 10.5Hz Filter')
xlabel('Seconds')

%Apply 30Hz low pass filter
filt_ECG_LP30 = lowpass(CombN,30,fs);
figure(7)
plot(Time,filt_ECG_LP30)
title('Low Pass 30Hz Filter')
xlabel('Seconds')

%Apply 6-10.5Hz band pass to combined signal + noise (attempt to isolate ECG)
filt_ECG_BP = bandpass(CombN, [6 10.5], fs);
figure(8)
plot(Time, filt_ECG_BP)
title('6 to 10.5Hz bandpass filter')
xlabel('Seconds')

%This is the best!
%Apply 5-30Hz band pass to combined signal + noise (attempt to isolate ECG)
filt_ECG_BP30 = bandpass(CombN, [5 30], fs);
figure(9)
plot(Time, filt_ECG_BP30)
title('5 to 30Hz bandpass filter')
xlabel('Seconds')

%Subplot
figure(10)
subplot(3,2,[1,2])
plot(Time, CombN)
title('Combined Signal + Noise')
xlabel('Time (S)')
ylabel('Amplitude')
%ylim([-0.02 0.03])

subplot(3,2,3)
plot(Time, filt_ECG_LP10)
title('Lowpass 10.5 Hz')
xlabel('Time (S)')
ylabel('Amplitude')
ylim([-0.02 0.03])

subplot(3,2,4)
plot(Time, filt_ECG_LP30)
title('Lowpass 30 Hz')
xlabel('Time (S)')
ylabel('Amplitude')
ylim([-0.02 0.03])

subplot(3,2,5)
plot(Time, filt_ECG_BP)
title('Bandpass - 6 to 10.5 Hz')
xlabel('Time (S)')
ylabel('Amplitude')
ylim([-0.02 0.03])

subplot(3,2,6)
plot(Time, filt_ECG_BP30)
title('Bandpass - 5 to 30 Hz')
xlabel('Time (S)')
ylabel('Amplitude')
ylim([-0.02 0.03])

%Finding RR interval filt_ECG_BP30
STDecg = std(filt_ECG_BP30);
ECG = filt_ECG_BP30-mean(filt_ECG_BP30);

Location = [];
R_Value = [];

[peaks,locations] = findpeaks(ECG);

for i = 1:length(peaks);
    if peaks(i) > 3*STDecg;
        location = locations(i);
        R_value = peaks(i);
        
        Location = [Location; location];
        R_Value = [R_Value; R_value];
        
    end
end

RR = [];
for i = 2:length(R_Value)
    diff = Location(i)-Location(i-1);
    RR = [RR, diff];
end

%DESCRIPTIVE STATISTICS - RR

quants = [0.25 0.75];
RR_time = RR / fs;
RR_mean = mean(RR_time);
RR_STDEV = std(RR_time);
RR_median = median(RR_time);
RR_25 = quantile(RR_time,quants(:,1));
RR_75 = quantile(RR_time,quants(:,2));
RR_stats = [RR_mean,RR_STDEV,RR_median,RR_25,RR_75];

stats_labels = {'Mean','STDEV','Median','25th','75th'};

Table_stats = table(stats_labels',RR_stats')

%Convert mean RR interval to BPM
BPM = (1/RR_mean)*60;
BPMstd = (RR_STDEV)*60;

%Isolating EMG


%High pass filter 50Hz and Bandpass 50-150Hz
filt_EMG_HP = highpass(CombN,50,fs);
figure(11)
subplot(3,1,1)
plot(Time,CombN)
title('Combined Data + Noise')
xlabel('Time (S)')
ylabel('Amplitude')

subplot(3,1,2)
plot(Time,filt_EMG_HP)
title('Highpass Filter 50Hz')
xlabel('Time (S)')
ylim([-0.015 0.015]);

filt_EMG_BP = bandpass(CombN,[50 150],fs);
subplot(3,1,3)
plot(Time,filt_EMG_BP)
title('Bandpass Filter 50Hz to 150Hz')
xlabel('Time (S)')
ylim([-0.015 0.015]);

% % Now, let's zero-center / DC offset...
% EKG_30 = filt_ECG_BP30 - mean(filt_ECG_BP30);
% EKG30_mean = mean(EKG_30);
% EKG30_stdev = std(EKG_30);
