% function to load ECG signals from downloaded data files
function ecgs = load_ecg(signame, infoname, if_plot)
    Octave = exist('OCTAVE_VERSION');
    load(signame);
    fid = fopen(infoname, 'rt');
    fgetl(fid);
    fgetl(fid);
    fgetl(fid);
    [freqint] = sscanf(fgetl(fid), ...
    'Sampling frequency: %f Hz  Sampling interval: %f sec');
    interval = freqint(2);
    fgetl(fid);

    if(Octave)
        for i = 1:size(val, 1)
           R = strsplit(fgetl(fid), char(9));
           signal{i} = R{2};
           gain(i) = str2num(R{3});
           base(i) = str2num(R{4});
           units{i} = R{5};
        end
    else
        for i = 1:size(val, 1)
          [row(i), signal(i), gain(i), base(i), units(i)] ...
              = strread(fgetl(fid),'%d%s%f%f%s','delimiter','\t');
        end
    end

    fclose(fid);
    val(val==-32768) = NaN;
    
    for i = 1:size(val, 1)
        val(i, :) = (val(i, :) - base(i)) / gain(i);
    end

    x = (1:size(val, 2)) * interval;
    
    ecg_sigs = val;
    time = x;
    
    if strcmp(if_plot, 'True') == 1
        fig_atm = figure;
        plot(time', ecg_sigs');

        for i = 1:length(signal)
            labels{i} = strcat(signal{i}, ' (', units{i}, ')'); 
        end

        legend(labels);
        title('118e00m Combined Signals');
        xlabel('Time (sec)');
        ylabel('ECG Signals (mv)')
        saveas(fig_atm, '118e00m_ATM_plot.png');
    end
    
    ecgs = {ecg_sigs, time};
    
end