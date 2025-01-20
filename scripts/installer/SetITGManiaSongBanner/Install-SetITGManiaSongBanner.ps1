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

    # Define source and destination base paths
    $sourceBaseDir = $PSScriptRoot
    $destinationBaseDir = Join-Path -Path $InstallPath -ChildPath "Themes\Simply Love\BGAnimations"

    # Directories to copy contents from
    $directoriesToCopy = @(
        "ScreenGameplay overlay",
        "ScreenSelectMusic overlay"
    )

    # Check each destination directory exists and copy files
    foreach ($dir in $directoriesToCopy) {
        $sourceDir = Join-Path -Path $sourceBaseDir -ChildPath $dir
        $destinationDir = Join-Path -Path $destinationBaseDir -ChildPath $dir

        # Check if destination directory exists
        if (-not (Test-Path -Path $destinationDir)) {
            $errorMessage = "Destination directory [$destinationDir] does not exist."
            Write-Log $errorMessage
            throw $errorMessage
        }

        # Copy only files from source to destination directory
        Get-ChildItem -Path $sourceDir -File | ForEach-Object {
            $sourceFilePath = $_.FullName
            $destinationFilePath = Join-Path -Path $destinationDir -ChildPath $_.Name

            Write-Log "Copying file [$($_)] to [$destinationDir]..."
            Copy-Item -Path $sourceFilePath -Destination $destinationFilePath -Force
        }
    }

    Write-Log "Installation complete!"
} catch {
    Write-Log "Script failed with the following exception: [$($_.Exception.Message)]"
    $Script:exitCode = 1
} finally {
    exit $Script:exitCode
}
