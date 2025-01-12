<#
.SYNOPSIS
    Installs song banner files for ITGmania.
.DESCRIPTION
    This script copies necessary song banner files to the ITGmania theme directory.
    It ensures the destination directory exists and handles any exceptions during the process.
.NOTES
    Ensure that the CoreFunctions module is available and properly configured.
#>
param(
    [string]$InstallPath = "C:\Games\ITGmania"
)

# Import core modules relevant for all scripts
[string]$coreFunctionsModule = "$PSScriptRoot\..\..\..\scripts\CoreFunctions.psm1"
Import-Module -Name $coreFunctionsModule -Force

try {
    Open-Header

    # Define source and destination paths
    $sourceDir = $PSScriptRoot
    $destinationDir = Join-Path -Path $InstallPath -ChildPath "Themes\Simply Love\BGAnimations\ScreenSelectMusic overlay"

    # Ensure destination directory exists
    if (-not (Test-Path -Path $destinationDir)) {
        Write-Log "Creating destination directory..."
        try {
            New-Item -Path $destinationDir -ItemType Directory -Force -ErrorAction Stop | Out-Null
        }
        catch {
            throw "Failed to create destination directory at [$destinationDir] with the following exception: [$($_.Exception.Message)]"
        }
    }

    # Files to copy
    $filesToCopy = @(
        "default.lua",
        "MySongMonitor.lua"
    )

    # Copy each file
    foreach ($file in $filesToCopy) {
        $sourcePath = Join-Path -Path $sourceDir -ChildPath $file
        $destinationPath = Join-Path -Path $destinationDir -ChildPath $file
        
        if (Test-Path -Path $sourcePath) {
            Write-Log "Copying [$file] to [$destinationDir]..."
            Copy-Item -Path $sourcePath -Destination $destinationPath -Force
        } else {
            Write-Warning "Source file not found: [$sourcePath]"
        }
    }

    Write-Log "Installation complete!"
} catch {
    Write-Log "Script failed with the following exception: [$($_.Exception.Message)]"
    $Script:exitCode = 1
} finally {
    exit $Script:exitCode
}
