-- 24 Sep 2025
include Setting
numeric digits 20

say 'SYSTEM TIME'
say version
say
say 'Below examples may be coded with full option or only first letter.'
say 'Both uppercase and lowercase are accepted.'
say 'Not shown here, but the Time() function also supports conversions.'
say
say 'Consume some time...'
do 100000000
end
say
w=18
say 'Time() function...'
say 'Default ' Left(Time(),w)    'same as Normal'
say 'Civil   ' Left(Time('C'),w) 'am/pm notation'
say 'Elapsed ' Left(Time('E'),w) 'sss.ddd000 seconds'
if Pos('ooRexx',version) > 0 then
   say 'Full    ' Left(Time('F'),w) 'microsecs since Jan 1, 0001, 00:00:00 (ooRexx)'
say 'Hours   ' Left(Time('H'),w) 'since midnight'
if Pos('Regina',version) > 0 then
   say 'Job     ' Left(Time('J'),w) 'cpu seconds (Regina)'
say 'Long    ' Left(Time('L'),w) 'hh:mm:ss.ddd000'
say 'Minutes ' Left(Time('M'),w) 'since midnight'
say 'Normal  ' Left(Time('N'),w) 'hh:mm:ss'
say 'Offset  ' Left(Time('O'),w) 'microsecs local (summer) time minus UTC'
say 'Reset   ' Left(Time('R'),w) 'reset elapsed'
say 'Seconds ' Left(Time('S'),w) 'since midnight'
say 'Ticks   ' Left(Time('T'),w) 'seconds since Jan 1, 1970, 00:00:00'
exit

include Abend
