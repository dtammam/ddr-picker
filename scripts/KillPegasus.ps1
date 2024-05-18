<#
.SYNOPSIS
    Kill the front-end launcher.
.NOTES
    Quickly kill the front-end launcher.
#>

# Import core modules relevant for all scripts
[string]$coreFunctionsModule = "$PSScriptRoot\CoreFunctions.psm1"
Import-Module -Name $coreFunctionsModule -Force

# Variable declaration
$Host.UI.RawUI.WindowTitle = $scriptName

try {
    Open-Header
    
    # Stop all relevant processes, with error actions set to silently continue in the event that some aren't open.
    Write-Output "Cabinet: Stopping all relevant processes..."
    Stop-Process -Name pegasus-fe -ErrorAction SilentlyContinue
    Write-Output "Cabinet: Stoped all relevant processes."
    $Script:exitCode = 0
} catch {
    Write-Output "Script failed with the following exception: [$($_.Message)]"
    $Script:exitCode = 1
} finally {
    exit $Script:exitCode
}