from memory import (memset_zero, memcpy)
from bit import pop_count
from time import monotonic

alias cLIMIT: Int = 1_000_000_000

alias cBufferSize: Int = 262144 # bytes
alias cBufferBits: Int = cBufferSize * 8

fn Intsqrt(n: UInt64) -> UInt64:
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

alias UnrollFunc = fn(UnsafePointer[UInt8], Int64, Int64, Int64) -> None

@always_inline
fn extreme[OFST: Int64, BP: Int64](pcmps: UnsafePointer[UInt8], bufsz: Int64, s: Int64, bp: Int64):
  var cp = pcmps + (s >> 3)
  var r1: Int64 = ((s + bp) >> 3) - (s >> 3)
  var r2: Int64 = ((s + 2 * bp) >> 3) - (s >> 3)
  var r3: Int64 = ((s + 3 * bp) >> 3) - (s >> 3)
  var r4: Int64 = ((s + 4 * bp) >> 3) - (s >> 3)
  var r5: Int64 = ((s + 5 * bp) >> 3) - (s >> 3)
  var r6: Int64 = ((s + 6 * bp) >> 3) - (s >> 3)
  var r7: Int64 = ((s + 7 * bp) >> 3) - (s >> 3)
  var plmt: UnsafePointer[UInt8] = pcmps + bufsz - r7
  while cp < plmt:
    cp[] |= UInt8(1 << OFST)
    cp[r1] |= UInt8(1 << ((OFST + BP) & 7))
    cp[r2] |= UInt8(1 << ((OFST + 2 * BP) & 7))
    cp[r3] |= UInt8(1 << ((OFST + 3 * BP) & 7))
    cp[r4] |= UInt8(1 << ((OFST + 4 * BP) & 7))
    cp[r5] |= UInt8(1 << ((OFST + 5 * BP) & 7))
    cp[r6] |= UInt8(1 << ((OFST + 6 * BP) & 7))
    cp[r7] |= UInt8(1 << ((OFST + 7 * BP) & 7))
    cp += bp
  var eplmt: UnsafePointer[UInt8] = plmt + r7
  if eplmt == cp or eplmt < cp: return
  cp[] |= UInt8(1 << OFST)
  cp += r1
  if eplmt == cp or eplmt < cp: return
  cp[] |= UInt8(1 << ((OFST + BP) & 7))
  cp += r2 - r1
  if eplmt == cp or eplmt < cp: return
  cp[] |= UInt8(1 << ((OFST + 2 * BP) & 7))
  cp += r3 - r2
  if eplmt == cp or eplmt < cp: return
  cp[] |= UInt8(1 << ((OFST + 3 * BP) & 7))
  cp += r4 - r3
  if eplmt == cp or eplmt < cp: return
  cp[] |= UInt8(1 << ((OFST + 4 * BP) & 7))
  cp += r5 - r4
  if eplmt == cp or eplmt < cp: return
  cp[] |= UInt8(1 << ((OFST + 5 * BP) & 7))
  cp += r6 - r5
  if eplmt == cp or eplmt < cp: return
  cp[] |= UInt8(1 << ((OFST + 6 * BP) & 7))
  cp += r7 - r6
  if eplmt == cp or eplmt < cp: return
  cp[] |= UInt8(1 << ((OFST + 7 * BP) & 7))

fn mkExtremeFuncs[SIZE: Int64]() -> UnsafePointer[UnrollFunc]:
  var jmptbl = UnsafePointer[UnrollFunc].alloc(Int(SIZE))
  @parameter
  for i in range(SIZE):
    alias OFST = i >> 2
    alias BP = ((i & 3) << 1) + 1
    jmptbl[i] = extreme[OFST, BP]
  return jmptbl

alias DenseFunc = fn(UnsafePointer[UInt64], Int64, Int64) -> UnsafePointer[UInt64]

@always_inline
fn denseCullFunc[BP: Int](pcmps: UnsafePointer[UInt64], bufsz: Int64, s: Int64) -> UnsafePointer[UInt64]:
  var cp: UnsafePointer[UInt64] = pcmps + (s >> 6)
  var plmt = pcmps + (bufsz >> 3) - BP
  while cp < plmt:
    @parameter
    for n in range(64):
      alias MUL = n * BP
      var cop = cp.offset(MUL >> 6)
      cop.store(cop.load() | (1 << (MUL & 63)))
    cp += BP
  return cp

