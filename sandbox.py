import numpy as np
import pathlib
from ecgdetectors import Detectors
import os
from tkinter import Tk
from tkinter.filedialog import askopenfilename

def GetPath():
    initial_dir = os.getcwd()
    Tk().withdraw()
    path = askopenfilename(initialdir=initial_dir)
    return path

print(GetPath())