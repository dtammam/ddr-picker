<#
.SYNOPSIS
    Lunch MAME.exe in an unobtrusive way.
.NOTES
    MAME.exe is required for launching 573 rhythm games and it must be opened, using the ROM and save state as arguments.
#>

# Parameters to launch the .ps1 script from a command line
param (
    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [string]$Global:ROMAndState = (Read-Host "Please input ROM and save state.")
)
# Import core modules relevant for all scripts
[string]$coreFunctionsModule = "$PSScriptRoot\CoreFunctions.psm1"
Import-Module -Name $coreFunctionsModule -Force

# Variable declaration
$Host.UI.RawUI.WindowTitle = $scriptName
[string]$Global:executablePath = 'C:\pegasus\games\ddr573-mame\'
[string]$Global:executable = 'mame.exe'
[string]$Global:iniPath = '-inipath C:\pegasus\games\ddr573-mame\'

try {
    Open-Header

    # Change the working directory to the directory with MAME in it, does not parse well without it    
    Set-Location -Path $Global:executablePath
    
    # Create our function for launching MAME with the appropriate ROM and state
    function Start-MAME {
        [CmdletBinding()]
        param(
            [Parameter(Mandatory)]
            [ValidateNotNullOrEmpty()]
            [string]$Global:ROMAndState
        )

        Start-Process -FilePath "$($Global:executablePath)\$($Global:executable)" -ArgumentList "$($Global:iniPath) $($Global:ROMAndState)"
    }

    # Start MAME.exe
    Write-Log "Cabinet: Launching MAME.exe with $($Global:ROMAndState)..."
    Start-MAME ($Global:ROMAndState)
    Write-Log "Cabinet: launched MAME.exe."
    $Script:exitCode = 0
} catch {
    Write-Log "Script failed with the following exception: [$($_.Message)]"
    $Script:exitCode = 1
} finally {
    exit $script:exitCode
}