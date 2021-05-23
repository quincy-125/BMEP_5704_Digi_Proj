
function wOutputs = wFilter(input,Fs,fWavelet,bWidth,plots)
    % Filters a single column (or row) vector using wavelet-based 
    % filtering. The user defines the wavelet centre frequencies. 
    % Function inputs %
    %   1) input: this is the input data. It must be a single column or row
    %      vector.
    %   2) Fs: the sampling rate (in Hz) at which the input data was 
    %      collected.
    %   3) fWavelet: wavelet centre frequencies. In the frequency domain, 
    %      the wavelets consist of a Gaussian function of frequency with 
    %      centre frequency represented by the peak of the Gaussian. 
    %      Centre frequencies (fWavelet) can consist of a single frequency
    %      or multiple frequencies (e.g. [10 20 50]). Frequencies in Hz.
    %   4) bWidth: the wavelets bandwidth (Hz). Bandwidth is taken as 1 standard
    %      deviation of the wavelets Gaussian function in the frequency 
    %      domain. 
    %   5) plots: input a 1 to turn plots on and a 0 to turn plots off.
    % Function outputs (wOutputs) %
    % The output from the function consists of three arrays. The first is 
    % the wavelet-filtered signals, i.e. the input signal but filtered 
    % using the wavelets. The wavelet-filtered signals are in order 
    % (1st to last column) of the input frequencies (fWavelet). The second
    % array consists of the wavelets used for the filtering, again in order
    % (1st to last column) of the input frequencies (fWavelet). The third 
    % array consists of peak-to-peak amplitudes of the wavelet-filtered
    % signals. Peak-to-peak amplitude is taken as 6 standards deviations of
    % the wavelet-filtered signal.
    % Examples %
    
    %   1) wOutputs = wFilter(data,20000,[10 20 40 80 160],1,1);
    %           input data (data) is filtered using one of five wavelets 
    %           centred at 10, 20, 40, 80 and 160 Hz. Each wavelet has a
    %           bandwidth of 1 Hz in the frequency domain. The sampling
    %           rate of the input data is 20 kHz. Plots are turned on.
    %   2) wOutputs = wFilter(data,10000,50,10,0);
    %           input data (data) is filtered using one wavelet centred
    %           at 50 Hz. The wavelet has a bandwidth of 10 Hz. The 
    %           sampling rate of the input signal is 10 kHz. Plots are
    %           turned off.
    %%%%%%%%% Function %%%%%%%%%
    
    SP=1/Fs; % sampling period
    input = input-mean(input); % forces mean of the input data to zero
    % transposes input data if in columns and not rows
    if size(input,2) > 1
        input = input';
    end
    % Warnings and errors %
    
    if sum((fWavelet-(bWidth*3))<0) >= 1
        warning(['wavelet bandwidth (bWidth) too large to fully' ...
        ' represent one or more of the lower frequency (fWavelet)' ...
        ' wavelets in the frequency domain. Cannot generate wavelet' ...
        ' frequencies less than 0 Hz. Consider a smaller bandwidth or' ...
        ' removing some of the lower frequency wavelets'])
    end
    if length(fWavelet) > 100
        warning(['large number of wavelet freqencies (fWavelet)' ...
        ' specified. Computation therefore heavy. If unresponsive,' ...
        ' consider using less frequencies.']);
    end
    if sum(fWavelet>(Fs/2)) >= 1
        error(['Error: One or more specified wavelet centre frequencies'...
        ' larger than the Nyquist frequency. Remove these frequencies' ... 
        ' before continuing.']);
    end
    if sum(length(input) < (Fs./fWavelet)) >= 1
        error(['Error: input signal too short to filter with one or'...
        ' more of the lower frequency wavelets. Ensure the length of' ...
        ' the input signal is longer than one phase (single period)' ...
        ' length for all input frequencies (e.g. 250 ms for 4 Hz).']);
    end
    % Generates wavelets %
    
    fprintf('\nGenerating wavelets....');
    allWavelets = repmat({[]},1,length(fWavelet));
    for i = 1:length(fWavelet) % loop through the wavelet frequencies
        % Gaussian %
        SDx = (Fs/bWidth)*0.11245; % SD of Gaussian determined by bWidth.
        % 0.11245 needed to convert the bandwidth from Hz to samples.
        xGaussian = -(SDx*5):1:(SDx*5); 
        yGaussian = gaussmf(xGaussian,[SDx 0]);
        % sinewave %
        t=(-((length(yGaussian )*SP)/2)):SP:((length(yGaussian )*SP)/2)-SP;
        sine=(sin(2*pi*fWavelet(i)*t+(pi/2))); % pi/2 needed to align the 
        % peak of the Gaussian and a peak of the sine wave.
        % Wavelet %
        wavelet = yGaussian.*sine; % wavelet consists of the sine wave
        % mutiplied with the Gaussian. In frequency domain, the wavelet 
        % is a gaussian function of frequency with the point of one SD
        % matching the input bandwidth (bWidth).
        wavelet=wavelet/sum(abs(wavelet)); % normalises wavelet to make
        % total area = 1.
        % collects all wavelets (at all centre frequencies) %
        allWavelets{i} = wavelet';
    end
    fprintf(' complete');
    
    % Filtering %
    
    % Generates the wavelet-filtered signals by convolving the input signal
    % with each wavelet. Wavelet-filtered signals are subsequently stored
    % in the variable called Filtered. Performs convolution in the frequency
    % domain to decrease computation requirements and processing time.
    
    fprintf('\nFiltering signal using %s wavelets. Completed: ',num2str(length(fWavelet)));
    lenConv = length(input) + length(allWavelets{1}) - 1; % length of convolution
    fftSignal = fft(input,lenConv); % fft of the input signal
    filHalfLength = floor(length(allWavelets{1})/2); % half the length of a wavelet
    Filtered = NaN(length(input),length(fWavelet)); % matrix of NaNs to add filtered data to
    for i = 1:length(allWavelets)
        fftWavelet = fft(allWavelets{i},lenConv); % fft of current wavelet
        convFreq = fftSignal .* fftWavelet; % convolution in frequency domain
        convTime = real(ifft(convFreq)); % convert to the time domain
        Filtered(:,i) = convTime(filHalfLength+1:filHalfLength+length(input));
        % display counter
        if i > 1
            for blahBlah = 0:log10(i-1)
                fprintf('\b');
            end
        end
        fprintf('%s',num2str(i));
    end
    
    amplitude = std(Filtered)*6; % peak-to-peak amplitude taken as 6*SD
    % Figures %
    % The below while loop plots all the wavelet-filtered signals. 
    % The scale of the y-axis on all wavelet-filtered signals
    % is determined by the maximum wavelet-filtered signal amplitude.
    % This allows a visual comparison of signal amplitude across wavelet 
    % centre frequencies.
    sets = 1:3:30000;
    ax = max(abs(Filtered(:))); 
    axl = length(input);
    j = 1;
    curSet = sets(j):1:sets(j+1)-1;
    if plots == 1
        while curSet(1) <= length(fWavelet)
            figure
            subplot(4,1,1);
            plot(input,'Color','k');
            set(subplot(4,1,1),'xtick',[],'color','none','box','off', ...
                'xcolor','none');
            axis([0,axl,-inf,inf]);
            title(subplot(4,1,1),'Raw data');
            subplot(4,1,2);
            plot(Filtered(:,curSet(1)),'Color','b');
            axis([0,axl,-ax,ax]);
            title(subplot(4,1,2),['filtered: ' num2str(fWavelet(curSet...
                (1))) ' Hz']);
            xlabel(subplot(4,1,2),'samples','FontSize',14);
            if curSet(2) <= length(fWavelet)
                subplot(4,1,3);
                plot(Filtered(:,curSet(2)),'Color','b');
                axis([0,axl,-ax,ax]);
                title(subplot(4,1,3),['filtered: ' num2str(fWavelet...
                    (curSet(2))) ' Hz']);
                xlabel(subplot(4,1,2),'');
                xlabel(subplot(4,1,3),'samples','FontSize',14);
            end
            if curSet(3) <= length(fWavelet)
                subplot(4,1,4);
                plot(Filtered(:,curSet(3)),'Color','b');
                axis([0,axl,-ax,ax]);
                title(subplot(4,1,4),['filtered: ' num2str(fWavelet...
                    (curSet(3))) ' Hz']);
                xlabel(subplot(4,1,3),'');
                xlabel(subplot(4,1,4),'samples','FontSize',14);
            end
            j = j+1;
            curSet = sets(j):1:sets(j+1)-1;
        end
        
        % plots the peak-to-peak amplitude of all wavelet-filtered signals,
        % taken as 6*SDs of the signal
        figure
        scatter(fWavelet,amplitude,'filled','r');
        title('Wavelet-filtered signal amplitudes')
        xlabel('Wavelet frequency (Hz)');
        ylabel('Amplitude');
    elseif plots ~= 0 && plots ~= 1
            
        warning('Input variables ''plots'' does not equal 0 or 1. Not plotting anything');
    end
    
    % Function output %
    
    wOutputs = [{Filtered} {cell2mat(allWavelets)} {amplitude}];
    
end
