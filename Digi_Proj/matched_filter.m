function mf_sigs = matched_filter(signame, infoname, if_plot, snr, ...
    pulsewid, prf, sr, npulse, swbwid)
    sep_sigs = sep_ecg(signame, infoname, if_plot);
    
    mlii = sep_sigs{1};
    v1 = sep_sigs{2};
    time = sep_sigs{3};
    
    fft_sigs = fft_ecg(signame, infoname, if_plot, snr);
    mlii_n = fft_sigs{1};
    v1_n = fft_sigs{2};
    
    waveform = phased.LinearFMWaveform('PulseWidth',pulsewid, ...
        'PRF',prf,'SampleRate',sr,'OutputFormat','Pulses', ...
        'NumPulses',npulse,'SweepBandwidth',swbwid);
    wav = getMatchedFilter(waveform);
    
    filter = phased.MatchedFilter('Coefficients',wav);
    taylorfilter = phased.MatchedFilter('Coefficients',wav,...
        'SpectrumWindow','Taylor');
    
    y_mlii = filter(mlii_n);
    y_taylor_mlii = taylorfilter(mlii_n);

    y_v1 = filter(v1_n);
    y_taylor_v1 = taylorfilter(v1_n);
    
    
    subplot(2,2,1)
    plot(time,real(mlii))
    title('Input MLII Signal')
    xlim([0 max(time)])
    grid on
    ylabel('MLII (mv)')
    
    if strcmp(if_plot, 'True') == 1
        fig_nf = figure;

        subplot(2,2,2)
        plot(time,real(mlii_n))
        title('Input MLII Signal with Noise')
        xlim([0 max(time)])
        grid on
        xlabel('Time (sec)')
        ylabel('MLII with noise (mv)')

        subplot(2,2,3)
        plot(time,real(v1))
        title('Input V1 Signal')
        xlim([0 max(time)])
        grid on
        ylabel('MLII (mv)')

        subplot(2,2,4)
        plot(time,real(v1_n))
        title('Input V1 Signal with Noise')
        xlim([0 max(time)])
        grid on
        xlabel('Time (sec)')
        ylabel('V1 with noise (mv)')

        saveas(fig_nf, 'Ori_Signals.png');
    end
    
    plot(time,abs(y_mlii),'b--')
    title('Matched Filter MLII Output')
    xlim([0 max(time)])
    grid on
    hold on
    plot(time,abs(y_taylor_mlii),'r-')
    ylabel('Magnitude')
    xlabel('Seconds')
    legend('No Spectrum Weighting','Taylor Window')
    hold off

    mf_sigs = {v1, y_mlii, y_taylor_mlii, y_v1, y_taylor_v1};
end