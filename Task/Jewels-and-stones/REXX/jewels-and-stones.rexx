-- 10 Nov 2025
include Setting

say 'JEWELS AND STONES'
say version
say
call Header
call Show 'aAAbbbb','aA'
call Show 'zz','Z'
call Show 'Abc',''
call Show '','Abc'
call Show 'aBCdEF','abcdef'
call Show 'abcdeabcde','abc'
call Show 'abc','abcdef'
exit

Header:
procedure
say 'Stones     Jewels     N'
say '-----------------------'
return

Show:
procedure
parse arg stones,jewels
say Left(stones,10) Left(jewels,10) Count1(stones,jewels)
say Left(stones,10) Left(jewels,10) Count2(stones,jewels)
say
return

Count1:
procedure
parse arg stones,jewels
n=0
do i=1 to Length(stones)
   s=Substr(stones,i,1); n+=(Pos(s,jewels)>0)
end
return n

Count2:
procedure
parse arg stones,jewels
n=0
do i=1 to Length(jewels)
   s=Substr(jewels,i,1); n+=Countstr(s,stones)
end
return n

-- Abend
include Abend
