
# SwapAudio

This is a tool to make swapping between up-to two sets of audio devices as simple as possible. It supports a few swapping methods: swap between just 2 playback devices, swap betweeen just 2 recording devices, or swap between 2 sets of devices. A device set is a playback and recording device combo. For example, my personal use case for SwapAudio is to switch between my USB microphone and wired headphones (set #1) and my wireless headset (set #2) with the press of a single button.



&nbsp;



# Dependencies

Use of this tool requires a PowerShell Cmdlet set called [AudioDeviceCmdlets](https://github.com/frgnca/AudioDeviceCmdlets) to be installed. SwapAudio will ask you to install the dependency for you. You will likely be prompted to first install the NuGet provider first. Enter either ('Y' or "Yes") or ('A' or "All") for each step when asked about NuGet to install that beforehand. If you'd like to install AudioDeviceCmdlets manually, then follow the [installation instructions](https://github.com/frgnca/AudioDeviceCmdlets#installation) on the AudioDeviceCmdlets repo to set it up before running SwapAudio. Keep in mind there's the same NuGet provider requirement for manually installing AudioDeviceCmdlets.



&nbsp;



# Running

To begin, right-click the Run.cmd file and choose "Run as administrator" to configure SwapAudio. During this setup script, a few required components may prompt for install. It is recommended to allow the script to automatically get these for you when asked. Once the setup is complete, it is recommended to use a keyboard shortcut to trigger the SwapAudioDevices.exe file. A good choice would be your keyboard driver software, e.g. Corsair iCUE. If you do not have a keyboard that supports this, or you'd rather not use it, an AutoHotkey script is included that can have its keybind customized. It defaults to using the "Pause/Break" key on your keyboard as the swap key.

To have this AutoHotkey script automatically run at Windows startup, you will need to move the SwapAudioDevices.ahk file into the path located at: \
&emsp; `"%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup"` \
During the setup script, it will ask you if it can move the file for you. If you would rather do it manually, then paste this path into your Windows explorer address bar to go straight to the startup folder and move the file into it.

For the program to work out-of-the-box, the executable file needs to be in the same directory as the AudioDevices.dat file that gets generated from the setup script. During the setup script, it will ask to move the executable file for you as well. If you would rather do it manually, then place the included SwapAudioDevices.exe file (or one you built yourself) inside of the folder located at: \
&emsp; `"%USERPROFILE%\SwapAudio\"`

Lastly, to reconfigure your set(s) of audio devices that you swap between, simply run the Run.cmd file again and it will ask you to overrite the current settings with new ones.



&nbsp;



# Building

This tool is built using the [PS2EXE tool](https://github.com/MScholtes/PS2EXE) to generate a Windows executable file out of the SwapAudioDevices PowerShell script. To build a new executable from scratch, first install PS2EXE, then run the following command from the base project directory: \
&emsp; `ps2exe "src/SwapAudioDevices.ps1" "bin/SwapAudioDevices.exe"`
