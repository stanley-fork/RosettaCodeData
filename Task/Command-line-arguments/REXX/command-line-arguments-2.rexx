-- 12 Sep 2025
include Setting

-- Use arguments -c,alpha beta,-h,gamma
say 'COMMAND-LINE ARGUMENTS (COMMA SEPARATED)'
say version
say
say 'parse arg xx:'
parse arg xx; say xx
say
say 'arg xx:'
arg xx; say xx
say
say 'parse arg x1,x2,x3,x4:'
parse arg x1','x2','x3','x4; say 'x1' x1 'x2' x2 'x3' x3 'x4' x4
say
say 'arg x1,x2,x3,x4:'
arg x1','x2','x3','x4; say 'x1' x1 'x2' x2 'x3' x3 'x4' x4
say
say 'parse arg x1,.,x3 (placeholder):'
parse arg x1','.','x3; say 'x1' x1 'x3' x3
say
say 'arg(1):'
say arg(1)
exit

include Abend
