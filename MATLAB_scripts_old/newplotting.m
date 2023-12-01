%% Heatmap Plotting
clear; clc; close all
error_table = readtable("error_metricas_HRV_TimeDomain.csv");
varNames = ['Metodo' "HR" "Promedio" "Desviacion" "RMSSD" "PNN50" "TRINDEX" "TINN"];
title_varNames = ['Metodo' 'HR' "del Promedio" "de la Desviación Estándar" "del RMSSD" "del PNN50" "del TRINDEX" "del TINN"];
heart_rates = string([linspace(40,180,15)]);
%% mean error
close all
f = waitbar(0,'Creando heatmaps','Name','Heatmaps');
sigmaMatrix = zeros(1,18);
noiseMatrix = zeros(1,18);
for j = 1:120:height(error_table)
    for i = 3:8
        figura = figure;
        PosAct = get(figura, 'Position');
        h = heatmap(error_table(j:j+119,:),"HR","Metodo", ...
            'ColorVariable',varNames(i), ...
            'ColorScaling','scaledrows', ...
            'ColorMethod','none');
        h.SourceTable.HR = categorical(h.SourceTable.HR);
        order = heart_rates;
        h.SourceTable.HR = reordercats(h.SourceTable.HR,order);

        sigma = table2array(error_table(j,"sigma"));
        noise = table2array(error_table(j,"noise"));
        
        sigmaMatrix(int32((j-1)/120)+1) = sigma;
        noiseMatrix(int32((j-1)/120)+1) = noise;

        titulo = {"Error "+title_varNames(i)+" de los Intervalos RR"; ... 
            "Desviación Estandar HR: " + string(sigma); ...
            "Ruido añadido: "+string(noise)};
        title(titulo)
        
        PosNue = [2400 300 PosAct(3) PosAct(4)];
        
        set(figura, "Position", PosNue);

        % Configurar márgenes mínimos
        set(gca, 'LooseInset', get(gca, 'TightInset'));

    end
    waitbar(j/(height(error_table)-1), f, 'Procesando...')
end
waitbar(1, f, "Finalizado")

%%
f2 = waitbar(0,'Guardando imagenes','Name','Guardado');
index = 1;
for k = 1:6:108
    waitbar((k+0)/108,f2,'Guardando imagen '+string(k+0)+' de 108')
    saveas(figure(k+0),"TD_HRV_HEAT\MEAN_"+string(sigmaMatrix(index))+"_"+string(noiseMatrix(index))+".pdf")
    waitbar((k+1)/108,f2,'Guardando imagen '+string(k+1)+' de 108')
    saveas(figure(k+1),"TD_HRV_HEAT\DESV_"+string(sigmaMatrix(index))+"_"+string(noiseMatrix(index))+".pdf")
    waitbar((k+2)/108,f2,'Guardando imagen '+string(k+2)+' de 108')
    saveas(figure(k+2),"TD_HRV_HEAT\RMSS_"+string(sigmaMatrix(index))+"_"+string(noiseMatrix(index))+".pdf")
    waitbar((k+3)/108,f2,'Guardando imagen '+string(k+3)+' de 108')
    saveas(figure(k+3),"TD_HRV_HEAT\PNN5_"+string(sigmaMatrix(index))+"_"+string(noiseMatrix(index))+".pdf")
    waitbar((k+4)/108,f2,'Guardando imagen '+string(k+4)+' de 108')
    saveas(figure(k+4),"TD_HRV_HEAT\TRIN_"+string(sigmaMatrix(index))+"_"+string(noiseMatrix(index))+".pdf")
    waitbar((k+5)/108,f2,'Guardando imagen '+string(k+5)+' de 108')
    saveas(figure(k+5),"TD_HRV_HEAT\TINN_"+string(sigmaMatrix(index))+"_"+string(noiseMatrix(index))+".pdf")

    index = index + 1;
end
waitbar(1,f2,"Todas las imagenes han sido guardadas")

%% boxplot
f = waitbar(0,'Creando Boxplots','Name','Boxplot');

%STD = [0 0.1 0.25 0.5 1 2 3 4 5];
%NOISE = [0 0.1 0.25 0.5 0.75 1 1.25 1.5 2 3];
selected_hr = 150;
selected_std = 0;
selected_noise = 0;

hr_string = " HR = " + string(selected_hr) + ", ";
std_string = "STD = " + string(selected_std) + ", ";
noise_string = "NOISE = " + string(selected_noise);

[~, ipeaks] = ecgsyn(sfecg,N,file_noise,file_hr,file_std,lfhfratio,sfint,ti,ai,bi);
true_RR = GroundTruth(ipeaks,N,sfecg);

[RR_1, RR_2, RR_3, RR_4, RR_5, RR_6, RR_7, RR_8] = READFILE(selected_std,selected_noise,selected_hr);

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

metrica = metrics(2:end,2);
RR_mean_err = GetError(metrica);

names = categorical({'Two Average','Matched Filter','SWT','Engzee','Christov','Hamilton','Pan Tompkins','WQRS'});
names = reordercats(names,{'Two Average','Matched Filter','SWT','Engzee','Christov','Hamilton','Pan Tompkins','WQRS'});

figure(1)
scatter(metrica,names);
hold on
errorbar(metrica,names,RR_mean_err, 'horizontal', 'LineStyle','none')
hold off
title(strcat(stat_string,hr_string,std_string,noise_string))
%%


[~,order] = sort(RR_mean_err);
figure_names_sorted = figure_names(order);
RR_mean_err_sorted = RR_mean_err(order);
metrica_sorted = metrica(order);

figure(1)
scatter(metrica_sorted,figure_names)
hold on
errorbar(metrica_sorted,figure_names_sorted,RR_mean_err_sorted, 'horizontal', 'LineStyle','none');
hold off
title(strcat(stat_string,hr_string,std_string,noise_string))

%%

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