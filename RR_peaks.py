import numpy as np
import pathlib
from ecgdetectors import Detectors
import os

########################### INIT FUNCTIONS #########################

def SplitParts(ecg_file_name):
    parts = ecg_file_name.rsplit('.',1) # "ECG_hrstd_Anoise_hrmean.tsv"
    print(parts)
    parts = parts[0] # "ECG_hrstd_Anoise_hrmean", "tsv"
    parts = parts.split('_') # "ECG", "hrstd", "Anoise", "hrmean"
    hrstd, Anoise, hrmean = parts[1], parts[2], parts[3]
    return hrstd, Anoise, hrmean

########################### END FUNCTIONS ###########################

current_dir = pathlib.Path(__file__).resolve()
data_dir = current_dir.parent / 'data2'

with open(data_dir / 'files_names.txt', 'r') as files_names_file:
    for line in files_names_file:
        ecg_file_name = line.strip()
        if ecg_file_name == "init":
            print("Reading files_names.txt ...")
            continue
        hrstd, Anoise, hrmean = SplitParts(ecg_file_name)
        
        print(ecg_file_name)
        ecg_file_path = data_dir / ecg_file_name
        unfiltered_ecg_dat = np.loadtxt(ecg_file_path)
        unfiltered_ecg = unfiltered_ecg_dat[:, 0]
        
        fs = 250
        detectors = Detectors(fs)
        
        for i in range(8):
            r_peaks = detectors.get_detector_list()[i][1](unfiltered_ecg)
            r_ts = np.array(r_peaks) / fs
            
            intervals = np.diff(r_ts)
            
            pre_folder_path = current_dir.parent / 'RR_intervals2' 
            specific_folder_path = 'RR_' + str(hrstd) + '_' + str(Anoise) + '_' + str(hrmean)
            rr_folder_path = pre_folder_path / specific_folder_path
            
            if not os.path.exists(rr_folder_path):
                os.makedirs(rr_folder_path)
            
            rr_file_name = 'RR_' + str(i) + '.txt'
            rr_file_path = rr_folder_path / rr_file_name
            
            with open(rr_file_path, 'w') as file:
                file.write('\n'.join(str(value) for value in intervals))
        
    print("Reading finished!")