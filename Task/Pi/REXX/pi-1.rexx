-- 12 Sep 2025
include Setting
signal on halt
arg digs
if digs = '' then
   digs=1000

say 'PI - Machin formula'
say version
say
numeric digits digs+4
spit=0; pie=0; v=5; vv=v*v; g=239; gg=g*g; s=16; r=4
do n = 1 by 2 until old = pie
   old=pie; pie=pie+s/(n*v)-r/(n*g)
   s=-s; r=-r; v=v*vv; g=g*gg
   if n > 3 then
      spit=spit+1
   if spit < 4 then
      iterate
   dd=SubStr(pie,spit-3,1); call CharOut ,dd
end
dd=SubStr(pie,spit-2); l=Length(dd)-4
if l>0  then
   call CharOut ,SubStr(dd,1,l)
say
say 'Specified' digs 'digits exhausted.'
call Timer
exit

Halt:
say
say 'Halted because of Ctrl-Break.'
call Timer
exit

include Math
