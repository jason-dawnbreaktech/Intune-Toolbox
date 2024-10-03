# Make sure you've already imported the Get-Win32AppInfo.ps1 script before running this example script.
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