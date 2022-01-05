
#NoEnv

SendMode Input

#SingleInstance force

EnvGet, hpath, HOMEPATH

Pause::
if FileExist(hpath . "\SwapAudio\AudioDevices.dat")
	RunWait % hpath . "\SwapAudio\SwapAudioDevices.exe"
else
	MsgBox, No AudioDevices.dat file found. Please re-run the Run.cmd script to set up SwapAudio again.

return
