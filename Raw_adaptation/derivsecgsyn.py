import numpy as np

# Raw adaptation from MATLAB code https://www.physionet.org/content/ecgsyn/1.0.0/

def derivsecgsyn(t, x, flag, rr, sfint, ti, ai, bi):
    xi = np.cos(ti)
    yi = np.sin(ti)
    ta = np.arctan2(x[1], x[0])
    r0 = 1
    a0 = 1.0 - np.sqrt(x[0]**2 + x[1]**2) / r0
    ip = 1 + int(np.floor(t * sfint))
    w0 = 2 * np.pi / rr[ip - 1]

    fresp = 0.25
    zbase = 0.005 * np.sin(2 * np.pi * fresp * t)

    dx1dt = a0 * x[0] - w0 * x[1]
    dx2dt = a0 * x[1] + w0 * x[0]

    dti = (ta - ti) % (2 * np.pi)
    dx3dt = - np.sum(ai * dti * np.exp(-0.5 * (dti / bi)**2)) - 1.0 * (x[2] - zbase)

    dxdt = np.array([dx1dt, dx2dt, dx3dt])
    
    return dxdt
