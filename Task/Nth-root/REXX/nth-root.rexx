-- 24 Aug 2025
include Setting

say 'NTH ROOT'
say version
say
parse arg x','root','digs
if x = '' then
   x = 2
if root = '' then
   root = 5
if digs = '' then
   digs = 65
numeric digits digs
say '     x = ' x
say '  root = ' root
say 'digits = ' digs
say 'answer = ' Nroot(x,root)
exit

include Math
