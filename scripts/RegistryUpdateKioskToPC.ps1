<#
.SYNOPSIS
    Bring a computer out of kiosk mode back to PC mode
.NOTES
    Replace shell to be explorer.exe as a standard PC shell.
.LINK
    Modifying registry via Powershell - https://devblogs.microsoft.com/powershell-community/how-to-update-or-add-a-registry-key-value-with-powershell/
.LINK
    Microsoft documentation for New-ItemProperty - https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.management/new-itemproperty?view=powershell-7.2
#>

# Import core modules relevant for all scripts
[string]$coreFunctionsModule = "$PSScriptRoot\CoreFunctions.psm1"
Import-Module -Name $coreFunctionsModule -Force

try {
    Open-Header

    Write-Log "Creating variables."
    $registryPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon"
    $name = 'Shell'
    $value = 'explorer.exe'
    
    Write-Log "Setting [$($name)] to [$($value)]..."
    New-ItemProperty -Path $registryPath -Name $name -Value $value -PropertyType String -Force
    Write-Log "Modified [$($name)] to [$($value)]."

    Write-Log "Restarting computer now..."
    Restart-Computer
    $Script:exitCode = 0
} catch {
    Write-Log "Script failed with the following exception: [$($_.Message)]"
    $Script:exitCode = 1
} finally {
    exit $Script:exitCode
}