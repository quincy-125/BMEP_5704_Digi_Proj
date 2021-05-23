function filt_ecmg = filter_ecmg(seed, sec, Fs, scales, notCool, ...
                if_plot, fs, wl, wh, bpi, win, mpp, cons_std)
            
    cb_sigs = load_ecmg(seed, sec, Fs, scales, notCool, if_plot);
    cb_sig_n = cb_sigs{7};
    
    % lowpass on combined signals
    ls_cbsn = lowpass(cb_sig_n, wl, fs);
    
    % highpass on combined signals
    hs_cbsn = highpass(cb_sig_n, wh, fs);
    
    % bandpass on combined signals
    bs_cbsn = bandpass(cb_sig_n, bpi, fs);
    
    t_cbsn = cb_sigs{1};
    mv_cbsn = movmean(bs_cbsn, win);

    [pks_cbsn, locs_cbsn] = findpeaks(abs(mv_cbsn), ...
                            'MinPeakProminence', mpp);
    
    % R-R interval
    cbsn_0 = cb_sig_n - mean(cb_sig_n);
    std_cbsn = std(cbsn_0);

    locs = [];
    pks = [];

    for i = 1:length(pks_cbsn)
        if pks_cbsn(i) > cons_std * std_cbsn
            loc = locs_cbsn(i);
            pk = pks_cbsn(i);

            locs = [locs; loc];
            pks = [pks; pk];

        end
    end
    
    if strcmp(if_plot, 'True') == 1
        fig_lp = figure;
        
        lowpass(cb_sig_n, wl, fs);
        title('Lowpass Filtering');
        saveas(fig_lp, 'Lowpass Filtering.png');
        
        fig_hp = figure;
        
        highpass(cb_sig_n, wh, fs);
        title('Highpass Filtering');
        saveas(fig_hp, 'Highpass Filtering.png');
        
        fig_bp = figure;
        
        bandpass(cb_sig_n, bpi, fs);
        title('Bandpass Filtering');
        saveas(fig_bp, 'Bandpass Filtering.png');
        
        fig_pks = figure;
        
        subplot(2,1,1);
        plot(locs, pks, '*');
        
        subplot(2,1,2);
        plot(t_cbsn, abs(mv_cbsn));
        
        saveas(fig_pks, 'Peaks.png')
    end
    
    rr = [];
    for i = 2:length(pks)
        diff = locs(i)-locs(i-1);
        rr = [rr, diff];
    end

    % DESCRIPTIVE STATISTICS - RR

    quants = [0.25 0.75];
    rr_time = rr / fs;
    rr_mean = mean(rr_time);
    rr_std = std(rr_time);
    rr_median = median(rr_time);
    rr_25 = quantile(rr_time,quants(:,1));
    rr_75 = quantile(rr_time,quants(:,2));
    rr_stats = [rr_mean, rr_std, rr_median, rr_25, rr_75];

    stats_labels = {'Mean','STDEV','Median','25th','75th'};

    table_stats = table(stats_labels',rr_stats');

    
    filt_ecmg = {t_cbsn, ls_cbsn, hs_cbsn, bs_cbsn, mv_cbsn, ...
                locs, pks, rr, table_stats};
end
