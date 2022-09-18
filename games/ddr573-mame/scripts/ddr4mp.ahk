#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

; Kill Pegasus and start mame2lit.exe for light support.
Run, C:\pegasus\scripts\KillPegasus.vbs,, hide
Run, C:\pegasus\scripts\StartLitForMAME.vbs,, hide

; Launch the game of choice with an argument for ROM and save state in double quotes.
Run, PowerShell -WindowStyle Hidden -File "C:\pegasus\scripts\StartMAME.ps1" "ddr4mp -state o"