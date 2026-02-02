#Only print to 17 digits due to floating-point imprecision
options(digits=17)

a_sqrt2 <- function(n) ifelse(n==1, 1, 2)
b_sqrt2 <- function(n) return(1)

a_e <- function(n) ifelse(n==1, 2, n-1)
b_e <- function(n) ifelse(n==1, 1, n-1)

a_pi <- function(n) ifelse(n==1, 3, 6)
b_pi <- function(n) (2*n-1)^2

continued_fraction <- function(a, b, n){
  frac <- function(x, d) a(x)+b(x)/d
  Reduce(frac, 1:n, 1, right=TRUE)
}

sqrt(2)
continued_fraction(a_sqrt2, b_sqrt2, 100)

exp(1)
continued_fraction(a_e, b_e, 100)

pi
sapply(cumprod(c(100, rep(10,3))),
       function(n) continued_fraction(a_pi, b_pi, n))
