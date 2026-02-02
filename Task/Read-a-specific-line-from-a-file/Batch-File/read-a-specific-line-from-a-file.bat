@echo off
setlocal enableextensions
for /f skip^=6^ tokens^=*^ delims^=^ eol^= %%a in (%1) do (
echo(%%a
goto:eof
)
