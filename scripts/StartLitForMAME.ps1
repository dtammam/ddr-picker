<#
.SYNOPSIS
    Start lights for MAME.
.NOTES
    Open the required executable silently which facilitates lights within MAME games.
.LINK
    Starting hidden processes - https://devblogs.microsoft.com/scripting/powertip-start-hidden-process-with-powershell/
#>

# Import core modules relevant for all scripts
[string]$coreFunctionsModule = "$PSScriptRoot\CoreFunctions.psm1"
Import-Module -Name $coreFunctionsModule -Force

# Variable declaration
[string]$executablePath = 'C:\pegasus\scripts\exe\mame2lit.exe'

try {
    Open-Header

    # Launch mame2lit.exe
    Write-Log "Launching mame2lit.exe..."
    Start-Process -WindowStyle Hidden -FilePath $executablePath
    Write-Log "Launched mame2lit.exe."
    $Script:exitCode = 0
} catch {
    Write-Log "Script failed with the following exception: [$($_.Message)]"
    $Script:exitCode = 1
} finally {
    exit $Script:exitCode
}