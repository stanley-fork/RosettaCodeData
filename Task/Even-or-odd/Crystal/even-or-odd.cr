#Using bitwise shift
  def isEven_bShift(n)
    n == ((n >> 1) << 1)
  end
  def isOdd_bShift(n)
    n != ((n >> 1) << 1)
  end
#Using modulo operator
  def isEven_mod(n)
    (n % 2) == 0
  end
  def isOdd_mod(n)
    (n % 2) != 0
  end
# Using bitwise "and"
  def isEven_bAnd(n)
    (n & 1) ==  0
  end
  def isOdd_bAnd(n)
    (n & 1) != 0
  end
# Using integer predicates
  def isEven_even(n)
    n.even?
  end
  def isOdd_odd(n)
    n.odd?
  end

puts isEven_bShift(7)
puts isOdd_bShift(7)

puts isEven_mod(12)
puts isOdd_mod(12)

puts isEven_bAnd(21)
puts isOdd_bAnd(21)

puts isEven_even(32)
puts isOdd_odd(32)
