%% Read files names
clear; clc;
list = dir('RR_intervals2');
sfecg = 250;
N = 128;
lfhfratio = 0.5;
sfint = 250;
ti = [-70 -15 0 15 100];
ai = [1.2 -5 30 -7.5 0.75];
bi = [0.25 0.1 0.1 0.1 0.4];
X = [7 8 9 10 11 12 13 14 15 1 2 3 4 5 6];
[Xsorted, I] = sort(X);

% Create table
names = categorical({'True HR','Two Average','Matched Filter','SWT','Engzee','Christov','Hamilton','Pan Tompkins','WQRS'});
names = reordercats(names,{'True HR','Two Average','Matched Filter','SWT','Engzee','Christov','Hamilton','Pan Tompkins','WQRS'});
heart_rates = string([linspace(40,180,15)]);
tableNames = {'True HR';'Two Average';'Matched Filter';'SWT';'Engzee';'Christov';'Hamilton';'Pan Tompkins';'WQRS'};
sz = [9*15*12 10];
varNames = ['Metodo' "HR" "LFpeak" "HFpeak" "NormPowerLF" "NormPowerHF" "LFHFratio" "TotalPower" "sigma" "noise"];
varTypes = ["string" "string" "double" "double" "double" "double" "double" "double" "double" "double"];
FreqDomainHRV_table = table('Size',sz,'VariableTypes',varTypes,'VariableNames',varNames);

%% Fill table
aux = zeros(1,3);
offset = 0;
f = waitbar(0,'Leyendo intervalos RR','Name','Heatmaps');
for i = 3:15:length(list)

    sub_list = list(i:i+14);
    ListSorted = sub_list(I);

    for j = 1:15
        file_name = ListSorted(j).name;
        file_name_parts = split(file_name,'_');
        aux = str2double([file_name_parts(2),file_name_parts(3),file_name_parts(4)]);
        file_std = aux(1); file_noise = aux(2); file_hr = aux(3);

        [~, true_ipeaks] = ecgsyn(sfecg,N,0,file_hr,file_std,lfhfratio,sfint,ti,ai,bi);
        true_RR = GroundTruth(true_ipeaks,N,sfecg);

        [RR_1, RR_2, RR_3, RR_4, RR_5, RR_6, RR_7, RR_8] = ...
            READFILE(file_std,file_noise,file_hr);

        TD_metrics_RR_0 = FreqDomainHRV(true_RR);
        TD_metrics_RR_1 = FreqDomainHRV(RR_1);
        TD_metrics_RR_2 = FreqDomainHRV(RR_2);
        TD_metrics_RR_3 = FreqDomainHRV(RR_3);
        TD_metrics_RR_4 = FreqDomainHRV(RR_4);
        TD_metrics_RR_5 = FreqDomainHRV(RR_5);
        TD_metrics_RR_6 = FreqDomainHRV(RR_6);
        TD_metrics_RR_7 = FreqDomainHRV(RR_7);
        TD_metrics_RR_8 = FreqDomainHRV(RR_8);

        metrics = [TD_metrics_RR_0;TD_metrics_RR_1;TD_metrics_RR_2; ...
                   TD_metrics_RR_3;TD_metrics_RR_4; ...
                   TD_metrics_RR_5;TD_metrics_RR_6; ...
                   TD_metrics_RR_7;TD_metrics_RR_8];

        for k = 1:9
            FreqDomainHRV_table.Metodo(k+offset) = tableNames(k);
            FreqDomainHRV_table.HR(k+offset) = heart_rates(j);
            FreqDomainHRV_table.LFpeak(k+offset) = metrics(k,1);
            FreqDomainHRV_table.HFpeak(k+offset) = metrics(k,2);
            FreqDomainHRV_table.NormPowerLF(k+offset) = metrics(k,3);
            FreqDomainHRV_table.NormPowerHF(k+offset) = metrics(k,4);
            FreqDomainHRV_table.LFHFratio(k+offset) = metrics(k,5);
            FreqDomainHRV_table.TotalPower(k+offset) = metrics(k,6);
            FreqDomainHRV_table.sigma(k+offset) = file_std;
            FreqDomainHRV_table.noise(k+offset) = file_noise;
        end
        offset = offset+9;
    end
    waitbar(i/length(list), f, 'Calculando...')
end
waitbar(1,f,'Finalizado')
disp("LISTO")

%% Error calculation
siz = [8*180 10];
error_table = table('Size',siz,'VariableTypes',varTypes,'VariableNames',varNames);
j = 1;

for i = 1:9:height(FreqDomainHRV_table)
    error_table(j:j+7,1:2) = FreqDomainHRV_table(i+1:i+8,1:2);
    error_table(j:j+7,9:10) = FreqDomainHRV_table(i+1:i+8,9:10);

    aux_array = table2array(FreqDomainHRV_table(i:i+8,3:8));
    LFP_error = GetError(aux_array(:,1));
    HFP_error = GetError(aux_array(:,2));
    NLF_error = GetError(aux_array(:,3));
    NHF_error = GetError(aux_array(:,4));
    LHR_error = GetError(aux_array(:,5));
    ToP_error = GetError(aux_array(:,6));

    error_table.LFpeak      (j:j+7) = LFP_error(2:end);
    error_table.HFpeak      (j:j+7) = HFP_error(2:end);
    error_table.NormPowerLF (j:j+7) = NLF_error(2:end);
    error_table.NormPowerHF (j:j+7) = NHF_error(2:end);
    error_table.LFHFratio   (j:j+7) = LHR_error(2:end);
    error_table.TotalPower  (j:j+7) = ToP_error(2:end);
    j=j+8;
end
disp("Errores calculados")

%% File Saving

writetable(FreqDomainHRV_table, 'SyntheticMetrics/metricas_HRV_FreqDomain.csv');
writetable(error_table, 'SyntheticMetrics/error_metricas_HRV_FreqDomain.csv');
%% FUNCTIONS

function [RR_1, RR_2, RR_3, RR_4, RR_5, RR_6, RR_7, RR_8] = READFILE(hrstd, Anoise, hrmean)
    % Leer archivos RR_peaks
    % 'RR_peaks/RR_hrstd_Anoise_hrmean/RR_'
    dir = 'RR_intervals2/RR_'+string(hrstd)+'_'+string(Anoise)+'_'+string(hrmean)+'/RR_';

    for i = 0:7
        path = strcat(dir,string(i),'.txt');
        aux = readtable(path,'Delimiter','\t');
        aux = table2array(aux);
        switch (i+1)
            case 1
                RR_1 = aux;
            case 2
                RR_2 = aux;
            case 3
                RR_3 = aux;
            case 4
                RR_4 = aux;
            case 5
                RR_5 = aux;
            case 6
                RR_6 = aux;
            case 7
                RR_7 = aux;
            case 8
                RR_8 = aux;
            otherwise
                print('error')
        end        
    end
end

% TRUE RR
function inter = GroundTruth(peaks, num, fs)
    L = length(peaks);
    pre = zeros(num+1,1);
    j = 1;
    for i = 1:L
        if peaks(i,1) == 3
            pre(j,1) = i;
            j = j+1;
        end
    end
    inter = diff(pre)/fs;
    inter = inter(1:end-1);
end