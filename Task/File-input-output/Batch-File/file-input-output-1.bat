@echo off
setlocal enableextensions
set /p a=<input.txt
:: no trailing newline
<nul >output.txt set/p=%a%
