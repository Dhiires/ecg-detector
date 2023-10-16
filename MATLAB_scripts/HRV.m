%% Ground Truth
L = length(ipeaks);
pre_intervals = zeros(N+1,1);
j = 1;
for i = 1:L
    if ipeaks(i,1) == 1
        pre_intervals(j,1) = i;
        j = j+1;
    end
end

intervals = diff(pre_intervals)/sfecg;
intervals = intervals(1:end-1);

RR_buffer = zeros(N,8);

% Leer archivos RR_peaks
% 'ECG_hrstd_Anoise_hrmean.tsv'
% 'RR_peaks/RR_hrstd_Anoise_hrmean/RR_'
% str_1 = 'RR_peaks/RR_'+string(hrstd)+'_'+string(Anoise)+'_'+string(hrmean)+'/RR_';
str_1 = 'RR_peaks/RR_peaks_w_w_120/RR_';

for i = 0:7
    path = strcat(str_1,string(i),'.txt');
    aux = readtable(path,'Delimiter','\t');
    aux = table2array(aux);
    aux_L = length(aux);
    RR_buffer(1:aux_L,i+1) = aux;
end

hr_string = " HR = " + string(hrmean) + ", ";
std_string = "STD = " + string(hrstd) + ", ";
noise_string = "NOISE = " + string(Anoise);

%% RR mean 

true_RR_mean = mean(intervals);
RR_buffer_mean = mean(RR_buffer);
metrics_RR_mean = [true_RR_mean RR_buffer_mean];

%% RR standard deviation

true_SDNN = std(intervals);
RR_buffer_SDNN = std(RR_buffer);
metrics_RR_SDNN = [true_SDNN RR_buffer_SDNN];

%% HR mean

true_HR_mean = mean(60.*intervals/sfecg);
RR_buffer_HR_mean = mean(60.*RR_buffer/sfecg);
metrics_HR_mean = [true_HR_mean RR_buffer_HR_mean];

%% HR standard deviation

true_HR_std = std(60.*intervals/sfecg);
RR_buffer_HR_std = std(60.*RR_buffer/sfecg);
metrics_HR_std = [true_HR_std RR_buffer_HR_std];

%% RMSSD 

true_RMSSD = RMSSD(intervals);
RR_buffer_RMSSD = [RMSSD(RR_buffer(:,1)) RMSSD(RR_buffer(:,2)) RMSSD(RR_buffer(:,3)) RMSSD(RR_buffer(:,4)) RMSSD(RR_buffer(:,5)) RMSSD(RR_buffer(:,6)) RMSSD(RR_buffer(:,7)) RMSSD(RR_buffer(:,8))];
metrics_RMSSD = [true_RMSSD RR_buffer_RMSSD];

%% pNN50

true_pNN50 = pNN50(intervals);
RR_buffer_pNN50 = [pNN50(RR_buffer(:,1)) pNN50(RR_buffer(:,2)) pNN50(RR_buffer(:,3)) pNN50(RR_buffer(:,4)) pNN50(RR_buffer(:,5)) pNN50(RR_buffer(:,6)) pNN50(RR_buffer(:,7)) pNN50(RR_buffer(:,8))];
metrics_pNN50 = [true_pNN50 RR_buffer_pNN50];

%% HRV Triangular index

true_TRINDEX = TRINDEX(intervals);
RR_buffer_TRINDEX = [TRINDEX(RR_buffer(:,1)) TRINDEX(RR_buffer(:,2)) TRINDEX(RR_buffer(:,3)) TRINDEX(RR_buffer(:,4)) TRINDEX(RR_buffer(:,5)) TRINDEX(RR_buffer(:,6)) TRINDEX(RR_buffer(:,7)) TRINDEX(RR_buffer(:,8))];
metrics_TRINDEX = [true_TRINDEX RR_buffer_TRINDEX];

%% TINN

true_TINN = TINN(intervals);
RR_buffer_TINN = [TINN(RR_buffer(:,1)) TINN(RR_buffer(:,2)) TINN(RR_buffer(:,3)) TINN(RR_buffer(:,4)) TINN(RR_buffer(:,5)) TINN(RR_buffer(:,6)) TINN(RR_buffer(:,7)) TINN(RR_buffer(:,8))];
metrics_TINN = [true_TINN RR_buffer_TINN];

%% FILE CREATION

metrics = [metrics_RR_mean; metrics_RR_SDNN; metrics_HR_mean; metrics_HR_std; metrics_RMSSD; metrics_pNN50; metrics_TRINDEX; metrics_TINN];

writematrix(metrics,strcat('metrics',hr_string,std_string,noise_string,'.txt'),'Delimiter','\t','FileType','text');

%% FUNCTIONS

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