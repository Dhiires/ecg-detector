%% HRV functions frequency domain

%% Main function

function metrics = FreqDomainHRV(intervals)
    if length(intervals) < 10
        metrics = nan(1,6);
        return
    end
    peakfreq = PeakFreq(intervals);
    %peakfreq_VLF = peakfreq(1);
    peakfreq_LF = peakfreq(2);
    peakfreq_HF = peakfreq(3);
    
    normpower = NormalizedPower(intervals);
    normpower_LF = normpower(1);
    normpower_HF = normpower(2);

    lfhfratio = LFHFratio(intervals);
    totpower = TotalPower(intervals);

    metrics = [peakfreq_LF, peakfreq_HF, normpower_LF, normpower_HF, lfhfratio, totpower];
end

% Peak Frequency
function pf = PeakFreq(array)
    [~,~,~,~,~,~,f,Y,NFFT] = HRV.fft_val_fun(array,250);
    YY = 2*abs(Y(1:NFFT/2+1));
    YY = YY.^2;
    
    peak_VLF = max(YY(f<=.04));
    peak_LF  = max(YY(f<=.15 & f>=.04));
    peak_HF  = max(YY(f<=.40 & f>=.15));
    
    if isnan(peak_VLF)
        f_peak_VLF = NaN;
    else
        f_peak_VLF = f(YY==peak_VLF);
    end

    if isnan(peak_VLF)
        f_peak_LF = NaN;
    else
        f_peak_LF = f(YY==peak_LF);
    end

    if isnan(peak_VLF)
        f_peak_HF = NaN;
    else
        f_peak_HF = f(YY==peak_HF);
    end

    pf = [f_peak_VLF, f_peak_LF, f_peak_HF];
end

% Normalized Power
function np = NormalizedPower(array)
    [pLF,pHF,~,~,~,~,~,~,~] = HRV.fft_val_fun(array,250);
    np = [pLF,pHF];
end

% Low Frequency, High Frequency ratio
function lhr = LFHFratio(array)
    [~,~,lhr,~,~,~,~,~,~] = HRV.fft_val_fun(array,250);
end

% Total Power
function tp = TotalPower(array)
    [~,~,~,VLF,LF,HF,~,~,~] = HRV.fft_val_fun(array,250);
    tp = VLF+LF+HF;
end