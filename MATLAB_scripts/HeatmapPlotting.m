%% Retrieve data Synthetic
clear; clc; close all
path = "SyntheticMetrics/";
Domain = "FD";
if Domain == "TD"
    error_table = readtable(strcat(path,"error_metricas_HRV_TimeDomain.csv"));
    varNames = ['Metodo' "HR" "Promedio" "Desviacion" "RMSSD" "PNN50" "TRINDEX" "TINN"];
    title_varNames = ['Metodo' 'HR' "del Promedio" "de la Desviación Estándar" "del RMSSD" "del PNN50" "del TRINDEX" "del TINN"];
    images_path = Domain+"_HRV_HEAT\SYNTHETIC\";
elseif Domain == "FD"
    error_table = readtable(strcat(path,"error_metricas_HRV_FreqDomain.csv"));
    varNames = ['Metodo' "HR" "LFpeak" "HFpeak" "NormPowerLF" "NormPowerHF" "LFHFratio" "TotalPower" "sigma" "noise"];
    title_varNames = ['Metodo' 'HR' "de la Potencia Peak de LF" "de la Potencia Peak de HF" "de la Potencia Normalizada de LF" "de la Potencia Normalizada de HF" "de la razón LF/HF" "de la Potencia Total"];
    images_path = Domain+"_HRV_HEAT\SYNTHETIC\"; 
else
    disp("Wrong Domain")
end

heart_rates = string([linspace(40,180,15)]);
%% Creating heatmaps
close all
f = waitbar(0,'Creando heatmaps','Name','Heatmaps');
sigmaMatrix = zeros(1,18);
noiseMatrix = zeros(1,18);
for j = 1:120:height(error_table)
    for i = 3:8
        figura = figure;
        PosAct = get(figura, 'Position');
        h = heatmap(error_table(j:j+119,:),"HR","Metodo", ...
            'ColorVariable',varNames(i), ... %'ColorScaling','scaledrows', ...
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
        xlabel("HR (bpm)")
        ylabel("Método")
        
        PosNue = [2400 300 PosAct(3) PosAct(4)];
        
        set(figura, "Position", PosNue);

    end
    waitbar(j/(height(error_table)-1), f, 'Procesando...')
end
waitbar(1, f, "Finalizado")

%% Save images Synthetic

f2 = waitbar(0,'Guardando imagenes','Name','Guardado');
index = 1;
total_imagenes = 72;
for k = 1:6:total_imagenes
    waitbar((k+0)/total_imagenes,f2,'Guardando imagen '+string(k+0)+' de '+total_imagenes)
    saveas(figure(k+0),images_path+"MEAN_"+string(sigmaMatrix(index))+"_"+string(noiseMatrix(index))+".pdf")
    waitbar((k+1)/total_imagenes,f2,'Guardando imagen '+string(k+1)+' de '+total_imagenes)
    saveas(figure(k+1),images_path+"DESV_"+string(sigmaMatrix(index))+"_"+string(noiseMatrix(index))+".pdf")
    waitbar((k+2)/total_imagenes,f2,'Guardando imagen '+string(k+2)+' de '+total_imagenes)
    saveas(figure(k+2),images_path+"RMSS_"+string(sigmaMatrix(index))+"_"+string(noiseMatrix(index))+".pdf")
    waitbar((k+3)/total_imagenes,f2,'Guardando imagen '+string(k+3)+' de '+total_imagenes)
    saveas(figure(k+3),images_path+"PNN5_"+string(sigmaMatrix(index))+"_"+string(noiseMatrix(index))+".pdf")
    waitbar((k+4)/total_imagenes,f2,'Guardando imagen '+string(k+4)+' de '+total_imagenes)
    saveas(figure(k+4),images_path+"TRIN_"+string(sigmaMatrix(index))+"_"+string(noiseMatrix(index))+".pdf")
    waitbar((k+5)/total_imagenes,f2,'Guardando imagen '+string(k+5)+' de '+total_imagenes)
    saveas(figure(k+5),images_path+"TINN_"+string(sigmaMatrix(index))+"_"+string(noiseMatrix(index))+".pdf")

    index = index + 1;
end
waitbar(1,f2,"Todas las imagenes han sido guardadas")
close all

%% Retrieve data Real
clear; clc; close all
path = "RealMetrics/";

Domain = "FD";
if Domain == "TD"
    error_table = readtable(strcat(path,"error_metricas_HRV_TimeDomain.csv"));
    varNames = ['Metodo' "Activity" "Subject" "Promedio" "Desviacion" "RMSSD" "PNN50" "TRINDEX" "TINN"];
    title_varNames = ['Metodo' 'Actividad' 'Sujeto' "del Promedio" "de la Desviación Estándar" "del RMSSD" "del PNN50" "del TRINDEX" "del TINN"];
    images_path = Domain+"_HRV_HEAT\REAL\";
elseif Domain == "FD"
    error_table = readtable(strcat(path,"error_metricas_HRV_FreqDomain.csv"));
    varNames = ['Metodo' "Activity" "Subject" "LFpeak" "HFpeak" "NormPowerLF" "NormPowerHF" "LFHFratio" "TotalPower"];
    title_varNames = ['Metodo' 'Actividad' 'Sujeto' "de la Potencia Peak de LF" "de la Potencia Peak de HF" "de la Potencia Normalizada de LF" "de la Potencia Normalizada de HF" "de la razón LF/HF" "de la Potencia Total"];
    images_path = Domain+"_HRV_HEAT\REAL\"; 
else
    disp("Wrong Domain")
end

%% Real Heatmaps
close all
f = waitbar(0,'Creando heatmaps','Name','Heatmaps');
for i = 4:9
    figura = figure;
    PosAct = get(figura, 'Position');
    h = heatmap(error_table,"Activity","Metodo", ...
        'ColorVariable',varNames(i));% ... %'ColorScaling','scaledrows',);
    h.SourceTable.Activity = categorical(h.SourceTable.Activity);
    titulo = {"Error "+title_varNames(i)+" de los Intervalos RR"};
    title(titulo);
    xlabel("Actividad");
    ylabel("Método");
    
    PosNue = [2400 300 PosAct(3) PosAct(4)];
    
    set(figura, "Position", PosNue);
    waitbar((i-3)/6, f, 'Procesando...')
