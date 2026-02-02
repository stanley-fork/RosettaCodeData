# HammingsLogImp.mojo - uses queue instead of frequent draining...
# compile with:  mojo build --march=native Hammings.mojo

# import bigints, std/math # no big ints
from math import (log2, trunc)
from memory import (memset_zero) #, memcpy)
from time import (monotonic)

alias cCOUNT: Int = 1_000_000

struct BigNat(Movable, ImplicitlyCopyable, Stringable): # enough just to support conversion and printing
  ''' Enough "infinite" precision to support as required here - multiply and
        divide by 10 conversion to string...
  '''
  var contents: List[UInt32]
  fn __init__(out self):
    self.contents = List[UInt32]()
  fn __init__(out self, val: UInt32):
    self.contents = List[UInt32](length=1, fill=val)
  fn __copyinit__(out self, existing: Self):
    self.contents = List[UInt32](existing.contents)
  fn __str__(self) -> String:
    var rslt: String = ""
    var v = List[UInt32](self.contents)
    while len(v) > 0:
      var t: UInt64 = 0
      for i in range(len(v) - 1, -1, -1):
        t = (t << 32) + Int(v[i])
        v[i] = Int(t // 10); t -= Int(v[i]) * 10
      var sz = len(v) - 1
      while sz >= 0 and v[sz] == 0: sz -= 1
      v.resize(sz + 1, 0)
      rslt = String(t) + rslt
    return rslt
  fn __imul__(mut self, rhs: Self):
    var lenl = len(self.contents); var lenr = len(rhs.contents)
    var rslt = List[UInt32](length = lenl + lenr, fill = 0)
    for i in range(lenr):
      var t: UInt64 = 0
      for j in range(lenl):
        t += Int(self.contents[j]) * Int(rhs.contents[i]) + Int(rslt[i + j])
        rslt[i + j] = Int(t & 0xFFFFFFFF); t >>= 32
      rslt[i + lenl] += Int(t)
    var sz = len(rslt) - 1
    while sz >= 0 and rslt[sz] == 0: sz -= 1
    rslt.resize(sz + 1, 0); self.contents = rslt^

alias lb2: Float64 = 1.0
alias lb3: Float64 = log2(Float64(3.0))
alias lb5: Float64 = log2(Float64(5.0))

@fieldwise_init
struct LogRep(ImplicitlyCopyable, Movable, Stringable):
  var logrep: Float64
  var x2: UInt32
  var x3: UInt32
  var x5: UInt32
  fn __del__(deinit self): return
  @always_inline
  fn mul2(self) -> Self:
    return LogRep(self.logrep + lb2, self.x2 + 1, self.x3, self.x5)
  @always_inline
  fn mul3(self) -> Self:
    return LogRep(self.logrep + lb3, self.x2, self.x3 + 1, self.x5)
  @always_inline
  fn mul5(self) -> Self:
    return LogRep(self.logrep + lb5, self.x2, self.x3, self.x5 + 1)
  fn __str__(self) -> String:
#    return "( " + String(self.x2) + ", " + String(self.x3) + ", " + String(self.x5) + " )"
    var rslt = BigNat(1)
    fn expnd(mut rslt: BigNat, bs: UInt32, n: UInt32):
      var bsm = BigNat(bs); var nm = n
      while nm > 0:
        if (nm & 1) != 0: rslt *= bsm
        tmp = bsm; bsm *= tmp; nm >>= 1
    expnd(rslt, 2, self.x2); expnd(rslt, 3, self.x3); expnd(rslt, 5, self.x5)
    return String(rslt)

alias oneLR: LogRep = LogRep(0.0, 0, 0, 0)

alias LogRepThunk = fn() escaping -> LogRep

# Since an escaping closure doesn't currently move even for last used captures, and
# List's can't be copied into closures, we could write a minimal List to do the job, or
# probably easier is to just use a Mojo Iterator struct....
struct _HammingsLogImpIter(ImplicitlyCopyable, Movable, Iterator):
  alias __copyinit__is_trivial = False
  alias __moveinit__is_trivial = False
  alias __del__is_trivial = False
  alias Element = LogRep
  var s2: List[LogRep]; var s3: List[LogRep]; var s5: LogRep; var mrg: LogRep
#  var s2p: UnsafePointer[LogRep]; var s3p: UnsafePointer[LogRep]
  var s2hdi: Int; var s2tli: Int; var s3hdi: Int; var s3tli: Int
  fn __init__(out self: Self):
    self.s2 = List[LogRep](length=512, fill=oneLR); self.s2[0] = oneLR.mul2()
    self.s3 = List[LogRep](length=1, fill=oneLR); self.s3[0] = oneLR.mul3()
    self.s5 = oneLR.mul5(); self.mrg = oneLR
#    self.s2p = self.s2.steal_data(); self.s3p = self.s3.steal_data()
    self.s2hdi = 0; self.s2tli = -1; self.s3hdi = 0; self.s3tli = -1
  fn __copyinit__(out self: Self, existing: Self, /):
    self.s2 = existing.s2.copy(); self.s3 = existing.s3.copy()
    self.s5 = existing.s5; self.mrg = existing.mrg
#    self.s2p = existing.s2p; self.s3p = existing.s3p
    self.s2hdi = existing.s2hdi; self.s2tli = existing.s2tli
    self.s3hdi = existing.s3hdi; self.s3tli = existing.s3tli
#  fn __moveinit__(out self: Self, var existing: Self, /):
#    self = existing^
  fn __has_next__(self: Self) -> Bool:
    return True # "infinite" series!
  fn __next__(mut self: Self) -> Self.Element:
    var rslt = self.s2.unsafe_get(self.s2hdi)
    var s2len = len(self.s2)
    self.s2tli += 1;
    if self.s2tli >= s2len:
      self.s2tli = 0
    if self.s2hdi == self.s2tli:
      if s2len < 1024:
        self.s2.resize(1024, oneLR) # ; self.s2p = self.s2.steal_data()
      else:
        self.s2.resize(s2len + s2len, oneLR) # ; self.s2p = self.s2.steal_data()
        for i in range(self.s2hdi):
          self.s2.unsafe_set(s2len + i, self.s2.unsafe_get(i))
#        memcpy[UInt8, 0](s2p + s2len, s2p, sizeof[LogRep]() * s2hdi)
        self.s2tli += s2len; s2len += s2len
    if rslt.logrep < self.mrg.logrep:
      self.s2hdi += 1
      if self.s2hdi >= s2len:
        self.s2hdi = 0
    else:
      rslt = self.mrg
      var s3len = len(self.s3)
      self.s3tli += 1;
      if self.s3tli >= s3len:
        self.s3tli = 0
      if self.s3hdi == self.s3tli:
        if s3len < 1024:
          self.s3.resize(1024, oneLR) # ; self.s3p = self.s3.steal_data()
        else:
          self.s3.resize(s3len + s3len, oneLR) # ; self.s3p = self.s3.steal_data()
          for i in range(self.s3hdi):
            self.s3.unsafe_set(s3len + i, self.s3.unsafe_get(i))
#          memcpy[UInt8, 0](s3p + s3len, s3p, sizeof[LogRep]() * s3hdi)
          self.s3tli += s3len; s3len += s3len
      if self.mrg.logrep < self.s5.logrep:
        self.s3hdi += 1
        if self.s3hdi >= s3len:
          self.s3hdi = 0
      else:
        self.s5 = self.s5.mul5()
      self.s3[self.s3tli] = rslt.mul3(); var t = self.s3[self.s3hdi];
      self.mrg = t if t.logrep < self.s5.logrep else self.s5
    self.s2.unsafe_set(self.s2tli, rslt.mul2()); return rslt

@fieldwise_init
struct HammingsLogImp(ImplicitlyCopyable, Movable, Iterable):
  alias __del__is_trivial = True
  alias IteratorType[
        iterable_mut: Bool, //, iterable_origin: Origin[iterable_mut]
    ]: Iterator = _HammingsLogImpIter
  fn __iter__(ref self: Self) -> _HammingsLogImpIter:
    return _HammingsLogImpIter()

fn main():
  print("The first 20 Hamming numbers are:")
  for i, h in enumerate(HammingsLogImp()):
    print(String(h) + " ", end='')
    if i >= 19: break
  print()
  for i, h in enumerate(HammingsLogImp()):
    if i >= 1691 - 1: print("The 1691st Hamming number is " + String(h)); break
  var strt: Int = monotonic()
  var ham = oneLR
  for i, h in enumerate(HammingsLogImp()):
    if i >= cCOUNT - 1: ham = h; break
  var elpsd = (monotonic() - strt) / 1000

  print("The " + String(cCOUNT) + "th Hamming number is:")
  print("2**" + String(ham.x2) + " * 3**" + String(ham.x3) + " * 5**" + String(ham.x5))
  var lg2 = lb2 * Float64(Int(ham.x2)) + lb3 * Float64(Int(ham.x3)) + lb5 * Float64(Int(ham.x5))
  var lg10 = lg2 / log2(Float64(10))
  var expnt = trunc(lg10); var num = Float64(10.0)**(lg10 - expnt)
  var apprxstr = String(num) + "E+" + String(Int(expnt))
  print("Approximately: ", apprxstr)
  var answrstr = String(ham)
  print("The result has", len(answrstr), "digits.")
  print(answrstr)
  print("This took " + String(elpsd) + " microseconds.")
