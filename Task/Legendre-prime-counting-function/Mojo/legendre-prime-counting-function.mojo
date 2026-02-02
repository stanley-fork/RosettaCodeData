# Legendre Prime Counting Function Using Partial Sieving...

# compile with "mojo build -march native <filename>"...

# from memory import (memset)
from time import (monotonic)

alias cLIMIT: UInt64 = 100_000_000_000

fn intsqrt(n: UInt64) -> UInt64:
  if n < 4:
    if n < 1: return 0 else: return 1
  var x: UInt64 = n; var qn: UInt64 = 0; var r: UInt64 = 0
  while qn < 64 and (1 << qn) <= n:
    qn += 2
  var q: UInt64 = 1 << qn
  while q > 1:
    if qn >= 64:
      q = 1 << (qn - 2); qn = 0
    else:
      q >>= 2
    var t: UInt64 =  r + q
    r >>= 1
    if x >= t:
      x -= t; r += q
  return r

fn countPrimes(limit: UInt64) -> Int64:
  if limit < 3: return 0 if limit < 2 else 1

  var rtlmt: Int = Int(intsqrt(limit))
  var mxndx = (rtlmt - 1) >> 1
  var rtrtlmt = Int(intsqrt(rtlmt))
  # converts `x` to Pi`x` through Phi(x, 1) so does not contain "one" where
  # the one means only divides by p2 which is two...
  @always_inline
  fn pip2(x: Int64) -> Int64 : return ((x - 1) // 2)
  @always_inline
  fn tondx(x: Int64) -> Int64 : return ((x - 1) // 2) # aame function; to doc
  @always_inline
  fn divide(n: UInt64, d: Int64) -> Int64: return Int64(n // UInt64(d))
  var pisndxs = # current accumulated counts of odd primes 1 to sqrt range
    UnsafePointer[UInt32].alloc(mxndx + 1)
  # initialized for no sieving other than odds-only - partial sieved by 2:
  #   0 odd primes to 1; 1 odd prime to 3, etc....
  for i in range(mxndx + 1): pisndxs[i] = i
  # initialized to all odd positive numbers 1, 3, 5, ... sqrt range...
  var roughs = # current odd k-rough numbers up to sqrt of range; k = 2
    UnsafePointer[UInt32].alloc(mxndx + 1)
  for i in range(mxndx + 1): roughs[i] = i + i + 1
  # array of current phi counts for above roughs...
  # these are not strictly `phi`'s since they also include the
  # count of base primes in order to match the above `pisndxs` definition!
  var pis = # starts as size of counts just as `roughs` so they align!
    UnsafePointer[Int64].alloc(mxndx + 1)
  # initialized for current roughs after accounting for even prime of two...
  for i in range(mxndx + 1): pis[i] = pip2(divide(limit, Int64(roughs[i])))
  # cmpsts is a bit-packed boolean array representing
  # odd composite numbers from 1 up to rtlmt used for sieving...
  # initialized as "zeros" meaning all odd positives are potentially prime
  # note that this array starts at (and keeps) 1 to match the algorithm even
  # though 1 is not a prime, as 1 is important in computation of phi...

  # number of found base primes and current highest used rough index...
  var numbps: Int = 0; var mxri: Int = mxndx
  while True:
    var bp = roughs[1]
    if bp > rtrtlmt: break

    # mark `roughs` for all current multiples of `bp`;
    # this is "partial sieving because it only culls by `bp` at a time...
    roughs[1] = 0 # mark off the `bp` in `roughs` itself
    for cullpos in range(bp * bp, rtlmt, bp + bp):
      var ndx = Int(pisndxs[cullpos >> 1]) - numbps
      if roughs[ndx] == UInt32(cullpos): roughs[ndx] = 0

    var roi: Int = 0 # to keep track of current used roughs index!
    for rii in range(mxri + 1): # processing over current roughs size...
      # q is not necessarily a prime but may be a
      # product of primes not yet culled by partial sieving;
      # this is what saves operations compared to recursive Legendre:
      var q: Int64 = Int64(roughs[rii])
      # skip over values of `q` already culled in the last partial sieve:
      if q == 0: continue # already marked!

      # since `q` cannot be equal to bp due to cull of bp and above skip;
      # the following computation is essential to the algorithm's speed:
      # see above description in the text for how this works...
      var d: Int64 = Int64(bp) * q # `d` odd product of combination odd primes!
      pis[roi] = pis[rii] -
                   ( pis[Int(pisndxs[d >> 1]) - numbps] if d <= rtlmt
                     else Int64(pisndxs[tondx(divide(limit, d))]) )
                       + Int64(numbps)
      # eliminate rough values that have been culled in partial sieve:
      # note that `pis` and `roughs` indices relate to each other!
      roughs[roi] = UInt32(q) # update rough value
      roi += 1 # advance rough "out" index

    var m = mxndx # adjust `pisndxs` counts for the newly culled odds...
    # this is faster than recounting over the `cmpsts` array for each loop...
    for cp in range(((rtlmt // bp) - 1) | 1, bp - 1, -2): # `cp` always odd!
      # `c` is correction from current count to desired count...
      # `e` is end limit index no correction is necessary for current cull...
      var c = pisndxs[cp >> 1] - numbps; var e = Int((cp * bp) >> 1)
      while m >= e:
        pisndxs[m] -= c; m -= 1 # correct over range down to `e`

    mxri = roi - 1 # set next loop max roughs index
    numbps += 1 # count base prime

  # now `pisndxs` is a LUT of odd prime accumulated counts for all odd primes;
  # `roughs` is exactly the "k-roughs" up to the sqrt of range with `k` the
  #    index of the next prime above the quad root of the range;
  # `pis` is the partial prime counts for each of the `roughs` values...
  # note that `pis` values include the count of the odd base primes!!!

  # the following does the top most "phi tree" calculation:
  var result: Int64 = pis[0] # the answer to here is all valid `phis`
  for i in range(1, mxri + 1): result -= Int64(pis[i]) # combined by subtraction
  # compensate for the included odd base prime counts over subracted above:
  result += ((mxri + 1 + 2 * (numbps - 1)) * mxri // 2)

  # This loop adds the counts due to the products of the `roughs` primes,
  # of which we only use two different ones at a time, as all the
  # combinations with lower primes than the cube root of the range have
  # already been computed and included with the previous major loop...
  # see text description above for how this works...
  for p1i in range(1, mxri + 1):  # for all `roughs` (now prime) not including one:
    var p1: UInt64 = UInt64(roughs[p1i])
    var m: UInt64 = limit // p1 # `m` is the `p` quotient
    # so that the end limit `e` can be calculated based on `limit`/(`p`^2)
    var endndx: Int = Int(pisndxs[tondx(Int64(m // p1))]) - numbps
    # following break test equivalent to non-memoization/non-splitting optmization:
    if endndx <= p1i: break # stop at about `p` of cube root of range!
    for p2i in range(p1i + 1, endndx + 1): # for all `roughs` greater than `p` to end limit:
      result += Int64(pisndxs[tondx(divide(m, Int64(roughs[p2i])))])
    # compensate for all the extra base prime counts just added!
    result -= ((endndx - p1i) * (numbps + p1i - 1))

  result += 1 # include the count for the only even prime of two
  pisndxs.free(); roughs.free(); pis.free()

  return result

fn main():
  var pow: Int = 1
  for i in range(10):
    print('10**', i, ' = ', countPrimes(pow), sep='')
    pow *= 10

  var start = monotonic()
  var answr = countPrimes(cLIMIT)
  var elpsd = (monotonic() - start) / 1000000
  print("Found", answr, "primes up to", cLIMIT, "in", elpsd, "milliseconds.")
