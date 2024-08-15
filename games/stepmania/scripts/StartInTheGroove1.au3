;~ 	StartInTheGroove1.au3
;~
;~ 	Goal:
;~		The purpose of this .au3 is to launch the relevant ROM on launch from the frontend. It'll close the frontend launcher, start the relevant prerequisite apps, and then launch the game via PowerShell script.
;~
;~ 	Audience:
;~ 		People who want to be able to launch scripts on startup.
;~
;~ 	Version:
;~ 		2022-09-20 - Original version.
;~ 		2024-08-10 - Update with reference to asset for digital marquee.

; Import WinAPI files, ensure that PowerShell launches as a 64-bit instance.
#include <WinAPIFiles.au3>
_WinAPI_Wow64EnableWow64FsRedirection(False)

; Kill Pegasus.
Run("powershell.exe -WindowStyle Hidden -File C:\pegasus\scripts\KillPegasus.ps1", "", @SW_HIDE)

; Set the dynamic marquee of choice with the correct working directory.
FileChangeDir("C:\pegasus\assets")
Run('powershell.exe -WindowStyle Hidden -File "C:\Pegasus\scripts\SetMarquee.ps1" -Image "C:\pegasus\assets\itg1.png"', "", @SW_HIDE)

; Launch the game of choice with the correct working directory.
FileChangeDir("C:\Games\In The Groove\Program")
Run('C:\Games\In The Groove\Program\In The Groove.exe', "")