;~ 	StartITGmania.au3
;~
;~ 	Goal:
;~		The purpose of this .au3 is to launch the relevant ROM on launch from the frontend. It'll close the frontend launcher, start the relevant prerequisite apps, and hten launch the game via PowerShell script.
;~
;~ 	Audience:
;~ 		People who want to be able to launch scripts on startup.
;~
;~ 	Version:
;~ 		9/20/2022 - Original version.
;~ 		8/14/2023 - Updating path to new version of ITGmania 0.7.0
;~ 		8/14/2023 - Updating path to new version of ITGmania 0.8.0
;~ 		7/01/2024 - Standardizing path to more generally refer to a version agnostic ITGmania directory, which will prevent the need to adjust moving forward

; Import WinAPI files, ensure that PowerShell launches as a 64-bit instance.
#include <WinAPIFiles.au3>
_WinAPI_Wow64EnableWow64FsRedirection(False)

; Kill Pegasus.
Run("powershell.exe -WindowStyle Hidden -File C:\pegasus\scripts\KillPegasus.ps1", "", @SW_HIDE)

; Launch the game of choice with the correct working directory.
FileChangeDir("C:\Games\ITGmania\Program")
Run('C:\Games\ITGmania\Program\ITGmania.exe', "")