dx=800; dy=600              # define grid size
C = complex(real=rep(seq(-2.2, 1.0, length.out=dx), each=dy),
            imag=rep(seq(-1.2, 1.2, length.out=dy), dx))
C = matrix(C, dy, dx)       # convert from vector to matrix
Z = 0                       # initialize Z to zero
X = array(0, c(dy, dx, 20)) # allocate memory for all the frames
for (k in 1:20) {           # perform 20 iterations
    Z = Z^2+C               # the main equation
    X[, , k] = exp(-abs(Z)) # store magnitude of the complex number
}
library(caTools)            # load library with write.gif function
jetColors = colorRampPalette(c("#00007F", "blue", "#007FFF", "cyan", "#7FFF7F", "yellow", "#FF7F00", "red", "#7F0000"))
write.gif(X, "Mandelbrot.gif", col=jetColors, delay=100, transparent=0)
