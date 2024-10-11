;~ 	Goal:
;~		The purpose of this .au3 is to launch the relevant applications when the system starts. The compiled binary will replace explorer.exe as the shell.
;~
;~ 	Audience:
;~ 		People who want to be able to launch scripts on startup.

; Import WinAPI files, ensure that PowerShell launches as a 64-bit instance.
#include <WinAPIFiles.au3>
_WinAPI_Wow64EnableWow64FsRedirection(False)

; Launch relevant PowerShell scripts.
Run("powershell.exe -WindowStyle Hidden -File C:\Pegasus\scripts\StartBackendApps.ps1", "", @SW_HIDE)
Run("powershell.exe -WindowStyle Minimized -File C:\Pegasus\scripts\ConnectVPN.ps1", "", @SW_HIDE)
Run("powershell.exe -WindowStyle Minimized -File C:\Pegasus\scripts\RestartiCloudLoop.ps1", "", @SW_HIDE)

; Launch relevant apps.
Run("C:\pegasus\listeners\Plus-GetScreenshot.exe")
Run("C:\pegasus\listeners\Slash-GetScreenshot.exe")
Run("C:\pegasus\listeners\ControlSpacebar-KillAllAndResetPegasus.exe")
Run("C:\pegasus\listeners\ControlTilde-RestartComputer.exe")
Run("C:\pegasus\listeners\ControlF2-RegistryUpdateKioskToPC.exe")
Run("C:\pegasus\listeners\ControlF3-RegistryUpdatePCToKiosk.exe")
Run("C:\pegasus\listeners\ControlF4-StartStream.exe")
Run("C:\pegasus\listeners\ControlF5-StartCursor.exe")
Run("C:\pegasus\listeners\ControlF6-StartExplorer.exe")
Run("C:\pegasus\listeners\ControlF7-StartEdge.exe")
Run("C:\pegasus\listeners\ControlF8-StartDiagnostics.exe")

; Set the default image for our dynamic marquee.
Run('powershell.exe -WindowStyle Hidden -File "C:\Pegasus\scripts\SetMarquee.ps1" -Image "C:\pegasus\assets\supernova.png"', "", @SW_HIDE)

; Sleep to let the VPN connect.
Sleep(4000)

; Set the default image for our dynamic marquee.
Run('powershell.exe -WindowStyle Hidden -File "C:\Pegasus\scripts\SetMarquee.ps1" -Image "C:\pegasus\assets\supernova.png"', "", @SW_HIDE)

; Start ITG2 to initialize display, the reset Pegasus.
Run("C:\pegasus\scripts\exe\InitializeDisplayWithITG2.exe")

; Sleep to give Pegasus time to startup.
Sleep(3000)

; Switch focus to Pegasus.
Run('powershell.exe -WindowStyle Hidden -Command "& { Import-Module ''C:\pegasus\scripts\CoreFunctions.psm1''; Set-ForegroundWindow -Window ''Pegasus'' }"', "", @SW_HIDE)

; Play a sound indicating a successful startup.
Run('powershell.exe -WindowStyle Hidden -Command "& { Import-Module ''C:\pegasus\scripts\CoreFunctions.psm1''; Start-Sound "C:\Games\Sounds\Megatouch_PhotoHunt_LevelEnd.wav }"', "", @SW_HIDE)