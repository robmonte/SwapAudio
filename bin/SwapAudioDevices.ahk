#NoEnv

SendMode Input

#SingleInstance force

EnvGet, hpath, Homepath

Pause::
if FileExist(hpath . "\SwapAudio\AudioDevices.dat")
	RunWait % hpath . "\SwapAudio\SwapAudioDevices.exe"
else
	RunWait PowerShell.exe -ExecutionPolicy Bypass -Command ".\Setup.ps1", UserProfile . "\AutoHotkey Scripts\src\SwapAudio"

return
