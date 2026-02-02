@echo off
call :fileexist input.txt
call :fileexist \input.txt
call :direxist docs
call :direxist \docs
goto :eof

:fileexist
if exist %1\ call :printexist File %1 0&goto:eof
if exist %1 call :printexist File %1 1&goto:eof
call :printexist File %1 0&goto:eof

:direxist
if exist %1\ call :printexist Directory %1 1&goto:eof
call :printexist Directory %1 0&goto:eof

:printexist
if %3 equ 0 (echo %1 %2 does not exist.) else (echo %1 %2 exists.)
goto:eof
