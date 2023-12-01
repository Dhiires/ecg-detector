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

    if length(intervals) < 2
        metrics = nan(1,6);
    end
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
    pnn = HRV.pNN50(array,0,0);
end

% HRV triangular index
function tri = TRINDEX(array)
    [tri,~] = HRV.triangular_val(array, 0);
end

% TINN
function tinn = TINN(array)
    [~,tinn] = HRV.triangular_val(array,0);
end