<#
.SYNOPSIS
    Restarts the computer.
.NOTES
    Restart in a programmatic and clean way.
#>

# Import core modules relevant for all scripts
[string]$coreFunctionsModule = "$PSScriptRoot\CoreFunctions.psm1"
Import-Module -Name $coreFunctionsModule -Force

# Variable declaration
$Host.UI.RawUI.WindowTitle = $scriptName

try {
    Open-Header

    Write-Output "Cabinet: Restarting Computer in 1 second..."
    Start-Sleep -Seconds 1
    Restart-Computer
    $Script:exitCode = 0
} catch {
    Write-Output "Script failed with the following exception: [$($_.Message)]"
    $Script:exitCode = 1
} finally {
    exit $Script:exitCode
}