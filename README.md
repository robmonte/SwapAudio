# SwapAudio

This is a tool to make swapping between two pairs of audio devices as simple as possible. It supports swapping between both two pairs of headphones and microphones together, just two pairs of headphones, or just two microphones.

&nbsp;

# Dependencies
Use of this tool requires the PowerShell Cmdlets [AudioDeviceCmdlets](https://github.com/frgnca/AudioDeviceCmdlets) to be installed. SwapAudio will ask you to install the dependency for you. If you are prompted to first install the NuGet provider, enter 'A' or "All" to allow that first. If you'd like to install AudioDeviceCmdlets manually, then follow the [installation instructions](https://github.com/frgnca/AudioDeviceCmdlets#installation) on the AudioDeviceCmdlets repo to set it up before running SwapAudio. Keep in mind the same NuGet provider requirement for manually installing it.

&nbsp;

# Running

Right-clicking the Run.cmd file and choose "Run as administrator" to configure SwapAudio. This helper file makes it easier to run the PowerShell script with the proper permissions. If you have a permissive execution policy set in PowerSheell, you can simply right-click the Setup.ps1 file and choose "Run with PowerShell" from the menu. If you don't know what this is, then just use the "Run.cmd" file. During the install, a few required components may prompt for install. It is recommended to allow this auto-setup when asked. Otherwise, refer to the below info for manual instructions.

Once the setup is complete, it is recommended to use a keyboard shortcut to trigger the SwapAudioDevices.exe file. A good choice would be your keyboard driver software, e.g. Corsair iCue. If you do not have a keyboard that supports this, or you'd rather not use it, an AutoHotkey script is included that can have its keybind customized. It defaults to using the "Pause/Break" key on your keyboard as the swap key.

To have this AutoHotkey script automatically run at Windows startup, you will need to move the SwapAudioDevices.ahk file into the path located at: `%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup` \
Runnig the Setup script will ask to move the script for you. If you would rather do it manually, then paste this path into your Windows explorer address bar to go straight to the startup folder and move the file into it.

For it script to work out-of-the-box, the executable file needs to be in the same location as the AudioDevices.dat file. Running the Setup script will ask to move the executable for you. If you would rather do it manually, then place the SwapAudioDevices.exe file included (or one you built yourself) inside of the folder located at: `%USERPROFILE%\SwapAudio\`

&nbsp;

# Building

This tool is built using the [PS2EXE tool](https://github.com/MScholtes/PS2EXE) to generate a Windows executable file. To build a new executable from scratch, install PS2EXE and then run the following command from the base project directory:

`ps2exe src/SwapAudio.ps1 bin/SwapAudioDevices.exe`