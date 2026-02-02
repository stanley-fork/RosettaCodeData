@echo off
setlocal enableextensions
set /p istr=
set /p inum=
set /a val=inum
if not "%val%"=="75000" echo Second input should be 75000.
