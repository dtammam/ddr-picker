;~ 	ControlF6-StartExplorer.au3
;~
;~ 	Goal:
;~		The purpose of this .au3 is to launch the relevant .ps1 file silently and with no console via button press.
;~ 		Without it, one is unable to run a program in a truly silent way (you'll see a command prompt flicker).
;~
;~ 	Audience:
;~ 		People who want to be able to launch scripts via button press.
;~
;~ 	Version:
;~ 		2022-09-20 - Original version.
;~ 		2022-10-23 - Migration to nircmd.exe for improved screenshot resolution.
;~ 		2024-05-19 - Rename for hygiene and standardization.
;~ 		2024-08-19 - Military dates, new copy for streaming
;~      2024-09-22 - Add a Ctrl modifier
;~      2024-10-01 - Edit for new application

; Import WinAPI files, ensure that PowerShell launches as a 64-bit instance.
#include <WinAPIFiles.au3>
_WinAPI_Wow64EnableWow64FsRedirection(False)

; Hotkey for launching the app.
Global $Pressed
HotKeySet("^{F6}", "Start_Program")

; Variable to update for our specified file.
$File = 'C:\pegasus\scripts\StartApp.ps1'

; Neverending loop, waiting on the $Pressed variable.
While True
	If $Pressed Then
		; Specific line that calls PowerShell.exe to launch our script.
		RunWait('powershell.exe -WindowStyle Hidden -File "' & $File & '" -ExecutableFullPath "C:\Windows\explorer.exe"', "", @SW_HIDE)

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
