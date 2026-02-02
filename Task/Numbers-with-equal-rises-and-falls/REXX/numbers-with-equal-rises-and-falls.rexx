-- 21 Sep 2025
include Setting

say 'NUMBERS WITH EQUAL RISES AND FALLS'
say version
say
call Task1 200
call Task2 10000000
call Timer 'r'
exit

Task1:
-- Show the first n numbers with rises = falls
procedure
arg nn
say 'First' nn 'numbers...'
n=0
do i=1 until n=nn
   if RisesEqFalls(i) then do
      n+=1
      call CharOut ,Right(i,4)
      if n//20=0 then
         say
   end
end
say
return

Task2:
-- Show nth number with rises = falls
procedure
arg nn
n=0
do i=1 until n=nn
   if RisesEqFalls(i) then
      n+=1
end
say 'The' nn'th number is' i
say
return

RisesEqFalls:
-- Is for a number rises = falls?
procedure
arg nn
nr=0; nf=0; b=nn//10; nn%=10
do while nn>0
   a=nn//10
   if a<b then
      nr+=1
   else
      if a>b then
         nf+=1
   b=a; nn%=10
end
return (nr=nf)

include Math
