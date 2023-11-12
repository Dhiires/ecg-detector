%% HRV functions time domain

%% Main function

function metrics = TimeDomainHRV(intervals)
    RRmean = mean(intervals);
    RRstd = std(intervals);
    rmssd = RMSSD(intervals);
    pnn50 = pNN50(intervals);
    trindex = TRINDEX(intervals);
    tinn  = TINN(intervals);

    metrics = [RRmean, RRstd, rmssd, pnn50, trindex, tinn];
end

% root mean square of successive differences
function rm = RMSSD(array)
    sum = 0;
    for i = 1:length(array)
        sum = sum + array(i)^2;
    end
    rm = sqrt(sum/(length(array)-1));
end

% intervalos adyacentes mayores a 50ms
function pnn = pNN50(array)
    nn = 0;
    for i = 1:length(array)
        if array(i) > 50e-3
            nn = nn + 1;
        end
    end
    pnn = 100*nn/length(array);
end

% HRV triangular index
function tri = TRINDEX(array)
    min_v = min(array);
    max_v = max(array);
    bins = min_v:0.002:max_v;
    [histogra, ~] = histcounts(array,bins);
    max_hist = max(histogra);

    tri = length(array)/max_hist;
end

% TINN
function tinn = TINN(array)
    min_v = min(array);
    max_v = max(array);
    bins = min_v:0.002:max_v;
    [counts, binEdges] = histcounts(array, bins);
    normalized_counts = counts/length(array);
    half_max = max(normalized_counts) / 2;
    bin_width = mean(diff(binEdges));
    idx = find(normalized_counts >= half_max, 1, 'first');
    tinn = bin_width * (idx - 1);
end