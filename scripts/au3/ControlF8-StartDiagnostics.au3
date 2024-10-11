;~ 	Goal:
;~		The purpose of this .au3 is to launch the relevant .ps1 file silently and with no console via button press.
;~ 		Without it, one is unable to run a program in a truly silent way (you'll see a command prompt flicker).
;~
;~ 	Audience:
;~ 		People who want to be able to launch scripts via button press.

; Import WinAPI files, ensure that PowerShell launches as a 64-bit instance.
#include <WinAPIFiles.au3>
_WinAPI_Wow64EnableWow64FsRedirection(False)

; Hotkey for launching the app.
Global $Pressed
HotKeySet("^{F8}", "Start_Program")

; Variable to update for our specified file.
$File = 'C:\pegasus\scripts\StartApp.ps1'

; Neverending loop, waiting on the $Pressed variable.
While True
	If $Pressed Then
		; Specific line that calls PowerShell.exe to launch our script.
		RunWait('powershell.exe -WindowStyle Hidden -File "' & $File & '" -ExecutableFullPath "C:\Program Files\LatencyMon\LatMon.exe"', "", @SW_HIDE)
		; Specific line that calls PowerShell.exe to launch our script.
		RunWait('powershell.exe -WindowStyle Hidden -File "' & $File & '" -ExecutableFullPath "C:\pegasus\scripts\exe\dpclat.exe"', "", @SW_HIDE)
		$Pressed = Not $Pressed
	EndIf
	; Nothing!
	Tooltip("")
WEnd

; Function for triggering the $Pressed variable.
Func Start_Program()
	$Pressed = Not $Pressed
	Return $Pressed
EndFunc
