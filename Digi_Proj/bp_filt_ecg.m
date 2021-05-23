function bp_sigs = bp_filt_ecg(signame, infoname, if_plot, snr, bpi, fs)
    fft_sigs = fft_ecg(signame, infoname, if_plot, snr);
    
    fft_mlii = fft_sigs{3};
    fft_v1 = fft_sigs{4};
    
    bp_mlii = bandpass(fft_mlii, bpi, fs);
    bp_v1 = bandpass(fft_v1, bpi, fs);
    
    sep_sigs = sep_ecg(signame, infoname, if_plot);
    
    mlii = sep_sigs{1};
    v1 = sep_sigs{2};
    
    t_mlii = (1:1:length(mlii))/fs;
    t_v1 = (1:1:length(v1))/fs;
    
    if strcmp(if_plot, 'True') == 1
        fig_fr = figure;
        
        subplot(2, 1, 1);
        freqz(bp_mlii);
        title('Bandpass Frequency Response MLII');
        
        subplot(2, 1, 2);
        freqz(bp_v1);
        title('Bandpass Frequency Response V1');
        
        saveas(fig_fr, 'Frequency Response.png');
        
        fig_bp_mlii = figure;
        
        bandpass(fft_mlii, bpi, fs);
        title('Bandpass Filterin MLII');
        saveas(fig_bp_mlii, 'Bandpass Filtering MLII.png');
        
        fig_bp_v1 = figure;
        
        bandpass(fft_v1, bpi, fs);
        title('Bandpass Filtering V1');
        saveas(fig_bp_v1, 'Bandpass Filtering V1.png');
        
        fig_bp = figure;
        
        subplot(2, 1, 1);
        plot(t_mlii, bp_mlii);
        title('Bandpass MLII');
        
        subplot(2, 1, 2);
        plot(t_v1, bp_v1);
        title('Bandpass V1');
        
        saveas(fig_bp, 'Bandpass Filtering.png');
    end
    
    bp_sigs = {bp_mlii, bp_v1, t_mlii, t_v1};
    
end