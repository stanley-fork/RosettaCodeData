-- 23 Aug 2025
include Setting

say 'MOEBIUS FUNCTION'
say version
say
numeric digits 100
call sequence 1,200
call sequence 100001,100200
call sequence 1000000001,1000000200
call sequence 10000000000001,10000000000200
exit

Sequence:
arg x,y
say 'Moebius sequence from' x 'to' y
n = 0
do i = x to y
   n = n+1
   call charout ,right(Moebius(i),3)
   if n//20 = 0 then
      say
end
say Format(Time('e'),,3) 'seconds'
say
return

include Math
