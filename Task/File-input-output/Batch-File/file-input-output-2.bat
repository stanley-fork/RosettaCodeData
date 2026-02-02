@echo off
setlocal enableextensions
::read first 4 lines
<input.txt (
set /p a1=
set /p a2=
set /p a3=
set /p a4=
)
echo(%a1%>output.txt
echo(%a2%>>output.txt
echo(%a3%>>output.txt
<nul >>output.txt set/p=%a4%
