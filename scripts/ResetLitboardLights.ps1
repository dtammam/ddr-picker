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
$Host.UI.RawUI.WindowTitle = $scriptName
[string]$lightExecutable = "LightsTest"
[string]$lightUtility = "C:\pegasus\scripts\exe\$($lightExecutable).exe"

try {
    Open-Header

    Write-Output "Cabinet: Starting light test..."
    Start-Process $lightUtility -WindowStyle Hidden
    Start-Sleep -Milliseconds 325
    Write-Output "Cabinet: Stopping light test..."
    Stop-Process -Name $lightExecutable
    Write-Output "Cabinet: Stopped light test."
    $Script:exitCode = 0
} catch {
    Write-Output "Script failed with the following exception: [$($_.Message)]"
    $Script:exitCode = 1
} finally {
    exit $Script:exitCode
}