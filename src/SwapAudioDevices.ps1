
# This script will swap the default device and default communication device between two sets of input/output devices
# with a single hotkey as set by an AutoHotkey driver script.



# Global variables
$dataFile = "$env:USERPROFILE\SwapAudio\AudioDevices.dat"



# Functions
function Main() {
	Perform-Swap
}

function Get-Current() {
	return Get-Content "$dataFile" | Select-Object -Skip 2 -First 1
}

function Set-Devices($recordingID, $playbackID) {
	if ($recordingID -ne 0) {
		Set-AudioDevice -ID "$recordingID" | Out-Null
	}
	if ($playbackID -ne 0) {
		Set-AudioDevice -ID "$playbackID" | Out-Null
	}
}

function Perform-Swap() {
	$current = Get-Current

	if ($current -eq "First") {
		$devices = Get-Content "$dataFile" | Select-Object -Skip 1 -First 1
	}
	else {
		$devices = Get-Content "$dataFile" | Select-Object -First 1
	}

	$line1 = Get-Content "$dataFile" | Select-Object -First 1
	$line2 = Get-Content "$dataFile" | Select-Object -Skip 1 -First 1

	"$line1" | Out-File -FilePath "$dataFile"
	"$line2" | Out-File -FilePath "$dataFile" -Append
	if ($current -eq "First") {
		"Second" | Out-File -FilePath "$dataFile" -Append -NoNewline
	}
	else {
		"First" | Out-File -FilePath "$dataFile" -Append -NoNewline
	}

	$devices | foreach {
		$device = $_ -split " "
	}

	Set-Devices $device[0] $device[1]
}



# Call the Main function
Main
