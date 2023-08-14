import numpy as np
from scipy.integrate import odeint
from scipy.signal import find_peaks

# Raw adaptation from MATLAB code https://www.physionet.org/content/ecgsyn/1.0.0/

def ecgsyn(sfecg, N, Anoise, hrmean, hrstd, lfhfratio, sfint, ti, ai, bi):
    if sfecg is None:
        sfecg = 256
    if N is None:
        N = 256
    if Anoise is None:
        Anoise = 0
    if hrmean is None:
        hrmean = 60
    if hrstd is None:
        hrstd = 1
    if lfhfratio is None:
        lfhfratio = 0.5
    if sfint is None:
        sfint = 512
    if ti is None:
        ti = np.array([-70, -15, 0, 15, 100]) * np.pi / 180
    if ai is None:
        ai = np.array([1.2, -5, 30, -7.5, 0.75])
    if bi is None:
        bi = np.array([0.25, 0.1, 0.1, 0.1, 0.4]) * np.sqrt(hrmean / 60)

    q = round(sfint / sfecg)
    qd = sfint / sfecg
    if q != qd:
        raise ValueError(f"Internal sampling frequency (sfint) must be an integer multiple of the ECG sampling frequency (sfecg).")

    flo = 0.1
    fhi = 0.25
    flostd = 0.01
    fhistd = 0.01

    rrmean = 60 / hrmean
    Nrr = 2 ** (np.ceil(np.log2(N * rrmean * (1 / sfint))))

    rr0 = rrprocess(flo, fhi, flostd, fhistd, lfhfratio, hrmean, hrstd, 1, Nrr)
    rr = np.interp(np.arange(len(rr0)) * sfint, np.arange(len(rr0)), rr0)

    dt = 1 / sfint
    rrn = np.zeros(len(rr))
    tecg = 0
    i = 0
    while i < len(rr):
        tecg += rr[i]
        ip = round(tecg / dt)
        rrn[i:ip] = rr[i]
        i = ip + 1
    Nt = ip

    x0 = np.array([1, 0, 0.04])
    Tspan = np.arange(0, Nt * dt, dt)
    X0 = odeint(derivsecgsyn, x0, Tspan, args=(rrn, sfint, ti, ai, bi))

    X = X0[::q, :]

    ipeaks = detectpeaks(X, ti, sfecg)

    z = X[:, 2]
    zmin = np.min(z)
    zmax = np.max(z)
    zrange = zmax - zmin
    z = (z - zmin) * (1.6) / zrange - 0.4

    eta = 2 * np.random.rand(len(z)) - 1
    s = z + Anoise * eta

    return s, ipeaks

def rrprocess(flo, fhi, flostd, fhistd, lfhfratio, hrmean, hrstd, sfrr, n):
    w1 = 2 * np.pi * flo
    w2 = 2 * np.pi * fhi
    c1 = 2 * np.pi * flostd
    c2 = 2 * np.pi * fhistd
    sig2 = 1
    sig1 = lfhfratio
    rrmean = 60 / hrmean
    rrstd = 60 * hrstd / (hrmean * hrmean)

    df = sfrr / n
    w = np.arange(n) * 2 * np.pi * df
    dw1 = w - w1
    dw2 = w - w2

    Hw1 = sig1 * np.exp(-0.5 * (dw1 / c1) ** 2) / np.sqrt(2 * np.pi * c1 ** 2)
    Hw2 = sig2 * np.exp(-0.5 * (dw2 / c2) ** 2) / np.sqrt(2 * np.pi * c2 ** 2)
    Hw = Hw1 + Hw2
    Hw0 = np.concatenate((Hw[:n // 2], Hw[n // 2 - 1::-1]))
    Sw = (sfrr / 2) * np.sqrt(Hw0)

    ph0 = 2 * np.pi * np.random.rand(n // 2 - 1)
    ph = np.concatenate(([0], ph0, [0], -np.flipud(ph0)))
    SwC = Sw * np.exp(1j * ph)
    x = (1 / n) * np.real(np.fft.ifft(SwC))

    xstd = np.std(x)
    ratio = rrstd / xstd
    rr = rrmean + x * ratio

    return rr

def detectpeaks(X, thetap, sfecg):
    N = len(X)
    irpeaks = np.zeros(N, dtype=int)

    theta = np.arctan2(X[:, 1], X[:, 0])
    ind0 = np.zeros(N, dtype=int)
    for i in range(N - 1):
        a = ((theta[i] <= thetap) & (thetap <= theta[i + 1]))
        j = np.where(a)[0]
        if len(j) > 0:
            d1 = thetap[j] - theta[i]
            d2 = theta[i + 1] - thetap[j]
            if d1 < d2:
                ind0[i] = j[0]
            else:
                ind0[i + 1] = j[0]

    d = max(2, sfecg // 64)
    ind = np.zeros(N, dtype=int)
    z = X[:, 2]
    zmin = np.min(z)
    zmax = np.max(z)
    zext = np.array([zmin, zmax, zmin, zmax, zmin])
    sext = np.array([1, -1, 1, -1, 1])
    for i in range(5):
        ind1 = np.where(ind0 == i + 1)[0]
        n = len(ind1)
        Z = np.ones((n, 2 * d + 1)) * zext[i] * sext[i]
        for j in range(-d, d + 1):
            k = np.where((1 <= ind1 + j) & (ind1 + j <= N))[0]
            Z[k, d + j] = z[ind1[k] + j] * sext[i]
        vmax = np.max(Z, axis=1)
        ivmax = np.argmax(Z, axis=1)
        iext = ind1 + ivmax - d
        ind[iext] = i + 1

    return ind

# You can call the ecgsyn function here with the desired parameter values
# For example:
s, ipeaks = ecgsyn(256, 256, 0, 60, 1, 0.5, 512, None, None, None)
print("ECG Signal:", s)
print("PQRST Peaks:", ipeaks)
