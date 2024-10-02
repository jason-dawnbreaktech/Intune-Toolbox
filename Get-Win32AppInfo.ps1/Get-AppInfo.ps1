
# Function to get installed application details from the registry
function Get-InstalledApplications {
    <#
    .SYNOPSIS
        Retrieves details of installed applications from the Windows registry.

    .DESCRIPTION
        This function accesses specific registry paths to collect information about installed applications on the system.
        It returns details such as DisplayName, UninstallString, InstallLocation, DisplayVersion, Publisher, Product Code, and Registry Path.

    .EXAMPLE
        $apps = Get-InstalledApplications

        Retrieves a list of installed applications and stores it in the variable $apps.

    .EXAMPLE
        Get-InstalledApplications | Where-Object { $_.Publisher -eq "Microsoft Corporation" }

        Retrieves installed applications published by Microsoft Corporation.

    .NOTES
        Author: JC ALAN
        https://github.com/jason-dawnbreaktech
        Date: 09/17/2024
    #>
    $paths = @(
        "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*",
        "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*"
    )

    $installedApps = foreach ($path in $paths) {
        Get-ItemProperty -Path $path -ErrorAction SilentlyContinue |
        Where-Object { $_.DisplayName -or $_.PSChildName } |
        Select-Object DisplayName, UninstallString, InstallLocation, DisplayVersion, Publisher, PSChildName, PSPath
    }
    return $installedApps
}

# Function to format and display application details
function Get-AppDetails {
    <#
    .SYNOPSIS
        Retrieves and displays detailed information about installed applications based on name or product code.

    .DESCRIPTION
        This function searches for installed applications by their Display Name or Product Code and displays detailed information such as:
        - Application Name
        - Uninstall String
        - Install Location
        - Display Version
        - Publisher
        - Product Code
        - Registry Path

    .PARAMETER AppIdentifier
        The name or product code of the application to search for.
        - If IdentifierType is "Name", provide part or all of the application's DisplayName.
        - If IdentifierType is "ProductCode", provide the exact product code (PSChildName) of the application.

    .PARAMETER IdentifierType
        Specifies whether the AppIdentifier is a "Name" (DisplayName) or "ProductCode" (PSChildName).
        Acceptable values are "Name" or "ProductCode".
        Default value is "Name".

    .EXAMPLE
        Get-AppDetails -AppIdentifier "Google Chrome"

        Retrieves and displays details for applications whose DisplayName includes "Google Chrome".

    .EXAMPLE
        Get-AppDetails -AppIdentifier "{4A03706F-666A-4037-7777-5F2748764D10}" -IdentifierType "ProductCode"

        Retrieves and displays details for the application with the specified product code.

    .EXAMPLE
        Get-AppDetails -AppIdentifier "Adobe" -IdentifierType "Name"

        Retrieves and displays details for applications whose DisplayName includes "Adobe".

    .NOTES
        Author: JC ALAN
        https://github.com/jason-dawnbreaktech
        Date: 09/17/2024
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, Position = 0)]
        [ValidateNotNullOrEmpty()]
        [string]$AppIdentifier,

        [Parameter(Mandatory = $false)]
        [ValidateSet("Name", "ProductCode")]
        [string]$IdentifierType = "Name"
    )

    if ($IdentifierType -eq "ProductCode") {
        $appDetails = Get-InstalledApplications | Where-Object { $_.PSChildName -eq $AppIdentifier }
    } else {
        $appDetails = Get-InstalledApplications | Where-Object { $_.DisplayName -like "*$AppIdentifier*" }
    }

    if ($appDetails) {
        foreach ($app in $appDetails) {
            $appName = $app.DisplayName
            $uninstallString = $app.UninstallString
            $installLocation = $app.InstallLocation
            $displayVersion = $app.DisplayVersion
            $publisher = $app.Publisher
            $productCode = $app.PSChildName
            $regPath = $app.PSPath

            Write-Host "Application Name: $appName"
            Write-Host "Uninstall String: $uninstallString"
            Write-Host "Install Location: $installLocation"
            Write-Host "Display Version: $displayVersion"
            Write-Host "Publisher: $publisher"
            Write-Host "Product Code: $productCode"
            Write-Host "Registry Path: $regPath"
            Write-Host "---------------------------------"
        }
    } else {
        Write-Host "No applications found matching the provided identifier."
    }
}

# Main script execution
$choice = Read-Host "Search by (1) Name or (2) Product Code? Enter 1 or 2"

if ($choice -eq '1') {
    $appName = Read-Host "Enter the application name to get details"
    Get-AppDetails -AppIdentifier $appName -IdentifierType "Name"
} elseif ($choice -eq '2') {
    $productCode = Read-Host "Enter the product code to get details"
    Get-AppDetails -AppIdentifier $productCode -IdentifierType "ProductCode"
} else {
    Write-Host "Invalid choice. Please run the script again and select either 1 or 2."
}

Pause
