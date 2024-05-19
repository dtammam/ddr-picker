<#
.SYNOPSIS
    Kill all front-end processes and restart the launcher.
.NOTES
    All processes are explicitly defined.
#>

# Import core modules relevant for all scripts
[string]$coreFunctionsModule = "$PSScriptRoot\CoreFunctions.psm1"
Import-Module -Name $coreFunctionsModule -Force

# Variable declaration
$Host.UI.RawUI.WindowTitle = $scriptName

try {
    Open-Header

    # Stop all relevant processes, with error actions set to silently continue in the event that some aren't open.
    Write-Log "Stopping all relevant processes..."
    Stop-Process -Name pegasus-fe -ErrorAction SilentlyContinue
    Stop-Process -Name spice -ErrorAction SilentlyContinue
    Stop-Process -Name StepMania -ErrorAction SilentlyContinue
    Stop-Process -Name mame -ErrorAction SilentlyContinue
    Stop-Process -Name mame2lit -ErrorAction SilentlyContinue
    Stop-Process -Name outfox -ErrorAction SilentlyContinue
    Stop-Process -Name gslauncher -ErrorAction SilentlyContinue
    Stop-Process -Name ITGMania -ErrorAction SilentlyContinue
    Stop-Process -Name cmd -ErrorAction SilentlyContinue
    Stop-Process -Name explorer -ErrorAction SilentlyContinue
    Stop-Process -Name OpenITG-PC -ErrorAction SilentlyContinue
    Stop-Process -Name OpenITG -ErrorAction SilentlyContinue
    Stop-Process -Name Taskmgr -ErrorAction SilentlyContinue	
    Stop-Process -Name cmd -ErrorAction SilentlyContinue -Force
    Stop-Process -Name timeout -ErrorAction SilentlyContinue	
    Stop-Process -Name notepad -ErrorAction SilentlyContinue -Force
    Stop-Process -Name notepad++ -ErrorAction SilentlyContinue -Force
    Stop-Process -Name regedit -ErrorAction SilentlyContinue -Force
    Stop-Process -Name mmc -ErrorAction SilentlyContinue -Force
    Stop-Process -Name NotITG-v4.2.0 -ErrorAction SilentlyContinue -Force
    Stop-Process -Name "In The Groove" -ErrorAction SilentlyContinue -Force
    Get-Process | Where-Object { $_.MainWindowTitle -like '*RestartiCloudLoop' } | Stop-Process -ErrorAction SilentlyContinue -Force
    Get-Process | Where-Object { $_.MainWindowTitle -like '*StartLitForMAME' } | Stop-Process -ErrorAction SilentlyContinue -Force
    Get-Process | Where-Object { $_.MainWindowTitle -like '*StartMAME' } | Stop-Process -ErrorAction SilentlyContinue -Force
    Get-Process | Where-Object { $_.MainWindowTitle -like '*ResetLitboardLights' } | Stop-Process -ErrorAction SilentlyContinue -Force
    Get-Process | Where-Object { $_.MainWindowTitle -like '*StartBackendApps' } | Stop-Process -ErrorAction SilentlyContinue -Force

    # Start all relevant processes, ensuring that the frontend launcher starts last so it is the focused window.
    Write-Log "Starting all relevant processes..."
    Start-Process PowerShell C:\pegasus\scripts\ResetLitboardLights.ps1 -WindowStyle Hidden
    Start-Process PowerShell C:\Pegasus\scripts\RestartiCloudLoop.ps1 -WindowStyle Minimized
    Start-Process C:\pegasus\pegasus-fe.exe
    Write-Log "Started all relevant processes."
    $Script:exitCode = 0
} catch {
    Write-Log "Script failed with the following exception: [$($_.Message)]"
    $Script:exitCode = 1
} finally {
    exit $Script:exitCode
}