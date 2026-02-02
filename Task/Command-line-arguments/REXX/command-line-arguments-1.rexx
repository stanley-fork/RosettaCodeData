-- 12 Sep 2025
include Setting

-- Use arguments -c "alpha beta" -h "gamma"
say 'COMMAND-LINE ARGUMENTS (SPACE SEPARATED)'
say version
say
say 'parse arg xx:'
parse arg xx; say 'xx='xx
say
say 'arg xx:'
arg xx; say 'xx='xx
say
say 'arg x1 x2 x3 x4 x5:'
arg x1 x2 x3 x4 x5; say 'x1='x1 'x2='x2 'x3='x3 'x4='x4 'x5='x5
say
say 'parse arg x1 x2 x3 x4 x5:'
parse arg x1 x2 x3 x4 x5; say 'x1='x1 'x2='x2 'x3='x3 'x4='x4 'x5='x5
say
say 'arg x1 . x3 (placeholder):'
arg x1 . x3; say 'x1='x1 'x3='x3
say
say 'Arg(1):'
say Arg(1)
say
say 'Words:'
do n = 1 to Words(Arg(1))
   say 'n='n 'Word(Arg(1),n)='Word(Arg(1),n)
end
exit

include Abend
