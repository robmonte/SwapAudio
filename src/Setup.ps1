
# This script will swap the default device and default communication device between two sets of input/output devices
# with a single hotkey as set by an AutoHotkey driver script.



# Global variables
$exeFile = "$env:USERPROFILE\SwapAudio\SwapAudioDevices.exe"
$dataFile = "$env:USERPROFILE\SwapAudio\AudioDevices.dat"
$ahkFile = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup\SwapAudioDevices.ahk"



# Functions
function Main() {
	Write-Host ""
	Write-Host ""

	Check-Deps 0
	
	if (-Not(Test-Path -Path "$dataFile" -PathType Leaf)) {
		First-Run 0
	}
	else {
		Write-Host "You appear to already have two pairs of audio devices configured."
		$reset = Read-Host "Would you like to reset and configure two new pairs? ([Y]es/[N]o): "

		if ($reset -eq "yes" -Or $reset -eq "ye" -Or $reset -eq "y") {
			First-Run 0
		}
		elseif ($reset -eq "no" -Or $reset -eq "n") {
			return
		}
		else {
			Write-Host -ForegroundColor Red "Incorrect confirmation input, please try again."
			Main
		}
	}

	Check-Move-AHK
	Move-Exe

	Write-Host ""
	Write-Host -ForegroundColor Green "Complete!"
	Write-Host "Press any key to exit..."
	$Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
	Exit 0
}

function Check-Deps($entry) {
	if ($entry -eq 2) {
		Write-Host ""
		Write-Host "Something went wrong. Please try installing `"AudioDeviceCmdlets`" manually."
		Exit 1
	}

	$entry++

	$checkAudioCmdlets = Get-Command -Name Get-AudioDevice -ErrorAction "SilentlyContinue"
	if (!$checkAudioCmdlets) {
		Write-Host "This program needs the Cmdlet `"AudioDeviceCmdlets`" to function properly."
		Write-Host -ForegroundColor Yellow -NoNewline  "Do you want to try installing it automatically? ([Y]es/[N]o): "
		$continue = Read-Host
		if ($continue -eq "yes" -Or $continue -eq "ye" -Or $continue -eq "y") {
			Install-Module -Name AudioDeviceCmdlets
			Check-Deps $entry
		}
		elseif ($continue -eq "no" -Or $continue -eq "n") {
			Write-Host ""
			Write-Host "Please check the README for instructions on installing AudioDeviceCmdlets."
			Write-Host "Press any key to exit..."
			$Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
			Exit 0
		}
		else {
			Write-Host -ForegroundColor Red "Incorrect confirmation input, please try again."
			Write-Host ""
			Check-Deps 0
		}
	}
}

