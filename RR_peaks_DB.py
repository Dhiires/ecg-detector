import numpy as np
import pathlib
from ecgdetectors import Detectors
import os

########################## INIT FUNCTIONS ##########################

def RunMethods(file_path, experiment, subject):
    fs = 250
    detectors = Detectors(fs)
    
    unfiltered_ecg_dat = np.loadtxt(file_path)
    unfiltered_ecg = unfiltered_ecg_dat[:,0]
    
    for i in range(8):
        r_peaks = detectors.get_detector_list()[i][1](unfiltered_ecg)
        r_ts = np.array(r_peaks) / fs
        
        intervals = np.diff(r_ts)
        
        pre_folder_path = current_dir.parent / 'DB_RR_intervals'
        specific_folder_path = 'RR_' + experiment + '_' + subject
        rr_folder_path = pre_folder_path / specific_folder_path
        
        if not os.path.exists(rr_folder_path):
            os.makedirs(rr_folder_path)
        
        rr_file_name = 'RR_' + str(i) + '.txt'
        rr_file_path = rr_folder_path / rr_file_name
        
        with open(rr_file_path, 'w') as file:
            file.write('\n'.join(str(value) for value in intervals))
            
    return

########################## END FUNCTIONS ##########################

current_dir = pathlib.Path(__file__).resolve()
parent_dir = current_dir.parent

data_dir = parent_dir / 'dataset_716' / 'experiment_data'

current_list = os.listdir(data_dir)

for subject in current_list:
    display_string = 'Reading ' + subject
    print(display_string)
    
    sub_list = os.listdir(data_dir / subject)
    for experiment in sub_list:
        display_string = 'Experiment ' + experiment
        print(display_string)
        
        ecg_file_path = data_dir / subject / experiment / 'ECG.tsv'
        
        RunMethods(ecg_file_path,experiment,subject)
    
print("Finished")