-- 24 Aug 2025
include Setting

say 'SUM DIGITS OF AN INTEGER'
say version
say
call Task 1
call Task 1234
call Task 'fe'
call Task 'f0e'
call Task '1E9'
call Task 100101001
call Task 885145624
call Task 'AF771ED0A'
call Task 'ashlh2837'
call Task '123,456,789'
call Task 12345.6789
call Task 'AF12 BE34'
call Task 'Rosetta Code 2007'
call Task '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ'
exit

Task:
procedure
arg xx
say 'Digital sum of' xx 'is' DigitSum(xx)
return

DigitSum:
procedure
arg xx
rr=0
do i = 1 to Length(xx)
   rr=rr+Pos(SubStr(xx,i,1),'123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ')
end
return rr

include Math
