%% Metrics compiler

%% Function
%[RRmean, RRstd, rmssd, pnn50, trindex, tinn]
function matrix = CompileMetrics(metrics)
    means = metrics(:,1);
    stds = metrics(:,2);
    rmssd = metrics(:,3);
    pnn = metrics(:,4);
    trindex = metrics(:,5);
    tinn = metrics(:,6);
    matrix = [rr0 rr1 rr2 rr3 rr4 rr5 rr6 rr7 rr8];
end