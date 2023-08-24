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

[s, ipeaks] = ecgsyn(sfecg,N,Anoise,hrmean,hrstd,lfhfratio,sfint,ti,ai,bi);

L = length(ipeaks);

figure()
plot(linspace(1,256,L),s)
title('ECG')

figure()
plot(linspace(1,256,L),ipeaks)
title('PQRST')

%%
newMatrix = zeros(length(s)/6,6);
j = 1;

for i = 1:length(s)/6
    newMatrix(i,:) = s(j:j+5);
    j = j+6;
end

writematrix(newMatrix,'test_data.tsv','Delimiter','\t','FileType','text');
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



differed_data = abs(diff(matriz));

figure()
plot(linspace(1,length(differed_data),length(differed_data)), differed_data)