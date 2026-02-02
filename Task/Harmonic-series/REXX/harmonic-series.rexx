-- 11 Sep 2025
include Setting
numeric digits 16

say 'HARMONIC SERIES'
say version
say
call First20
call Greater
call Timer
exit

First20:
procedure
say 'First 20 Harmonic numbers...'
say
s=0
do n = 1 to 20
   s=s+1/n
   call CharOut ,Format(s,2,11)
   if n//5 = 0 then
      say
end
say
return 0

Greater:
procedure
say 'First Harmonic number > given Integer...'
say
say 'Int     Seqno          Value'
s=0; i=1
do n = 1 to 275E6
   s=s+1/n
   if s > i then do
      say Right(i,3) Right(n,9) Format(s,2,11)
      i=i+1
   end
end
say
return 0

include Math
