-- 11 Sep 2025
include Setting

say 'VARIADIC FUNCTION'
say version
say
call Task 'Sin(x)',,0,Abs(-12),SqRt(12)/1,,'Number 7',,2**10
exit

Task:
procedure
do a = 1 to Arg()
   say 'Arg('a')' '=' Arg(a)
end
return

include Math
