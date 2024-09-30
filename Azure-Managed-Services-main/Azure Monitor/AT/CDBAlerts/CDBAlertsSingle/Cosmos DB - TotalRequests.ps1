param (
    [string]$ParameterFile = "C:\samples\AT\CDBAlerts\CDBAlert-Par.json"
)

# Load parameters from the parameter file
$Parameters = Get-Content $ParameterFile | ConvertFrom-Json

# Define variables
$alertRuleNamePrefix = "Cosmos DB - TotalRequests - azm "
$Customer = $Parameters.ClNm

# Get all Cosmos DB accounts in the subscription by Tag
$cosmosDBAccounts = Get-AzCosmosDBAccount | Where-Object { $_.Tags[$Parameters.tagKey] -eq $Parameters.tagValue }

foreach ($cosmosDBAccount in $cosmosDBAccounts)
{
    # Create the metric alert condition for Available Storage
    $condition = New-AzMetricAlertRuleV2Criteria -MetricName "TotalRequests" -TimeAggregation "count" -Operator "GreaterThan" -Threshold 200
    
    # Define alert rule name based on the Cosmos DB account name
    $alertRuleName = "$alertRuleNamePrefix-$($cosmosDBAccount.Name)"

    # Create the alert rule
    Add-AzMetricAlertRuleV2 -Name $alertRuleName -ResourceGroupName $Parameters.resourceGroupName -WindowSize 00:05:00 -Frequency 00:05:00 -TargetResourceId $cosmosDBAccount.Id -Condition $condition -ActionGroupId $Parameters.actionGroupId -Severity 4 -Description "Client Name:$Customer-Refers to the total number of requests made to your Azure Cosmos DB account over a specific time period on $($cosmosDBAccount.Name)"
}