end
waitbar(1, f, "Finalizado")

%% Save images Real

f2 = waitbar(0,'Guardando imagenes','Name','Guardado');
index = 1;
total_imagenes = 6;
for k = 1:6:total_imagenes
    waitbar((k+0)/total_imagenes,f2,'Guardando imagen '+string(k+0)+' de '+total_imagenes)
    saveas(figure(k+0),images_path+"MEAN"+".pdf")
    waitbar((k+1)/total_imagenes,f2,'Guardando imagen '+string(k+1)+' de '+total_imagenes)
    saveas(figure(k+1),images_path+"DESV"+".pdf")
    waitbar((k+2)/total_imagenes,f2,'Guardando imagen '+string(k+2)+' de '+total_imagenes)
    saveas(figure(k+2),images_path+"RMSS"+".pdf")
    waitbar((k+3)/total_imagenes,f2,'Guardando imagen '+string(k+3)+' de '+total_imagenes)
    saveas(figure(k+3),images_path+"PNN5"+".pdf")
    waitbar((k+4)/total_imagenes,f2,'Guardando imagen '+string(k+4)+' de '+total_imagenes)
    saveas(figure(k+4),images_path+"TRIN"+".pdf")
    waitbar((k+5)/total_imagenes,f2,'Guardando imagen '+string(k+5)+' de '+total_imagenes)
    saveas(figure(k+5),images_path+"TINN"+".pdf")

    index = index + 1;
end
waitbar(1,f2,"Todas las imagenes han sido guardadas")
close all