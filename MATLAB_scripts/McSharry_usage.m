%% Parámetros ECG
clear, clc
STD = [0 0.1 0.25 0.5 1 2 3 4 5];
NOISE = [0 0.1 0.25 0.5 0.75 1 1.25 1.5 2 3];
HRS = linspace(40,180,15);
sfecg = 250;
N = 128;
lfhfratio = 0.5;
sfint = 250;
ti = [-70 -15 0 15 100];
ai = [1.2 -5 30 -7.5 0.75];
bi = [0.25 0.1 0.1 0.1 0.4];

%% Usage

NO_HRSTD = 0;
for j = 1:length(NOISE)
    true_RR = zeros(N,15);
    for k = 1:length(HRS)
        [s, ipeaks] = ecgsyn(sfecg,N,NOISE(j),HRS(k),NO_HRSTD,lfhfratio,sfint,ti,ai,bi);
        file_name = create_tsv(s,NO_HRSTD,NOISE(j),HRS(k));
        save_file_name(file_name);
    end
end

NO_NOISE = 0;
for i = 1:length(STD)
    for k = 1:length(HRS)
        [s, ipeaks] = ecgsyn(sfecg,N,NO_NOISE,HRS(k),STD(i),lfhfratio,sfint,ti,ai,bi);
        file_name = create_tsv(s,STD(i),NO_NOISE,HRS(k));
        save_file_name(file_name);
    end
end

%% FUNCTIONS

% ECG FILE CREATION
function f_name = create_tsv(ecg, hrstd, Anoise, hrmean)
    newMatrix = [ecg ecg ecg ecg ecg ecg];
    % 'ECG_hrstd_Anoise_hrmean.tsv'
    f_name = 'ECG\ECG_'+string(hrstd)+'_'+string(Anoise)+'_'+string(hrmean)+'.tsv';
    writematrix(newMatrix,f_name,'Delimiter','\t','FileType','text');
end

% SAVE FILE NAME TO .TXT
function save_file_name(f_name)
    files = readlines("files_names.txt");
    files = [files; f_name];
    fid = fopen("files_names.txt","w");
    fprintf(fid, '%s\n', files(1:end-1));
    fprintf(fid,'%s',files(end));
end