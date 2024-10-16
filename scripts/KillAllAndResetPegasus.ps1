﻿<#
.SYNOPSIS
    Kill all front-end processes and restart the launcher.
.NOTES
    All processes are explicitly defined.
#>

# Import core modules relevant for all scripts
[string]$coreFunctionsModule = "$PSScriptRoot\CoreFunctions.psm1"
Import-Module -Name $coreFunctionsModule -Force

try {
    Open-Header

    Write-Log "Stopping all relevant processes..."
    [array]$processesToKill = @(
        'cmd'
        'explorer'
        'gslauncher'
        'In The Groove'
        'ITGMania'
        'i_view64'
        'mame'
        'mame2lit'
        'mmc'
        'notepad'
        'notepad++'
        'NotITG-v4.2.0'
        'OpenITG'
        'OpenITG-PC'
        'outfox'
        'pegasus-fe'
        'regedit'
        'spice'
        'StepMania'
        'Taskmgr'
        'timeout'
    )

    foreach ($process in $processesToKill) { Stop-Process -Name $process -ErrorAction SilentlyContinue -Force }

    Write-Log "Closing all relevant PowerShell windows..."
    [array]$windowTitlesToKill = @(
        'ResetLitboardLights'
        'RestartiCloudLoop'
        'StartBackendApps'
        'StartLitForMAME'
        'StartMAME'
    )

    foreach ($window in $windowTitlesToKill) {
        Get-Process | 
            Where-Object { $_.MainWindowTitle -like "*$window*" } | 
            Stop-Process -ErrorAction SilentlyContinue -Force
    }

    Write-Log "Starting all relevant processes..."
    Start-Process PowerShell C:\pegasus\scripts\ResetLitboardLights.ps1 -WindowStyle Hidden
    Start-Process PowerShell C:\Pegasus\scripts\RestartiCloudLoop.ps1 -WindowStyle Minimized
    Open-FullscreenImage -Image "C:\pegasus\assets\supernova.png" # Match the cabinet by default
    Start-Process 'C:\pegasus\pegasus-fe.exe'
    Set-ForegroundWindow -Window 'Pegasus'

    Write-Log "Started all relevant processes."
    Start-Sound ("C:\Games\Sounds\Megatouch_PhotoHunt_Tada.wav")
    $Script:exitCode = 0
} catch {
    Write-Log "Script failed with the following exception: [$($_.Message)]"
    $Script:exitCode = 1
} finally {
    exit $Script:exitCode
}