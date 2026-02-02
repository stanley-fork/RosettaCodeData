-- 29 Aug 2025
include Setting

say 'LINEAR CONGRUENTIAL GENERATOR'
say version
say
numeric digits 20
Memo. = 0
say '-------------------'
say ' n        BSD    MS'
say '-------------------'
do i = 1 to 10
   say Right(i,2) Right(MSD(),10) Right(MS(),5)
end
say '-------------------'
exit

MSD:
procedure expose Memo.
Memo.msd = (1103515245*Memo.msd+12345)//(2**31)
return Memo.msd

MS:
procedure expose Memo.
Memo.ms = (214013*Memo.ms+2531011)//(2**31)
return Memo.ms%(2**16)

include Math
