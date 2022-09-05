<#
RegistryUpdatePCToKiosk.ps1

    Goal:
        The purpose of this script is to bring a computer out of PC mode and into kiosk mode.
        This will allow someone to use their utility machine without the annoyance of explorer.exe.

    Audience:
        People who want to be able to optimize front-end usage of Windows-based utility machines.

    Version:
        8/27/2022 - Original version
        9/2/2022 - Conversion from .bat/.reg to .ps1

    Return Codes:
        Success - 0
        Failure - 1

    References:
        Modifying registry via Powershell - https://devblogs.microsoft.com/powershell-community/how-to-update-or-add-a-registry-key-value-with-powershell/
        Microsoft documentation for New-ItemProperty - https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.management/new-itemproperty?view=powershell-7.2
#>

# Define good/bad exit codes
$SuccessExitCode = 0
$FailureExitCode = 1
$Host.UI.RawUI.WindowTitle = "Registry Update PC to Kiosk"

# Overarching Try block for execution
Try {
    Write-Output "Cabinet: Creating variables."
    $RegistryPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon"
    $Name = 'Shell'
	$Value = '"C:\pegasus\StartFrontendApps.exe"'
    
    Write-Output "Cabinet: Setting $($Name) to $($Value)..."
    New-ItemProperty -Path $RegistryPath -Name $Name -Value $Value -PropertyType String -Force
    Write-Output "Cabinet: Modified $($Name) to $($Value)."

    Write-Output "Cabinet: Restarting Computer now..."
    Restart-Computer
    Exit $SuccessExitCode
}

# Overarching Catch block for issues
Catch {
    Write-Output "Script failed with the following exception: $($_)"
    Exit $FailureExitCode
}