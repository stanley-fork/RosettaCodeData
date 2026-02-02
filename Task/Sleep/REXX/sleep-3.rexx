-- 24 Aug 2025
include Setting

say 'SLEEP'
say version
say
call Sleep 1
call Sleep 2
call Sleep 3
exit

Sleep:
procedure
arg s
say time('l') 'Waiting for' s 'seconds...'
'timeout /t' s '/nobreak > nul'
say time('l') 'Done!'
return

include Abend
