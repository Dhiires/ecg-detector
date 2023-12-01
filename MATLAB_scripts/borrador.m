%% Borrador de cositas

%% testing

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

%% intervalos adyacentes mayores a 50ms
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

%%
    for j = 1:15
        for k = 1:9
                error_table.Metodo(k+i-1) = tableNames(k);
                error_table.HR(k+i-1) = heart_rates(j);

                error_table.Promedio(k+i-1)     = Prom_error(k);
                error_table.Desviacion(k+i-1)   = Desv_error(k);
                error_table.RMSSD(k+i-1)        = RMSS_error(k);
                error_table.PNN50(k+i-1)        = PNN5_error(k);
                error_table.TRINDEX(k+i-1)      = TRIN_error(k);
                error_table.TINN(k+i-1)         = TINN_error(k);
        end
    end

%% 
        [RRmean, RRstd, rmssd, pnn50_0, trindex, tinn] = TimeDomainHRV(true_RR);
        [RRmean1, RRstd1, rmssd1, pnn50_1, trindex1, tinn1] = TimeDomainHRV(RR_1);
        [RRmean2, RRstd2, rmssd2, pnn50_2, trindex2, tinn2] = TimeDomainHRV(RR_2);
        [RRmean3, RRstd3, rmssd3, pnn50_3, trindex3, tinn3] = TimeDomainHRV(RR_3);
        [RRmean4, RRstd4, rmssd4, pnn50_4, trindex4, tinn4] = TimeDomainHRV(RR_4);
        [RRmean5, RRstd5, rmssd5, pnn50_5, trindex5, tinn5] = TimeDomainHRV(RR_5);
        [RRmean6, RRstd6, rmssd6, pnn50_6, trindex6, tinn6] = TimeDomainHRV(RR_6);
        [RRmean7, RRstd7, rmssd7, pnn50_7, trindex7, tinn7] = TimeDomainHRV(RR_7);
        [RRmean8, RRstd8, rmssd8, pnn50_8, trindex8, tinn8] = TimeDomainHRV(RR_8);
        
        metric_mean = CompileMetrics(RRmean,RRmean1,RRmean2,RRmean3,RRmean4,RRmean5,RRmean6,RRmean7,RRmean8);

%%
aux = zeros(1,3);
help = 0;
for i = 123:137 %3:length(list)

    file_name = list(i).name;
    file_name_parts = split(file_name,'_');
    aux = str2double([file_name_parts(2),file_name_parts(3),file_name_parts(4)]);
    file_std = aux(1); file_noise = aux(2); file_hr = aux(3);

    [~, ipeaks] = ecgsyn(sfecg,N,file_noise,file_hr,file_std,lfhfratio,sfint,ti,ai,bi);
    true_RR = GroundTruth(ipeaks,N,sfecg);

    [RR_1, RR_2, RR_3, RR_4, RR_5, RR_6, RR_7, RR_8] = READFILE(file_std,file_noise,file_hr);
    % En este punto se tiene el trueRR y los RR por archivo de la carpeta
    % actual de la iteración, el problema es que no se recorren en orden
    % ascendente de HR

    % Luego deberían ir una función de todas las metricas HRV

    RR_mean_metrics = GetRRmean(true_RR, RR_1, RR_2, RR_3, RR_4, RR_5, RR_6, RR_7, RR_8);
    RR_mean_err = GetError(RR_mean_metrics);
    
    for j = help+1:help+9
        table1.Metodo(j) = tableNames(j-help);
        table1.HR(j) = heart_rates(i-122);
        table1.error(j) = RR_mean_err(j-help);
    end
    help = help+9;
    
end

%%    
    %hr_string = " HR = " + string(file_hr) + ", ";
    %std_string = "STD = " + string(file_std) + ", ";
    %noise_string = "NOISE = " + string(file_noise);
    %
    %figure
    %scatter(RR_mean_metrics,names)
    %hold on
    %errorbar(RR_mean_metrics,names,RR_mean_err, 'horizontal', 'LineStyle','none');
    %hold off
    %title(strcat(stat_string,hr_string,std_string,noise_string))

%% STRINGS
    hr = " HR = " + string(hrmean) + ", ";
    std = "STD = " + string(hrstd) + ", ";
    noise = "NOISE = " + string(Anoise);
 
%% No standard deviation, no added noise
clear
sfecg = 250;
N = 128;
Anoise = 0;
hrmean = 60;
hrstd = 0;
lfhfratio = 0.5;
sfint = 250;
ti = [-70 -15 0 15 100];
ai = [1.2 -5 30 -7.5 0.75];
bi = [0.25 0.1 0.1 0.1 0.4];

