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

; Import WinAPI files, ensure that PowerShell launches as a 64-bit instance.
#include <WinAPIFiles.au3>
_WinAPI_Wow64EnableWow64FsRedirection(False)

; Launch relevant PowerShell scripts.
Run("powershell.exe -WindowStyle Hidden -File C:\Pegasus\scripts\StartBackendApps.ps1", "", @SW_HIDE)
Run("powershell.exe -WindowStyle Minimized -File C:\Pegasus\scripts\RestartiCloudLoop.ps1", "", @SW_HIDE)

; Launch relevant apps.
Run("C:\pegasus\Plus-ScreenshotTake.exe")
Run("C:\pegasus\Slash-ScreenshotTake.exe")
Run("C:\pegasus\Spacebar-KillAllAndResetPegasus.exe")
Run("C:\pegasus\Tilde-RestartComputer.exe")
Run("C:\pegasus\F2-RegistryUpdateKioskToPC.exe")
Run("C:\pegasus\F3-RegistryUpdatePCToKiosk.exe")

; Sleep to let the VPN connect.
Sleep(4000)

; Launch Pegasus.
Run("C:\pegasus\pegasus-fe.exe")