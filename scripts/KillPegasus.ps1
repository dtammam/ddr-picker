<#
.SYNOPSIS
    Kill the front-end launcher.
.NOTES
    Quickly kill the front-end launcher.
#>

# Import core modules relevant for all scripts
[string]$coreFunctionsModule = "$PSScriptRoot\CoreFunctions.psm1"
Import-Module -Name $coreFunctionsModule -Force

try {
    Open-Header
    
    # Stop all relevant processes, with error actions set to silently continue in the event that some aren't open.
    Write-Log "Stopping all relevant processes..."
    Stop-Process -Name pegasus-fe -ErrorAction SilentlyContinue
    Write-Log "Stoped all relevant processes."
    $Script:exitCode = 0
} catch {
    Write-Log "Script failed with the following exception: [$($_.Message)]"
    $Script:exitCode = 1
} finally {
    exit $Script:exitCode
}