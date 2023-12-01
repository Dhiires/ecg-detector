%% HRV using toolbox full RR
% Vollmer, Marcus. "HRVTool - an Open-Source Matlab Toolbox for Analyzing 
% Heart Rate Variability.” 2019 Computing in Cardiology Conference (CinC), 
% Computing in Cardiology, 2019, doi:10.22489/cinc.2019.032.

%% Create Table
stat_string = 'Error Promedio Intervalos RR ';

names = categorical({'True HR','Two Average','Matched Filter','SWT','Engzee','Christov','Hamilton','Pan Tompkins','WQRS'});
names = reordercats(names,{'True HR','Two Average','Matched Filter','SWT','Engzee','Christov','Hamilton','Pan Tompkins','WQRS'});
heart_rates = string([linspace(40,180,15)]);
tableNames = {'True HR';'Two Average';'Matched Filter';'SWT';'Engzee';'Christov';'Hamilton';'Pan Tompkins';'WQRS'};
sz = [9*15 3];
varNames = ['Metodo' "HR" "error"];
varTypes = ["string" "string" "double"];
table1 = table('Size',sz,'VariableTypes',varTypes,'VariableNames',varNames);
help = 0;

%%
figure()
h = heatmap(error_table,"HR","Metodo",'ColorVariable','Promedio','Colormap',pink);
h.SourceTable.HR = categorical(h.SourceTable.HR);
order = heart_rates;
h.SourceTable.HR = reordercats(h.SourceTable.HR,order);
% ORDENAR EL EJE Y
a = abs(mean(true_RR)-mean(true_RR))*(100/mean(true_RR));
b = abs(mean(RR_1)-mean(true_RR))*(100/mean(true_RR));
c = abs(mean(RR_2)-mean(true_RR))*(100/mean(true_RR));
d = abs(mean(RR_3)-mean(true_RR))*(100/mean(true_RR));
e = abs(mean(RR_4)-mean(true_RR))*(100/mean(true_RR));
f = abs(mean(RR_5)-mean(true_RR))*(100/mean(true_RR));
g = abs(mean(RR_6)-mean(true_RR))*(100/mean(true_RR));
h = abs(mean(RR_7)-mean(true_RR))*(100/mean(true_RR));
l = abs(mean(RR_8)-mean(true_RR))*(100/mean(true_RR));
vals = [a, b, c, d, e, f, g, h, l];

hr_string = " HR = " + string(file_hr) + ", ";
std_string = "STD = " + string(file_std) + ", ";
noise_string = "NOISE = " + string(file_noise);

%%
figure()
b = barh(names, [a, b, c, d, e, f, g, h, l]);
b.FaceColor = "flat";
b.CData(1, :) = [.5, 0, .5];
title(strcat(stat_string,hr_string,std_string,noise_string))

% Agregar el valor de cada columna al final de las barras
for i = 1:numel(names)
    text(vals(i)+ 0.0005, i, sprintf('%.2f', vals(i)), 'HorizontalAlignment', 'left', 'VerticalAlignment', 'middle')
end


