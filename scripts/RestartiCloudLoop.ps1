<#
.SYNOPSIS
    Make iCloud Photo uploads consistent from a Windows machine.
.DESCRIPTION
    I'm not sure if you use an iPhone with iCloud for your cloud photo storage while also managing pictures from
    Windows computers... but if you have, you know it's not great. If you've struggled like me (seeing it behave
    inconsistently, not working at times), then this script might help you. It creates a neverending loop which:
        - Stops iCloud Services 
        - Stops iCloud Photos
        - Starts iCloud Services
        - Starts iCloud Photos
        - Waits 5 minutes
        - Goes to your Uploads and deletes everything inside
        - Restarts the loop

    The reason why is because the only way I found iCloud on Windows to work consistently was to restart it
    very regularly. The 5 minute delay is to give your device time to receive photos and actually upload them. 
    If you find photos on your phone that you'd rather delete... they'll come back if still in the uploads folder 
    after a service restart - which is why this deletes them from 'Uploads' each go around.

    My use-case was for a Dance Dance Revolution machine with a button to take a photo and save into Uploads. 
    I figure this could be useful for similar utility machine use-cases or even just general better behavior for 
    photographers or others who need Windows and iCloud for a workflow.
.NOTES
    8/27/2022 - Original version
    9/2/2022 - Conversion from .bat to .ps1
    5/16/2024 - Standardizing formatting in alignment with PowerShell best practices

    One person referencing the issue: https://www.reddit.com/r/iCloud/comments/lptouf/icloud_photos_for_windows/
#>
try {
    # Variable declaration
    [int]$exitCode = -1
    [bool]$loop = $True
    [string]$Host.Ui.RawUI.WindowTitle = "Restart iCloud Loop"
    [string]$applePath = "C:\Program Files (x86)\Common Files\Apple\Internet Services\"
    [string]$iCloudServices = "iCloudServices"
    [string]$iCloudPhotos = "iCloudPhotos"
    [string]$photoUploadPath = "C:\Users\me\Pictures\Uploads\"
    [string]$photos = (Get-ChildItem $photoUploadPath -Recurse).FullName
    [int]$deletedCount = 0

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
        foreach ($photo in $photos) {
            Remove-Item -Path $photo
            Write-Output "iCloud Fix: Successfully deleted [$($photo)] in [$($photoUploadPath)]."
            $deletedCount += 1
            Write-Output "iCloud Fix: Successfully deleted [$($deletedCount)] photos."
            continue
        }

        # Restart the loop
        Start-Sleep -Seconds 2
        Write-Output "iCloud Fix: Restarting the loop..."
        [int]$deletedCount = 0
    }
    $exitCode = 0
} catch {
    Write-Output "Script failed with the following exception: [$($_)]"
    $exitCode = 1
} finally {
    Write-Output "Script completed successfully. Exiting..."
    exit $exitCode
}