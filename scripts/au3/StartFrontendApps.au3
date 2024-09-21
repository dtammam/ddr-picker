;~ 	StartFrontendApps.au3
;~
;~ 	Goal:
;~		The purpose of this .au3 is to launch the relevant applications when the system starts. This will replace explorer.exe as the shell.
;~
;~ 	Audience:
;~ 		People who want to be able to launch scripts on startup.
;~
;~ 	Version:
;~ 		9/20/2022 - Original version.
;~ 		10/23/2022 - Migration to nircmd.exe for improved screenshot resolution (Plus-Get-Screenshot.exe and Slash-Get-Screenshot.exe)
;~ 		05/19/2022 - Reference renamed Plus-GetScreenshot.exe and Slash-GetScreenshot.exe)

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

; Sleep to let the VPN connect.
Sleep(4000)

; Set the default image for our dynamic marquee.
Run('powershell.exe -WindowStyle Hidden -File "C:\Pegasus\scripts\SetMarquee.ps1" -Image "C:\pegasus\assets\supernova.png"', "", @SW_HIDE)

; Launch Pegasus.
Run("C:\pegasus\pegasus-fe.exe")

; Sleep to give Pegasus time to startup.
Sleep(3000)

; Switch focus to Pegasus.
Run('powershell.exe -WindowStyle Hidden -Command "& { Import-Module ''C:\pegasus\scripts\CoreFunctions.psm1''; Set-ForegroundWindow -Window ''Pegasus'' }"', "", @SW_HIDE)