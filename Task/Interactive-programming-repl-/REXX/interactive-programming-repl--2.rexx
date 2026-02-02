-- 12 Sep 2025
include Setting

say 'INTERACTIVE PROGRAMMING'
say version
say
say 'Type source code at the REXX prompt, followed by Enter.'
say 'Just Enter or command ''exit'' leaves the program.'
say

IgnoreError16:
include Setting

do until command = ''
   call Charout, 'REXX '
   parse pull command
   interpret command
   say
end
say 'Goodbye!'
exit

include Math
