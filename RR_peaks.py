import numpy as np
import matplotlib.pyplot as plt
import pathlib
from ecgdetectors import Detectors
import sys

current_dir = pathlib.Path(__file__).resolve()

# dir = current_dir.parent/'data'/'ECG_arti_nostd_nonoise_60.tsv'
# dir = current_dir.parent/'data'/'ECG_arti_wstd_nonoise_60.tsv'
# dir = current_dir.parent/'data'/'ECG_arti_nostd_wnoise_60.tsv'
# dir = current_dir.parent/'data'/'ECG_arti_wstd_wnoise_60.tsv'
# dir = current_dir.parent/'data'/'ECG_arti_nostd_nonoise_120.tsv'
# dir = current_dir.parent/'data'/'ECG_arti_wstd_nonoise_120.tsv'
# dir = current_dir.parent/'data'/'ECG_arti_nostd_wnoise_120.tsv'
dir = current_dir.parent/'data'/'ECG_arti_wstd_wnoise_120.tsv'

unfiltered_ecg_dat = np.loadtxt(dir)
unfiltered_ecg = unfiltered_ecg_dat[:, 0]
fs = 250

detectors = Detectors(fs)

for i in range(8):
    r_peaks = detectors.get_detector_list()[i][1](unfiltered_ecg)
    r_ts = np.array(r_peaks) / fs
    
    intervals = np.diff(r_ts)
 
    path = 'C:/Users/joseb/Documents/Memoria/ecg-detector/RR_peaks_w_w_120/'+'RR_'+str(i)+'.txt'
    
    with open(path,'w') as file:
        file.write('\n'.join(str(value) for value in intervals))