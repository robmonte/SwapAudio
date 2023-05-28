@echo off

set loc=%~dp0

net session >NUL 2>&1
if %ERRORLEVEL% == 0 (
	powershell -ExecutionPolicy Bypass -File "%loc%\Setup.ps1"
) else (
	@REM Relaunches itself as administrator if the user accepts, closes if it doesn't.
	powershell -Command "Start-Process -Verb RunAs -FilePath '%0'" >NUL 2>&1
)
