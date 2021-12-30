# SwapAudio

This is a tool to make swapping between two pairs of audio devices as simple as possible. It supports swapping between both two pairs of headphones and microphones together, just two pairs of headphones, or just two microphones.

&nbsp;

# Running

Begin by double-clicking the Run.cmd file to configure SwapAudio. This helper cmd file is likely necessary to run the PowerShell script with the proper permissions. If you have a permissive execution policy already set in PowerSheell to allow scripts, you can simply right-click the Setup.ps1 file and choose "Run with PowerShell" from the context menu. If you don't know what this is, then just use the "Run.cmd" file which will  invoke the PowerShell script for you.

Once the setup is complete, it is recommended to use a keyboard shortcut tool to map a key or key combination to trigger the SwapAudioDevices.exe file. A good choice would be your keyboard driver software, such as Corsair iCue. If you do not have a keyboard that supports this, or you'd rather not use such driver software, an AutoHotkey script is included that can have its keybind customized. It defaults to using the "Pause/Break" key on your keyboard as the swap key.

To have this AutoHotkey script automatically run at Windows startup, you will need to move the SwapAudioDevices.ahk file into the path located at: `%appdata%\Microsoft\Windows\Start Menu\Programs\Startup` \
Paste this path into your Windows explorer address bar to go straight to the folder, then move the script to it.

&nbsp;

# Dependencies
Use of this tool requires the PowerShell Cmdlets [AudioDeviceCmdlets](https://github.com/frgnca/AudioDeviceCmdlets) to be installed. Follow the [installation instructions](https://github.com/frgnca/AudioDeviceCmdlets#installation) on the AudioDeviceCmdlets repo to set it up before running SwapAudio.

&nbsp;

# Building

This tool is built using the [PS2EXE tool](https://github.com/MScholtes/PS2EXE) to generate a Windows executable file. To build a new executable, run the following command from the base project directory:

`ps2exe src/SwapAudio.ps1 bin/SwapAudioDevices.exe`