-- 8 Sep 2025
include Setting

say 'ASSERTIONS'
say version
say
a=41
call Assert a = 41
say 'This line is executed'
call Assert a = 42,'The Answer to the Ultimate Question must be Forty-Two'
say 'This line is not executed'
exit

include Math
