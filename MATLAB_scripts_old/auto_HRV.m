%% Orden

% Obtener lista de RR_intervals (list = dir('RR_intervals')) LISTO
% Por cada item de list obtener list(i).name 
% A list(i).name sacarle std, noise, hr
% Crear ipeaks [~, ipeaks] = ecgsyn(sfecg,N,file_noise,file_hr,file_std,lfhfratio,sfint,ti,ai,bi);
% Crear intervals (Ground Truth) (convertir a función)

%% Read files names
clear; clc;
list = dir('RR_intervals');
sfecg = 250;
N = 128;
lfhfratio = 0.5;
sfint = 250;
ti = [-70 -15 0 15 100];
ai = [1.2 -5 30 -7.5 0.75];
bi = [0.25 0.1 0.1 0.1 0.4];
X = [7 8 9 10 11 12 13 14 15 1 2 3 4 5 6];
[Xsorted, I] = sort(X);

%% Create Table
stat_string = 'Error Promedio Intervalos RR ';

names = categorical({'True HR','Two Average','Matched Filter','SWT','Engzee','Christov','Hamilton','Pan Tompkins','WQRS'});
names = reordercats(names,{'True HR','Two Average','Matched Filter','SWT','Engzee','Christov','Hamilton','Pan Tompkins','WQRS'});
heart_rates = string([linspace(40,180,15)]);
tableNames = {'True HR';'Two Average';'Matched Filter';'SWT';'Engzee';'Christov';'Hamilton';'Pan Tompkins';'WQRS'};
sz = [9*15 10];
varNames = ['Metodo' "HR" "Promedio" "Desviacion" "RMSSD" "PNN50" "TRINDEX" "TINN" "sigma" "noise"];
varTypes = ["string" "string" "double" "double" "double" "double" "double" "double" "double" "double"];
table1 = table('Size',sz,'VariableTypes',varTypes,'VariableNames',varNames);

%%
aux = zeros(1,3);
offset = 0;
for i = 3:15:length(list)

    sub_list = list(i:i+14);
    ListSorted = sub_list(I);

    for j = 1:15
        file_name = ListSorted(j).name;
        file_name_parts = split(file_name,'_');
        aux = str2double([file_name_parts(2),file_name_parts(3),file_name_parts(4)]);
        file_std = aux(1); file_noise = aux(2); file_hr = aux(3);
    
        [~, ipeaks] = ecgsyn(sfecg,N,file_noise,file_hr,file_std,lfhfratio,sfint,ti,ai,bi);
        true_RR = GroundTruth(ipeaks,N,sfecg);
    
        [RR_1, RR_2, RR_3, RR_4, RR_5, RR_6, RR_7, RR_8] = READFILE(file_std,file_noise,file_hr);
        % En este punto se tiene el trueRR y los RR por archivo de la carpeta
        % actual de la iteración, el problema es que no se recorren en orden
        % ascendente de HR
    
        TD_metrics_RR_0 = TimeDomainHRV(true_RR);
        TD_metrics_RR_1 = TimeDomainHRV(RR_1);
        TD_metrics_RR_2 = TimeDomainHRV(RR_2);
        TD_metrics_RR_3 = TimeDomainHRV(RR_3);
        TD_metrics_RR_4 = TimeDomainHRV(RR_4);
        TD_metrics_RR_5 = TimeDomainHRV(RR_5);
        TD_metrics_RR_6 = TimeDomainHRV(RR_6);
        TD_metrics_RR_7 = TimeDomainHRV(RR_7);
        TD_metrics_RR_8 = TimeDomainHRV(RR_8);

        metrics = [TD_metrics_RR_0;TD_metrics_RR_1;TD_metrics_RR_2; ...
                   TD_metrics_RR_3;TD_metrics_RR_4; ...
                   TD_metrics_RR_5;TD_metrics_RR_6; ...
                   TD_metrics_RR_7;TD_metrics_RR_8];

        % Acá tenemos las métricas HRV en el tiempo para una HR específica
        % hay que ingresarla a la tabla

        for k = 1:9
            table1.Metodo(k+offset) = tableNames(k);
            table1.HR(k+offset) = heart_rates(j);
            table1.Promedio(k+offset) = metrics(k,1);
            table1.Desviacion(k+offset) = metrics(k,2);
            table1.RMSSD(k+offset) = metrics(k,3);
            table1.PNN50(k+offset) = metrics(k,4);
            table1.TRINDEX(k+offset) = metrics(k,5);
            table1.TINN(k+offset) = metrics(k,6);
            table1.sigma(k+offset) = file_std;
            table1.noise(k+offset) = file_noise;
        end
        offset = offset+9;
    end
end
disp("LISTO")

%% Error calculation
siz = [8*270 10];
varNames2 = ['Metodo' "HR" "Promedio" "Desviacion" "RMSSD" "PNN50" "TRINDEX" "TINN" "sigma" "noise"];
varTypes2 = ["string" "string" "double" "double" "double" "double" "double" "double" "double" "double"];
error_table = table('Size',siz,'VariableTypes',varTypes2,'VariableNames',varNames2);
j = 1;
for i = 1:9:height(table1)
    error_table(j:j+7,1:2) = table1(i+1:i+8,1:2);
    error_table(j:j+7,9:10) = table1(i+1:i+8,9:10);

    aux_array = table2array(table1(i:i+8,3:8));
    Prom_error = GetError(aux_array(:,1));
    Desv_error = GetError(aux_array(:,2));
    RMSS_error = GetError(aux_array(:,3));
    PNN5_error = GetError(aux_array(:,4));
    TRIN_error = GetError(aux_array(:,5));
    TINN_error = GetError(aux_array(:,6));

    error_table.Promedio    (j:j+7)     = Prom_error(2:end);
    error_table.Desviacion  (j:j+7)     = Desv_error(2:end);
    error_table.RMSSD       (j:j+7)     = RMSS_error(2:end);
    error_table.PNN50       (j:j+7)     = PNN5_error(2:end);
    error_table.TRINDEX     (j:j+7)     = TRIN_error(2:end);
    error_table.TINN        (j:j+7)     = TINN_error(2:end);
    j=j+8;
end

%% File Saving

writetable(table1, 'metricas_HRV_TimeDomain.csv');
writetable(error_table, 'error_metricas_HRV_TimeDomain.csv')
%% FUNCTIONS

function err = GetError(vals)
    err = (vals - vals(1)); %.*100/vals(1);
    err = abs(err);
end

function [RR_1, RR_2, RR_3, RR_4, RR_5, RR_6, RR_7, RR_8] = READFILE(hrstd, Anoise, hrmean)
    % Leer archivos RR_peaks
    % 'RR_peaks/RR_hrstd_Anoise_hrmean/RR_'
    dir = 'RR_intervals/RR_'+string(hrstd)+'_'+string(Anoise)+'_'+string(hrmean)+'/RR_';

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
        if peaks(i,1) == 1
            pre(j,1) = i;
            j = j+1;
        end
    end
    inter = diff(pre)/fs;
    inter = inter(1:end-1);
end