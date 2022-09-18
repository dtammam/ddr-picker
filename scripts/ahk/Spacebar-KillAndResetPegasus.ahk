/*
<#
Spacebar-KillandResetPegasus.ahk

    Goal:
        The purpose of this .ahk is to launch the relevant script via button press.
        Without it, one is unable to map the related script to a button press.

    Audience:
        People who want to be able to launch scripts via button press.

    Version:
        8/27/2022 - Original version
        9/5/2022 - Updated comment block
        9/17/2022 - Use hidden windowstyle for silent execution
        9/18/2022 - New logic of .ahk to .vbs to .ps1
#>
*/

; # Default .ahk file configuration settings

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

; # Run the pre-designated .ps1 file with the button press

Space::
Run, C:\pegasus\scripts\KillAndResetPegasus.vbs,, hide