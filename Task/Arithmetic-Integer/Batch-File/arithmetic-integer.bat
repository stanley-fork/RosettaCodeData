@echo off
echo Batch rounds towards zero and its modulus should match the sign of the first operand.
set /p a=
set /p b=
set /a "sum=a+b, difference=a-b, product=a*b, intmod=a/b, remainder=a%%b"
echo a + b = %sum%
echo a - b = %difference%
echo a * b = %product%
echo a / b = %intmod%
echo a %%(%%^) b = %remainder%
pause
