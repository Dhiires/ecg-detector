%% Read files names
clear; clc; close all;
list = dir('DB_RR_intervals');
sfecg = 250;
N = 128;
lfhfratio = 0.5;
sfint = 250;
ti = [-70 -15 0 15 100];
ai = [1.2 -5 30 -7.5 0.75];
bi = [0.25 0.1 0.1 0.1 0.4];

% Create table
names = categorical({'True HR','Two Average','Matched Filter','SWT','Engzee','Christov','Hamilton','Pan Tompkins','WQRS'});
names = reordercats(names,{'True HR','Two Average','Matched Filter','SWT','Engzee','Christov','Hamilton','Pan Tompkins','WQRS'});
heart_rates = string([linspace(40,180,15)]);
tableNames = {'True HR';'Two Average';'Matched Filter';'SWT';'Engzee';'Christov';'Hamilton';'Pan Tompkins';'WQRS'};
sz = [9*125 9];
varNames = ["Metodo" "Activity" "Subject" "Promedio" "Desviacion" "RMSSD" "PNN50" "TRINDEX" "TINN"];
varTypes = ["string" "string" "string" "double" "double" "double" "double" "double" "double"];
TimeDomainHRV_table = table('Size',sz,'VariableTypes',varTypes,'VariableNames',varNames);

%% Fill table

f = waitbar(0,'Leyendo intervalos RR');
offset = 0;
for i = 3:25:length(list)
    sub_list = list(i:i+24);

    for j = 1:25
        file_name = sub_list(j).name;
        file_name_parts = split(file_name,'_');
        aux = [file_name_parts(2), file_name_parts(4)];
        activity = aux(1); subject = aux(2);

        % Read annotations
        path = 'DB_RR_intervals/'+string(file_name)+'/annotation_'+ ...
            string(activity)+'_subject_'+string(subject)+'.txt';
        true_peaks = readtable(path,'Delimiter','\t');
        true_peaks = table2array(true_peaks);

        if isempty(true_peaks)
            metrics = nan(9,6);
            for k = 1:9
                TimeDomainHRV_table.Metodo(k+offset) = tableNames(k);
                TimeDomainHRV_table.Subject(k+offset) = subject;
                TimeDomainHRV_table.Activity(k+offset) = activity;
                TimeDomainHRV_table.Promedio(k+offset) = metrics(k,1);
                TimeDomainHRV_table.Desviacion(k+offset) = metrics(k,2);
                TimeDomainHRV_table.RMSSD(k+offset) = metrics(k,3);
                TimeDomainHRV_table.PNN50(k+offset) = metrics(k,4);
                TimeDomainHRV_table.TRINDEX(k+offset) = metrics(k,5);
                TimeDomainHRV_table.TINN(k+offset) = metrics(k,6);
            end
            offset = offset + 9;
            continue
        end

        true_RR = diff(true_peaks)/sfecg;

        % Read detections
        [RR_1, RR_2, RR_3, RR_4, RR_5, RR_6, RR_7, RR_8] = ...
            READFILE(activity,subject);

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

        for k = 1:9
            TimeDomainHRV_table.Metodo(k+offset) = tableNames(k);
            TimeDomainHRV_table.Subject(k+offset) = subject;
            TimeDomainHRV_table.Activity(k+offset) = activity;
            TimeDomainHRV_table.Promedio(k+offset) = metrics(k,1);
            TimeDomainHRV_table.Desviacion(k+offset) = metrics(k,2);
            TimeDomainHRV_table.RMSSD(k+offset) = metrics(k,3);
            TimeDomainHRV_table.PNN50(k+offset) = metrics(k,4);
            TimeDomainHRV_table.TRINDEX(k+offset) = metrics(k,5);
            TimeDomainHRV_table.TINN(k+offset) = metrics(k,6);
        end
        offset = offset + 9;
    end
    waitbar(i/length(list),f,'Calculando...')
end
waitbar(1,f,'Finalizado')
disp("LISTO")

%% Error calculation
siz = [8*125 9];
error_table = table('Size',siz,'VariableTypes',varTypes,'VariableNames',varNames);
j = 1;

for i = 1:9:height(TimeDomainHRV_table)
    error_table(j:j+7,1:3) = TimeDomainHRV_table(i+1:i+8,1:3);

    aux_array = table2array(TimeDomainHRV_table(i:i+8,4:9));
    Prom_error = GetError(aux_array(:,1));
    Desv_error = GetError(aux_array(:,2));
    RMSS_error = GetError(aux_array(:,3));
    PNN5_error = GetError(aux_array(:,4));
    TRIN_error = GetError(aux_array(:,5));
    TINN_error = GetError(aux_array(:,6));

    error_table.Promedio    (j:j+7) = Prom_error(2:end);
    error_table.Desviacion  (j:j+7) = Desv_error(2:end);
    error_table.RMSSD       (j:j+7) = RMSS_error(2:end);
    error_table.PNN50       (j:j+7) = PNN5_error(2:end);
    error_table.TRINDEX     (j:j+7) = TRIN_error(2:end);
    error_table.TINN        (j:j+7) = TINN_error(2:end);
    j=j+8;
end
disp("Errores calculados")

%% File Saving

writetable(TimeDomainHRV_table, 'RealMetrics/metricas_HRV_TimeDomain.csv');
writetable(error_table, 'RealMetrics/error_metricas_HRV_TimeDomain.csv');

%% FUNCTIONS

function [RR_1, RR_2, RR_3, RR_4, RR_5, RR_6, RR_7, RR_8] = READFILE(activity, subject)
    % Leer archivos RR_peaks
    dir = 'DB_RR_intervals/RR_'+string(activity)+'_subject_'+string(subject)+'/RR_';

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