import numpy as np
import matplotlib.pyplot as plt
import pathlib
from ecgdetectors import Detectors
import sys

current_dir = pathlib.Path(__file__).resolve()

dir = current_dir.parent/'data'/'ECG_arti_og_sett.tsv'

unfiltered_ecg_dat = np.loadtxt(dir)
unfiltered_ecg = unfiltered_ecg_dat[:, 0]
fs = 250

detectors = Detectors(fs)

for i in range(8):
    r_peaks = detectors.get_detector_list()[i][1](unfiltered_ecg)
    r_ts = np.array(r_peaks) / fs
    
    intervals = np.diff(r_ts)
    heart_rate = 60.0/intervals
 
    path = 'C:/Users/joseb/Documents/Memoria/ecg-detector/heart_rates/'+'HR_'+str(i)+'.txt'
    
    with open(path,'w') as file:
        file.write('\n'.join(str(value) for value in heart_rate))
        
