
# This script will swap the default device and default communication device between two sets of input/output devices
# with a single hotkey as set by an AutoHotkey driver script.



# Global variables
$dataFile = "$env:USERPROFILE\AutoHotkey Scripts\SwapAudio\AudioDevices.dat"



# Functions
function Main() {
	Write-Host ""
	Write-Host ""
	
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

	New-Item -Path "$dataFile" -ItemType File -Force
	
	"$firstRecordingDeviceID $firstPlaybackDeviceID" | Out-File -FilePath "$dataFile"
	"$secondRecordingDeviceID $secondPlaybackDeviceID" | Out-File -FilePath "$dataFile" -Append
	"First" | Out-File -FilePath "$dataFile" -Append -NoNewline
}

function Get-Pair-Choice($count) {
	Write-Host -NoNewline "Enter the "
	Write-Host -NoNewline -ForegroundColor Yellow "recording "
	$RecordingDeviceIndex = Read-Host -Prompt "device index number for the $count pair of devices: "
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
	$PlaybackDeviceIndex = Read-Host -Prompt "device index number for the $count pair of devices:  "
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
