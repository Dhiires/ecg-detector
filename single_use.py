import numpy as np
import matplotlib.pyplot as plt
from tkinter import Tk
from tkinter.filedialog import askopenfilename
import os

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

plt.figure()
t = np.linspace(0, len(unfiltered_ecg) / fs, len(unfiltered_ecg))
plt.plot(t,unfiltered_ecg)
plt.xlim(20,30)
plt.title("ECG Sintético Ruido Añadido 0.75 mV")
plt.ylabel("ECG (mV)")
plt.xlabel("Time (s)")
plt.show()