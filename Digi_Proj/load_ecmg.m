function cb_sigs = load_ecmg(seed, sec, Fs, scales, notCool, if_plot)
    sig = BuildCombinedSignal(seed, sec, Fs, scales, notCool);
    sigs = {sig(1,:), sig(2,:), sig(3,:), sig(4,:), sig(5,:), ...
        sig(6,:), sig(7,:)};
    if strcmp(if_plot, 'True') == 1
        fig1 = figure;
        subplot(2,1,1)
        plot(sigs{1}, sigs{3})
        subplot(2,1,2)
        pwelch(sigs{3})
        saveas(fig1, 'Signals_1_VS_3.png')
        
        fig2 = figure;
        subplot(2,1,1)
        plot(sigs{1}, sigs{5})
        subplot(2,1,2)
        pwelch(sigs{5})
        saveas(fig2, 'Signals_1_VS_5.png')
        
        fig3 = figure;
        subplot(2,1,1)
        plot(sigs{1}, sigs{6})
        subplot(2,1,2)
        pwelch(sigs{6})
        saveas(fig3, 'Signals_1_VS_6.png')
        
        fig4 = figure;
        subplot(2,1,1)
        plot(sigs{1}, sigs{7})
        subplot(2,1,2)
        pwelch(sigs{7})  
        saveas(fig4, 'Signals_1_VS_7.png')
    end
    
    cb_sigs = sigs;
end