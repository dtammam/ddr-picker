<#
.SYNOPSIS
    Make iCloud Photo uploads consistent from a Windows machine.
.NOTES
    The only way I found iCloud on Windows to work consistently was to restart it very regularly. 
    The 5 minute delay is to give your device time to receive photos and actually upload them. 
.LINK
    One person referencing the issue: https://www.reddit.com/r/iCloud/comments/lptouf/icloud_photos_for_windows/
#>

# Import core modules relevant for all scripts
[string]$coreFunctionsModule = "$PSScriptRoot\CoreFunctions.psm1"
Import-Module -Name $coreFunctionsModule -Force

# Variable declaration
$Host.UI.RawUI.WindowTitle = $scriptName

# Variable declaration
[bool]$loop = $True
[string]$applePath = "C:\Program Files (x86)\Common Files\Apple\Internet Services\"
[string]$iCloudServices = "iCloudServices"
[string]$iCloudPhotos = "iCloudPhotos"
[string]$photoUploadPath = "C:\Users\me\Pictures\Uploads\"
[int]$deletedCount = 0

try {
    Open-Header

    # A neverending While loop with our arbitrary variable to make this script run indefinitely
    while ($loop -eq $True) {
        Write-Output "iCloud Fix: Loop started."
        
        # Close iCloud Services
        Start-Sleep -Seconds 2
        Write-Output "iCloud Fix: Stopping [$($iCloudServices)]..."
        Start-Sleep -Seconds 2
        if (-not (Get-Process "$iCloudServices" -ErrorAction SilentlyContinue)) {
            Write-Output "iCloud Fix: [$($iCloudServices)] not running. Continuing..."
        } else {
            Stop-Process -Name $iCloudServices -Force -ErrorAction SilentlyContinue
            Write-Output "iCloud Fix: Stopped [$($iCloudServices)]..."
        }
        
        # Close iCloud Photos
        Start-Sleep -Seconds 2
        Write-Output "iCloud Fix: Stopping [$($iCloudPhotos)]..."
        Start-Sleep -Seconds 2
        if (-not (Get-Process "$iCloudPhotos" -ErrorAction SilentlyContinue)) {
            Write-Output "iCloud Fix: [$($iCloudPhotos)] not running. Continuing..."
        } else {
            Stop-Process -Name $iCloudPhotos -Force -ErrorAction SilentlyContinue
            Write-Output "iCloud Fix: Stopped [$($iCloudPhotos)]..."
        }
        
        # Start iCloud Services
        Start-Sleep -Seconds 2
        Write-Output "iCloud Fix: Starting [$($iCloudServices)]..."
        Start-Sleep -Seconds 2
        Start-Process $applePath\"$iCloudServices.exe"
        Write-Output "iCloud Fix: Started [$($iCloudServices)] successfully."

        # Start iCloud Photos
        Start-Sleep -Seconds 2
        Write-Output "iCloud Fix: Starting [$($iCloudPhotos)]..."
        Start-Sleep -Seconds 2
        Start-Process $applePath\"$iCloudPhotos.exe"
        Write-Output "iCloud Fix: Started [$($iCloudPhotos)] successfully."

        # Wait to give time for photos to be taken/uploaded, set variables for Uploads directory
        Start-Sleep -Seconds 2
        Write-Output "iCloud Fix: Waiting 5 minutes to delete photos and restart the loop."
        Start-Sleep -Seconds 300

        # Recurse through the Uploads directory and delete all items in it
        $photos = (Get-ChildItem $photoUploadPath -Recurse).FullName
        foreach ($photo in $photos) {
            Remove-Item -Path $photo
            Write-Output "iCloud Fix: Successfully deleted [$($photo)] in [$($photoUploadPath)]."
            $deletedCount += 1
            Write-Output "iCloud Fix: Successfully deleted [$($deletedCount)] photos."
        }

        # Restart the loop
        Start-Sleep -Seconds 2
        Write-Output "iCloud Fix: Restarting the loop..."
        [int]$deletedCount = 0
    }
    $exitCode = 0
} catch {
    Write-Output "Script failed with the following exception: [$($_.Message)]"
    $exitCode = 1
} finally {
    Write-Output "Script completed successfully. Exiting..."
    exit $exitCode
}