fn mkDenseFuncs[SIZE: Int64]() -> UnsafePointer[DenseFunc]:
  var jmptbl = UnsafePointer[DenseFunc].alloc(Int(SIZE))
  @parameter
  for i in range(SIZE):
    alias BP = (i << 1) + 3
    jmptbl[i] = denseCullFunc[Int(BP)]
  return jmptbl

@always_inline
fn cullPass(dfs: UnsafePointer[DenseFunc], efs: UnsafePointer[UnrollFunc],
            cmpsts: UnsafePointer[UInt8], bytesz: Int64, s: Int64, bp: Int64):
    if bp <= 129: # dense culling
        var sm = s
        while (sm >> 3) < bytesz and (sm & 63) != 0:
            cmpsts[sm >> 3] |= UInt8(1 << (sm & 7))
            sm += bp
        var bcp = dfs[(bp - 3) >> 1](cmpsts.bitcast[UInt64](), bytesz, sm)
        var ns: Int64 = 0
        var ncp = bcp
        var cmpstslmtp = (cmpsts + bytesz).bitcast[UInt64]()
        while ncp < cmpstslmtp:
            ncp[0] |= UInt64(1 << (ns & 63))
            ns += bp
            ncp = bcp + (ns >> 6)
    else: # extreme loop unrolling culling
        efs[((s & 7) << 2) + ((bp & 7) >> 1)](cmpsts, bytesz, s, bp)
#    else:
#        for c in range(s, bytesz * 8, bp): # slow bit twiddling way
#            cmpsts[c >> 3] |= (1 << (c & 7))

fn cullPage(dfs: UnsafePointer[DenseFunc], efs: UnsafePointer[UnrollFunc],
            lwi: Int64, lmt: Int64, cmpsts: UnsafePointer[UInt8], bsprmrps: UnsafePointer[UInt8]):
    var bp: Int64 = 1; var ndx = 0
    while True:
        bp += Int64(bsprmrps[ndx]) << 1
        var i = (bp - 3) >> 1
        var s = (i + i) * (i + 3) + 3
        if s >= lmt: break
        if s >= lwi: s -= lwi
        else:
            s = (lwi - s) % bp
            if s: s = bp - s
        cullPass(dfs, efs, cmpsts, cBufferSize, s, bp)
        ndx += 1

fn countPagePrimes(ptr: UnsafePointer[UInt8], bitsz: Int64) -> Int64:
    var wordsz: Int64 = (bitsz + 63) // 64  # round up to nearest 64 bit boundary
    var rslt: Int64 = wordsz * 64
    var bigcmps = ptr.bitcast[UInt64]()
    for i in range(wordsz - 1):
       rslt -= Int64(pop_count(bigcmps[i]))
    rslt -= Int64(pop_count(bigcmps[wordsz - 1] | UInt64(-2 << ((bitsz - 1) & 63))))
    return rslt

struct SoEOdds(ImplicitlyCopyable, Movable, Sized, Iterable, Iterator):
    alias __copyinit__is_trivial = False
    alias __moveinit__is_trivial = False
    alias __del__is_trivial = False
    alias IteratorType[
          iterable_mut: Bool, //, iterable_origin: Origin[iterable_mut]
      ]: Iterator = SoEOdds
    alias Element = UInt64
    var len: Int64
    var cmpsts: UnsafePointer[UInt8] # because DynamicVector has deep copy bug in Mojo version 0.7
    var sz: Int64
    var ndx: Int64
    fn __init__(out self, limit: Int64):
        self.len = 0 if limit < 2 else (limit - 3) // 2 + 1
        self.sz = 0 if limit < 2 else self.len + 1 # for the unprocessed only even prime of two
        self.ndx = -1
        var bytesz = 0 if limit < 2 else ((self.len + 63) & -64) >> 3 # round up to nearest 64 bit boundary
        self.cmpsts = UnsafePointer[UInt8].alloc(Int(bytesz))
        memset_zero(self.cmpsts, Int(bytesz))
        var denseFuncs : UnsafePointer[DenseFunc] = mkDenseFuncs[64]()
        var extremeFuncs: UnsafePointer[UnrollFunc] = mkExtremeFuncs[32]()
        for i in range(self.len):
            var s = (i + i) * (i + 3) + 3
            if s >= self.len: break
            if (self.cmpsts[i >> 3] >> UInt8(i & 7)) & 1: continue
            var bp = i + i + 3
            cullPass(denseFuncs, extremeFuncs, self.cmpsts, bytesz, s, bp)
        self.sz = countPagePrimes(self.cmpsts, self.len) + 1 # add one for only even prime of two
    fn __del__(deinit self):
        self.cmpsts.free()
    fn __copyinit__(out self, existing: Self):
        self.len = existing.len
        var bytesz = (self.len + 7) // 8
        self.cmpsts = UnsafePointer[UInt8].alloc(Int(bytesz))
        memcpy(self.cmpsts, existing.cmpsts, Int(bytesz))
        self.sz = existing.sz
        self.ndx = existing.ndx
    fn __moveinit__(out self, deinit existing: Self):
        self.len = existing.len
        self.cmpsts = existing.cmpsts
        self.sz = existing.sz
        self.ndx = existing.ndx
    fn __len__(self: Self) -> Int: return Int(self.sz)
    fn __iter__(ref self: Self) -> Self: return self
    @always_inline
    fn __has_next__(self: Self) -> Bool:
      return self.sz > 0
    @always_inline
    fn __next__(mut self: Self) -> Self.Element:
        if self.ndx < 0:
            self.ndx = 0; self.sz -= 1; return 2
        while (self.ndx < self.len) and ((self.cmpsts[self.ndx >> 3] >> UInt8(self.ndx & 7)) & 1):
            self.ndx += 1
        var rslt = (UInt64(self.ndx) << 1) + 3; self.sz -= 1; self.ndx += 1; return rslt

