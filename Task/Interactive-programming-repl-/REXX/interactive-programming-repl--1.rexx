-- 12 Sep 2025
say 'INTERACTIVE PROGRAMMING'
say
say 'Type source code at the REXX prompt, followed by Enter.'
say 'Just Enter or command ''exit'' leaves the program.'
say
do until command = ''
   call Charout, 'REXX '
   parse pull command
   interpret command
   say
end
say 'Goodbye!'
exit
