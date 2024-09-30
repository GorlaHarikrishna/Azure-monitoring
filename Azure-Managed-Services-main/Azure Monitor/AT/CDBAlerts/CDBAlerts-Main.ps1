param (
    [string]$ParameterFile = "C:\samples\AT\CDBAlerts\CDBAlert-Par.json"
)

# Define the paths to your scripts
$CDBExternalScriptPath1 = "C:\samples\AT\CDBAlerts\CDBAlertsSingle\Cosmos DB - AvailableStorage.ps1"
$CDBExternalScriptPath2 = "C:\samples\AT\CDBAlerts\CDBAlertsSingle\Cosmos DB - TotalRequests.ps1"

# Load parameters from the parameter file
$Parameters = Get-Content $ParameterFile | ConvertFrom-Json

# Define Variables
$Cntx = $Parameters.subscriptionId

# Set Context 
Set-AzContext -SubscriptionId "$Cntx"

# Call the external Cosmos DB - AvailableStorage with parameters
Write-Host "CDBAlertsSingle\Cosmos DB - AvailableStorage.ps1..."
& $CDBExternalScriptPath1 -ParameterFile "C:\samples\AT\CDBAlerts\CDBAlert-Par.json"

# Call the external Cosmos DB - TotalRequests with parameters
Write-Host "CDBAlertsSingle\Cosmos DB - TotalRequests.ps1..."
& $CDBExternalScriptPath2 -ParameterFile "C:\samples\AT\CDBAlerts\CDBAlert-Par.json"

Write-Host "Master Script for CDB Alerts Completed."