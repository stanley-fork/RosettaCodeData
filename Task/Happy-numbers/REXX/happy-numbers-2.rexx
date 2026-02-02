-- 23 Aug 2025
include Setting

say 'HAPPY NUMBERS'
say version
say
say 'Process first 8...'
call HappyS 8
call ShowFirst8
say
say 'Process first 10 million...'
call HappyS 1e7
call ShowNth 1e1
call ShowNth 1e2
call ShowNth 1e3
call ShowNth 1e4
call ShowNth 1e5
call ShowNth 1e6
call ShowNth 1e7
say
call Timer 'R'
exit

HappyS:
procedure expose Happ. Flag.
arg xx
-- Preset squares for digital sum
do i = 0 to 9
   Pow2.i=i*i
end
-- Collect happy numbers <= 1000
Flag.=0; Happ.=0; n=0
do i = 1 while n < xx
   h=i; ll=''
   do forever
-- Squared digital sum
      ss=0
      do Length(h)
         parse var h d +1 h; ss=ss+Pow2.d
      end
      select
-- Unhappy? Flag sad sums, next number
         when Flag.ss then do
            do while ll <> ''
               parse var ll s ll; Flag.s=1
            end
            iterate i
         end
-- Repeating? Flag sad sums, next number
         when WordPos(ss,ll) > 0 then do
            do while ll <> ''
               parse var ll s ll; Flag.s=1
            end
            iterate i
         end
-- Happy? Bump, next number
         when ss = 1 then do
            n=n+1; Happ.n=i
            iterate i
         end
-- Next sum
         otherwise do
            ll=ll ss; h=ss
         end
      end
   end
end i
-- Flag happy numbers <= 1000
Flag.=0
do i = 1 to n
   h=Happ.i; Flag.h=1
end
-- Collect happy numbers > 1000 using flagged numbers
do i = 1001 while n < xx
   h=i
-- Squared digital sum
   ss=0
   do Length(h)
      parse var h d +1 h; ss=ss+Pow2.d
   end
-- Happy? Bump
   if Flag.ss then do
      n=n+1; Happ.n=i
   end
end i
-- Count
Happ.0=n
return n

ShowFirst8:
procedure expose Happ.
say 'First 8 Happy numbers are'
do i = 1 to 8
   call Charout ,Right(Happ.i,3)
end
say
return

ShowNth:
procedure expose Happ.
arg xx
xx = xx/1
say xx'th Happy number is' Happ.xx
return

include Math
