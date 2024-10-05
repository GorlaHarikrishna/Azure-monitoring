param (
    [string]$ParameterFile = "C:\samples\AT\RSVAlerts\Replication\RSVReplicationHealth.json"
)

# Load parameters from the parameter file
$Parameters = Get-Content $ParameterFile | ConvertFrom-Json

# Define variables
$Customer = $Parameters.ClNm
$IntSubID = $Parameters.subscriptionId

# Get all RSVs in the subscription with a specific tag
$Vaults = Get-AzResource -Tag @{ $Parameters.tagKey = $Parameters.tagValue } -ResourceType "Microsoft.RecoveryServices/vaults"

 # Define alert dimensions 
 $dim1 = New-AzScheduledQueryRuleDimensionObject -Name "name_s" -Operator "Include" -Value "*"
 $dim2 = New-AzScheduledQueryRuleDimensionObject -Name "replicationHealth_s" -Operator "Include" -Value "*"
 $dim3 = New-AzScheduledQueryRuleDimensionObject -Name "replicationHealthErrors_s" -Operator "Include" -Value "*"
 $dim4 = New-AzScheduledQueryRuleDimensionObject -Name "Resource" -Operator "Include" -Value "*"

$condition = New-AzScheduledQueryRuleConditionObject 
    -Query "AzureDiagnostics | where TimeGenerated > ago(24h) | where replicationProviderName_s == 'A2A' | where isnotempty(name_s) and isnotnull(name_s) | summarize hint.strategy=partitioned arg_max(TimeGenerated, *) by name_s | where replicationHealth_s == 'Critical' | project name_s, replicationHealth_s, replicationHealthErrors_s, Resource" `
    -TimeAggregation "Count" `
    -Operator "GreaterThan" `
    -Threshold "0" `
    -FailingPeriodNumberOfEvaluationPeriod 1 `
    -FailingPeriodMinFailingPeriodsToAlert 1

# Loop Through Virtual Machines and Create Alert Rules
foreach ($Vault in $Vaults) {
    $VaultName = $Vault.Name
    $scope = "/subscriptions/$IntSubID/resourceGroups/$($Vault.ResourceGroupName)/providers/Microsoft.RecoveryServices/vaults/$VaultName"
    $alertRuleName = "RSV - Unhealthy Replication - azm -$VaultName"
    $description = "Client Name:$Customer-Measure the amount of available physical memory (RAM) in megabytes (MB) on a Windows system on VM $VaultName"
    
    New-AzScheduledQueryRule -Name $alertRuleName `
        -ResourceGroupName $Parameters.resourceGroupName `
        -Location $Parameters.location `
        -DisplayName $alertRuleName `
        -Description $description `
        -Scope $scope `
        -Severity 4 `
        -WindowSize ([System.TimeSpan]::FromMinutes(10)) `
        -EvaluationFrequency ([System.TimeSpan]::FromMinutes(5)) `
        -CriterionAllOf $condition
}