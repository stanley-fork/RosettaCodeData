-- 24 Aug 2025
say 'PROGRAM NAME'
say
call Internal 'as routine'
dummy=Internal('as function')
call External 'as routine'
dummy=External('as function')
'regina External' 'as command'
'rexx External' 'as command'
exit

Internal:
parse arg xx
say 'Internal' xx 'returns...'
parse version rexx
parse source system command program
say 'Interpreter ' rexx
say 'Platform    ' system
say 'Invoked as  ' command
say 'Program name' program
say 'Interface   ' address()
say
return 0
