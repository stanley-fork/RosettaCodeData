-- 24 Aug 2025
Main:
parse version version
say 'SCOPE FUNCTION NAMES AND LABELS'
say version
say
call Routine
say Function(3)
signal Goto
say 'This line is not exected!'

Continue:
say 'Program ends'
exit

Routine:
say 'Routine invoked'
say 2*2
return

Function:
arg x
say 'Function invoked'
return x*x

Function:
arg x
say 'This label is not executed!'
return x*x

Goto:
say 'Goto invoked'
say 4*4
signal Continue
