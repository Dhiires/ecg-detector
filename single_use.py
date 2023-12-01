import numpy as np
import matplotlib.pyplot as plt
from tkinter import Tk
from tkinter.filedialog import askopenfilename
import os
from ecgdetectors import Detectors

#################### FUNCTIONS ####################
def GetPath():
    initial_dir = os.getcwd()
    Tk().withdraw()
    path = askopenfilename(initialdir=initial_dir)
    return path
#################### FUNCTIONS ####################

unfiltered_ecg_dat = np.loadtxt(GetPath())
unfiltered_ecg = unfiltered_ecg_dat[:, 0]

fs = 250

detectors = Detectors(fs)

title = "Detección de onda R"
metodo = 0
r_peaks = detectors.get_detector_list()[metodo][1](unfiltered_ecg)
r_ts = np.array(r_peaks) / fs

plt.figure()
t = np.linspace(0, len(unfiltered_ecg) / fs, len(unfiltered_ecg))
plt.plot(t,unfiltered_ecg)
plt.plot(r_ts, unfiltered_ecg[r_peaks],'ro')
plt.xlim(20,30)
plt.title(title)
plt.ylabel("ECG (mV)")
plt.xlabel("Time (s)")
plt.show()

plt.plot(t,unfiltered_ecg)
plt.title(title)
plt.ylabel("ECG (mV)")
plt.xlabel("Time (s)")
plt.show()