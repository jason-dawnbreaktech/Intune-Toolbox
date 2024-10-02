## Get-Win32AppInfo.ps1

This script includes functions to search for and retrieve information about installed applications from the registry. These functions can be used to query general application info from the registry, or to pull specific values, such as the uninstall string. 

### How to use

You can use the `Get-Help` Cmdlet to get a description of how to use the function after it has been loaded. 

`Get-Help Get-InstalledApplications`

Call the script and you will be prompted to choose either `name` or `product code`. If you choose product code, enter the full GUID of the installed application. This necessitates that you know this value beforehand. Otherwise, choose name, and enter a term to match the name of the installed app. I.e. if you search 'adobe', it will return **any** value in the registry where the name includes adobe. 

## Creating a default PowerShell Profile

One of the best ways to take advantage of these functions is to create a default PowerShell profile that loads with your logon. Follow these instructions:

1. Open PowerShell.
2. Type:
``` PowerShell 
## First Check to see if you already have a profile:

Test-Path $profile

## If false create your profile

New-Item -Path $profile -Type File -Force
```
3. Open your profile file in an editor and add any scripts/functions you wanted loaded in a default PowerShell instance. Ensure you only add the functions once and in the correct order, as some functions reference others in the module. 
4. The next time you load PowerShell, these functions will be loaded into your instance by default. If you get an error regarding execution policy, run the following command:
``` PowerShell
Set-ExecutionPolicy RemoteSigned
```