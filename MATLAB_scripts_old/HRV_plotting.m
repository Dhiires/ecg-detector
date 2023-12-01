%% HRV plotting

%% RR mean

stat_string = 'Promedio Intervalos RR ';

names = categorical({'True HR','Two Average','Matched Filter','SWT','Engzee','Christov','Hamilton','Pan Tompkins','WQRS'});
names = reordercats(names,{'True HR','Two Average','Matched Filter','SWT','Engzee','Christov','Hamilton','Pan Tompkins','WQRS'});

figure()
b = bar(names,metrics_RR_mean);
b.FaceColor = "flat";
b.CData(1,:) = [.5 0 .5];
title(strcat(stat_string,hr_string,std_string,noise_string))

%% RR STD

stat_string = 'Desviación Estándar Intervalos RR ';

names = categorical({'True STD','Two Average','Matched Filter','SWT','Engzee','Christov','Hamilton','Pan Tompkins','WQRS'});
names = reordercats(names,{'True STD','Two Average','Matched Filter','SWT','Engzee','Christov','Hamilton','Pan Tompkins','WQRS'});

figure()
b = bar(names,[true_SDNN RR_buffer_SDNN]);
b.FaceColor = "flat";
b.CData(1,:) = [.5 0 .5];
title(strcat(stat_string,hr_string,std_string,noise_string))

%% HR mean

stat_string = 'Promedio Ritmo Cardiaco ';

names = categorical({'True STD','Two Average','Matched Filter','SWT','Engzee','Christov','Hamilton','Pan Tompkins','WQRS'});
names = reordercats(names,{'True STD','Two Average','Matched Filter','SWT','Engzee','Christov','Hamilton','Pan Tompkins','WQRS'});

figure()
b = bar(names,[true_HR_mean RR_buffer_HR_mean]);
b.FaceColor = "flat";
b.CData(1,:) = [.5 0 .5];
title(strcat(stat_string,hr_string,std_string,noise_string))

%% HR STD

stat_string = 'Desviación Estándar Ritmo Cardiaco ';

names = categorical({'True STD','Two Average','Matched Filter','SWT','Engzee','Christov','Hamilton','Pan Tompkins','WQRS'});
names = reordercats(names,{'True STD','Two Average','Matched Filter','SWT','Engzee','Christov','Hamilton','Pan Tompkins','WQRS'});

figure()
b = bar(names,[true_HR_std RR_buffer_HR_std]);
b.FaceColor = "flat";
b.CData(1,:) = [.5 0 .5];
title(strcat(stat_string,hr_string,std_string,noise_string))