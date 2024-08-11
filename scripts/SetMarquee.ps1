<#
.SYNOPSIS
    Opens an image in full screen
.NOTES
    Leverages the `Open-FullscreenImage` function within the CoreFunctions module to make the DDR machine's marquee awesome.
.PARAMETER Image
    Image to launch. Provide the full filepath.
.EXAMPLE
    .\SetMarquee.ps1 -Image "C:\ddr-picker-assets\ddr-picker\assets\5thmix.png"
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [string]$Image
)

# Import core modules relevant for all scripts
[string]$coreFunctionsModule = "$PSScriptRoot\CoreFunctions.psm1"
Import-Module -Name $coreFunctionsModule -Force

try {
    Open-Header

    Write-Log "Setting marquee image to [$($Image)]..."
    Open-FullscreenImage -Image $Image
    Write-Log "Set marquee image to [$($Image)] successfully."

    $Script:exitCode = 0
} catch {
    Write-Log "Script failed with the following exception: [$($_.Message)]"
    $Script:exitCode = 1
} finally {
    exit $Script:exitCode
}