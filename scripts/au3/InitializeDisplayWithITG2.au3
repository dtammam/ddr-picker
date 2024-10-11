;~ 	InitializeDisplayWithITG2.au3
;~
;~ 	Goal:
;~		The purpose of this .au3 is to initialize the display driver which sets resolution properly for Irfanview.
;~		On first launch of Stepmania based games, the resolution glitches out Irfanview.
;~
;~ 	Audience:
;~ 		People who want to be able to launch scripts on startup.

; Import WinAPI files, ensure that PowerShell launches as a 64-bit instance.
#include <WinAPIFiles.au3>
_WinAPI_Wow64EnableWow64FsRedirection(False)

; Launch ITG2 as to trigger display resolution adjustment needed for first launch, give it a moment, then reset it post-launch
Run("C:\pegasus\games\stepmania\StartInTheGroove2.exe")

Sleep(4000)
Run("powershell.exe -WindowStyle Minimized -File C:\Pegasus\scripts\KillAllAndResetPegasus.ps1", "", @SW_HIDE)