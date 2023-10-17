%% Borrador de cositas

%% testing
 
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
