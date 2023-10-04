%% Ground Truth
L = length(ipeaks);
t = linspace(0,N,L);
tp = linspace(0,N,N);
pre_intervals = zeros(N+1,1);
pulses = zeros(L,1);
c = 0;
j = 1;
for i = 1:L
    if ipeaks(i,1) == 1
        pre_intervals(j,1) = i;
        j = j+1;
        c = c+1;
    end
end

intervals = diff(pre_intervals)/sfecg;
%heart_rate = 60.*intervals/sfecg;

%%
RR0 = zeros(N,1);
RR1 = zeros(N,1);
RR2 = zeros(N,1);
RR3 = zeros(N,1);
RR4 = zeros(N,1);
RR5 = zeros(N,1);
RR6 = zeros(N,1);
RR7 = zeros(N,1);

RR_buffer = [RR0 RR1 RR2 RR3 RR4 RR5 RR6 RR7];

%% Leer archivos r_peaks r_ts

for i = 0:7
    path = strcat('RR_peaks/RR_peaks_w_w_60/RR_',string(i),'.txt');
    aux = readtable(path,'Delimiter','\t');
    aux = table2array(aux);
    aux_L = length(aux);
    RR_buffer(1:aux_L,i+1) = aux;
end

figure()
plot(tp,intervals)
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