function Check-Move-AHK() {
	Write-Host ""
	Write-Host "You can control the audio device swap with the `"Pause/Break`" key through an AutoHotkey script."
	Write-Host "This script can be set to auto-load on Windows startup so the swap key can always be pressed."
	$checkAHKCommand = Get-Command -Name AutoHotkey -ErrorAction "SilentlyContinue"
	if (!$checkAHKCommand) {
		Write-Host ""
		Write-Host -ForegroundColor Yellow "You don't have AutoHotkey installed. You can still choose to set the script to auto-run."
		Write-Host -ForegroundColor Yellow "Visit https://www.autohotkey.com/ to download and install it, or use an alternate method for setting a toggle key."
	}

	Write-Host -ForegroundColor Yellow -NoNewline  "Do you want to set the AutoHotkey script to automatically load on Windows startup? ([Y]es/[N]o): "
	$continue = Read-Host
	if ($continue -eq "yes" -Or $continue -eq "ye" -Or $continue -eq "y") {
		Copy-Item -Path "$PSScriptRoot\..\bin\SwapAudioDevices.ahk" -Destination "$ahkFile"		
		Write-Host ""
		Write-Host -ForegroundColor Green "The script has been moved to the startup folder and the script is now running! Try it out! (Pause/Break key)"
		if ($checkAHKCommand) {
			AutoHotkey.exe "$ahkFile"
		}
	}
	elseif ($continue -eq "no" -Or $continue -eq "n") {
		Write-Host ""
		Write-Host "You can move the AutoHotkey script later manually by checking the README for instructions."
	}
	else {
		Write-Host -ForegroundColor Red "Incorrect confirmation input, please try again."
		Write-Host ""
		Check-Move-AHK
	}
}

function Confirm() {
	Write-Host -ForegroundColor Yellow -NoNewline "To continue, confirm the pairs of devices are correct ([Y]es/[N]o): "
	$continue = Read-Host
	if ($continue -eq "yes" -Or $continue -eq "ye" -Or $continue -eq "y") {
		return
	}
	elseif ($continue -eq "no" -Or $continue -eq "n") {
		First-Run 1
	}
	else {
		Write-Host -ForegroundColor Red "Incorrect confirmation input, please try again."
		Write-Host ""
		Confirm
	}
}

function First-Run($entry) {
	if ($entry -eq 0) {
		Write-Host ""
		Write-Host "Below is a list of your audio devices and their ID numbers."
		Write-Host "Choose two pairs of input/output devices to swap between when prompted."
		$devList = $(Get-AudioDevice -List)
		$skipObj = @{
			Index = 0
			Name = "NONE (DON'T TOGGLE)"
			Type = "Skip"
		}
		$skip = New-Object psobject -Property $skipObj
		$devList = ,$skip + $devList
		$devList | Select-Object Index, Name, Type | Out-String
		Write-Host ""
		Write-Host -ForegroundColor Yellow "If you want to swap just input devices or just output devices, enter 0"
		Write-Host -ForegroundColor Yellow "for that device type's index number."
		Write-Host ""
	}

	$firstRecordingDeviceIndex, $firstPlaybackDeviceIndex = Get-Pair-Choice "first"
	$secondRecordingDeviceIndex, $secondPlaybackDeviceIndex = Get-Pair-Choice "second"

	Print-Pair-Choice "first" $firstRecordingDeviceIndex $firstPlaybackDeviceIndex
	Print-Pair-Choice "second" $secondRecordingDeviceIndex $secondPlaybackDeviceIndex

	Confirm

	$firstRecordingDeviceID = Index-To-ID $firstRecordingDeviceIndex
	$firstPlaybackDeviceID = Index-To-ID $firstPlaybackDeviceIndex
	$secondRecordingDeviceID = Index-To-ID $secondRecordingDeviceIndex
	$secondPlaybackDeviceID = Index-To-ID $secondPlaybackDeviceIndex

	New-Item -Path "$dataFile" -ItemType File -Force | Out-Null
	
	"$firstRecordingDeviceID $firstPlaybackDeviceID" | Out-File -FilePath "$dataFile"
	"$secondRecordingDeviceID $secondPlaybackDeviceID" | Out-File -FilePath "$dataFile" -Append
	"First" | Out-File -FilePath "$dataFile" -Append -NoNewline
}

function Get-Pair-Choice($count) {
	Write-Host -NoNewline "Enter the "
	Write-Host -NoNewline -ForegroundColor Yellow "recording "
	$RecordingDeviceIndex = Read-Host -Prompt "device index number for the $count pair of devices: "
	if ($RecordingDeviceIndex -isnot [int]) {
		Write-Host ""
		Write-Host -ForegroundColor Red "Incorrect input. Please only enter a single index number for each step."
		Write-Host ""
		Get-Pair-Choice $count
	}
	if ($RecordingDeviceIndex -ne 0) {
		$CheckRecording = Get-AudioDevice -Index $RecordingDeviceIndex | Select-Object -ExpandProperty Type
		if ($CheckRecording -ne "Recording") {
			Write-Host -ForegroundColor Red "The device index you entered was not a recording device, please try again."
			Write-Host ""
			Get-Pair-Choice $count
			return
		}
	}
	
	Write-Host -NoNewline "Enter the "
	Write-Host -NoNewline -ForegroundColor Yellow "playback "
	$PlaybackDeviceIndex = Read-Host -Prompt "device index number for the $count pair of devices: "
	if ($PlaybackDeviceIndex -isnot [int]) {
		Write-Host ""
		Write-Host -ForegroundColor Red "Incorrect input. Please only enter a single index number for each step."
		Write-Host ""
		Get-Pair-Choice $count
	}
	if ($PlaybackDeviceIndex -ne 0) {
		$CheckPlayback = Get-AudioDevice -Index $PlaybackDeviceIndex | Select-Object -ExpandProperty Type
		if ($CheckPlayback -ne "Playback") {
			Write-Host -ForegroundColor Red "The device index you entered was not a playback device, please try again."
			Write-Host ""
			Get-Pair-Choice $count
			return
		}
	}
	
	Write-Host ""
	return $RecordingDeviceIndex, $PlaybackDeviceIndex
}

function Index-To-ID($deviceIndex) {
	if ($deviceIndex -eq 0) {
		return 0
	}
	
	return Get-AudioDevice -Index $deviceIndex | Select-Object -ExpandProperty ID
}

function Move-Exe() {
	Copy-Item -Path "$PSScriptRoot\..\bin\SwapAudioDevices.exe" -Destination "$exeFile"
}

function Print-Pair-Choice($count, $recordingIndex, $playbackIndex) {
	Write-Host "Your $count pair of devices are:"
	if ($recordingIndex -eq 0) {
		Write-Host -ForegroundColor Green "   Recording device:  NONE (DON'T TOGGLE)"
	}
	else {
		Write-Host -ForegroundColor Green "   Recording device: $(Get-AudioDevice -Index $recordingIndex | Select-Object -ExpandProperty Name)"
	}
	if ($playbackIndex -eq 0) {
		Write-Host -ForegroundColor Green "   Playback device:  NONE (DON'T TOGGLE)"
	}
	else {
		Write-Host -ForegroundColor Green "   Playback device:  $(Get-AudioDevice -Index $playbackIndex | Select-Object -ExpandProperty Name)"
	}
	Write-Host ""
}

function Read-Host($prompt) {
	Write-Host $prompt -NoNewline
	return $Host.UI.ReadLine()
}



# Call the Main function
Main
