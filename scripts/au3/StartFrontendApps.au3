;~ 	StartFrontendApps.au3
;~
;~ 	Goal:
;~		The purpose of this .au3 is to launch the relevant applications when the system starts. This will replace explorer.exe as the shell.
;~
;~ 	Audience:
;~ 		People who want to be able to launch scripts on startup.
;~
;~ 	Version:
;~ 		2022-09-20: Original version
;~ 		2022-10-23: Migration to nircmd.exe for improved screenshot resolution (Plus-Get-Screenshot.exe and Slash-Get-Screenshot.exe)
;~ 		2022-05-19: Reference renamed Plus-GetScreenshot.exe and Slash-GetScreenshot.exe)
;~ 		2024-10-06: Added section to start ITG2 for display initialization/reset and converted time to military

; Import WinAPI files, ensure that PowerShell launches as a 64-bit instance.
#include <WinAPIFiles.au3>
_WinAPI_Wow64EnableWow64FsRedirection(False)

; Launch relevant PowerShell scripts.
Run("powershell.exe -WindowStyle Hidden -File C:\Pegasus\scripts\StartBackendApps.ps1", "", @SW_HIDE)
Run("powershell.exe -WindowStyle Minimized -File C:\Pegasus\scripts\ConnectVPN.ps1", "", @SW_HIDE)
Run("powershell.exe -WindowStyle Minimized -File C:\Pegasus\scripts\RestartiCloudLoop.ps1", "", @SW_HIDE)

; Launch relevant apps.
Run("C:\pegasus\Plus-GetScreenshot.exe")
Run("C:\pegasus\Slash-GetScreenshot.exe")
Run("C:\pegasus\ControlSpacebar-KillAllAndResetPegasus.exe")
Run("C:\pegasus\ControlTilde-RestartComputer.exe")
Run("C:\pegasus\ControlF2-RegistryUpdateKioskToPC.exe")
Run("C:\pegasus\ControlF3-RegistryUpdatePCToKiosk.exe")
Run("C:\pegasus\ControlF4-StartStream.exe")
Run("C:\pegasus\ControlF5-StartVSCode.exe")
Run("C:\pegasus\ControlF6-StartExplorer.exe")
Run("C:\pegasus\ControlF7-StartEdge.exe")

; Set the default image for our dynamic marquee.
Run('powershell.exe -WindowStyle Hidden -File "C:\Pegasus\scripts\SetMarquee.ps1" -Image "C:\pegasus\assets\supernova.png"', "", @SW_HIDE)

; Sleep to let the VPN connect.
Sleep(4000)

; Set the default image for our dynamic marquee.
Run('powershell.exe -WindowStyle Hidden -File "C:\Pegasus\scripts\SetMarquee.ps1" -Image "C:\pegasus\assets\supernova.png"', "", @SW_HIDE)

; Start ITG2 to initialize display, the reset Pegasus.
Run("C:\pegasus\InitializeDisplayWithITG2.exe")

; Sleep to give Pegasus time to startup.
Sleep(3000)

; Switch focus to Pegasus.
Run('powershell.exe -WindowStyle Hidden -Command "& { Import-Module ''C:\pegasus\scripts\CoreFunctions.psm1''; Set-ForegroundWindow -Window ''Pegasus'' }"', "", @SW_HIDE)