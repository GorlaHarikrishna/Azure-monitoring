param (
    [string]$ParameterFile = "C:\samples\AT\VMAlertsCitrix\VMAlert-Citrix-Par.json"
)

# Define the paths to your scripts
$ExternalScriptPath1 = "C:\samples\AT\VMAlertsCitrix\VMAlertsSingle-Citrix\Citrix - Disk-Data Disk IOPS Consumed Percentage.ps1"
$ExternalScriptPath2 = "C:\samples\AT\VMAlertsCitrix\VMAlertsSingle-Citrix\Citrix - Disk-OS Disk IOPS Consumed Percentage.ps1"
$ExternalScriptPath3 = "C:\samples\AT\VMAlertsCitrix\VMAlertsSingle-Citrix\Citrix - Disk-Percentiles Free Space.ps1"
$ExternalScriptPath5 = "C:\samples\AT\VMAlertsCitrix\VMAlertsSingle-Citrix\Citrix - Memory-Percentiles Committed Bytes In Use.ps1"
$ExternalScriptPath7 = "C:\samples\AT\VMAlertsCitrix\VMAlertsSingle-Citrix\Citrix - Network-In Total.ps1"
$ExternalScriptPath8 = "C:\samples\AT\VMAlertsCitrix\VMAlertsSingle-Citrix\Citrix - VM-Availability.ps1"
$ExternalScriptPath9 = "C:\samples\AT\VMAlertsCitrix\VMAlertsSingle-Citrix\Citrix - VM-CPUByPercentiles.ps1"
$ExternalScriptPath10 = "C:\samples\AT\VMAlertsCitrix\VMAlertsSingle-Citrix\Citrix - VM-SystemUpTime.ps1"

# Load parameters from the parameter file
$Parameters = Get-Content $ParameterFile | ConvertFrom-Json

# Define Variables
$Cntx = $Parameters.subscriptionId

# Set Context 
Set-AzContext -SubscriptionId "$Cntx"

# Call the external Virtual Machine - Availability with parameters
Write-Host "VMAlertsSingle-Citrix\Disk-Data Disk IOPS Consumed Percentage.ps1..."
& $ExternalScriptPath1 -ParameterFile "C:\samples\AT\VMAlertsCitrix\VMAlert-Citrix-Par.json"

# Call the external Disk - Data Disk IOPS Consumed Percentage with parameters
Write-Host "VMAlertsSingle-Citrix\Disk-OS Disk IOPS Consumed Percentage.ps1..."
& $ExternalScriptPath2 -ParameterFile "C:\samples\AT\VMAlertsCitrix\VMAlert-Citrix-Par.json"

# Call the external Disk - OS Disk IOPS Consumed Percentage with parameters
Write-Host "VMAlertsSingle-Citrix\Disk-Percentiles Free Space.ps1..."
& $ExternalScriptPath3 -ParameterFile "C:\samples\AT\VMAlertsCitrix\VMAlert-Citrix-Par.json"

# Call the external Disk - Virtual Machines by Free Space MB with parameters
Write-Host "VMAlertsSingle-Citrix\Memory-Percentiles Committed Bytes In Use.ps1..."
& $ExternalScriptPath5 -ParameterFile "C:\samples\AT\VMAlertsCitrix\VMAlert-Citrix-Par.json"

# Call the external Memory - Virtual Machines by AvailableMB with parameters
Write-Host "VMAlertsSingle-Citrix\Network-In Total.ps1..."
& $ExternalScriptPath7 -ParameterFile "C:\samples\AT\VMAlertsCitrix\VMAlert-Citrix-Par.json"

# Call the external Network - In Total with parameters
Write-Host "VMAlertsSingle-Citrix\VM-Availability.ps1..."
& $ExternalScriptPath8 -ParameterFile "C:\samples\AT\VMAlertsCitrix\VMAlert-Citrix-Par.json"

# Call the external Virtual Machine CPU by percentiles with parameters
Write-Host "VMAlertsSingle-Citrix\VM-CPUByPercentiles.ps1..."
& $ExternalScriptPath9 -ParameterFile "C:\samples\AT\VMAlertsCitrix\VMAlert-Citrix-Par.json"

# Call the external Virtual Machine System Up Time with parameters
Write-Host "VMAlertsSingle-Citrix\VM-SystemUpTime.ps1..."
& $ExternalScriptPath10 -ParameterFile "C:\samples\AT\VMAlertsCitrix\VMAlert-Citrix-Par.json"

Write-Host "Master Script for VM Alerts-Citrix Completed."