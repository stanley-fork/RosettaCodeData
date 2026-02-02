-- 8 Nov 2025
include Setting

say 'COUNT IN FACTORS'
say version
say
numeric digits 100

call CountFactors 1
call CountFactors 1e5
call CountFactors 1e10
call CountFactors 1e15
call CountFactors 1e20
call CountFactors 1e25
call CountFactors 1e30
exit

CountFactors:
arg x,y
say 'Factor the numbers' x 'to' x'+20...'
do i=x to x+20
   if i=1 then
      s='1 = 1'
   else do
      s=i '='; f=FactorS(i)
      do j=1 to f
         s=s Fact.j
         if j<f then
            s=s 'x'
      end j
   end
   say s
end i
call Timer 'R'
return

-- FactorS
include Sequence
-- Timer
include Timer
