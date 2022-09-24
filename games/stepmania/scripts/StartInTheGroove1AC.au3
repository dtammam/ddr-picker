;~ 	StartInTheGroove1AC.au3
;~
;~ 	Goal:
;~		The purpose of this .au3 is to launch the relevant ROM on launch from the frontend. It'll close the frontend launcher, start the relevant prerequisite apps, and then launch the game via PowerShell script.
;~
;~ 	Audience:
;~ 		People who want to be able to launch scripts on startup.
;~
;~ 	Version:
;~ 		9/20/2022 - Original version.
;~ 		9/23/2022 - Modification to final ITG1 AC version.

; Import WinAPI files, ensure that PowerShell launches as a 64-bit instance.
#include <WinAPIFiles.au3>
_WinAPI_Wow64EnableWow64FsRedirection(False)

; Kill Pegasus.
Run("powershell.exe -WindowStyle Hidden -File C:\pegasus\scripts\KillPegasus.ps1", "", @SW_HIDE)

; Launch the game of choice with the correct working directory.
FileChangeDir("C:\Games\2004-08-30 ITG1 Arcade Final\Program")
Run('C:\Games\2004-08-30 ITG1 Arcade Final\Program\StepMania.exe', "")