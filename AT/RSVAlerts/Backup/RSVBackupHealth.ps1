param (
    [string]$ParameterFile = "C:\samples\AT\RSVAlerts\Backup\RSVBackupHealth.json"
)

# Load parameters from the parameter file
$Parameters = Get-Content $ParameterFile | ConvertFrom-Json

# Define variables
$alertRuleNamePrefix = "RSV - Backups Degraded - Health Events - azm "
$Customer = $Parameters.ClNm

# Get all RSVs in the subscription with a specific tag
$Vaults = Get-AzResource -Tag @{ $Parameters.tagKey = $Parameters.tagValue } -ResourceType "Microsoft.RecoveryServices/vaults"

foreach ($Vault in $Vaults){

    # Define alert dimensions 
    $dim1 = New-AzMetricAlertRuleV2DimensionSelection -DimensionName "healthStatus" -ValuesToInclude "PersistentDegraded","TransientDegraded"
    $dim2 = New-AzMetricAlertRuleV2DimensionSelection -DimensionName "backupInstanceName" -ValuesToInclude "*"
    
    # Define alert condition
    $condition = New-AzMetricAlertRuleV2Criteria -MetricName "BackupHealthEvent" -TimeAggregation "Count" -Operator "GreaterThan" -Threshold 0 -DimensionSelection $dim1,$dim2
    
    # Define alert rule name based on the RSV name
    $alertRuleName = "$alertRuleNamePrefix-$($Vault.Name)"
    
    # Create the alert rule
    Add-AzMetricAlertRuleV2 -Name $alertRuleName -ResourceGroupName $Parameters.resourceGroupName -WindowSize 01:00:00 -Frequency 01:00:00 -TargetResourceId $Vault.Id -Condition $condition -ActionGroupId $Parameters.actionGroupId -Severity 4 -Description "Client Name:$Customer-Overall health and status of backup operations in RSV $($Vault.Name)"
}
