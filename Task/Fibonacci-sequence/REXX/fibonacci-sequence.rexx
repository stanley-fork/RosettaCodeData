-- 19 Sep 2025
include Setting

say 'FIBONACCI SEQUENCE'
say version
say
say 'Fibonacci numbers up to F100 are...'
call Fibonacci1 100
say
call Timer 'r'
say 'Selected Fibonacci numbers using recurrence...'
call Fibonacci2 1e2
call Fibonacci2 1e3
call Fibonacci2 1e4
call Fibonacci2 1e5
call Fibonacci2 1e6
say
call Timer 'r'
say 'Selected Fibonacci numbers using closed formula...'
call Fibonacci3 1e2
call Fibonacci3 1e3
call Fibonacci3 1e4
call Fibonacci3 1e5
say
call Timer 'r'
exit

Fibonacci1:
-- Show sequence
arg xx
numeric digits 25
call CharOut ,Right(0,22) Right(1,21)
a=0; b=1
do i=2 to xx
   c=b+a; a=b; b=c
   call CharOut ,Right(c,22)
   if i//5=4 | i//5=9 then
      say
end
say
return

Fibonacci2:
-- Get specific number sequence
arg xx
numeric digits xx/4
a=0; b=1
do i=2 to xx
   f=b+a; a=b; b=f
end
say 'F'xx '=' Left(f,10)'...'Right(f,10) '('Xpon(f) 'digits)' elaps('r')'s'
return

Fibonacci3:
-- Get specific number formula
arg xx
numeric digits xx/4
f=Round(((0.5*(1+SqRt(5)))**xx-(0.5*(1-SqRt(5)))**xx)/SqRt(5))/1
say 'F'xx '=' Left(f,10)'...'Right(f,10) '('Xpon(f) 'digits)' elaps('r')'s'
return

include Math
