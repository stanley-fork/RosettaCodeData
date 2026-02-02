@echo off
setlocal
set /p i=Insert number:

::bitwise and
set /a "test1=%i%&1"

::modulo
set /a test2=%i% %% 2

set test
pause>nul
