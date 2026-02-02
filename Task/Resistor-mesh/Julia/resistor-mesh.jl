using SparseArrays, LinearAlgebra

const N = 10

# Build an (N-1) x N discrete forward-difference operator:
# each row k has +1 at column k and -1 at column k+1
const rows = vcat(1:(N-1), 1:(N-1))
const cols = vcat(1:(N-1), 2:N)
const vals = vcat(ones(N-1), -ones(N-1))
const D1 = sparse(rows, cols, vals, N-1, N)   # (N-1) x N

# Identity as a sparse NxN
const I_N = spdiagm(0 => ones(N))

# Build 2D difference operator with Kronecker products
const D = [kron(D1, I_N); kron(I_N, D1)]      # (2*N*(N-1)) x (N^2)

# indices and right-hand side
const i, j = N*1 + 2, N*7 + 7
const b = zeros(N^2)
b[i], b[j] = 1.0, -1.0

# Solve normal equations (least-squares / Poisson-style)
v = (D' * D) \ b

# potential difference
println(v[i] - v[j])
