'<#
'KillAndResetPegasus.vbs
' 
'    Goal:
'        The purpose of this .vbs is to launch the relevant .ps1 file called by .ahk silently and with no console via button press. Without it, one is unable to run a program in a truly silent way (you'll see a command prompt flicker).
'        Uses a file variable for easy replacement of target .ps1 scripts to execute.
'
'    Audience:
'        People who want to be able to launch scripts via button press.
'
'    Version:
'        9/18/2022 - Original version.
'#>

'Set relevant variable for the engine that will execute and a lead-up with the path
powershell = "PowerShell.exe -WindowStyle Hidden -File C:\pegasus\scripts\"
file = "KillAndResetPegasus.ps1"

'Concatenate both the path and file for easy replacement in duplicate files
script = powershell+file

'Launch with a silently created console
set shell = CreateObject("Wscript.shell")
shell.run script,0