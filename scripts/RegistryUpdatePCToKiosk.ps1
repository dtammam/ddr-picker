<#
.SYNOPSIS
    Bring a computer out of PC mode into Kiosk mode.
.NOTES
    Replace shell to be a script that launches all utilities, as opposed to explorer.exe.
.LINK
    Modifying registry via Powershell - https://devblogs.microsoft.com/powershell-community/how-to-update-or-add-a-registry-key-value-with-powershell/
.LINK
    Microsoft documentation for New-ItemProperty - https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.management/new-itemproperty?view=powershell-7.2
#>

# Import core modules relevant for all scripts
[string]$coreFunctionsModule = "$PSScriptRoot\CoreFunctions.psm1"
Import-Module -Name $coreFunctionsModule -Force

# Variable declaration
$Host.UI.RawUI.WindowTitle = $scriptName

try {
    Open-Header

    Write-Log "Creating variables."
    $registryPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon"
    $name = 'Shell'
	$value = '"C:\pegasus\StartFrontendApps.exe"'
    
    Write-Log "Setting [$($name)] to [$($value)]..."
    New-ItemProperty -Path $registryPath -Name $name -Value $value -PropertyType String -Force
    Write-Log "Modified [$($name)] to [$($value)]."

    Write-Log "Restarting Computer now..."
    Restart-Computer
    $script:exitCode = 0
} catch {
    Write-Log "Script failed with the following exception: [$($_.Message)]"
    $script:exitCode = 1
} finally {
    exit $script:exitCode
}