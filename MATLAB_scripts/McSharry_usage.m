%% No standard deviation, no added noise
clear
sfecg = 250;
N = 128;
Anoise = 0;
hrmean = 120;
hrstd = 0;
lfhfratio = 0.5;
sfint = 250;
ti = [-70 -15 0 15 100];
ai = [1.2 -5 30 -7.5 0.75];
bi = [0.25 0.1 0.1 0.1 0.4];

[s, ipeaks] = ecgsyn(sfecg,N,Anoise,hrmean,hrstd,lfhfratio,sfint,ti,ai,bi);

%% No standard deviation, added noise
clear
sfecg = 250;
N = 128;
Anoise = 0.1;
hrmean = 120;
hrstd = 0;
lfhfratio = 0.5;
sfint = 250;
ti = [-70 -15 0 15 100];
ai = [1.2 -5 30 -7.5 0.75];
bi = [0.25 0.1 0.1 0.1 0.4];

[s, ipeaks] = ecgsyn(sfecg,N,Anoise,hrmean,hrstd,lfhfratio,sfint,ti,ai,bi);

%% with standard deviation, no noise
clear
sfecg = 250;
N = 128;
Anoise = 0;
hrmean = 120;
hrstd = 1;
lfhfratio = 0.5;
sfint = 250;
ti = [-70 -15 0 15 100];
ai = [1.2 -5 30 -7.5 0.75];
bi = [0.25 0.1 0.1 0.1 0.4];

[s, ipeaks] = ecgsyn(sfecg,N,Anoise,hrmean,hrstd,lfhfratio,sfint,ti,ai,bi);

%% with standard deviation, with noise
clear
sfecg = 250;
N = 128;
Anoise = 0.1;
hrmean = 120;
hrstd = 1;
lfhfratio = 0.5;
sfint = 250;
ti = [-70 -15 0 15 100];
ai = [1.2 -5 30 -7.5 0.75];
bi = [0.25 0.1 0.1 0.1 0.4];

[s, ipeaks] = ecgsyn(sfecg,N,Anoise,hrmean,hrstd,lfhfratio,sfint,ti,ai,bi);

%% FILE CREATION
newMatrix = zeros(length(s)/6,6);
j = 1;

for i = 1:length(s)/6
    newMatrix(i,:) = s(j:j+5);
    j = j+6;
end

newMatrix = [s s s s s s];

%writematrix(newMatrix,'.tsv','Delimiter','\t','FileType','text');
writematrix(newMatrix,'ECG_arti_wstd_wnoise_120.tsv','Delimiter','\t','FileType','text');
