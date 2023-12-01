%% Parámetros ECG
clear, clc, close all
hrstd = 2;
Anoise = 0;
hrmean = 60;
sfecg = 250;
N = 128;
lfhfratio = 0.5;
sfint = 250;
ti = [-70 -15 0 15 100];
ai = [1.2 -5 30 -7.5 0.75];
bi = [0.25 0.1 0.1 0.1 0.4];

[s1, ipeaks1] = ecgsyn(sfecg, N, Anoise, hrmean, hrstd, lfhfratio, sfint, ti, ai, bi);
true_RR1 = GroundTruth(ipeaks1,N,sfecg);
t1 = linspace(0, length(s1)/sfecg, length(s1));

test = FreqDomainHRV(true_RR1);
%%
[pLF,pHF,LFHFratio,~,~,~,f,Y,NFFT] = HRV.fft_val_fun(true_RR1,250,'linear');
YY = 2*abs(Y(1:NFFT/2+1));
YY = YY.^2;

VLF = YY(f<=.04);
LF  = YY(f<=.15);  
HF  = YY(f<=.40);

peak_VLF = max(YY(f<=.04));
peak_LF  = max(YY(f<=.15 & f>=.04));
peak_HF  = max(YY(f<=.40 & f>=.15));

f_peak_VLF = f(YY==peak_VLF);
f_peak_LF  = f(YY==peak_LF);
f_peak_HF  = f(YY==peak_HF);
%%
figure
plot(f,YY)
xlim([0 .40])
hold on
plot(f_peak_VLF,peak_VLF,'x')
plot(f_peak_LF,peak_LF,'x')
plot(f_peak_HF,peak_HF,'x')
hold off
%%
hrstd = 6;

[s2, ipeaks2] = ecgsyn(sfecg, N, Anoise, hrmean, hrstd, lfhfratio, sfint, ti, ai, bi);
true_RR2 = GroundTruth(ipeaks2,N,sfecg);
t2 = linspace(0, length(s2)/sfecg, length(s2));

hrstd = 6;
Anoise = 0.75;

[s3, ipeaks3] = ecgsyn(sfecg, N, Anoise, hrmean, hrstd, lfhfratio, sfint, ti, ai, bi);
true_RR3 = GroundTruth(ipeaks3,N,sfecg);
t3 = linspace(0, length(s3)/sfecg, length(s3));


for i = 1:length(ipeaks1)
    if ipeaks1(i) == 3
        ipeaks1(i) = s1(i);
    else
        ipeaks1(i) = 0;
    end
end

for i = 1:length(ipeaks2)
    if ipeaks2(i) == 3
        ipeaks2(i) = s2(i);
    else
        ipeaks2(i) = 0;
    end
end

for i = 1:length(ipeaks3)
    if ipeaks3(i) == 3
        ipeaks3(i) = s3(i);
    else
        ipeaks3(i) = 0;
    end
end

figure
plot(t1,s1)
hold on
plot(t1,ipeaks1,'x')
hold off

figure
plot(t2,s2)
hold on
plot(t2,ipeaks2,'x')
hold off

figure
plot(t3,s3)
hold on
plot(t3,ipeaks3,'x')
hold off
%%
figure
plot(t1,ipeaks1,'o')
hold on
plot(t3,ipeaks3,'x')
hold off

figure
plot(t2,ipeaks2,'o')
hold on
plot(t3,ipeaks3,'x')
hold off
%%
figure
plot(TRI1,'o')
hold on
plot(TRI2,'x')
hold off

figure
plot(TINN1,'o')
hold on
plot(TINN2,'x')
hold off
%%
figure
plot(s1,'blue')
hold on
plot(ipeaks/5,'o')
hold off

%% Functions

% TRUE RR
function inter = GroundTruth(peaks, num, fs)
    L = length(peaks);
    pre = zeros(num+1,1);
    j = 1;
    for i = 1:L
        if peaks(i,1) == 3
            pre(j,1) = i;
            j = j+1;
        end
    end
    inter = diff(pre)/fs;
    inter = inter(1:end-1);
end