import numpy as np
import pathlib
from ecgdetectors import Detectors
import os

# Obtiene la ruta completa del script actual y su directorio padre
current_dir = pathlib.Path(__file__).resolve()
parent_dir = current_dir.parent

# Define la ruta del directorio de datos
data_dir = parent_dir / 'dataset_716' / 'experiment_data'

# Lista el contenido del directorio de datos
current_list = os.listdir(data_dir)

for file in current_list:
    print(file)
    
        