-- 19 Sep 2025
include Setting

say 'LEONARDO NUMBERS'
say version
say
call Leonardo 24,1,1,1
call Leonardo 24,0,1,0
call Timer 'r'
exit

Leonardo:
-- Show sequence
arg nn,l0,l1,add
numeric digits 25
say 'First' nn+1 'Leonardo numbers starting with' l0','l1 'and adding' add
say
call CharOut ,Right(l0,8) Right(l1,7)
a=l0; b=l1
do i=2 to nn
   c=b+a+add; a=b; b=c
   call CharOut ,Right(c,8)
   if i//5=4 | i//5=9  then
      say
end
say
return

include Math
