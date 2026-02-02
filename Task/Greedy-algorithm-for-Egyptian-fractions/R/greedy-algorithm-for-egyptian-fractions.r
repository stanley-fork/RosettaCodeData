library(gmp)

next_denom <- function(x, y) (y%%x>0)+y%/%x

greedy_egyptian <- function(a, b){
  x <- as.bigz(a)
  y <- as.bigz(b)
  fracs <- NULL
  if(x>y){
    fracs <- c(x%/%y, fracs)
    x <- x%%y
    if(x==0) return(fracs)
  }
  fracs <- c(1/next_denom(x, y), fracs)
  while(y%%x>0){
    x_new <- -y%%x
    y_new <- y*(1+y%/%x)
    x <- x_new
    y <- y_new
    fracs <- c(1/next_denom(x, y), fracs)
  }
  rev(fracs)
}

test_fracs <- list(list(43, 48), list(5, 121), list(2014, 59))
reprs <- lapply(test_fracs, function(l) do.call(greedy_egyptian, l))
names(reprs) <- c("43/48", "5/121", "2014/59")
print(reprs, initLine=FALSE)

len_ge <- function(x, y) length(greedy_egyptian(x, y))
last_denoms <- lengths <- matrix.bigz(nrow=98, ncol=98)
for(i in 2:99){
  for(j in 2:99){
    lengths[i-1, j-1] <- len_ge(i, j)
    last_denoms[i-1, j-1] <- 1/(greedy_egyptian(i, j)[len_ge(i, j)])
  }
}

lmax <- max(lengths)
lmax_inds <- which(lengths==lmax, arr.ind=TRUE)
cat(sprintf("%i/%i has maximum length of %s:",
            1+lmax_inds[1], 1+lmax_inds[2], lmax), "\n")

print(greedy_egyptian(1+lmax_inds[1], 1+lmax_inds[2]), initLine=FALSE)

dmax_inds <- which(last_denoms==max(last_denoms), arr.ind=TRUE)
cat(sprintf("%i/%i contains the largest denominator:",
            1+dmax_inds[1], 1+dmax_inds[2]), "\n")

print(greedy_egyptian(1+dmax_inds[1], 1+dmax_inds[2]), initLine=FALSE)
