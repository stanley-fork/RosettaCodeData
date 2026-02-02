-- 15 Nov 2025
include Setting
arg ww
if ww='' then
   ww=4

say 'MULTI-BASE PRIMES'
say version
say
call GetPrimes
call Timer 'r'
call Collect
call Timer 'r'
call Report
call Timer 'r'
exit

GetPrimes:
a=2*36*10**ww
say 'Get primes up to' a'...'
call Primes a
return

Collect:
say 'Collect bases up to' ww'-character numbers...'
Base. = ''
do j=1 to Prim.0
   do b=36 by -1 to 2
      n=D2n(Prim.j,b); l=Length(n)
      if l>ww then
         iterate
      if l=1 then
         Base.l.n=b Base.l.n
      else
         Base.l.n=Base.l.n b
   end
end
return

Report:
say 'Report bases up to' ww'-character numbers...'
do w=1 to ww
   a=Left(1,w,0); b=Left(9,w,9); c=0
   do n=a to b
      y=Words(Base.w.n)
      if y>c then do
         mxn=n; c=Max(c,y)
      end
   end
   say w'-character numbers that are prime in the most bases ('c')'
   do n=a to b
      y=Words(Base.w.n)
      if y=c then
         say n  'in' Strip(Base.w.n)
   end
   say
end
return

-- D2n (convert decimal to base n)
include Base
-- Primes (get primes)
include Sequence
-- Timer
include Timer
