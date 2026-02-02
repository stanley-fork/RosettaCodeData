-- 30 Sep 2025
include Setting

say 'CALCULATING THE VALUE OF E'
say version
say
-- divide by 1 rounds to current digits
numeric digits 9
say E()/1
numeric digits 18
say E()/1
numeric digits 33
say E()/1
numeric digits 66
say E()/1
exit

E:
procedure
-- 3 extra digits to avoid roundoff errors
numeric digits Digits()+3
-- 1 fuzz digit for loop control
numeric fuzz 1
-- Taylor series
rr=2; t=1
do n=2 until rr=v
   v=rr; t=t/n; rr+=t
end n
return rr

include Abend
