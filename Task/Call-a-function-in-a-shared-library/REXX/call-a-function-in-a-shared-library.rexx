-- 12 Sep 2025
include Setting

say 'CALL A FUNCTION IN A SHARED LIBRARY'
say version
say 'Dump the variable pool'
say
if Pos('Regina',version) > 0 | Pos('ooRexx',version) > 0 then do
   call RxFuncAdd 'sysloadfuncs','rexxutil','sysloadfuncs'
   call SysLoadFuncs
   call SysDumpVariables
end
else
   say 'Sorry! Not supported for your interpreter.'
exit

include Math
