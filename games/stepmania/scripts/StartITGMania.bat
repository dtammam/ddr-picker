GOTO comment
<#
StartITGMania.bat

    Goal:
        The purpose of this script is to launch a game from pegasus-fe.exe.
        Without it, one is unable to launch a game - it does not work with .ps1 files natively.

    Audience:
        People who want to be able to launch scripts to launch games using pegasus-fe.

    Version:
        9/5/2022 - Original version
#>

# Kill pegasus-fe.exe and then launch the game
:comment
PowerShell -NoProfile -ExecutionPolicy Bypass -Command "& {Start-Process PowerShell -ArgumentList '-NoProfile -ExecutionPolicy Bypass -File ""C:\pegasus\scripts\KillPegasus.ps1""' -Verb RunAs}"
Start C:\Games\"ITGmania 0.5.1"\Program\ITGmania.exe
Exit