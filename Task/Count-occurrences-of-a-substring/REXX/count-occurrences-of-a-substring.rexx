-- 11 Nov 2025
include Setting

say 'COUNT SUBSTRING'
say version
say
call Task 'th','the three truths'
call Task ' ','the three truths'
call Task 'a','aaa'
call Task 'abab','abababababab'
call Task 'c','abababababab'
call Task 'a',''
call Task '','a'
exit

Task:
procedure
parse arg needle,haystack
say '"'needle'"' 'occurs' Countstr(needle,haystack) 'times in' '"'haystack'"'
return

include Abend
