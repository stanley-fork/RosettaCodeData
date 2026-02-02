-- 10 Oct 2025
include Setting
numeric digits 100
arg xx
if xx = '' then
   xx = 255
else
   interpret 'xx='xx

say 'NON-DECIMAL RADICES CONVERT'
say version
say
do n = 2 to 36
   say xx 'decimal =' D2n(xx,n) 'base' n '=' N2d(D2n(xx,n),n) 'decimal'
end
exit

N2d:
-- Convert base n to base 10
procedure
arg xx,yy
xx=Upper(xx)
if yy=2 then
   return X2D(B2X(xx))+0
if yy=16 then
   return X2D(xx)+0
b=XRange('0','9')XRange('A','Z'); l=Length(xx)
rr=0
do i=1 to l
   d=Pos(SubStr(xx,i,1),b)-1; rr=rr*yy+d
end i
return rr

D2n:
-- Convert base 10 to base n
procedure
arg xx,yy
if yy=2 then
   return X2B(D2X(xx))+0
if yy=16 then
   return D2X(xx)
b=XRange('0','9')XRange('A','Z')
rr=''
do while xx>0
   r=xx//yy; xx=xx%yy; rr=SubStr(b,r+1,1)rr
end
return rr

include Abend
