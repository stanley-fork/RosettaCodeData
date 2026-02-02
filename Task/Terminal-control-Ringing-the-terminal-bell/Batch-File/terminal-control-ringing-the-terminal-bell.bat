@echo off
setlocal enableextensions
pushd %~dp0
forfiles /m "%~nx0" /c "cmd /c echo 0x07"
