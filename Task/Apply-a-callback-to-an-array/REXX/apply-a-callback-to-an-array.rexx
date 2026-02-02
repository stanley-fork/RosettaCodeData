-- 8 Sep 2025
include Setting

say 'APPLY A CALLBACK TO AN ARRAY'
say version
say
call Task 'x'
call Task ''
call Task 'Sqrt(x)'
call Task 'Sin(x)'
call Task 'Exp(x)'
exit

Task:
-- Get function to apply
parse arg function
-- Example array with x-values
array.=0; n=10
do i = 1 to n
   array.i=i
end
array.0 = n
if function = '' then do
-- Apply fixed function to each element
   do i = 1 to array.0
      array.i=Square(array.i)
   end
   function='Square(x)'
end
else do
-- Apply dynamic function to each element
   do i = 1 to array.0
      array.i=Std(Eval(function,array.i)/1)
   end
end
-- Show after callback
call Show
return

Show:
say ' x' function
do i = 1 to n
   say Right(i,2) array.i
end
say
return

Square:
arg xx
return xx**2

include Math
