param (
    [string]$ParameterFile = "C:\samples\AT\RAlerts\RAlert-Par.json"
)

# Define the paths to your scripts
$RExternalScriptPath1 = "C:\samples\AT\RAlerts\RAlertsSingle\Cache for Redis - CPU.ps1"
$RExternalScriptPath2 = "C:\samples\AT\RAlerts\RAlertsSingle\Cache for Redis - EvictedKeys.ps1"
$RExternalScriptPath3 = "C:\samples\AT\RAlerts\RAlertsSingle\Cache for Redis - ServerLoad.ps1"

# Load parameters from the parameter file
$Parameters = Get-Content $ParameterFile | ConvertFrom-Json

# Define Variables
$Cntx = $Parameters.subscriptionId

# Set Context 
Set-AzContext -SubscriptionId "$Cntx"

# Call the external Cache for Redis - CPU with parameters
Write-Host "KVAlertsSingle\Cache for Redis - CPU.ps1..."
& $RExternalScriptPath1 -ParameterFile "C:\samples\AT\RAlerts\RAlert-Par.json"

# Call the external Cache for Redis - EvictedKeys with parameters
Write-Host "KVAlertsSingle\Cache for Redis - EvictedKeys.ps1..."
& $RExternalScriptPath2 -ParameterFile "C:\samples\AT\RAlerts\RAlert-Par.json"

# Call the external Cache for Redis - ServerLoad with parameters
Write-Host "KVAlertsSingle\Cache for Redis - ServerLoad.ps1..."
& $RExternalScriptPath3 -ParameterFile "C:\samples\AT\RAlerts\RAlert-Par.json"

Write-Host "Master Script for R Alerts Completed."