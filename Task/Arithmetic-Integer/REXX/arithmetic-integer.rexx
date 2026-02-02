-- 24 Sep 2025
include Setting

say 'ARITHMETIC - INTEGER'
say version
say
arg x','y
if x='' then
   x=3
if y='' then
   y=7
say 'All supported operations on integers...'
say 'Addition         x+y = ' x+y
say 'Subtraction      x-y = ' x-y
say 'Multiplication   x*y = ' x*y
say 'Integer division x%y = ' x%y '(rounds towards zero)'
say 'Real division    x/y = ' x/y '(might be floating point)'
say 'Remainder        x//y =' x//y
say 'Exponentiation   x**y =' x**y '(might be floating point)'
exit

include Math
