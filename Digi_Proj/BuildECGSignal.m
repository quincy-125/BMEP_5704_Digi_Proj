function out = BuildECGSignal(sec,fs,scale)
%
    out = BuildECGSignal(sec,fs,scale);
%
% Built on top of ecgsym fron the Physionet project
% sec: number of seconds of data (> 10 sec)
% fs: sample rate (hz)
% scale: magnitude of signal
%
% Returns 3 rows of data
% 1: Time
% 2: R position (indicated by 1)
% 3: Signal (no noise)
%
