
# SwapAudio

This is a tool to make swapping between up-to two sets of input and output devices as simple as possible. It
supports a few swapping methods: swap between just 2 playback devices, swap betweeen just 2 recording devices,
or swap between 2 sets of devices. A device set is a playback and recording device combo. For example, my
personal use case for SwapAudio is to switch between my USB microphone and wired headphones (set #1) and my
wireless headset (set #2) with the press of a single button.



&nbsp;



# Dependencies

Use of this tool requires a PowerShell Cmdlet set called
[AudioDeviceCmdlets](https://github.com/frgnca/AudioDeviceCmdlets) to be installed. SwapAudio will ask you to
install the dependency for you. You will likely be prompted to first install the NuGet provider first. Enter either
('Y' or "Yes") or ('A' or "All") for each step when asked about NuGet to install that beforehand. If you'd like to
install AudioDeviceCmdlets manually, then follow the
[installation instructions](https://github.com/frgnca/AudioDeviceCmdlets#installation) on the AudioDeviceCmdlets
repo to set it up before running SwapAudio. Keep in mind there's the same NuGet provider requirement for manually
installing AudioDeviceCmdlets.



&nbsp;



# Downloading

To download, you can either clone this repo or visit the [releases page](https://github.com/robmonte/SwapAudio/releases). Either way is nearly identical, the only difference being the release page's zip file will not include
unnecessary files such as git files.



&nbsp;



# Running

To begin, run the `Run.cmd` file. It *should* ask you for permissions when run, but if it doesn't you can do this
manually by right-clicking it and choosing "Run as administrator". This is required to be able to function.
During this setup script, a few required components may prompt for install. It is recommended to allow the script
to automatically get these for you when asked. Once the setup is complete, it will save config files to the User
Profile and then you're ready to go.

&nbsp;

It is recommended to use a shortcut to trigger the `SwapAudioDevices.exe` file. This is the file that actually
performs the swapping of system input and output devices and comes precompiled. If you'd like to compile it yourself
from source, see the [Building & Contributing](#building--contributing) section below. A good choice would be your
keyboard driver software, e.g. Corsair iCUE. If you do not have a keyboard that supports this, or you'd rather not
use it, an AutoHotkey script is included that can have its keybind customized. It defaults to using the
"Pause/Break" key on your keyboard as the swap key.

To have this AutoHotkey script automatically run at Windows startup, you will need to move the
`SwapAudioDevices.ahk` file into the path located at: \
&emsp; `"%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup"` \
During the setup script, it will ask if it may move this file for you. If you would rather do it manually, then
paste this path into your Windows explorer address bar to find the location.

Another option is using something like an Elgato Stream Deck. In the Stream Deck software, you can set a button to
execute a regular `.exe` file by placing the "System -> Open" action onto a key, then setting the "App/File" to
the `SwapAudioDevices.exe` file path. I have included 2 choices of icons that you may use to label SwapAudio on
your Stream Deck if you like them, located in the [res](./res) folder of the project.

&nbsp;

For the program to work out-of-the-box, the executable file needs to be in the same directory as the
`AudioDevices.dat` file that gets generated from the setup script. During the setup script, it will ask to move
the executable file for you as well. If you would rather do it manually, then place either the included
`SwapAudioDevices.exe` file, or one you built yourself, inside of the folder located at: \
&emsp; `"%USERPROFILE%\SwapAudio\"`

&nbsp;

Lastly, to reconfigure the set(s) of audio devices that you swap between, simply run "SwapAudio Setup" from the
Start Menu. You should be able to search in the Start Menu to find it, but if you cannot find it, then simply
find and run the `Run.cmd` file again. It will first ask you to overwrite the current settings with new ones,
then will continue with the questions again.



&nbsp;



# Building & Contributing

This tool is built using the [PS2EXE tool](https://github.com/MScholtes/PS2EXE) to generate a Windows executable
file out of the SwapAudioDevices PowerShell script. To build a new executable from scratch, first install PS2EXE,
then run the following command from the base project directory: \
&emsp; `ps2exe "src/SwapAudioDevices.ps1" "bin/SwapAudioDevices.exe"` \
This executable is included in the bin directory for ease-of-use, but feel free to build it yourself if concerned.
It is the file that actually performs the swapping of system settings for the input and output devices.
