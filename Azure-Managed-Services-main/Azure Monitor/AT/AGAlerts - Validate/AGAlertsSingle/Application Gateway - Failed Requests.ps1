param (
    [string]$ParameterFile = "C:\\Path\\To\\Your\\ParameterFile.json"
)

# Load parameters from the parameter file
$Parameters = Get-Content $ParameterFile | ConvertFrom-Json

# Define variables
$alertRuleNamePrefix = "Application Gateway - Failed Requests - azm "
$Customer = $Parameters.ClNm

# Get all Application Gateways in the subscription
$AppGateways = Get-AzApplicationGateway | Where-Object { $_.Tags[$Parameters.tagKey] -eq $Parameters.tagValue }

# Loop through Application Gateways and create metric alert rules
foreach ($AppGateway in $AppGateways)
{
    $resourceId = $AppGateway.Id
    # Create the metric alert condition
    $condition = New-AzMetricAlertRuleV2Criteria -MetricName "FailedRequests" -TimeAggregation "Total" -Operator "GreaterThan" -Threshold 100
    # Define alert rule name based on the Application Gateway name
    $alertRuleName = "$alertRuleNamePrefix$($AppGateway.Name)"
    # Create the alert rule
    Add-AzMetricAlertRuleV2 -Name $alertRuleName -ResourceGroupName $Parameters.resourceGroupName -WindowSize '00:05:00' -Frequency '00:01:00' -TargetResourceId $resourceId -Condition $condition -ActionGroupId $Parameters.actionGroupId -Severity 3 -Description "Client Name: $Customer - Monitors failed requests on $($AppGateway.Name)"
}