[s, ipeaks] = ecgsyn(sfecg,N,Anoise,hrmean,hrstd,lfhfratio,sfint,ti,ai,bi); s; ipeaks;

%% No standard deviation, added noise
clear
sfecg = 250;
N = 128;
Anoise = 0.1;
hrmean = 60;
hrstd = 0;
lfhfratio = 0.5;
sfint = 250;
ti = [-70 -15 0 15 100];
ai = [1.2 -5 30 -7.5 0.75];
bi = [0.25 0.1 0.1 0.1 0.4];

[s, ipeaks] = ecgsyn(sfecg,N,Anoise,hrmean,hrstd,lfhfratio,sfint,ti,ai,bi); s; ipeaks;

%% with standard deviation, no noise
clear
sfecg = 250;
N = 128;
Anoise = 0;
hrmean = 60;
hrstd = 1;
lfhfratio = 0.5;
sfint = 250;
ti = [-70 -15 0 15 100];
ai = [1.2 -5 30 -7.5 0.75];
bi = [0.25 0.1 0.1 0.1 0.4];

[s, ipeaks] = ecgsyn(sfecg,N,Anoise,hrmean,hrstd,lfhfratio,sfint,ti,ai,bi);
 
 %% Plotting RR intervals

figure()
plot(tp,intervals,'LineWidth',3)
hold on
plot(RR_buffer(:,1))
plot(RR_buffer(:,2))
plot(RR_buffer(:,3))
plot(RR_buffer(:,4))
plot(RR_buffer(:,5))
plot(RR_buffer(:,6))
plot(RR_buffer(:,7))
plot(RR_buffer(:,8))
hold off
xlim([5 30])
legend('True HR','Two Average','Matched Filter','SWT','Engzee','Christov','Hamilton','Pan Tompkins','WQRS')

%%
figure
plot(true_RR)
hold on
plot(RR_1)
plot(RR_2)
plot(RR_3)
plot(RR_4)
plot(RR_5)
plot(RR_6)
plot(RR_7)
plot(RR_8)
hold off
legend('True HR','Two Average','Matched Filter','SWT','Engzee','Christov','Hamilton','Pan Tompkins','WQRS')

%% Plot testing

figure()
plot(t,s)
xlim([20 40])
title('ECG')

figure()
plot(t,ipeaks)
xlim([20 40])
title('PQRST')

%% Recommended settings
%ecgsyn(256, 256, 0, 60, 1, 0.5, 256, [-70 -15 0 15 100], [1.2 -5 30 -7.5 0.75], [0.25 0.1 0.1 0.1 0.4])
sfecg = 256;
N = 256;
Anoise = 0;
hrmean = 60;
hrstd = 1;
lfhfratio = 0.5;
sfint = 256;
ti = [-70 -15 0 15 100];
ai = [1.2 -5 30 -7.5 0.75];
bi = [0.25 0.1 0.1 0.1 0.4];

[s, ipeaks] = ecgsyn(sfecg,N,Anoise,hrmean,hrstd,lfhfratio,sfint,ti,ai,bi); s; ipeaks;
%% Recommended settings less pulses
%ecgsyn(256, 256, 0, 60, 1, 0.5, 256, [-70 -15 0 15 100], [1.2 -5 30 -7.5 0.75], [0.25 0.1 0.1 0.1 0.4])
sfecg = 256;
N = 128;
Anoise = 0;
hrmean = 60;
hrstd = 1;
lfhfratio = 0.5;
sfint = 256;
ti = [-70 -15 0 15 100];
ai = [1.2 -5 30 -7.5 0.75];
bi = [0.25 0.1 0.1 0.1 0.4];

[s, ipeaks] = ecgsyn(sfecg,N,Anoise,hrmean,hrstd,lfhfratio,sfint,ti,ai,bi);

%%

% Leer el archivo TSV en una tabla
tablaDatos = readtable('ECG.tsv', 'FileType','text','Delimiter',{'\t', ' '}, 'MultipleDelimsAsOne', true);

% Convertir la tabla a una matriz numérica
matrizDatos = table2array(tablaDatos);

% Ahora la variable matrizDatos contiene tus datos numéricos
% disp(matrizDatos);

matriz = [matrizDatos(:,1);matrizDatos(:,2);matrizDatos(:,3);matrizDatos(:,4);matrizDatos(:,5);matrizDatos(:,6)];

figure()
plot(linspace(1,length(matriz),length(matriz)), matriz)

figure()
plot(linspace(1,length(matrizDatos),length(matrizDatos)), matrizDatos(:,1))

%% differed_data = abs(diff(matriz));

figure()
plot(linspace(1,length(differed_data),length(differed_data)), differed_data)

%%
figure()
plot(tp,heart_rate)
ylim([45 85])
