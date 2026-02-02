-- 12 Sep 2025
include Setting
signal on halt
arg digs
if digs = '' then
   digs=1000

say 'PI - Gibbons Spigot'
say version
say
numeric digits digs+4
q=1; r=0; t=1; k=1; n=3; l=3; z=0; dot=1
do until z = digs
   qq=q+q; tn=t*n
   if qq+qq+r-t < tn then do
      z=z+1; call CharOut ,n
      if dot then do
         dot=0; call CharOut ,.
      end
      nr=(r-tn)*10; n=((((qq+q+r)*10)/t)-n*10)%1
      q=q*10
   end
   else do
      nr=(qq+r)*l; tl=t*l; n=(q*(k*7+2)+r*l)/tl%1
      q=q*k; t=tl; l=l+2; k=k+1
   end
   r=nr
end
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
