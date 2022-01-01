@echo off

set loc=%~dp0

net session >NUL 2>&1
if %ERRORLEVEL% == 0 (
	PowerShell.exe -ExecutionPolicy Bypass -File "%loc%\Setup.ps1"
) else (
	echo Please run this script as an administrator by right-clicking it and choosing "Run as administrator"
	pause
)
