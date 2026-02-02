-- 12 Sep 2025
include Setting

say 'GET SYSTEM COMMAND OUTPUT'
say version '(Windows)'
say
command='dir "c:\program files\oorexx\*.cls"'; stem.=0
address system command with output stem stem.
say 'Output from system command' command'...'
say
do i = 1 to stem.0
   say stem.i
end
exit

include Abend
