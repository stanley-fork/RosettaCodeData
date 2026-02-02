# compile with: nim c -d:danger -t:-march=native --mm:arc <filename>

from std/monotimes import getMonoTime, `-`
from std/times import inMilliseconds
from std/math import `^`

# integer square root runtion
proc isqrt(n: uint64): uint64 =
  if n < 4:
    if n < 1: return 0 else: return 1
  var x: uint64 = n; var qn: int = 0; var r: uint64 = 0
  while qn < 64 and (1.uint64 shl qn) <= n: qn += 2
  var q: uint64 = 1.uint64 shl qn
  while q > 1:
    if qn >= 64:
      q = 1.uint64 shl (qn - 2); qn = 0
    else:
      q = q shr 2
    var t: uint64 =  r + q
    r = r shr 1
    if x >= t:
      x -= t; r += q
  return r

# non-recursive Legendre prime counting function for a range `limit`...
# has O(limit^(3/4)/((log n)^2)) time complexity; O(n^(1/2)) space complexity.
proc countPrimes(limit: uint64): int64 =
  if limit < 3: # can't odd sieve for value less than 3!
    return if limit < 2: 0 else: 1
  else:
    proc pip2(n: int): int {.inline.} = (n - 1) shr 1 # Phi(n, 1) function
    proc tondx(n: int): int {.inline.} = (n - 1) shr 1 # same func, diff name
    # dividing using float64 is faster than int64 for some CPU's...
    # precision limits range to maybe 1e16!
#    proc divide(n: uint64, d: int64): int {.inline.} =
#      (n.float64 / d.float64).int
    proc divide(n: uint64, d: int64): int {.inline.} = (n div d.uint64).int
#    proc divide(n: uint64, d: int64): int {.inline.} =
#      (n.float64 / d.float64).int # precision only to 2^53 - 1 or about 1e16!
    let rtlmt = limit.isqrt.int # precision limits range to maybe 1e16!
    let rtrtlmt = rtlmt.uint64.isqrt.int
    let mxndx = (rtlmt - 1) div 2
    var pisndxs = # current accumulated counts of odd primes 1 to sqrt range
      cast[ptr[UncheckedArray[uint32]]](alloc(sizeof(uint32) * (mxndx + 1)))
    # initialized for no sieving other than odds-only - partial sieved by 2...
    #   0 odd primes to 1; 1 odd prime to 3, etc....
    for i in 0 .. mxndx: pisndxs[i] = i.uint32
    var roughs = # current odd k-rough numbers up to sqrt of range; k = 2
      cast[ptr[UncheckedArray[uint32]]](alloc(sizeof(uint32) * (mxndx + 1)))
    # initialized to all odd positive numbers 1, 3, 5, ... sqrt range...
    for i in 0 .. mxndx: roughs[i] = (i + i + 1).uint32
    # array of current pi counts for above roughs...
    var pis = # starts as size of counts just as `roughs` so they align!
      cast[ptr[UncheckedArray[int64]]](alloc(sizeof(int64) * (mxndx + 1)))
    # initialized for current roughs after accounting for even prime of two...
    for i in 0 .. mxndx: pis[i] = pip2(divide(limit, (i + i + 1).int64)).int64

    # number of found base primes and current highest used rough index...
    var numbps = 0; var mxri = mxndx
    while true:
      let bp = roughs[1].int
      if bp > rtrtlmt: break

      # mark `roughs` for all current multiples of `bp`;
      # this is "partial sieving because it only culls by `bp` at a time...
      roughs[1] = 0 # mark off the `bp` in `roughs` itself
      for cullpos in countup(bp * bp, rtlmt, bp + bp):
        let ndx = pisndxs[cullpos shr 1] - numbps.uint32
        if roughs[ndx] == cullpos.uint32: roughs[ndx] = 0

      # the critical work of partial sieving is done here...
      var roi = 0 # to keep track of current used roughs index!
      for rii in 0 .. mxri: # processing over current roughs size...
        # q is not necessarily a prime but may be a
        # product of primes not yet culled by partial sieving;
        # this is what saves operations compared to recursive Legendre:
        let q = roughs[rii].int
        if q == 0: continue # skip previously marked `roughs`

        # since `q` cannot be equal to bp due to cull of bp and above skip;
        let d = bp * q # `d` odd product of some combination of odd primes!
        # the following computation is essential to the algorithm's speed:
        # see above description in the text for how this works:
        pis[roi] = pis[rii] -
          ( if d <= rtlmt: pis[pisndxs[d shr 1].int - numbps]
            else: pisndxs[tondx(divide(limit, d.int64))].int64 ) + numbps.int64

        # eliminate rough values that have been culled in partial sieve:
        # note that `pis` and `roughs` indices relate to each other!
        roughs[roi] = q.uint32 # update rough value
        roi += 1 # advance rough index

      var ci = mxndx # adjust `pisndxs` counts for the newly culled odds...
      # this is faster than recounting over the `cmpsts` array for each loop...
      for cp in countdown(((rtlmt div bp) - 1) or 1, bp, 2): # cp odd!
        # `c` is correction from current count to desired count...
        # `e` is end limit index no correction is necessary for current cull...
        let c = pisndxs[cp shr 1] - numbps.uint32
        let e = (cp * bp) shr 1
        while ci >= e: pisndxs[ci] -= c; ci -= 1 # correct for range down to `e`

      mxri = roi - 1; numbps += 1 # next loop max roughs index; count base prime

    # now `pisndxs` is a LUT of odd prime accumulated counts for all odd primes;
    # `roughs` is exactly the "k-roughs" up to the sqrt of range with `k` the
    #    index of the next prime above the quad root of the range;
    # `pis` is the partial prime counts for each of the `roughs` values...
    # note that `pis` values include the count of the odd base primes!!!

    # the following does the top most "phi tree" calculation:
    result = pis[0] # the answer to here is all valid `phis`
    for i in 1 .. mxri: result -= pis[i] # combined here by subtraction
    # compensate for the included odd base prime counts over subracted above:
    result += ((mxri + 1 + 2 * (numbps - 1)) * mxri div 2).int64

    # This loop adds the counts due to the products of the `roughs` primes,
    # of which we only use two different ones at a time, as all the
    # combinations with lower primes than the cube root of the range have
    # already been computed and included with the previous major loop...
    # see text description above for how this works...
    for p1i in 1 .. mxri:  # for all `roughs` (now prime) not including one:
      let p1 = roughs[p1i].int64
      let m = (limit div p1.uint64).int64 # `m` is the `p1` quotient
      # so that the end limit `e` can be calculated based on `limit`/(`p1`^2)
      let endndx = pisndxs[tondx((m div p1).int)].int - numbps
      # following break test equivalent to non-memoization/non-splitting optmization:
      if endndx <= p1i: break # stop at about `p1` of cube root of range!
      for p2i in p1i + 1 .. endndx: # for `pi` < `roughs` <= end limit:
         result += pisndxs[tondx(divide(m.uint64, roughs[p2i].int64))].int64
      # compensate for all the extra base prime counts just added!
      result -= ((endndx - p1i) * (numbps + p1i - 1)).int64

    result += 1 # include the count for the only even prime of two
    pisndxs.dealloc; roughs.dealloc; pis.dealloc

var pow = 1'u64
for i in 0 .. 9: echo "π(10^", i, ") = ", pow.countPrimes; pow *= 10
let pwr = 11
let strt = getMonoTime()
let answr = countPrimes(10.uint64^pwr)
let elpsd = (getMonoTime() - strt).inMilliseconds
echo "π(10^", pwr, ") = ", answr
echo "This last took ", elpsd, " milliseconds."
