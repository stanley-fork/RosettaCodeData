import numba

import numpy as np
import matplotlib.pyplot as plt

import decimal as dc  # decimal floating point arithmetic with arbitrary precision
dc.getcontext().prec = 80  # set precision to 80 digits (about 256 bits)

d, h = 1600, 1000  # pixel density (= image width) and image height
n, r = 80000, 100000.0  # number of iterations and escape radius (r > 2)

a = dc.Decimal("-1.256827152259138864846434197797294538253477389787308085590211144291")
b = dc.Decimal(".37933802890364143684096784819544060002129071484943239316486643285025")

S = np.zeros(n + 100, dtype=np.complex128)  # 100 iterations are chained
u, v = dc.Decimal(0), dc.Decimal(0)

for i in range(n + 100):
    S[i] = float(u) + float(v) * 1j
    if u * u + v * v < r * r:
        u, v = u * u - v * v + a, 2 * u * v + b
    else:
        print("The reference sequence diverges within %s iterations." % i)
        break

x = np.linspace(0, 2, num=d+1, dtype=np.float64)
y = np.linspace(0, 2 * h / d, num=h+1, dtype=np.float64)

A, B = np.meshgrid(x - 1, y - h / d)
C = 5.0e-35 * (A + B * 1j)

@numba.njit(parallel=True, fastmath=True)
def iteration_numba_bla(S, C):
    I, J = np.zeros(C.shape, dtype=np.intp), np.zeros(C.shape, dtype=np.complex128)
    E, Z, dZ = np.zeros_like(C), np.zeros_like(C), np.zeros_like(C)

    def iteration(S, dS, R, A, B, C):
        I, J = np.zeros(C.shape, dtype=np.intp), np.zeros(C.shape, dtype=np.complex128)
        E, Z, dZ = np.zeros_like(C), np.zeros_like(C), np.zeros_like(C)

        def abs2(z):
            return z.real * z.real + z.imag * z.imag

        def iterate2(delta, index, epsilon, z, dz):
            index, epsilon = index + 1, (2 * S[index] + epsilon) * epsilon + delta
            z, dz = S[index] + epsilon, 2 * z * dz + 1
            index, epsilon = index + 1, (2 * S[index] + epsilon) * epsilon + delta
            z, dz = S[index] + epsilon, 2 * z * dz + 1
            return index, epsilon, z, dz

        def skip100(delta, index, e, z, dz):
            de = dz - dS[index]  # no catastrophic cancellation (don't try that with e)
            # for l in range(100):  # skip 100 iterations (using linear approximations)
            #     index, e, de = index + 1, 2 * S[index] * e + delta, 2 * S[index] * de
            index, e, de = index + 100, A[index] * e + B[index] * delta, A[index] * de
            z, dz = S[index] + e, dS[index] + de
            return index, e, z, dz

        for k in range(len(C)):
            delta, index, epsilon, z, dz = C[k], I[k], E[k], Z[k], dZ[k]

            i, j = 0, 0
            while i + j < n:
                if abs2(z) < abs2(r):
                    if abs2(epsilon) < abs2(1e-10 * R[index]):
                        index, epsilon, z, dz = skip100(delta, index, epsilon, z, dz)
                        j = j + 100
                    else:
                        if abs2(z) < abs2(epsilon):
                            index, epsilon = 0, z  # reset the reference orbit
                        index, epsilon, z, dz = iterate2(delta, index, epsilon, z, dz)
                        i = i + 2
                else:
                    break

            I[k], E[k], Z[k], dZ[k], J[k] = index, epsilon, z, dz, complex(i + j, j)

        return I, E, Z, dZ, J

    A, B = np.ones(n, dtype=np.complex128), np.zeros(n, dtype=np.complex128)
    R, aS = np.full(n, 2, dtype=np.float64), np.where(np.abs(S) < 2, np.abs(S), 0)
    dS = np.zeros(n + 100, dtype=np.complex128)

    for i in range(1, n + 100):  # derivation of the series (accuracy is not required)
        dS[i] = 2 * S[i - 1] * dS[i - 1] + 1

    for i in numba.prange(n):  # coefficients und radii for the bilinear approximation
        for l in range(100):
            A[i], B[i] = 2 * S[i + l] * A[i], 2 * S[i + l] * B[i] + 1
            R[i] = min(R[i], aS[i + l])  # validity radii and skip barriers (zeros)

    for i in numba.prange(C.shape[0]):
        I[i, :], E[i, :], Z[i, :], dZ[i, :], J[i, :] = iteration(S, dS, R, A, B, C[i, :])

    return I, E, Z, dZ, J

I, E, Z, dZ, J = iteration_numba_bla(S, C)
D, T = np.zeros(C.shape, dtype=np.float64), J.real.copy()

skipped = J.imag.sum() / J.real.sum()
print("%.1f%% of all iterations were skipped." % (skipped * 100))

N = abs(Z) > 2  # exterior distance estimation
D[N] = np.log(abs(Z[N])) * abs(Z[N]) / abs(dZ[N])

plt.imshow(D ** 0.15, cmap=plt.cm.turbo, origin="lower")
plt.savefig("Mandelbrot_deep_zoom.png", dpi=200)

N = abs(Z) >= r  # normalized iteration count
T[N] = T[N] - np.log2(np.log(abs(Z[N])) / np.log(r))

T = np.minimum(T, n)  # truncation
T = (T - T.min()) / (T.max() - T.min())  # scaling

plt.imshow(T ** 0.2, cmap=plt.cm.jet, origin="lower")
plt.savefig("Mandelbrot_deep_time.png", dpi=200)
