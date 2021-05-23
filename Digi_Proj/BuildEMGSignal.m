function out = BuildEMGSignal(sec,fs,scale)
%
% out = BuildEMGSignal(sec,fs,scale)
%
% Generated based on work described:
% https://www.wpi.edu/Pubs/E-project/Available/E-project-031210-170006/unrestricted/EMG_MQP_Report.pdf
%
% sec: number of seconds of data (> 10 sec)
% fs: sample rate (hz)
% scale: magnitude of signal
%
% Returns 3 rows of data
% 1: Time
% 2: Activity Mask (=1)
% 3: Signal (no noise)
%
