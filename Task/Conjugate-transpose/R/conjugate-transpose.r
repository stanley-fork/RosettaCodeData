conj_t <- function(mat) t(Conj(mat))

near_eq <- function(x, y, eps=10^-10) all(abs(x-y)<eps)

is_hermitian <- function(mat) near_eq(mat, conj_t(mat))

is_normal <- function(mat){
  mat_h <- conj_t(mat)
  near_eq(mat%*%mat_h, mat_h%*%mat)
}

is_unitary <- function(mat){
  id <- diag(nrow(mat))
  near_eq(mat%*%conj_t(mat), id)
}

mat1 <- matrix(c(3+0i, 2-1i, 2+1i, 1+0i), nrow=2)

mat2 <- matrix(complex(real=c(1, 0, 1, 1, 1, 0, 0, 1, 1),
                       imaginary=0),
               nrow=3)

s <- sqrt(2)/2
mat3 <- matrix(complex(real=c(s, 0, 0, s, rep(0, 5)),
                       imaginary=c(0, -s, 0, 0, s, 0, 0, 0, 1)),
               nrow=3)

conj_tests <- function(mat){
  cat("\nChosen matrix:\n")
  print(mat)
  cat("\nConjugate transpose:\n")
  print(conj_t(mat))
  test_funs <- c(is_hermitian, is_normal, is_unitary)
  results <- sapply(test_funs, function(f) f(mat))
  queries <- c("Hermitian?", "Normal?", "Unitary?")
  writeLines(paste(queries, results))
}

sapply(list(mat1, mat2, mat3), conj_tests) |> invisible()
