import bigints

proc powmod(b, e, m: BigInt): BigInt =
  assert e >= 0'bi
  var e = e
  var b = b
  let t = 2'bi
  result = initBigInt(1)
  while e > 0'bi:
    if e mod t == 1'bi:
      result = (result * b) mod m
    e = e div t
    b = (b.pow 2) mod m

var
  a = initBigInt("2988348162058574136915891421498819466320163312926952423791023078876139")
  b = initBigInt("2351399303373464486466122544523690094744975233415544072992656881240319")

echo powmod(a, b, 10'bi.pow 40)
