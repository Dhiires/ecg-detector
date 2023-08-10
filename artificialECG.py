import numpy as np
import matplotlib.pyplot as plt

# Parámetros del modelo
alpha = 1.0
omega = 0.5
A = 0.15
f_2 = 0.1  # Frecuencia respiratoria en Hz

# Valores de interés
times = {'P': -0.2, 'Q': -0.05, 'R': 0.0, 'S': 0.05, 'T': 0.3}
theta_values = {'P': -np.pi/3, 'Q': -np.pi/12, 'R': 0.0, 'S': np.pi/12, 'T': np.pi/2}
a_values = {'P': 1.2, 'Q': -5.0, 'R': 30.0, 'S': -7.5, 'T': 0.75}
b_values = {'P': 0.25, 'Q': 0.1, 'R': 0.1, 'S': 0.1, 'T': 0.4}

# Función de la línea de base z_0
def z_0(t):
    return A * np.sin(2 * np.pi * f_2 * t)

# Ecuaciones diferenciales
def dx_dt(x, y):
    return alpha * x - omega * y

def dy_dt(x, y):
    return alpha * y + omega * x

def dz_dt(x, y, z, t):
    theta = np.arctan2(y, x)
    dz = 0
    for event in times.keys():
        delta_theta_i = (theta - theta_values[event]) % (2 * np.pi)
        dz += a_values[event] * delta_theta_i * np.exp(-delta_theta_i**2 / (2 * b_values[event]**2))
    return dz - (z - z_0(t))

# Parámetros de simulación
duration = 100  # Duración en segundos
sampling_rate = 1000  # Tasa de muestreo en Hz
num_samples = int(duration * sampling_rate)
time = np.linspace(0, duration, num_samples)
delta_t = 1 / sampling_rate

# Inicialización
x = np.zeros(num_samples)
y = np.zeros(num_samples)
z = np.zeros(num_samples)

# Integración numérica usando el método de cuarto orden Runge-Kutta
for i in range(1, num_samples):
    k1_x = dx_dt(x[i - 1], y[i - 1])
    k1_y = dy_dt(x[i - 1], y[i - 1])
    k1_z = dz_dt(x[i - 1], y[i - 1], z[i - 1], time[i - 1])

    k2_x = dx_dt(x[i - 1] + 0.5 * delta_t * k1_x, y[i - 1] + 0.5 * delta_t * k1_y)
    k2_y = dy_dt(x[i - 1] + 0.5 * delta_t * k1_x, y[i - 1] + 0.5 * delta_t * k1_y)
    k2_z = dz_dt(x[i - 1] + 0.5 * delta_t * k1_x, y[i - 1] + 0.5 * delta_t * k1_y, z[i - 1] + 0.5 * delta_t * k1_z, time[i - 1] + 0.5 * delta_t)

    k3_x = dx_dt(x[i - 1] + 0.5 * delta_t * k2_x, y[i - 1] + 0.5 * delta_t * k2_y)
    k3_y = dy_dt(x[i - 1] + 0.5 * delta_t * k2_x, y[i - 1] + 0.5 * delta_t * k2_y)
    k3_z = dz_dt(x[i - 1] + 0.5 * delta_t * k2_x, y[i - 1] + 0.5 * delta_t * k2_y, z[i - 1] + 0.5 * delta_t * k2_z, time[i - 1] + 0.5 * delta_t)

    k4_x = dx_dt(x[i - 1] + delta_t * k3_x, y[i - 1] + delta_t * k3_y)
    k4_y = dy_dt(x[i - 1] + delta_t * k3_x, y[i - 1] + delta_t * k3_y)
    k4_z = dz_dt(x[i - 1] + delta_t * k3_x, y[i - 1] + delta_t * k3_y, z[i - 1] + delta_t * k3_z, time[i - 1] + delta_t)

    x[i] = x[i - 1] + (delta_t / 6) * (k1_x + 2 * k2_x + 2 * k3_x + k4_x)
    y[i] = y[i - 1] + (delta_t / 6) * (k1_y + 2 * k2_y + 2 * k3_y + k4_y)
    z[i] = z[i - 1] + (delta_t / 6) * (k1_z + 2 * k2_z + 2 * k3_z + k4_z)

# Generar la señal de ECG sintética
ecg_signal = z

# Visualizar la señal de ECG generada
plt.figure()
plt.plot(time, ecg_signal)
plt.title('Señal de ECG Sintética')
plt.xlabel('Tiempo (s)')
plt.ylabel('Amplitud')
plt.show()
