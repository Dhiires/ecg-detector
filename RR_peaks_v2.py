import numpy as np
import matplotlib.pyplot as plt
import pathlib
from ecgdetectors import Detectors
import os

current_dir = pathlib.Path(__file__).resolve()

# 'ECG_hrstd_Anoise_hrmean.tsv'
# 'RR_peaks/RR_hrstd_Anoise_hrmean/RR_'

hrstd = 1
Anoise = 1
hrmean = 60

dir  = current_dir.parent/'data'/'ECG_'+str(hrstd)+'_'+str(Anoise)+'_'+str(hrmean)+'.tsv'

unfiltered_ecg_dat = np.loadtxt(dir)
unfiltered_ecg = unfiltered_ecg_dat[:, 0]
fs = 250

detectors = Detectors(fs)

for i in range(8):
    r_peaks = detectors.get_detector_list()[i][1](unfiltered_ecg)
    r_ts = np.array(r_peaks) / fs
    
    intervals = np.diff(r_ts)
    
    folder_path = 'C:/Users/joseb/Documents/Memoria/ecg-detector/RR_'+str(hrstd)+'_'+str(Anoise)+'_'+str(hrmean)
    
    if not os.path.exists(folder_path):
        os.makedirs(folder_path)
    
    path = os.path.join(folder_path, 'RR_' + str(i) + '.txt')
    
    with open(path,'w') as file:
        file.write('\n'.join(str(value) for value in intervals))