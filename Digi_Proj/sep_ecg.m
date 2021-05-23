% function to split ECG signals into MLII and V1 signals
function sep_sigs = sep_ecg(signame, infoname, if_plot)
    ecgs = load_ecg(signame, infoname, if_plot);
    ecg_sigs = ecgs{1};
    time = ecgs{2};
    
    MLII = ecg_sigs(1, :);
    V1 = ecg_sigs(2, :);
    
    if strcmp(if_plot, 'True') == 1
        fig = figure;

        subplot(2, 1, 1);
        plot(time, MLII, '-r');
        title('MLII (mv)');

        subplot(2, 1, 2);
        plot(time, V1, '-b');
        title('V1 (mv)');

        saveas(fig, 'ECG Separate Signals.png');
    end
    
    sep_sigs = {MLII, V1, time};
end