function fft_sigs = fft_ecg(signame, infoname, if_plot, snr)
    sep_sigs = sep_ecg(signame, infoname, if_plot);
    
    mlii = sep_sigs{1};
    v1 = sep_sigs{2};
    time = sep_sigs{3};
    
    % add noise to seperate signals MLII and V1
    mlii_n = awgn(mlii, snr, 'measured');
    v1_n = awgn(v1, snr, 'measured');
    
    if strcmp(if_plot, 'True') == 1
        fig_noise = figure;

        subplot(2, 1, 1);
        plot(time, mlii_n, '-r');
        title('MLII with Added Noise');

        subplot(2, 1, 2);
        plot(time, v1_n, '-b');
        title('V1 with Added Noise');

        saveas(fig_noise, 'noise_signal.png');
    end
    
    % FFT for seperate signals MLII and V1
    fft_mlii = fft(mlii);
    fft_v1 = fft(v1);
    
    f_mlii = (0:length(mlii)-1) * length(time) / length(fft_mlii);
    f_v1 = (0:length(v1)-1) * length(time) / length(fft_v1);
    
    if strcmp(if_plot, 'True') == 1
        fig_fft = figure;

        subplot(2, 1, 1);
        plot(f_mlii, abs(fft_mlii), '-r');
        title('Magnitude MLII');

        subplot(2, 1, 2);
        plot(f_v1, abs(fft_v1), '-g');
        title('Magnitude V1');

        saveas(fig_fft, 'FFT_Signals.png');
    end
    
    
    % FFT Shift for seperate FFT signals MLII_FFT and V1_FFT with noise
    % added
    len_mlii_n = length(mlii_n);
    len_v1_n = length(v1_n);
    
    fshift_mlii = (-len_mlii_n/2:len_mlii_n/2-1) * ...
        (length(time)/len_mlii_n);
    yshift_mlii = fftshift(fft_mlii);
    
    fshift_v1 = (-len_v1_n/2:len_v1_n/2-1) * ...
        (length(time)/len_v1_n);
    yshift_v1 = fftshift(fft_v1);
    
    if strcmp(if_plot, 'True') == 1
        fig_fftshift = figure;

        subplot(2, 1, 1);
        plot(fshift_mlii, abs(yshift_mlii), '-r');
        title('FFT Shift MLII');

        subplot(2, 1, 2);
        plot(fshift_v1, abs(yshift_v1), '-y');
        title('FFT Shift V1');
        saveas(fig_fftshift, 'FFT_Shift.png');
    end
    
    fft_sigs = {mlii_n, v1_n, fft_mlii, fft_v1, ...
        fshift_mlii, yshift_mlii, fshift_v1, yshift_v1};
    
end