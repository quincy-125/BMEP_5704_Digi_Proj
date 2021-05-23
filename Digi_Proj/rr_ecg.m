function rr_sigs = rr_ecg(signame, infoname, if_plot, ...
                        bpi, fs, win, mpp, cons_std)
    % mpp = 0.01;
    % cons_std = 0.02;
    
    sep_sigs = sep_ecg(signame, infoname, if_plot);
    
    mlii = sep_sigs{1};
    v1 = sep_sigs{2};
    
    t_mlii = (1:1:length(mlii))/fs;
    t_v1 = (1:1:length(v1))/fs;
    
    bp_mlii = bandpass(mlii, bpi, win);
    bp_v1 = bandpass(v1, bpi, win);
    
    mv_mlii = movmean(bp_mlii, win);
    mv_v1 = movmean(bp_v1, win);

    [pks_mlii, locs_mlii] = findpeaks(abs(mv_mlii), ...
                            'MinPeakProminence', mpp);
    [pks_v1, locs_v1] = findpeaks(abs(mv_v1), ...
                            'MinPeakProminence', mpp);
    
    % R-R interval MLII
    mlii_0 = mlii - mean(mlii);
    std_mlii = std(mlii_0);

    locs_m = [];
    pks_m = [];

    for i = 1:length(pks_mlii)
        if pks_mlii(i) > cons_std * std_mlii
            loc_mlii = locs_mlii(i);
            pk_mlii = pks_mlii(i);

            locs_m = [locs_m; loc_mlii];
            pks_m = [pks_m; pk_mlii];

        end
    end
    
    if strcmp(if_plot, 'True') == 1
        fig_mlii = figure;
        
        subplot(2,1,1);
        plot(locs_m, pks_m, '*');
        
        subplot(2,1,2);
        plot(t_mlii, abs(mv_mlii));
        
        saveas(fig_mlii, 'Peaks MLII.png');
    end
    
    rr_mlii = [];
    for i = 2:length(pks_m)
        diff_mlii = locs_m(i)-locs_m(i-1);
        rr_mlii = [rr_mlii, diff_mlii];
    end

    % DESCRIPTIVE STATISTICS - RR MLII

    quants_mlii = [0.25 0.75];
    rr_time_mlii = rr_mlii / fs;
    rr_mean_mlii = mean(rr_time_mlii);
    rr_std_mlii = std(rr_time_mlii);
    rr_median_mlii = median(rr_time_mlii);
    rr_25_mlii = quantile(rr_time_mlii, quants_mlii(:,1));
    rr_75_mlii = quantile(rr_time_mlii, quants_mlii(:,2));
    rr_stats_mlii = [rr_mean_mlii, rr_std_mlii, rr_median_mlii, ...
                    rr_25_mlii, rr_75_mlii];

    stats_labels_mlii = {'Mean MLII','STDEV MLII','Median MLII',...
                        '25th MLII','75th MLII'};

    table_stats_mlii = table(stats_labels_mlii', rr_stats_mlii');
    
    % R-R interval V1
    v1_0 = v1 - mean(v1);
    std_v1 = std(v1_0);

    locs_v = [];
    pks_v = [];

    for i = 1:length(pks_v1)
        if pks_v1(i) > cons_std * std_v1
            loc_v1 = locs_v1(i);
            pk_v1 = pks_v1(i);

            locs_v = [locs_v; loc_v1];
            pks_v = [pks_v; pk_v1];
        end
    end
    
    if strcmp(if_plot, 'True') == 1
        fig_v1 = figure;
        
        subplot(2,1,1);
        plot(locs_v, pks_v, '*');
        
        subplot(2,1,2);
        plot(t_v1, abs(mv_v1));
        
        saveas(fig_v1, 'Peaks V1.png')
    end
    
    rr_v1 = [];
    for i = 2:length(pks_v)
        diff_v1 = locs_v(i)-locs_v(i-1);
        rr_v1 = [rr_v1, diff_v1];
    end

    % DESCRIPTIVE STATISTICS - RR MLII

    quants_v1 = [0.25 0.75];
    rr_time_v1 = rr_v1 / fs;
    rr_mean_v1 = mean(rr_time_v1);
    rr_std_v1 = std(rr_time_v1);
    rr_median_v1 = median(rr_time_v1);
    rr_25_v1 = quantile(rr_time_v1, quants_v1(:,1));
    rr_75_v1 = quantile(rr_time_v1, quants_v1(:,2));
    rr_stats_v1 = [rr_mean_v1, rr_std_v1, rr_median_v1, ...
                    rr_25_v1, rr_75_v1];

    stats_labels_v1 = {'Mean V1','STDEV V1','Median V1',...
                        '25th V1','75th V1'};

    table_stats_v1 = table(stats_labels_v1', rr_stats_v1');
    
    rr_sigs = {rr_mlii, rr_v1, table_stats_mlii, table_stats_v1};

end