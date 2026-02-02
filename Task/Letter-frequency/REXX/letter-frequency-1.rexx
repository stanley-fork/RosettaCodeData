-- 10 Nov 2025
include Setting
arg file
if file='' then
   file='Miserables.txt'

say 'LETTER FREQUENCY'
say version
say
call CountLetters(file)
call ShowLetters
call Timer
exit

CountLetters:
procedure expose Lett.
arg file
Lett.=0; a=0; b=0
do while Lines(file)
   line=Linein(file); a+=1; l=Length(line); b+=l
   do i=1 to l
      d=C2d(Substr(line,i,1)); Lett.d+=1
   end
end
say a 'lines,' b 'characters'
say
return

ShowLetters:
procedure expose Lett.
say 'l hex dec  count'
say '----------------'
do i=0 to 255
   if Lett.i>0 then do
      say D2c(i) Right(D2x(i),3) Right(i,3) Right(Lett.i,6)
   end
end
return

-- Timer
include Timer
