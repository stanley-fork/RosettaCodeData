External:
parse arg xx
say 'External' xx 'returns...'
parse version rexx
parse source system command program
say 'Interpreter ' rexx
say 'Platform    ' system
say 'Invoked as  ' command
say 'Program name' program
say 'Interface   ' address()
say
return 0
