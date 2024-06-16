<#
.SYNOPSIS
    Resets lights.
.NOTES
    Take advantage of Din's LightsTest.exe which starts off by showing all lights off.
#>

# Import core modules relevant for all scripts
[string]$coreFunctionsModule = "$PSScriptRoot\CoreFunctions.psm1"
Import-Module -Name $coreFunctionsModule -Force

# Variable declaration
[string]$lightExecutable = "LightsTest"
[string]$lightUtility = "C:\pegasus\scripts\exe\$($lightExecutable).exe"

try {
    Open-Header

    Write-Log "Starting light test..."
    Start-Process $lightUtility -WindowStyle Hidden
    Start-Sleep -Milliseconds 325
    Write-Log "Stopping light test..."
    Stop-Process -Name $lightExecutable
    Write-Log "Stopped light test."
    $Script:exitCode = 0
} catch {
    Write-Log "Script failed with the following exception: [$($_.Message)]"
    $Script:exitCode = 1
} finally {
    exit $Script:exitCode
}