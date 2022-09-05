/*
<#
Slash-ScreenshotTake.ahk

    Goal:
        The purpose of this .ahk is to launch the relevant .ps1 via button press.
        Without it, one is unable to map the related script to a button press.

    Audience:
        People who want to be able to launch scripts via button press.

    Version:
        8/27/2022 - Original version
        9/5/2022 - Updated comment block
#>
*/

; # Default .ahk file configuration settings

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

SetKeyDelay, 0, 50

/::
Run, powershell  -noLogo -ExecutionPolicy unrestricted -file C:\Games\ScreenshotTake.ps1,, Hide