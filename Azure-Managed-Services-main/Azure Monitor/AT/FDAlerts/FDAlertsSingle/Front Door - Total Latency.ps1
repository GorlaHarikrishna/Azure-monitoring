param (
    [string]$ParameterFile = "C:\Path\To\Your\ParameterFile.json"
)

# Load parameters from the parameter file
$Parameters = Get-Content $ParameterFile | ConvertFrom-Json

# Define variables
$alertRuleNamePrefix = "Front Door - Total Latency - azm "
$Customer = $Parameters.ClNm

# Get all Front Door instances in the subscription
$FrontDoors = Get-AzFrontDoor | Where-Object { $_.Tags[$Parameters.tagKey] -eq $Parameters.tagValue }

# Loop through Front Door instances and create metric alert rules
foreach ($FrontDoor in $FrontDoors)
{
    $resourceId = $FrontDoor.ResourceId
    # Create the metric alert condition
    $condition = New-AzMetricAlertRuleV2Criteria -MetricName "TotalLatency" -TimeAggregation "Average" -Operator "GreaterThan" -Threshold 2500
    # Define alert rule name based on the Front Door name
    $alertRuleName = "$alertRuleNamePrefix$($FrontDoor.Name)"
    # Create the alert rule
    Add-AzMetricAlertRuleV2 -Name $alertRuleName -ResourceGroupName $Parameters.resourceGroupName -WindowSize 00:05:00 -Frequency 00:05:00 -TargetResourceId $resourceId -Condition $condition -ActionGroupId $Parameters.actionGroupId -Severity 3 -Description "Client Name: $Customer - Monitors total latency on $($FrontDoor.Name)"
}