struct SoEOddsPaged(ImplicitlyCopyable, Movable, Iterable, Iterator):
    alias __copyinit__is_trivial = False
    alias __moveinit__is_trivial = False
    alias __del__is_trivial = False
    alias IteratorType[
          iterable_mut: Bool, //, iterable_origin: Origin[iterable_mut]
      ]: Iterator = SoEOddsPaged
    alias Element = UInt64
    var denseFuncs : UnsafePointer[DenseFunc]
    var extremeFuncs: UnsafePointer[UnrollFunc]
    var len: Int64
    var cmpsts: UnsafePointer[UInt8] # because DynamicVector has deep copy bug in Mojo version 0.7
    var sz: Int64 # 0 means finished; otherwise contains number of odd base primes
    var ndx: Int64
    var lwi: Int64
    var bsprmrps: UnsafePointer[UInt8] # contains deltas between odd base primes starting from zero
    fn __init__(out self, limit: UInt64):
        self.denseFuncs = mkDenseFuncs[64]()
        self.extremeFuncs = mkExtremeFuncs[32]()
        self.len = 0 if limit < 2 else Int(((limit - 3) // 2 + 1))
        self.sz = 0 if limit < 2 else 1 # means iterate until this is set to zero
        self.ndx = -1 # for unprocessed only even prime of two
        self.lwi = 0
        if self.len < cBufferBits:
            var bytesz = ((self.len + 63) & -64) >> 3 # round up to nearest 64 bit boundary
            self.cmpsts = UnsafePointer[UInt8].alloc(Int(bytesz))
            self.bsprmrps = UnsafePointer[UInt8].alloc(Int(self.sz))
        else:
            self.cmpsts = UnsafePointer[UInt8].alloc(Int(cBufferSize))
            var bsprmitr = SoEOdds(Int(Intsqrt(limit)))
            self.sz = len(bsprmitr)
            self.bsprmrps = UnsafePointer[UInt8].alloc(Int(self.sz))
            var ndx = -1; var oldbp: UInt64 = 1
            for bsprm in bsprmitr:
                if ndx < 0: ndx += 1; continue # skip over the 2 prime
                self.bsprmrps[ndx] = UInt8(bsprm - oldbp) >> 1
                oldbp = bsprm; ndx += 1
            self.bsprmrps[ndx] = 255 # one extra value to go beyond the necessary cull space
    fn __del__(deinit self):
        self.cmpsts.free(); self.bsprmrps.free()
    fn __copyinit__(out self, existing: Self):
        self.denseFuncs = existing.denseFuncs
        self.extremeFuncs = existing.extremeFuncs
        self.len = existing.len
        self.sz = existing.sz
        var bytesz = cBufferSize if self.len >= cBufferBits
                     else ((self.len + 63) & -64) >> 3 # round up to nearest 64 bit boundary
        self.cmpsts = UnsafePointer[UInt8].alloc(Int(bytesz))
        memcpy(self.cmpsts, existing.cmpsts, Int(bytesz))
        self.ndx = existing.ndx
        self.lwi = existing.lwi
        self.bsprmrps = UnsafePointer[UInt8].alloc(Int(self.sz))
        memcpy(self.bsprmrps, existing.bsprmrps, Int(self.sz))
    fn __moveinit__(out self, deinit existing: Self):
        self.denseFuncs = existing.denseFuncs
        self.extremeFuncs = existing.extremeFuncs
        self.len = existing.len
        self.cmpsts = existing.cmpsts
        self.sz = existing.sz
        self.ndx = existing.ndx
        self.lwi = existing.lwi
        self.bsprmrps = existing.bsprmrps
    fn countPrimes(self) -> Int64:
        if self.len <= cBufferBits: return len(SoEOdds(2 * self.len + 1))
        var cnt: Int64 = 1; var lwi: Int64 = 0
        var cmpsts = UnsafePointer[UInt8].alloc(Int(cBufferSize))
        memset_zero(cmpsts, Int(cBufferSize))
        cullPage(self.denseFuncs, self.extremeFuncs, 0, cBufferBits, cmpsts, self.bsprmrps)
        while lwi + cBufferBits <= self.len:
            cnt += countPagePrimes(cmpsts, cBufferBits)
            lwi += cBufferBits
            memset_zero(cmpsts, Int(cBufferSize))
            var lmt = lwi + cBufferBits if lwi + cBufferBits <= self.len else self.len
            cullPage(self.denseFuncs, self.extremeFuncs, lwi, lmt, cmpsts, self.bsprmrps)
        cnt += countPagePrimes(cmpsts, self.len - lwi)
        return cnt
    fn __len__(self: Self) -> Int: return Int(self.sz)
    fn __iter__(ref self: Self) -> Self: return self
    @always_inline
    fn __has_next__(self: Self) -> Bool:
      return self.sz > 0
    fn __next__(mut self: Self) -> Self.Element: # don't count number of primes by Interating - slooow
        if self.ndx < 0:
            self.ndx = 0; self.lwi = 0
            if self.len < 2: self.sz = 0
            elif self.len <= cBufferBits:
                var bytesz = ((self.len + 63) & -64) >> 3 # round up to nearest 64 bit boundary
                memset_zero(self.cmpsts, Int(bytesz))
                for i in range(self.len):
                    var s = (i + i) * (i + 3) + 3
                    if s >= self.len: break
                    if (self.cmpsts[i >> 3] >> UInt8(i & 7)) & 1: continue
                    var bp = i + i + 3
                    cullPass(self.denseFuncs, self.extremeFuncs, self.cmpsts, bytesz, s, bp)
            else:
                memset_zero(self.cmpsts, Int(cBufferSize))
                cullPage(self.denseFuncs, self.extremeFuncs, 0, cBufferBits, self.cmpsts, self.bsprmrps)
            return 2
        var rslt = (UInt64(self.lwi + self.ndx) << 1) + 3; self.ndx += 1
        if self.lwi + cBufferBits >= self.len:
            while (self.lwi + self.ndx < self.len) and ((self.cmpsts[self.ndx >> 3] >> UInt8(self.ndx & 7)) & 1):
                self.ndx += 1
        else:
            while (self.ndx < cBufferBits) and ((self.cmpsts[self.ndx >> 3] >> UInt8(self.ndx & 7)) & 1):
                self.ndx += 1
            while (self.ndx >= cBufferBits) and (self.lwi + cBufferBits <= self.len):
                self.ndx = 0; self.lwi += cBufferBits; memset_zero(self.cmpsts, Int(cBufferSize))
                var lmt = self.lwi + cBufferBits if self.lwi + cBufferBits <= self.len else self.len
                cullPage(self.denseFuncs, self.extremeFuncs, self.lwi, lmt, self.cmpsts, self.bsprmrps)
                var buflmt = cBufferBits if self.lwi + cBufferBits <= self.len else self.len - self.lwi
                while (self.ndx < buflmt) and ((self.cmpsts[self.ndx >> 3] >> UInt8(self.ndx & 7)) & 1):
                    self.ndx += 1
        if self.lwi + self.ndx >= self.len: self.sz = 0
        return rslt

fn main():
    print("The primes to 100 are:")
    for prm in SoEOddsPaged(100): print(prm, " ", end="")
    print()
    var strt0 = monotonic()
    var answr0 = SoEOddsPaged(1_000_000).countPrimes()
    var elpsd0 = (monotonic() - strt0) / 1000000
    print("Found", answr0, "primes up to 1,000,000 in", elpsd0, "milliseconds.")
    var strt1 = monotonic()
    var answr1 = SoEOddsPaged(cLIMIT).countPrimes()
    var elpsd1 = (monotonic() - strt1) / 1000000
    print("Found", answr1, "primes up to", cLIMIT, "in", elpsd1, "milliseconds.")
