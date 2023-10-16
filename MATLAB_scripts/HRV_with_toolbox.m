%% HRV using toolbox full RR
% Vollmer, Marcus. "HRVTool - an Open-Source Matlab Toolbox for Analyzing 
% Heart Rate Variability.” 2019 Computing in Cardiology Conference (CinC), 
% Computing in Cardiology, 2019, doi:10.22489/cinc.2019.032.

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
dir = 'RR_peaks/RR_'+string(hrstd)+'_'+string(Anoise)+'_'+string(hrmean)+'/RR_';

for i = 0:7
    path = strcat(dir,string(i),'.txt');
    aux = readtable(path,'Delimiter','\t');
    aux = table2array(aux);
    aux_L = length(aux);
    RR_buffer(1:aux_L,i+1) = aux;
end

hr_string = " HR = " + string(hrmean) + ", ";
std_string = "STD = " + string(hrstd) + ", ";
noise_string = "NOISE = " + string(Anoise);
