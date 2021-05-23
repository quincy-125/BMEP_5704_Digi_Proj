% BMEP 5704 Spring 2021
% Digital Project
% Team Taylor, Emkily, Alex, Quincy
% Create by Quincy Gu
% Create on May 22nd, 2021

% main function
function out = ECG(task, signame, infoname, if_plot, snr, ...
                    pulsewid, prf, sr, npulse, swbwid, ...
                    seed, sec, Fs, scales, notCool, fs, bpi, ...
                    wl, wh, win, mpp, cons_std)
               
    if strcmp(task, 'Load ECG') == 1
        ecgs = load_ecg(signame, infoname, if_plot);
        out = ecgs;
    end
    
    if strcmp(task, 'Load Combined Signals') == 1
        cb_sigs = load_ecmg(seed, sec, Fs, scales, notCool, if_plot);
        out = cb_sigs;
    end
    
    if strcmp(task, 'Split ECG Signals') == 1
        sep_sigs = sep_ecg(signame, infoname, if_plot);
        out = sep_sigs;
    end
    
    if strcmp(task, 'RR Combined Signals') == 1
        filt_ecmg = filter_ecmg(seed, sec, Fs, scales, notCool, ...
                if_plot, fs, wl, wh, bpi, win, mpp, cons_std);
        out = filt_ecmg;
    end
    
    if strcmp(task, 'RR ECG Signals') == 1
        rr_sigs = rr_ecg(signame, infoname, if_plot, ...
                        bpi, fs, win, mpp, cons_std);
        out = rr_sigs;
    end
    
    if strcmp(task, 'FFT ECG Signals') == 1
        fft_sigs = fft_ecg(signame, infoname, if_plot, snr);
        out = fft_sigs;
    end
    
    if strcmp(task, 'Matched ECG Filtering') == 1
        mf_sigs = matched_filter(signame, infoname, if_plot, snr, ...
                   pulsewid, prf, sr, npulse, swbwid);
        out = mf_sigs;
    end
end
