<#
.SYNOPSIS
    Restarts the computer.
.NOTES
    Restart in a programmatic and clean way.
#>

# Import core modules relevant for all scripts
[string]$coreFunctionsModule = "$PSScriptRoot\CoreFunctions.psm1"
Import-Module -Name $coreFunctionsModule -Force

try {
    Open-Header

    Write-Log "Restarting Computer in 1 second..."
    Start-Sleep -Seconds 1
    Start-Sound ("C:\Games\Megatouch_PhotoHunt_Phew.wav")
    Restart-Computer
    $Script:exitCode = 0
} catch {
    Write-Log "Script failed with the following exception: [$($_.Message)]"
    $Script:exitCode = 1
} finally {
    exit $Script:exitCode
}