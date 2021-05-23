function out = BuildCombinedSignal(seed,sec,fs,scales,notCool)
%
    out = BuildCombinedSignal(seed, sec,fs,scales, notCool);
%
% This function will combine ECG and EMG data.
%
% seed: seed for random number (to allow for reproducibility)
% sec: number of seconds of data (> 10 sec)
% fs: sample rate (hz)
% scales: magnitude of signals [ECG EMG Noise] (see example)
% notCool:  Just to mess with you.  notCool = 1
%
% Returns 7 rows of data
% 1: Time
% 2: ECG R location (=1)
% 3: ECG (no noise)
% 4: EMG location (=1)
% 5: EMG (no noise)
% 6: Combined (no noise)
% 7: W/ noise
%
% Example:
% 
% seed = 232323;
% fs = 2000;
% sec = 30;
% ecgScale = .02;
% emgScale = .01;
% noiseScale = .001;
% scales = [ecgScale emgScale noiseScale];
% notCool = 0;
%
% sig = BuildCombinedSignal(seed,sec,fs,scales,notCool);
%
% figure(1)
% subplot(2,1,1)
% plot(sig(1,:),sig(3,:))
% subplot(2,1,2)
% pwelch(sig(3,:))
% 
% figure(2)
% subplot(2,1,1)
% plot(sig(1,:),sig(5,:))
% subplot(2,1,2)
% pwelch(sig(5,:))
% 
% figure(3)
% subplot(2,1,1)
% plot(sig(1,:),sig(6,:))
% subplot(2,1,2)
% pwelch(sig(6,:))
% 
% figure(4)
% subplot(2,1,1)
% plot(sig(1,:),sig(7,:))
% subplot(2,1,2)
% pwelch(sig(7,:))
